require("stategraphs/commonstates")

local actionhandlers = 
{
    ActionHandler(ACTIONS.EAT, "eat"),
    ActionHandler(ACTIONS.GOHOME, "eat"),
    ActionHandler(ACTIONS.INVESTIGATE, "investigate"),
}

local events=
{
    EventHandler("attacked", function(inst) 
        if not inst.components.health:IsDead() and not inst.sg:HasStateTag("no_stun") and not inst.sg:HasStateTag("attack") then 
            inst.sg:GoToState("evade")  -- can't attack during hit reaction
        end 
    end),
    EventHandler("doattack", function(inst, data) 
        if not inst.components.health:IsDead() and not inst.sg:HasStateTag("busy") and not inst.sg:HasStateTag("evade")  and data and data.target  then 
            if math.random() < 0.4 then
                inst.sg:GoToState("tail_attack", data.target) 
            else
                inst.sg:GoToState("attack", data.target) 
            end
        end 
    end),
    EventHandler("death", function(inst) inst.sg:GoToState("death") end),
    CommonHandlers.OnSleep(),
    CommonHandlers.OnFreeze(),
    EventHandler("exitshield", function(inst) inst.sg:GoToState("shield_end") end),
    
    
    EventHandler("locomote", function(inst) 
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
    end),    
}

local function SoundPath(inst, event)
    local creature = "spider"

    if inst:HasTag("spider_warrior") then
        creature = "spiderwarrior"
    elseif inst:HasTag("spider_hider") or inst:HasTag("spider_spitter") then
        creature = "cavespider"
    else
        creature = "spider"
    end
    return "dontstarve/creatures/" .. creature .. "/" .. event
end

