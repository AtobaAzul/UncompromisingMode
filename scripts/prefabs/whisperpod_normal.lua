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
    local snappy = SpawnPrefab("snapdragon_buddy")
	snappy.Transform:SetPosition(pos:Get())
	snappy.sg:GoToState("create")
    SpawnPrefab("snapdragonherd").Transform:SetPosition(pos:Get())
	
	snappy:DoTaskInTime(0, function(snappy) snappy.AnimState:OverrideSymbol("hair", "snapdragon_build_"..inst.planted or "snapdragon_build", "hair") end)
	snappy:DoTaskInTime(0, function(snappy) snappy.AnimState:OverrideSymbol("ear", "snapdragon_build_"..inst.planted or "snapdragon_build", "ear") end)
	snappy:DoTaskInTime(0, function(snappy) snappy.AnimState:OverrideSymbol("face", "snapdragon_build_"..inst.planted or "snapdragon_build", "face") end)
	snappy:DoTaskInTime(0, function(snappy) snappy.AnimState:OverrideSymbol("jaw", "snapdragon_build_"..inst.planted or "snapdragon_build", "jaw") end)
	snappy.seeds = inst.planted or "seeds"
	
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
		inst.components.crop:StartGrowing("snapdragon", TUNING.SEEDS_GROW_TIME / 40)
		inst.components.crop:SetOnMatureFn(onmatured)
		inst.growing = true
		
		if (item.prefab == "watermelon_seeds" or "pomegranate_seeds" or "pumpkin_seeds" or "dragonfruit_seeds" or "eggplant_seeds" or "durian_seeds") then
			inst.planted = item.prefab
			--[[local prefab = nil
			prefab = item.components.plantable.product
			inst.planted = prefab
			inst.AnimState:SetBuild("snapdragon_build_"..inst.planted"_seeds")--]]
			inst.AnimState:SetBuild("snapdragon_build_"..inst.planted)
		else
			inst.planted = "seeds"
		end
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
    data.planted = inst.planted
end

local function OnPreLoad(inst, data)
    if data ~= nil and data.growing then
        inst.growing = data.growing
    end
	
    if data ~= nil and data.planted then
        inst.planted = data.planted
    end
end

local function OnInit(inst, data)
    if not inst.growing then
		inst:RemoveComponent("crop")
    end
	
	
    if inst.planted ~= nil then
		inst.AnimState:SetBuild("snapdragon_build_"..inst.planted)
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
	inst.AnimState:PlayAnimation("sprout")
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
	inst.planted = nil
	
    inst.OnSave = OnSave
    inst.OnPreLoad = OnPreLoad
	
	inst:DoTaskInTime(0, OnInit)

	return inst
end
	
return Prefab("whisperpod_normal_ground", fn, assets, prefabs)