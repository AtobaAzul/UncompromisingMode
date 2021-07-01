local loot =
{
    "log",
    "log",
    "log",
    "poop",
}

local function OnVacate(inst)
    SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
end

local function ReBuild(inst)
inst:Show()
local fx = SpawnPrefab("collapse_small")
fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
inst:Show()
MakeObstaclePhysics(inst, 0.33)

    inst:AddComponent("spawner")
    inst.components.spawner:Configure("pigking_pigguard", TUNING.TOTAL_DAY_TIME * 4)
    inst.components.spawner:SetOnlySpawnOffscreen(true)
    inst.components.spawner:SetOnVacateFn(OnVacate)
inst.demolished = false
end

local function onhammered(inst)
    inst.components.lootdropper:DropLoot()
	inst.demolished = true
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("wood")
	local x,y,z = inst.Transform:GetWorldPosition()
	inst.Physics:ClearCollisionMask()
	inst:Hide()
	inst.components.fueled:InitializeFuelLevel(0)
	inst.components.timer:StartTimer("rebuild", 60)
	if inst.components.spawner ~= nil then
	if inst.components.spawner.child ~= nil then
	inst.components.spawner.child:RemoveComponent("homeseeker")
	end
	inst:RemoveComponent("spawner")
	end
end

local function onhit(inst,worker)
		local x, y, z = inst.Transform:GetWorldPosition()
		local guards = TheSim:FindEntities(x,y,z,40,{"guard"})
		for i, v in ipairs(guards) do
		if v.components.health ~= nil and v.components.combat ~= nil and not v.components.health:IsDead() then
		v.components.combat:SuggestTarget(worker)
		end
		end
    inst.AnimState:PlayAnimation("hit")
    inst.AnimState:PushAnimation("idle")
end

local function onextinguish(inst)
    if inst.components.fueled ~= nil then
        inst.components.fueled:InitializeFuelLevel(0)
    end
end

local function onupdatefueledraining(inst)
    inst.components.fueled.rate = 1 + TUNING.PIGTORCH_RAIN_RATE * TheWorld.state.precipitationrate
end

local function onisraining(inst, israining)
    if inst.components.fueled ~= nil then
        if israining then
            inst.components.fueled:SetUpdateFn(onupdatefueledraining)
            onupdatefueledraining(inst)
        else
            inst.components.fueled:SetUpdateFn()
            inst.components.fueled.rate = 1
        end
    end
end

local function onfuelchange(newsection, oldsection, inst)
    if newsection <= 0 then
        inst.components.burnable:Extinguish()
    else
        if not inst.components.burnable:IsBurning() then
            inst.components.burnable:Ignite()
        end

        inst.components.burnable:SetFXLevel(newsection, inst.components.fueled:GetSectionPercent())
    end
end

local function OnHaunt(inst)
    inst.components.fueled:TakeFuelItem(SpawnPrefab("pigtorch_fuel"))
    inst.components.spawner:ReleaseChild()
    return true
end

local function OnLoadTorch(inst,data)
if data ~= nil and data.demolished ~= nil then
inst.demolished = data.demolished
if inst.demolished == true then
	local x,y,z = inst.Transform:GetWorldPosition()
	inst.Physics:ClearCollisionMask()
	inst:Hide()
	inst.components.fueled:InitializeFuelLevel(0)
	inst.components.timer:StartTimer("rebuild", 1000+math.random(400,1000))
	if inst.components.spawner ~= nil then
	if inst.components.spawner.child ~= nil then
	inst.components.spawner.child:RemoveComponent("homeseeker")
	end
	inst:RemoveComponent("spawner")
	end
end
end
end

