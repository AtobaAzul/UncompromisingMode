local env = env
GLOBAL.setfenv(1, GLOBAL)

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
end)