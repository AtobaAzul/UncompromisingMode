local assets=
{ 
    Asset("ANIM", "anim/uncompromising_shadow_projectile1_fx.zip"),
    Asset("ANIM", "anim/uncompromising_shadow_projectile2_fx.zip"),
}
local prefabs = 
{
}

local function fn1(anim)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("uncompromising_shadow_projectile1_fx")
    inst.AnimState:SetBuild("uncompromising_shadow_projectile1_fx")
    inst.AnimState:PlayAnimation(anim)

    inst.Transform:SetScale(2.8, 1.8, 2.8)

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")

    --inst:AddComponent("transparentonsanity_dreadeye")
    --inst:AddComponent("transparentonsanity")
	inst.AnimState:SetMultColour(1, 1, 1, 0.4)
	
	inst.AnimState:UsePointFiltering(true)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:ListenForEvent("animover", function() inst:Remove() end)
    inst.persists = false

    return inst
end

local function slowproj1(inst)
	local inst = fn1("anim")

    if not TheWorld.ismastersim then
        return inst
    end

	return inst
end

local function fastproj1(inst)
	local inst = fn1("anim2")

    if not TheWorld.ismastersim then
        return inst
    end

	return inst
end
	

local function fn2()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("uncompromising_shadow_projectile2_fx")
    inst.AnimState:SetBuild("uncompromising_shadow_projectile2_fx")
    inst.AnimState:PlayAnimation("anim1")
    
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)

    inst.Transform:SetScale(2, 2, 2)

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")

    --inst:AddComponent("transparentonsanity_dreadeye")
	inst.AnimState:SetMultColour(1, 1, 1, 0.4)
    --inst:AddComponent("transparentonsanity")
	
	inst.AnimState:UsePointFiltering(true)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:DoTaskInTime(1,  function() inst.AnimState:PlayAnimation("anim2", true) end)
    inst:DoTaskInTime(8,  function() inst.AnimState:PlayAnimation("anim3") end)
    inst:DoTaskInTime(9, inst.Remove)
    inst.persists = false

    return inst
end

return Prefab( "uncompromising_shadow_projectile1_fx", slowproj1, assets), -- prefabs
	Prefab( "uncompromising_shadow_projectile1_fx_fast", fastproj1, assets),
    Prefab("uncompromising_shadow_projectile2_fx", fn2, assets) 