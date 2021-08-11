local function InitializeClean(inst)
	local x,y,z = inst.Transform:GetWorldPosition()
	local badair = TheSim:FindEntities(x,y,z,20,{"ratgas"})
	if badair ~= nil then
		for i,v in ipairs(badair) do
			v:Remove()
		end
	end
end

local function cleanairfn()
	local inst = CreateEntity()
	inst.entity:AddTransform()
    inst.entity:AddNetwork()
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddTag("cleanair")
	
	inst:DoTaskInTime(0,InitializeClean)
	
	return inst
end

return Prefab("ratacombs_cleanair", cleanairfn)