local function OnSaveTorch(inst,data)
if inst.demolished ~= nil then
data.demolished = inst.demolished
end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, 0.33)

    inst.AnimState:SetBank("pigtorch")
    inst.AnimState:SetBuild("pig_torch")
    inst.AnimState:PlayAnimation("idle", true)

    inst:AddTag("structure")
    inst:AddTag("wildfireprotected")
	inst:AddTag("pkpole")
    --MakeSnowCoveredPristine(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("burnable")
    inst.components.burnable.canlight = false
    inst.components.burnable:AddBurnFX("pigtorch_flame", Vector3(-5, 40, 0), "fire_marker")
    inst:ListenForEvent("onextinguish", onextinguish) --in case of creepy hands

    inst:AddComponent("fueled")
    inst.components.fueled.accepting = true
    inst.components.fueled.maxfuel = TUNING.PIGTORCH_FUEL_MAX
    inst.components.fueled:SetSections(3)
    inst.components.fueled.fueltype = FUELTYPE.PIGTORCH
    inst.components.fueled:SetSectionCallback(onfuelchange)
    inst.components.fueled:InitializeFuelLevel(TUNING.PIGTORCH_FUEL_MAX)

    inst:WatchWorldState("israining", onisraining)
    onisraining(inst, TheWorld.state.israining)

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot(loot)
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)

    inst:AddComponent("spawner")
    inst.components.spawner:Configure("pigking_pigguard", TUNING.TOTAL_DAY_TIME * 4)
    inst.components.spawner:SetOnlySpawnOffscreen(true)
    inst.components.spawner:SetOnVacateFn(OnVacate)

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_SMALL)
    inst.components.hauntable:SetOnHauntFn(OnHaunt)
	inst:AddComponent("timer")
	inst:ListenForEvent("timerdone", ReBuild)
    --MakeSnowCovered(inst)
	
	inst.OnLoad = OnLoadTorch
	inst.OnSave = OnSaveTorch
    return inst
end
local RETARGET_MUST_TAGS = { "_combat" }
local WEREPIG_RETARGET_CANT_TAGS = { "werepig", "alwaysblock", "wereplayer" }
local function OnEat(inst, food)
    if food.components.edible ~= nil then
        if food.components.edible.foodtype == FOODTYPE.VEGGIE then
            SpawnPrefab("poop").Transform:SetPosition(inst.Transform:GetWorldPosition())
        elseif food.components.edible.foodtype == FOODTYPE.MEAT and
            inst.components.werebeast ~= nil and
            not inst.components.werebeast:IsInWereState() and
            food.components.edible:GetHealth(inst) < 0 then
            inst.components.werebeast:TriggerDelta(1)
        end
    end
end

local function NormalRetargetFn(inst)
	local exclude_tags = { "playerghost", "INLIMBO" }
	if inst.components.follower.leader ~= nil then
		table.insert(exclude_tags, "abigail")
	end
	if inst.components.minigame_spectator ~= nil then
		table.insert(exclude_tags, "player") -- prevent spectators from auto-targeting webber
	end

    local oneof_tags = {"monster"}
    if not inst:HasTag("merm") then
        table.insert(oneof_tags, "merm")
    end

    return not inst:IsInLimbo()
        and FindEntity(
                inst,
                TUNING.PIG_TARGET_DIST,
                function(guy)
					for i,v in ipairs(inst.hitlist) do
						if guy.userid ~= nil and v == guy.userid then
						
						local taskid = guy.userid
						
						if inst.taskid ~= nil then
							inst.taskid:Cancel()
							inst.taskid = nil
						end
						
						inst.taskid = inst:DoTaskInTime(60, function(inst) table.removetablevalue(inst.hitlist, taskid) end)
						
						return (guy.LightWatcher == nil or guy.LightWatcher:IsInLight())
								and inst.components.combat:CanTarget(guy)
						end
					end
					
					for i,v in ipairs(oneof_tags) do --Have to emulate the oneof_tags effect
						if guy:HasTag(v) then
						return (guy.LightWatcher == nil or guy.LightWatcher:IsInLight())
								and inst.components.combat:CanTarget(guy)
						end
					end
                end,
                RETARGET_MUST_TAGS, -- see entityreplica.lua
                exclude_tags
            )
        or nil
end
local function NormalKeepTargetFn(inst, target)
    --give up on dead guys, or guys in the dark, or werepigs
    return inst.components.combat:CanTarget(target)
        and (target.LightWatcher == nil or target.LightWatcher:IsInLight())
        and not (target.sg ~= nil and target.sg:HasStateTag("transform"))
end
local guardbrain = require "brains/pigguard_pigkingbrain"
local guardbuilds = { "pig_guard_build" }

local function GuardShouldSleep(inst)
    return false
end

local function GuardShouldWake(inst)
    return true
