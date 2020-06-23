local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
local function OnSeasonTick(inst)
	if TheWorld.state.issummer then
		inst.components.worldtemperature:SetTemperatureMod(TUNING.DSTU.CAVES_TEMP_MULT, TUNING.DSTU.CAVES_TEMP_LOCUS)
	else
		inst.components.worldtemperature:SetTemperatureMod(TUNING.CAVES_TEMP_MULT, TUNING.CAVES_TEMP_LOCUS)
	end
end
	
env.AddPrefabPostInit("cave_network", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	inst:DoTaskInTime(0, OnSeasonTick)
	inst:ListenForEvent("seasontick", OnSeasonTick)
end)