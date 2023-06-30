local assets =
{
    Asset("ANIM", "anim/giant_tree_nest.zip"),
}

local function OnLoad(inst, data)
    if data then
        if data.egg then
            inst.egg = data.egg
        end
    end
end

local function OnSave(inst, data)
    data.egg = inst.egg
end

local function onpickup(inst, picker)
    local item = nil
    local x, y, z = inst.Transform:GetWorldPosition()
    for i = 1, math.random(3, 6) do
        item = SpawnPrefab("twigs")
        if (picker ~= nil or picker ~= TheWorld) and picker.components.inventory ~= nil then
            picker.components.inventory:GiveItem(item, nil, inst:GetPosition())
        else
            item.Transform:SetPosition(x, y, z)
        end
    end

    for i = 1, inst.egg do
        item = SpawnPrefab("bird_egg")
        if (picker ~= nil or picker ~= TheWorld) and picker.components.inventory ~= nil then
            picker.components.inventory:GiveItem(item, nil, inst:GetPosition())
        else
            item.Transform:SetPosition(x, y, z)
        end
    end
end

local function Erode(inst)
    local item = nil
    local x, y, z = inst.Transform:GetWorldPosition()
    for i = 1, math.random(3, 6) do
        item = SpawnPrefab("twigs")
        item.Transform:SetPosition(x, y, z)
        if item.components.inventoryitem ~= nil and item.components.inventoryitem.ondropfn ~= nil then
            item.components.inventoryitem.ondropfn(item)
        end
    end
    for i = 1, inst.egg do
        item = SpawnPrefab("bird_egg")
        item.Transform:SetPosition(x, y, z)
        if item.components.inventoryitem ~= nil and item.components.inventoryitem.ondropfn ~= nil then
            item.components.inventoryitem.ondropfn(item)
        end
    end
    inst:Remove()
end

local function onburnt(inst)
    local item = nil
    local x, y, z = inst.Transform:GetWorldPosition()
    for i = 1, math.random(3, 6) do
        item = SpawnPrefab("ash")
        item.Transform:SetPosition(x, y, z)
        if item.components.inventoryitem ~= nil and item.components.inventoryitem.ondropfn ~= nil then
            item.components.inventoryitem.ondropfn(item)
        end
    end
    for i = 1, inst.egg do
        item = SpawnPrefab("bird_egg_cooked")
        item.Transform:SetPosition(x, y, z)
        if item.components.inventoryitem ~= nil and item.components.inventoryitem.ondropfn ~= nil then
            item.components.inventoryitem.ondropfn(item)
        end
    end
    inst:Remove()
end


local function Init(inst)
    if inst.egg then
        inst:AddComponent("pickable")
        inst.components.pickable.picksound = "dontstarve/wilson/harvest_sticks"
        inst.components.pickable.onpickedfn = onpickup
        inst.components.pickable.remove_when_picked = true
        inst.components.pickable.canbepicked = true

        inst:AddComponent("burnable")
        inst.components.burnable:SetFXLevel(2)
        inst.components.burnable:AddBurnFX("character_fire", Vector3(.1, 0, .1), "nest")
        inst.components.burnable.canlight = true
        inst.components.burnable:SetOnBurntFn(onburnt)
        inst.components.burnable:SetBurnTime(10)
        inst.AnimState:PlayAnimation("idle_" .. inst.egg, true)
    else
        inst.egg = math.random(1, 3)
        Init(inst)
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst, 1)


    inst.AnimState:SetBank("giant_tree_nest")
    inst.AnimState:SetBuild("giant_tree_nest")


    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:DoTaskInTime(0, Init)
    inst:AddComponent("timer")
    if not inst.components.timer:TimerExists("erode") then
        inst.components.timer:StartTimer("erode", 8 * 60)
    end
    inst:AddComponent("inspectable")
    inst:ListenForEvent("timerdone", Erode)

    inst.onsave = OnSave
    inst.onload = OnLoad

    return inst
end

return Prefab("giant_tree_birdnest", fn, assets)
