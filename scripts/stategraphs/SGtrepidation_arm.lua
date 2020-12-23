require("stategraphs/commonstates")

local events=
{
    EventHandler("attacked", function(inst) if not inst.components.health:IsDead() and not inst.sg:HasStateTag("hit") and not inst.sg:HasStateTag("attack") then inst.sg:GoToState("hit") end end),
    EventHandler("death", function(inst) inst.sg:GoToState("death") end),
    CommonHandlers.OnFreeze(),
    EventHandler("newcombattarget", function(inst,data)
            
            if inst.sg:HasStateTag("idle") and data.target then
                inst.sg:GoToState("taunt")
            end
        end)
}

local function OnEntitySleep(inst)
    inst.SoundEmitter:KillSound("tentacle")
end

local function OnEntityWake(inst)
    if inst.sg.mem.rumblesoundstate then --don't nil check, can be false
        if not inst.SoundEmitter:PlayingSound("tentacle") then
            inst.SoundEmitter:PlaySound("dontstarve/tentacle/tentacle_rumble_LP", "tentacle")
        end
        inst.SoundEmitter:SetParameter("tentacle", "state", inst.sg.mem.rumblesoundstate)
    end
end

local function StartRumbleSound(inst, state)
    if inst.sg.mem.rumblesoundstate ~= state then
        if inst.sg.mem.rumblesoundstate == nil then
            inst:ListenForEvent("entitysleep", OnEntitySleep)
            inst:ListenForEvent("entitywake", OnEntityWake)
        end
        inst.sg.mem.rumblesoundstate = state
        if not inst:IsAsleep() then
            OnEntityWake(inst)
        end
    end
end

local function StopRumbleSound(inst)
    if not inst.sg.statemem.keeprumblesound then
        inst.sg.mem.rumblesoundstate = false
        inst.SoundEmitter:KillSound("tentacle")
    end
end

local states=
{


    State{
        name = "rumble",
        tags = {"idle"},
        onenter = function(inst)
            StartRumbleSound(inst, 0)
            inst.AnimState:PlayAnimation("idle_1")
            inst.AnimState:PushAnimation("idle_1", true)
            inst.sg:SetTimeout(GetRandomWithVariance(10, 5) )
        end,
        ontimeout = function(inst)
            inst.AnimState:PushAnimation("idle_1", false)
            inst.sg:GoToState("idle")
        end,

        onexit = StopRumbleSound,
    },
   
    State{
        name = "idle",
        tags = {"idle"},
        onenter = function(inst)
            inst.AnimState:PushAnimation("idle_1", true)
            inst.sg:SetTimeout(GetRandomWithVariance(10, 5) )
            inst.SoundEmitter:KillAllSounds()
        end,
                
        ontimeout = function(inst)
			inst.sg:GoToState("rumble")
        end,
    },
    
    State{
        name = "taunt",
        tags = {"taunting"},
        onenter = function(inst)
            StartRumbleSound(inst, 0)
            
            inst.AnimState:PlayAnimation("taunt")
        end,

        onupdate = function(inst)
            if inst.sg.timeinstate > .3 and inst.components.combat:TryAttack() then
                inst.sg:GoToState("attack_pre")
            elseif inst.components.combat.target == nil then
                inst.AnimState:PlayAnimation("idle_1")
                inst.sg:GoToState("idle")
            end

        end,
        onexit = StopRumbleSound,
    },
    
    State{
        name ="attack_pre",
        tags = {"attack"},
        onenter = function(inst)
            inst.SoundEmitter:PlaySound("dontstarve/tentacle/tentacle_emerge")
            inst.components.combat:StartAttack()
            inst.AnimState:PlayAnimation("atk_pre")
            StartRumbleSound(inst, 1)
        end,
        events=
        {
            EventHandler("animover", function(inst)
                inst.sg.statemem.keeprumblesound = true
                inst.sg:GoToState("attack")
            end),
        },
        timeline=
        {
            TimeEvent(20*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/tentacle/tentacle_emerge_VO") end),
        },
        onexit = StopRumbleSound,
    },
    
    State{ 
        name = "attack",
        tags = {"attack"},
        onenter = function(inst)
			if inst.components.combat.target ~= nil then
			inst:ForceFacePoint(inst.components.combat.target:GetPosition() )
			end
            inst.AnimState:PlayAnimation("atk_loop")
            inst.AnimState:PushAnimation("taunt", false)
        end,
        
        timeline=
        {
            TimeEvent(2*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/tentacle/tentacle_attack") end),
			TimeEvent(7*FRAMES, function(inst) inst.components.combat:DoAttack() end),
            --TimeEvent(15*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/tentacle/tentacle_attack") end),
            --TimeEvent(17*FRAMES, function(inst) inst.components.combat:DoAttack() end),
            --TimeEvent(18*FRAMES, function(inst) inst.sg:RemoveStateTag("attack") end),
        },
        
        events=
        {
            EventHandler("animqueueover", function(inst) 
                inst.sg.statemem.keeprumblesound = true
                if inst.components.combat.target then
                    inst.sg:GoToState("attack")
					
                else
                    inst.sg:GoToState("attack_post") 
                end
            end),
        },
        onexit = StopRumbleSound,
    },
    
    State{
        name ="attack_post",
        onenter = function(inst)
            inst.SoundEmitter:PlaySound("dontstarve/tentacle/tentacle_disappear")
            inst.AnimState:PlayAnimation("atk_pst")
        end,
        events=
        {
            EventHandler("animover", function(inst) inst.SoundEmitter:KillAllSounds() inst.sg:GoToState("idle") end),
        },
        onexit = StopRumbleSound,
    },
    
    
	State{
        name = "death",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.SoundEmitter:PlaySound("dontstarve/tentacle/tentacle_death_VO")
            inst.AnimState:PlayAnimation("death")
            RemovePhysicsColliders(inst)                     
        end,
          
        timeline=
        {
            TimeEvent(20*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/tentacle/tentacle_splat") end),
        },       
    },
    
        
    State{
        name = "hit",
        tags = {"busy", "hit"},
        
        onenter = function(inst)
            --inst.SoundEmitter:PlaySound("dontstarve/pig/grunt")
            inst.AnimState:PlayAnimation("hit")
            inst.SoundEmitter:PlaySound("dontstarve/tentacle/tentacle_hurt_VO")
        end,
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("attack") end),
        },
        
    },    
    
}
    
return StateGraph("trepidation_arm", states, events, "idle")

