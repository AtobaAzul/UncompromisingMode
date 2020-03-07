local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
env.AddPrefabPostInit("moose", function(inst)

	if not TheWorld.ismastersim then
		return
	end
	
	if inst.components.combat ~= nil then
		local function isnotmossling(ent)
			if ent ~= nil and not ent:HasTag("mossling")then -- fix to friendly AOE: refer for later AOE mobs -Axe
				return true
			end
		end
        inst.components.combat:SetAreaDamage(TUNING.DEERCLOPS_AOE_RANGE/2, TUNING.DEERCLOPS_AOE_SCALE, isnotmossling) -- you can edit these values to your liking -Axe
	end       

	if inst.components.combat ~= nil then
		inst.components.combat:SetRange(TUNING.MOOSE_ATTACK_RANGE * 1.1)
	end
end)