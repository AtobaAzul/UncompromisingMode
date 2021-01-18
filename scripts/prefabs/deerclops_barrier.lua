local function OnWorked(inst, worker, workleft)
	if workleft > 8 then
	inst.AnimState:PlayAnimation("full")
	end
	if workleft <= 8 and workleft >= 4 then
	inst.AnimState:PlayAnimation("med")
	end
	if workleft < 4 then
	inst.AnimState:PlayAnimation("weak")
	end
    if workleft <= 0 then
            inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/iceboulder_smash")
			inst:Remove()
    end
end
local function RemoveIt(inst)
	if inst.components.workable ~= nil then
		if inst.components.workable.workleft > 8 then
		inst.AnimState:PlayAnimation("melt_full")
		end
		if inst.components.workable.workleft <= 8 and inst.components.workable.workleft >= 4 then
		inst.AnimState:PlayAnimation("melt_med")
		end
		if inst.components.workable.workleft < 4 then
		inst.AnimState:PlayAnimation("melt_weak")
		end
		inst:DoTaskInTime(0.25,function(inst) inst:Remove() end)
	else
		inst:Remove()
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
    inst.components.workable:SetWorkLeft(12)

    inst.components.workable:SetOnWorkCallback(OnWorked)
	inst.persists = false
    inst:AddComponent("inspectable")
    inst.AnimState:PlayAnimation("form")
    inst.AnimState:PushAnimation("full")
	inst.RemoveIt = RemoveIt
    MakeSnowCovered(inst)

    MakeHauntableWork(inst)

    return inst
end

return Prefab("deerclops_barrier", rock_ice_fn)
