local InventoryCrafter = Class(function(self, inst)
    --public fiedl variables
    self.inst = inst
    self.recipes = {}

    assert(self.inst.components.inventory ~= nil, "Attempted to add an inventory crafter with to inventory! Make sure the component is added *after* adding the inv. component!")
end)

--saves a recipe.
function InventoryCrafter:AddRecipe(output, input, amount, numtogive)
    self.recipes[input] = { output = output, amount = amount or 1, numtogive = numtogive or 1 }
end

--crafts the first thing it can.
function InventoryCrafter:Craft()
    assert(self.inst.components.inventory ~= nil, "Attempted to craft with no inventory component!")

    if not next(self.recipes) then
        print("InventoryTransformationRecipe: Attempting crafting with no recipes added!", self.inst)
    end

    local inst = self.inst
    local inv = inst.components.inventory
    local inputitem, recipe
    --find valid recipe
    for k, v in pairs(inv.itemslots) do
        if self.recipes[v.prefab] ~= nil then
            inputitem = v
            recipe = self.recipes[v.prefab]
            break
        end
    end
    if not inputitem then
        return
    end

    local stacksize = inputitem.components.stackable ~= nil and inputitem.components.stackable:StackSize() or 1

    local numtogive, amount = recipe.numtogive, recipe.amount

    --WARNING: DO NOT ADD INVCRAFTING RECIPES THAT USES MORE THAN 1 NON-STACKABLE INPUT!
    if stacksize >= amount then
        for i = 1, amount do
            if inputitem ~= nil then
                if inputitem.components.stackable ~= nil then
                    inputitem.components.stackable:Get():Remove()
                else
                    inputitem:Remove()
                end
            else
                print("InvCrafter: INPUT ITEM NIL! Did you try to add a recipe that uses more than 1 non-stackable item?", inst)
            end
        end

        for i = 1, numtogive do
            inv:GiveItem(SpawnPrefab(recipe.output), nil, inst:GetPosition())
        end
        return true
    end
    return false
end

return InventoryCrafter