end
local function SetGuardPig(inst)
    inst:RemoveTag("werepig")
    inst:AddTag("guard")
    inst:SetBrain(guardbrain)
    inst:SetStateGraph("SGpig")
    inst.AnimState:SetBuild(inst.build)

    inst.components.sleeper:SetResistance(3)

    inst.components.health:SetMaxHealth(TUNING.PIG_GUARD_HEALTH)
    inst.components.combat:SetDefaultDamage(TUNING.PIG_GUARD_DAMAGE)
    inst.components.combat:SetAttackPeriod(TUNING.PIG_GUARD_ATTACK_PERIOD)
    inst.components.combat:SetKeepTargetFunction(NormalKeepTargetFn)
    inst.components.combat:SetRetargetFunction(1, NormalRetargetFn)
    inst.components.combat:SetTarget(nil)
    inst.components.locomotor.runspeed = TUNING.PIG_RUN_SPEED
    inst.components.locomotor.walkspeed = TUNING.PIG_WALK_SPEED

    inst.components.sleeper:SetSleepTest(GuardShouldSleep)
    inst.components.sleeper:SetWakeTest(GuardShouldWake)

    inst.components.lootdropper:SetLoot({})
    inst.components.lootdropper:AddRandomLoot("meat", 3)
    inst.components.lootdropper:AddRandomLoot("pigskin", 1)
    inst.components.lootdropper.numrandomloot = 1

    inst.components.trader:Enable()
    inst.components.talker:StopIgnoringAll("becamewerepig")
    inst.components.follower:SetLeader(nil)
end
local function ShouldAcceptItem(inst, item)
    if item.components.equippable ~= nil and item.components.equippable.equipslot == EQUIPSLOTS.HEAD then
        return true
    elseif inst.components.eater:CanEat(item) then
        local foodtype = item.components.edible.foodtype
        if foodtype == FOODTYPE.MEAT or foodtype == FOODTYPE.HORRIBLE then
            return inst.components.follower.leader == nil or inst.components.follower:GetLoyaltyPercent() <= TUNING.PIG_FULL_LOYALTY_PERCENT
        elseif foodtype == FOODTYPE.VEGGIE or foodtype == FOODTYPE.RAW then
            local last_eat_time = inst.components.eater:TimeSinceLastEating()
            return (last_eat_time == nil or
                    last_eat_time >= TUNING.PIG_MIN_POOP_PERIOD)
                and (inst.components.inventory == nil or
                    not inst.components.inventory:Has(item.prefab, 1))
        end
        return true
    end
end
local function ontalk(inst, script)
    inst.SoundEmitter:PlaySound("dontstarve/pig/grunt")
