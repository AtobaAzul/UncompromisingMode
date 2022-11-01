require "prefabs/winter_ornaments"

local function OnUnwrapped(inst)
	if inst.size ~= nil then
		if inst.size == 1 then
		inst.components.lootdropper:AddChanceLoot("hat_bagmask",    1.00)
		inst.components.lootdropper:AddChanceLoot("halloweencandy_1",    1.00)
		inst.components.lootdropper:AddChanceLoot("halloweencandy_14",    1.00)
		end
		if inst.size == 2 then
		inst.components.lootdropper:AddChanceLoot("hat_blackcatmask",    1.00)
		inst.components.lootdropper:AddChanceLoot("halloweencandy_2",    1.00)
		inst.components.lootdropper:AddChanceLoot("halloweencandy_13",    1.00)
		end
		if inst.size == 3 then
		inst.components.lootdropper:AddChanceLoot("hat_clownmask",    1.00)
		inst.components.lootdropper:AddChanceLoot("halloweencandy_3",    1.00)
		inst.components.lootdropper:AddChanceLoot("halloweencandy_12",    1.00)
		end
		if inst.size == 4 then
		inst.components.lootdropper:AddChanceLoot("hat_wathommask",    1.00)
		inst.components.lootdropper:AddChanceLoot("halloweencandy_4",    1.00)
		inst.components.lootdropper:AddChanceLoot("halloweencandy_11",    1.00)
		end
		if inst.size == 5 then
		inst.components.lootdropper:AddChanceLoot("hat_devilmask",    1.00)
		inst.components.lootdropper:AddChanceLoot("halloweencandy_5",    1.00)
		inst.components.lootdropper:AddChanceLoot("halloweencandy_10",    1.00)
		end
		if inst.size == 6 then
		inst.components.lootdropper:AddChanceLoot("hat_fiendmask",    1.00)
		inst.components.lootdropper:AddChanceLoot("halloweencandy_6",    1.00)
		inst.components.lootdropper:AddChanceLoot("halloweencandy_9",    1.00)
		end
		if inst.size == 7 then
		inst.components.lootdropper:AddChanceLoot("hat_ghostmask",    1.00)
		inst.components.lootdropper:AddChanceLoot("halloweencandy_7",    1.00)
		inst.components.lootdropper:AddChanceLoot("halloweencandy_8",    1.00)
		end
		if inst.size == 8 then
		inst.components.lootdropper:AddChanceLoot("hat_globmask",    1.00)
		inst.components.lootdropper:AddChanceLoot("halloweencandy_8",    1.00)
		inst.components.lootdropper:AddChanceLoot("halloweencandy_7",    1.00)
		end
		if inst.size == 9 then
		inst.components.lootdropper:AddChanceLoot("hat_hockeymask",    1.00)
		inst.components.lootdropper:AddChanceLoot("halloweencandy_9",    1.00)
		inst.components.lootdropper:AddChanceLoot("halloweencandy_6",    1.00)
		end
		if inst.size == 10 then
		inst.components.lootdropper:AddChanceLoot("hat_joyousmask",    1.00)
		inst.components.lootdropper:AddChanceLoot("halloweencandy_13",    1.00)
		inst.components.lootdropper:AddChanceLoot("halloweencandy_13",    1.00)
		inst.components.lootdropper:AddChanceLoot("halloweencandy_13",    1.00)
		end
		if inst.size == 11 then
		inst.components.lootdropper:AddChanceLoot("hat_mermmask",    1.00)
		inst.components.lootdropper:AddChanceLoot("halloweencandy_11",    1.00)
		inst.components.lootdropper:AddChanceLoot("halloweencandy_4",    1.00)
		end
		if inst.size == 12 then
		inst.components.lootdropper:AddChanceLoot("hat_oozemask",    1.00)
		inst.components.lootdropper:AddChanceLoot("halloweencandy_12",    1.00)
		inst.components.lootdropper:AddChanceLoot("halloweencandy_3",    1.00)
		end
		if inst.size == 13 then
		inst.components.lootdropper:AddChanceLoot("hat_orangecatmask",    1.00)
		inst.components.lootdropper:AddChanceLoot("halloweencandy_13",    1.00)
		inst.components.lootdropper:AddChanceLoot("halloweencandy_2",    1.00)
		end
		if inst.size == 14 then
		inst.components.lootdropper:AddChanceLoot("hat_phantommask",    1.00)
		inst.components.lootdropper:AddChanceLoot("halloweencandy_14",    1.00)
		inst.components.lootdropper:AddChanceLoot("halloweencandy_1",    1.00)
		end
		if inst.size == 15 then
		inst.components.lootdropper:AddChanceLoot("hat_pigmask",    1.00)
		inst.components.lootdropper:AddChanceLoot("halloweencandy_1",    1.00)
		inst.components.lootdropper:AddChanceLoot("halloweencandy_12",    1.00)
		end	
		if inst.size == 16 then
		inst.components.lootdropper:AddChanceLoot("hat_pumpgoremask",    1.00)
		inst.components.lootdropper:AddChanceLoot("halloweencandy_2",    1.00)
		inst.components.lootdropper:AddChanceLoot("halloweencandy_10",    1.00)
		end	
		if inst.size == 17 then
		inst.components.lootdropper:AddChanceLoot("hat_redskullmask",    1.00)
		inst.components.lootdropper:AddChanceLoot("halloweencandy_3",    1.00)
		inst.components.lootdropper:AddChanceLoot("halloweencandy_9",    1.00)
		end
		
		if inst.size == 18 then
			inst.components.lootdropper:AddChanceLoot("hat_skullmask",    1.00)
		inst.components.lootdropper:AddChanceLoot("halloweencandy_4",    1.00)
		inst.components.lootdropper:AddChanceLoot("halloweencandy_7",    1.00)
			end		
			
		if inst.size == 19 then
			inst.components.lootdropper:AddChanceLoot("hat_spectremask",    1.00)
		inst.components.lootdropper:AddChanceLoot("halloweencandy_5",    1.00)
		inst.components.lootdropper:AddChanceLoot("halloweencandy_6",    1.00)
			end		
			
		if inst.size == 20 then
			inst.components.lootdropper:AddChanceLoot("hat_whitecatmask",    1.00)
		inst.components.lootdropper:AddChanceLoot("halloweencandy_6",    1.00)
		inst.components.lootdropper:AddChanceLoot("halloweencandy_3",    1.00)
		end
			
		if inst.size == 21 then
			inst.components.lootdropper:AddChanceLoot("hat_technomask",    1.00)
		inst.components.lootdropper:AddChanceLoot("potato",    1.00)
		inst.components.lootdropper:AddChanceLoot("trinket_6",    1.00)
		end			
			
		if inst.size == 22 then
			inst.components.lootdropper:AddChanceLoot("hat_mandrakemask",    1.00)
		inst.components.lootdropper:AddChanceLoot("halloweencandy_7",    1.00)
		inst.components.lootdropper:AddChanceLoot("halloweencandy_1",    1.00)
		end			
			
		if inst.size == 23 then
			inst.components.lootdropper:AddChanceLoot("hat_opossummask",    1.00)
			inst.components.lootdropper:AddChanceLoot("bananapop",    1.00)
		end
		
		if math.random() > 0.5 then
			if math.random() > 0.5 then
				inst.components.lootdropper:AddChanceLoot("um_ornament_opossum",    1.00)
			else
				inst.components.lootdropper:AddChanceLoot("um_ornament_rat",    1.00)
			end
		end
		
		inst.components.lootdropper:DropLoot()
	end
	
    inst:Remove()
end


local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("rne_goodiebag")
	inst.AnimState:SetBuild("rne_goodiebag")
	inst.AnimState:PlayAnimation("idle")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst.size = math.random(1,23)

	inst:AddComponent("inspectable")
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/rne_goodiebag.xml"
	
	inst:AddComponent("lootdropper")
		
	inst:AddComponent("unwrappable")
	inst.components.unwrappable:SetOnUnwrappedFn(OnUnwrapped)

	return inst
end

return Prefab("rne_goodiebag", fn)