
local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
local function OnDropped(inst)
	inst.hasTail = false
    --inst.sg:GoToState("stunned")
end

env.AddPrefabPostInit("grassgekko", function(inst)

	if not TheWorld.ismastersim then
		return
	end
	
	inst:AddTag("canbetrapped")
	inst:AddTag("animal")
	inst.components.lootdropper:AddChanceLoot("dug_grass",1.00)
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/grassgekko.xml"
    inst.components.inventoryitem.nobounce = true
    inst.components.inventoryitem.canbepickedup = false
    inst.components.inventoryitem.canbepickedupalive = true
    inst.components.inventoryitem:SetSinks(true)
	
	MakeFeedableSmallLivestock(inst, TUNING.RABBIT_PERISH_TIME, nil, OnDropped)
end)
