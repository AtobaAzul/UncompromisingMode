local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

env.AddPrefabPostInit("stalker_atrium", function(inst)
	if not TheWorld.ismastersim then
		return
	end

    local _GetBattleCryString = inst.components.combat.GetBattleCryString

    local function AtriumBattleCry(combat, target)
        local strtbl =
            target ~= nil and
            target:HasTag("wathom") and
            "STALKER_ATRIUM_WATHOM_BATTLECRY" or
            _GetBattleCryString(combat, target)
        return strtbl, math.random(#STRINGS[strtbl])
    end
    
    inst.components.combat.GetBattleCryString = AtriumBattleCry

end)