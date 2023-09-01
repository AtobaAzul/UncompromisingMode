local assets =
{
    Asset("ANIM", "anim/portableboat.zip"),
}

local item_assets =
{
    Asset("ANIM", "anim/seafarer_boat.zip"),
    Asset("INV_IMAGE", "boat_item"),
}

local prefabs =
{
    "mast",
    "steeringwheel",
    "rudder",
    "boatlip",
    "boat_water_fx",
    "boat_leak",
    "fx_boat_crackle",
    "boatfragment03",
    "boatfragment04",
    "boatfragment05",
    "fx_boat_pop",
    "boat_player_collision",
    "boat_item_collision",
    "walkingplank",
}

local sounds ={
    place = "wes/characters/wes/blow_idle",
    creak = nil,
    damage = "wes/characters/wes/blow_idle",
    sink = "turnoftides/common/together/boat/sink",
    hit = "turnoftides/common/together/boat/hit",
    thunk = "turnoftides/common/together/boat/thunk",
    movement = "turnoftides/common/together/boat/movement",
}

local item_prefabs =
{
    "boat",
}

local function OnRepaired(inst)
    --inst.SoundEmitter:PlaySound("turnoftides/common/together/boat/repair_with_wood")
end

local function OnSpawnNewBoatLeak(inst, data)
	if data ~= nil then

		local damage = TUNING.BOAT.GRASSBOAT_LEAK_DAMAGE[data.leak_size]
		if damage ~= nil then
	        inst.components.health:DoDelta(-damage)
		end

		if data.playsoundfx then
			inst.SoundEmitter:PlaySoundWithParams(inst.sounds.damage, { intensity = 0.8 })
		end
	end
end

local function RemoveConstrainedPhysicsObj(physics_obj)
    if physics_obj:IsValid() then
        physics_obj.Physics:ConstrainTo(nil)
        physics_obj:Remove()
    end
end

local function AddConstrainedPhysicsObj(boat, physics_obj)
	physics_obj:ListenForEvent("onremove", function() RemoveConstrainedPhysicsObj(physics_obj) end, boat)

    physics_obj:DoTaskInTime(0, function()
		if boat:IsValid() then
			physics_obj.Transform:SetPosition(boat.Transform:GetWorldPosition())
   			physics_obj.Physics:ConstrainTo(boat.entity)
		end
	end)
end

local function on_start_steering(inst)
    if ThePlayer and ThePlayer.components.playercontroller ~= nil and ThePlayer.components.playercontroller.isclientcontrollerattached then
        inst.components.reticule:CreateReticule()
    end
end

local function on_stop_steering(inst)
    if ThePlayer and ThePlayer.components.playercontroller ~= nil and ThePlayer.components.playercontroller.isclientcontrollerattached then
        inst.lastreticuleangle = nil
        inst.components.reticule:DestroyReticule()
    end
end

local function ReticuleTargetFn(inst)

    local range = 7
    local pos = Vector3(inst.Transform:GetWorldPosition())

    local dir = Vector3()
    dir.x = TheInput:GetAnalogControlValue(CONTROL_MOVE_RIGHT) - TheInput:GetAnalogControlValue(CONTROL_MOVE_LEFT)
    dir.y = 0
    dir.z = TheInput:GetAnalogControlValue(CONTROL_MOVE_UP) - TheInput:GetAnalogControlValue(CONTROL_MOVE_DOWN)
    local deadzone = .3

    if math.abs(dir.x) >= deadzone or math.abs(dir.z) >= deadzone then
        dir = dir:GetNormalized()

        inst.lastreticuleangle = dir
    else
        if inst.lastreticuleangle then
            dir = inst.lastreticuleangle
        else
            return nil
        end
    end

    local Camangle = TheCamera:GetHeading()/180
    local theta = -PI *(0.5 - Camangle)

    local newx = dir.x * math.cos(theta) - dir.z *math.sin(theta)
    local newz = dir.x * math.sin(theta) + dir.z *math.cos(theta)

    pos.x = pos.x - (newx * range)
    pos.z = pos.z - (newz * range)

    return pos
end

local function EnableBoatItemCollision(inst)
    if not inst.boat_item_collision then
        inst.boat_item_collision = SpawnPrefab("portableboat_item_collision")
        AddConstrainedPhysicsObj(inst, inst.boat_item_collision)
    end
end

local function DisableBoatItemCollision(inst)
    if inst.boat_item_collision then
        RemoveConstrainedPhysicsObj(inst.boat_item_collision) --also :Remove()s object
        inst.boat_item_collision = nil
    end
end

local function OnPhysicsWake(inst)
    EnableBoatItemCollision(inst)
    if inst.stopupdatingtask then
        inst.stopupdatingtask:Cancel()
        inst.stopupdatingtask = nil
    else
        inst.components.walkableplatform:StartUpdating()
    end
    inst.components.boatphysics:StartUpdating()
