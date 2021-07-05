local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddStategraphPostInit("walrus", function(inst)

local function PlayCreatureSound(inst, sound, creature)
    local creature = creature or inst.soundgroup or inst.prefab
    inst.SoundEmitter:PlaySound("dontstarve/creatures/" .. creature .. "/" .. sound)
end

local events=
{
	EventHandler("attacked", function(inst)
		if not inst.components.health:IsDead() and not inst.sg:HasStateTag("attack") then
			if inst.counter ~= nil and inst.counter >= 3 then
				inst.counter = 0
				inst.sg:GoToState("counterattack")
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
			
			if not inst.components.health:IsDead() and not inst.sg:HasStateTag("attack") then
				inst.sg:GoToState("hit")
			end
		end
	end)
}

local states = {
	State{
        name = "throw_trap_pre",
        tags = { "attack", "busy" },

        onenter = function(inst)
            PlayCreatureSound(inst, "taunt")
            inst.components.combat:StartAttack()
            inst.Physics:Stop()
            inst.sg:SetTimeout(0.5)
            inst.AnimState:PlayAnimation("idle_angry")
        end,

        ontimeout= function(inst)
            inst.sg:GoToState("throw_trap")
        end,

        events =
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("throw_trap")
            end),
        },
    },
	
	State{
		name = "throw_trap",
        tags = { "attack", "busy", "canrotate" },

        onenter = function(inst, cb)
            PlayCreatureSound(inst, "attack")
            inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_whoosh")
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("atk")
			inst.spitweb = false
			
			local target = inst.components.combat.target ~= nil and inst.components.combat.target or nil
			
			if target ~= nil and target.Transform ~= nil then
				inst:ForceFacePoint(target.Transform:GetWorldPosition())
			end
        end,

		timeline=
        {
            TimeEvent(20*FRAMES, function(inst)
				local target = inst.components.combat.target ~= nil and inst.components.combat.target or nil
			
				if target ~= nil and target.Transform ~= nil then
					inst:ForceFacePoint(target.Transform:GetWorldPosition())
				end
				
				inst.LaunchTrap(inst, inst.components.combat.target)
			end),
        },

        events=
        {
			EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },
	
	State{
		name = "drop_trap",
        tags = { "attack", "busy" },

        onenter = function(inst, cb)
            PlayCreatureSound(inst, "attack")
            inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_whoosh")
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("pig_pickup")
			inst.spitweb = false
        end,

		timeline=
        {
            TimeEvent(20*FRAMES, function(inst)
				local x, y, z = inst.Transform:GetWorldPosition()
				SpawnPrefab("um_bear_trap").Transform:SetPosition(x, 0, z)
			end),
        },

        events=
        {
			EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State{
        name = "counterattack",
        tags = {"attack"},
        
        onenter = function(inst)
            PlayCreatureSound(inst, "attack")
            inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_whoosh")
            inst.components.combat:StartAttack()
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("atk")
        end,
        
        timeline =
        {
            TimeEvent(20*FRAMES, function(inst) 
				local target = inst.components.combat.target
                
				if target ~= nil then
					local range = inst.prefab == "little_walrus" and 4 or 5
					local physrange = target ~= nil and target:GetPhysicsRadius(0) + range or 0
					local finalrange = physrange * physrange
					if distsq(target:GetPosition(), inst:GetPosition()) <= finalrange then
						target:PushEvent("attacked", { attacker = inst, damage = inst.components.combat.defaultdamage / 1.5 })
					
						if target ~= nil and target.components.inventory ~= nil and not target:HasTag("fat_gang") and not target:HasTag("foodknockbackimmune") and not (target.components.rider ~= nil and target.components.rider:IsRiding()) and 
						--Don't knockback if you wear marble
						(target.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY) ==nil or not target.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY):HasTag("marble") and not target.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY):HasTag("knockback_protection")) then
							target:PushEvent("knockback", {knocker = inst, radius = 8 * inst.components.combat.defaultdamage, strengthmult = 1.25})
						end
					end
				end
			end),
        },
        
        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },
	
	State{
        name = "taunt_newtarget", -- i don't want auto-taunt in combat
        tags = {"busy"},
        
        onenter = function(inst)
            inst.Physics:Stop()
			if TheWorld.state.issummer then
				inst.AnimState:PlayAnimation("idle_happy")
			else
				inst.AnimState:PlayAnimation("abandon")
			end
            PlayCreatureSound(inst, "taunt")
        end,
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },
	
	State{
        name = "taunt_attack",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.components.combat:StartAttack() -- reset combat attack timer
            inst.Physics:Stop()
			if TheWorld.state.issummer then
				inst.AnimState:PlayAnimation("idle_happy")
			else
				inst.AnimState:PlayAnimation("abandon")
			end
            PlayCreatureSound(inst, "taunt")
        end,
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
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