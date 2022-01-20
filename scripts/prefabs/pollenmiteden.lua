local prefabs =
{
    "pollenmites",
}

local assets =
{
    Asset("ANIM", "anim/gnat_cocoon.zip"),
    Asset("SOUND", "sound/spider.fsb"),
    Asset("MINIMAP_IMAGE", "pollenmiteden_map"),
}

local ANIM_DATA =
{
    SMALL =
    {
        hit = "cocoon_small_hit",
        idle = "cocoon_small",
        init = "grow_sac_to_small",
        freeze = "frozen_small",
        thaw = "frozen_loop_pst_small",
    },

    MEDIUM =
    {
        hit = "cocoon_medium_hit",
        idle = "cocoon_medium",
        init = "grow_small_to_medium",
        freeze = "frozen_medium",
        thaw = "frozen_loop_pst_medium",
    },

    LARGE =
    {
        hit = "cocoon_large_hit",
        idle = "cocoon_large",
        init = "grow_medium_to_large",
        freeze = "frozen_large",
        thaw = "frozen_loop_pst_large",
    },
}

local LOOT_DATA =
{
    SMALL = { "ash", "ash" },
    MEDIUM = { "ash", "ash", "ash", "ash" },
    LARGE = { "ash", "ash", "ash", "ash", "ash", "ash" },
}

local function SetStage(inst, stage)
    if stage <= 3 and inst.components.childspawner ~= nil then -- if childspawner doesn't exist, then this den is burning down
        inst.SoundEmitter:PlaySound("dontstarve/creatures/spider/spiderLair_grow")
        inst.components.childspawner:SetMaxChildren(math.floor(SpringCombatMod(TUNING.SPIDERDEN_SPIDERS[stage])))
        inst.components.childspawner:SetMaxEmergencyChildren(TUNING.SPIDERDEN_EMERGENCY_WARRIORS[stage])
        inst.components.childspawner:SetEmergencyRadius(TUNING.SPIDERDEN_EMERGENCY_RADIUS[stage])
        --inst.components.health:SetMaxHealth(TUNING.SPIDERDEN_HEALTH[stage])

        inst.AnimState:PlayAnimation(inst.anims.init)
        inst.AnimState:PushAnimation(inst.anims.idle, true)
    end

    inst.data.stage = stage -- track here, as growable component may go away
end

local function SetSmall(inst)
    inst.anims = ANIM_DATA.SMALL
    SetStage(inst, 1)
    inst.components.lootdropper:SetLoot(LOOT_DATA.SMALL)

    if inst.components.burnable ~= nil then
        inst.components.burnable:SetFXLevel(3)
        inst.components.burnable:SetBurnTime(20)
    end

    if inst.components.freezable ~= nil then
        inst.components.freezable:SetShatterFXLevel(3)
        inst.components.freezable:SetResistance(2)
    end

    local my_x, my_y, my_z = inst.Transform:GetWorldPosition()
    if TheWorld.Map:GetPlatformAtPoint(my_x, my_z) == nil then
        inst.GroundCreepEntity:SetRadius(5)
    end
end

local function SetMedium(inst)
    inst.anims = ANIM_DATA.MEDIUM
    SetStage(inst, 2)
    inst.components.lootdropper:SetLoot(LOOT_DATA.MEDIUM)

    if inst.components.burnable ~= nil then
        inst.components.burnable:SetFXLevel(3)
        inst.components.burnable:SetBurnTime(20)
    end

    if inst.components.freezable ~= nil then
        inst.components.freezable:SetShatterFXLevel(4)
        inst.components.freezable:SetResistance(3)
    end
    
    local my_x, my_y, my_z = inst.Transform:GetWorldPosition()
    if TheWorld.Map:GetPlatformAtPoint(my_x, my_z) == nil then
        inst.GroundCreepEntity:SetRadius(9)
    end
end

local function SetLarge(inst)
    inst.anims = ANIM_DATA.LARGE
    SetStage(inst, 3)
    inst.components.lootdropper:SetLoot(LOOT_DATA.LARGE)

    if inst.components.burnable ~= nil then
        inst.components.burnable:SetFXLevel(4)
        inst.components.burnable:SetBurnTime(30)
    end

    if inst.components.freezable ~= nil then
        inst.components.freezable:SetShatterFXLevel(5)
        inst.components.freezable:SetResistance(4)
    end

    local my_x, my_y, my_z = inst.Transform:GetWorldPosition()
    if TheWorld.Map:GetPlatformAtPoint(my_x, my_z) == nil then
        inst.GroundCreepEntity:SetRadius(9)
    end
