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
	if prefab and item and item:HasTag("antihistamine") and character ~= nil and character ~= "WES" then
			if character ~= "WILSON" and GLOBAL.STRINGS.CHARACTERS[character].DESCRIBE.ANTIHISTAMINE ~= nil then
				ret = ret .."\n".. GLOBAL.STRINGS.CHARACTERS[character].DESCRIBE.ANTIHISTAMINE--(GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.ANTIHISTAMINE or "")--
			else
				ret = ret .."\n".. GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.ANTIHISTAMINE
			end
	end
	
	if prefab and item and item:HasTag("um_durability") and character ~= nil and character ~= "WES" then
			
		item.durabilitystring = GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.DURABILITY_LEVEL
				
		if not inst.prefab == "wilson" and GLOBAL.STRINGS.CHARACTERS[character].DESCRIBE.DURABILITY_LEVEL ~= nil then
			item.durabilitystring = GLOBAL.STRINGS.CHARACTERS[character].DESCRIBE.DURABILITY_LEVEL
		end
				
		local newsection = item.components.fueled ~= nil and item.components.fueled:GetCurrentSection()
		
		if item.components.fueled ~= nil then
			if newsection <= 1 then
				ret = ret .."\n".. item.durabilitystring.QUARTER
			elseif newsection <= 2 then
				ret = ret .."\n".. item.durabilitystring.HALF
			elseif newsection <= 3 then
				ret = ret .."\n".. item.durabilitystring.THREEQUARTER
			elseif newsection <= 4 then
				ret = ret .."\n".. item.durabilitystring.FULL
			end
		end
	end
	
	if prefab and item and item:HasTag("heatrock") and character ~= nil and character ~= "WES" and TUNING.DSTU.INSUL_THERMALSTONE then
		if item.components and item.components.temperature ~= nil then
				
            local winter_insulation, summer_insulation = item.components.temperature:GetInsulation()
			
			item.heatstring = GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.HEATROCK_LEVEL
			
			if not inst.prefab == "wilson" and GLOBAL.STRINGS.CHARACTERS[character].DESCRIBE.HEATROCK_LEVEL ~= nil then
				item.heatstring = GLOBAL.STRINGS.CHARACTERS[character].DESCRIBE.HEATROCK_LEVEL
			end
			
			if GLOBAL.TheWorld.state.issummer then
				if summer_insulation <= 30 then
					ret = ret .."\n".. item.heatstring.TINY
				elseif summer_insulation > 30 and summer_insulation <= 90 then
					ret = ret .."\n".. item.heatstring.SMALL
				elseif summer_insulation > 90 and summer_insulation <= 150 then
					ret = ret .."\n".. item.heatstring.MED
				elseif summer_insulation > 150 and summer_insulation <= 210 then
					ret = ret .."\n".. item.heatstring.LARGE
				elseif summer_insulation > 210 then
					ret = ret .."\n".. item.heatstring.HUGE
				end
			elseif GLOBAL.TheWorld.state.iswinter then
				if winter_insulation <= 30 then
					ret = ret .."\n".. item.heatstring.TINY
				elseif winter_insulation > 30 and winter_insulation <= 90 then
					ret = ret .."\n".. item.heatstring.SMALL
				elseif winter_insulation > 90 and winter_insulation <= 150 then
					ret = ret .."\n".. item.heatstring.MED
				elseif winter_insulation > 150 and winter_insulation <= 210 then
					ret = ret .."\n".. item.heatstring.LARGE
				elseif winter_insulation > 210 then
					ret = ret .."\n".. item.heatstring.HUGE
				end
			else
				if winter_insulation > summer_insulation then
					if winter_insulation <= 30 then
						ret = ret .."\n".. item.heatstring.TINY
					elseif winter_insulation > 30 and winter_insulation <= 90 then
						ret = ret .."\n".. item.heatstring.SMALL
					elseif winter_insulation > 90 and winter_insulation <= 150 then
						ret = ret .."\n".. item.heatstring.MED
					elseif winter_insulation > 150 and winter_insulation <= 210 then
						ret = ret .."\n".. item.heatstring.LARGE
					elseif winter_insulation > 210 then
						ret = ret .."\n".. item.heatstring.HUGE
					end
				else
					if summer_insulation <= 30 then
						ret = ret .."\n".. item.heatstring.TINY
					elseif summer_insulation > 30 and summer_insulation <= 90 then
						ret = ret .."\n".. item.heatstring.SMALL
					elseif summer_insulation > 90 and summer_insulation <= 150 then
						ret = ret .."\n".. item.heatstring.MED
					elseif summer_insulation > 150 and summer_insulation <= 210 then
						ret = ret .."\n".. item.heatstring.LARGE
					elseif summer_insulation > 210 then
						ret = ret .."\n".. item.heatstring.HUGE
					end
				end
			end
		end
	end
	
	
	if prefab and item and item:HasTag("vetsitem") and not inst:HasTag("vetcurse") and character ~= nil and character ~= "WES" then
		item.vetstring = GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.VETSITEM
			
		if not inst.prefab == "wilson" and GLOBAL.STRINGS.CHARACTERS[character].DESCRIBE.VETSITEM ~= nil then
			item.vetstring = GLOBAL.STRINGS.CHARACTERS[character].DESCRIBE.VETSITEM
		end
		
		ret = ret .."\n".. item.vetstring
	end
	
	return ret
end