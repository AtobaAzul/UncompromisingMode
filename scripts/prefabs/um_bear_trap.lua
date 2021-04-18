require "prefabutil"

local function onfinished_normal(inst)
	inst.DynamicShadow:Enable(false)
	
	if inst.deathtask ~= nil then
		inst.deathtask:Cancel()
	end
	inst.deathtask = nil
    inst:RemoveComponent("inventoryitem")
    inst:RemoveComponent("mine")
    inst.persists = false
    inst.Physics:SetActive(false)
	
	if not inst.Snapped then
		inst.AnimState:PlayAnimation("activate")
		inst.AnimState:PushAnimation("death", false)
	else
		inst.AnimState:PushAnimation("death", false)
	end
	
    inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
    inst:DoTaskInTime(3, inst.Remove)
	
	if inst.latchedtarget ~= nil then
		local pos = Vector3(inst.latchedtarget.Transform:GetWorldPosition())
		inst.latchedtarget.components.locomotor:RemoveExternalSpeedMultiplier(inst.latchedtarget, "um_bear_trap") 
		inst.latchedtarget._bear_trap_speedmulttask = nil
		inst.latchedtarget:RemoveChild(inst)
		inst.Physics:Teleport(pos.x,pos.y,pos.z) 
	end
end

local function debuffremoval(inst)
	inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "um_bear_trap") 
	inst._bear_trap_speedmulttask = nil
end

local function OnExplode(inst, target)
	if inst.deathtask == nil then
	inst.deathtask = inst:DoTaskInTime(30, onfinished_normal)
	end
	inst.Snapped = true
	inst.SoundEmitter:PlaySound("dontstarve/common/trap_teeth_trigger")
	--inst.SoundEmitter:PlaySound("dontstarve/impacts/impact_metal_armour_sharp")

    inst.AnimState:PlayAnimation("activate")
    if target then
		if inst.deathtask ~= nil then
			inst.deathtask:Cancel()
		end
		inst.deathtask = nil
	
        target.components.combat:GetAttacked(inst, TUNING.TRAP_TEETH_DAMAGE)
		
		inst.latchedtarget = target
		
		inst.AnimState:SetFinalOffset(-1)
		inst.Physics:Teleport(0,0,0)	
		target:AddChild(inst)
        --inst.entity:AddFollower():FollowSymbol(target.GUID, target.components.combat.hiteffectsymbol or "body", 0, --[[-50]]0, 0)
		
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
	inst.Snapped = false
    if inst.components.inventoryitem ~= nil then
        inst.components.inventoryitem.nobounce = true
    end
    if not inst:IsInLimbo() then
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
    end
    inst.AnimState:PlayAnimation("idle_active")
end

local function SetInactive(inst)
    if inst.components.inventoryitem ~= nil then
        inst.components.inventoryitem.nobounce = false
    end
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

local function OnAttacked(inst, worker)
    if not inst.components.health:IsDead() then
		if inst.Snapped then
			inst.SoundEmitter:PlaySound("dontstarve/impacts/impact_metal_armour_dull")
			inst.AnimState:PlayAnimation("hit")
		else
			OnExplode(inst, nil)
		end
    end
end

local function calculate_mine_test_time()
    return TUNING.STARFISH_TRAP_TIMING.BASE + (math.random() * TUNING.STARFISH_TRAP_TIMING.VARIANCE)
end

local function common_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local shadow = inst.entity:AddDynamicShadow()
    shadow:SetSize( 1.5, 1 )

    MakeInventoryPhysics(inst)


    inst.AnimState:SetBank("um_bear_trap")
    inst.AnimState:SetBuild("um_bear_trap")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("trap")
    inst:AddTag("bear_trap")
    inst:AddTag("smallcreature")
    inst:AddTag("mech")

	MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.latchedtarget = nil
	inst.Snapped = false
	
    inst:AddComponent("inspectable")
	
	inst.SoundEmitter:PlaySound("dontstarve/impacts/impact_metal_armour_blunt")

	--inst:AddComponent("inventoryitem")
	--inst.components.inventoryitem:SetOnDroppedFn(OnDropped)

    inst:AddComponent("mine")
    inst.components.mine:SetRadius(TUNING.TRAP_TEETH_RADIUS * 1.3)
    inst.components.mine:SetAlignment("bear_trap_immune")
    inst.components.mine:SetOnExplodeFn(OnExplode)
    inst.components.mine:SetOnResetFn(OnReset)
    inst.components.mine:SetOnSprungFn(SetSprung)
    inst.components.mine:SetOnDeactivateFn(SetInactive)
    inst.components.mine:SetTestTimeFn(calculate_mine_test_time)
    inst.components.mine:Reset()
	
	inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.WALRUS_HEALTH)
    inst:ListenForEvent("death", onfinished_normal)

    inst:AddComponent("combat")
    inst:ListenForEvent("attacked", OnAttacked)
	
    inst:AddComponent("deployable")
    inst.components.deployable.ondeploy = ondeploy
    inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.LESS)

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetOnHauntFn(OnHaunt)
	
	inst.deathtask = inst:DoTaskInTime(30, onfinished_normal)

    return inst
end

