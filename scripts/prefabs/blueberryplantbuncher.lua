local function SpawnBlueberryBunches(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	x = x - 2
	z = z - 2
	for i = 1, math.random(2,3) do
		for k = 1, math.random(2,3) do
			if TheWorld.Map:IsPassableAtPoint(x, 0, z) then
				local plant = SpawnPrefab("blueberryplant")
				plant.Transform:SetPosition(x, y, z)
			end
			x = x + math.random()+math.random()+0.6
			z = z - 0.5 +math.random()
			if TheWorld.Map:IsPassableAtPoint(x, 0, z) then
				local sorrel = SpawnPrefab("um_sorrel")
				sorrel.Transform:SetPosition(x, y, z)
			end
		end
		x = x - 3 * math.random()- 3 * math.random() - 0.75
		z = z + math.random()+math.random()+0.6
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
		inst:DoTaskInTime(0,SpawnBlueberryBunches)
        return inst
end

return Prefab("blueberryplantbuncher", makefn)

