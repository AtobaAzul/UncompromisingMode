require("stategraphs/commonstates")

local events =
{
    EventHandler("attacked", function(inst)
        if not inst.components.health:IsDead() and not inst.sg:HasStateTag("attack") then
            inst.sg:GoToState("hit")
        end
    end),
    EventHandler("death", function(inst)
        inst.sg:GoToState("death", inst.sg.statemem.dead)
    end),
    EventHandler("doattack", function(inst, data)
        if not inst.components.health:IsDead() and (inst.sg:HasStateTag("hit") or not inst.sg:HasStateTag("busy")) then
            inst.sg:GoToState("fling", data.target)
        end
	end),
    --[[EventHandler("spawn", function(inst)
        inst.sg:GoToState("spawn")
    end),]]
    CommonHandlers.OnSleep(),
    CommonHandlers.OnHop(),
    CommonHandlers.OnLocomote(true, false),
    CommonHandlers.OnFreeze(),
}

local function GoToIdle(inst)
    inst.sg:GoToState("idle")
end

local states =
{
    State{
        name = "idle",
        tags = { "idle", "canrotate" },
        onenter = function(inst, playanim)
            
            inst.Physics:Stop()
			inst.AnimState:PlayAnimation("idle")

            inst.sg:SetTimeout(2*math.random()+.5)
        end,
		
        events =
        {
            EventHandler("animover", GoToIdle),
        },
    },

    State{
        name = "spawn",
        tags = { "busy" },

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("spawn", false)
        end,

        events =
        {
            EventHandler("animover", GoToIdle),
        },

    },

    State{
        name = "despawn",
        tags = { "busy" },

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("despawn", false)
        end,

        events =
        {
            EventHandler("animover", function(inst) inst:Remove() end),
        },

    },    

    State{
        name = "attack",
        tags = { "attack", "busy" },

        onenter = function(inst, target)
            inst.sg.statemem.target = target
            inst.Physics:Stop()
            inst.components.combat:StartAttack()
            inst.AnimState:PlayAnimation("attack")
        end,

        onexit = function(inst)
            inst.components.locomotor:Stop()
            inst.components.locomotor:EnableGroundSpeedMultiplier(true)
            inst.Physics:ClearMotorVelOverride()
        end,

        timeline =
        {

            TimeEvent(10*FRAMES, function(inst)
                inst.components.combat:DoAttack(inst.sg.statemem.target) 
                inst.SoundEmitter:PlaySound(inst.sounds.attack)
                inst.components.locomotor:EnableGroundSpeedMultiplier(false)            
                inst.Physics:SetMotorVelOverride(3,0,0)
            end),

            TimeEvent(18*FRAMES, function(inst)
                inst.components.combat:DoAttack(inst.sg.statemem.target) 
            end),

            TimeEvent(26*FRAMES, function(inst)
                inst.components.combat:DoAttack(inst.sg.statemem.target) 
                inst.components.locomotor:Stop()
            end),
        },

        events =
        {
            EventHandler("animover", function(inst)
                if math.random() < 0.2 then
                    inst.components.combat:SetTarget(nil)
                    inst.sg:GoToState("taunt")
                else
                    inst.sg:GoToState("idle")
                end
            end),
        },
    },

    State{
        name = "shoot",
        tags = { "attack", "busy" },

        onenter = function(inst, target)
            if not target then
                target = inst.components.combat.target
            end

            if target then
                inst.sg.statemem.target = target
            end

            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("flee")
        end,

        timeline =
        {   
            TimeEvent(7*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.spit) end),
            TimeEvent(15*FRAMES, function(inst)
                if inst.sg.statemem.target and inst.sg.statemem.target:IsValid() then
                    inst.sg.statemem.inkpos = Vector3(inst.sg.statemem.target.Transform:GetWorldPosition())            
                    inst:LaunchProjectile(inst.sg.statemem.inkpos)

                    inst.components.timer:StopTimer("ink_cooldown")
                    inst.components.timer:StartTimer("ink_cooldown", 10 + math.random()*3)
                end
            end),
        },

        events =
        {
            EventHandler("animover", GoToIdle),
        },
    },    

    State{
        name = "eat",
        tags = { "busy" },

        onenter = function(inst, cb)
            inst.Physics:Stop()
            inst.components.combat:StartAttack()
            inst.AnimState:PlayAnimation("attack", false)
        end,

        timeline =
        {
            TimeEvent(14*FRAMES, function(inst)
                inst.SoundEmitter:PlaySound(inst.sounds.bite)
            end),
        },

        events =
        {           
            EventHandler("animover", GoToIdle),
        },
    },

    State{
        name = "gobble",
        tags = { "busy" },

        onenter = function(inst, cb)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("gobble_pre")
            inst.components.timer:StartTimer("gobble_cooldown", 2 + math.random()*5)
        end,      

        timeline =
        {
            TimeEvent(12*FRAMES, function(inst) 
                inst.components.locomotor:Stop()
                inst.components.locomotor:EnableGroundSpeedMultiplier(false)
                inst.Physics:SetMotorVelOverride(20,0,0)
            end),
        },

        events =
        {
            EventHandler("animover", function(inst)
                inst.SoundEmitter:PlaySound(inst.sounds.bite)
                local action = inst:GetBufferedAction()
                if action and action.target and action.target:IsValid() then
                    if math.random() < inst.geteatchance(inst, action.target) then
                        if action.target.components.oceanfishable and action.target.components.oceanfishable:GetRod() then
                            local rod = action.target.components.oceanfishable:GetRod()
                            inst.components.oceanfishable:SetRod(rod)

                            inst:PushEvent("attacked",{attacker = rod.components.oceanfishingrod.fisher})
                        end
                        action.target:Remove() 
                    else
                        inst.sg.statemem.miss = true
                        action.target:PushEvent("dobreach")
                    end
                end
                inst:ClearBufferedAction()

                if inst.sg.statemem.miss then
                    inst.sg:GoToState("gobble_fail")
                else
                    inst.sg:GoToState("gobble_success")
                end
            end),
        },

        onexit = function(inst)
            inst.components.locomotor:Stop()
            inst.components.locomotor:EnableGroundSpeedMultiplier(true)
            inst.Physics:ClearMotorVelOverride()
            if inst.components.oceanfishable:GetRod() then
                inst.components.oceanfishable:ResetStruggling()
            end
        end,
    },

    State{
        name = "gobble_success",
        tags = { "busy" },

        onenter = function(inst)           
            local herd = inst.components.herdmember:GetHerd()
            if herd then
                for k,v in pairs(herd.components.herd.members)do
                    if inst.foodtarget and k.foodtarget and k.foodtarget == inst.foodtarget then
                        k.foodtarget = nil
                    end
                end
            end
            inst.foodtarget = nil

            inst.components.locomotor:Stop()
            inst.components.locomotor:EnableGroundSpeedMultiplier(false)
            inst.Physics:SetMotorVelOverride(20,0,0)
            inst.AnimState:PlayAnimation("gobble_success")
            inst.SoundEmitter:PlaySound(inst.sounds.gobble)
        end,

        timeline =
        {
            TimeEvent(6*FRAMES, function(inst) 
                inst.components.locomotor:Stop()
                inst.components.locomotor:EnableGroundSpeedMultiplier(true)
                inst.Physics:ClearMotorVelOverride()
            end),
        },

        events =
        {
            EventHandler("animover", GoToIdle),
        },
        
        onexit = function(inst)
            inst.components.locomotor:Stop()
            inst.components.locomotor:EnableGroundSpeedMultiplier(true)
            inst.Physics:ClearMotorVelOverride()
        end,        
    },

    State{
        name = "gobble_fail",
        tags = { "busy" },

        onenter = function(inst)
            inst.Physics:Stop()    
            inst.AnimState:PlayAnimation("gobble_fail")

            -- If the squid misses, give up this target and choose another from it's school 
            -- so that it doesn't chase it off into no mans land away from the rest of the squid
            if inst.foodtarget then
                local herd = inst.foodtarget.components.herdmember:GetHerd()
                local list = {}
                if herd then
                    for k,v in pairs(herd.components.herd.members)do
                        if k ~= inst.foodtarget then
                            table.insert(list,k)
                        end
                    end
                end
                if #list > 0 then
                    inst.foodtarget = list[math.random(1,#list)]
                end
            end
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("taunt") end),
        },
    },


    State{
        name = "hit",
        tags = { "busy", "hit" },

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("hit")
        end,

        events =
        {
            EventHandler("animover", GoToIdle),
        },
    },

    State{
        name = "taunt",
        tags = { "busy" },

        onenter = function(inst, norepeat)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("taunt")        
        end,

        timeline =
        {
            TimeEvent(8 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound(inst.sounds.taunt)
            end),
        },

        events =
        {
            EventHandler("animover", GoToIdle),
        },
    },

    State{
        name = "fling",
        tags = { "busy","jumping" },

        onenter = function(inst, norepeat)
            if inst:IsOnOcean() then
                inst.fling_land = false
            else
                inst.fling_land = true
            end        
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("jump")

            inst:StopBrain()     

            inst.components.locomotor:Stop()
            inst.components.locomotor:EnableGroundSpeedMultiplier(false)

            inst.Physics:SetMotorVelOverride(10,0,0)

            inst.sg:SetTimeout(0.35) 
        end,

        onexit = function(inst)
            inst.sg:GoToState("fling_pst")
        end,
		
    },    

    State{
        name = "fling_pst",
        tags = { "busy","jumping" },

        onenter = function(inst, norepeat)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("jump_pst")

            inst.components.locomotor:Stop()
            inst.components.locomotor:EnableGroundSpeedMultiplier(false)

            inst.Physics:SetMotorVelOverride(10,0,0) 
        end,


        onexit = function(inst)
            inst.components.locomotor:Stop()
            inst.components.locomotor:EnableGroundSpeedMultiplier(true)
            inst.Physics:ClearMotorVelOverride()     
            inst:RestartBrain()
        end,  

        events =
        {
            EventHandler("animover", GoToIdle),
        },        
    },  

    State{
        name = "death",
        tags = { "busy" },

        onenter = function(inst, reanimating)
            if reanimating then
                inst.AnimState:Pause()
            else
                inst.AnimState:PlayAnimation("dead")
                if inst.components.amphibiouscreature ~= nil and inst.components.amphibiouscreature.in_water then
                    inst.AnimState:PushAnimation("dead_loop", true)
                end         
            end
            inst.Physics:Stop()
            RemovePhysicsColliders(inst)
            inst.SoundEmitter:PlaySound(inst.sounds.death)
            inst.components.lootdropper:DropLoot(inst:GetPosition())
        end,

        timeline =
        {
            TimeEvent(TUNING.GARGOYLE_REANIMATE_DELAY, function(inst)
                if not inst:IsInLimbo() then
                    inst.AnimState:Resume()
                end
            end),
            TimeEvent(11 * FRAMES, function(inst)
                if inst.sg.statemem.clay then
                    PlayClayFootstep(inst)
                end
            end),
        },

        onexit = function(inst)
            if not inst:IsInLimbo() then
                inst.AnimState:Resume()
            end
        end,
    },

    State{
        name = "forcesleep",
        tags = { "busy", "sleeping" },

        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("sleep_loop", true)
        end,
    },

