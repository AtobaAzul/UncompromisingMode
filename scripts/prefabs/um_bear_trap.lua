require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/trap_teeth.zip"),
}

local assets_maxwell =
{
    Asset("ANIM", "anim/trap_teeth_maxwell.zip"),
    Asset("MINIMAP_IMAGE", "trap_teeth"),
}

local function onfinished_normal(inst)
	if inst.deathtask ~= nil then
		inst.deathtask:Cancel()
	end
	inst.deathtask = nil
    inst:RemoveComponent("inventoryitem")
    inst:RemoveComponent("mine")
    inst.persists = false
    inst.Physics:SetActive(false)
    inst.AnimState:PushAnimation("death", false)
    inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
    inst:DoTaskInTime(3, inst.Remove)
	
	if inst.latchedtarget ~= nil then
		inst.latchedtarget.components.locomotor:RemoveExternalSpeedMultiplier(inst.latchedtarget, "um_bear_trap") 
		inst.latchedtarget._bear_trap_speedmulttask = nil
	end
end

local function debuffremoval(inst)
	inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "um_bear_trap") 
	inst._bear_trap_speedmulttask = nil
end

local function OnExplode(inst, target)
    inst.AnimState:PlayAnimation("activate")
    if target then
		if inst.deathtask ~= nil then
			inst.deathtask:Cancel()
		end
		inst.deathtask = nil
	
        inst.SoundEmitter:PlaySound("dontstarve/common/trap_teeth_trigger")
        target.components.combat:GetAttacked(inst, TUNING.TRAP_TEETH_DAMAGE)
		
		inst.latchedtarget = target
		
        inst.entity:AddFollower():FollowSymbol(target.GUID, target.components.combat.hiteffectsymbol or "body", 0, --[[-50]]0, 0)
		
		local debuffkey = inst.prefab
		
		target.components.locomotor:SetExternalSpeedMultiplier(target, debuffkey, 0.3)
		
		inst:ListenForEvent("death", onfinished_normal, target)
		inst:ListenForEvent("onremoved", onfinished_normal, target)
		
		target._bear_trap_speedmulttask = target:DoTaskInTime(10, function(i) 
			i.components.locomotor:RemoveExternalSpeedMultiplier(i, debuffkey) 
			i._bear_trap_speedmulttask = nil
		end)
		
		inst:DoTaskInTime(10, function(inst) inst.components.health:Kill() end)
		
		inst.persists = false
		
		if target ~= nil and target.components.health:IsDead() then
			inst.components.health:Kill()
		end
    end
	
	inst:RemoveComponent("inventoryitem")
	inst:RemoveComponent("mine")
end

local function OnReset(inst)
    if inst.components.inventoryitem ~= nil then
        inst.components.inventoryitem.nobounce = true
    end
    if not inst:IsInLimbo() then
        inst.MiniMapEntity:SetEnabled(true)
    end
    if not inst.AnimState:IsCurrentAnimation("idle") then
        inst.SoundEmitter:PlaySound("dontstarve/common/trap_teeth_reset")
        inst.AnimState:PlayAnimation("land")
        inst.AnimState:PushAnimation("idle", false)
    end
end

local function SetSprung(inst)
    if inst.components.inventoryitem ~= nil then
        inst.components.inventoryitem.nobounce = true
    end
    if not inst:IsInLimbo() then
        inst.MiniMapEntity:SetEnabled(true)
    end
    inst.AnimState:PlayAnimation("idle_active")
end

local function SetInactive(inst)
    if inst.components.inventoryitem ~= nil then
        inst.components.inventoryitem.nobounce = false
    end
    inst.MiniMapEntity:SetEnabled(false)
    inst.AnimState:PlayAnimation("idle")
end

local function OnDropped(inst)
    inst.components.mine:Deactivate()
end

local function ondeploy(inst, pt, deployer)
    inst.components.mine:Reset()
    inst.Physics:Stop()
    inst.Physics:Teleport(pt:Get())
end

local function OnHaunt(inst, haunter)
    if inst.components.mine == nil or inst.components.mine.inactive then
        inst.components.hauntable.hauntvalue = TUNING.HAUNT_TINY
        Launch(inst, haunter, TUNING.LAUNCH_SPEED_SMALL)
        return true
    elseif not inst.components.mine.issprung then
        return false
    elseif math.random() <= TUNING.HAUNT_CHANCE_OFTEN then
        inst.components.hauntable.hauntvalue = TUNING.HAUNT_SMALL
        inst.components.mine:Reset()
        return true
    end
    return false
