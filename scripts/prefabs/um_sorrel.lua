require "prefabutil"
require "modutil"

local assets =
{
    Asset("ANIM", "anim/sorrel.zip"),
}
SetSharedLootTable( 'sorrel_blooming',
{
    {'greenfoliage',    1.0},
    {'greenfoliage',    1.0},
    {'greenfoliage',    0.5},
    {'petals',          1.0},
    {'petals',          0.5}
})

SetSharedLootTable( 'sorrel',
{
    {'greenfoliage',    1},
    {'greenfoliage',    1},
    {'greenfoliage',    0.50},
})

local function bloom(inst)
    if TheWorld.state.isspring then
        inst:AddTag("blooming")
        inst.components.lootdropper:SetChanceLootTable('sorrel_blooming')
        --inst.components.harvestable.product = "petals"
        --if inst.components.harvestable:CanBeHarvested() then
        inst.AnimState:PlayAnimation("idle_flower")
        --end
    else
        if inst:HasTag("blooming") then
            inst:RemoveTag("blooming")
            --inst.components.harvestable.product = "greenfoliage"
        end
        inst.AnimState:PlayAnimation("idle2")
        inst.components.lootdropper:SetChanceLootTable('sorrel')
    end
end

local function OnSave(inst, data)
    data.rotation = inst.Transform:GetRotation()
    --data.scale = { inst.Transform:GetScale() }
end

local function OnLoad(inst, data)
    if data ~= nil then
        if data.rotation ~= nil then
            inst.Transform:SetRotation(data.rotation)
        end
        if data.scale ~= nil then
            inst.Transform:SetScale(data.scale[1] or 1, data.scale[2] or 2, data.scale[3] or 3)
        end
    end
    bloom(inst)
end

local function onharvest(inst, picker, produce)
    if inst:HasTag("blooming") then
        --MAKE THIS A HAYFEVER THINGFGAAA
    end
    inst.components.harvestable.maxproduce = 10 --idk
    inst.AnimState:PlayAnimation("idle", true)
end


local function ongrow(inst, produce)
    if inst:HasTag("blooming") then
        inst.AnimState:PlayAnimation("idle_flower", true)
        inst.components.harvestable.product = "petals"
    else
        inst.AnimState:PlayAnimation("idle2", true)
        inst.components.harvestable.product = "greenfoliage"
    end
end

local function onworkfinished(inst, digger)
    inst.components.lootdropper:DropLoot()
    inst:Remove()
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("sorrel")
    inst.AnimState:SetBuild("sorrel")
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_GROUND)
    inst.AnimState:SetSortOrder(2)
    inst.AnimState:PlayAnimation("idle2", true)
    inst:AddTag("NOBLOCK")

    --inst:AddComponent("harvestable")
    --inst.components.harvestable:SetUp("greenfoliage", 100, TUNING.GRASS_REGROW_TIME/2, onharvest, ongrow)

    inst:WatchWorldState("isspring", bloom)

    MakeMediumBurnable(inst)
    MakeSmallPropagator(inst)

    --[[inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.DIG)
    inst.components.workable:SetWorkLeft(1)
    inst.components.workable:SetOnFinishCallback(onworkfinished)]]

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable('sorrel')
    --[[if not TheWorld.ismastersim then
        return inst
    end]]


    inst.Transform:SetRotation(math.random() * 360)

    --inst.Transform:SetScale(1.2, 1.5, 1.2)

    local scale = GetRandomMinMax(1.25, 1.5)
    inst.Transform:SetScale(scale, scale, scale)

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    return inst
end

return Prefab("um_sorrel", fn, assets)
