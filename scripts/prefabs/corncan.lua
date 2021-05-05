local function onhammered(inst)
    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
        inst.components.burnable:Extinguish()
    end
    inst.components.lootdropper:SpawnLootPrefab("corn")
    inst:Remove()
end

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("corncan")
    inst.AnimState:SetBuild("corncan")
    inst.AnimState:PlayAnimation("idle")
    
    MakeInventoryPhysics(inst)
 	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then 
		return inst
	end       
    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/corncan.xml"
    
    inst:AddComponent("tradable")
    inst.components.tradable.goldvalue = 8
	inst:AddComponent("lootdropper")
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(1)
    inst.components.workable:SetMaxWork(1)
    inst.components.workable:SetOnFinishCallback(onhammered)

    return inst
end

return Prefab("corncan", fn)
