require("stategraphs/commonstates")

local events =
{
    EventHandler("attacked", function(inst)
        if not inst.components.health:IsDead() and not inst.sg:HasStateTag("attack") and not inst.sg:HasStateTag("busy") then
            inst.sg:GoToState("hit")
        end
    end),
    EventHandler("death", function(inst)
        inst.sg:GoToState("death", inst.sg.statemem.dead)
    end),
    EventHandler("doattack", function(inst, data)
        if not inst.components.health:IsDead() and (inst.sg:HasStateTag("hit") or not inst.sg:HasStateTag("busy")) then
            inst.sg:GoToState("attack", data.target)
        end
    end),
    EventHandler("spawn", function(inst)
        inst.sg:GoToState("spawn")
    end),
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

            local random_roll = math.random()
            local anim = (random_roll > 0.6 and "idle2")
                    or (random_roll > 0.3 and "idle2")
                    or "idle2"

            if playanim then
                inst.AnimState:PlayAnimation(playanim)
                inst.AnimState:PushAnimation(anim, true)
            else
                inst.AnimState:PlayAnimation(anim, true)
            end

            inst.sg:SetTimeout(2*math.random()+.5)
        end,
        
        timeline =
        {
            TimeEvent(8*FRAMES, function(inst)
               if inst.AnimState:IsCurrentAnimation("idle2") then
                    inst.SoundEmitter:PlaySound("hookline/creatures/squid/eye")
               end
            end),
            TimeEvent(10*FRAMES, function(inst)
               if inst.AnimState:IsCurrentAnimation("idle2") then
               end
            end),
            TimeEvent(20*FRAMES, function(inst)
               if inst.AnimState:IsCurrentAnimation("idle2") then
               end
            end),
            TimeEvent(21*FRAMES, function(inst)
               if inst.AnimState:IsCurrentAnimation("idle2") then
                    inst.SoundEmitter:PlaySound("hookline/creatures/squid/eye")
               end
            end),
        },

        onexit = function(inst)
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
            inst.AnimState:PlayAnimation("birth", false)
			inst.AnimState:PushAnimation("jump_dirt", false)
        end,

        events =
        {	
			EventHandler("animover",function(inst)
				local effect = SpawnPrefab("pine_needles_chop")
				local x,y,z = inst.Transform:GetWorldPosition()
				effect.Transform:SetPosition(x, y, z)
			end),
            EventHandler("animqueueover", GoToIdle),
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
            TimeEvent(8*FRAMES, function(inst)
                if inst:HasTag("swimming") then 
                    SpawnPrefab("splash_green").Transform:SetPosition(inst.Transform:GetWorldPosition())
                end
            end),

            TimeEvent(10*FRAMES, function(inst)
                inst.components.combat:DoAttack(inst.sg.statemem.target) 
                inst.SoundEmitter:PlaySound(inst.sounds.attack)
                inst.components.locomotor:EnableGroundSpeedMultiplier(false)            
                inst.Physics:SetMotorVelOverride(8,0,0)
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
                    inst.sg:GoToState("taunt")
                else
                    inst.sg:GoToState("idle")
                end
            end),
        },
    },
    State{
        name = "hit",
        tags = { "busy", "hit" },

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("hit")
			inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/hurt_VO")
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
                inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/hurt_VO")
            end),
        },

        events =
        {
            EventHandler("animover", GoToIdle),
        },
    },

    State{
        name = "death",
        tags = { "busy" },

        onenter = function(inst, reanimating)

            inst.AnimState:PlayAnimation("dead")   
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
        end,

        timeline =
        {
            TimeEvent(0, function(inst)                
                PlayFootstep(inst,0.2)              
            end),
            TimeEvent(2*FRAMES, function(inst) 
                inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/deciduous/drake_run_rustle")
            end),

            TimeEvent(4 * FRAMES, function(inst)
                PlayFootstep(inst,0.2)                    
            end),
            TimeEvent(6*FRAMES, function(inst) 
                inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/deciduous/drake_run_rustle") 
            end),
            TimeEvent(7 * FRAMES, function(inst) 
                inst.components.locomotor:RunForward() 
            end),
            TimeEvent(8*FRAMES, function(inst) 
                inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/deciduous/drake_run_rustle")
            end),
            TimeEvent(10*FRAMES, function(inst) 
                inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/deciduous/drake_run_rustle") 
            end),
        },

        ontimeout = function(inst)
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
	
    State{
        name = "sleep",
        tags = {"busy", "sleeping", "nowake"},

        onenter = function(inst)
            inst.AnimState:PlayAnimation("embed")
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg.statemem.continuesleeping = true
                    inst.sg:GoToState(inst.sg.mem.sleeping and "sleeping" or "spawn")
                end
            end),
        },

        onexit = function(inst)
            if not inst.sg.statemem.continuesleeping and inst.components.sleeper ~= nil and inst.components.sleeper:IsAsleep() then
                inst.components.sleeper:WakeUp()
            end
        end,
    },

    State{
        name = "sleeping",
        tags = { "busy", "sleeping" },

        onenter = function(inst)
            inst.AnimState:PlayAnimation("embed_loop")
        end,

        timeline =
        {
            TimeEvent(1*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dangerous_sea/creatures/water_plant/sleep") end),
            TimeEvent(44*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dangerous_sea/creatures/water_plant/sleep") end),
        },


        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg.statemem.continuesleeping = true
                    inst.sg:GoToState("sleeping")
                end
            end),
        },

        onexit = function(inst)
            if not inst.sg.statemem.continuesleeping and inst.components.sleeper ~= nil and inst.components.sleeper:IsAsleep() then
                inst.components.sleeper:WakeUp()
            end
        end,
    },
}



--[[CommonStates.AddSleepStates(states,
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
})]]

CommonStates.AddWalkStates(states, nil, nil, nil, true)

CommonStates.AddFrozenStates(states)

return StateGraph("stumpling", states, events, "idle")
