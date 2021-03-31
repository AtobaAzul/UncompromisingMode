require "prefabutil"
local function Melt(inst)
inst._puddle.AnimState:PlayAnimation("dryup")
end
local function OnWorked(inst, worker, workleft)
	if inst:HasTag("cracked") then
	if workleft == 1 then
	inst.AnimState:PlayAnimation("weak_cracked")
	end
    if workleft <= 0 then
            inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/iceboulder_smash")
			inst.AnimState:PlayAnimation("break")
			inst.Physics:ClearCollisionMask()
			inst:DoTaskInTime(4,function(inst) ErodeAway(inst) end)
    end
	else
	if workleft > 4 then
	inst.AnimState:PlayAnimation("full")
	end
	if workleft <= 4 and workleft >= 2 then
	inst.AnimState:PlayAnimation("med")
	end
	if workleft < 2 then
	inst.AnimState:PlayAnimation("weak")
	end
    if workleft <= 0 then
            inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/iceboulder_smash")
			inst.AnimState:PlayAnimation("break")
			inst.Physics:ClearCollisionMask()
			inst:DoTaskInTime(4,function(inst) ErodeAway(inst) end)
    end
	end
end
local function RemoveIt(inst)
	if inst.components.workable ~= nil then
		if inst:HasTag("cracked") then
			if inst.components.workable.workleft == 2 then
			inst.AnimState:PlayAnimation("melt_full_cracked")
			end
			if inst.components.workable.workleft == 1 then
			inst.AnimState:PlayAnimation("melt_weak_cracked")
			end	
			inst:RemoveComponent("workable")
			inst.Physics:ClearCollisionMask()
			inst.AnimState:PushAnimation("break")
			inst:DoTaskInTime(4,function(inst) ErodeAway(inst) end)
		else
			if inst.components.workable.workleft > 4 then
			inst.AnimState:PlayAnimation("melt_full")
			end
			if inst.components.workable.workleft <= 4 and inst.components.workable.workleft >= 2 then
			inst.AnimState:PlayAnimation("melt_med")
			end
			if inst.components.workable.workleft < 2 then
			inst.AnimState:PlayAnimation("melt_weak")
			end
			inst:RemoveComponent("workable")
			inst.Physics:ClearCollisionMask()
			inst.AnimState:PushAnimation("break")
			inst:DoTaskInTime(4,function(inst) ErodeAway(inst) end)
		end
	else
		inst.Physics:ClearCollisionMask()
		inst.AnimState:PlayAnimation("break")
		inst:DoTaskInTime(4,function(inst) ErodeAway(inst) end)
	end
end
local function rock_ice_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddSoundEmitter()
    inst.entity:AddAnimState()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("deerclops_barrier")
    inst.AnimState:SetBuild("deerclops_barrier")

    MakeObstaclePhysics(inst, 1)

    inst.MiniMapEntity:SetIcon("iceboulder.png")

    inst:AddTag("antlion_sinkhole_blocker")
    inst:AddTag("frozen")
    MakeSnowCoveredPristine(inst)


    inst.entity:SetPristine()
        if not TheWorld.ismastersim then
            return inst
        end

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.MINE)
	--inst:AddTag("cracked")
    --inst.AnimState:PlayAnimation("form_cracked")
    --inst.AnimState:PushAnimation("full_cracked")
    --inst.components.workable:SetWorkLeft(2)

    inst.components.workable:SetOnWorkCallback(OnWorked)
	inst.persists = false
    inst:AddComponent("inspectable")

	inst.RemoveIt = RemoveIt
    MakeSnowCovered(inst)

    MakeHauntableWork(inst)

    return inst
end

return Prefab("deerclops_barrier", rock_ice_fn)