end

local function OnPhysicsSleep(inst)
    DisableBoatItemCollision(inst)
    inst.stopupdatingtask = inst:DoTaskInTime(1, function()
        inst.components.walkableplatform:StopUpdating()
        inst.stopupdatingtask = nil
    end)
    inst.components.boatphysics:StopUpdating()
end

local function StopBoatPhysics(inst)
    --Boats currently need to not go to sleep because
    --constraints will cause a crash if either the target object or the source object is removed from the physics world
    inst.Physics:SetDontRemoveOnSleep(false)
end

local function StartBoatPhysics(inst)
    inst.Physics:SetDontRemoveOnSleep(true)
end

local function speed(inst)
    if not inst.startpos then

        inst.startpos = Vector3(inst.Transform:GetWorldPosition())
        inst.starttime = GetTime()
        inst.speedtask = inst:DoPeriodicTask(FRAMES, function()
            local pt = Vector3(inst.Transform:GetWorldPosition())
            local dif = distsq(pt.x,pt.z,inst.startpos.x,inst.startpos.z)
        end)
    else
        inst.startpos = nil
        inst.speedtask:Cancel()
        inst.speedtask = nil
        inst.starttime = nil
    end
end

local function OnDismantle(inst, doer)
    inst.AnimState:PlayAnimation("plug_remove")
	
	SpawnPrefab("splash").Transform:SetPosition(inst.Transform:GetWorldPosition())
	
	inst.portaraft.boatreciever = doer
	inst.portaraft.rechargerate = inst.portaraft.components.health:GetPercent()
	
	inst.portaraft.components.health:Kill()
	
	inst:ListenForEvent("animover", function(inst)
		inst:Remove()
	end)
end

local function OnEntityReplicated(inst)
    --Use this setting because we can rotate, and we are not billboarded with discreet anim facings
    --NOTE: this setting can only be applied after entity replicated
    inst.Transform:SetInterpolateRotation(true)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("boat.png")
    inst.entity:AddNetwork()

    inst:AddTag("ignorewalkableplatforms")
	inst:AddTag("antlion_sinkhole_blocker")
	inst:AddTag("boat")
    inst:AddTag("wood")
    inst:AddTag("blocker")
    inst:AddTag("portableraft")

    local radius = 3
    local max_health = TUNING.BOAT.HEALTH / 2

    local phys = inst.entity:AddPhysics()
    phys:SetMass(TUNING.BOAT.MASS)
    phys:SetFriction(0)
    phys:SetDamping(5)
    phys:SetCollisionGroup(COLLISION.OBSTACLES)
    phys:ClearCollisionMask()
    phys:CollidesWith(COLLISION.WORLD)
    phys:CollidesWith(COLLISION.OBSTACLES)
    phys:SetCylinder(radius, 3)

    inst.AnimState:SetBank("portableboat")
    inst.AnimState:SetBuild("portableboat")
    inst.AnimState:SetSortOrder(ANIM_SORT_ORDER.OCEAN_BOAT)
	inst.AnimState:SetFinalOffset(1)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetScale(radius / 4, radius / 4, radius / 4)

    inst:AddComponent("walkableplatform")
    inst.components.walkableplatform.platform_radius = radius
    inst.components.walkableplatform.player_collision_prefab = "portableboat_player_collision"

    inst:AddComponent("healthsyncer")
    inst.components.healthsyncer.max_health = max_health

	--AddConstrainedPhysicsObj(inst, SpawnPrefab("portableboat_item_collision")) -- hack until physics constraints are networked

    inst:AddComponent("waterphysics")
    inst.components.waterphysics.restitution = 0.75

    inst:AddComponent("reticule")
    inst.components.reticule.targetfn = ReticuleTargetFn
    inst.components.reticule.ispassableatallpoints = true
    inst.on_start_steering = on_start_steering
    inst.on_stop_steering = on_stop_steering

    inst.doplatformcamerazoom = net_bool(inst.GUID, "doplatformcamerazoom", "doplatformcamerazoomdirty")

	if not TheNet:IsDedicated() then
        inst:ListenForEvent("endsteeringreticule", function(inst,data)  if ThePlayer and ThePlayer == data.player then inst:on_stop_steering() end end)
        inst:ListenForEvent("starsteeringreticule", function(inst,data) if ThePlayer and ThePlayer == data.player then inst:on_start_steering() end end)

        inst:AddComponent("boattrail")
	end

    inst:AddComponent("boatringdata")
    inst.components.boatringdata:SetRadius(radius)
    inst.components.boatringdata:SetNumSegments(8)
	
    inst.walksound = "moss"

	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        inst.OnEntityReplicated = OnEntityReplicated
        return inst
    end
	
    inst.Physics:SetDontRemoveOnSleep(true)
    inst.item_collision_prefab = "portableboat_item_collision"
    EnableBoatItemCollision(inst)

    inst.entity:AddPhysicsWaker() --server only component
    inst.PhysicsWaker:SetTimeBetweenWakeTests(TUNING.BOAT.WAKE_TEST_TIME)

    inst:AddComponent("hull")
    inst.components.hull:SetRadius(radius)
	local boatlip = SpawnPrefab("boatlip")
	boatlip.AnimState:SetScale(0.7, 0.7, 0.7)
	inst.components.hull:SetBoatLip(boatlip)
   -- local playercollision = SpawnPrefab("portableboat_player_collision")
	--inst.components.hull:AttachEntityToBoat(playercollision, 0, 0)
	
    local walking_plank = SpawnPrefab("portableplank")
    local edge_offset = -0.05
    inst.components.hull:AttachEntityToBoat(walking_plank, 0, 3 + edge_offset, true)
    inst.components.hull:SetPlank(walking_plank)
	
    local ripcord = SpawnPrefab("portableboat_ripcord")
    inst.components.hull:AttachEntityToBoat(ripcord, 0, 0, true)
	ripcord.portaraft = inst

    inst:AddComponent("repairable")
    --inst.components.repairable.repairmaterial = MATERIALS.WOOD
    inst.components.repairable.onrepaired = OnRepaired

    inst:AddComponent("boatring")

    inst:AddComponent("hullhealth")
    inst.components.hullhealth.leakproof = true
	
    inst:AddComponent("boatphysics")
	inst.components.boatphysics.max_velocity = TUNING.BOAT.MAX_VELOCITY_MOD * 1.5
	
    inst:AddComponent("boatdrifter")
    inst:AddComponent("savedrotation")

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(max_health)
	inst.components.health:StartRegen(-1, 2)
    inst.components.health.nofadeout = true

    inst:SetStateGraph("SGportableboat")

	inst:ListenForEvent("spawnnewboatleak", OnSpawnNewBoatLeak)
    inst.boat_crackle = "fx_boat_crackle"

    inst.StopBoatPhysics = StopBoatPhysics
    inst.StartBoatPhysics = StartBoatPhysics

    inst.OnPhysicsWake = OnPhysicsWake
    inst.OnPhysicsSleep = OnPhysicsSleep

    inst.sinkloot = function() end
	
    inst.speed = speed

    inst.sounds = sounds

    return inst
