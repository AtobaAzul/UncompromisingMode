local function SpawnOuterRing(inst)
	local x,y,z = inst.Transform:GetWorldPosition()
	local radius = math.random(35,42)
	local angle
	for angle = 1,360,60 do
		local radius1 = radius + math.random(-4,4)
		local x1 = x + radius1*math.cos(angle*3.14/180)
		local z1 = z + radius1*math.sin(angle*3.14/180)
		local wreck = SpawnPrefab("specter_shipwreck")
		wreck.Transform:SetPosition(x1,y,z1)
	end
	
end

local function RegenArea(inst)

	SpawnOuterRing(inst)
end



local function makefn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:SetPristine()
		
    if not TheWorld.ismastersim then
        return inst
    end
	inst:DoTaskInTime(0,RegenArea)
    return inst
end

return Prefab("um_spectersea_areahandler", makefn)

