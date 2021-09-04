local assets =
{
    Asset("ANIM", "anim/warg_gingerbread_bomb.zip"),
    Asset("ANIM", "anim/goo_icing.zip"),
}

local function pipethrown(inst)
	
	SpawnPrefab("statue_transition_2").Transform:SetPosition(inst.Transform:GetWorldPosition())
	--inst.SoundEmitter:PlaySound("dontstarve/sanity/creature2/taunt")
    RemovePhysicsColliders(inst)
	
    inst:AddTag("NOCLICK")
    inst.persists = false
end

local function onhit(inst, attacker, target)

    if target ~= nil and target.prefab == "nightlight" then
		inst.SoundEmitter:PlaySound("dontstarve/maxwell/shadowmax_appear")
		target.components.fueled:TakeFuelItem(inst)
		SpawnPrefab("statue_transition").Transform:SetPosition(target.Transform:GetWorldPosition())
		
		inst:Remove()
	end
end

local function fn()
	local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
	
    inst.AnimState:SetBank("warg_gingerbread_bomb")
    inst.AnimState:SetBuild("warg_gingerbread_bomb")
    inst.AnimState:PlayAnimation("spin_loop", true)
	
	inst.AnimState:SetMultColour(0, 0, 0, 0.4)
	
    inst:AddTag("NOCLICK")
    inst:AddTag("weapon")
    inst:AddTag("projectile")
	
    RemovePhysicsColliders(inst)
	
    inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
    inst:AddComponent("fuel")
    inst.components.fuel.fueltype = FUELTYPE.NIGHTMARE
    inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(0)
	
    inst:AddComponent("projectile")
    inst.components.projectile:SetSpeed(25)
    inst.components.projectile:SetOnThrownFn(pipethrown)
    inst.components.projectile:SetHoming(true)
    inst.components.projectile:SetHitDist(math.sqrt(3))
    inst.components.projectile:SetOnHitFn(onhit)
    inst.components.projectile:SetOnMissFn(inst.Remove)
    inst.components.projectile:SetLaunchOffset(Vector3(0, 2, 0))
	
	inst:DoTaskInTime(5, inst.Remove)
	
    inst.persists = false

    return inst
end

return Prefab("nightlightfuel", fn, assets)