local brain = require "brains/spiderbrain_trapdoor"

SetSharedLootTable( 'spider_trapdoor',
{
    {'monstermeat',  1.00},
})
local function ShouldAcceptItem(inst, item, giver)

    local in_inventory = inst.components.inventoryitem.owner ~= nil
    if in_inventory and not inst.components.eater:CanEat(item) then
        return false, "SPIDERNOHAT"
    end

    return (giver:HasTag("spiderwhisperer") and inst.components.eater:CanEat(item)) or
           (item.components.equippable ~= nil and item.components.equippable.equipslot == EQUIPSLOTS.HEAD)
end

local function HasFriendlyLeader(inst, target)
    local leader = inst.components.follower.leader
    local target_leader = (target.components.follower ~= nil) and target.components.follower.leader or nil
    
    if leader ~= nil and target_leader ~= nil then

        if target_leader.components.inventoryitem then
            target_leader = target_leader.components.inventoryitem:GetGrandOwner()
            -- Don't attack followers if their follow object has no owner
            if target_leader == nil then
                return true
            end
        end

        local PVP_enabled = TheNet:GetPVPEnabled()
        return leader == target or (target_leader ~= nil 
                and (target_leader == leader or (target_leader:HasTag("player") 
                and not PVP_enabled))) or
                (target.components.domesticatable and target.components.domesticatable:IsDomesticated() 
                and not PVP_enabled) or
                (target.components.saltlicker and target.components.saltlicker.salted
                and not PVP_enabled)
    
    elseif target_leader ~= nil and target_leader.components.inventoryitem then
        -- Don't attack webber's chester
        target_leader = target_leader.components.inventoryitem:GetGrandOwner()
        return target_leader ~= nil and target_leader:HasTag("spiderwhisperer")
    end

    return false
end


