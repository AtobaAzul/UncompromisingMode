require("stategraphs/commonstates")

local events =
{
    EventHandler("doattack", function(inst, data) 
        if not (inst.sg:HasStateTag("busy") or inst.components.health:IsDead()) then
            inst.sg:GoToState(
                data.target:IsValid()
                and not inst:IsNear(data.target, 1.5)
                and "leap_pre" --Do leap attack
                or "attack",
                data.target
            )
        end
    end),
	
    EventHandler("death", function(inst) inst.sg:GoToState("death") end),

	--CommonHandlers.OnLocomote(false, true),
    EventHandler("locomote", function(inst) 
        if not inst.sg:HasStateTag("busy") --[[and not inst.sg:HasStateTag("grabbing") and not inst.sg:HasStateTag("evade")]] then
            
            local is_moving = inst.sg:HasStateTag("moving")
            local wants_to_move = inst.components.locomotor:WantsToMoveForward()
            if not inst.sg:HasStateTag("attack") and is_moving ~= wants_to_move then
                if wants_to_move then
                    --inst.sg:GoToState("premoving")
                    inst.sg:GoToState("moving")
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

local states =
{
    State{
        name = "death",
        tags = {"busy"},

        onenter = function(inst)
			inst:AddTag("INLIMBO")
            PlayExtendedSound(inst, "death")
            inst.AnimState:PlayAnimation("death")
            inst.Physics:Stop()
            RemovePhysicsColliders(inst)
            inst:AddTag("NOCLICK")  
            inst.persists = false
        end,

        events=
        {
			EventHandler("animover", OnAnimOverRemoveAfterSounds),
        },
		
        onexit = function(inst)
            inst:RemoveTag("NOCLICK")
        end
    },

    State{
        name = "moving_pre",
        tags = {"moving", "canrotate"},

        onenter = function(inst)
            inst.AnimState:PlayAnimation("walk_pre")
        end,

        timeline=
        {
        },

        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },
	
    State{
        name = "moving",
        tags = {"moving", "canrotate"},

        onenter = function(inst)
            --PlayExtendedSound(inst, "idle")
            inst.components.locomotor:WalkForward()
            inst.AnimState:PlayAnimation("walk_loop", true)
        end,

        timeline=
        {
        },

        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("moving") end),
        },
    },

    State{
        name = "moving_pst",
        tags = {"moving", "canrotate"},

        onenter = function(inst)
            inst.AnimState:PlayAnimation("walk_pst")
        end,

        timeline=
        {
        },

        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State{
        name = "idle",
        tags = {"idle", "canrotate"},

        onenter = function(inst, start_anim)
            inst.Physics:Stop()
			inst.AnimState:PlayAnimation("idle_loop", true)
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if math.random() < 0.01 then
                    inst.sg:GoToState("taunt")
                else  
                    inst.sg:GoToState("idle")
                end
            end),
        },        
    },

    State{
        name = "appear",
        tags = {"busy"},

        onenter = function(inst)
            inst.AnimState:PlayAnimation("appear")
            PlayExtendedSound(inst, "appear")
            inst.Physics:Stop()            
        end,

        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end ),
        },
    },
	
    State{
        name = "taunt",
        tags = {"busy"},

        onenter = function(inst)
            inst.Physics:Stop()
			PlayExtendedSound(inst, "taunt")
            inst.AnimState:PlayAnimation("taunt")

			if inst.components.combat ~= nil and inst.components.combat.target ~= nil then
			    inst:ForceFacePoint(inst.components.combat.target:GetPosition())
			end

        end,

        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },    
	
	State{
        name = "action",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("eat_pre")
        end,
        
        events=
        {
            EventHandler("animover", function(inst)

                if inst:PerformBufferedAction() then
                    inst.sg:GoToState("eat_loop")
                else
                    inst.sg:GoToState("idle")
                end
            end),
        },
    },
    
    State{
        name = "attack",
        tags = {"attack", "busy"},

        onenter = function(inst, target)
            inst.Physics:Stop()
            inst.components.combat:StartAttack()
			PlayExtendedSound(inst, "attack_grunt")
            inst.AnimState:PlayAnimation("atk")
            inst.sg.statemem.target = target
        end,
		
		timeline =
        {
			TimeEvent(10*FRAMES, function(inst) inst.components.combat:DoAttack(inst.sg.statemem.target) end),
		},

        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State{
        name = "leap_pre",
        tags = {"attack", "canrotate", "busy", "jumping"},

        onenter = function(inst, target)
            inst.Physics:Stop()
            inst.components.locomotor:Stop()

            inst.AnimState:PlayAnimation("shuttle_pre")
            inst.sg.statemem.target = target

			if target ~= nil and target:IsValid() then
				inst:ForceFacePoint(target:GetPosition())
			end
        end,
		
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("leap_attack") end),
        },
    },
	
    State{
        name = "leap_attack",
        tags = {"attack", "canrotate", "busy", "jumping"},

        onenter = function(inst, target)
            inst.components.locomotor:Stop()
            inst.components.locomotor:EnableGroundSpeedMultiplier(false)
			inst.Physics:SetMotorVelOverride(30,0,0)
            inst.components.combat:StartAttack()
			PlayExtendedSound(inst, "attack")

            inst.AnimState:PlayAnimation("shuttle_loop", true)
            inst.sg.statemem.target = target

			--[[if target ~= nil and target:IsValid() then
				inst:ForceFacePoint(target:GetPosition())
			end]]
        end,
		
        onexit = function(inst)
            inst.components.locomotor:Stop()
            inst.components.locomotor:EnableGroundSpeedMultiplier(true)
            inst.Physics:ClearMotorVelOverride()
        end,
		
		timeline =
        {
			TimeEvent(5*FRAMES, function(inst) inst.components.combat:DoAttack(inst.sg.statemem.target) end),
			TimeEvent(10*FRAMES, function(inst) inst.components.combat:DoAttack(inst.sg.statemem.target) end),
			TimeEvent(15*FRAMES, function(inst) inst.components.combat:DoAttack(inst.sg.statemem.target) end),
			TimeEvent(20*FRAMES, function(inst) inst.components.combat:DoAttack(inst.sg.statemem.target) end),
			TimeEvent(25*FRAMES, function(inst) inst.components.combat:DoAttack(inst.sg.statemem.target) end),
			TimeEvent(30*FRAMES, function(inst) inst.components.combat:DoAttack(inst.sg.statemem.target) end),
        },
		
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("leap_pst") end),
        },
    },
	
    State{
        name = "leap_pst",
        tags = {"attack", "canrotate", "busy", "jumping"},

        onenter = function(inst, target)
            inst.components.locomotor:Stop()
            inst.Physics:ClearMotorVelOverride()
			inst.Physics:Stop()

            inst.AnimState:PlayAnimation("shuttle_pst")
        end,
		
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State{
        name = "hit",
        tags = {"busy"},

        onenter = function(inst)
			inst.SoundEmitter:PlaySound("UCSounds/aphid/walk")
            --inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/enemy/weevole/hit")
            inst.AnimState:PlayAnimation("hit")
            inst.Physics:Stop()            
        end,

        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end ),
        },
    },

}

CommonStates.AddWalkStates(states)

return StateGraph("nightcrawler", states, events, "appear")
