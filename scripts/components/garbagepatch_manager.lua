--------------------------------------------------------------------------
--[[ GarbagePatch Manager class definition ]]
--------------------------------------------------------------------------

GarbagePatchManager = Class(function(self, inst)
    assert(TheWorld.ismastersim, "GarbagePatch Manager should not exist on client")

    --Public
    self.inst = inst
    self.garbage_inventory = nil

    self.inst:DoTaskInTime(0, function(inst)
        self:AddInventory()
    end)
end)

function GarbagePatchManager:FindSpotForPatch()
    local pos = TheWorld.Map:FindRandomPointInOcean(10)

    if pos ~= nil then
        local x, y, z = FindRandomPointOnShoreFromOcean(pos.x, pos.y, pos.z)
        return Vector3(x, y, z)        --return as vec
    else
        return self:FindSpotForPatch() --probably NOT a good idea, lol, but there's no WAY it'll cause a SO, RIGHT???????
    end
end

function GarbagePatchManager:AddInventory()
    if self.garbage_inventory == nil and TheSim:FindFirstEntityWithTag("garbagepatch_inventory") then
       
        self.garbage_inventory = TheSim:FindFirstEntityWithTag("garbagepatch_inventory")
    elseif self.garbage_inventory == nil then
       
        self.garbage_inventory = SpawnPrefab("garbagepatch_inventory")
    else
       
    end

    return self.garbage_inventory
end

--optimization method, doesn't have to run the if statements.
function GarbagePatchManager:GetInventory()
    return self.garbage_inventory ~= nil and self.garbage_inventory or self:AddInventory()
end

--pos param so in case we need to spawn it in a especific place (i.e. siren's place when that's done)
function GarbagePatchManager:SpawnPatch(pos)
    local x, y, z
    if pos == nil then
        x, y, z = self:FindSpotForPatch():Get()
    else
        x, y, z = self:FindSpotForPatch():Get()
    end

    for i = 0, math.ceil(#self.garbage_inventory.components.inventory.itemslots / 5) do
        local flotsam = SpawnPrefab("garbagepatchflotsam")
        flotsam.Transform:SetPosition(x + math.random(-10, 10), y, z + math.random(-10, 10))
    end
end

return GarbagePatchManager
