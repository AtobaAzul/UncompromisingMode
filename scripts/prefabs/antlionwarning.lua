
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst.SoundEmitter:PlaySound("dontstarve/creatures/together/antlion/death")
	ShakeAllCameras(CAMERASHAKE.FULL, .7, .02, .5, inst, 40)
	inst:DoTaskInTime(3, function(inst)
		inst:Remove()
	end)

    return inst
end

return Prefab("antlionwarning", fn)