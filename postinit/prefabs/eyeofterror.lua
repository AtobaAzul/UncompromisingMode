local env = env
GLOBAL.setfenv(1, GLOBAL)

local function UpdateCooldown(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	
	local playercount = #TheSim:FindEntities(x, y, z, 40, {"player"}, {"playerghost"}) or 1
	local playerscaling = 10 * (playercount or 1)

	inst._cooldowns.spawn = 50 - playerscaling
	
	if inst._cooldowns.spawn <= 20 then
		inst._cooldowns.spawn = 18
	end
	
	print(inst._cooldowns.spawn)
end

local function OnAttackedTwin1(inst, data)
    if data.attacker and not inst.components.commander:IsSoldier(data.attacker) then
		inst.components.combat:ShareTarget(data.attacker, 50, function(dude)
			local should_share = dude:HasTag("eyeofterror")
				and dude.prefab == "eyeofterror2"
				and not dude.components.health:IsDead()
				
			return should_share
		end, 5)
    end
end

env.AddPrefabPostInit("twinofterror1", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
    inst:ListenForEvent("attacked", OnAttackedTwin1)
	
	inst:DoPeriodicTask(5, UpdateCooldown)
end)

local function OnAttackedTwin2(inst, data)
    if data.attacker and not inst.components.commander:IsSoldier(data.attacker) then
		inst.components.combat:ShareTarget(data.attacker, 50, function(dude)
			local should_share = dude:HasTag("eyeofterror")
				and dude.prefab == "eyeofterror1"
				and not dude.components.health:IsDead()
				
			return should_share
		end, 5)
    end
end
env.AddPrefabPostInit("twinofterror2", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
    inst:ListenForEvent("attacked", OnAttackedTwin2)
	
	inst:DoPeriodicTask(5, UpdateCooldown)
end)