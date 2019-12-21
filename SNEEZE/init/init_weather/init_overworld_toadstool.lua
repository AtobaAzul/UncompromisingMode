AddPrefabPostInit("forest_network",function()
	-- TODO check that we are in forest
	if GLOBAL.TheWorld.ismastersim then
		if not GLOBAL.TheWorld.components.toadstoolspawner then
			GLOBAL.TheWorld:AddComponent("toadstoolspawner")
		end
	end
end)