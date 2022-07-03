local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
if env.GetModConfigData("wigfrid") then
	env.AddPrefabPostInit("wathgrithr", function(inst) 
		if not TheWorld.ismastersim then
			return
		end

		if inst.components.battleborn ~= nil then
			inst.components.battleborn.clamp_min = 0.11
			inst.components.battleborn.clamp_max = 0.66
		end
	end)
end
