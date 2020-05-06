local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
local function DefaultIgniteFn(inst)
    if inst.components.burnable ~= nil then
        inst.components.burnable:StartWildfire()
    end
end

env.AddPrefabPostInit("willow", function(inst)
	if not TheWorld.ismastersim then
		return
	end

	if inst.components.burnable ~= nil then
		inst.components.burnable:SetBurnTime(TUNING.WORMWOOD_BURN_TIME * 2)
		MakeSmallPropagator(inst)
	end
end)