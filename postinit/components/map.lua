local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddPrefabPostInit("world", function(inst)
	local Map = getmetatable(inst.Map).__index
	local _IsDeployPointClear = Map.IsDeployPointClear
	Map.IsDeployPointClear = function(Map, pt, inst, min_spacing, min_spacing_sq_fn, near_other_fn, check_player, custom_ignore_tags)
		
		if pt ~= nil and pt.x ~= nil then
			local x = pt.x
			local z = pt.z
			
			local portaboat = TheSim:FindEntities(x, 0, z, 4, {"portableraft"})
			if portaboat ~= nil and #portaboat > 0 then
				return false
			end
		end

		return _IsDeployPointClear(Map, pt, inst, min_spacing, min_spacing_sq_fn, near_other_fn, check_player, custom_ignore_tags)
	end
end)