local prefabs = 
{
    "snapdragon",
}

local function CanSpawn(inst)
    return inst.components.herd and not inst.components.herd:IsFull()
end

local function OnSpawned(inst, newent)
    if inst.components.herd ~= nil then
        inst.components.herd:AddMember(newent)
    end
end
   
local function fn()
	local inst = CreateEntity()
	
    inst.entity:AddTransform()
    --[[Non-networked entity]]

    inst:AddTag("herd")
    --V2C: Don't use CLASSIFIED because herds use FindEntities on "herd" tag
    inst:AddTag("NOBLOCK")
    inst:AddTag("NOCLICK")
    
    inst:AddComponent("herd")
    inst.components.herd:SetMemberTag("snapdragon")
    inst.components.herd:SetGatherRange(40)
    inst.components.herd:SetUpdateRange(30)
    inst.components.herd:SetOnEmptyFn(inst.Remove)

--[[
    inst:AddComponent("periodicspawner")
    inst.components.periodicspawner:SetRandomTimes(20, 30)
    inst.components.periodicspawner:SetPrefab("snapdragon")
    inst.components.periodicspawner:SetOnSpawnFn(OnSpawned)
    inst.components.periodicspawner:SetSpawnTestFn(CanSpawn)
    inst.components.periodicspawner:SetDensityInRange(20, 6)
    inst.components.periodicspawner:SetOnlySpawnOffscreen(true)
    inst.components.periodicspawner:Start()

]]
    return inst
end

return Prefab( "snapdragonherd", fn, nil, prefabs) 
