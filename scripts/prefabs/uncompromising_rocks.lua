local assets =
{
    Asset("ANIM", "anim/moonrock_pillarsmall.zip"),
}


SetSharedLootTable( 'moonrock_pillarsmall',
{
    {'moonrocknugget',  1.00},
    {'rocks',  1.00},
    {'rocks',  1.00},
    {'moonrocknugget',  1.00},
})


local function OnWork(inst, worker, workleft)
    if workleft <= 0 then
        local pt = inst:GetPosition()
        SpawnPrefab("rock_break_fx").Transform:SetPosition(pt:Get())
        inst.components.lootdropper:DropLoot(pt)

        if inst.showCloudFXwhenRemoved then
            local fx = SpawnPrefab("collapse_small")
            fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
        end

		if not inst.doNotRemoveOnWorkDone then
	        inst:Remove()
		end
    else
		if workleft < 4 then
			inst.AnimState:PlayAnimation("pillar_collapsed")
		end
		if workleft < 8 and workleft >= 4 then
			if not inst.collapsed then
				inst.AnimState:PlayAnimation("pillar_collapse")
				inst.AnimState:PushAnimation("pillar_collapsed",false)
				inst.collapsed = true
				inst.components.workable:SetWorkable(false)
				inst:ListenForEvent("animover",function(inst) inst.components.workable:SetWorkable(true) end)
			else
				inst.AnimState:PlayAnimation("pillar_collapsed")
			end
		end
		if workleft < 12 and workleft >= 8 then
			inst.AnimState:PlayAnimation("pillar")
		end
    end
end

local function baserock_fn(bank, build, anim, icon, tag, multcolour)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, 1)

    if icon ~= nil then
        inst.MiniMapEntity:SetIcon(icon)
    end

    inst.AnimState:SetBank(bank)
    inst.AnimState:SetBuild(build)

    if type(anim) == "table" then
        for i, v in ipairs(anim) do
            if i == 1 then
                inst.AnimState:PlayAnimation(v)
            else
                inst.AnimState:PushAnimation(v, false)
            end
        end
    else
        inst.AnimState:PlayAnimation(anim)
    end

    MakeSnowCoveredPristine(inst)

    inst:AddTag("boulder")
    if tag ~= nil then
        inst:AddTag(tag)
    end

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("lootdropper")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.MINE)
    inst.components.workable:SetWorkLeft(12)
    inst.components.workable:SetOnWorkCallback(OnWork)


    inst:AddComponent("inspectable")
    inst.components.inspectable.nameoverride = "ROCK"
    MakeSnowCovered(inst)

    MakeHauntableWork(inst)
	
	inst.onsave = function(inst,data)
		if inst.collapsed then
			data.collapsed = true
		end
	end
	
	inst.onload = function(inst,data)
		if data.collapsed then
			inst.collapsed = true
		end
	end
	
    return inst
end

local function moonrock_pillarsmall()
    local inst = baserock_fn("moonrock_pillarsmall", "moonrock_pillarsmall", "pillar", "rock_moon.png")

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.inspectable.nameoverride = "ROCK_MOON"
    inst.components.lootdropper:SetChanceLootTable('moonrock_pillarsmall')

    return inst
end


return Prefab("moonrock_pillarsmall", moonrock_pillarsmall, assets)
