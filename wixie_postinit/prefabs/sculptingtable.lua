local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddPrefabPostInit("sculptingtable", function(inst)
	if not TheWorld.ismastersim then
		return
	end

	if inst.components.pickable ~= nil then
		local _Oldonitemtaken = inst.components.pickable.onpickedfn
		
		inst.components.pickable.onpickedfn = function(inst, picker, loot)
			local final_picker = picker
		
			if picker ~= nil and not picker.components.inventory then
				final_picker = nil
			end
				
			return _Oldonitemtaken(inst, final_picker, loot)
		end
	end
end)