end

local function common_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.MiniMapEntity:SetIcon("trap_teeth.png")

    inst.AnimState:SetBank("lavaarena_trap_beartrap")
    inst.AnimState:SetBuild("lavaarena_trap_beartrap")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("trap")

        MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.latchedtarget = nil
	
    inst:AddComponent("inspectable")

	--inst:AddComponent("inventoryitem")
	--inst.components.inventoryitem:SetOnDroppedFn(OnDropped)

    inst:AddComponent("mine")
    inst.components.mine:SetRadius(TUNING.TRAP_TEETH_RADIUS)
    inst.components.mine:SetAlignment({ "walrus", "hound" })
    inst.components.mine:SetOnExplodeFn(OnExplode)
    inst.components.mine:SetOnResetFn(OnReset)
    inst.components.mine:SetOnSprungFn(SetSprung)
    inst.components.mine:SetOnDeactivateFn(SetInactive)
    inst.components.mine:Reset()
	
	inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.WALRUS_HEALTH)
    inst:ListenForEvent("death", onfinished_normal)

    inst:AddComponent("combat")
	
    inst:AddComponent("deployable")
    inst.components.deployable.ondeploy = ondeploy
    inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.LESS)

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetOnHauntFn(OnHaunt)
	
	inst.deathtask = inst:DoTaskInTime(30, onfinished_normal)

    return inst
end

local function OnHitInk(inst, attacker, target)
	local x, y, z = inst.Transform:GetWorldPosition()
	
	SpawnPrefab("antlion_sinkhole_boat").Transform:SetPosition(x, 0, z)
	
    inst:Remove()
end

local function oncollide(inst, other)
	local x, y, z = inst.Transform:GetWorldPosition()
	if other ~= nil and other:IsValid() and other:HasTag("_combat") or y <= inst:GetPhysicsRadius() + 0.001 then
		OnHitInk(inst, other)
	end
end

local function onthrown(inst)
    inst:AddTag("NOCLICK")
    inst.persists = false
    inst.AnimState:SetBank("lavaarena_trap_beartrap")
    inst.AnimState:SetBuild("lavaarena_trap_beartrap")
    inst.AnimState:PlayAnimation("spin_loop", true)
	
    inst.Physics:SetMass(1)
    inst.Physics:SetFriction(10)
    inst.Physics:SetDamping(5)
    inst.Physics:SetCollisionGroup(COLLISION.OBSTACLES)
    inst.Physics:ClearCollisionMask()
    inst:SetPhysicsRadiusOverride(3)
    inst.Physics:CollidesWith(COLLISION.WORLD)
    inst.Physics:CollidesWith(COLLISION.CHARACTERS)
    inst.Physics:SetCapsule(1.5, 1.5)
	
    inst.Physics:SetCollisionCallback(oncollide)
end

local function projectilefn()
    local inst = CreateEntity()
	
    inst:AddTag("bearger_boulder")

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddPhysics()
    inst.entity:AddNetwork()

	local shadow = inst.entity:AddDynamicShadow()
    shadow:SetSize( 1.5, 1 )

    inst.AnimState:SetBank("lavaarena_trap_beartrap")
    inst.AnimState:SetBuild("lavaarena_trap_beartrap")
	inst.AnimState:PlayAnimation("land")
	inst.AnimState:PushAnimation("idle", false)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("complexprojectile")
    inst.components.complexprojectile:SetHorizontalSpeed(15)
    inst.components.complexprojectile:SetGravity(-20)
    inst.components.complexprojectile:SetLaunchOffset(Vector3(0, .1, 0))
    inst.components.complexprojectile:SetOnLaunch(onthrown)
    inst.components.complexprojectile:SetOnHit(OnHitInk)
    inst.components.complexprojectile.usehigharc = false

    inst.persists = false

    inst:AddComponent("locomotor")

	--inst:DoTaskInTime(0.1, function(inst) inst:DoPeriodicTask(0, TestProjectileLand) end)

    return inst
end

return Prefab("um_bear_trap", common_fn, assets),
    MakePlacer("um_bear_trap_placer", "trap_teeth", "trap_teeth", "idle"),
    Prefab("um_bear_trap_projectile", projectilefn, assets_maxwell)
