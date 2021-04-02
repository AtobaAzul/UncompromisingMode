AddPrefabPostInit("wes", function(inst) 
	if not GLOBAL.TheWorld.ismastersim then
		return
	end
	inst:AddTag("the_mime")
    --inst.components.hunger:SetRate(TUNING.WILSON_HUNGER_RATE * 1.25)
end)