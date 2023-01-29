local assets =
{
}

local function SpawnReedsBunches(inst)
local x, y, z = inst.Transform:GetWorldPosition()
x = x - 2
z = z - 2
for i = 1, math.random(2,3) do
	for k = 1, math.random(2,3) do
		if TheWorld.Map:IsPassableAtPoint(x, 0, z) then
		local plant = SpawnPrefab("reeds")
		plant.Transform:SetPosition(x, y, z)
	end
	x = x + math.random()+math.random()+0.7
	z = z - 0.5 +math.random()
end
x = x - 3 * math.random()- 3 * math.random() - 1.5
z = z + math.random()+math.random()+0.7
end
inst:Remove()
end

local function makefn()
    	local inst = CreateEntity()

    	inst.entity:AddTransform()
    	inst.entity:AddAnimState()
        inst.entity:AddNetwork()
		inst.entity:AddSoundEmitter()
		inst.entity:AddMiniMapEntity()
		inst.entity:AddDynamicShadow()
        inst.entity:SetPristine()
		
        if not TheWorld.ismastersim then
            return inst
        end
		inst:DoTaskInTime(0,SpawnReedsBunches)
        return inst
end

return Prefab("reedbuncher", makefn, assets)

