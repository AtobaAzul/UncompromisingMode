--BeeQueen now has AOE -Axe
AddPrefabPostInit("beequeen", function (inst)
    if inst ~= nil and inst.components ~= nil and inst.components.combat ~= nil then
		local function isnotbee(ent)
			if ent ~= nil and not ent:HasTag("bee") and not ent:HasTag("hive") then -- fix to friendly AOE: refer for later AOE mobs -Axe
				return true
			end
		end
        inst.components.combat:SetAreaDamage(TUNING.DEERCLOPS_AOE_RANGE/2, TUNING.DEERCLOPS_AOE_SCALE, isnotbee) -- you can edit these values to your liking -Axe
    end                                     
end)
--Treeguard now has AOE - Axe
AddPrefabPostInit("leif", function (inst)
    if inst ~= nil and inst.components ~= nil and inst.components.combat ~= nil then
		local function isnottree(ent)
			if ent ~= nil and not ent:HasTag("leif") then -- fix to friendly AOE: refer for later AOE mobs -Axe
				return true
			end
		end
        inst.components.combat:SetAreaDamage(TUNING.DEERCLOPS_AOE_RANGE/2, TUNING.DEERCLOPS_AOE_SCALE, isnottree) -- you can edit these values to your liking -Axe
    end                                     
end)