end

local function PlayLegBurstSound(inst)
    inst.SoundEmitter:PlaySound("dontstarve/creatures/spiderqueen/legburst")
end

local function SpawnQueen(inst, should_duplicate)
	
    local x, y, z = inst.Transform:GetWorldPosition()

	local x1 = x + math.random(-10, 10)
	local z1 = z + math.random(-10, 10)

	local land = TheWorld.Map:IsPassableAtPoint(x1, 0, z1)
	local holes = TheWorld.Map:IsPointNearHole(Vector3(x1, 0, z1))
	
	if land and #TheSim:FindEntities(x1, y, z1, 5, nil, nil, { "pollenmiteden" }) < 1 and should_duplicate then


		inst.AnimState:PushAnimation("cocoon_large_burst_pst")
		inst.AnimState:PushAnimation("cocoon_small", true)

		inst.components.growable:SetStage(1)
		inst.components.growable:StartGrowing(60)
	
		local queen = SpawnPrefab("pollenmiteden")
		queen.Transform:SetPosition(x1, 0, z1)
	end
end

local function AttemptMakeQueen(inst)
    if inst.components.growable == nil then
        --failsafe in case we still got here after we are burning
        return
    end

    if inst.data.stage == nil or inst.data.stage ~= 3 then
        -- we got here directly (probably by loading), so reconfigure to the level 3 state.
        SetLarge(inst)
    end

    --[[if not inst:IsNearPlayer(30) then
        inst.components.growable:StartGrowing(60 + math.random(60))
        return
    end]]

    local check_range = 60
    local cap = 10
    local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, check_range, nil, nil, { "pollenmiteden" })
    local num_dens = #ents

    inst:DoTaskInTime(35 * FRAMES, SpawnQueen, num_dens < cap)
    return true
end

local function OnKilled(inst)
    inst.AnimState:PlayAnimation("cocoon_dead")
    if inst.components.childspawner ~= nil then
        inst.components.childspawner:ReleaseAllChildren()
    end
    RemovePhysicsColliders(inst)

    inst.SoundEmitter:KillSound("loop")

    inst.SoundEmitter:PlaySound("dontstarve/creatures/spider/spiderLair_destroy")
    inst.components.lootdropper:DropLoot(inst:GetPosition())
end

local function IsDefender(child)
    return child.prefab == "pollenmites"
end

local function SpawnDefenders(inst, attacker)
    if not inst.components.health:IsDead() then
        inst.SoundEmitter:PlaySound("dontstarve/creatures/spider/spiderLair_hit")
        inst.AnimState:PlayAnimation(inst.anims.hit)
        inst.AnimState:PushAnimation(inst.anims.idle)
        if inst.components.childspawner ~= nil then
            local max_release_per_stage = { 1, 1, 1 }
            local num_to_release = 1
            local num_warriors = math.min(num_to_release, TUNING.SPIDERDEN_WARRIORS[inst.data.stage])
            num_to_release = math.floor(SpringCombatMod(num_to_release))
            num_warriors = math.floor(SpringCombatMod(num_warriors))
            num_warriors = num_warriors - inst.components.childspawner:CountChildrenOutside(IsDefender)
            for k = 1, num_to_release do
                inst.components.childspawner.childname = k <= num_warriors and "pollenmites" or "pollenmites"
                local pollenmite = inst.components.childspawner:SpawnChild()
                if pollenmite ~= nil and attacker ~= nil and pollenmite.components.combat ~= nil then
                    pollenmite.components.combat:SetTarget(attacker)
                    pollenmite.components.combat:BlankOutAttacks(1.5 + math.random() * 2)
                end
            end
            inst.components.childspawner.childname = "pollenmites"

            local emergencypollenmite = inst.components.childspawner:TrySpawnEmergencyChild()
            if emergencypollenmite ~= nil then
                emergencypollenmite.components.combat:SetTarget(attacker)
                emergencypollenmite.components.combat:BlankOutAttacks(1.5 + math.random() * 2)
            end
        end
    end
end

local function IsInvestigator(child)
    return child.components.knownlocations:GetLocation("investigate") ~= nil
end

