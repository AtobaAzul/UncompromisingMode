local itemassets =
{
	Asset("ANIM", "anim/tar.zip"),
}

local assets =
{
	Asset("ANIM", "anim/tar_trap.zip"),
}

local itemprefabs=
{
    "ratpoison",
}

local function oneaten(inst, eater)
	if eater and eater:HasTag("raidrat") then
		eater.components.health:Kill()
	end
end

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    MakeInventoryPhysics(inst)

    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(3)

    inst.AnimState:SetBank("tar_trap")
    inst.AnimState:SetBuild("tar_trap")

    inst.AnimState:PlayAnimation("idle_full")
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then 
		return inst
	end
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("edible")
    inst.components.edible.foodtype = FOODTYPE.HORRIBLE --Horrible is generally unedible
	inst.components.edible.healthvalue = -20
	inst.components.edible:SetOnEatenFn(oneaten)
	
	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_SUPERSLOW)
	
	inst:AddComponent("bait")

    return inst
end

local function OnDeploy(inst, pt)
	SpawnPrefab("ratpoison").Transform:SetPosition(pt.x, 0, pt.z)
	SpawnPrefab("ratpoison").Transform:SetPosition(pt.x, 0, pt.z)
	SpawnPrefab("ratpoison").Transform:SetPosition(pt.x, 0, pt.z)
	SpawnPrefab("ratpoison").Transform:SetPosition(pt.x, 0, pt.z)
    inst:Remove()
end

local function itemfn()
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    inst.entity:AddNetwork()
	
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("tar")
    inst.AnimState:SetBuild("tar")
    inst.AnimState:PlayAnimation("idle")
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then 
		return inst
	end
	
	inst:AddComponent("inspectable")

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/ratpoisonbottle.xml"
    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
	
	inst:AddComponent("deployable")
    inst.components.deployable.ondeploy = OnDeploy

    MakeHauntableLaunch(inst)
	
    return inst
end

return Prefab( "ratpoisonbottle", itemfn, itemassets, itemprefabs),
    Prefab("ratpoison", fn, assets),
    MakePlacer("ratpoisonbottle_placer",  "tar_trap", "tar_trap", "idle_full") 