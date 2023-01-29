local function fn(Sim)
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
	
	inst.entity:AddTransform()
    inst.entity:AddNetwork()
    MakeInventoryPhysics(inst)
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	MakeSmallBurnable(inst, 4+ math.random()*4)
    MakeSmallPropagator(inst)
    inst.components.burnable:Ignite()
    
    inst:AddComponent("heater")
    inst.components.heater.heat = 20

    return inst
end

return Prefab("willowfire", fn)


