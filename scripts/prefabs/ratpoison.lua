local itemassets =
{
	Asset("ANIM", "anim/tar.zip"),
}

local assets =
{
	Asset("ANIM", "anim/tar_trap.zip"),
	Asset("ANIM", "anim/um_goo.zip"),
}

local itemprefabs=
{
    "ratpoison",
}

local function oneaten(inst, eater)
	if inst.count ~= nil and inst.count ~= 0 then
		local poison = SpawnPrefab("ratpoison")
		poison.Transform:SetPosition(inst.Transform:GetWorldPosition())
		poison.count = inst.count - 1
		eater:AddDebuff("ratpoison_debuff", "ratpoison_debuff")
	else
		eater:AddDebuff("ratpoison_debuff", "ratpoison_debuff")
		inst:Remove()
	end
end

local function OnSave(inst,data)
	if inst.count then
		data.count = inst.count
	end
	data.rotation = inst.Transform:GetRotation()
end

local function OnLoad(inst,data)
	if data then
		if data.count then
		inst.count = data.count
		end
		if data.rotation ~= nil then
            inst.Transform:SetRotation(data.rotation)
        end
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
    inst.AnimState:SetBank("um_goo")
    inst.AnimState:SetBuild("um_goo")

    inst.AnimState:PlayAnimation("true_idle")
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

	inst.Transform:SetRotation(math.random() * 360)

	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
    return inst
end

local function OnDeploy(inst, pt)
	local poison = SpawnPrefab("ratpoison")
	poison.Transform:SetPosition(pt.x, 0, pt.z)
	poison.count = 8
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
	
    inst:AddTag("donotautopick")

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
    MakePlacer("ratpoisonbottle_placer",  "um_goo", "um_goo", "true_idle") 