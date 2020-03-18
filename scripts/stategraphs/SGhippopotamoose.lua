require("stategraphs/commonstates")

function SpawnWaves(inst, numWaves, totalAngle, waveSpeed, wavePrefab, initialOffset, idleTime, instantActive, random_angle)
	wavePrefab = wavePrefab or "rogue_wave"
	totalAngle = math.clamp(totalAngle, 1, 360)

    local pos = inst:GetPosition()
    local startAngle = (random_angle and math.random(-180, 180)) or inst.Transform:GetRotation()
    local anglePerWave = totalAngle/(numWaves - 1)

	if totalAngle == 360 then
		anglePerWave = totalAngle/numWaves
	end

    --[[
    local debug_offset = Vector3(2 * math.cos(startAngle*DEGREES), 0, -2 * math.sin(startAngle*DEGREES)):Normalize()
    inst.components.debugger:SetOrigin("debugy", pos.x, pos.z)
    local debugpos = pos + (debug_offset * 2)
    inst.components.debugger:SetTarget("debugy", debugpos.x, debugpos.z)
    inst.components.debugger:SetColour("debugy", 1, 0, 0, 1)
	--]]

    for i = 0, numWaves - 1 do
        local wave = SpawnPrefab(wavePrefab)

        local angle = (startAngle - (totalAngle/2)) + (i * anglePerWave)
        local rad = initialOffset or (inst.Physics and inst.Physics:GetRadius()) or 0.0
        local total_rad = rad + wave.Physics:GetRadius() + 0.1
        local offset = Vector3(math.cos(angle*DEGREES),0, -math.sin(angle*DEGREES)):Normalize()
        local wavepos = pos + (offset * total_rad)

--        if inst:GetIsOnWater(wavepos:Get()) then
	        wave.Transform:SetPosition(wavepos:Get())

	        local speed = waveSpeed or 6
	        wave.Transform:SetRotation(angle)
	        wave.Physics:SetMotorVel(speed, 0, 0)
	        wave.idle_time = idleTime or 5

	        if instantActive then
	        	wave.sg:GoToState("idle")
	        end

	        if wave.soundtidal then
--	        	wave.SoundEmitter:PlaySound("volcano/common/rogue_waves/"..wave.soundtidal)
	        end
--        else
--        	wave:Remove()
--        end
    end
