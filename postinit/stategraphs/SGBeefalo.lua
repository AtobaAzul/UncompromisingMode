local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddStategraphPostInit("beefalo", function(inst)
local events={
	
	}


local states = {
	State{
        name = "attack",
        tags = {"attack", "busy"},

        onenter = function(inst, target)
            inst.sg.statemem.target = target
            inst.SoundEmitter:PlaySound(inst.sounds.angry)
            inst.components.combat:StartAttack()
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("atk_pre")
            inst.AnimState:PushAnimation("atk", false)
        end,

        timeline=
        {
            TimeEvent(15*FRAMES, function(inst) inst.components.combat:DoAttack(inst.sg.statemem.target) end),
        },

        events=
        {
            EventHandler("animqueueover", function(inst) 
			if math.random() < 0.66 then
				inst.sg:GoToState("charge_start")
				else
				inst.sg:GoToState("idle")
				end
			end),
        },
    },
	
    State{  name = "charge_start",
            tags = {"moving", "running", "busy", "atk_pre", "canrotate"},
            
            onenter = function(inst)
                -- inst.components.locomotor:RunForward()
                inst.Physics:Stop()
                --inst.SoundEmitter:PlaySound(inst.soundpath .. "pawground")
                --inst.AnimState:PlayAnimation("atk_pre")
                inst.AnimState:PlayAnimation("mating_taunt1")
				inst.components.locomotor.runspeed = TUNING.BEEFALO_RUN_SPEED.DEFAULT--*4
                inst.sg:SetTimeout(1)
            end,
            
            ontimeout= function(inst)
                inst.sg:GoToState("charge")
                inst:PushEvent("attackstart" )
            end,
            
            timeline=
            {
		    --TimeEvent(1*FRAMES,  function(inst) inst.SoundEmitter:PlaySound(inst.effortsound) end ),
		    --TimeEvent(12*FRAMES, function(inst)
            --                        inst.SoundEmitter:PlaySound(inst.soundpath .. "pawground")
            --                        --SpawnPrefab("ground_chunks_breaking").Transform:SetPosition(inst.Transform:GetWorldPosition())
            --                    end ),
            --TimeEvent(15*FRAMES,  function(inst) inst.sg:RemoveStateTag("canrotate") end ),
		    --TimeEvent(20*FRAMES,  function(inst) inst.SoundEmitter:PlaySound(inst.effortsound) end ),
		    --TimeEvent(30*FRAMES, function(inst)
                                    --inst.SoundEmitter:PlaySound(inst.soundpath .. "pawground")
                                    --SpawnPrefab("ground_chunks_breaking").Transform:SetPosition(inst.Transform:GetWorldPosition())
            --                    end ),
		    --TimeEvent(35*FRAMES,  function(inst) inst.SoundEmitter:PlaySound(inst.effortsound) end ),
            },        

            onexit = function(inst)
                --inst.SoundEmitter:PlaySound(inst.soundpath .. "charge_LP","charge")
            end,
        },

    State{  name = "charge",
            tags = {"moving", "running"},
            
            onenter = function(inst) 
                inst.components.locomotor:RunForward()
                
                if not inst.AnimState:IsCurrentAnimation("run_loop") then
                    inst.AnimState:PlayAnimation("run_loop", true)
                end
                --inst.sg:SetTimeout(inst.AnimState:GetCurrentAnimationLength())
            end,
            
            timeline=
            {
		        --TimeEvent(5*FRAMES,  function(inst) inst.SoundEmitter:PlaySound(inst.effortsound) end ),
                TimeEvent(5*FRAMES, function(inst)
                                        SpawnPrefab("ground_chunks_breaking").Transform:SetPosition(inst.Transform:GetWorldPosition())
                                    end ),
            },
            
            {   
                EventHandler("animover", function(inst) inst.sg:GoToState("charge") end ),        
            },
        },
    
    State{  name = "charge_stop",
            tags = {"canrotate", "idle"},
            
            onenter = function(inst) 
                --inst.SoundEmitter:KillSound("charge")
                inst.components.locomotor:Stop()
                inst.AnimState:PlayAnimation("run_pst")
		        --inst.SoundEmitter:PlaySound(inst.effortsound)
				inst.components.locomotor.runspeed = TUNING.BEEFALO_RUN_SPEED.DEFAULT
            end,
            
            events=
            {   
                EventHandler("animover", function(inst) inst.sg:GoToState("attack") end ),        
            },
        },    

    State{  name = "chargeattack",
            tags = {"runningattack"},
            
            onenter = function(inst)
                --inst.SoundEmitter:KillSound("charge")
                inst.components.combat:StartAttack()
                inst.components.locomotor:StopMoving()
		        --inst.SoundEmitter:PlaySound(inst.effortsound)
                --inst.AnimState:PlayAnimation("run_pst")
				inst.components.locomotor.runspeed = TUNING.BEEFALO_RUN_SPEED.DEFAULT
            end,
            
            timeline =
            {
                TimeEvent(1*FRAMES, function(inst)
                                        inst.components.combat:DoAttack()
                                     end),
            },
            
            events =
            {
                EventHandler("animqueueover", function(inst) inst.sg:GoToState("attack") end),
            },
        },
}

for k, v in pairs(events) do
    assert(v:is_a(EventHandler), "Non-event added in mod events table!")
    inst.events[v.name] = v
end

for k, v in pairs(states) do
    assert(v:is_a(State), "Non-state added in mod state table!")
    inst.states[v.name] = v
end

end)

