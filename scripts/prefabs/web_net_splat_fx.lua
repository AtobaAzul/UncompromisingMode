local assets =
{
	Asset( "ANIM", "anim/web_net_splat.zip"),
	Asset( "ANIM", "anim/web_net_splash.zip"),
}



local function fn_websplat(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	inst.persists = false

    inst.AnimState:SetBuild("web_net_splat")
    inst.AnimState:SetBank("spat_splat")
    inst.AnimState:PlayAnimation("idle")
	inst.AnimState:Hide("goosplat")
	--[[inst.AnimState:Hide("goosplat-0")
	inst.AnimState:Hide("goosplat-1")
	inst.AnimState:Hide("goosplat-2")
	inst.AnimState:Hide("goosplat-5")
	inst.AnimState:Hide("goosplat-6")
	inst.AnimState:Hide("goosplat-7")
	inst.AnimState:Hide("goosplat-8")
	inst.AnimState:Hide("goosplat-9")]]
	inst:AddTag("FX")
	inst:AddTag("NOCLICK")
	
	inst:ListenForEvent("animover", function(inst) inst:Remove() end )

    return inst
end
local function fn_websplashfull(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	inst.persists = false

    inst.AnimState:SetBuild("web_net_splash")
    inst.AnimState:SetBank("spat_splash")
    inst.AnimState:PlayAnimation("full")

	inst:AddTag("FX")
	inst:AddTag("NOCLICK")
	
	inst:ListenForEvent("animover", function(inst) inst:Remove() end )

    return inst
end
local function fn_websplashmed(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	inst.persists = false

    inst.AnimState:SetBuild("web_net_splash")
    inst.AnimState:SetBank("spat_splash")
    inst.AnimState:PlayAnimation("med")

	inst:AddTag("FX")
	inst:AddTag("NOCLICK")
	
	inst:ListenForEvent("animover", function(inst) inst:Remove() end )

    return inst
end
local function fn_websplashlow(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	inst.persists = false

    inst.AnimState:SetBuild("web_net_splash")
    inst.AnimState:SetBank("spat_splash")
    inst.AnimState:PlayAnimation("low")

	inst:AddTag("FX")
	inst:AddTag("NOCLICK")
	
	inst:ListenForEvent("animover", function(inst) inst:Remove() end )

    return inst
end
local function fn_websplashmelted(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	inst.persists = false

    inst.AnimState:SetBuild("web_net_splash")
    inst.AnimState:SetBank("spat_splash")
    inst.AnimState:PlayAnimation("melted")

	inst:AddTag("FX")
	inst:AddTag("NOCLICK")
	
	inst:ListenForEvent("animover", function(inst) inst:Remove() end )

    return inst
end
return Prefab("web_splash_fx_melted", fn_websplashmelted, assets),
Prefab("web_splash_fx_low", fn_websplashlow, assets),
Prefab("web_splash_fx_med", fn_websplashmed, assets),
Prefab("web_splash_fx_full", fn_websplashfull, assets),
Prefab("web_net_splat_fx", fn_websplat, assets)