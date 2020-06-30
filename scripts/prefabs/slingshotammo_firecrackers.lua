local assets =
{
    Asset("ANIM", "anim/slingshotammo.zip"),
}


local assets_firecrackers =
{
    Asset("ANIM", "anim/firecrackers.zip"),
}

local prefabs_firecrackers =
{
    "explode_firecrackers",
}

-- temp aggro system for the slingshots
local function no_aggro(attacker, target)
	local targets_target = target.components.combat.target
	return targets_target ~= nil and targets_target:IsValid() and targets_target ~= attacker 
			and (GetTime() - target.components.combat.lastwasattackedbytargettime) < 4
			and (targets_target.components.health ~= nil and not targets_target.components.health:IsDead())
end

local function DealDamage(inst, attacker, target)
    if target ~= nil and target:IsValid() and target.components.combat ~= nil then
		target.components.combat.temp_disable_aggro = no_aggro(attacker, target)
        target.components.combat:GetAttacked(attacker, TUNING.SLINGSHOT_AMMO_DAMAGE_ROCKS, inst)
		target.components.combat.temp_disable_aggro = false
    end
end

local function ImpactFx(inst, attacker, target)
    if target ~= nil and target:IsValid() and target.components.combat.hiteffectsymbol ~= nil then
		local impactfx = SpawnPrefab("explode_firecrackers")
		impactfx.Transform:SetPosition(target.Transform:GetWorldPosition())
--[[
		if inst.ammo_def.hit_sound ~= nil then
			inst.SoundEmitter:PlaySound(inst.ammo_def.hit_sound)
		end]]
    end
end

local function OnHit(inst, attacker, target)
	DealDamage(inst, attacker, target)
    ImpactFx(inst, attacker, target)

    inst:Remove()
end

local function SpawnFirecrackers(inst, pt, starting_angle, attacker)
    local fireworks = SpawnPrefab("firecrackers_slingshot")
    if fireworks ~= nil then
        fireworks.Transform:SetPosition(pt.x, 0, pt.z)
		fireworks.components.burnable:Ignite()
		fireworks.attacker = attacker
		--fireworks:TheAttacker(attacker)
    end
end

local function OnHit_Firecrackers(inst, attacker, target)
    DealDamage(inst, attacker, target)
    ImpactFx(inst, attacker, target)

    local pt
    if target ~= nil and target:IsValid() then
        pt = target:GetPosition()
    else
        pt = inst:GetPosition()
        target = nil
    end

	local theta = math.random() * 2 * PI
	SpawnFirecrackers(target, pt, theta, attacker)

    inst:Remove() 
end

local function OnMiss(inst, owner, target)
--	if TheWorld.Map:IsVisualGroundAtPoint(x, y, z) then 
--		splash
--	else
--		ground impact
--	end

    inst:Remove()
end

local function projectile_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.Transform:SetFourFaced()

    MakeProjectilePhysics(inst)

    inst.AnimState:SetBank("slingshotammo")
    inst.AnimState:SetBuild("slingshotammo_firecracker")
    inst.AnimState:PlayAnimation("spin_loop", true)

    --projectile (from projectile component) added to pristine state for optimization
    inst:AddTag("projectile")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    inst:AddComponent("projectile")
	inst.components.projectile.hascustomattack = true
    inst.components.projectile:SetSpeed(25)
    inst.components.projectile:SetHoming(false)
    inst.components.projectile:SetHitDist(1.5)
    inst.components.projectile:SetOnHitFn(OnHit_Firecrackers)
    inst.components.projectile:SetOnMissFn(OnMiss)
    inst.components.projectile.range = 30

    return inst
end

local function inv_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetRayTestOnBB(true)
    inst.AnimState:SetBank("slingshotammo")
    inst.AnimState:SetBuild("slingshotammo_firecracker")
    inst.AnimState:PlayAnimation("idle")
    inst.Transform:SetScale(1.3,1.3,1.3)

    inst:AddTag("molebait")
	inst:AddTag("slingshotammo")
	inst:AddTag("reloaditem_ammo")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("reloaditem")

    inst:AddComponent("edible")
    inst.components.edible.foodtype = FOODTYPE.ELEMENTAL
    inst.components.edible.hungervalue = 1
    inst:AddComponent("tradable")

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_TINYITEM

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/slingshotammo_firecrackers.xml"
    inst.components.inventoryitem:SetSinks(true)

    inst:AddComponent("bait")
    MakeHauntableLaunch(inst)

    return inst