function GetOtherSpiders(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    return TheSim:FindEntities(x, y, z, 15,  { "spider" }, { "FX", "NOCLICK", "DECOR", "INLIMBO" })
end

local function OnGetItemFromPlayer(inst, giver, item)

    if inst.components.eater:CanEat(item) then
        inst.components.eater:Eat(item)

        if inst.components.inventoryitem.owner ~= nil then
            inst.sg:GoToState("idle")
        else
            inst.sg:GoToState("eat", true)
        end

        local playedfriendsfx = false
        if inst.components.combat.target == giver then
            inst.components.combat:SetTarget(nil)
        elseif giver.components.leader ~= nil and
            inst.components.follower ~= nil then
            
            if giver.components.minigame_participator == nil then
                giver:PushEvent("makefriend")
                giver.components.leader:AddFollower(inst)
                playedfriendsfx = true
            end
        end

        if giver.components.leader ~= nil then
            local spiders = GetOtherSpiders(inst, 15) --note: also returns the calling instance of the spider in the list
            local maxSpiders = TUNING.SPIDER_FOLLOWER_COUNT

            for i, v in ipairs(spiders) do
                if v ~= inst then
                    if maxSpiders <= 0 then
                        break
                    end

                    local effectdone = true

                    if v.components.combat.target == giver then
                        v.components.combat:SetTarget(nil)
                    elseif giver.components.leader ~= nil and
                        v.components.follower ~= nil and
                        v.components.follower.leader == nil then
                        if not playedfriendsfx then
                            giver:PushEvent("makefriend")
                            playedfriendsfx = true
                        end
                        giver.components.leader:AddFollower(v)
                    else
                        effectdone = false
                    end

                    if effectdone then
                        maxSpiders = maxSpiders - 1

                        if v.components.sleeper:IsAsleep() then
                            v.components.sleeper:WakeUp()
                        end
                    end
                end
            end
        end
    -- I also wear hats
    elseif item.components.equippable ~= nil and item.components.equippable.equipslot == EQUIPSLOTS.HEAD then
        local current = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
        if current ~= nil then
            inst.components.inventory:DropItem(current)
        end
        inst.components.inventory:Equip(item)
        inst.AnimState:Show("hat")
    end
end

local function OnRefuseItem(inst, item)
    inst.sg:GoToState("taunt")
    if inst.components.sleeper:IsAsleep() then
        inst.components.sleeper:WakeUp()
    end
end

local TARGET_MUST_TAGS = { "_combat", "character" }
local TARGET_CANT_TAGS = { "spiderwhisperer", "spiderdisguise", "INLIMBO" }
local function FindTarget(inst, radius)
    if not inst.no_targeting then
        return FindEntity(
            inst,
            SpringCombatMod(radius),
            function(guy)
                return (not inst.bedazzled and (not guy:HasTag("monster") or guy:HasTag("player")))
                    and inst.components.combat:CanTarget(guy)
                    and not (inst.components.follower ~= nil and inst.components.follower.leader == guy)
                    and not HasFriendlyLeader(inst, guy)
                    and not (inst.components.follower.leader ~= nil and inst.components.follower.leader:HasTag("player") 
                        and guy:HasTag("player") and not TheNet:GetPVPEnabled())
            end,
            TARGET_MUST_TAGS,
            TARGET_CANT_TAGS
        )
    end
end

local function NormalRetarget(inst)
    return FindTarget(inst, inst.components.knownlocations:GetLocation("investigate") ~= nil and TUNING.SPIDER_INVESTIGATETARGET_DIST or TUNING.SPIDER_TARGET_DIST)
end

local function WarriorRetarget(inst)
    return FindTarget(inst, TUNING.SPIDER_TARGET_DIST)
end

local function keeptargetfn(inst, target)
   return target ~= nil
        and target.components.combat ~= nil
        and target.components.health ~= nil
        and not target.components.health:IsDead()
        and not (inst.components.follower ~= nil and
                (inst.components.follower.leader == target or inst.components.follower:IsLeaderSame(target)))
end

local function BasicWakeCheck(inst)
    return inst.components.combat:HasTarget()
        or (inst.components.homeseeker ~= nil and inst.components.homeseeker:HasHome())
        or inst.components.burnable:IsBurning()
        or inst.components.freezable:IsFrozen()
        or inst.components.health.takingfiredamage
        or inst.components.follower:GetLeader() ~= nil
end

local function ShouldSleep(inst)
    return TheWorld.state.iscaveday and not BasicWakeCheck(inst)
end

local function ShouldWake(inst)
    return not TheWorld.state.iscaveday
        or BasicWakeCheck(inst)
        or (inst:HasTag("spider_warrior") and
            FindTarget(inst, TUNING.SPIDER_WARRIOR_WAKE_RADIUS) ~= nil)
end

local function DoReturn(inst)
    local home = inst.components.homeseeker ~= nil and inst.components.homeseeker.home or nil
    if home ~= nil and
        home.components.childspawner ~= nil and
        not (inst.components.follower ~= nil and
            inst.components.follower.leader ~= nil) then
        home.components.childspawner:GoHome(inst)
    end
end

local function OnEntitySleep(inst)
    if TheWorld.state.iscaveday then
        DoReturn(inst)
    end
end

local function SummonFriends(inst, attacker)
    local den = GetClosestInstWithTag("spiderden", inst, SpringCombatMod(TUNING.SPIDER_SUMMON_WARRIORS_RADIUS))
    if den ~= nil and den.components.combat ~= nil and den.components.combat.onhitfn ~= nil then
        den.components.combat.onhitfn(den, attacker)
    end
end

local function OnAttacked(inst, data)
    inst.components.combat:SetTarget(data.attacker)
    inst.components.combat:ShareTarget(data.attacker, 30, function(dude)
        return dude:HasTag("spider")
            and not dude.components.health:IsDead()
            and dude.components.follower ~= nil
            and dude.components.follower.leader == inst.components.follower.leader
    end, 10)
end

local function OnIsCaveDay(inst, iscaveday)
    if not iscaveday then
        inst.components.sleeper:WakeUp()
    elseif inst:IsAsleep() then
        DoReturn(inst)
    end
end

local function CalcSanityAura(inst, observer)
    if observer:HasTag("spiderwhisperer") or inst.bedazzled or 
    (inst.components.follower.leader ~= nil and inst.components.follower.leader:HasTag("spiderwhisperer")) then
        return 0
    end
    
    return inst.components.sanityaura.aura
end

local function HalloweenMoonMutate(inst, new_inst)
	local leader = inst ~= nil and inst.components.follower ~= nil
		and new_inst ~= nil and new_inst.components.follower ~= nil
		and inst.components.follower:GetLeader()
		or nil

	if leader ~= nil then
		new_inst.components.follower:SetLeader(leader)
		new_inst.components.follower:AddLoyaltyTime(
			inst.components.follower:GetLoyaltyPercent()
			* (new_inst.components.follower.maxfollowtime or inst.components.follower.maxfollowtime)
		)
	end
end
local function OnTrapped(inst, data)
    inst.components.inventory:DropEverything()
end
local function OnGoToSleep(inst)
    inst.components.inventoryitem.canbepickedup = true
end

local function OnWakeUp(inst)
    inst.components.inventoryitem.canbepickedup = false
end

local function SetHappyFace(cond) --Trapdoor spiders don't *actually* smile.
    if is_happy then
        inst.AnimState:OverrideSymbol("face", "spider_trapdoor", "happy_face")    
    else
        inst.AnimState:ClearOverrideSymbol("face")
    end
end

local function OnStartLeashing(inst, data)
    inst:SetHappyFace(true)
    inst.components.inventoryitem.canbepickedup = true

    if inst.recipe then
        local leader = inst.components.follower.leader
        if leader.components.builder and not leader.components.builder:KnowsRecipe(inst.recipe) and leader.components.builder:CanLearn(inst.recipe) then
            leader.components.builder:UnlockRecipe(inst.recipe)
        end
    end
end
local function OnStopLeashing(inst, data)
    inst.defensive = false
    inst.no_targeting = false
    inst.components.inventoryitem.canbepickedup = false

    if not inst.bedazzled then
        inst:SetHappyFace(false)
    end
end

local function SetHappyFace(inst, is_happy)
    if is_happy then
        inst.AnimState:OverrideSymbol("face", "spider_trapdoor", "happy_face")    
    else
        inst.AnimState:ClearOverrideSymbol("face")
    end
end

local function SoundPath(inst, event)
    return "dontstarve/creatures/spiderwarrior/" .. event
end

local function create_common(build)
    local inst = CreateEntity()
    
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddLightWatcher()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()

    MakeCharacterPhysics(inst, 10, .5)

    inst.DynamicShadow:SetSize(1.5, .5)
    inst.Transform:SetFourFaced()

    inst:AddTag("cavedweller")
    inst:AddTag("monster")
    inst:AddTag("hostile")
    inst:AddTag("scarytoprey")
    inst:AddTag("canbetrapped")
    inst:AddTag("smallcreature")
    inst:AddTag("spider")
    inst:AddTag("drop_inventory_pickup")
    inst:AddTag("drop_inventory_murder")
	inst:AddTag("spider_warrior")

    --trader (from trader component) added to pristine state for optimization
    inst:AddTag("trader")

    inst.AnimState:SetBank("spider")
    inst.AnimState:SetBuild("spider_trapdoor")
    inst.AnimState:PlayAnimation("idle")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	inst.Transform:SetScale(1.1,1.1,1.1)
    ----------
    inst.OnEntitySleep = OnEntitySleep

    -- locomotor must be constructed before the stategraph!
    inst:AddComponent("locomotor")
    inst.components.locomotor:SetSlowMultiplier( 1 )
    inst.components.locomotor:SetTriggersCreep(false)
    inst.components.locomotor.pathcaps = { ignorecreep = true }
	inst.components.locomotor:SetAllowPlatformHopping(true)
	
    inst.SoundPath = SoundPath
	
    inst:SetStateGraph("SGspider")

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:AddRandomLoot("monstermeat", 1)
    --inst.components.lootdropper:AddRandomLoot("silk", .5)
    inst.components.lootdropper:AddRandomLoot("spidergland", 1)
    inst.components.lootdropper:AddRandomHauntedLoot("spidergland", 1)
    inst.components.lootdropper.numrandomloot = 1
	inst.components.lootdropper:SetChanceLootTable('spider_trapdoor')

    ---------------------        
    MakeMediumBurnableCharacter(inst, "body")
    MakeMediumFreezableCharacter(inst, "body")
    inst.components.burnable.flammability = TUNING.SPIDER_FLAMMABILITY
    ---------------------       

    inst:AddComponent("health")
    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "body"
    inst.components.combat:SetKeepTargetFunction(keeptargetfn)
    inst.components.combat:SetOnHit(SummonFriends)

    inst:AddComponent("follower")
    inst.components.follower.maxfollowtime = TUNING.TOTAL_DAY_TIME

    ------------------

    inst:AddComponent("sleeper")
    inst.components.sleeper:SetResistance(2)
    inst.components.sleeper:SetSleepTest(ShouldSleep)
    inst.components.sleeper:SetWakeTest(ShouldWake)
    ------------------

    inst:AddComponent("knownlocations")

    ------------------

    inst:AddComponent("eater")
    inst.components.eater:SetDiet({ FOODTYPE.MEAT }, { FOODTYPE.MEAT })
    inst.components.eater:SetCanEatHorrible()
    inst.components.eater.strongstomach = true -- can eat monster meat!

    ------------------

    inst:AddComponent("inspectable")
	inst:AddComponent("debuffable")
    inst:AddComponent("inventory")
	-----------------
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/spider_trapdoor.xml"
    inst.components.inventoryitem.nobounce = true
    inst.components.inventoryitem.canbepickedup = false
    inst.components.inventoryitem.canbepickedupalive = true	
	
    inst:ListenForEvent("gotosleep", OnGoToSleep)
    inst:ListenForEvent("onwakeup", OnWakeUp)
    ------------------

    inst:AddComponent("trader")
    inst.components.trader:SetAcceptTest(ShouldAcceptItem)
    inst.components.trader:SetAbleToAcceptTest(ShouldAcceptItem)
    inst.components.trader.onaccept = OnGetItemFromPlayer
    inst.components.trader.onrefuse = OnRefuseItem
    inst.components.trader.deleteitemonaccept = false

    ------------------

    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aurafn = CalcSanityAura

	------------------

	inst:AddComponent("halloweenmoonmutable")
	inst.components.halloweenmoonmutable:SetPrefabMutated("spider_moon")
	inst.components.halloweenmoonmutable:SetOnMutateFn(HalloweenMoonMutate)
	
    MakeFeedableSmallLivestock(inst, TUNING.SPIDER_PERISH_TIME)
    MakeHauntablePanic(inst)
	
	inst:AddComponent("embarker")
	inst:AddComponent("drownable")
    inst:SetBrain(brain)

    inst:ListenForEvent("attacked", OnAttacked)

    inst:WatchWorldState("iscaveday", OnIsCaveDay)
    OnIsCaveDay(inst, TheWorld.state.iscaveday)
    inst:ListenForEvent("ontrapped", OnTrapped)
	
	inst.recipe = "mutator_trapdoor"
	
    inst.SetHappyFace = SetHappyFace
	
    inst:ListenForEvent("startleashing", OnStartLeashing)
    inst:ListenForEvent("stopleashing", OnStopLeashing)
	
    return inst
end

local function create_trapdoor()
    local inst = create_common("spider_trapdoor")

    if not TheWorld.ismastersim then
        return inst
    end
	inst:AddTag("tauntless")
    inst.components.health:SetMaxHealth(250)

    inst.components.combat:SetDefaultDamage(33)
    inst.components.combat:SetAttackPeriod(TUNING.SPIDER_WARRIOR_ATTACK_PERIOD + math.random() * 2)
    inst.components.combat:SetRange(TUNING.SPIDER_WARRIOR_ATTACK_RANGE, TUNING.SPIDER_WARRIOR_HIT_RANGE)
    inst.components.combat:SetRetargetFunction(2, WarriorRetarget)
    inst.components.locomotor.walkspeed = TUNING.SPIDER_WARRIOR_WALK_SPEED
    inst.components.locomotor.runspeed = TUNING.SPIDER_WARRIOR_RUN_SPEED*1.1

    inst.components.sanityaura.aura = -TUNING.SANITYAURA_MED
	inst:AddTag("trapdoorspider")
    return inst
end

return Prefab("spider_trapdoor", create_trapdoor)
