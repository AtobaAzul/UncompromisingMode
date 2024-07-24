--a component for WX's ability to dismantle circuits with an unplug tool
local Data_Extractor = Class(function(self, inst)
    self.inst = inst

end)

function Data_Extractor:BreakDown(target, doer)
    local owner = target.components.inventoryitem:GetGrandOwner()
    local receiver = owner ~= nil and not owner:HasTag("pocketdimension_container") and (owner.components.inventory or owner.components.container) or nil
    local pt = receiver ~= nil and self.inst:GetPosition() or doer:GetPosition()

    local loot = target.components.lootdropper:GetRecipeLoot(AllRecipes[target.prefab])
    target:Remove()

    for _, prefab in ipairs(loot) do
		if prefab == "scandata" then
			if receiver ~= nil then
		        receiver:GiveItem(SpawnPrefab(prefab), nil, pt)
			else
				target.components.lootdropper:SpawnLootPrefab(prefab, pt)
			end
		end
    end
	return true
end

return Data_Extractor