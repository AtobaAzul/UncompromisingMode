local assets =
{
    Asset("ANIM", "anim/bearger_ring_fx.zip"),
}

local function PlayRingAnim()
    local inst = CreateEntity()

    inst:AddTag("FX")
    --[[Non-networked entity]]
    inst.entity:SetCanSleep(false)
    inst.persists = false

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
	
	local value = TheWorld.state.isday and 1 or (TheWorld.state.isdusk or TheWorld.state.isfullmoon) and 0.5 or 0
	inst.AnimState:SetMultColour(value, value, value, .6 - (value / 2))

    inst.AnimState:SetBank("bearger_ring_fx")
    inst.AnimState:SetBuild("bearger_ring_fx")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetFinalOffset(3)

    inst.AnimState:SetOrientation( ANIM_ORIENTATION.OnGround )
    inst.AnimState:SetLayer( LAYER_BACKGROUND )
    inst.AnimState:SetSortOrder( 3 )

    inst:ListenForEvent("animover", inst.Remove)

    return inst
end

return Prefab("wathom_heartbeat_ringfx", PlayRingAnim, assets)