local function old_fn(build)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local shadow = inst.entity:AddDynamicShadow()
    shadow:SetSize( 1.5, 1 )

    MakeInventoryPhysics(inst)



    inst.AnimState:SetBank("um_bear_trap")
    inst.AnimState:SetBuild("um_bear_trap_old")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("trap")
    inst:AddTag("bear_trap")
    inst:AddTag("smallcreature")
    inst:AddTag("mech")

	MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.latchedtarget = nil
	inst.Snapped = false
	
    inst:AddComponent("inspectable")
	
	inst.SoundEmitter:PlaySound("dontstarve/impacts/impact_metal_armour_blunt")

	--inst:AddComponent("inventoryitem")
	--inst.components.inventoryitem:SetOnDroppedFn(OnDropped)

    inst:AddComponent("mine")
    inst.components.mine:SetRadius(TUNING.TRAP_TEETH_RADIUS * 1.3)
    inst.components.mine:SetAlignment("bear_trap_immune")
    inst.components.mine:SetOnExplodeFn(OnExplode)
    inst.components.mine:SetOnResetFn(OnReset)
    inst.components.mine:SetOnSprungFn(SetSprung)
    inst.components.mine:SetOnDeactivateFn(SetInactive)
    inst.components.mine:SetTestTimeFn(calculate_mine_test_time)
    inst.components.mine:Reset()
	
	inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.WALRUS_HEALTH)
    inst:ListenForEvent("death", onfinished_normal)

    inst:AddComponent("combat")
    inst:ListenForEvent("attacked", OnAttacked)
	
    inst:AddComponent("deployable")
    inst.components.deployable.ondeploy = ondeploy
    inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.LESS)

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetOnHauntFn(OnHaunt)
	
	--inst.deathtask = inst:DoTaskInTime(30, onfinished_normal) don't die

    return inst
end

local function OnHitInk(inst, target)
	local x, y, z = inst.Transform:GetWorldPosition()
	
	inst.trap = SpawnPrefab("um_bear_trap")
	inst.trap.Transform:SetPosition(x, 0, z)
	
    inst:Remove()
end

local function OnHitTarget(inst, target)
	local x, y, z = inst.Transform:GetWorldPosition()
	
	inst.trap = SpawnPrefab("um_bear_trap")
	inst.trap.Transform:SetPosition(x, 0, z)
	if target ~= nil then
		inst.trap.components.mine:Explode(target)
	end
	
    inst:Remove()
end

local function oncollide(inst, other)
	local x, y, z = inst.Transform:GetWorldPosition()
	if other ~= nil and not other:HasTag("walrus") and not other:HasTag("hound") and other:IsValid() and other:HasTag("_combat") then
		OnHitTarget(inst, other)
	elseif y <= inst:GetPhysicsRadius() + 0.001 then
		OnHitInk(inst, other)
	end
end

local function onthrown(inst)
    inst:AddTag("NOCLICK")
    inst.persists = false
    inst.AnimState:SetBank("um_bear_trap")
    inst.AnimState:SetBuild("um_bear_trap")
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
	
    inst:AddTag("bear_trap")

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddPhysics()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("um_bear_trap")
    inst.AnimState:SetBuild("um_bear_trap")
	inst.AnimState:PushAnimation("idle", false)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("complexprojectile")
    inst.components.complexprojectile:SetOnHit(OnHitInk)
    inst.components.complexprojectile:SetOnLaunch(onthrown)
    inst.components.complexprojectile:SetHorizontalSpeed(30)
    inst.components.complexprojectile:SetLaunchOffset(Vector3(2, 2, 0))
    inst.components.complexprojectile.usehigharc = false

    inst.persists = false

    inst:AddComponent("locomotor")

	--inst:DoTaskInTime(0.1, function(inst) inst:DoPeriodicTask(0, TestProjectileLand) end)

    return inst
end

local function DoSpawnTrap(x,y,z)
local xi = x+math.random(-7,7)
local zi = z+math.random(-7,7)															--Prevent traps from being placed inside things. Add more things to list as you please
if TheWorld.Map:IsAboveGroundAtPoint(xi, 0, zi) and #TheSim:FindEntities(xi,y,zi,1.5,{"giant_tree"}) and #TheSim:FindEntities(xi,y,zi,1.5,{"bear_trap"}) == 0 and #TheSim:FindEntities(xi,y,zi,5,{"bear_trap"}) < 2 then
local trap = SpawnPrefab("um_bear_trap_old")
trap.Transform:SetPosition(xi,y,zi)
else
DoSpawnTrap(x,y,z)
end
end

local function Spawntrap(inst)
local x,y,z = inst.Transform:GetWorldPosition()         --If the area is heavily lived in, bear traps will become a nuisance rather than a danger, know when to stop.
if #TheSim:FindEntities(x,y,z,10,{"bear_trap"}) < 3 and #TheSim:FindEntities(x,y,z,30,{"structure"}) < 20 and #TheSim:FindEntities(x,y,z,40,{"player"}) == 0 then
DoSpawnTrap(x,y,z)
end
inst.components.timer:StartTimer("spawntrap", 200+math.random(1000,2000))
end
local function ghost_walrusfn() --ghost walrus
    local inst = CreateEntity()
	

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddPhysics()
    inst.entity:AddNetwork()


    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	inst:AddTag("ghost_walrus")
	inst:AddTag("CLASSIFIED")

	inst:AddComponent("timer")
	if not inst.components.timer:TimerExists("spawntrap") then
	inst.components.timer:StartTimer("spawntrap", 2000+math.random(100,1000)) --ghost walrus leaves bear traps in the player's fridge
	end
	inst:ListenForEvent("timerdone", Spawntrap)

    return inst
end

return Prefab("um_bear_trap", common_fn),
    Prefab("um_bear_trap_old", old_fn),
    MakePlacer("um_bear_trap_placer", "trap_teeth", "trap_teeth", "idle"),
    Prefab("um_bear_trap_projectile", projectilefn),
	Prefab("ghost_walrus",ghost_walrusfn)
