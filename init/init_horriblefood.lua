local foods = { --health/hunger/sanity
    coontail = { 9, 9, 7 },
    shroom_skin = { 10, 10, 0 },
    tentaclespots = { 10, 10, 0 },
    --waterplant_bomb = {-2.5,}
    glommerwings = { 10, 10, 0 },
}


for prefab, stats in pairs(foods) do
    AddPrefabPostInit(prefab, function(inst)
        if not GLOBAL.TheWorld.ismastersim then
            return
        end

        inst:AddComponent("edible")
        inst.components.edible.healthvalue = stats[1]
        inst.components.edible.hungervalue = stats[2]
        inst.components.edible.sanityvalue = stats[3]
        inst.components.edible.foodtype = GLOBAL.FOODTYPE.HORRIBLE
    end)
end
