require("stategraphs/commonstates")

local function doattackfn(inst, data)
	if not inst:HasTag("viperlingfriend") then
    if not (inst.sg:HasStateTag("busy") or inst.components.health:IsDead()) then
        inst.sg:GoToState(inst.sg:HasStateTag("lure") and "attack_pre" or "attack")
    end
	else
	inst.sg:GoToState("attack")
	end
end

local function onattackedfn(inst, data)
    if not (inst.sg:HasStateTag("busy") or
            inst.sg:HasStateTag("invisible") or
            inst.sg:HasStateTag("nohit") or
            (inst.components.health ~= nil and inst.components.health:IsDead())) then
        --Will handle the playing of the "hit" animation
        inst.sg:GoToState("hit")
    end
end

local function ChangeToLure(inst)
    inst.components.pickable.canbepicked = true
	if not inst:HasTag("viperling") then
    ChangeToInventoryPhysics(inst)
	end
    inst.components.sanityaura.aura = 0
end

local function ChangeToWorm(inst)
    inst.components.pickable.canbepicked = false
	if not inst:HasTag("viperling") then
    ChangeToCharacterPhysics(inst)
	end
    inst.components.sanityaura.aura = -TUNING.SANITYAURA_SMALL
end

local actionhandlers =
{
    ActionHandler(ACTIONS.PICKUP, "action"),
    ActionHandler(ACTIONS.PICK, "action"),
    ActionHandler(ACTIONS.HARVEST, "action"),
    ActionHandler(ACTIONS.EAT, "eat"),
}

local events =
{
    EventHandler("locomote", function(inst)
        if inst.components.locomotor:WantsToMoveForward() then
            if inst.sg:HasStateTag("idle") then
                inst.sg.statemem.walking = true
                inst.sg:GoToState("walk_start")
            end
        elseif inst.sg:HasStateTag("moving") then
            inst.sg.statemem.walking = true
            inst.sg:GoToState("walk_stop")
        end
    end),
    CommonHandlers.OnLocomote(false, true),
    CommonHandlers.OnFreeze(),
    CommonHandlers.OnDeath(),
    CommonHandlers.OnSleep(),
    EventHandler("doattack", doattackfn),
    EventHandler("attacked", onattackedfn),
    EventHandler("dolure", function(inst)
        inst.sg:GoToState("lure_enter")
    end),
}

