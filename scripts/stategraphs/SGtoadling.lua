require("stategraphs/commonstates")

local actionhandlers = 
{
}

local events=
{
    CommonHandlers.OnLocomote(true, true),
    CommonHandlers.OnSleep(),
    CommonHandlers.OnFreeze(),
    CommonHandlers.OnAttack(),
    CommonHandlers.OnAttacked(),
    CommonHandlers.OnDeath(),

    EventHandler("doattack", function(inst)
                                if inst.components.health and not inst.components.health:IsDead()
                                   and (inst.sg:HasStateTag("hit") or not inst.sg:HasStateTag("busy")) then
                                    inst.sg:GoToState("gore")
                                end
                            end),
    EventHandler("doleapattack", function(inst,data)
                                if inst.components.health and not inst.components.health:IsDead() and not inst.sg:HasStateTag("busy") then
                                    inst.sg:GoToState("leap_attack_pre", data.target)
                                end
                            end),
}

local states=
{
     State{
        
        name = "idle",
        tags = {"idle", "canrotate"},
        onenter = function(inst, playanim)
            inst.Physics:Stop()
            inst.SoundEmitter:KillSound("charge")
            if playanim then
                inst.AnimState:PlayAnimation(playanim)
                inst.AnimState:PushAnimation("idle", true)
            else
                inst.AnimState:PlayAnimation("idle", true)
            end
        end,
        
       --[[timeline = 
        {
            TimeEvent(11*FRAMES, function(inst) inst.SoundEmitter:PlaySound("UCSounds/Hippo/breathout") end ),
            TimeEvent(26*FRAMES, function(inst) inst.SoundEmitter:PlaySound("UCSounds/Hippo/breathin") end ),
            TimeEvent(46*FRAMES, function(inst) inst.SoundEmitter:PlaySound("UCSounds/Hippo/breathout") end ),
            TimeEvent(57*FRAMES, function(inst) inst.SoundEmitter:PlaySound("UCSounds/Hippo/breathin") end ),


        },--]]
        
        events=
        {
            EventHandler("animover", function(inst) 
                if math.random() < 0.5 and inst:HasTag("huff_idle") then
                    inst.sg:GoToState("huff")                 
                else
                    inst.sg:GoToState("idle")                 
                end
            end),
        },
    },

    State{
        name = "gore",
        tags = {"attack", "busy"},
        
        onenter = function(inst, target)
            if inst.components.locomotor then
                inst.components.locomotor:StopMoving()
            end
            inst.components.combat:StartAttack()
            inst.AnimState:PlayAnimation("atk")
            inst.sg.statemem.target = target
        end,
        
        timeline = 
        {
           TimeEvent(16*FRAMES, function(inst) inst.components.combat:DoAttack() end),
           TimeEvent(13*FRAMES, function(inst) inst.SoundEmitter:PlaySound("UCSounds/Hippo/attack") end ),

        },        

        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State{
            
        name = "leap_attack_pre",
        tags = {"attack", "canrotate", "busy","leapattack"},
        
        onenter = function(inst, target)
            inst.components.locomotor:Stop()                    
            inst.AnimState:PlayAnimation("jump_atk_pre")
            inst.sg.statemem.startpos = Vector3(inst.Transform:GetWorldPosition())
            inst.sg.statemem.targetpos = Vector3(target.Transform:GetWorldPosition())
        end,
            
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("leap_attack",{startpos =inst.sg.statemem.startpos, targetpos =inst.sg.statemem.targetpos}) end),
        },
    },


    State{

        name = "leap_attack",
        tags = {"attack", "canrotate", "busy", "leapattack"},
        
        onenter = function(inst, data)
            inst.sg.statemem.startpos = data.startpos
            inst.sg.statemem.targetpos = data.targetpos
            inst.components.locomotor:Stop()
            inst.Physics:SetActive(false)
            inst.components.locomotor:EnableGroundSpeedMultiplier(false)

            inst.components.combat:StartAttack()
            inst.AnimState:PlayAnimation("jump_atk_loop")            
        end,

        onupdate = function(inst)
            local percent = inst.AnimState:GetCurrentAnimationTime () / inst.AnimState:GetCurrentAnimationLength()
            local xdiff = inst.sg.statemem.targetpos.x - inst.sg.statemem.startpos.x
            local zdiff = inst.sg.statemem.targetpos.z - inst.sg.statemem.startpos.z

            --print(inst.sg.statemem.targetpos.x,inst.sg.statemem.targetpos.z, inst.sg.statemem.startpos.x,inst.sg.statemem.startpos.z)

            inst.Transform:SetPosition(inst.sg.statemem.startpos.x+(xdiff*percent),0,inst.sg.statemem.startpos.z+(zdiff*percent))
        end,

        onexit = function(inst)
            inst.Physics:SetActive(true)
            --inst.Physics:ClearMotorVelOverride()
            inst.components.locomotor:Stop()
            inst.components.locomotor:EnableGroundSpeedMultiplier(true)
            inst.sg.statemem.startpos = nil
            inst.sg.statemem.targetpos = nil
        end,
        
       timeline = 
        {
            TimeEvent(4*FRAMES, function(inst) inst.SoundEmitter:PlaySound("UCSounds/Hippo/attack") end ),
            ---TimeEvent(20*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/enemy/hippo/huff_out") end ),
        },
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("leap_attack_pst") end),
        },
    },


    State{

        name = "leap_attack_pst",
        tags = {"busy"},
        
        onenter = function(inst, target)
                --inst.components.groundpounder:GroundPound()
				local x, y, z = inst:GetPosition():Get()
			
				local ents = TheSim:FindEntities(x, y, z, TUNING.METEOR_RADIUS * 1.3, nil, {"frog", "toadstool", "shadow", "toad"})
				for i, v in ipairs(ents) do
						if v.components.combat ~= nil then
						v.components.combat:GetAttacked(inst, TUNING.METEOR_DAMAGE * 1.25, nil)
						end
				end
				inst.components.groundpounder:GroundPound()
			
                inst:DoMushroomBomb()
                inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/bearger/groundpound",nil,.5)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("jump_atk_pst")
        end,

        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("taunt") end),
        },
    },
	
	State{
            
        name = "enter_pre",
        tags = {"attack", "canrotate", "busy","leapattack"},
        
        onenter = function(inst, target)
            inst.components.locomotor:Stop()                    
            inst.AnimState:PlayAnimation("jump_atk_pre")
        end,
            
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("enter_attack") end),
        },
    },


    State{

        name = "enter_attack",
        tags = {"attack", "canrotate", "busy", "leapattack"},
        
        onenter = function(inst, data)
            inst.components.locomotor:Stop()
            inst.Physics:SetActive(false)
            inst.components.locomotor:EnableGroundSpeedMultiplier(false)

            inst.components.combat:StartAttack()
            inst.AnimState:PlayAnimation("jump_atk_loop")            
        end,

        onupdate = function(inst)
            
        end,

        onexit = function(inst)
            inst.Physics:SetActive(true)
            --inst.Physics:ClearMotorVelOverride()
            inst.components.locomotor:Stop()
            inst.components.locomotor:EnableGroundSpeedMultiplier(true)
            inst.sg.statemem.startpos = nil
            inst.sg.statemem.targetpos = nil
        end,
        
       timeline = 
        {
            TimeEvent(4*FRAMES, function(inst) inst.SoundEmitter:PlaySound("UCSounds/Hippo/attack") end ),
            ---TimeEvent(20*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/enemy/hippo/huff_out") end ),
        },
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("enter_attack_pst") end),
        },
    },


    State{

        name = "enter_attack_pst",
        tags = {"busy"},
        
        onenter = function(inst, target)
                --inst.components.groundpounder:GroundPound()
				local x, y, z = inst:GetPosition():Get()
			
				--[[local ents = TheSim:FindEntities(x, y, z, TUNING.METEOR_RADIUS, nil, {"frog", "toadstool"})
				for i, v in ipairs(ents) do
						if v.components.combat ~= nil then
						v.components.combat:GetAttacked(inst, TUNING.METEOR_DAMAGE * 2, nil)
						end
				end--]]
			
                --inst:DoMushroomBomb()
                inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/bearger/groundpound",nil,.5)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("jump_atk_pst")
        end,

        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("taunt") end),
        },
    },

    State{
        
        name = "huff",
        tags = {"idle", "canrotate"},
        onenter = function(inst)
            inst.Physics:Stop()
            inst.SoundEmitter:KillSound("charge")

            inst.AnimState:PlayAnimation("idle_huff")
        end,

         timeline = 
        {
            TimeEvent(7*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/frog/grunt") end ),
            TimeEvent(20*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/frog/grunt") 
			local x, y, z = inst.Transform:GetWorldPosition()
			SpawnPrefab("disease_puff").Transform:SetPosition(x, y, z)
			end ),
			--TimeEvent(20*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/enemy/hippo/huff_out") end ),
        },
        
        events=
        {
            EventHandler("animover", function(inst) 
                if math.random()<0.1 then
                    inst.sg:GoToState("huff")                 
                else
                    inst.sg:GoToState("idle")                 
                end
            end),
        },
    },

    State{
        name = "taunt",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("taunt")
            ---inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/enemy/hippo/taunt")
        end,
        
        timeline = 
        {   

            TimeEvent(11*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/together/toad_stool/roar") end ),
            TimeEvent(29*FRAMES, function(inst) inst.SoundEmitter:PlaySound("UCSounds/Hippo/attack") end ),
        --    TimeEvent(15*FRAMES,  function(inst) inst.SoundEmitter:PlaySound(inst.effortsound) end ),
        --    TimeEvent(27*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.soundpath .. "voice") end ),
        },
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State{
        name = "emerge",
        tags = {"canrotate", "busy"},
        
        onenter = function(inst)
            -- local is_moving = inst.sg:HasStateTag("moving")
            -- local is_running = inst.sg:HasStateTag("running")
            local should_move = inst.components.locomotor:WantsToMoveForward()
            local should_run = inst.components.locomotor:WantsToRun()
            if should_move then
                inst.components.locomotor:WalkForward()
            elseif should_run then
                inst.components.locomotor:RunForward()
            end

            inst.AnimState:SetBank("hippo_water")
            inst.AnimState:PlayAnimation("emerge")
        end,

        timeline=
        {
            TimeEvent( 8*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.emerge) end),
        },
       
        events=
        {
            EventHandler("animover", function(inst) 
                inst.AnimState:PlayAnimation("idle_loop")
                inst.AnimState:SetBank("hippo")
                inst.sg:GoToState("idle")
            end),
        },

        onexit = function(inst)
            inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/bearger/step_soft")
        end,
    },

    State{
        name = "submerge",
        tags = {"canrotate", "busy"},
        
        onenter = function(inst)
            local should_move = inst.components.locomotor:WantsToMoveForward()
            local should_run = inst.components.locomotor:WantsToRun()
            if should_move then
                inst.components.locomotor:WalkForward()
            elseif should_run then
                inst.components.locomotor:RunForward()
            end

            inst.AnimState:SetBank("hippo_water")
            inst.AnimState:PlayAnimation("submerge")
        end,

        timeline=
        {
            TimeEvent(10*FRAMES, function(inst) 
                    inst.SoundEmitter:PlaySound(inst.sounds.submerge) 
                 end),
        },
       
        events=
        {
            EventHandler("animover", function(inst) 
                --inst.AnimState:SetBank("ox")
                inst.sg:GoToState("idle")
            end),
        },

        onexit = function(inst)
            inst.walksound = inst.sounds.walk_water
        end,
    },
}

CommonStates.AddWalkStates(states,
{
    starttimeline = 
    {
	    TimeEvent(0*FRAMES, function(inst) inst.Physics:Stop() end ),
    },
	walktimeline = {
		    TimeEvent(0*FRAMES, function(inst) inst.Physics:Stop() end ),
            TimeEvent(7*FRAMES, function(inst) 
                inst.components.locomotor:WalkForward()
            end ),              
             TimeEvent(10*FRAMES, function(inst) 
                inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/enemy/hippo/in") 
                      
            end ),
            TimeEvent(19*FRAMES, function(inst)
                
                inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/bearger/step_soft")
                
            end ),
            TimeEvent(20*FRAMES, function(inst)
		    --    inst.SoundEmitter:PlaySound(inst.effortsound)
           --     inst.SoundEmitter:PlaySound(inst.soundpath .. "land")
                --       :Shake(shakeType, duration, speed, scale)
                    if inst:HasTag("lightshake") then
                        TheCamera:Shake("VERTICAL", 0.3, 0.05, 0.05)
                end
                inst.Physics:Stop()
            end ),
	},
}, nil,true)

CommonStates.AddRunStates(states,{
   starttimeline = 
    {
        TimeEvent(0*FRAMES, function(inst) inst.Physics:Stop() end ),
    },
    runtimeline = {
            TimeEvent(0*FRAMES, function(inst) 
                inst.Physics:Stop() 
            end ),
            TimeEvent(7*FRAMES, function(inst) 
                inst.components.locomotor:WalkForward()
            end ),     
            TimeEvent(10*FRAMES, function(inst) 
                inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/enemy/hippo/in")           
            end ),
            TimeEvent(19*FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/bearger/step_soft")
            end ),

            TimeEvent(20*FRAMES, function(inst)
          --      inst.SoundEmitter:PlaySound(inst.effortsound)
           --     inst.SoundEmitter:PlaySound(inst.soundpath .. "land")
                --       :Shake(shakeType, duration, speed, scale)
                    if inst:HasTag("lightshake") then
                        TheCamera:Shake("VERTICAL", 0.3, 0.05, 0.05)                        
                    else
                        TheCamera:Shake("VERTICAL", 0.5, 0.05, 0.1)
                    end
                inst.Physics:Stop()
            end ),
    },
    },{startrun="walk_pre",run="walk_loop",stoprun="walk_pst"},true)

CommonStates.AddSleepStates(states,
{
    starttimeline = 
    {
		--TimeEvent(11*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.soundpath .. "liedown") end ),
    },
    
	sleeptimeline = {
        TimeEvent(33*FRAMES, function(inst) inst.SoundEmitter:PlaySound("UCSounds/Hippo/in") end),
	},
})

CommonStates.AddCombatStates(states,
{
    attacktimeline = 
    {
        TimeEvent(4*FRAMES, function(inst) inst.SoundEmitter:PlaySound("UCSounds/Hippo/attack") end),
        TimeEvent(17*FRAMES, function(inst)
                                inst.components.combat:DoAttack()
                             end),
    },
    hittimeline = 
    {
        TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/together/toad_stool/hit") end),
    },
    deathtimeline = 
    {
        TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound("UCSounds/Hippo/death") end),
    },
})

CommonStates.AddFrozenStates(states)

    
return StateGraph("toadling", states, events, "idle", actionhandlers)