--Essentially just a copy-pasted normal driftwood tree, but, you know, ours.
--Not sure if it'll have any special interactions or anything.
--It's large, so we'll need both the left AND right chopping anims.

local driftwood_waterlogged_assets =
{
    Asset("ANIM", "anim/driftwood_normal.zip"),
    Asset("MINIMAP_IMAGE", "driftwood_small1"),
}

local prefabs =
{
    "driftwood_log",
    "twigs",
    "charcoal",
}

SetSharedLootTable( 'driftwood_waterlogged',
{
    {'twigs',           1.0},
    {'twigs',           1.0},
    {'driftwood_log',   1.0},
    {'driftwood_log',   1.0},
    {'driftwood_log',   1.0},
    {'driftwood_log',   1.0},
})


local function on_chop(inst, chopper, remaining_chops)
    if not (chopper ~= nil and chopper:HasTag("playerghost")) then
        inst.SoundEmitter:PlaySound("turnoftides/common/together/driftwood/chop")
    end

    if remaining_chops > 0 then
        inst.AnimState:PlayAnimation("chop_normal")
    end
end

local function dig_up_driftwood_stump(inst, chopper)
    inst.components.lootdropper:SpawnLootPrefab("driftwood_log")
    inst:Remove()
end

local function make_stump(inst, is_burnt)
    inst:RemoveComponent("workable")
    inst:RemoveComponent("burnable")
    inst:RemoveComponent("propagator")
    inst:RemoveComponent("hauntable")
    if not is_burnt then
        MakeSmallBurnable(inst)
        MakeSmallPropagator(inst)
        MakeHauntableIgnite(inst)

        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.DIG)
        inst.components.workable:SetOnFinishCallback(dig_up_driftwood_stump)
        inst.components.workable:SetWorkLeft(1)
    end
    RemovePhysicsColliders(inst)
    inst:AddTag("stump")
end

local function on_chopped_down(inst, chopper)
    inst.SoundEmitter:PlaySound("dontstarve/forest/appear_wood")
    inst.SoundEmitter:PlaySound("dontstarve/forest/treeCrumble",nil,.4)

    if inst.is_large then
        -- The tall driftwood tree has a different falling animations depending on its position
        -- relative to the character chopping it down. Also affects loot spawn location.
        local pt = inst:GetPosition()
        local theirpos = chopper:GetPosition()
        local he_right = (theirpos - pt):Dot(TheCamera:GetRightVec()) > 0
        if he_right then
            inst.AnimState:PlayAnimation("fallleft_normal")
            inst.components.lootdropper:DropLoot(pt - TheCamera:GetRightVec())
        else
            inst.AnimState:PlayAnimation("fallright_normal")
            inst.components.lootdropper:DropLoot(pt + TheCamera:GetRightVec())
        end
        inst:ListenForEvent("animover", inst.Remove)
    else
        -- Small trees just crumble and die.
        inst.AnimState:PlayAnimation("fall")
        inst.components.lootdropper:DropLoot()
        inst:ListenForEvent("animover", inst.Remove)
    end
end

local function on_chopped_down_burnt(inst, chopper)
    inst.SoundEmitter:PlaySound("dontstarve/forest/treeCrumble")

    if not (chopper ~= nil and chopper:HasTag("playerghost")) then
        inst.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_tree")
    end

    inst.AnimState:PlayAnimation("chop_burnt_normal")

    if not inst.is_large then
        make_stump(inst, true)
    end

    inst:ListenForEvent("animover", inst.Remove)
    inst.components.lootdropper:DropLoot()
end

local function on_burnt(inst)
    inst:RemoveComponent("burnable")
    inst:RemoveComponent("propagator")
    inst:RemoveComponent("hauntable")
    MakeHauntableWork(inst)

    inst.components.lootdropper:SetChanceLootTable(nil)
    inst.components.lootdropper:SetLoot({"charcoal"})

    inst.components.workable:SetWorkLeft(1)
    inst.components.workable:SetOnWorkCallback(nil)
    inst.components.workable:SetOnFinishCallback(on_chopped_down_burnt)
    inst.AnimState:PlayAnimation("burnt")
    inst:AddTag("burnt")