-- FISHING STATES

    State{
        name = "bitehook_pre",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("struggle_pre")
            inst:PerformBufferedAction()
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    if inst.components.oceanfishable ~= nil and inst.components.oceanfishable:GetRod() ~= nil then
                        inst.sg:GoToState("bitehook_loop")
                    else
                        inst.sg:GoToState("bitehook_jump")
                    end
                end
            end),
        },

    },    

    State{
        name = "bitehook_loop",
        tags = {"busy"},
        
        onenter = function(inst, remaining_loops)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("struggle_loop", true)
            inst.sg:SetTimeout(3 + math.random() * 0.5) -- TODO: make tuning varaibles per fish def
        end,
        
        onupdate = function(inst)
            if inst.components.oceanfishable ~= nil and inst.components.oceanfishable:GetRod() ~= nil then
                if not inst:HasTag("partiallyhooked") then
                    inst.sg.statemem.not_interupted = true
                    inst.sg:GoToState("idle")
                end
            else 
                inst.sg:GoToState("bitehook_jump")
            end
        end,

        ontimeout = function(inst)
            if inst:HasTag("partiallyhooked") then
                inst.sg.statemem.not_interupted = true
                inst.sg:GoToState("bitehook_jump")
            end
        end,

        onexit = function(inst)
            if not inst.sg.statemem.not_interupted and inst.components.oceanfishable ~= nil then
                inst.components.oceanfishable:SetRod(nil)
            end
        end,
    },

    State{
        name = "bitehook_jump",
        tags = {"busy", "jumping"},
        
        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("struggle_to_breach")
            inst.AnimState:PushAnimation("breach", false)
        end,

        timeline =
        {
            TimeEvent(3*FRAMES, function(inst) 
                local theta, speed = math.random() * 2 * PI, 1
                inst.Physics:SetMotorVelOverride(math.sin(theta) * speed, 0, math.cos(theta) * speed)
            end),
            TimeEvent(21*FRAMES, function(inst)
                inst.Physics:ClearMotorVelOverride()
                inst.components.locomotor:Stop()
            end),
        },
        
        events =
        {
            EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone() then
                    if inst.components.oceanfishable ~= nil then
                        inst.components.oceanfishable:SetRod(nil)
                    end

                    if inst.components.eater ~= nil then
                        inst.components.eater.lasteattime = GetTime()
                    end

                    -- if hook is set then start fighting otherwise, drop hook and go to idle, refresh brain

                    inst.sg:GoToState("idle")
                end
            end),
        },

        onexit = function(inst)
            inst.Physics:ClearMotorVelOverride()
            if inst:HasTag("partiallyhooked") and inst.components.oceanfishable ~= nil then
                inst.components.oceanfishable:SetRod(nil)
            end

        end,
    },    

    State{
        name = "breach",
        tags = {"busy"},
        
        onenter = function(inst, remaining_loops)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("breach_pre", false)
            inst.AnimState:PushAnimation("breach", false)
        end,

        events =
        {
            EventHandler("animqueueover", GoToIdle),
        },

    },  

