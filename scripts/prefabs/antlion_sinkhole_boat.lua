local rippleassets =
{
    Asset("ANIM", "anim/malbatross_ripple.zip"),
}

local function BoatBreaker(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
		
	local ripple = SpawnPrefab("antlion_sinkhole_ripple")
    ripple.Transform:SetPosition(x, y, z)
		
	local pt = inst:GetPosition()
	local boat = TheWorld.Map:GetPlatformAtPoint(pt.x, pt.z)
	
	if boat ~= nil and boat.components.hullhealth then
		boat.components.health:DoDelta(-5, false, nil)
		
		local chance = math.random()
		
		if chance >= 0.8 then
			boat:PushEvent("spawnnewboatleak", {pt = pt, leak_size = "med_leak", playsoundfx = true})
		elseif chance < 0.8 and chance >= 0.5 then
			boat:PushEvent("spawnnewboatleak", {pt = pt, leak_size = "small_leak", playsoundfx = true})
		end
	elseif TheWorld.Map:IsOceanAtPoint(pt.x, 0, pt.z) then
		local splash = SpawnPrefab("splash_green")
		splash.Transform:SetPosition(x, y, z)
    end

	
	inst:Remove()
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:DoTaskInTime(0, BoatBreaker)
	
	inst.persists = false

    return inst
end

local function ripplefn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("malbatross_ripple")
    inst.AnimState:SetBuild("malbatross_ripple")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("fx")

    inst.AnimState:SetLayer(LAYER_BELOW_GROUND)
    inst.AnimState:SetSortOrder(ANIM_SORT_ORDER_BELOW_GROUND.BOAT_TRAIL)

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst:ListenForEvent("animover", inst.Remove)

    return inst
end


return Prefab("antlion_sinkhole_boat", fn),
       Prefab("antlion_sinkhole_ripple", ripplefn, rippleassets )