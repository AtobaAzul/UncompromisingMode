local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
env.AddPrefabPostInit("forest", function(inst)
    if not TheWorld.ismastersim then
        return
    end
	--[[
    if GetModConfigData("gamemode") == GAMEMODE_UNCOMPROMISING or
	(GetModConfigData("gamemode") == GAMEMODE_CUSTOM_SETTINGS and GetModConfigData("harder_weather") == true) then
    inst:AddComponent("toadrain")
	inst:AddComponent("hayfever_tracker")
	inst:AddComponent("firefallwarning")
	end
	
	inst:AddComponent("gmoosespawner")
	inst:AddComponent("mock_dragonflyspawner")--]]
end)