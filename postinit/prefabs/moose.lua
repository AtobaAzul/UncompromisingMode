local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
local function SuperHop(inst, data)
    if data.name == "SuperHop" then
        inst.superhop = true
    end
end

env.AddPrefabPostInit("moose", function(inst)

	if not TheWorld.ismastersim then
		return
	end
	
	if inst.components.combat ~= nil then
		local function isnotmossling(ent)
			if ent ~= nil and not ent:HasTag("mossling") and not ent:HasTag("moose")then -- fix to friendly AOE: refer for later AOE mobs -Axe
				return true
			end
		end
        inst.components.combat:SetAreaDamage(TUNING.DEERCLOPS_AOE_RANGE/2, TUNING.DEERCLOPS_AOE_SCALE, isnotmossling) -- you can edit these values to your liking -Axe
	end       

	if inst.components.combat ~= nil then
		inst.components.combat:SetRange(TUNING.MOOSE_ATTACK_RANGE * 1.1)
	end
	
    inst:AddComponent("groundpounder")
    inst.components.groundpounder.destroyer = false
    inst.components.groundpounder.damageRings = 2
    inst.components.groundpounder.destructionRings = 2
    inst.components.groundpounder.platformPushingRings = 2
    inst.components.groundpounder.numRings = 2
	
	inst.superhop = true
	
	inst:AddComponent("timer")
    inst:ListenForEvent("timerdone", SuperHop)
end)

env.AddPrefabPostInit("mothergoose", function(inst)

	if not TheWorld.ismastersim then
		return
	end
	
	if inst.components.combat ~= nil then
		local function isnotmossling(ent)
			if ent ~= nil and not ent:HasTag("mossling") and not ent:HasTag("moose")then -- fix to friendly AOE: refer for later AOE mobs -Axe
				return true
			end
		end
        inst.components.combat:SetAreaDamage(TUNING.DEERCLOPS_AOE_RANGE/2, TUNING.DEERCLOPS_AOE_SCALE, isnotmossling) -- you can edit these values to your liking -Axe
	end       

	if inst.components.combat ~= nil then
		inst.components.combat:SetRange(TUNING.MOOSE_ATTACK_RANGE * 1.1)
	end
	
    inst:AddComponent("groundpounder")
    inst.components.groundpounder.destroyer = false
    inst.components.groundpounder.damageRings = 2
    inst.components.groundpounder.destructionRings = 2
    inst.components.groundpounder.platformPushingRings = 2
    inst.components.groundpounder.numRings = 2
	
	inst.superhop = true
	
	inst:AddComponent("timer")
    inst:ListenForEvent("timerdone", SuperHop)
end)