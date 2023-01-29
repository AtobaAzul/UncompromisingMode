require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/wixie_wardrobe.zip"),
}

local prefabs =
{
    "collapse_big",
}

local function ShutterAndShake(inst)
	inst.AnimState:PlayAnimation("active")
	inst.AnimState:PushAnimation("closed", false)
	inst.SoundEmitter:PlaySound("dontstarve/common/wardrobe_active")
end

local function OnActivate(inst)
	if not inst.AnimState:IsCurrentAnimation("active") then
		inst.AnimState:PlayAnimation("hit")
		inst.AnimState:PushAnimation("closed", false)
		inst.SoundEmitter:PlaySound("dontstarve/common/wardrobe_hit")
	end
	
    inst.components.activatable.inactive = true
end

local function GetActivateVerb(inst)
	return "OPEN"
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst:SetPhysicsRadiusOverride(.8)
    MakeObstaclePhysics(inst, inst.physicsradiusoverride)

    inst:AddTag("wixie_wardrobe")

    inst.AnimState:SetBank("wardrobe")
    inst.AnimState:SetBuild("wixie_wardrobe")
    inst.AnimState:PlayAnimation("closed")

    inst.MiniMapEntity:SetIcon("wardrobe.png")

    MakeSnowCoveredPristine(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
    inst:AddComponent("activatable")
    inst.components.activatable.OnActivate = OnActivate
    inst.components.activatable.inactive = true
	inst.components.activatable.quickaction = true
	inst.components.activatable.standingaction = true
	
	inst.GetActivateVerb = GetActivateVerb
	
    inst:AddComponent("inspectable")

    inst:AddComponent("lootdropper")
	
    MakeSnowCovered(inst)
	
	inst:ListenForEvent("wixie_wardrobe_shutter", OnActivate)
	inst:ListenForEvent("wixie_wardrobe_shake", ShutterAndShake)

    return inst
end

return Prefab("wixie_wardrobe", fn, assets, prefabs)