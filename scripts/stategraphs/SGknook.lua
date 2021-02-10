require("stategraphs/commonstates")

local actionhandlers = 
{
}

local events=
{
    EventHandler("attacked", function(inst) 
        if not inst.components.health:IsDead() and not inst.sg:HasStateTag("attack") and not inst.sg.HasStateTag('busy') then 
            inst.sg:GoToState("hit")  -- can't attack during hit reaction
        end 
    end),
    EventHandler("doattack", function(inst, data) 
        if not inst.components.health:IsDead() and data and data.target and not inst.sg:HasStateTag("attack") then 
        inst.sg:GoToState("attack_pre", data.target) 
        end 
    end),
    EventHandler("death", function(inst) inst.sg:GoToState("death") end),
    CommonHandlers.OnSleep(),
    CommonHandlers.OnFreeze(),
    EventHandler("locomote", function(inst) 
        if not inst.sg:HasStateTag("busy") and not inst.sg:HasStateTag("evade") and not inst.sg:HasStateTag("beinghit")  then
            
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

local states=
{
    
    
    State{
        name = "death",
        tags = {"busy","dying"},
        
        onenter = function(inst)
			inst.Physics:Stop()
			RemovePhysicsColliders(inst) 
            inst.AnimState:PlayAnimation("death")
            inst.components.lootdropper:DropLoot(Vector3(inst.Transform:GetWorldPosition()))
			inst.SoundEmitter:PlaySound("dontstarve/creatures/knight_nightmare/death")
			inst.SoundEmitter:PlaySound("dontstarve/creatures/rook_nightmare/death")
			
        end,
		timeline=
        {
        },
        events=
        {
            EventHandler("animover", function(inst)  end),
        },
    },    
    
    State{
        name = "premoving",
        tags = {"moving", "canrotate"},
        
        onenter = function(inst)
            inst.Physics:Stop()
			if inst.components.combat.target ~= nil then
			inst.AnimState:PlayAnimation("jump_pre")
			else
			inst.AnimState:PlayAnimation("jump_pre")
			end
        end,
        
        timeline=
        {
            TimeEvent(3*FRAMES, PlayFootstep),
        },
        
        events=
        {
            EventHandler("animover", function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/rook_nightmare/rattle")
			if inst.components.combat.target ~= nil then
			inst.sg:GoToState("aggresivehop")
			else
			inst.sg:GoToState("moving")
			end end),
        },
    },
    
    State{
        name = "moving",
        tags = {"moving", "canrotate"},
        
        onenter = function(inst)
			inst.components.locomotor:WalkForward()
			inst.components.locomotor.walkspeed = 4
            inst.AnimState:PlayAnimation("jump")
        end,
        
        timeline=
        {
		TimeEvent(3*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/knight_nightmare/bounce") end),
		TimeEvent(16*FRAMES, function(inst) inst.Physics:Stop() end),
        },
        
        events=
        {
            EventHandler("animover", function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/knight_nightmare/land")
			inst.sg:GoToState("premoving") end),
        },
        
    },   
     State{
        name = "aggresivehop",
        tags = {"moving","attack"},
        
        onenter = function(inst)
			inst.components.locomotor:WalkForward()
            inst.AnimState:PlayAnimation("bigjump")
			inst.components.locomotor.walkspeed = 8
        end,
        
        timeline=
        {
		TimeEvent(3*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/knight_nightmare/bounce") end),
		TimeEvent(15*FRAMES, function(inst) inst.Physics:Stop() 
		if inst.components.combat.target ~= nil then
		local cooldown = inst.components.combat.laststartattacktime
		inst.components.combat:DoAreaAttack(inst, 2, nil, nil, nil, { "INLIMBO", "notarget", "invisible", "noattack", "chess", "playerghost", "shadow", "shadowchesspiece", "shadowcreature", "shadowminion" })
		--SpawnPrefab("ground_chunks_breaking").Transform:SetPosition(inst.Transform:GetWorldPosition())
		--SpawnPrefab("ground_chunks_breaking").Transform:SetPosition(inst.Transform:GetWorldPosition())
		inst:DoTaskInTime(0.3,function(inst, cooldown) inst.components.combat.laststartattacktime = cooldown end)
		end end),
        },
        
        events=
        {
            EventHandler("animover", function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/knight_nightmare/land")
			inst.sg:GoToState("premoving") end),
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
            if math.random() < 1 then
				inst.sg:SetTimeout(math.random()*2 + 1)
			end

            if start_anim then
                inst.AnimState:PlayAnimation(start_anim)
                inst.AnimState:PushAnimation("idle", true)
            else
                inst.AnimState:PlayAnimation("idle", true)
            end

        end,
        timeline = 
        {
		    TimeEvent(21*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/knight_nightmare/idle")
			inst.SoundEmitter:PlaySound("dontstarve/creatures/bishop_nightmare/idle") end ),
        },
    },
    State{
        name = "waken",
        tags = {"idle", "busy"},
        

        onenter = function(inst)
			inst.Transform:SetNoFaced()
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("waken")
        end,
        timeline=
        {
		TimeEvent(3*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/knight_nightmare/bounce") end),
		TimeEvent(12*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/rook_nightmare/rattle") end),
		TimeEvent(20*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/rook_nightmare/rattle") end),
        },
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle")
				inst.Transform:SetFourFaced() end),
        },
    },
    State{
        name = "zombie",
        tags = {"idle", "busy"},
        

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("zombie")
        end,
        timeline=
        {
		TimeEvent(3*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/knight_nightmare/bounce")
		SpawnPrefab("ground_chunks_breaking").Transform:SetPosition(inst.Transform:GetWorldPosition())end),
		TimeEvent(5*FRAMES, function(inst) SpawnPrefab("ground_chunks_breaking").Transform:SetPosition(inst.Transform:GetWorldPosition()) end),
		TimeEvent(7*FRAMES, function(inst) SpawnPrefab("ground_chunks_breaking").Transform:SetPosition(inst.Transform:GetWorldPosition()) end),
		TimeEvent(12*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/rook_nightmare/rattle") end),
		TimeEvent(20*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/rook_nightmare/rattle") end),
        },
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle")
				inst.Transform:SetFourFaced() end),
        },
    },

    State{
        name = "taunt",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("taunt")
            inst.SoundEmitter:PlaySound("dontstarve/creatures/knight_nightmare/voice")
            inst.SoundEmitter:PlaySound("dontstarve/creatures/rook_nightmare/voice")
        end,
        timeline = 
        {
		    TimeEvent(8*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/knight_nightmare/pawground") end ),
		    TimeEvent(15*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/knight_nightmare/pawground") end ),
        },        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },    
    
     State{
        name = "attack_pre",
        tags = {"attack", "busy", "no_stun"},
        
        onenter = function(inst, target)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("atk_pre")
        end,
        
        timeline=
        {   
			TimeEvent(6*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/knight_nightmare/bounce") end),
			--TimeEvent(22*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/knight_nightmare/attack") end),
        },
        
        events=
        {
            EventHandler("animover", function(inst) 
			if math.random() > 0.35 then 
			inst.sg:GoToState("attack")
			else
			inst.sg:GoToState("aggresivehop")
			end
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
			TimeEvent(1*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/knight_nightmare/bounce") end),
			TimeEvent(6*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/knight_nightmare/attack") end),
            TimeEvent(7*FRAMES, function(inst) inst.components.combat:DoAttack(inst.sg.statemem.target) 
			inst.SoundEmitter:PlaySound("dontstarve/creatures/rook_nightmare/rattle") 
					if inst.components.combat.target ~= nil and inst.components.combat:CanHitTarget(inst.components.combat.target) then--distsq(target:GetPosition(), inst:GetPosition()) <= 10 then
					--Don't knockback if you wear marble
					local target = inst.components.combat.target
					if target ~= nil and target.components.inventory ~= nil and not target:HasTag("fat_gang") and not target:HasTag("foodknockbackimmune") and not (target.components.rider ~= nil and target.components.rider:IsRiding()) and 
					--Don't knockback if you wear marble
					(target.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY) ==nil or not target.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY):HasTag("marble") and not target.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY):HasTag("knockback_protection")) then
						target:PushEvent("knockback", {knocker = inst, radius = 150, strengthmult = 1})
					end
				end
				end),
        },
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State{
        name = "hit",
        tags = {"beinghit"},      
        onenter = function(inst)
            inst.AnimState:PlayAnimation("hit")
            inst.Physics:Stop()   
			inst.SoundEmitter:PlaySound("dontstarve/creatures/knight_nightmare/hurt")
			inst.SoundEmitter:PlaySound("dontstarve/creatures/rook_nightmare/hurt")
        end,
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end ),
        },
    },    
    
}
CommonStates.AddSleepStates(states,
{
    starttimeline = 
    {
		TimeEvent(11*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/knight_nightmare/liedown") end ),
    },
    
	sleeptimeline = {
        TimeEvent(18*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/knight_nightmare/sleep")
			inst.SoundEmitter:PlaySound("dontstarve/creatures/rook_nightmare/sleep") end),
	},
})
CommonStates.AddFrozenStates(states)

return StateGraph("knook", states, events, "idle", actionhandlers)

