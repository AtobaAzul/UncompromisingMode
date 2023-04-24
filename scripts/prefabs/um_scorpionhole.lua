SetSharedLootTable('scorpionhole',
{
    {"rocks",           1.00},
	{"rocks",           1.00},
})

local SMALL = 1
local MEDIUM = 2
local LARGE = 3

local function set_stage(inst, workleft, play_grow_sound)
    local new_stage = (workleft * 4 <= TUNING.MOONSPIDERDEN_WORK and SMALL)
            or (workleft * 2 <= TUNING.MOONSPIDERDEN_WORK and MEDIUM)
            or LARGE

    inst.components.childspawner:SetMaxChildren(3)
    inst.components.childspawner:SetMaxEmergencyChildren(1)
    inst.components.childspawner:SetEmergencyRadius(TUNING.MOONSPIDERDEN_EMERGENCY_RADIUS[new_stage])

    if inst._stage ~= nil and inst._stage == (new_stage - 1) then
        if play_grow_sound then
            inst.SoundEmitter:PlaySound("dontstarve/creatures/spider/spiderLair_grow")
        end
    else
        inst.AnimState:PlayAnimation("idle")
    end

    inst._num_investigators = TUNING.MOONSPIDERDEN_MAX_INVESTIGATORS[new_stage]

    inst._stage = new_stage
end


---------------------------------------------------------------------------


---------------------------------------------------------------------------

local function IsInvestigator(child)
    return child.components.knownlocations:GetLocation("investigate") ~= nil
end

local function SpawnInvestigators(inst, worker)
    if inst.components.childspawner ~= nil then
        local targetpos = worker ~= nil and worker and worker:GetPosition() or nil
        for k = 1, math.random(1,2) do
            local scorpion = inst.components.childspawner:SpawnChild()
            if scorpion ~= nil and targetpos ~= nil then
                scorpion.components.knownlocations:RememberLocation("investigate", targetpos)
            end
        end
    end
end

local function SummonChildren(inst, data)
    if inst.components.childspawner ~= nil then
        local children_released = inst.components.childspawner:ReleaseAllChildren()

        for i,v in ipairs(children_released) do
            v:AddDebuff("spider_summoned_buff", "spider_summoned_buff")
        end
    end
end

---------------------------------------------------------------------------

local function ReturnChildren(inst)
    if inst.components.childspawner ~= nil then
        for k, child in pairs(inst.components.childspawner.childrenoutside) do
            if child.components.homeseeker ~= nil then
                child.components.homeseeker:GoHome()
            end
            child:PushEvent("gohome")
        end
    end
end

---------------------------------------------------------------------------

local function spawner_onworked(inst, worker, workleft)
    if workleft <= 0 then
        local pos = inst:GetPosition()
        SpawnPrefab("rock_break_fx").Transform:SetPosition(pos:Get())
        inst.components.lootdropper:DropLoot(pos)
        inst:Remove()
    else
        set_stage(inst, workleft, false)
    end

    if inst.components.childspawner ~= nil then
		SpawnInvestigators(inst, worker)
        inst.components.childspawner:ReleaseAllChildren(worker)
    end
end

local function on_workable_load(inst)
    set_stage(inst, inst.components.workable.workleft, false)
end

---------------------------------------------------------------------------



local function OnPreLoad(inst, data)

end

local function OnGoHome(inst, child)

end

local function StartSpawning(inst)
    if inst.components.childspawner ~= nil and not TheWorld.state.iscaveday then
        inst.components.childspawner:StartSpawning()
    end
end

local function StopSpawning(inst)
    if inst.components.childspawner ~= nil then
		local x,y,z = inst.Transform:GetWorldPosition()
		local players = #TheSim:FindEntities(x,y,z,15,{"player"},{"playerghost"})
		if players == 0 then
			inst.components.childspawner:StopSpawning()
		end
    end
end


local function OnIsCaveDay(inst, iscaveday)
    if iscaveday then
        StopSpawning(inst)
    else
        StartSpawning(inst)
    end
end

local function OnInit(inst)
    inst:WatchWorldState("iscaveday", OnIsCaveDay)
    OnIsCaveDay(inst, TheWorld.state.iscaveday)
end

local function OnPlayerNear(inst)
	inst.components.childspawner:SetSpawnPeriod(60)
	inst.components.childspawner:StartSpawning() --Bypass Day Stuff, home is being trespassed...
	inst.components.childspawner.timetonextspawn = math.random(1,3)
end

local function OnPlayerFar(inst)
	local x,y,z = inst.Transform:GetWorldPosition()
	local players = #TheSim:FindEntities(x,y,z,15,{"player"},{"playerghost"})
	if players == 0 then
		inst.components.childspawner:SetSpawnPeriod(60)
		if TheWorld.state.iscaveday then
			StopSpawning(inst)
		end
	end
	
end

local function OnAppear(inst,scorpion)
	local player = FindEntity(inst,7,nil,{"player"},{"playerghost"})
	if player then
		scorpion.components.combat:SuggestTarget(player)
	end
	scorpion.sg:GoToState("enterdig")
end

local function scorpionhole_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()


	
    inst.AnimState:SetBank("rabbithole")
    inst.AnimState:SetBuild("rabbit_hole")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(3)
	
    --inst.MiniMapEntity:SetIcon("spidermoonden.png")


    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
	inst:AddTag("scorpionhole")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.DIG)
    inst.components.workable:SetMaxWork(4)
    inst.components.workable:SetWorkLeft(4)
    inst.components.workable:SetOnWorkCallback(spawner_onworked)
    inst.components.workable.savestate = true
    inst.components.workable:SetOnLoadFn(on_workable_load)

    inst:AddComponent("childspawner")
    inst.components.childspawner:SetRegenPeriod(180)
    inst.components.childspawner:SetSpawnPeriod(15)
    inst.components.childspawner:SetGoHomeFn(OnGoHome)
	
	
    inst.components.childspawner:StartRegen()
    inst.components.childspawner.childname = "um_scorpion"
    inst.components.childspawner.emergencychildname = "um_scorpion"
    inst.components.childspawner.canemergencyspawn = true
	inst.components.childspawner:SetSpawnedFn(OnAppear)

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable('scorpionhole')



    MakeHauntableWork(inst)


    set_stage(inst, TUNING.MOONSPIDERDEN_WORK, false)

    inst.components.childspawner:StartSpawning()
	
    inst.OnPreLoad = OnPreLoad

    inst.SummonChildren = SummonChildren
	
	inst:AddComponent("playerprox")
	inst.components.playerprox:SetDist(15, 15)
	inst.components.playerprox:SetOnPlayerNear(OnPlayerNear)
	inst.components.playerprox:SetOnPlayerFar(OnPlayerFar)
	
    inst:DoTaskInTime(0, OnInit)
	
	if not TUNING.DSTU.DESERTSCORPIONS then	
		inst:Remove()
	end
	
    return inst
end

return Prefab("um_scorpionhole", scorpionhole_fn)