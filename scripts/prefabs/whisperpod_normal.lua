require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/whisperpod_normal_ground.zip"),
}

local prefabs =
{
    "ash",
    "snapdragon",
    "snapdragonherd",
}

local function onmatured(inst)
    if not POPULATING then
        inst.SoundEmitter:PlaySound("dontstarve/common/farm_harvestable")
    end
	
	local pos = inst:GetPosition()
    local snappy = SpawnPrefab("snapdragon")
	snappy.Transform:SetPosition(pos:Get())
	snappy.sg:GoToState("create")
    SpawnPrefab("snapdragonherd").Transform:SetPosition(pos:Get())
	
	inst.components.workable:SetWorkAction(nil)
	inst:Remove()
end

local function onburnt(inst)
    DefaultBurntFn(inst)
end

local function OnDigUp(inst)--, worker)
    local x, y, z = inst.Transform:GetWorldPosition()
    local product = SpawnPrefab("whisperpod")
	product.Transform:SetPosition(x, y, z)
    product.components.inventoryitem:DoDropPhysics(x, y, z, true)
	
    inst:Remove()
end

local function GetStatus(inst)
    return (inst:HasTag("withered") and "WITHERED")
        or (inst.components.crop ~= nil and inst.components.crop:IsReadyForHarvest() and "READY")
        or "GROWING"
end

--------------------------------------------------------------------------

local function OnGetItemFromPlayer(inst, giver, item)
    if item.components.plantable ~= nil and not inst.growing then
		inst:AddComponent("crop")
		inst.components.crop:StartGrowing("snapdragon", TUNING.SEEDS_GROW_TIME / 4)
		inst.components.crop:SetOnMatureFn(onmatured)
		inst.growing = true
    end
end

local function AbleToAcceptTest(inst, item, giver)
	return item.components.plantable ~= nil and not inst.growing
end

local function AcceptTest(inst, item, giver)
    return item.components.plantable ~= nil and not inst.growing
end

local function OnSave(inst, data)
    data.burnt = inst.growing
end

local function OnPreLoad(inst, data)
    if data ~= nil and data.growing then
        inst.growing = data.growing
    end
end

local function OnInit(inst, data)
    if not inst.growing then
		inst:RemoveComponent("crop")
    end
end

--------------------------------------------------------------------------

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	inst.entity:AddMiniMapEntity()
	inst.MiniMapEntity:SetIcon("plant_normal_ground.png")
			
	inst.AnimState:SetBank("whisperpod_normal_ground")
	inst.AnimState:SetBuild("whisperpod_normal_ground")
	inst.AnimState:PlayAnimation("placer")
	--inst.AnimState:Hide("mouseover")
	
    --[[local scale = 1.22
    inst.Transform:SetScale(scale, scale, scale)]]

	inst:AddTag("whisperpod")
	inst:AddTag("NPC_workable")
	inst:AddTag("trader")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("trader")
	inst.components.trader:SetAbleToAcceptTest(AbleToAcceptTest)
	inst.components.trader:SetAcceptTest(AcceptTest)
	inst.components.trader.onaccept = OnGetItemFromPlayer
	
	inst:AddComponent("crop")
	inst.components.crop:SetOnMatureFn(onmatured)
		
	inst:AddComponent("inspectable")
	inst.components.inspectable.getstatus = GetStatus
	inst.components.inspectable.nameoverride = "plant_normal"

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetWorkLeft(1)
	inst.components.workable:SetOnFinishCallback(OnDigUp)

	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
	inst.components.burnable:SetOnBurntFn(onburnt)
	--Clear default handlers so we don't stomp our .persists flag
	inst.components.burnable:SetOnIgniteFn(nil)
	inst.components.burnable:SetOnExtinguishFn(nil)
	
	inst.growing = false
	
    inst.OnSave = OnSave
    inst.OnPreLoad = OnPreLoad
	
	inst:DoTaskInTime(0, OnInit)

	return inst
end
	
return Prefab("whisperpod_normal_ground", fn, assets, prefabs)