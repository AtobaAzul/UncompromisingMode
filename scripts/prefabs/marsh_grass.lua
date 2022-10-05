local assets =
{
    Asset("ANIM", "anim/bush_marsh.zip"),      
}

local prefabs =
{
}

local function fn(Sim)
    local inst = CreateEntity()
	
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()
	
    inst.AnimState:SetBuild("bush_marsh")    
    inst.AnimState:SetBank("bank_a26ad8bb")
    inst.AnimState:PlayAnimation("idle_loop", true)
	MakeSmallBurnable(inst, TUNING.MED_BURNTIME)
	inst.entity:SetPristine()
	

    if not TheWorld.ismastersim then
        return inst
    end
	
	--[[
    inst:AddComponent("activatable")
    inst.components.activatable.OnActivate = inst:Remove()
	]]
    inst:AddComponent("inspectable")
	
	
    --inst.deactivate = deactivate

    --inst.OnSave = onsave 
    --inst.OnLoad = onload
	

    return inst
end

return Prefab("marsh_grass", fn, assets, prefabs)


