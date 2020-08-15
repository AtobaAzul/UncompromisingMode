require("stategraphs/commonstates")

local actionhandlers =
{
    ActionHandler(ACTIONS.GOHOME, "action"),
}

local events =
{
    EventHandler("attacked", function(inst)
        if not (inst.sg:HasStateTag("attack") or inst.sg:HasStateTag("hit") or inst.sg:HasStateTag("noattack") or inst.components.health:IsDead()) then
            inst.sg:GoToState("hit")
        end
    end),
    EventHandler("death", function(inst) inst.sg:GoToState("death") end),
    EventHandler("doattack", function(inst, data)
        if not (inst.sg:HasStateTag("busy") or inst.components.health:IsDead()) then
            inst.sg:GoToState("attack", data.target)
        end
    end),
    CommonHandlers.OnLocomote(false, true),
}

local function FinishExtendedSound(inst, soundid)
    inst.SoundEmitter:KillSound("sound_"..tostring(soundid))
    inst.sg.mem.soundcache[soundid] = nil
    if inst.sg.statemem.readytoremove and next(inst.sg.mem.soundcache) == nil then
        inst:Remove()
    end
end

local function PlayExtendedSound(inst, soundname)
    if inst.sg.mem.soundcache == nil then
        inst.sg.mem.soundcache = {}
        inst.sg.mem.soundid = 0
    else
        inst.sg.mem.soundid = inst.sg.mem.soundid + 1
    end
    inst.sg.mem.soundcache[inst.sg.mem.soundid] = true
    inst.SoundEmitter:PlaySound(inst.sounds[soundname], "sound_"..tostring(inst.sg.mem.soundid))
    inst:DoTaskInTime(5, FinishExtendedSound, inst.sg.mem.soundid)
end

local function OnAnimOverRemoveAfterSounds(inst)
    if inst.sg.mem.soundcache == nil or next(inst.sg.mem.soundcache) == nil then
        inst:Remove()
    else
        inst:Hide()
        inst.sg.statemem.readytoremove = true
    end
end

local function SpikeAoE(inst)
    local target = inst.components.combat.target
    local target_index = {}
    local found_targets = {}
    local ix, iy, iz = inst.Transform:GetWorldPosition()
    local spike_num = 4
    local ring_num = 6
    local rad = math.random(0, 2*math.pi)
    inst.SoundEmitter:PlaySound("dontstarve/common/shadowTentacleAttack_1")
    inst.SoundEmitter:PlaySound("dontstarve/common/shadowTentacleAttack_2")

    local fx1 = SpawnPrefab("uncompromising_shadow_projectile1_fx")
    fx1.Transform:SetPosition(ix, iy, iz)
    inst:DoTaskInTime(1.2, function()
        inst.SoundEmitter:PlaySound("dontstarve/sanity/creature2/attack")
        local ents = TheSim:FindEntities(ix, iy, iz, 1.2, nil, { "FX", "NOCLICK", "INLIMBO", "shadowdominant" })
        for k,v in ipairs(ents) do
            if not target_index[v] and v ~= inst and inst.components.combat:IsValidTarget(v) and v.components.combat and ((v.components.sanity and v.components.sanity:IsInsane()) or v == target) then
                target_index[v] = true
                v.components.combat:GetAttacked(inst, TUNING.DSTU.DREADEYE_DAMAGE * 0.8)
            end
        end
    end)

    for i = 2,ring_num do -- ring
        inst:DoTaskInTime(FRAMES * i * 3, function()
            for j = 1,spike_num do -- spike
                local rad2 = rad + (math.pi * 2 * (j / spike_num))
                local velx = math.cos(rad2)
                local velz = -math.sin(rad2)
                local dx, dy, dz = ix + (i * velx), 0, iz + (i * velz)
                local fx1 = SpawnPrefab("uncompromising_shadow_projectile1_fx")
                fx1.Transform:SetPosition(dx, dy, dz)
                inst:DoTaskInTime(1.2, function()
                    inst.SoundEmitter:PlaySound("dontstarve/sanity/creature2/attack")
                    local ents = TheSim:FindEntities(dx, dy, dz, 1.2, nil, { "FX", "NOCLICK", "INLIMBO" })
                    for k,v in ipairs(ents) do
                        if not target_index[v] and v ~= inst and inst.components.combat:IsValidTarget(v) and v.components.combat and ((v.components.sanity and v.components.sanity:IsInsane()) or v == target) then
                            target_index[v] = true
                            v.components.combat:GetAttacked(inst, TUNING.DSTU.DREADEYE_DAMAGE * 0.8)
                        end
                    end
                end)
            end
            rad = rad + ((2*math.pi)/12)
        end)
    end
