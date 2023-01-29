local prefabs = {}
local mutator_targets = 
{
    "trapdoor",
}

local function MakeMutatorFn(mutator_target)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("um_spider_mutators")
    inst.AnimState:SetBuild("um_spider_mutators")
    inst.AnimState:PlayAnimation(mutator_target)

    MakeInventoryFloatable(inst)

    inst:AddTag("spidermutator")
    inst:AddTag("monstermeat")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/mutator_"..mutator_target..".xml"
	
    inst:AddComponent("stackable")

    inst:AddComponent("edible")
    inst.components.edible.foodtype = FOODTYPE.MEAT
    inst.components.edible.secondaryfoodtype = FOODTYPE.MONSTER
    inst.components.edible.healthvalue = -TUNING.HEALING_SMALL
    inst.components.edible.hungervalue = TUNING.CALORIES_SMALL
    inst.components.edible.sanityvalue = -TUNING.SANITY_SMALL

    inst:AddComponent("spidermutator")
    inst.components.spidermutator:SetMutationTarget("spider_" .. mutator_target)

    MakeHauntableLaunch(inst)

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.SMALL_FUEL

    MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)

    return inst
end

for i, mutator_target in ipairs(mutator_targets) do
    table.insert(prefabs, "spider_" .. mutator_target)
end

local mutator_prefabs = {}
for i, mutator_target in ipairs(mutator_targets) do
    table.insert(mutator_prefabs, Prefab("mutator_" .. mutator_target, function() return MakeMutatorFn(mutator_target) end))
end

return unpack(mutator_prefabs)