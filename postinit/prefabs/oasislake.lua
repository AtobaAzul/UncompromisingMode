local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
local function OnSeasonTick(inst)
	if TheWorld.state.issummer then
		if inst.components.oasis == nil then
			inst:AddComponent("oasis")
			inst.components.oasis.radius = TUNING.SANDSTORM_OASIS_RADIUS
		end
	else
		if inst.components.oasis then
			inst:RemoveComponent("oasis")
		end
	end
end
	


env.AddPrefabPostInit("mutatedhound", function(inst)
	if not TheWorld.ismastersim then
		return
	end

	inst:ListenForEvent("seasontick", OnSeasonTick)
end)