-- END FISHING STATES

-- RUN STATES START HERE

    State{
        name = "run_start",
        tags = { "moving", "running", "canrotate" },

        onenter = function(inst)
            inst.components.locomotor:RunForward()
            inst.AnimState:PlayAnimation("run_pre")       
        end,

        events =
        {
            EventHandler("animover", function(inst)
                inst.staydim = true 
                inst.sg:GoToState("run") 
            end),
        },
    },

    State{
        name = "run",
        tags = { "moving", "running", "canrotate" },

        onenter = function(inst)
            inst.components.locomotor:RunForward()
            inst.AnimState:PlayAnimation("run_loop", true)
            inst.sg:SetTimeout(inst.AnimState:GetCurrentAnimationLength())

            if inst:HasTag("swimming") then
                inst.waketask = inst:DoPeriodicTask(0.3, function()
                    local wake = SpawnPrefab("wake_small")
                    local rotation = inst.Transform:GetRotation()

                    local theta = rotation * DEGREES
                    local offset = Vector3(math.cos( theta ), 0, -math.sin( theta ))
                    local pos = Vector3(inst.Transform:GetWorldPosition()) + offset
                    wake.Transform:SetPosition(pos.x,pos.y,pos.z)

                    wake.Transform:SetRotation(rotation - 90)
                end)
            end
        end,

        timeline =
        {
            TimeEvent(0, function(inst)                
                if inst:HasTag("swimming") then 
                    inst.Physics:Stop()  
                else
                    PlayFootstep(inst,0.2)
                end                
            end),
            TimeEvent(2*FRAMES, function(inst) 
                if not inst:HasTag("swimming") then
                    inst.SoundEmitter:PlaySound("hookline/creatures/squid/run") 
                end 
            end),

            TimeEvent(4 * FRAMES, function(inst)
                if inst:HasTag("swimming") then 
                    inst.SoundEmitter:PlaySound(inst.sounds.swim)
                else
                    PlayFootstep(inst,0.2)                    
                end
            end),
            TimeEvent(6*FRAMES, function(inst) 
                if not inst:HasTag("swimming") then
                    inst.SoundEmitter:PlaySound("hookline/creatures/squid/run") 
                end 
            end),
            TimeEvent(7 * FRAMES, function(inst) 
                if inst:HasTag("swimming") then 
                    inst.components.locomotor:RunForward() 
                end 
            end),
            TimeEvent(8*FRAMES, function(inst) 
                if not inst:HasTag("swimming") then
                    inst.SoundEmitter:PlaySound("hookline/creatures/squid/run") 
                end 
            end),
            TimeEvent(10*FRAMES, function(inst) 
                if not inst:HasTag("swimming") then
                    inst.SoundEmitter:PlaySound("hookline/creatures/squid/run") 
                end 
            end),
        },

        onexit = function(inst)     
            if inst.waketask then
                inst.waketask:Cancel()
                inst.waketask = nil
            end
        end,

        ontimeout = function(inst)
            inst.staydim = true 
            inst.sg:GoToState("run") 
        end,
    },

    State{
        name = "run_stop",
        tags = { "idle" },

        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("run_pst")

        end,

        events =
        {
            EventHandler("animqueueover", GoToIdle),
        },
    },   
}

