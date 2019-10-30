local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
env.AddPrefabPostInit("deerclops", function(inst)
	local function GetHeatFn(inst)
		return -40
	end

	if not TheWorld.ismastersim then
		return
	end
	
	inst:RemoveComponent("freezable")
	
	inst:AddComponent("heater")
    inst.components.heater.heatfn = GetHeatFn
    inst.components.heater:SetThermics(false, true)
	
	inst:AddComponent("groundpounder")
	inst.components.groundpounder.destroyer = true
	inst.components.groundpounder.damageRings = 2
    inst.components.groundpounder.destructionRings = 2
    inst.components.groundpounder.platformPushingRings = 2
    inst.components.groundpounder.numRings = 3
	inst.components.groundpounder.groundpoundfx = "deerclops_ground_fx"
end)