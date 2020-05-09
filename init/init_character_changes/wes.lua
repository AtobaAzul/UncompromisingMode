AddPrefabPostInit("wes", function(inst) 
	if not GLOBAL.TheWorld.ismastersim then
		return
	end
	inst:AddTag("the_mime")
end)