end

local function fading(inst, alpha)
    inst.AnimState:OverrideMultColour(alpha, alpha, alpha, alpha)
end

local states =
{
    State{
        name = "idle",
        tags = { "idle", "canrotate" },

        onenter = function(inst)
            if inst.wantstodespawn then
                local t = GetTime()
                if t > inst.components.combat:GetLastAttackedTime() + 5 then
                    local target = inst.components.combat.target
                    if target == nil or
                        target.components.combat == nil or
                        not target.components.combat:IsRecentTarget(inst) or
                        t > target.components.combat.laststartattacktime + 5 then
                        inst.sg:GoToState("disappear")
                        return
                    end
                end
            end

            inst.components.locomotor:StopMoving()
            if not inst.AnimState:IsCurrentAnimation("idle_loop") then
                inst.AnimState:PlayAnimation("idle_loop", true)
            end
        end,
    },

    State{
        name = "disguise",
        tags = { "disguise", "busy", "disguised" }, -- , "busy" 

        onenter = function(inst)
            inst.AnimState:PlayAnimation("idonotexist")
            inst.components.locomotor:StopMoving()
            inst.Physics:Stop()
			inst:Disguise()
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("disguise") end)
        },
    },

    State{
        name = "disguise_teleport",
        tags = { "busy" },

        onenter = function(inst)
            inst.Physics:Stop()
            PlayExtendedSound(inst, "appear")
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end)
        },
    },

    State{
        name = "disguise_attack",
        tags = { "attack", "disguise", "busy" }, -- , "busy" 

        onenter = function(inst)
			
			inst:RemoveTag("NOCLICK")
            inst.Physics:Stop()
            inst.components.combat:StartAttack()
            inst.AnimState:PlayAnimation("atk_pre")
            inst.AnimState:PushAnimation("atk", false)
            inst.sg:GoToState("taunt")
			fading(inst, 0.40)
            inst:DoTaskInTime(0.25, function() SpikeAoE(inst) end)
            inst.atkcount = 3
            PlayExtendedSound(inst, "attack_grunt")
        end,
		
        events =
        {
            EventHandler("animqueueover", function(inst)
                if math.random() < 0.333 then
                    inst.components.combat:SetTarget(nil)
                    inst.sg:GoToState("taunt")
                else
                    inst.sg:GoToState("idle")
                end
            end),
        },
    },

    State{
        name = "attack",
        tags = { "attack", "busy" },

        onenter = function(inst, target)
            inst.sg.statemem.target = target
            inst.Physics:Stop()
            inst.components.combat:StartAttack()
            inst.AnimState:PlayAnimation("atk_pre")
            inst.AnimState:PushAnimation("atk", false)
            inst.atkcount = inst.atkcount - 1
            if inst.atkcount <= 0 then
                inst.sg:GoToState("taunt")
                inst:DoTaskInTime(0.25, function() SpikeAoE(inst) end)
                inst.atkcount = 3
            end 
            PlayExtendedSound(inst, "attack_grunt")
        end,

        timeline =
        {
            TimeEvent(14*FRAMES, function(inst) PlayExtendedSound(inst, "attack") end),
            TimeEvent(16*FRAMES, function(inst) inst.components.combat:DoAttack(inst.sg.statemem.target) end),
            --inst.Physics:SetMotorVel(0, 0, 0)
            --TimeEvent(4*FRAMES, function(inst) inst.Physics:SetMotorVel(6, 0, 0) end), --9
        },

        events =
        {
            EventHandler("animqueueover", function(inst)
                if math.random() < 0.333 then
                    inst.components.combat:SetTarget(nil)
                    inst.sg:GoToState("taunt")
                else
                    inst.sg:GoToState("idle")
                end
            end),
        },
    },

    State{
        name = "hit",
        tags = { "busy", "hit" }, -- , "fading" 

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("disappear")
        end,

        timeline =
        {
            TimeEvent(1*FRAMES, function(inst) fading(inst, 0.36) end),
            TimeEvent(3*FRAMES, function(inst) fading(inst, 0.32) end),
            TimeEvent(5*FRAMES, function(inst) fading(inst, 0.28) end),
            TimeEvent(7*FRAMES, function(inst) fading(inst, 0.24) end),
            TimeEvent(9*FRAMES, function(inst) fading(inst, 0.20) end),
            TimeEvent(11*FRAMES, function(inst) fading(inst, 0.16) end),
            TimeEvent(13*FRAMES, function(inst) fading(inst, 0.12) end),
            TimeEvent(15*FRAMES, function(inst) fading(inst, 0.08) end),
            TimeEvent(17*FRAMES, function(inst) fading(inst, 0.04) end),
            TimeEvent(19*FRAMES, function(inst) fading(inst, 0.00) end),
        },

        events =
        {
            EventHandler("animover", function(inst)
                local max_tries = 4
                for k = 1, max_tries do
                    local x, y, z = inst.Transform:GetWorldPosition()
                    local offset = 15
                    x = x + math.random(2 * offset) - offset
                    z = z + math.random(2 * offset) - offset
                    if TheWorld.Map:IsPassableAtPoint(x, y, z) then
                        inst.Physics:Teleport(x, y, z)
                        break
                    end
                end

				if math.random() <= 0.33 then
					inst.sg:GoToState("disguise")
				else
					inst.sg:GoToState("appear")
				end
            end),
        },
    },

    State{
        name = "taunt",
        tags = { "busy" },

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("taunt")
            PlayExtendedSound(inst, "taunt")
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State{
        name = "appear",
        tags = { "busy" },

        onenter = function(inst)
            inst.AnimState:PlayAnimation("appear")
            inst.Physics:Stop()
            PlayExtendedSound(inst, "appear")
        end,

        timeline =
        {
            TimeEvent(1*FRAMES, function(inst) fading(inst, 0.00) end),
            TimeEvent(3*FRAMES, function(inst) fading(inst, 0.04) end),
            TimeEvent(5*FRAMES, function(inst) fading(inst, 0.08) end),
            TimeEvent(7*FRAMES, function(inst) fading(inst, 0.12) end),
            TimeEvent(9*FRAMES, function(inst) fading(inst, 0.16) end),
            TimeEvent(11*FRAMES, function(inst) fading(inst, 0.20) end),
            TimeEvent(13*FRAMES, function(inst) fading(inst, 0.24) end),
            TimeEvent(15*FRAMES, function(inst) fading(inst, 0.28) end),
            TimeEvent(17*FRAMES, function(inst) fading(inst, 0.32) end),
            TimeEvent(19*FRAMES, function(inst) fading(inst, 0.36) end),
        },

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end)
        },
    },

    State{
        name = "death",
        tags = { "busy" },

        onenter = function(inst)
            PlayExtendedSound(inst, "death")
            inst.AnimState:PlayAnimation("disappear")
            inst.Physics:Stop()
            RemovePhysicsColliders(inst)
            inst.components.lootdropper:DropLoot(inst:GetPosition())
            inst:AddTag("NOCLICK")
            inst.persists = false
        end,

        timeline =
        {
            TimeEvent(1*FRAMES, function(inst) fading(inst, 0.36) end),
            TimeEvent(3*FRAMES, function(inst) fading(inst, 0.32) end),
            TimeEvent(5*FRAMES, function(inst) fading(inst, 0.28) end),
            TimeEvent(7*FRAMES, function(inst) fading(inst, 0.24) end),
            TimeEvent(9*FRAMES, function(inst) fading(inst, 0.20) end),
            TimeEvent(11*FRAMES, function(inst) fading(inst, 0.16) end),
            TimeEvent(13*FRAMES, function(inst) fading(inst, 0.12) end),
            TimeEvent(15*FRAMES, function(inst) fading(inst, 0.08) end),
            TimeEvent(17*FRAMES, function(inst) fading(inst, 0.04) end),
            TimeEvent(19*FRAMES, function(inst) fading(inst, 0.00) end),
        },

        events =
        {
            EventHandler("animover", OnAnimOverRemoveAfterSounds),
        },

        onexit = function(inst)
            inst:RemoveTag("NOCLICK")
        end
    },

    State{
        name = "disappear",
        tags = { "busy", "noattack" },

        onenter = function(inst)
            PlayExtendedSound(inst, "death")
            inst.AnimState:PlayAnimation("disappear")
            inst.Physics:Stop()
            inst:AddTag("NOCLICK")
            inst.persists = false
        end,

        timeline =
        {
            TimeEvent(1*FRAMES, function(inst) fading(inst, 0.36) end),
            TimeEvent(3*FRAMES, function(inst) fading(inst, 0.32) end),
            TimeEvent(5*FRAMES, function(inst) fading(inst, 0.28) end),
            TimeEvent(7*FRAMES, function(inst) fading(inst, 0.24) end),
            TimeEvent(9*FRAMES, function(inst) fading(inst, 0.20) end),
            TimeEvent(11*FRAMES, function(inst) fading(inst, 0.16) end),
            TimeEvent(13*FRAMES, function(inst) fading(inst, 0.12) end),
            TimeEvent(15*FRAMES, function(inst) fading(inst, 0.08) end),
            TimeEvent(17*FRAMES, function(inst) fading(inst, 0.04) end),
            TimeEvent(19*FRAMES, function(inst) fading(inst, 0.00) end),
        },

        events =
        {
            EventHandler("animover", OnAnimOverRemoveAfterSounds),
        },

        onexit = function(inst)
            inst:RemoveTag("NOCLICK")
        end,
    },

    State{ 
        name = "teleport_disapper",
        tags = { "busy", "noattack" },
    
        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("disappear")
        end,

        timeline =
        {
            TimeEvent(1*FRAMES, function(inst) fading(inst, 0.36) end),
            TimeEvent(3*FRAMES, function(inst) fading(inst, 0.32) end),
            TimeEvent(5*FRAMES, function(inst) fading(inst, 0.28) end),
            TimeEvent(7*FRAMES, function(inst) fading(inst, 0.24) end),
            TimeEvent(9*FRAMES, function(inst) fading(inst, 0.20) end),
            TimeEvent(11*FRAMES, function(inst) fading(inst, 0.16) end),
            TimeEvent(13*FRAMES, function(inst) fading(inst, 0.12) end),
            TimeEvent(15*FRAMES, function(inst) fading(inst, 0.08) end),
            TimeEvent(17*FRAMES, function(inst) fading(inst, 0.04) end),
            TimeEvent(19*FRAMES, function(inst) fading(inst, 0.00) end),
        },
    
        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("appear") end),
        },
    },

    State{
        name = "action",
        onenter = function(inst, playanim)
            inst.Physics:Stop()
            inst:PerformBufferedAction()
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },
}
CommonStates.AddWalkStates(states)

return StateGraph("dreadeye", states, events, "appear", actionhandlers)