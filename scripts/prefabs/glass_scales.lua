local function onhammered(inst, worker)
inst.components.lootdropper:SpawnLootPrefab("moonglass_charged")
inst.components.lootdropper:SpawnLootPrefab("moonglass_charged")
inst.components.lootdropper:SpawnLootPrefab("moonglass_charged")
inst.components.lootdropper:SpawnLootPrefab("moonglass_charged")
inst.components.lootdropper:SpawnLootPrefab("moonglass_charged")
inst.components.lootdropper:SpawnLootPrefab("moonglass_charged")
inst:Remove()
end

local function fngeode()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	inst.entity:AddLight()
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
	
    inst.Light:SetColour(111/255, 111/255, 227/255)
    inst.Light:SetIntensity(0.75)
    inst.Light:SetFalloff(0.5)
    inst.Light:SetRadius(1.5)
    inst.Light:Enable(true)  
	
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("moonglass_geode")
    inst.AnimState:SetBuild("moonglass_geode")
    inst.AnimState:PlayAnimation("idle")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/moonglass_geode.xml"
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(1)
    inst.components.workable:SetOnFinishCallback(onhammered)
	
	inst:AddComponent("lootdropper")
	inst.Transform:SetScale(1.5,1.5,1.5)
    MakeHauntableLaunch(inst)

    return inst
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	inst.entity:AddLight()
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")

    inst.Light:SetColour(111/255, 111/255, 227/255)
    inst.Light:SetIntensity(0.75)
    inst.Light:SetFalloff(0.5)
    inst.Light:SetRadius(1)
    inst.Light:Enable(true)  
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("glass_scales")
    inst.AnimState:SetBuild("glass_scales")
    inst.AnimState:PlayAnimation("idle")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/glass_scales.xml"
	
    inst:AddComponent("tradable")

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM
	
    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("glass_scales", fn),
Prefab("moonglass_geode",fngeode)
