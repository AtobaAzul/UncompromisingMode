AddPrefabPostInit("wolfgang", function(inst) 
	if not TheWorld.ismastersim then
		return
	end
	inst:AddTag("the_mime")
end)