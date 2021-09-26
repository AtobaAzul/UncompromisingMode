require("stategraphs/commonstates")

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

local states =
{
    State{
        name = "idle",
        tags = { "idle", "canrotate" },

        onenter = function(inst)

            inst.components.locomotor:StopMoving()
            if not inst.AnimState:IsCurrentAnimation("idle") then
                inst.AnimState:PlayAnimation("idle", true)
            end
        end,
    },

    State{
        name = "attack",
        tags = { "attack", "busy" },

        onenter = function(inst, target)
            inst.sg.statemem.target = target
            inst.Physics:Stop()
            inst.components.combat:StartAttack()
            inst.AnimState:PlayAnimation("atk")
            PlayExtendedSound(inst, "attack_grunt")
			inst.components.combat:DoAttack(inst.sg.statemem.target)
        end,

        timeline =
        {
            TimeEvent(3*FRAMES, function(inst) PlayExtendedSound(inst, "attack") end),
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
			--[[TimeEvent(1*FRAMES, function(inst) fading(inst, 0.36) end),
            TimeEvent(3*FRAMES, function(inst) fading(inst, 0.32) end),
            TimeEvent(5*FRAMES, function(inst) fading(inst, 0.28) end),
            TimeEvent(7*FRAMES, function(inst) fading(inst, 0.24) end),
            TimeEvent(9*FRAMES, function(inst) fading(inst, 0.20) end),
            TimeEvent(11*FRAMES, function(inst) fading(inst, 0.16) end),
            TimeEvent(13*FRAMES, function(inst) fading(inst, 0.12) end),
            TimeEvent(15*FRAMES, function(inst) fading(inst, 0.08) end),
            TimeEvent(17*FRAMES, function(inst) fading(inst, 0.04) end),
            TimeEvent(19*FRAMES, function(inst) fading(inst, 0.00) end),]]
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

				inst.sg:GoToState("appear")
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

return StateGraph("nervoustick", states, events, "idle")