local function SpawnInvestigators(inst, data)
    if not inst.components.health:IsDead() and not (inst.components.freezable ~= nil and inst.components.freezable:IsFrozen()) then
        inst.AnimState:PlayAnimation(inst.anims.hit)
        inst.AnimState:PushAnimation(inst.anims.idle)
        if inst.components.childspawner ~= nil then
            local max_release_per_stage = { 1, 1, 1 }
            local num_to_release = math.min(max_release_per_stage[inst.data.stage] or 1, inst.components.childspawner.childreninside)
            num_to_release = math.floor(SpringCombatMod(num_to_release))
            local num_investigators = inst.components.childspawner:CountChildrenOutside(IsInvestigator)
            num_to_release = num_to_release - num_investigators
            local targetpos = data ~= nil and data.target ~= nil and data.target:GetPosition() or nil
            for k = 1, num_to_release do
                local pollenmite = inst.components.childspawner:SpawnChild()
                if pollenmite ~= nil and targetpos ~= nil then
                    pollenmite.components.knownlocations:RememberLocation("investigate", targetpos)
                end
            end
        end
    end
end

local function OnIgnite(inst)
    if inst.components.childspawner ~= nil then
        --SpawnDefenders(inst)
    end
    inst.SoundEmitter:KillSound("loop")
    DefaultBurnFn(inst)
end

local function OnFreeze(inst)
    --print(inst, "OnFreeze")
    inst.SoundEmitter:PlaySound("dontstarve/common/freezecreature")
    inst.AnimState:PlayAnimation(inst.anims.freeze, true)
    inst.AnimState:OverrideSymbol("swap_frozen", "frozen", "frozen")

    if inst.components.growable ~= nil then
        inst.components.growable:Pause()
    end
end

local function OnThaw(inst)
    --print(inst, "OnThaw")
    inst.AnimState:PlayAnimation(inst.anims.thaw, true)
    inst.SoundEmitter:PlaySound("dontstarve/common/freezethaw", "thawing")
    inst.AnimState:OverrideSymbol("swap_frozen", "frozen", "frozen")
end

local function OnUnFreeze(inst)
    --print(inst, "OnUnFreeze")
    inst.AnimState:PlayAnimation(inst.anims.idle, true)
    inst.SoundEmitter:KillSound("thawing")
    inst.AnimState:ClearOverrideSymbol("swap_frozen")

    if inst.components.growable ~= nil then
        inst.components.growable:Resume()
    end
end

local function GetSmallGrowTime(inst)
    return 15 + math.random()
end

local function GetMedGrowTime(inst)
    return 20 + math.random()
end

local function GetLargeGrowTime(inst)
    return 25 + math.random()
end

local function OnEntityWake(inst)
    inst.SoundEmitter:PlaySound("UCSounds/pollenmite/loop","loop", 0.5)
    --inst.SoundEmitter:PlaySound("dontstarve/creatures/spider/spidernest_LP", "loop")
end

local function OnEntitySleep(inst)
    inst.SoundEmitter:KillSound("loop")
end


local function OnStageAdvance(inst)
   inst.components.growable:DoGrowth()
   return true
end

local growth_stages =
{
    { name = "small",   time = GetSmallGrowTime,    fn = SetSmall           },
    { name = "med",     time = GetMedGrowTime,      fn = SetMedium          },
    { name = "large",   time = GetLargeGrowTime,    fn = SetLarge           },
    { name = "queen",                               fn = AttemptMakeQueen   },
}

local function CanTarget(guy)
    return not guy.components.health:IsDead()
end

local function OnHaunt(inst)
    if math.random() <= TUNING.HAUNT_CHANCE_HALF then
        local target = FindEntity(
            inst,
            25,
            CanTarget,
            { "_combat", "_health", "character" }, --see entityreplica.lua
            { "player", "pollenmites", "INLIMBO" }
        )
        if target ~= nil then
            SpawnDefenders(inst, target)
            inst.components.hauntable.hauntvalue = TUNING.HAUNT_MEDIUM
            return true
        end
    end

    if inst.data.stage == 3 and
        math.random() <= TUNING.HAUNT_CHANCE_RARE and
        AttemptMakeQueen(inst) then
        inst.components.hauntable.hauntvalue = TUNING.HAUNT_LARGE
        return true
    end

    return false
end

local function OnLoadPostPass(inst)
    if inst.components.growable ~= nil and inst:GetCurrentPlatform() ~= nil then
		inst.components.growable:StopGrowing()
    end
end

