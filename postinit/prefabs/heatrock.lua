--[[
	Normally, Thermal Stones have 120 insulation. Now they have 60, but inherit half the player's insulation.
	This means they're just as powerful as before if you wear a Winter Hat or a Tam O'Shanter, but benefit
	further if you equip high insulation clothing such as a Beefalo Hat, or use both head and body slots
	for insulation. --KoreanWaffles
]]

AddPrefabPostInit("heatrock", function(inst)
    local base_insulation = GLOBAL.TUNING.INSULATION_SMALL --60 insulation
    inst.components.temperature.inherentinsulation = base_insulation
    inst.components.temperature.inherentsummerinsulation = base_insulation
    
    local function CalculateInsulation()
        local owner = inst.components.inventoryitem.owner
        if owner and owner.components.temperature then
            local winter_insulation, summer_insulation = owner.components.temperature:GetInsulation()
            inst.components.temperature.inherentinsulation = base_insulation + winter_insulation / 2
            inst.components.temperature.inherentsummerinsulation = base_insulation + summer_insulation / 2
        else
            inst.components.temperature.inherentinsulation = base_insulation
            inst.components.temperature.inherentsummerinsulation = base_insulation
        end
    end
    
    inst:ListenForEvent("temperaturedelta", CalculateInsulation)
end)