require("stategraphs/commonstates")
--[[
local actionhandlers = 
{
    ActionHandler(ACTIONS.EAT, "eat"),
    ActionHandler(ACTIONS.GOHOME, "eat"),
    ActionHandler(ACTIONS.INVESTIGATE, "investigate"),
}]]

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

local events=
{
	--[[EventHandler("locomote", function(inst) 
        if not inst.sg:HasStateTag("busy") and not inst.sg:HasStateTag("evade")  then
            
            local is_moving = inst.sg:HasStateTag("moving")
            local wants_to_move = inst.components.locomotor:WantsToMoveForward()
            if not inst.sg:HasStateTag("attack") and is_moving ~= wants_to_move then
                if wants_to_move then
                    inst.sg:GoToState("premoving")
                else
                    inst.sg:GoToState("idle")
                end
            end
        end
    end),   ]] 
}

local states=
{

	State{

        name = "appear",
        tags = {"idle", "canrotate"},
        onenter = function(inst, playanim)
            inst.AnimState:PlayAnimation("hand_in")
            inst.Physics:Stop()
            PlayExtendedSound(inst, "appear")
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end)
        },
    },
	
	State{

        name = "idle",
        tags = {"idle", "canrotate"},
        onenter = function(inst)
			if inst.despawntick == nil then
				inst.despawntick = 0
			elseif inst.despawntick ~= nil then
				inst.despawntick = inst.despawntick + 1
			end
		
            inst.components.locomotor:StopMoving()
			inst.AnimState:PlayAnimation("hand_in_loop", true)
        end,

        events=
        {
            EventHandler("animover", function(inst)
				if inst.despawntick ~= nil and inst.despawntick > 5 or not TheWorld.state.isnight then
					inst.sg:GoToState("run_stop")
				elseif inst.components.combat:HasTarget() then
					inst.sg:GoToState("charge_pre")
				else
					inst.sg:GoToState("idle")
				end
			end),
        },
    },

	State{  name = "charge_pre",
            tags = {"moving", "running", "busy", "atk_pre", "canrotate"},

            onenter = function(inst)
                inst.Physics:Stop()
                inst.AnimState:PlayAnimation("struggle_pre")
				PlayExtendedSound(inst, "taunt")
				
				if inst.components.combat:HasTarget() then
					inst:ForceFacePoint(inst.components.combat.target.Transform:GetWorldPosition())
				end
            end,

			events=
			{
				EventHandler("animover", function(inst) 
					if inst.components.combat:HasTarget() then
						inst:ForceFacePoint(inst.components.combat.target.Transform:GetWorldPosition())
						inst.sg:GoToState("run")
					else
						inst.sg:GoToState("idle")
					end
				end),
			},
        },

    State{  name = "run",
            tags = {"moving", "running", "canrotate"},

            onenter = function(inst)
				inst.components.locomotor.walkspeed = inst.components.locomotor.walkspeed + 1 or 8
				inst.components.locomotor.runspeed = inst.components.locomotor.runspeed + 1 or 8
				
				if inst.runnin == nil then
					inst.running = 1
				else
					inst.running = inst.running + 1
				end
				
				inst:StartGrabbing()
				PlayExtendedSound(inst, "attack_grunt")
			
                inst.components.locomotor:RunForward()
				inst.AnimState:PlayAnimation("struggle_loop")
                inst.sg:SetTimeout(inst.AnimState:GetCurrentAnimationLength())
            end,

			events=
			{
				EventHandler("animover", function(inst) 
					local x, y, z = inst.Transform:GetWorldPosition()
					
					if TheWorld.state.isnight and inst.components.combat:HasTarget() or (inst.running > 5 and TheSim:GetLightAtPoint(x, y, z) == TUNING.DARK_CUTOFF) then
						inst.sg:GoToState("run")
					else
						inst.sg:GoToState("run_stop")
					end
				end),
			},
        },

    State{  name = "run_stop",
            tags = {"canrotate", "idle", "canrotate"},

            onenter = function(inst)
				PlayExtendedSound(inst, "death")
				inst:StopGrabbing()
                inst.SoundEmitter:KillSound("charge")
                inst.components.locomotor:Stop()
                inst.AnimState:PlayAnimation("scared")
            end,

            events=
            {
                EventHandler("animover", function(inst) inst:Remove() end ),
            },
        },
}

CommonStates.AddFrozenStates(states)

return StateGraph("sushadow", states, events, "appear")--, actionhandlers)

