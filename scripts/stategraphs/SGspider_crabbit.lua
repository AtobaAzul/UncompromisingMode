    require("stategraphs/commonstates")

local actionhandlers =
{
    ActionHandler(ACTIONS.GOHOME, "action"),
}

local function canteleport(inst)
    return not (inst.sg:HasStateTag("attack") or inst.sg:HasStateTag("hit")
        or inst.sg:HasStateTag("teleporting") or inst.sg:HasStateTag("noattack")
        or inst.components.health:IsDead())
end

local function canattack(inst)
    return not (inst.sg:HasStateTag("busy") or inst.components.health:IsDead())
end

local events =
{
   --[[ EventHandler("boatteleport", function(inst, data)
        if canteleport(inst) then
            inst.sg:GoToState("boatteleport", data ~= nil and data.force_random_angle_on_boat or nil)
        end
    end),]]
    EventHandler("death", function(inst) inst.sg:GoToState("death") end),
    --[[EventHandler("doattack", function(inst, data)
        if canattack(inst) then
            inst.sg:GoToState("attack")
        end
    end),]]


    EventHandler("locomote", function(inst) 
        if not inst.sg:HasStateTag("busy") then  
            local wants_to_move = inst.components.locomotor:WantsToMoveForward()
            if not inst.sg:HasStateTag("attack") then
                if wants_to_move then
                    inst.sg:GoToState("move")
                else
                    inst.sg:GoToState("idle")
                end
            end
		end
    end), 
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

local function SetRippleScale(inst, scale)
    scale = math.max(0.01, scale) -- hack to avoid mouse always detected as hovering this creature when holding ocean-targeting equipment (oars, etc)
    inst._ripples.Transform:SetScale(scale, scale, scale)
end

local TELEPORT_ANGLE_VARIANCE = PI/4
local IN_OCEAN_TELEPORT_RADIUS = 6

local states =
{
    State{
        name = "idle",
        tags = { "idle", "canrotate" },

        onenter = function(inst)
			inst.AnimState:PlayAnimation("idle",true)
        end,
    },
    State{
        name = "move",
        tags = {"moving", "canrotate"},
        
        onenter = function(inst)
			inst.AnimState:PlayAnimation("walk")
			inst.components.locomotor:WalkForward()
        end,
        
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("move") end),
        },
        
    },   
    State{ --Update This Later
        name = "attack",
        tags = { "attack", "busy" },

        onenter = function(inst, target)
            inst.sg.statemem.target = target
            inst.Physics:Stop()
            inst.components.combat:StartAttack()
            inst.AnimState:PlayAnimation("atk_pre")
            inst.AnimState:PushAnimation("atk", false)
            PlayExtendedSound(inst, "attack_grunt")
        end,

        timeline =
        {
            TimeEvent(14*FRAMES, function(inst) PlayExtendedSound(inst, "attack") end),
            TimeEvent(17*FRAMES, function(inst) inst.components.combat:DoAttack(inst.sg.statemem.target) end),
        },

        events =
        {
            EventHandler("animqueueover", function(inst)
                if math.random() < .333 then
                    inst.sg:GoToState("taunt")
                else
                    inst.sg:GoToState("idle")
                end
            end),
        },
    },

    State{ --Update this later
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

    State{ --Update this later
        name = "appear",
        tags = { "busy", "teleporting", "appearing" },

        onenter = function(inst)
            inst.AnimState:PlayAnimation("appear")
            inst.Physics:Stop()
            PlayExtendedSound(inst, "appear")

            SetRippleScale(inst, 0)
        end,

        onupdate = function(inst)
            SetRippleScale(inst, math.clamp((inst.AnimState:GetCurrentAnimationTime() / inst.AnimState:GetCurrentAnimationLength()) * 2, 0, 1))
        end,

        onexit = function(inst)
            SetRippleScale(inst, 1)
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end)
        },
    },

    State{ --Update this later
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

        events =
        {
            EventHandler("animover", OnAnimOverRemoveAfterSounds),
        },

        onexit = function(inst)
            inst:RemoveTag("NOCLICK")
        end
    },

    State{ --Update this later?
        name = "disappear",
        tags = { "busy", "noattack" },

        onenter = function(inst)
            PlayExtendedSound(inst, "death")
            inst.AnimState:PlayAnimation("disappear")
            inst.Physics:Stop()
            inst:AddTag("NOCLICK")
            inst.persists = false

            SetRippleScale(inst, 1)
        end,

        onupdate = function(inst)
            SetRippleScale(inst, 1 - math.clamp((inst.AnimState:GetCurrentAnimationTime() / inst.AnimState:GetCurrentAnimationLength()) * 2, 0, 1))
        end,

        events =
        {
            EventHandler("animover", OnAnimOverRemoveAfterSounds),
        },

        onexit = function(inst)
            inst:RemoveTag("NOCLICK")
            SetRippleScale(inst, 0)
        end,
    },

    State{ --Probably repurpose, could update.
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

return StateGraph("spider_crabbit", states, events, "idle", actionhandlers)