end

local function build_boat_collision_mesh(radius, height)
    local segment_count = 20
    local segment_span = math.pi * 2 / segment_count

    local triangles = {}
    local y0 = 0
    local y1 = height

    for segement_idx = 0, segment_count do

        local angle = segement_idx * segment_span
        local angle0 = angle - segment_span / 2
        local angle1 = angle + segment_span / 2

        local x0 = math.cos(angle0) * radius
        local z0 = math.sin(angle0) * radius

        local x1 = math.cos(angle1) * radius
        local z1 = math.sin(angle1) * radius

        table.insert(triangles, x0)
        table.insert(triangles, y0)
        table.insert(triangles, z0)

        table.insert(triangles, x0)
        table.insert(triangles, y1)
        table.insert(triangles, z0)

        table.insert(triangles, x1)
        table.insert(triangles, y0)
        table.insert(triangles, z1)

        table.insert(triangles, x1)
        table.insert(triangles, y0)
        table.insert(triangles, z1)

        table.insert(triangles, x0)
        table.insert(triangles, y1)
        table.insert(triangles, z0)

        table.insert(triangles, x1)
        table.insert(triangles, y1)
        table.insert(triangles, z1)
    end

	return triangles
end

local PLAYER_COLLISION_MESH = build_boat_collision_mesh(3.1, 3)
local ITEM_COLLISION_MESH = build_boat_collision_mesh(3.2, 3)

local function boat_player_collision_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
	inst.entity:AddNetwork()

    local phys = inst.entity:AddPhysics()
    phys:SetMass(0)
    phys:SetFriction(0)
    phys:SetDamping(5)
    phys:SetCollisionGroup(COLLISION.BOAT_LIMITS)
    phys:ClearCollisionMask()
    phys:CollidesWith(COLLISION.CHARACTERS)
    phys:CollidesWith(COLLISION.WORLD)
    phys:SetTriangleMesh(PLAYER_COLLISION_MESH)

    inst:AddTag("NOBLOCK")
    inst:AddTag("NOCLICK")
    inst:AddTag("portableraft")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.persists = false

    return inst
end

