local function StartCheckingForWoby(inst)
	inst:DoPeriodicTask(5, function(inst)
		local x, y, z = inst.Transform:GetWorldPosition()
		local wobys = TheSim:FindEntities(x, y, z, 10, {"customwobytag"})
		if wobys ~= nil and #wobys <= 0 then
			inst:Remove()
		end
	end)
end

local function wobytargetfn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddNetwork()
	
	inst:AddTag("NOBLOCK")
	inst:AddTag("FX")
	inst:AddTag("wobysittarget")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:DoTaskInTime(10, StartCheckingForWoby)

    inst.owner = nil
    inst.persists = false

    return inst
end

return Prefab("woby_target", wobytargetfn)