end

local function GetStatus(inst)
    return (inst:HasTag("burnt") and "BURNT")
        or (inst:HasTag("stump") and "CHOPPED")
        or (inst.components.burnable ~= nil and
            inst.components.burnable:IsBurning() and
            "BURNING")
        or nil
end

local function onsave(inst, data)
    if inst:HasTag("burnt") or (inst.components.burnable ~= nil and inst.components.burnable:IsBurning()) then
        data.burnt = true
    end
    if inst:HasTag("stump") then
        data.stump = true
    end
end

local function onload(inst, data)
    if data == nil then
        return
    end

    if data.stump then
        local is_burnt = data.burnt or inst:HasTag("burnt")

        make_stump(inst, is_burnt)

        inst.AnimState:PlayAnimation("stump", false)
        if is_burnt then
            DefaultBurntFn(inst)
        end
    elseif data.burnt and not inst:HasTag("burnt") then
        -- Make the appropriate driftwood burnt function, then immediately call it on the instance we're loading.
        on_burnt(inst)
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

local function fn(type_name, is_large)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    -- Seems kind of counterintuitive, but the 'large' trees are taller, and have a smaller (tree-like) radius.
    local physics_size = is_large and .25 or 1
    MakeObstaclePhysics(inst, is_large and .25 or 1)

    -- All driftwood trees are sharing a single minimap icon, since they're functionally the same.
    inst.MiniMapEntity:SetIcon("driftwood_small1.png")
    inst.MiniMapEntity:SetPriority(-1)

    inst:AddTag("plant")
    inst:AddTag("tree")
    inst:AddTag("ignorewalkableplatforms")

    inst.AnimState:SetBank("driftwood_normal")
    inst.AnimState:SetBuild("driftwood_normal")

    inst.AnimState:PlayAnimation("idle")


    inst:SetPrefabNameOverride("DRIFTWOOD_TREE")

    MakeSnowCoveredPristine(inst)

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end


	inst.is_large = is_large

    MakeLargeBurnable(inst)
    inst.components.burnable:SetOnBurntFn(on_burnt)
    MakeMediumPropagator(inst)

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable(is_large and "driftwood_tree" or "driftwood_small")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.CHOP)

    MakeInventoryFloatable(inst, "med", 0, {1.1, 0.9, 1.1})
    inst.components.floater.bob_percent = 0

    local land_time = (POPULATING and math.random()*5*FRAMES) or 0
    inst:DoTaskInTime(land_time, function(inst)
        inst.components.floater:OnLandedServer()
    end)

    inst:ListenForEvent("on_collide", OnCollide)

    -- Enable the two types of driftwood to be tuned separately.
    local work_amount = is_large and TUNING.DRIFTWOOD_TREE_CHOPS or TUNING.DRIFTWOOD_SMALL_CHOPS
    inst.components.workable:SetWorkLeft(work_amount)

    inst.components.workable:SetOnWorkCallback(on_chop)
    inst.components.workable:SetOnFinishCallback(on_chopped_down)

    MakeHauntableWorkAndIgnite(inst)

    local color = 0.7 + math.random() * 0.3
    inst.AnimState:SetMultColour(color, color, color, 1)

    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = GetStatus
    inst.components.inspectable.nameoverride = "DRIFTWOOD_TREE"
    MakeWaterObstaclePhysics(inst, 0.80, 2, 0.75)

    inst.OnSave = onsave
    inst.OnLoad = onload

    MakeSnowCovered(inst)

	return inst
end

local function driftwood_waterlogged()
    return fn("waterlogged", true)
end

return Prefab("driftwood_waterlogged", driftwood_waterlogged, driftwood_waterlogged_assets, prefabs)