local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddStategraphPostInit("pig", function(inst)

local events =
{	
    EventHandler("doattack", function(inst, data) 
        if (inst:HasTag("pig") or inst:HasTag("pigguard")) and not data.target:HasTag("werepig") then
            inst.sg:GoToState("refuse", data.target)
            inst.components.combat:SetTarget(nil)
		else
			local nstate = "attack"
			if inst.sg:HasStateTag("charging") then
				nstate = "charge_attack"
			end
			if inst.components.health and not inst.components.health:IsDead()
			   and not inst.sg:HasStateTag("busy") then
				inst.sg:GoToState(nstate)
			end
            --inst.sg:GoToState("attack", data.target)
        end
    end),
	
	
	EventHandler("attacked", function(inst)
		
		if not inst:HasTag("manrabbit") and (inst:HasTag("pig") or inst:HasTag("pigguard")) and not inst:HasTag("werepig") and inst.components.health ~= nil and not inst.components.health:IsDead() then
			if inst.counter ~= nil and inst.counter >= 3 then
				inst.counter = 0
				inst.sg:GoToState("counterattack_pre")
				return
			else
				if inst.counter ~= nil then
					inst.counter = inst.counter + 1
					if inst.countertask ~= nil then
						inst.countertask:Cancel()
						inst.countertask = nil
					end
					inst.countertask = inst:DoTaskInTime(10, function(inst) inst.counter = 0 end)
				else
					inst.counter = 0
				end
			end
		end
	
		if inst.components.health ~= nil and not inst.components.health:IsDead()
		and (not inst.sg:HasStateTag("busy") or
		inst.sg:HasStateTag("caninterrupt") or
		inst.sg:HasStateTag("frozen")) then
			inst.sg:GoToState("hit")
		end
	
	end),
    
    
}

local states = {
	State{
        name = "counterattack_pre",
        tags = { "attack", "busy" },

        onenter = function(inst)
            inst.SoundEmitter:PlaySound("dontstarve/pig/attack")
            inst.components.combat:StartAttack()
            inst.Physics:Stop()
            inst.sg:SetTimeout(0.5)
            inst.AnimState:PlayAnimation("idle_angry")
        end,

        ontimeout= function(inst)
            inst.sg:GoToState("counterattack")
        end,

        events =
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("counterattack")
            end),
        },
    },
	
	State{
        name = "counterattack",
        tags = { "attack", "busy" },

        onenter = function(inst)
            inst.SoundEmitter:PlaySound("dontstarve/pig/attack")
            inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_whoosh")
            inst.components.combat:StartAttack()
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("counter_atk")
        end,

        timeline =
        {
            TimeEvent(9 * FRAMES, function(inst)
				local target = inst.components.combat.target
				
				if target ~= nil and distsq(target:GetPosition(), inst:GetPosition()) <= inst.components.combat:CalcAttackRangeSq(target) then
					target:PushEvent("attacked", { attacker = inst, damage = inst.components.combat.defaultdamage / 1.5} )
					
					if target ~= nil and target.components.inventory ~= nil and not target:HasTag("fat_gang") and not target:HasTag("foodknockbackimmune") and not (target.components.rider ~= nil and target.components.rider:IsRiding()) and 
					--Don't knockback if you wear marble
					(target.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY) ==nil or not target.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY):HasTag("marble") and not target.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY):HasTag("knockback_protection")) then
						target:PushEvent("knockback", {knocker = inst, radius = 150, strengthmult = 1})
					end
				end
				
                inst.sg:RemoveStateTag("attack")
                inst.sg:RemoveStateTag("busy")
            end),
        },

        events =
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("charge_pre")
            end),
        },
    },
	
	State{
        name = "charge_antic_pre",
        tags = {"attack", "busy", "moving", "charging", "busy", "atk_pre", "canrotate"},

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("paw_pre")
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("charge_antic_loop") end),
        },
    },

    State{
        name = "charge_antic_loop",
        tags = {"attack", "busy", "moving", "charging", "busy", "atk_pre", "canrotate"},

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("paw_loop", true)
            inst.sg:SetTimeout(1.5)
        end,

        ontimeout= function(inst)
            inst.sg:GoToState("charge_pre")
            inst:PushEvent("attackstart" )
        end,
    },

    State{
        name = "charge_pre",
        tags = {"busy", "charging", "moving", "running"},

        onenter = function(inst)
            inst.components.locomotor:RunForward()
            inst.AnimState:PlayAnimation("charge_pre")
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("charge_loop") end),
        },
    },

    State{
        name = "charge_loop",
        tags = {"charging", "moving", "running"},

        onenter = function(inst)
			inst.components.locomotor.runspeed = TUNING.PIG_RUN_SPEED + 8
			inst.components.locomotor.walkspeed = TUNING.PIG_WALK_SPEED + 8
			
            inst.components.locomotor:WalkForward()
            inst.AnimState:PlayAnimation("charge_loop")
			
        end,

        onexit = function(inst)
			inst.components.locomotor.runspeed = TUNING.PIG_RUN_SPEED
			inst.components.locomotor.walkspeed = TUNING.PIG_WALK_SPEED
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("charge_attack") end),
        },
    },

    State{
        name = "charge_pst",
        tags = {"canrotate", "idle"},

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("charge_pst")
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State{
        name = "charge_attack",
        tags = {"chargingattack"},

        onenter = function(inst)
            inst.components.combat:StartAttack()
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("charge_atk")
            inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/wild_boar/charge_attack")
        end,

        timeline =
        {
            TimeEvent(12*FRAMES, function(inst) 
                inst.components.combat:DoAttack()
                inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_whoosh")
            end),
        },

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("attack") end),
        },
    }
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