local function OnSeasonTick(inst)
	if TheWorld.state.isspring then
        inst.components.growable:StartGrowing()
	else
		if inst.components.growable:GetStage() == 3 then
			inst.components.growable:SetStage(2)
		elseif inst.components.growable:GetStage() == 2 then
			inst.components.growable:SetStage(1)
		end
        inst.components.growable:StopGrowing()
	end
end

local function Init(inst)
    if TUNING.DSTU.POLLENMITES == false then
    inst:Remove()
    end
end

local function MakePollenmiteDenFn(den_level)
    return function()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddGroundCreepEntity()
        inst.entity:AddSoundEmitter()
        inst.entity:AddMiniMapEntity()
        inst.entity:AddNetwork()

        MakeObstaclePhysics(inst, .5)

        inst.MiniMapEntity:SetIcon("pollenmiteden_map.tex")

        inst.AnimState:SetBank("spider_cocoon")
        inst.AnimState:SetBuild("gnat_cocoon")
        inst.AnimState:PlayAnimation("cocoon_small", true)

        inst:AddTag("cavedweller")
        inst:AddTag("structure")
        inst:AddTag("chewable") -- by werebeaver
        inst:AddTag("hostile")
        inst:AddTag("pollenmiteden")
        inst:AddTag("hive")

        MakeSnowCoveredPristine(inst)

        inst:SetPrefabName("pollenmiteden")
		
		inst.Transform:SetScale(0.95,0.95,0.95)
		--inst.AnimState:SetMultColour(0.1, 0.1, 0.1, 1)

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst.data = {}

        -------------------
        inst:AddComponent("health")
        inst.components.health:SetMaxHealth(200)
		inst.components.health.invincible = false

        -------------------
        inst:AddComponent("childspawner")
        inst.components.childspawner.childname = "pollenmites"
        inst.components.childspawner:SetRegenPeriod(TUNING.SPIDERDEN_REGEN_TIME / 3)
        inst.components.childspawner:SetSpawnPeriod(TUNING.SPIDERDEN_RELEASE_TIME)
        inst.components.childspawner.allowboats = true
		inst.components.childspawner:StartSpawning()
        --inst.components.childspawner:SetMaxChildren(TUNING.SPIDERDEN_SPIDERS[stage])
        --inst.components.childspawner:ScheduleNextSpawn(0)
        --inst:ListenForEvent("creepactivate", SpawnInvestigators)

        ---------------------
        inst:AddComponent("lootdropper")
        ---------------------

        ---------------------
        MakeMediumBurnable(inst)
        inst.components.burnable:SetOnIgniteFn(OnIgnite)
        -------------------

        ---------------------
        MakeMediumFreezableCharacter(inst)
        inst:ListenForEvent("freeze", OnFreeze)
        inst:ListenForEvent("onthaw", OnThaw)
        inst:ListenForEvent("unfreeze", OnUnFreeze)

        -------------------

        inst:AddComponent("combat")
        --inst.components.combat:SetOnHit(SpawnDefenders)
        inst:ListenForEvent("death", OnKilled)

        ---------------------
        MakeMediumPropagator(inst)

        ---------------------
        inst:AddComponent("growable")
        inst.components.growable.springgrowth = true
        inst.components.growable.stages = growth_stages
        inst.components.growable:SetStage(den_level)
        inst.components.growable:StartGrowing()

        ---------------------

        --inst:AddComponent( "spawner" )
        --inst.components.spawner:Configure( "resident", max, initial, rate )
        --inst.spawn_weight = global_spawn_weight

        inst:AddComponent("inspectable")

        inst:AddComponent("hauntable")
        inst.components.hauntable.cooldown = TUNING.HAUNT_COOLDOWN_MEDIUM
        inst.components.hauntable:SetOnHauntFn(OnHaunt)

        MakeSnowCovered(inst)

        inst.OnEntitySleep = OnEntitySleep
        inst.OnEntityWake = OnEntityWake
		inst.OnLoadPostPass = OnLoadPostPass
		
		inst:ListenForEvent("seasontick", OnSeasonTick)

		if not POPULATING then
			inst:DoTaskInTime(0, OnLoadPostPass)
		end

        inst:DoTaskInTime(0, Init)
        return inst
    end
end

return Prefab("pollenmiteden", MakePollenmiteDenFn(1), assets, prefabs),
    Prefab("pollenmiteden_2", MakePollenmiteDenFn(2), assets, prefabs),
    Prefab("pollenmiteden_3", MakePollenmiteDenFn(3), assets, prefabs)
