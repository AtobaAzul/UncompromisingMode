local assets =
{
    Asset("ANIM", "anim/searock_arches.zip"),
}


SetSharedLootTable( 'seastack',
{
    {'rocks',  1.00},
    {'rocks',  1.00},
    {'rocks',  1.00},
    {'rocks',  1.00},
})

local function updateart(inst)
    --[[local workleft = inst.components.workable.workleft
    inst.AnimState:PlayAnimation(
        (workleft > 6 and inst.stackid.."_full") or
        (workleft > 3 and inst.has_medium_state and inst.stackid.."_med") or inst.stackid.."_low"
    )]]
end

local function OnWork(inst, worker, workleft)
    if workleft <= 0 then
        TheWorld:PushEvent("CHEVO_seastack_mined", {target=inst,doer=worker})
        local pt = inst:GetPosition()
        SpawnPrefab("rock_break_fx").Transform:SetPosition(pt:Get())

        local loot_dropper = inst.components.lootdropper

        inst:SetPhysicsRadiusOverride(nil)

        loot_dropper:DropLoot(pt)

        inst:Remove()
    else
        updateart(inst)
    end
end

local DAMAGE_SCALE = 0.5
local function OnCollide(inst, data)
    local boat_physics = data.other.components.boatphysics
    if boat_physics ~= nil then
        local hit_velocity = math.floor(math.abs(boat_physics:GetVelocity() * data.hit_dot_velocity) * DAMAGE_SCALE / boat_physics.max_velocity + 0.5)
        inst.components.workable:WorkedBy(data.other, hit_velocity * TUNING.SEASTACK_MINE)
    end
end

local function onsave(inst, data)
    data.stackid = inst.stackid
	data.friend = inst.friend
	data.hasFriend = inst.hasFriend
end

local function onload(inst, data)
    updateart(inst)
	if data.hasFriend then
		inst.hasFriend = data.hasFriend
	end
	if data.friend then
		data.friend = inst.friend
	end
end

local function SpawnFriend(inst)
	if inst.hasFriend == false then
		local x,y,z = inst.Transform:GetWorldPosition()
		local friend = SpawnPrefab("searock_arches")
		friend.Transform:SetPosition(x+6.1,y,z)
		friend.friend = inst
		inst.friend = friend
		inst.hasFriend = true
		friend.hasFriend = true
	end
end

local function FaceFriend(inst) --Will have to do it differently when the rocks can be destroyed
	local x,y,z = inst.friend.Transform:GetWorldPosition()
	inst:ForceFacePoint(x,y,z)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst.MiniMapEntity:SetIcon("seastack.png")

    inst:SetPhysicsRadiusOverride(2.35)
	inst.Transform:SetEightFaced()
    MakeWaterObstaclePhysics(inst, 0.80, 2, 0.75)

    inst:AddTag("ignorewalkableplatforms")
    inst:AddTag("seastack")

    inst.AnimState:SetBank("searock_arches")
    inst.AnimState:SetBuild("searock_arches")
    inst.AnimState:PlayAnimation("full")

    MakeInventoryFloatable(inst, "med", 0.1, {1.1, 1.1, 1.1})
    inst.components.floater.bob_percent = 0

    local land_time = (POPULATING and math.random()*5*FRAMES) or 0
    inst:DoTaskInTime(land_time, function(inst)
        inst.components.floater:OnLandedServer()
    end)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable('seastack')
    inst.components.lootdropper.max_speed = 2
    inst.components.lootdropper.min_speed = 0.3
    inst.components.lootdropper.y_speed = 14
    inst.components.lootdropper.y_speed_variance = 4
    inst.components.lootdropper.spawn_loot_inside_prefab = true

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.MINE)
    inst.components.workable:SetWorkLeft(TUNING.SEASTACK_MINE)
    inst.components.workable:SetOnWorkCallback(OnWork)
    inst.components.workable.savestate = true

    inst:AddComponent("inspectable")


    MakeHauntableWork(inst)

    inst:ListenForEvent("on_collide", OnCollide)

    if not POPULATING then
        updateart(inst)
    end
	inst.hasFriend = false
	inst:DoTaskInTime(0,SpawnFriend)
	inst:DoTaskInTime(1,FaceFriend)
    --------SaveLoad
    inst.OnSave = onsave
    inst.OnLoad = onload

    return inst
end

return Prefab("searock_arches", fn, assets)