local states=
{
    
    
    State{
        name = "death",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.SoundEmitter:PlaySound("UCSounds/Scorpion/death")
			inst.Physics:Stop()
			RemovePhysicsColliders(inst) 
			if inst:HasTag("notactuallydead") then
			inst.AnimState:PlayAnimation("disappear")
			inst.sg:SetTimeout(0.6)
			else
            inst.AnimState:PlayAnimation("death")
            inst.components.lootdropper:DropLoot(Vector3(inst.Transform:GetWorldPosition())) 
			end
        end,
		ontimeout = function(inst)
			local x, y, z = inst.Transform:GetWorldPosition()
			SpawnPrefab("sand_puff").Transform:SetPosition(x, y, z)
			SpawnPrefab("sinkhole_warn_fx_"..math.random(3)).Transform:SetPosition(x, y, z)
			SpawnPrefab("sinkhole_warn_fx_"..math.random(3)).Transform:SetPosition(x, y, z)
			SpawnPrefab("sinkhole_warn_fx_"..math.random(3)).Transform:SetPosition(x, y, z)
			SpawnPrefab("sinkhole_warn_fx_"..math.random(3)).Transform:SetPosition(x, y, z)
        end,
		        events=
        {
            EventHandler("animover", function(inst) 
			if inst:HasTag("notactuallydead") then
			local x, y, z = inst.Transform:GetWorldPosition()
			SpawnPrefab("sinkhole_warn_fx_"..math.random(3)).Transform:SetPosition(x, y, z)
			SpawnPrefab("sinkhole_warn_fx_"..math.random(3)).Transform:SetPosition(x, y, z)
			SpawnPrefab("sinkhole_warn_fx_"..math.random(3)).Transform:SetPosition(x, y, z)
			SpawnPrefab("sinkhole_warn_fx_"..math.random(3)).Transform:SetPosition(x, y, z)
			end

			end),
        },

    },    
    
    State{
        name = "premoving",
        tags = {"moving", "canrotate"},
        
        onenter = function(inst)
            inst.components.locomotor:WalkForward()
            inst.AnimState:PlayAnimation("walk_pre")
        end,
        
        timeline=
        {
            TimeEvent(3*FRAMES, function(inst) inst.SoundEmitter:PlaySound("UCSounds/Scorpion/walk") end),
            TimeEvent(3*FRAMES, function(inst) inst.SoundEmitter:PlaySound("UCSounds/Scorpion/mumble") end),
        },
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("moving") end),
        },
    },
    
    State{
        name = "moving",
        tags = {"moving", "canrotate"},
        
        onenter = function(inst)
            inst.components.locomotor:RunForward()
            inst.AnimState:PushAnimation("walk_loop")
        end,
        
        timeline=
        {
        
            TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound("UCSounds/Scorpion/walk") end),
            ----TimeEvent(2*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/enemy/scorpion/walk") end),
            TimeEvent(4*FRAMES, function(inst) inst.SoundEmitter:PlaySound("UCSounds/Scorpion/walk") end),
            ----TimeEvent(6*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/enemy/scorpion/walk") end),
            TimeEvent(6*FRAMES, function(inst) inst.SoundEmitter:PlaySound("UCSounds/Scorpion/mumble") end),
            TimeEvent(8*FRAMES, function(inst) inst.SoundEmitter:PlaySound("UCSounds/Scorpion/walk") end),
            ----TimeEvent(10*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/enemy/scorpion/walk") end),
            TimeEvent(12*FRAMES, function(inst) inst.SoundEmitter:PlaySound("UCSounds/Scorpion/walk") end),
            ----TimeEvent(14*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/enemy/scorpion/walk") end),
            TimeEvent(16*FRAMES, function(inst) inst.SoundEmitter:PlaySound("UCSounds/Scorpion/walk") end),
        },
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("moving") end),
        },
        
    },    
    
    
    State{
        name = "idle",
        tags = {"idle", "canrotate"},
        
        ontimeout = function(inst)
			inst.sg:GoToState("taunt")
        end,
        
        onenter = function(inst, start_anim)
            inst.Physics:Stop()
            local animname = "idle"
            if math.random() < .3 then
				inst.sg:SetTimeout(math.random()*2 + 2)
			end

            if start_anim then
                inst.AnimState:PlayAnimation(start_anim)
                inst.AnimState:PushAnimation("idle", true)
            else
                inst.AnimState:PlayAnimation("idle", true)
            end

        end,
    },
    
    State{
        name = "eat",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("eat")
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
        name = "born",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.AnimState:PlayAnimation("taunt")
        end,
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },      
    
    State{
        name = "eat_loop",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("eat_loop", true)
            inst.sg:SetTimeout(1+math.random()*1)
        end,
        
        ontimeout = function(inst)
            inst.sg:GoToState("idle", "eat_pst")
        end,       
    },  

    State{
        name = "taunt",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("taunt")
            inst.SoundEmitter:PlaySound("UCSounds/Scorpion/taunt")
        end,
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },    
    
    State{
        name = "investigate",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("taunt")
            inst.SoundEmitter:PlaySound("UCSounds/Scorpion/taunt")
        end,
        
        events=
        {
            EventHandler("animover", function(inst)
                inst:PerformBufferedAction()
                inst.sg:GoToState("idle")
            end),
        },
    },    
    
    State{
        name = "attack",
        tags = {"attack", "busy", "no_stun"},
        
        onenter = function(inst, target)
            inst.Physics:Stop()
            inst.components.combat:StartAttack()
            inst.AnimState:PlayAnimation("atk")
            inst.sg.statemem.target = target
        end,
        
        timeline=
        {
            TimeEvent(5*FRAMES, function(inst) inst.SoundEmitter:PlaySound("UCSounds/Scorpion/snap") end),
            TimeEvent(6*FRAMES, function(inst) inst.SoundEmitter:PlaySound("UCSounds/Scorpion/snap") end),
            TimeEvent(8*FRAMES, function(inst) inst.SoundEmitter:PlaySound("UCSounds/Scorpion/snap") end),
            TimeEvent(10*FRAMES, function(inst) inst.SoundEmitter:PlaySound("UCSounds/Scorpion/snap") end),
            TimeEvent(12*FRAMES, function(inst) inst.SoundEmitter:PlaySound("UCSounds/Scorpion/snap") end),
            TimeEvent(10*FRAMES, function(inst) inst.SoundEmitter:PlaySound("UCSounds/Scorpion/attack") end),
            TimeEvent(25*FRAMES, function(inst) inst.components.combat:DoAttack(inst.sg.statemem.target) end),
        },
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State{
        name = "tail_attack",
        tags = {"attack", "busy","no_stun"},
        
        onenter = function(inst, target)
            --inst.components.combat.poisonous = true
			inst:AddTag("sleepattack")
            inst.Physics:Stop()
            inst.components.combat:StartAttack()
            inst.AnimState:PlayAnimation("tail")
            inst.sg.statemem.target = target
        end,
        
        timeline=
        {
            TimeEvent(20*FRAMES, function(inst) inst.SoundEmitter:PlaySound("UCSounds/Scorpion/snap") end),
            TimeEvent(15*FRAMES, function(inst) inst.SoundEmitter:PlaySound("UCSounds/Scorpion/attack") end),
            TimeEvent(20*FRAMES, function(inst) 
                inst.components.combat:DoAttack(inst.sg.statemem.target) end),
        },
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },

        onexit = function(inst)
             --inst.components.combat.poisonous = false
			 inst:RemoveTag("sleepattack")
        end,
       
    },

    State{
        name = "leap_attack",
        tags = {"attack", "canrotate", "busy", "jumping"},

		
		onenter = function(inst)
		inst.components.combat:SetRange(2*TUNING.SPIDER_WARRIOR_ATTACK_RANGE, 2*TUNING.SPIDER_WARRIOR_HIT_RANGE)
            inst.sg:SetTimeout(21*FRAMES)                  
            --if inst.components.combat.target and inst.components.combat.target:IsValid() then
                inst:ForceFacePoint(inst.components.combat.target:GetPosition() )
            --end   
            inst.components.locomotor:Stop()           
            inst.AnimState:PlayAnimation("atk")
            --inst.Physics:SetMotorVelOverride(20,0,0)
            inst.components.locomotor:EnableGroundSpeedMultiplier(false)
        end,
		
		ontimeout = function(inst)
            inst.sg:GoToState("taunt")
			inst.components.combat:SetRange(3, 3)
        end,


        onexit = function(inst)
            inst.components.locomotor:Stop()
            inst.components.locomotor:EnableGroundSpeedMultiplier(true)
            inst.Physics:ClearMotorVelOverride()
        end,
		
		timeline =
        {
			TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound("UCSounds/Scorpion/attack") end),
            TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound(SoundPath(inst, "Jump")) end),
            TimeEvent(8	*FRAMES, function(inst) inst.Physics:SetMotorVelOverride(20,0,0) end),
            TimeEvent(8*FRAMES, function(inst) inst.SoundEmitter:PlaySound("UCSounds/Scorpion/snap_pre") end),
            TimeEvent(9*FRAMES, function(inst) inst.SoundEmitter:PlaySound("UCSounds/Scorpion/snap") end),
            TimeEvent(19*FRAMES, function(inst) inst.components.combat:SetRange(3, 3)
			inst.components.combat:DoAttack(inst.sg.statemem.target) end),
            TimeEvent(20*FRAMES,
                function(inst)
                    inst.Physics:ClearMotorVelOverride()
                    inst.components.locomotor:Stop()
                end),
        },

        events=
        {
            --EventHandler("animover", function(inst) inst.sg:GoToState("taunt") end),
        },
    },

    State{
        name = "spitter_attack",
        tags = {"attack", "canrotate", "busy", "spitting"},

        onenter = function(inst, target)
            if inst.weapon and inst.components.inventory then 
                inst.components.inventory:Equip(inst.weapon)
            end
            if inst.components.locomotor then
                inst.components.locomotor:StopMoving()
            end
            inst.AnimState:PlayAnimation("spit")
        end,

        onexit = function(inst)
            if inst.components.inventory then
                inst.components.inventory:Unequip(EQUIPSLOTS.HANDS)
            end
        end,

        timeline =
        {
            TimeEvent(7*FRAMES, function(inst) 
            inst.SoundEmitter:PlaySound(SoundPath(inst, "spit_web")) end),

            TimeEvent(21*FRAMES, function(inst) inst.components.combat:DoAttack()
            --inst.SoundEmitter:PlaySound(SoundPath(inst, "spit_voice"))
             end),
        },

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("taunt") end),
        },
    },

    State{
        name = "hit",
        
        onenter = function(inst)
            inst.AnimState:PlayAnimation("hit")
            inst.Physics:Stop()            
        end,
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end ),
        },
    },    
    
    State{
        name = "hit_stunlock",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.SoundEmitter:PlaySound(SoundPath(inst, "hit_response"))
            inst.AnimState:PlayAnimation("hit")
            inst.Physics:Stop()            
        end,
        
        events=
        {
            EventHandler("animover", function(inst) 
                if inst.components.combat.target and inst.components.combat.target:IsValid() then
                    inst.sg:GoToState("evade") 
                else
                    inst.sg:GoToState("idle") 
                end
            end ),
        },
    },  

    State{
        name = "evade",
        tags = {"busy", "evade","no_stun"},

        onenter = function(inst) 
            inst.components.locomotor:Stop()           
            inst.AnimState:PlayAnimation("evade")
            inst.components.locomotor:EnableGroundSpeedMultiplier(false)
			inst.components.combat:SetRange(TUNING.SPIDER_WARRIOR_ATTACK_RANGE, TUNING.SPIDER_WARRIOR_HIT_RANGE)
			--if inst.components.combat.target and inst.components.combat.target:IsValid() then
                --inst:ForceFacePoint(inst.components.combat.target:GetPosition() )
            --end  
			--inst.Physics:SetMotorVelOverride(-20,0,0)
        end,

        events=
        {
            EventHandler("animover", function(inst)
				--inst.Physics:SetMotorVelOverride(-20,0,0)			
                inst.sg:GoToState("evade_loop") 
            end ),
        },               
    },

    State{
        name = "evade_loop",
        tags = {"busy", "evade","no_stun"},


        onenter = function(inst)
		--inst.components.combat:SetRange(10, 10)
            inst.sg:SetTimeout(0.1)                  
            --if inst.components.combat.target and inst.components.combat.target:IsValid() then
            --    inst:ForceFacePoint(inst.components.combat.target:GetPosition() )
            --end   
            inst.components.locomotor:Stop()           
            inst.AnimState:PlayAnimation("evade_loop",true)
           --inst.Physics:SetMotorVelOverride(-20,0,0)
            inst.components.locomotor:EnableGroundSpeedMultiplier(false)
			inst.sg.statemem.startpos = Vector3(inst.Transform:GetWorldPosition())
            inst.sg.statemem.targetpos = Vector3(inst.components.combat.target.Transform:GetWorldPosition())
        end,
		onupdate = function(inst)
            local percent = inst.AnimState:GetCurrentAnimationTime () / inst.AnimState:GetCurrentAnimationLength()
            local xdiff = 2--inst.sg.statemem.targetpos.x - inst.sg.statemem.startpos.x
            local zdiff = 2--inst.sg.statemem.targetpos.z - inst.sg.statemem.startpos.z

            --print(inst.sg.statemem.targetpos.x,inst.sg.statemem.targetpos.z, inst.sg.statemem.startpos.x,inst.sg.statemem.startpos.z)

            inst.Transform:SetPosition(inst.sg.statemem.startpos.x-(xdiff*percent),0,inst.sg.statemem.startpos.z-(zdiff*percent))
        end,
--[[
        events=
        {
            EventHandler("animover", function(inst) 
                inst.sg:GoToState("evade_pst") 
            end ),
        },  
]]
        timeline =
        {
            --TimeEvent(0*FRAMES, function(inst) inst.Physics:SetMotorVel(-20,0,0) end),
          
        },
        ontimeout = function(inst)
            inst.sg:GoToState("evade_pst")
        end,

        onexit = function(inst)
            inst.components.locomotor:EnableGroundSpeedMultiplier(true)
            inst.Physics:ClearMotorVelOverride()
            inst.components.locomotor:Stop()
        end,        
    },

    State{
        name = "evade_pst",
        tags = {"busy", "evade","no_stun"},

        onenter = function(inst)                     
            --if inst.components.combat.target and inst.components.combat.target:IsValid() then
            --    inst:ForceFacePoint(inst.components.combat.target:GetPosition() )
            --end   
            inst.components.locomotor:Stop()           
            inst.AnimState:PlayAnimation("evade_pst")                    
        end,

        events=
        {
            EventHandler("animover", function(inst) 
                if inst.components.combat.target and inst.components.combat.target:IsValid() then

                    local JUMP_DISTANCE = 3 

                    local distance = inst:GetDistanceSqToInst(inst.components.combat.target )
					inst.components.combat:SetRange(3, 3)
                    --print(distance)
                    if distance > JUMP_DISTANCE*JUMP_DISTANCE then
                        inst.sg:GoToState("leap_attack",inst.components.combat.target) 
                    else

                        if math.random() < 0.3 then
                            inst.sg:GoToState("tail_attack",inst.components.combat.target) 
                        else
                            inst.sg:GoToState("attack",inst.components.combat.target) 
                        end
                    end
                else
                    inst.sg:GoToState("idle") 
                end

            end ),
        },  

        onexit = function(inst)
            inst.components.locomotor:EnableGroundSpeedMultiplier(true)
            inst.Physics:ClearMotorVelOverride()
            inst.components.locomotor:Stop()
        end,        
    },


    State{
        name = "fall",
        tags = {"busy"},
        onenter = function(inst)
            inst.Physics:SetDamping(0)
            inst.Physics:SetMotorVel(0,-20+math.random()*10,0)
            inst.AnimState:PlayAnimation("idle", true)
        end,
        
        onupdate = function(inst)
            local pt = Point(inst.Transform:GetWorldPosition())
            if pt.y < 2 then
                inst.Physics:SetMotorVel(0,0,0)
            end
            
            if pt.y <= .1 then
                pt.y = 0                
                inst.Physics:Stop()
                inst.Physics:SetDamping(5)
                inst.Physics:Teleport(pt.x,pt.y,pt.z)
               -- inst.DynamicShadow:Enable(true)
                --inst.SoundEmitter:PlaySound("dontstarve/frog/splat")
                inst.sg:GoToState("idle")
            end
        end,

        onexit = function(inst)
            local pt = inst:GetPosition()
            pt.y = 0
            inst.Transform:SetPosition(pt:Get())
        end,
    }, 

    State{
        name = "dropper_enter",
        tags = {"busy"},

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("enter")
            --inst.SoundEmitter:PlaySound("dontstarve/creatures/spider/descend")            
        end,

        events=
        {
            EventHandler("animqueueover", function(inst) inst.sg:GoToState("taunt") end ),
        },



    },
    State{
        name = "enterdig",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("appear")
            inst.SoundEmitter:PlaySound("UCSounds/Scorpion/taunt")
			--local x, y, z = inst.Transform:GetWorldPosition()
			--SpawnPrefab("sand_puff").Transform:SetPosition(x,y,z)
        end,
        timeline =
        {
            TimeEvent(3*FRAMES, function(inst) 
            	local x, y, z = inst.Transform:GetWorldPosition()
				SpawnPrefab("sinkhole_warn_fx_"..math.random(3)).Transform:SetPosition(x, y, z)end),

            TimeEvent(6*FRAMES, function(inst) 
			local x, y, z = inst.Transform:GetWorldPosition()
				SpawnPrefab("sinkhole_warn_fx_"..math.random(3)).Transform:SetPosition(x, y, z)end),
          
        },
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("taunt") end),
        },
    },  
}

CommonStates.AddSleepStates(states,
{
	starttimeline = {
		TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound(SoundPath(inst, "fallAsleep")) end ),
	},
	sleeptimeline = 
	{
		TimeEvent(35*FRAMES, function(inst) inst.SoundEmitter:PlaySound(SoundPath(inst, "sleeping")) end ),
	},
	waketimeline = {
		TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound(SoundPath(inst, "wakeUp")) end ),
	},
})
CommonStates.AddFrozenStates(states)

return StateGraph("scorpion", states, events, "idle", actionhandlers)

