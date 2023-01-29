local assets =
{

}

SetSharedLootTable( 'um_sandrock',
{
    {'rocks',  1.00},
    {'rocks',  1.00},
    {'rocks',  1.00},
})

SetSharedLootTable( 'um_sandrock_amber',
{
    {'rocks',  1.00},
    {'rocks',  1.00},
    {'rocks',  1.00},
	{'um_amber', 1.00},
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
        inst.AnimState:PlayAnimation(
            (workleft < TUNING.ROCKS_MINE / 3 and "low") or
            (workleft < TUNING.ROCKS_MINE * 2 / 3 and "med") or
            "full"
        )
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
    inst.components.workable:SetWorkLeft(TUNING.ROCKS_MINE)
    inst.components.workable:SetOnWorkCallback(OnWork)

    if multcolour == nil or (0 <= multcolour and multcolour < 1) then
        if multcolour == nil then
            multcolour = 0.5
        end

        local color = multcolour + math.random() * (1.0 - multcolour)
        inst.AnimState:SetMultColour(color, color, color, 1)
    end

    inst:AddComponent("inspectable")
    inst.components.inspectable.nameoverride = "ROCK"
    MakeSnowCovered(inst)

    MakeHauntableWork(inst)

    return inst
end

local function AmberInit(inst)
    inst.components.lootdropper:SetChanceLootTable('um_sandrock_amber')
end

local function SandInit(inst)
	if inst.amber then
		if inst.amber > 0.75 then
			AmberInit(inst)
		end
	else
		inst.amber = math.random()
		SandInit(inst)
	end
end

local function OnSandSave(inst, data)
	data.amber = inst.amber
end

local function OnSandLoad(inst, data)
	if data then
		if data.amber then
			inst.amber = data.amber
		end
	end
end

local function sandrock_fn()
    local inst = baserock_fn("rock", "rock", "full", "rock.png")

    if not TheWorld.ismastersim then
        return inst
    end
	inst:DoTaskInTime(0,SandInit)
    inst.components.lootdropper:SetChanceLootTable('um_sandrock')
	
	inst.onsave = OnSandSave
	inst.onload = OnSandLoad
	
    return inst
end

local function babiesrock_fn()
    local inst = baserock_fn("rock", "rock", "full", "rock.png")

    if not TheWorld.ismastersim then
        return inst
    end
	inst:DoTaskInTime(0,SandInit)
    inst.components.lootdropper:SetChanceLootTable('um_sandrock')
	
	
    return inst
end

return Prefab("um_sandrock", sandrock_fn, assets),
Prefab("um_bugbabiesrock",babiesrock_fn)