end

local STARTLE_TAGS = { "canbestartled" }

local function TheAttacker(attacker)
	inst.attacker = attacker
end

local function DoPop(inst, remaining, total, level, hissvol)
    local x, y, z = inst.Transform:GetWorldPosition()
    SpawnPrefab("explode_firecrackers").Transform:SetPosition(x, y, z)
	
	for i, v in ipairs(TheSim:FindEntities(x, y, z, 2.2, "_combat", { "shadow", "INLIMBO"})) do
		if v.components.combat ~= nil and v.components.combat ~= nil then
			if not v.components.health:IsDead() then
				v.components.combat:GetAttacked(inst.attacker or nil, 5, inst)
			end
		end
    end

    for i, v in ipairs(TheSim:FindEntities(x, y, z, TUNING.FIRECRACKERS_STARTLE_RANGE, STARTLE_TAGS)) do
        v:PushEvent("startle", { source = inst })
    end

    if remaining > 1 then
        inst.AnimState:PlayAnimation("spin_loop"..tostring(math.random(3)))

        if hissvol > .5 then
            hissvol = hissvol - .1
            inst.SoundEmitter:SetVolume("hiss", hissvol)
        end

        local newlevel = 8 - math.ceil(8 * remaining / total)
        for i = level + 1, newlevel do
            inst.AnimState:Hide("F"..tostring(i))
        end

        local angle = math.random() * 2 * PI
        local spd = 1.5
        inst.Physics:Teleport(x, math.max(y * .5, .1), z)
        inst.Physics:SetVel(math.cos(angle) * spd, 8, math.sin(angle) * spd)

        --23 frames in spin_loop, so if the delay gets longer, loop the anim
        inst:DoTaskInTime(.3 + .3 * math.random(), DoPop, remaining - 1, total, newlevel, hissvol)
    else
        inst:Remove()
    end
end

local function StartExploding(inst)
    inst:RemoveComponent("burnable")
    inst:AddTag("NOCLICK")
    inst:AddTag("scarytoprey")
    inst.Physics:SetFriction(.2)
    DoPop(inst, 8, 8, 0, 1)
    inst:RemoveComponent("stackable")
    inst.persists = false
end

local function StartFuse(inst)
    inst.starttask = nil
    inst:RemoveComponent("burnable")

    inst.AnimState:PlayAnimation("burn")
    inst.SoundEmitter:PlaySound("dontstarve/common/blackpowder_fuse_LP", "hiss")

    inst:DoTaskInTime(inst.AnimState:GetCurrentAnimationLength(), StartExploding, math.floor(33.4 * math.sqrt(inst.components.stackable:StackSize() + 3) - 58.8 + .5))

    inst:RemoveComponent("stackable")
    inst.persists = false
end

local function OnIgniteFn(inst)
    if inst.starttask == nil then
        inst.starttask = inst:DoTaskInTime(0, StartExploding)
    end
    inst.components.inventoryitem.canbepickedup = false
end

local function OnExtinguishFn(inst)
    if inst.starttask ~= nil then
        inst.starttask:Cancel()
        inst.starttask = nil
        inst.components.burnable:Ignite()
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("firecrackers")
    inst.AnimState:SetBuild("firecrackers")
    inst.AnimState:PlayAnimation("idle")
    inst.Transform:SetScale(0.9,0.9,0.9)

    inst:AddTag("explosive")

    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inventoryitem")

    inst:AddComponent("inspectable")

    inst:AddComponent("burnable")
    inst.components.burnable:SetOnIgniteFn(DefaultBurnFn)
    inst.components.burnable:SetOnExtinguishFn(DefaultExtinguishFn)

    inst.components.burnable:SetBurnTime(nil)
    inst.components.burnable:SetOnIgniteFn(OnIgniteFn)
    inst.components.burnable:SetOnExtinguishFn()

	--inst:ListenForEvent("findattacker", data)

    MakeHauntableLaunchAndIgnite(inst)
	
    inst.persists = false

    return inst
end


return Prefab("slingshotammo_firecrackers", inv_fn, assets, prefabs),
		Prefab("slingshotammo_firecrackers_proj", projectile_fn, assets, prefabs),
		Prefab("firecrackers_slingshot", fn, assets_firecrackers, prefabs_firecrackers)