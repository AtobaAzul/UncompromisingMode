local COLLISION_SIZE = 1 --must be an int
local NEAR_DIST_SQ = 10 * 10
local FAR_DIST_SQ = 11 * 11

local UPDATE_INTERVAL = .2
local UPDATE_OFFSET = 0 --used to stagger periodic updates across entities

--V2C: Use a shared add/remove wall because regions may overlap
local PF_SHARED = {}

local function AddSharedWall(pathfinder, x, z, inst)
    local id = tostring(x)..","..tostring(z)
    if PF_SHARED[id] == nil then
        PF_SHARED[id] = { [inst] = true }
        pathfinder:AddWall(x, 0, z)
    else
        PF_SHARED[id][inst] = true
    end
end

local function RemoveSharedWall(pathfinder, x, z, inst)
    local id = tostring(x)..","..tostring(z)
    if PF_SHARED[id] ~= nil then
        PF_SHARED[id][inst] = nil
        if next(PF_SHARED[id]) ~= nil then
            return
        end
        PF_SHARED[id] = nil
    end
    pathfinder:RemoveWall(x, 0, z)
end

local function OnIsPathFindingDirty(inst)
    if inst._ispathfinding:value() then
        if inst._pftable == nil then
            inst._pftable = {}
            local pathfinder = TheWorld.Pathfinder
            local x, y, z = inst.Transform:GetWorldPosition()
            x = math.floor(x * 100 + .5) / 100
            z = math.floor(z * 100 + .5) / 100
            for dx = -COLLISION_SIZE, COLLISION_SIZE do
                local x1 = x + dx
                for dz = -COLLISION_SIZE, COLLISION_SIZE do
                    local z1 = z + dz
                    AddSharedWall(pathfinder, x1, z1, inst)
                    table.insert(inst._pftable, { x1, z1 })
                end
            end
        end
    elseif inst._pftable ~= nil then
        local pathfinder = TheWorld.Pathfinder
        for i, v in ipairs(inst._pftable) do
            RemoveSharedWall(pathfinder, v[1], v[2], inst)
        end
        inst._pftable = nil
    end
end

local function InitializePathFinding(inst, isready)
    if isready then
        inst:ListenForEvent("onispathfindingdirty", OnIsPathFindingDirty)
        OnIsPathFindingDirty(inst)
    else
        inst:DoTaskInTime(0, InitializePathFinding, true)
    end
end

local function updatephysics(inst)
    inst.Physics:SetCollisionGroup(COLLISION.OBSTACLES)
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.WORLD)
	if not inst.conceal then
		inst.Physics:CollidesWith(COLLISION.ITEMS)
		if inst.active then
			inst.Physics:CollidesWith(COLLISION.CHARACTERS)
		end
	end
end

local function OnActiveStateChanged(inst)
	updatephysics(inst)
end

local function OnConcealStateChanged(inst)
	OnActiveStateChanged(inst)
end


local function Raise(inst)
inst.conceal = nil
inst.active = true
OnConcealStateChanged(inst)
inst.sg:GoToState("raise")
end

local function Lower(inst)
inst.active = false
OnConcealStateChanged(inst)
inst.sg:GoToState("lower")
end

local function getstatus(inst)
    return inst.active and "ACTIVE" or "INACTIVE"
end

local function onremove(inst)
    inst._ispathfinding:set_local(false)
    OnIsPathFindingDirty(inst)
end

local function Initialize(inst)
	if TheWorld.components.ratacombs_junk_manager ~= nil then
		if TheWorld.components.ratacombs_junk_manager.areaoneblockers ~= nil then
			table.insert(TheWorld.components.ratacombs_junk_manager.areaoneblockers,inst)
		else
			TheWorld.components.ratacombs_junk_manager.areaoneblockers = {}
			table.insert(TheWorld.components.ratacombs_junk_manager.areaoneblockers,inst)
		end
	end
end

local function commonfn(tags)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, COLLISION_SIZE)

    inst.MiniMapEntity:SetIcon("obelisk.png")

    inst.AnimState:SetBank("blocker_sanity")
    inst.AnimState:SetBuild("blocker_sanity")
    inst.AnimState:PlayAnimation("idle_inactive")

    inst:AddTag("antlion_sinkhole_blocker")
	for _, v in ipairs(tags) do
		inst:AddTag(v)
	end

	updatephysics(inst)

    inst._pftable = nil
    inst._ispathfinding = net_bool(inst.GUID, "_ispathfinding", "onispathfindingdirty")
    InitializePathFinding(inst, TheWorld.ismastersim)

    inst.OnRemoveEntity = onremove

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.active = false
	inst.active_queue = false
--    inst.conceal = nil
--    inst.conceal_queued = nil
	inst:AddTag("ratacombsrock_lock")

    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = getstatus

    inst:SetStateGraph("SGnightmarerock")

	inst.lower = Lower
	inst.raise = Raise
	
	inst.OnActiveStateChanged = OnActiveStateChanged
	inst.OnConcealStateChanged = OnConcealStateChanged
	
	inst:DoTaskInTime(0,Initialize)
	inst:DoTaskInTime(0,Raise)
    return inst
end

local function insanityrock()
    local inst = commonfn({"insanityrock"})
    return inst
end
---------------------------------------------
local function IsAvoveGround(x,y,z)
return TheWorld.Map:IsVisualGroundAtPoint(x,y,z)
end


local function SpawnBarriersFromCoordsZ(inst,x,y,z)
	local voidfound = false
	local i = 1
	while voidfound == false do
		if not IsAvoveGround(x,y,z-i) then
			voidfound = true
			inst:Remove()
		else
			SpawnPrefab("ratacombslock_rock").Transform:SetPosition(x,y,z-i)
			i = i + 1
		end
	end
end

local function SpawnBarriersFromCoordsX(inst,x,y,z)
	SpawnPrefab("ratacombslock_rock").Transform:SetPosition(x,y,z)
	local voidfound = false
	local i = 1
	while voidfound == false do
		if not IsAvoveGround(x-i,y,z) then
			voidfound = true
		else
			SpawnPrefab("ratacombslock_rock").Transform:SetPosition(x-i,y,z)
			i = i + 1
		end
	end
end

local function Init(inst)
	local voidfound = false
	local i = 1
	while voidfound == false do
		local x,y,z = inst.Transform:GetWorldPosition()
		if not IsAvoveGround(x+i,y,z) then
			voidfound = true
			SpawnBarriersFromCoordsX(inst,x+i,y,z)
		else
			if not IsAvoveGround(x,y,z+i) then
				voidfound = true
				SpawnBarriersFromCoordsZ(inst,x,y,z+i)
			else
				i = i + 1
			end
		end
	end
end

local function spawnerfn() -- The blocker code from adv mode is unreliable, let's just spawn it ourselves.
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	inst:DoTaskInTime(0,Init)
	return inst
end
return Prefab("ratacombslock_rock", insanityrock),
	Prefab("ratacombslock_rock_spawner",spawnerfn)