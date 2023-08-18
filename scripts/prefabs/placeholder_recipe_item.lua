local function fn_ia()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/placeholder_ingredient_ia.xml"

    --incredibly scuffed, but I needed a way to add recipes *after/during* prefab loading.
    return inst
end

local function fn_ia_um()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/placeholder_ingredient_ia_um.xml"

    --incredibly scuffed, but I needed a way to add recipes *after/during* prefab loading.
    return inst
end

if GetValidRecipe("slingshotammo_tar") then
	if Prefabs["tar"] and Prefabs["slingshotammo_tar"] ~= nil then
		AllRecipes["slingshotammo_tar"].ingredients = { Ingredient("tar", 1) }
	elseif Prefabs["sludge"] and Prefabs["slingshotammo_tar"] ~= nil then
		AllRecipes["slingshotammo_tar"].ingredients = { Ingredient("sludge", 1) }
	end
end


if Prefabs["obsidian"] and Prefabs["slingshotammo_obsidian"] ~= nil then
    AllRecipes["slingshotammo_obsidian"].ingredients = { Ingredient("obsidian", 1) }
end

return Prefab("placeholder_ingredient_ia", fn_ia), Prefab("placeholder_ingredient_ia_um", fn_ia_um)