end

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
        
       timeline = 
        {
            TimeEvent(11*FRAMES, function(inst) inst.SoundEmitter:PlaySound("Hamlet/creatures/enemy/hippo/out") end ),
            TimeEvent(26*FRAMES, function(inst) inst.SoundEmitter:PlaySound("Hamlet/creatures/enemy/hippo/in") end ),
            TimeEvent(46*FRAMES, function(inst) inst.SoundEmitter:PlaySound("Hamlet/creatures/enemy/hippo/out") end ),
            TimeEvent(57*FRAMES, function(inst) inst.SoundEmitter:PlaySound("Hamlet/creatures/enemy/hippo/in") end ),


        },
        
        events=
        {
            EventHandler("animover", function(inst) 
                if math.random()<0.05 and inst:HasTag("huff_idle") then
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
           TimeEvent(13*FRAMES, function(inst) inst.SoundEmitter:PlaySound("Hamlet/creatures/enemy/hippo/leap_attack") end ),

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
            TimeEvent(4*FRAMES, function(inst) inst.SoundEmitter:PlaySound("Hamlet/creatures/enemy/hippo/leap_attack") end ),
            ---TimeEvent(20*FRAMES, function(inst) inst.SoundEmitter:PlaySound("Hamlet/creatures/enemy/hippo/huff_out") end ),
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
	local map = TheWorld.Map
	local x, y, z = inst.Transform:GetWorldPosition()
	local ground = map:GetTile(map:GetTileCoordsAtPoint(x, y, z))
	if ground ~= GROUND.OCEAN_COASTAL and
	ground ~= GROUND.OCEAN_COASTAL_SHORE and
	ground ~= GROUND.OCEAN_SWELL and
	ground ~= GROUND.OCEAN_ROUGH and
	ground ~= GROUND.OCEAN_BRINEPOOL and
	ground ~= GROUND.OCEAN_BRINEPOOL_SHORE and
	ground ~= GROUND.OCEAN_HAZARDOUS then	
	
                 inst.components.groundpounder:GroundPound()
                 inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/bearger/groundpound",nil,.5)
    else
    SpawnWaves(inst, 12, 360, 4)
	end
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
            TimeEvent(7*FRAMES, function(inst) inst.SoundEmitter:PlaySound("Hamlet/creatures/enemy/hippo/huff_in") end ),
            TimeEvent(20*FRAMES, function(inst) inst.SoundEmitter:PlaySound("Hamlet/creatures/enemy/hippo/huff_out") end ),
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
            ---inst.SoundEmitter:PlaySound("Hamlet/creatures/enemy/hippo/taunt")
        end,
        
        timeline = 
        {   

            TimeEvent(11*FRAMES, function(inst) inst.SoundEmitter:PlaySound("Hamlet/creatures/enemy/hippo/taunt") end ),
            TimeEvent(29*FRAMES, function(inst) inst.SoundEmitter:PlaySound("Hamlet/creatures/enemy/hippo/attack") end ),
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
            inst.SoundEmitter:PlaySound("Hamlet/creatures/enemy/hippo/walk")
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
                    SpawnWaves(inst, 6, 360, 2, "wave_ripple")
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
                inst.SoundEmitter:PlaySound("Hamlet/creatures/enemy/hippo/in") 
                if not inst.onwater then
                    -- do land stuff    
                else
                    -- do water stuff                    
                end                
            end ),
            TimeEvent(19*FRAMES, function(inst)
                
                if not inst.onwater then
                inst.SoundEmitter:PlaySound("Hamlet/creatures/enemy/hippo/walk")
                    -- do land stuff    
                else
                    -- do water stuff  
                end  
            end ),
            TimeEvent(20*FRAMES, function(inst)
		    --    inst.SoundEmitter:PlaySound(inst.effortsound)
           --     inst.SoundEmitter:PlaySound(inst.soundpath .. "land")
                --       :Shake(shakeType, duration, speed, scale)
                if not inst.onwater then
                    if inst:HasTag("lightshake") then
                        TheCamera:Shake("VERTICAL", 0.3, 0.05, 0.05)                        
                    else
                        TheCamera:Shake("VERTICAL", 0.5, 0.05, 0.1)
                    end
                else
                    if inst:HasTag("wavemaker") then
                        SpawnWaves(inst, 6, 360, 2, "wave_ripple") -- initialOffset, idleTime, instantActive, random_angle)
                    end
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
                inst.SoundEmitter:PlaySound("Hamlet/creatures/enemy/hippo/in") 
                if not inst.onwater then
                    -- do land stuff    
                else
                    -- do water stuff                    
                end                
            end ),
            TimeEvent(19*FRAMES, function(inst)
                
                if not inst.onwater then
                inst.SoundEmitter:PlaySound("Hamlet/creatures/enemy/hippo/walk")
                    -- do land stuff    
                else
                    -- do water stuff  
                end  
            end ),

            TimeEvent(20*FRAMES, function(inst)
          --      inst.SoundEmitter:PlaySound(inst.effortsound)
           --     inst.SoundEmitter:PlaySound(inst.soundpath .. "land")
                --       :Shake(shakeType, duration, speed, scale)
                if not inst.onwater then
                    if inst:HasTag("lightshake") then
                        TheCamera:Shake("VERTICAL", 0.3, 0.05, 0.05)                        
                    else
                        TheCamera:Shake("VERTICAL", 0.5, 0.05, 0.1)
                    end
                else
                    if inst:HasTag("wavemaker") then
                        SpawnWaves(inst, 6, 360, 2, "wave_ripple") -- initialOffset, idleTime, instantActive, random_angle)
                    end
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
        TimeEvent(33*FRAMES, function(inst) inst.SoundEmitter:PlaySound("Hamlet/creatures/enemy/hippo/huff_in") end),
	},
})

CommonStates.AddCombatStates(states,
{
    attacktimeline = 
    {
        TimeEvent(4*FRAMES, function(inst) inst.SoundEmitter:PlaySound("Hamlet/creatures/enemy/hippo/attack") end),
        TimeEvent(17*FRAMES, function(inst)
                                inst.components.combat:DoAttack()
                             end),
    },
    hittimeline = 
    {
        TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound("Hamlet/creatures/enemy/hippo/hit") end),
    },
    deathtimeline = 
    {
        TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound("Hamlet/creatures/enemy/hippo/death") end),
    },
})

CommonStates.AddFrozenStates(states)

    
return StateGraph("hippopotamoose", states, events, "idle", actionhandlers)