local function boat_item_collision_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()

    --[[Non-networked entity]]
    inst:AddTag("CLASSIFIED")

    local phys = inst.entity:AddPhysics()
    phys:SetMass(1000)
    phys:SetFriction(0)
    phys:SetDamping(5)
    phys:SetCollisionGroup(COLLISION.BOAT_LIMITS)
    phys:ClearCollisionMask()
    phys:CollidesWith(COLLISION.ITEMS)
    phys:CollidesWith(COLLISION.FLYERS)
    phys:CollidesWith(COLLISION.WORLD)
    phys:SetTriangleMesh(ITEM_COLLISION_MESH)
    --Boats currently need to not go to sleep because
    --constraints will cause a crash if either the target object or the source object is removed from the physics world
    --while the above is still true, the constraint is now properly removed before despawning the object, and can be safely ignored for this object, kept for future copy/pasting.
    phys:SetDontRemoveOnSleep(true)

    inst:AddTag("NOBLOCK")
    inst:AddTag("ignorewalkableplatforms")
    inst:AddTag("portableraft")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    return inst
end

local function ondeploy(inst, pt, deployer)
    local boat = SpawnPrefab("portableboat")
    if boat ~= nil then
        boat.Physics:SetCollides(false)
        boat.Physics:Teleport(pt.x, 0, pt.z)
        boat.Physics:SetCollides(true)

        boat.sg:GoToState("place")

		boat.components.hull:OnDeployed()

        inst:Remove()
    end
end

local function OnCharged(inst)
    inst.components.deployable.restrictedtag = "player"
end

local function item_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst:AddTag("boatbuilder")
	inst:AddTag("usedeployspacingasoffset")
    
    MakeInventoryPhysics(inst, 3000)

    inst.AnimState:SetBank("portableboat_item")
    inst.AnimState:SetBuild("portableboat_item")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryFloatable(inst, "med", 0.25, 0.83)
	inst.Physics:SetFriction(0.3)
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("rechargeable")
    inst.components.rechargeable:SetOnChargedFn(OnCharged)
	
    inst:AddComponent("deployable")
    inst.components.deployable.restrictedtag = "player"
    inst.components.deployable.ondeploy = ondeploy
    inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.PLACER_DEFAULT)
    inst.components.deployable:SetDeployMode(DEPLOYMODE.WATER)

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/portableboat_item.xml"

    MakeLargePropagator(inst)
    MakeHauntableLaunch(inst)

    return inst
end

local function cord_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("portableboat")
    inst.AnimState:SetBuild("portableboat")
    inst.AnimState:PlayAnimation("plug_place")
    inst.AnimState:PushAnimation("plug_idle", false)

    inst:AddTag("ignorewalkableplatforms")
    inst:AddTag("boat_ripcord")
	
	inst.Transform:SetScale(0.65, 0.65, 0.65)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
    --inst:AddComponent("inspectable")
	
    inst:AddComponent("portablestructure")
    inst.components.portablestructure:SetOnDismantleFn(OnDismantle)
	
    inst.persists = false
	
    return inst
end

local function lipfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst:AddTag("NOBLOCK")
    inst:AddTag("DECOR")

    inst.AnimState:SetBank("portableboat")
    inst.AnimState:SetBuild("portableboat")
    inst.AnimState:PlayAnimation("lip", true)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGroundFixed)
    inst.AnimState:SetLayer(LAYER_BELOW_GROUND)
    inst.AnimState:SetSortOrder(ANIM_SORT_ORDER_BELOW_GROUND.BOAT_LIP)
    inst.AnimState:SetFinalOffset(0)
    inst.AnimState:SetOceanBlendParams(TUNING.OCEAN_SHADER.EFFECT_TINT_AMOUNT)
    inst.AnimState:SetInheritsSortKey(false)

    inst.Transform:SetRotation(90)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    return inst
end

local function fakefn()
    local inst = CreateEntity()
	
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst:AddTag("walkingplank")
    inst:AddTag("FX")

    inst:AddTag("ignorewalkableplatforms") -- because it is a child of the boat    
	
    inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end

    inst:SetStateGraph("SGwalkingplank")
	
    inst:AddComponent("walkingplank")
    inst.persists = false
	
    return inst
end

return Prefab("portableboat", fn, assets, prefabs),
       Prefab("portableboat_player_collision", boat_player_collision_fn),
       Prefab("portableboat_item_collision", boat_item_collision_fn),
       Prefab("portableboat_item", item_fn, item_assets, item_prefabs),
       Prefab("portableboat_ripcord", cord_fn, item_assets, item_prefabs),
	   Prefab("portableboatlip", lipfn, assets, prefabs),
	   Prefab("portableplank", fakefn, assets, prefabs),
       MakePlacer("portableboat_item_placer", "portableboat_placer", "portableboat_test", "placer", true, false, false, 0.8, nil, nil, nil, 0)