local states =
{	
    State{
        name = "idle_enter",
        tags = { "idle", "invisible", "dirt" },

        onenter = function(inst)
			if not inst:HasTag("viperling") then
            inst.Physics:Stop()
			else
			inst.components.locomotor:StopMoving()
			end
            inst.AnimState:PlayAnimation("mound")
            inst.SoundEmitter:KillAllSounds()
        end,

        events =
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle")
            end),
        },
    },

    State{
        name = "idle",
        tags = { "idle", "invisible", "dirt" },

        onenter = function(inst)
		if not inst:HasTag("viperling") then
            inst.Physics:Stop()
			else
			inst.components.locomotor:StopMoving()
		end
            inst.AnimState:PlayAnimation("mound_idle", true)
            inst.SoundEmitter:KillAllSounds()
        end,

        events =
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle")
            end),
        },
    },

    State{
        name = "idle_exit",
        tags = { "idle", "invisible", "dirt" },

        onenter = function(inst)
		if not inst:HasTag("viperling") then
            inst.Physics:Stop()
			else
			inst.components.locomotor:StopMoving()
			end
            inst.AnimState:PlayAnimation("mound_out")
            inst.SoundEmitter:KillAllSounds()
        end,

        events =
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle")
            end),
        },
    },

    State{
        name = "action",
        tags = { "busy" },

        onenter = function(inst)
		if not inst:HasTag("viperling") then
            inst.Physics:Stop()
			else
			inst.components.locomotor:StopMoving()
		end
            inst.AnimState:PlayAnimation("pickup")
            inst.SoundEmitter:KillAllSounds()    
            inst.SoundEmitter:PlaySound("dontstarve/creatures/worm/emerge")
        end,

        timeline =
        {	
	
            TimeEvent(10 * FRAMES, function(inst)
                inst.sg:AddStateTag("nohit")
            end),
            TimeEvent(15 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/creatures/worm/bite")
                inst:PerformBufferedAction()
            end),

        },

        events =
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle")
            end),
        },
    },

    State{
        name = "eat",

        onenter = function(inst, playanim)
		if not inst:HasTag("viperling") then
            inst.Physics:Stop()
			else
			inst.components.locomotor:StopMoving()
		end
            inst.AnimState:PlayAnimation("eat")
            inst.SoundEmitter:PlaySound("dontstarve/creatures/worm/emerge")
        end,

        timeline =
        {	
		
            TimeEvent(20 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/worm/eat") end),
            TimeEvent(30 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/worm/eat") end),
            TimeEvent(40 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/worm/eat") end),
            TimeEvent(60 * FRAMES, function(inst)
                inst.sg:AddStateTag("nohit")
                inst:PerformBufferedAction()
            end),
            TimeEvent(75 * FRAMES, function(inst) 
			inst.SoundEmitter:PlaySound("dontstarve/creatures/worm/retract")

			end),
        },

        events =
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle")
            end),
        }
    },

    State{
        name = "taunt",
        tags = { "taunting" },

        onenter = function(inst)
		if not inst:HasTag("viperling") then
            inst.Physics:Stop()
			else
			inst.components.locomotor:StopMoving()
		end
            inst.SoundEmitter:PlaySound("dontstarve/creatures/worm/emerge")
            inst.AnimState:PlayAnimation("taunt")
        end,

        timeline =
        {	

            TimeEvent(30 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/worm/retract") end),
        },

        events =
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle")
            end),
        },
    },

    State{
        name = "attack_pre",
        tags = { "canrotate", "invisible" },

        onenter = function(inst)
		if not inst:HasTag("viperling") then
            inst.Physics:Stop()
			else
            inst.components.locomotor:StopMoving()			
		end
            inst.AnimState:PlayAnimation("atk_pre")
			if not inst:HasTag("viperling") then
            inst:turnofflight()
			end
        end,

        events =
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("attack")
            end),
        },
    },

    State{
        name = "attack",
        tags = { "attack", "nohit" },

        onenter = function(inst)
		if not inst:HasTag("viperling") then
            inst.Physics:Stop()
				if inst.components.combat ~= nil and inst.components.combat.target ~= nil then
				inst.ViperlingBelch(inst,inst.components.combat.target)
				end
			else
			inst.components.locomotor:StopMoving()
		end
            inst.AnimState:PlayAnimation("atk")
            inst.components.combat:StartAttack()
            inst.SoundEmitter:PlaySound("dontstarve/creatures/worm/emerge")
        end,

        timeline =
        {
            --[[TimeEvent(20 * FRAMES, function(inst)
                inst.sg:AddStateTag("nohit")
            end),]]
			TimeEvent(1 * FRAMES, function(inst)
                --inst:turnonlight()
            end),
            TimeEvent(25 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/creatures/worm/bite")
                inst.components.combat:DoAttack()
            end),
            TimeEvent(40 * FRAMES, function(inst) 
			inst.SoundEmitter:PlaySound("dontstarve/creatures/worm/retract")
			--inst:turnofflight()
			end),
        },

        events =
        {
            EventHandler("animover", function(inst)
				if inst:HasTag("viperling") then
				inst.attacks = inst.attacks + 1
					if inst:HasTag("viperlingfriend") then
						if inst.attacks >= 8 then
						inst.ShadowDespawn(inst)
						end				
						else
						if inst.attacks >= 2 then
						inst.ShadowDespawn(inst)
						end
					end
				end
                inst.sg:GoToState("idle")
            end),
        },
    },

    State{
        name = "death",
        tags = { "busy" },

        onenter = function(inst)
            inst.AnimState:PlayAnimation("death")
			if not inst:HasTag("viperling") then
            RemovePhysicsColliders(inst)
            inst.components.lootdropper:DropLoot(inst:GetPosition())
			end
			
        end,

        timeline =
        {
            TimeEvent(FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/creatures/worm/retract")
                inst.SoundEmitter:PlaySound("dontstarve/creatures/worm/death")
            end),
        },
        EventHandler("animover", function(inst)
            if inst:HasTag("viperlingfriend") then
			inst:Remove()
			end
        end),
    },

    State{
        name = "hit",
        tags = { "busy", "hit" },

        onenter = function(inst)
            inst.AnimState:PlayAnimation("hit")
        end,

        timeline =
        {	
			
            TimeEvent(FRAMES, function(inst)
			inst.SoundEmitter:PlaySound("dontstarve/creatures/worm/hurt")
	
			end),
			
            TimeEvent(20 * FRAMES, function(inst) 
			inst.SoundEmitter:PlaySound("dontstarve/creatures/worm/retract")
		
			end),
        },

        events =
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle")
            end),
        },
    },

    State{
        name = "walk_start",
        tags = { "moving", "canrotate", "dirt", "invisible" },

        onenter = function(inst)
            inst.components.locomotor:WalkForward()
            inst.AnimState:PlayAnimation("walk_pre")
            if not inst.SoundEmitter:PlayingSound("walkloop") then
                inst.SoundEmitter:PlaySound("dontstarve/creatures/worm/move", "walkloop")
            end
        end,

        events =
        {
            EventHandler("animover", function(inst)
                inst.sg.statemem.walking = true
                inst.sg:GoToState("walk")
            end),
        },

        onexit = function(inst)
            if not inst.sg.statemem.walking then
                inst.SoundEmitter:KillSound("walkloop")
            end
        end,
    },

    State{
        name = "walk",
        tags = { "moving", "canrotate", "dirt", "invisible" },

        onenter = function(inst)
            inst.components.locomotor:WalkForward()
            inst.AnimState:PlayAnimation("walk_loop")
            if not inst.SoundEmitter:PlayingSound("walkloop") then
                inst.SoundEmitter:PlaySound("dontstarve/creatures/worm/move", "walkloop")
            end
        end,

        timeline =
        {
            TimeEvent(0, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/worm/dirt") end),
            TimeEvent(10 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/worm/dirt") end),
            TimeEvent(20 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/worm/dirt") end),
        },

        events =
        {
            EventHandler("animover", function(inst)
                inst.sg.statemem.walking = true
                inst.sg:GoToState("walk")
            end),
        },

        onexit = function(inst)
            if not inst.sg.statemem.walking then
                inst.SoundEmitter:KillSound("walkloop")
            end
        end,
    },

    State{
        name = "walk_stop",
        tags = { "canrotate", "dirt", "invisible" },

        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("walk_pst")
            if not inst.SoundEmitter:PlayingSound("walkloop") then
                inst.SoundEmitter:PlaySound("dontstarve/creatures/worm/move", "walkloop")
            end
        end,

        events =
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle_enter")
            end),
        },

        onexit = function(inst)
            if not inst.sg.statemem.walking then
                inst.SoundEmitter:KillSound("walkloop")
            end
        end,
    },  

    State{
        name = "lure_enter",
        tags = { "invisible", "lure" },

        onenter = function(inst)
		if not inst:HasTag("viperling") then
            inst.Physics:Stop()
			else
			inst.components.locomotor:StopMoving()
		end
            inst.AnimState:PlayAnimation("lure_enter")
            inst.SoundEmitter:KillAllSounds()
            ChangeToLure(inst)
		
        end,

        timeline =
        {
            TimeEvent(FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/worm/lure_emerge") end),
        },

        events =
        {
            EventHandler("animover", function(inst)
                inst.sg.statemem.islure = true
                inst.sg:GoToState("lure", true)
            end),
        },

        onexit = function(inst)
            if not inst.sg.statemem.islure then
                ChangeToWorm(inst)
            end
        end,
    },

    State{
        name = "lure",
        tags = { "invisible", "lure" },

        onenter = function(inst, islure)
		if not inst:HasTag("viperling") then
            inst.Physics:Stop()
			else
			inst.components.locomotor:StopMoving()
		end
            inst.AnimState:PlayAnimation("idle_loop", true)
            inst.SoundEmitter:KillAllSounds()
            if not islure then
                ChangeToLure(inst)
            end
            inst.sg:SetTimeout(GetRandomWithVariance(TUNING.WORM_LURE_TIME, TUNING.WORM_LURE_VARIANCE))
        end,

        ontimeout = function(inst)
            inst.sg.statemem.islure = true
            inst.sg:GoToState("lure_exit", true)
        end,

        onexit = function(inst)
            inst.lastluretime = GetTime()
            if not inst.sg.statemem.islure then
                ChangeToWorm(inst)
            end
        end,
    },

    State{
        name = "lure_exit",
        tags = { "invisible", "lure" },

        onenter = function(inst, islure)
            inst.AnimState:PlayAnimation("lure_exit")
            inst.SoundEmitter:KillAllSounds()
            if not islure then
                ChangeToLure(inst)
            end
			if not inst:HasTag("viperling") then
            inst:turnofflight()
			end
        end,

        timeline =
        {
            TimeEvent(FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/worm/lure_retract") end),
        }, 

        events =
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle_enter")
            end),
        },

        onexit = ChangeToWorm,
    },
}

CommonStates.AddFrozenStates(states)

return StateGraph("viperworm", states, events, "idle", actionhandlers)
