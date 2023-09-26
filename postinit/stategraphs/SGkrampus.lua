local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddStategraphPostInit("krampus", function(inst)

local events =
{
	EventHandler("doattack", function(inst)
		if not inst.components.health:IsDead() and
		(inst.sg:HasStateTag("hit") or not
		inst.sg:HasStateTag("busy")) then
			if inst.counter ~= nil and inst.counter >= 3 then
				inst.counter = 0
				inst.sg:GoToState("feint_attack")
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
			inst.sg:GoToState("attack")
		end
	end),
}

local function LaunchItem(inst, target, item)
    if item.Physics ~= nil and item.Physics:IsActive() then
        local x, y, z = item.Transform:GetWorldPosition()
        item.Physics:Teleport(x, .1, z)

        x, y, z = inst.Transform:GetWorldPosition()
        local x1, y1, z1 = target.Transform:GetWorldPosition()
        local angle = math.atan2(z1 - z, x1 - x) + (math.random() * 20 - 10) * DEGREES
        local speed = 5 + math.random() * 2
        item.Physics:SetVel(math.cos(angle) * speed, 10, math.sin(angle) * speed)
    end
end

local states = {
	State{
        name = "feint_attack",
        tags = {"attack"},

        onenter = function(inst, cb)
            inst.Physics:Stop()
            inst.components.combat:StartAttack()
            inst.AnimState:PlayAnimation("atk_pre")
            inst.AnimState:PushAnimation("atk", false)
        end,

        timeline=
        {
            TimeEvent(0*FRAMES, function(inst) inst:PerformBufferedAction() inst.SoundEmitter:PlaySound("dontstarve/creatures/krampus/attack") end),
            TimeEvent(14*FRAMES, function(inst) inst:PerformBufferedAction() inst.SoundEmitter:PlaySound("dontstarve/creatures/krampus/kick_whoosh") end),
            TimeEvent(18*FRAMES, function(inst) inst.components.combat:DoAttack() end),
        },

        events=
        {
            EventHandler("animqueueover", function(inst)inst.sg:GoToState("counterattack_pre") end),
        },
    },

	State{
        name = "counterattack_pre",
        tags = { "attack", "busy" },

        onenter = function(inst)
            inst.SoundEmitter:PlaySound("dontstarve/creatures/krampus/growlshort")
            inst.components.combat:StartAttack()
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("b_s_p")
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
            inst.SoundEmitter:PlaySound("dontstarve/creatures/krampus/growllong")
            inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_whoosh")
            inst.components.combat:StartAttack()
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("bs_s")
        end,

        timeline =
        {
			TimeEvent(5 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/krampus/bag_swing") end),
            TimeEvent(8 * FRAMES, function(inst)
                
				local x, y, z = inst:GetPosition():Get()
			
				local ents = TheSim:FindEntities(x, y, z, 5, nil, {"deergemresistance", "snowish", "ghost", "playerghost", "shadow", "INLIMBO"})
				for i, v in ipairs(ents) do
					if v.components.combat ~= nil then
						v.components.combat:GetAttacked(inst, 50, nil)
					end
					
					--inst.SoundEmitter:PlaySound("dontstarve/creatures/krampus/bag_drop")
					--inst.SoundEmitter:PlaySound("dontstarve/creatures/krampus/bag_foley")
					inst.SoundEmitter:PlaySound("dontstarve/creatures/krampus/bag_swing")
					
					if v ~= nil and v.components.inventory ~= nil then 
						if not v:HasTag("stronggrip") then
							local item = v.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
							if item ~= nil then
								v.components.inventory:DropItem(item)
								LaunchItem(inst, v, item)
							end
						end
						
						if inst.components.thief ~= nil then
							for i = 1, 3 do
								inst.components.thief:StealItem(v)
							end
						end
					
						if not v:HasTag("fat_gang") and not v:HasTag("foodknockbackimmune") and not (v.components.rider ~= nil and v.components.rider:IsRiding()) and 
							--Don't knockback if you wear marble
							(v.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY) ==nil or not v.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY):HasTag("marble") and not v.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY):HasTag("knockback_protection")) then
								v:PushEvent("knockback", {knocker = inst, radius = 150, strengthmult = 1.5})
						end
					end
				end
            end),
        },

        events =
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle")
            end),
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