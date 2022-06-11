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
	eater:AddDebuff("ratpoison_debuff", "ratpoison_debuff")
end

local function OnSave(inst,data)
	if inst.rotation ~= nil then
		data.rotation = inst.rotation
	end
	
	if inst.scalex ~= nil then
		data.scalex = inst.scalex
	end
	
	if inst.scalez ~= nil then
		data.scalez = inst.scalez
	end
end

local function OnLoad(inst,data)
	if data.rotation ~= nil then
		inst.rotation = data.rotation
		inst.Transform:SetRotation(inst.rotation)
	end
	
	if data.scalex ~= nil and data.scalez ~= nil then
		inst.scalex = data.scalex
		inst.scalez = data.scalez
		inst.Transform:SetScale(inst.scalex,1,inst.scalez)
	end
end

local function OnPicked(inst)
	inst:Remove()
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
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetBank("tar_trap")
    inst.AnimState:SetBuild("tar_trap")

    inst.AnimState:PlayAnimation("idle_full")
	
	inst.entity:SetPristine()

	inst:AddTag("NORATCHECK")
	
	if not TheWorld.ismastersim then 
		return inst
	end
	
	inst:AddComponent("edible")
    inst.components.edible.foodtype = FOODTYPE.VEGGIE --Horrible is generally unedible
	inst.components.edible.healthvalue = -15
	inst.components.edible:SetOnEatenFn(oneaten)
	
	inst:AddComponent("bait")
	
	inst:AddComponent("inspectable")
	
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem:SetOnPutInInventoryFn(OnPicked)
	inst.components.inventoryitem:SetOnPickupFn(OnPicked)
	inst.components.inventoryitem.cangoincontainer = false
	
	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_SUPERSLOW)

	inst.AnimState:SetMultColour(0.6,1,1,1)
	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
    return inst
end

local function OnDeploy(inst, pt)
	for i = 1,8 do 
		local poison = SpawnPrefab("ratpoison")
		poison.Transform:SetPosition(pt.x, 0, pt.z)
		inst:Remove()
	end
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