local assets =
{
    Asset("ANIM", "anim/critterlab.zip"),
}

local function SwitchToClassic(inst)
	local pos = inst:GetPosition()
	local altar = SpawnPrefab("critterlab")
	altar.Transform:SetPosition(pos:Get())
	altar.ambush = false
	inst:Remove()
end

local function blink(inst)
    inst.AnimState:PlayAnimation("proximity_loop"..math.random(4))
	inst.idletask = inst:DoTaskInTime(math.random() + 1.0, blink)
end

local function onturnoff(inst)
	if inst.idletask ~= nil then
		inst.idletask:Cancel()
		inst.idletask = nil
	end
    inst.AnimState:PushAnimation("idle", false)
	inst.SoundEmitter:KillSound("loop")
end

local function onturnon(inst)
	inst.SoundEmitter:PlaySound("dontstarve/common/together/critter_lab/idle", "loop")
	blink(inst)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, .4)

    inst.MiniMapEntity:SetPriority(5)
    inst.MiniMapEntity:SetIcon("critterlab.png")

    inst.AnimState:SetBank("critterlab")
    inst.AnimState:SetBuild("critterlab")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("critterlab")
    inst:AddTag("antlion_sinkhole_blocker")

    --prototyper (from prototyper component) added to pristine state for optimization
    inst:AddTag("prototyper")

    MakeSnowCoveredPristine(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    
    inst:AddComponent("prototyper")
    inst.components.prototyper.onturnon = onturnon
    inst.components.prototyper.onturnoff = onturnoff
    inst.components.prototyper.trees = TUNING.PROTOTYPER_TREES.CRITTERLAB

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	inst:DoTaskInTime(0, SwitchToClassic)

    return inst
end

local function broken_onrepaired(inst, doer, repair_item)
    --if inst.components.workable.workleft < inst.components.workable.maxwork then
        --inst.AnimState:PlayAnimation("hit_broken")
        --inst.SoundEmitter:PlaySound("dontstarve/common/ancienttable_repair")
    --else
        local pos = inst:GetPosition()
        local altar = SpawnPrefab("critterlab")
        altar.Transform:SetPosition(pos:Get())
        altar.ambush = false
        --altar.SoundEmitter:PlaySound("dontstarve/common/ancienttable_activate")
        SpawnPrefab("collapse_small").Transform:SetPosition(pos:Get())
        --inst:PushEvent("onprefabswaped", {newobj = altar})
        inst:Remove()
    --end
end

local function onworked(inst, worker)
    -- make sure it never runs out of work to do
    inst.components.workable:SetWorkLeft(TUNING.STAGEHAND_HITS_TO_GIVEUP -1)
end

local function brokenfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, .4)

    inst.MiniMapEntity:SetPriority(5)
    inst.MiniMapEntity:SetIcon("critterlab.png")

    inst.AnimState:SetBank("critterlab")
    inst.AnimState:SetBuild("critterlab_broken")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("critterlab")
    inst:AddTag("antlion_sinkhole_blocker")
    inst:AddTag("stone")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
	
    inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetWorkLeft(TUNING.STAGEHAND_HITS_TO_GIVEUP -1)
	inst.components.workable:SetMaxWork(TUNING.STAGEHAND_HITS_TO_GIVEUP)
    inst.components.workable:SetOnWorkCallback(onworked)
	--[[
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetMaxWork(8)
	inst.components.workable:SetWorkLeft(1)
	inst.components.workable:SetOnWorkCallback(onworked)
	inst.components.workable.savestate = true
	]]
    inst:AddComponent("repairable")
    inst.components.repairable.repairmaterial = MATERIALS.MOONROCK
    inst.components.repairable.onrepaired = broken_onrepaired

    return inst
end

return Prefab("critterlab_real", fn, assets, prefabs),
		Prefab("critterlab_real_broken", brokenfn, assets, prefabs)