end
local function OnGetItemFromPlayer(inst, giver, item)
    --I eat food
    if item.components.edible ~= nil then
        --meat makes us friends (unless I'm a guard)
        if (    item.components.edible.foodtype == FOODTYPE.MEAT or
                item.components.edible.foodtype == FOODTYPE.HORRIBLE
            ) and
            item.components.inventoryitem ~= nil and
            (   --make sure it didn't drop due to pockets full
                item.components.inventoryitem:GetGrandOwner() == inst or
                --could be merged into a stack
                (   not item:IsValid() and
                    inst.components.inventory:FindItem(function(obj)
                        return obj.prefab == item.prefab
                            and obj.components.stackable ~= nil
                            and obj.components.stackable:IsStack()
                    end) ~= nil)
            ) then
            if inst.components.combat:TargetIs(giver) then
                inst.components.combat:SetTarget(nil)          --hmmmm I wonder if I have the guard tag or not?
            elseif giver.components.leader ~= nil and not (inst:HasTag("guard") or giver:HasTag("monster") or giver:HasTag("merm")) then

				if giver.components.minigame_participator == nil then
	                giver:PushEvent("makefriend")
	                giver.components.leader:AddFollower(inst)
				end
                inst.components.follower:AddLoyaltyTime(item.components.edible:GetHunger() * TUNING.PIG_LOYALTY_PER_HUNGER)
                inst.components.follower.maxfollowtime =
                    giver:HasTag("polite")
                    and TUNING.PIG_LOYALTY_MAXTIME + TUNING.PIG_LOYALTY_POLITENESS_MAXTIME_BONUS
                    or TUNING.PIG_LOYALTY_MAXTIME
            end
        end
        if inst.components.sleeper:IsAsleep() then
            inst.components.sleeper:WakeUp()
        end
    end

    --I wear hats
    if item.components.equippable ~= nil and item.components.equippable.equipslot == EQUIPSLOTS.HEAD then
        local current = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
        if current ~= nil then
            inst.components.inventory:DropItem(current)
        end
        inst.components.inventory:Equip(item)
        inst.AnimState:Show("hat")
    end
end
local MAX_TARGET_SHARES = 5
local SHARE_TARGET_DIST = 30
local function OnRefuseItem(inst, item)
    inst.sg:GoToState("refuse")
    if inst.components.sleeper:IsAsleep() then
        inst.components.sleeper:WakeUp()
    end
end
local function CustomOnHaunt(inst)
    if not inst:HasTag("werepig") and math.random() <= TUNING.HAUNT_CHANCE_OCCASIONAL then
        local remainingtime = TUNING.TOTAL_DAY_TIME * (1 - TheWorld.state.time)
        local mintime = TUNING.SEG_TIME
        inst.components.werebeast:SetWere(math.max(mintime, remainingtime) + math.random() * TUNING.SEG_TIME)
        inst.components.hauntable.hauntvalue = TUNING.HAUNT_LARGE
    end
end
local function CalcSanityAura(inst, observer)
    return (inst.prefab == "moonpig" and -TUNING.SANITYAURA_LARGE)
        or (inst.components.werebeast ~= nil and inst.components.werebeast:IsInWereState() and -TUNING.SANITYAURA_LARGE)
        or (inst.components.follower ~= nil and inst.components.follower.leader == observer and TUNING.SANITYAURA_SMALL)
        or 0
end
local function GetStatus(inst)
    return (inst:HasTag("werepig") and "WEREPIG")
        or (inst:HasTag("guard") and "GUARD")
        or (inst.components.follower.leader ~= nil and "FOLLOWER")
        or nil
end
local RETARGET_MUST_TAGS = { "_combat" }
local WEREPIG_RETARGET_CANT_TAGS = { "werepig", "alwaysblock", "wereplayer" }
local function WerepigRetargetFn(inst)
    return FindEntity(
        inst,
        SpringCombatMod(TUNING.PIG_TARGET_DIST),
        function(guy)
            return inst.components.combat:CanTarget(guy)
                and not (guy.sg ~= nil and guy.sg:HasStateTag("transform"))
        end,
        RETARGET_MUST_TAGS, --See entityreplica.lua (re: "_combat" tag)
        WEREPIG_RETARGET_CANT_TAGS
    )
end
local werepigbrain = require "brains/werepigbrain"
local function WerepigSleepTest(inst)
    return false
end

local function WerepigWakeTest(inst)
    return true
end
local function WerepigKeepTargetFn(inst, target)
    return inst.components.combat:CanTarget(target)
           and not target:HasTag("werepig")
           and not target:HasTag("wereplayer")
           and not (target.sg ~= nil and target.sg:HasStateTag("transform"))
end
local function SetWerePig(inst)
    inst:AddTag("werepig")
    inst:RemoveTag("guard")
    inst:SetBrain(werepigbrain)
    inst:SetStateGraph("SGwerepig")
    inst.AnimState:SetBuild("werepig_build")

    inst.components.sleeper:SetResistance(3)

    inst.components.combat:SetDefaultDamage(TUNING.WEREPIG_DAMAGE)
    inst.components.combat:SetAttackPeriod(TUNING.WEREPIG_ATTACK_PERIOD)
    inst.components.locomotor.runspeed = TUNING.WEREPIG_RUN_SPEED 
    inst.components.locomotor.walkspeed = TUNING.WEREPIG_WALK_SPEED 

    inst.components.sleeper:SetSleepTest(WerepigSleepTest)
    inst.components.sleeper:SetWakeTest(WerepigWakeTest)

    inst.components.lootdropper:SetLoot({ "meat", "meat", "pigskin" })
    inst.components.lootdropper.numrandomloot = 0

    inst.components.health:SetMaxHealth(TUNING.WEREPIG_HEALTH)
    inst.components.combat:SetTarget(nil)
    inst.components.combat:SetRetargetFunction(3, WerepigRetargetFn)
    inst.components.combat:SetKeepTargetFunction(WerepigKeepTargetFn)

    inst.components.trader:Disable()
    inst.components.follower:SetLeader(nil)
    inst.components.talker:IgnoreAll("becamewerepig")
end
local function OnSave(inst, data)
    data.build = inst.build
	data._pigtokeninitialized = inst._pigtokeninitialized
	if inst.hitlist ~= nil then
	data.hitlist = inst.hitlist
	end
end

local function OnLoad(inst, data)
    if data ~= nil then
        inst.build = data.build or builds[1]
        if not inst.components.werebeast:IsInWereState() then
            inst.AnimState:SetBuild(inst.build)
        end
		inst._pigtokeninitialized = data._pigtokeninitialized
	if data.hitlist ~= nil then
	inst.hitlist = data.hitlist
	end
    end
end
local function IsPig(dude)
    return dude:HasTag("pig")
end

local function IsWerePig(dude)
    return dude:HasTag("werepig")
end

local function IsNonWerePig(dude)
    return dude:HasTag("pig") and not dude:HasTag("werepig")
end

local function IsGuardPig(dude)
    return dude:HasTag("guard") and dude:HasTag("pig")
end
local function OnAttackedByDecidRoot(inst, attacker)
    local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, SpringCombatMod(SHARE_TARGET_DIST) * .5, SUGGESTTARGET_MUST_TAGS, SUGGESTTARGET_CANT_TAGS)
    local num_helpers = 0
    for i, v in ipairs(ents) do
        if v ~= inst and not v.components.health:IsDead() then
            v:PushEvent("suggest_tree_target", { tree = attacker })
            num_helpers = num_helpers + 1
            if num_helpers >= MAX_TARGET_SHARES then
                break
            end
        end
    end