CommonStates.AddAmphibiousCreatureHopStates(states, 
{ -- config
    swimming_clear_collision_frame = 9 * FRAMES,
},
nil, -- anims
{ -- timeline
    hop_pre =
    {
        TimeEvent(0, function(inst) 
            if inst:HasTag("swimming") then 
                SpawnPrefab("splash_green").Transform:SetPosition(inst.Transform:GetWorldPosition()) 
            end
        end),
    },
    hop_pst = {
        TimeEvent(4 * FRAMES, function(inst) 
            if inst:HasTag("swimming") then 
                inst.components.locomotor:Stop()
                SpawnPrefab("splash_green").Transform:SetPosition(inst.Transform:GetWorldPosition()) 
            end
        end),
        TimeEvent(6 * FRAMES, function(inst) 
            if not inst:HasTag("swimming") then 
                inst.components.locomotor:StopMoving()
            end
        end),
    }
})

CommonStates.AddSleepStates(states,
{
    sleeptimeline =
    {
        TimeEvent(17 * FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.sleep) end),
    },

    waketimeline = 
    {
        TimeEvent(8*FRAMES, function(inst) inst.SoundEmitter:PlaySound("hookline/creatures/squid/run") end),
        TimeEvent(11*FRAMES, function(inst) inst.SoundEmitter:PlaySound("hookline/creatures/squid/run") end),
        TimeEvent(16*FRAMES, function(inst) inst.SoundEmitter:PlaySound("hookline/creatures/squid/run") end),
    },
})

CommonStates.AddWalkStates(states, nil, nil, nil, true)

CommonStates.AddFrozenStates(states)

return StateGraph("squid", states, events, "idle")
