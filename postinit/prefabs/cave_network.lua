local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
local function OnSeasonTick(inst)
	if TheWorld.state.issummer then
		inst.components.worldtemperature:SetTemperatureMod(TUNING.DSTU.SUMMER_CAVES_TEMP_MULT, TUNING.CAVES_TEMP_LOCUS)
	elseif TheWorld.state.iswinter then
		inst.components.worldtemperature:SetTemperatureMod(TUNING.DSTU.WINTER_CAVES_TEMP_MULT, TUNING.CAVES_TEMP_LOCUS)
	else
		inst.components.worldtemperature:SetTemperatureMod(TUNING.CAVES_TEMP_MULT, TUNING.CAVES_TEMP_LOCUS)
	end
end
	
env.AddPrefabPostInit("cave_network", function(inst)
	if not TheWorld.ismastersim then
		return
	end

	inst:DoTaskInTime(0, OnSeasonTick)
	inst:ListenForEvent("ms_playerjoined", OnSeasonTick)
	inst:ListenForEvent("seasontick", OnSeasonTick)
end)