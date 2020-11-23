local require = GLOBAL.require
GLOBAL.require("stringutil")
local _GetDescription = GLOBAL.GetDescription
GLOBAL.GetDescription = function(inst, item, ...)
	local character =
        type(inst) == "string"
        and inst
        or (inst ~= nil and inst.prefab or nil)

    character = character ~= nil and string.upper(character) or nil
		
	local ret = _GetDescription(inst, item, ...)
	local prefab = item and item.prefab
	if prefab and item and item:HasTag("antihistamine") and character ~= nil then
		if not inst.prefab == "wilson" and GLOBAL.STRINGS.CHARACTERS[character].DESCRIBE.ANTIHISTAMINE ~= nil then
			ret = ret .."\n".. GLOBAL.STRINGS.CHARACTERS[character].DESCRIBE.ANTIHISTAMINE--(GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.ANTIHISTAMINE or "")--
		else
			ret = ret .."\n".. "It's useful for ailing a stuffy nose!"
		end
	end
	
	if prefab and item and item:HasTag("heatrock") and character ~= nil then
		if item.components and item.components.temperature ~= nil then
				
			item.currentheat = item.components.temperature:GetInsulation()
			
			item.heatstring = GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.HEATROCK_LEVEL
			
			if not inst.prefab == "wilson" and GLOBAL.STRINGS.CHARACTERS[character].DESCRIBE.HEATROCK_LEVEL ~= nil then
				item.heatstring = GLOBAL.STRINGS.CHARACTERS[character].DESCRIBE.HEATROCK_LEVEL
			end
			
			if item.currentheat < 60 then
				ret = ret .."\n".. item.heatstring.TINY
			elseif item.currentheat >= 60 and item.currentheat < 120 then
				ret = ret .."\n".. item.heatstring.SMALL
			elseif item.currentheat >= 120 and item.currentheat < 180 then
				ret = ret .."\n".. item.heatstring.MED
			elseif item.currentheat >= 180 and item.currentheat < 240 then
				ret = ret .."\n".. item.heatstring.LARGE
			elseif item.currentheat >= 240 then
				ret = ret .."\n".. item.heatstring.HUGE
			end
		end
	end
		
	return ret
end