end
local function OnAttacked(inst, data)
    --print(inst, "OnAttacked")
    local attacker = data.attacker
    inst:ClearBufferedAction()

	if attacker ~= nil then
		if attacker.prefab == "deciduous_root" and attacker.owner ~= nil then 
			OnAttackedByDecidRoot(inst, attacker.owner)
		elseif attacker.prefab ~= "deciduous_root" and not attacker:HasTag("pigelite") then
			inst.components.combat:SetTarget(attacker)

			if inst:HasTag("werepig") then
				inst.components.combat:ShareTarget(attacker, SHARE_TARGET_DIST, IsWerePig, MAX_TARGET_SHARES)
			elseif inst:HasTag("guard") then
				inst.components.combat:ShareTarget(attacker, SHARE_TARGET_DIST, attacker:HasTag("pig") and IsGuardPig or IsPig, MAX_TARGET_SHARES)
			elseif not (attacker:HasTag("pig") and attacker:HasTag("guard")) then
				inst.components.combat:ShareTarget(attacker, SHARE_TARGET_DIST, IsNonWerePig, MAX_TARGET_SHARES)
			end
		end
	end
end
local function OnNewTarget(inst, data)
    if inst:HasTag("werepig") then
        inst.components.combat:ShareTarget(data.target, SHARE_TARGET_DIST, IsWerePig, MAX_TARGET_SHARES)
		else
		if data.target:HasTag("pig") then
		inst.components.combat.target = nil
		end
		if data.target.userid ~= nil and not table.contains(inst.hitlist,data.target.userid) then
			table.insert(inst.hitlist,data.target.userid)
			
			local taskid = data.target.userid
			inst.taskid = inst:DoTaskInTime(60, function(inst) table.removetablevalue(inst.hitlist, taskid) end)
		end
		if data.target.userid ~= nil then
		local x,y,z = inst.Transform:GetWorldPosition()
		local ents = TheSim:FindEntities(x, y, z, 40, {"pig","guard"}) --Spread the news, they'll let any new pig guards nearby know that there's a bad man around
		for i, v in ipairs(ents) do
			if v ~= inst and not v.components.health:IsDead() then
				if data.target.userid ~= nil and not table.contains(v.hitlist,data.target.userid) then
				table.insert(v.hitlist,data.target.userid)
				
					local taskid = data.target.userid
					v.taskid = v:DoTaskInTime(60, function(v) table.removetablevalue(v.hitlist, taskid) end)
				end
			end
		end
		end
    end
end

local function SuggestTreeTarget(inst, data)
    if data ~= nil and data.tree ~= nil and inst:GetBufferedAction() ~= ACTIONS.CHOP then
        inst.tree_target = data.tree
    end
end

