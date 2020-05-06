local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
local function DefaultIgniteFn(inst)
    if inst.components.burnable ~= nil then
        inst.components.burnable:StartWildfire()
    end
end

env.AddPrefabPostInit("wormwood", function(inst)
	if not TheWorld.ismastersim then
		return
	end

	if inst.components.burnable ~= nil then
		MakeSmallPropagator(inst)
	end
end)