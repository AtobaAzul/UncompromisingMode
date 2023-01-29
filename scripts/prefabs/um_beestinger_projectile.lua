local assets =
{
    Asset("ANIM", "anim/um_beestinger_projectile.zip"),
}

local TARGET_IGNORE_TAGS = { "INLIMBO", "bee" }

local function pipethrown(inst)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:PlayAnimation("stinger")
    inst:AddTag("NOCLICK")
    inst.persists = false
end

local function onhit(inst, attacker, target)

    if not target:IsValid() or target:HasTag("bee") then
        --target killed or removed in combat damage phase
        return
    end

    if target.components.sleeper ~= nil and target.components.sleeper:IsAsleep() then
        target.components.sleeper:WakeUp()
    end


    if target.components.combat ~= nil then
        target.components.combat:SuggestTarget(attacker)
    end

	target.components.combat:GetAttacked(attacker, 50, inst)

	inst:Remove()
end

local function PhysTest(inst)
	local ent = FindEntity(inst,inst.hitdist,nil,{"_combat"},{"INLIMBO"})
	if ent and not ent:HasTag("bee") and ent:IsValid() then
		onhit(inst,inst,ent)
	end
end

local function stinger_fn()
	local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    RemovePhysicsColliders(inst)
	
	inst.AnimState:SetFinalOffset(0.5)
    inst.AnimState:SetBank("um_beestinger_projectile")
    inst.AnimState:SetBuild("um_beestinger_projectile")

	inst.AnimState:SetMultColour(1,0,0,1)
	
    inst:AddTag("NOCLICK")
    inst:AddTag("sharp")
    inst:AddTag("weapon")
    inst:AddTag("projectile")
	inst:AddTag("bee")
    inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	inst.anim = 1
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(0)
	
    inst:AddComponent("projectile")
    inst.components.projectile:SetSpeed(25)
    inst.components.projectile:SetOnThrownFn(pipethrown)
    inst.components.projectile:SetHoming(false)
	inst.hitdist = math.sqrt(2)
    inst.components.projectile:SetHitDist(inst.hitdist)
    inst.components.projectile:SetOnHitFn(onhit)
    inst.components.projectile:SetOnMissFn(function(inst) inst:Remove() end)
    inst.components.projectile:SetLaunchOffset(Vector3(0, 0.5, 0))
	inst:DoTaskInTime(5,function(inst) inst:Remove() end)
	inst:DoPeriodicTask(FRAMES,PhysTest)
	
	inst.Transform:SetScale(1.2,1.2,1.2)
    inst.persists = false

    return inst
end
return Prefab("um_beestinger_projectile",stinger_fn,assets)
