local function Initialize(inst)
	if TheWorld.totalcatcoondens ~= nil and TheWorld.totalcatcoondens < 4+math.random(0,2) then --bit of randomization
		local x,y,z = inst.Transform:GetWorldPosition()
		SpawnPrefab("catcoonden").Transform:SetPosition(x,y,z)
		SpawnPrefab("flower_rose").Transform:SetPosition(x+math.random(-1,1),y,z+math.random(-1,1))
	end
	inst:Remove()
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()

    inst.entity:SetPristine()	
    if not TheWorld.ismastersim then
        return inst
    end

	inst:DoTaskInTime(math.random(1,10)*0.1,Initialize)
		
    return inst
end

return Prefab("backupcatcoonden", fn)