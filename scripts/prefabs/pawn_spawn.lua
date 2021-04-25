local assets =
{
    Asset("ANIM", "anim/catcoon_den.zip"),
}

local prefabs =
{
    "um_pawn",
}

local function onhammered(inst)
    if inst.components.childspawner ~= nil then
        inst.components.childspawner:ReleaseAllChildren()
    end
    local x, y, z = inst.Transform:GetWorldPosition()
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(x, y, z)
    inst:Remove()
end

local function onhit(inst)
    if not inst.playing_dead_anim then
        inst.AnimState:PlayAnimation("hit", false)
    end
end

local function create_common(pawntype)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst:AddTag("cavedweller")
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    -------------------
    --[[inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.DIG)
    inst.components.workable:SetWorkLeft(4)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)]]   

    -------------------
    inst:AddComponent("childspawner")
    inst.components.childspawner.childname = "um_pawn"..pawntype
    inst.components.childspawner:SetRegenPeriod(TUNING.CATCOONDEN_REGEN_TIME)
    inst.components.childspawner:SetSpawnPeriod(1)
    inst.components.childspawner:SetMaxChildren(1)
    inst.components.childspawner:StartSpawning()

    return inst
end

local function pawn()
    local inst = create_common("")

    if not TheWorld.ismastersim then
        return inst
    end

    return inst
end

local function pawn_nightmare()
    local inst = create_common("_nightmare")

    if not TheWorld.ismastersim then
        return inst
    end

    return inst
end

return Prefab("pawn_hopper", pawn, assets, prefabs),
		Prefab("pawn_hopper_nightmare", pawn_nightmare, assets, prefabs)
