local assets = 
{
}

local function MakeSoul(name, music)
	local function fn()
        local inst = CreateEntity()
        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank("um_records")
        inst.AnimState:SetBuild("um_records")
        inst.AnimState:PlayAnimation(name)

        inst:AddTag("cattoy")
        inst:AddTag("phonograph_record")

        MakeInventoryFloatable(inst, "med", 0.05, 0.68)

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
        	return inst
        end

        inst:AddComponent("inspectable")
		inst.components.inspectable.nameoverride = "RECORD"
		
        inst:AddComponent("tradable")

        inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.atlasname = "images/inventoryimages/"..name..".xml"

        inst:AddComponent("fuel")
        inst.components.fuel.fuelvalue = TUNING.MED_FUEL

        MakeHauntableLaunch(inst) 

        inst.songToPlay = music

        return inst
	end

    return Prefab(name, fn)
end

return MakeSoul("um_record_menu", "UMMusic/gramaphone_record/uncomp_main_menu" ),
	MakeSoul("um_record_walter", "UMMusic/gramaphone_record/follow_me_woby_flat" ),
	MakeSoul("um_record_wixie", "UMMusic/gramaphone_record/wixie_the_delinquent" ),
	MakeSoul("um_record_shadow_wixie", "UMMusic/gramaphone_record/shadow_boxing" ),
	MakeSoul("um_record_hooded_widow", "UMMusic/gramaphone_record/hoodedforest_efs" ),
	MakeSoul("um_record_wathom", "UMMusic/gramaphone_record/wathom_amped" ),
	MakeSoul("um_record_stranger", "UMMusic/gramaphone_record/tiddlestranger" ),
	MakeSoul("um_record_winky", "UMMusic/gramaphone_record/winky" )