local function common(moonbeast)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddLightWatcher()
    inst.entity:AddNetwork()

    MakeCharacterPhysics(inst, 50, .5)

    inst.DynamicShadow:SetSize(1.5, .75)
    inst.Transform:SetFourFaced()

    inst:AddTag("character")
    inst:AddTag("pig")
    inst:AddTag("scarytoprey")
    inst.AnimState:SetBank("pigman")
    inst.AnimState:PlayAnimation("idle_loop", true)
    inst.AnimState:Hide("hat")

    --Sneak these into pristine state for optimization
    inst:AddTag("_named")

        --trader (from trader component) added to pristine state for optimization
        inst:AddTag("trader")

        inst:AddComponent("talker")
        inst.components.talker.fontsize = 35
        inst.components.talker.font = TALKINGFONT
        --inst.components.talker.colour = Vector3(133/255, 140/255, 167/255)
        inst.components.talker.offset = Vector3(0, -400, 0)
        inst.components.talker:MakeChatter()


    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    --Remove these tags so that they can be added properly when replicating components below
    inst:RemoveTag("_named")

        inst.components.talker.ontalk = ontalk

    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor.runspeed = TUNING.PIG_RUN_SPEED --5
    inst.components.locomotor.walkspeed = TUNING.PIG_WALK_SPEED --3

    inst:AddComponent("bloomer")

    ------------------------------------------
    inst:AddComponent("eater")
    inst.components.eater:SetDiet({ FOODGROUP.OMNI }, { FOODGROUP.OMNI })
    inst.components.eater:SetCanEatHorrible()
    inst.components.eater:SetCanEatRaw()
    inst.components.eater.strongstomach = true -- can eat monster meat!
    inst.components.eater:SetOnEatFn(OnEat)
    ------------------------------------------
    inst:AddComponent("health")
    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "pig_torso"

    MakeMediumBurnableCharacter(inst, "pig_torso")

    inst:AddComponent("named")
    inst.components.named.possiblenames = STRINGS.PIGNAMES
    inst.components.named:PickNewName()

    ------------------------------------------
    MakeHauntablePanic(inst)


        inst:AddComponent("werebeast")
        inst.components.werebeast:SetOnWereFn(SetWerePig)
        inst.components.werebeast:SetTriggerLimit(4)

        AddHauntableCustomReaction(inst, CustomOnHaunt, true, nil, true)
 
    ------------------------------------------
    inst:AddComponent("follower")
    inst.components.follower.maxfollowtime = TUNING.PIG_LOYALTY_MAXTIME
    ------------------------------------------

    inst:AddComponent("inventory")

    ------------------------------------------

    inst:AddComponent("lootdropper")

    ------------------------------------------

    inst:AddComponent("knownlocations")

    ------------------------------------------

        inst:AddComponent("trader")
        inst.components.trader:SetAcceptTest(ShouldAcceptItem)
        inst.components.trader.onaccept = OnGetItemFromPlayer
        inst.components.trader.onrefuse = OnRefuseItem
        inst.components.trader.deleteitemonaccept = false

    ------------------------------------------

    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aurafn = CalcSanityAura
    ------------------------------------------

    inst:AddComponent("sleeper")

    ------------------------------------------
    MakeMediumFreezableCharacter(inst, "pig_torso")

    ------------------------------------------

    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = GetStatus
    ------------------------------------------

        inst.OnSave = OnSave
        inst.OnLoad = OnLoad

    inst:ListenForEvent("attacked", OnAttacked)
    inst:ListenForEvent("newcombattarget", OnNewTarget)
	inst:ListenForEvent("suggest_tree_target", SuggestTreeTarget)
	inst.hitlist = {}
    return inst
end

local function guard()
    local inst = common(false)

    if not TheWorld.ismastersim then
        return inst
    end

    -- boat hopping setup
    inst.components.locomotor:SetAllowPlatformHopping(true)
    inst:AddComponent("embarker")
    inst:AddComponent("drownable")

    inst.build = guardbuilds[math.random(#guardbuilds)]
    inst.AnimState:SetBuild(inst.build)
    inst.components.werebeast:SetOnNormalFn(SetGuardPig)
    SetGuardPig(inst)
    return inst
end

return Prefab("pigking_pigtorch", fn),
Prefab("pigking_pigguard", guard)

