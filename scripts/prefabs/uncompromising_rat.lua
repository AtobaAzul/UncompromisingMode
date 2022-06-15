local assets =
{
	Asset("ANIM", "anim/uncompromising_rat.zip"),
	Asset("ANIM", "anim/uncompromising_caverat.zip"),
	Asset("ANIM", "anim/carrat_basic.zip"),
	Asset("ANIM", "anim/uncompromising_rat_water.zip"),
	Asset("ANIM", "anim/uncompromising_rat_burrow.zip"),
	Asset("ANIM", "anim/uncompromising_junkrat.zip"),
	Asset("ANIM", "anim/ratdroppings.zip"),
}

local prefabs =
{
	
}

local carratsounds =
{
	idle = "turnoftides/creatures/together/carrat/idle",
	hit = "turnoftides/creatures/together/carrat/hit",
	sleep = "turnoftides/creatures/together/carrat/sleep",
	death = "turnoftides/creatures/together/carrat/death",
	emerge = "turnoftides/creatures/together/carrat/emerge",
	submerge = "turnoftides/creatures/together/carrat/submerge",
	eat = "turnoftides/creatures/together/carrat/eat",
	stunned = "turnoftides/creatures/together/carrat/stunned",
}
--[[
SetSharedLootTable("raidrat",
{
})]]

SetSharedLootTable("ratburrow",
{
	{"redgem",		0.10},
	{"bluegem",		0.10},
	{"goldnugget",		1.00},
	{"goldnugget",		0.25},
	{"goldnugget",		0.10},
	{"boneshard",		1.00},
	{"boneshard",		0.25},
	{"boneshard",		0.10},
})

SetSharedLootTable("ratburrow_small",
{
	{"redgem",		0.10},
	{"bluegem",		0.10},
	{"goldnugget",		1.00},
	{"goldnugget",		0.25},
	{"boneshard",		1.00},
	{"boneshard",		0.25},
})

SetSharedLootTable("packrat",
{
	{"redgem",		0.10},
	{"bluegem",		0.10},
	{"goldnugget",		1.00},
	{"goldnugget",		0.25},
	{"goldnugget",		0.10},
	{"boneshard",		1.00},
	{"boneshard",		0.25},
	{"boneshard",		0.10},
})

local brain = require "brains/uncompromising_ratbrain"
local junkbrain = require "brains/uncompromising_junkratbrain"

local function OnInit(inst)
	TheWorld:PushEvent("DenSpawned")
end

local function OnRemoved(inst)
	TheWorld:PushEvent("DenRemoved")
end

local function on_cooked_fn(inst, cooker, chef)
	inst.SoundEmitter:PlaySound(inst.sounds.hit)
end

local function on_dropped(inst)
	inst.sg:GoToState("stunned")
end

local function on_burnt(inst)
	inst.components.lootdropper:DropLoot()
	inst:Remove()
end

local function OnAttackOther(inst, data)
	if data.target ~= nil and data.target:HasTag("player") and not data.target:HasTag("hasplaguemask") and not data.target:HasTag("ratfriend") and not data.target:HasTag("automaton") and TUNING.DSTU.MAXHPHITTERS then
		data.target.components.health:DeltaPenalty(0.01)
	end
	
	--[[if data.target ~= nil and data.target:HasTag("player") and inst.components.thief ~= nil then
		inst.components.thief:StealItem(data.target)
	end]]
end

local function OnAttacked(inst, data)
	if not inst:HasTag("packrat") then
		inst.components.combat:SetTarget(data.attacker)
	end
	
	inst.components.combat:ShareTarget(data.attacker, 30, function(dude)
		return dude:HasTag("raidrat")
			and not dude.components.health:IsDead()
			and not dude:HasTag("packrat")
	end, 10)
end

local function OnDeath(inst)
	if inst._item ~= nil then
		inst._item:Remove()
	end
end

local function OnPickup(inst, data)
	if inst._item ~= nil then
		inst._item:Remove()
	end
	
	if data.item.components.explosive == nil then
		inst:AddTag("carrying")
		data.item:AddTag("raided")
		local item = string.lower(data.item.prefab) ~= nil and string.lower(data.item.prefab)
		local skin_build = data.item:GetSkinBuild()
		inst._item = SpawnPrefab(item)
		
		if inst._item ~= nil then
			inst._item.components.inventoryitem.canbepickedup = false
			inst._item.entity:SetParent(inst.entity)
			inst._item.entity:AddFollower()
			inst._item.Follower:FollowSymbol(inst.GUID, "carrat_body", 0, -60, 0)
			inst._item.Transform:SetScale(0.8, 0.8, 0.8)
			if skin_build ~= nil then
				--TODO : Need to match the item skin here
			end
			inst._item:AddComponent("pickable")
			inst._item.components.pickable.quickpick = true
			inst._item.components.pickable.canbepicked = true
			inst._item.components.pickable.onpickedfn = function()
				inst.components.inventory:DropEverything()
				inst:RemoveTag("carrying")
				inst._item:Remove()
			end
			
			local function DeleteBackItem(inst)
				if inst._item ~= nil then
					for i = 1, inst.components.inventory.maxslots do
					local v = inst.components.inventory:FindItem(function(item) return not item:HasTag("nosteal") end)
						if v ~= nil then
							inst.components.inventory:DropItem(v, true, true)
							v:Remove()
						end
					end
				end
			end
			
			inst:ListenForEvent("onremove", DeleteBackItem, inst._item)
		end
	else
		data.item.components.explosive:OnBurnt()
	end
end

local function ShouldSleep(inst)
    return false
end

local function ShouldWake(inst)
    return true
end

local function onsave_rat(inst, data)
	if inst:HasTag("carrying") then
		data.carrying = true
	end
		
	if inst:HasTag("ratscout") then
		data.scouting = true
	end
end

local function onload_rat(inst, data)
	if data ~= nil then
		if data.carrying ~= nil then
			inst.components.inventory:DropEverything()
		end
		
		if data.scouting ~= nil and data.scouting then
			inst:AddTag("ratscout")
		end
	end
end

local function DoRipple(inst)
    if inst.components.drownable ~= nil and inst.components.drownable:IsOverWater() then
        SpawnPrefab("weregoose_ripple"..tostring(math.random(2))).entity:SetParent(inst.entity)
    end
end

local function Trapped(inst)
	--print("bumpk")

	local x, y, z = inst.Transform:GetWorldPosition()

	local ents = TheSim:FindEntities(x, y, z, 2, {"trap"})
				
	for i, v in ipairs(ents) do
		--print("bumpkin")
		v:DoTaskInTime(5, function(v)
			--print("frumpkin")
			v:PushEvent("harvesttrap")--.components.trap:Disarm()
		end)
	end
end

local function OnHitOther(inst, other)
	inst.components.thief:StealItem(other)
end

local RETARGET_CANT_TAGS = { "wall", "raidrat", "ratfriend"}
local function rattargetfn(inst)
    return FindEntity(
                inst, 3,
                function(guy)
					local validitem = guy.components.inventory ~= nil and guy.components.inventory:FindItem(function(item) return not item:HasTag("nosteal") end)
                    return inst:GetTimeAlive() > 5 and not 
					inst:HasTag("carrying") and
					guy:HasTag("player") and
					validitem ~= nil and
					inst.components.combat:CanTarget(guy) and not 
					(inst.components.follower ~= nil and inst.components.follower.leader == guy)
                end,
                nil,
                RETARGET_CANT_TAGS
            )
        or nil
end

local function KeepTargetFn(inst, target)
	local validitem = target.components.inventory ~= nil and target.components.inventory:FindItem(function(item) return not item:HasTag("nosteal") end)

    return not inst:HasTag("carrying") and
		validitem ~= nil and
		inst.components.combat:CanTarget(target) and inst:IsNear(target, TUNING.HOUND_TARGET_DIST)
end

local function StealItem(inst, victim, stolenitem)
	inst:PushEvent("onpickupitem", { item = stolenitem })
end

local function CancelBuff(inst)
	inst.components.locomotor.walkspeed = TUNING.DSTU.RAIDRAT_WALKSPEED
	inst.components.locomotor.runspeed = TUNING.DSTU.RAIDRAT_RUNSPEED
	inst.components.combat:SetAttackPeriod(TUNING.DSTU.RAIDRAT_ATTACK_PERIOD)
		
	if inst.note ~= nil then
		inst.note:Remove()
		inst.note = nil
	end
	
	if inst.bufftask ~= nil then
		inst.bufftask:Cancel()
	end
	
	inst.bufftask = nil
end

local function PiedPiperBuff(inst, duration)
	if inst.bufftask == nil then
		--print("note")
	
		local fx = SpawnPrefab("rat_note")
		fx.entity:SetParent(inst.entity)
		fx.entity:AddFollower()
		fx.Follower:FollowSymbol(inst.GUID, "carrat_head", 0, -180, 0)
	
		inst.note = fx
		
		inst.components.locomotor.walkspeed = TUNING.DSTU.RAIDRAT_BUFFED_WALKSPEED
		inst.components.locomotor.runspeed = TUNING.DSTU.RAIDRAT_BUFFED_RUNSPEED
		inst.components.combat:SetAttackPeriod(TUNING.DSTU.RAIDRAT_BUFFED_ATTACK_PERIOD)
		
		inst.bufftask = inst:DoTaskInTime(duration, CancelBuff)
    else
		inst.bufftask:Cancel()
		inst.bufftask = nil
		inst.bufftask = inst:DoTaskInTime(duration, CancelBuff)
	end
end

local function ShouldAcceptItem_Winky(inst, item, giver)
    return giver:HasTag("ratwhisperer") and inst.components.eater:CanEat(item)
end

local function OnGetItemFromPlayer_Winky(inst, giver, item)
    if inst.components.eater:CanEat(item) then
		if inst._item ~= nil then
			inst._item:Remove()
		end

		for k,v in pairs(inst.components.inventory.itemslots) do
			giver.components.inventory:GiveItem(inst.components.inventory:RemoveItemBySlot(k))
		end

        inst.components.eater:Eat(item)
		inst.sg:GoToState("eat", true)
		
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
    end
end

local function OnRefuseItem_Winky(inst, item)
    inst.sg:GoToState("taunt")
    if inst.components.sleeper:IsAsleep() then
        inst.components.sleeper:WakeUp()
    end
end

local function CalcSanityAura(inst, observer)
    if observer:HasTag("ratwhisperer") or 
    (inst.components.follower.leader ~= nil and inst.components.follower.leader:HasTag("ratwhisperer")) then
        return 0
    end
    
    return inst.components.sanityaura.aura
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddDynamicShadow()
	inst.entity:AddNetwork()
	
	MakeCharacterPhysics(inst, 1, 0.5)
	
	inst.DynamicShadow:SetSize(1, .75)
	inst.DynamicShadow:Enable(false)
	inst.Transform:SetSixFaced()
	
	inst.AnimState:SetBank("carrat")
	inst.AnimState:SetBuild("uncompromising_rat")
	inst.AnimState:PlayAnimation("planted")
	
	inst:AddTag("raidrat")
	inst:AddTag("animal")
	inst:AddTag("hostile")
	inst:AddTag("herdmember")
	inst:AddTag("smallcreature")
	inst:AddTag("canbetrapped")
	inst:AddTag("cattoy")
	inst:AddTag("catfood")
	inst:AddTag("cookable")
	inst:AddTag("NOBLOCK")
	--mainly for winky, too lazy to make it for only allied rats.

	inst.entity:SetCanSleep(false)
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("drownable")
	inst.components.drownable.enabled = false
	
	if inst.gooserippletask == nil then
            inst.gooserippletask = inst:DoPeriodicTask(.25, DoRipple, FRAMES)
        end
	
	--[[inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.GROUND)
    --inst.Physics:CollidesWith(COLLISION.OBSTACLES)
    --inst.Physics:CollidesWith(COLLISION.SMALLOBSTACLES)
    inst.Physics:CollidesWith(COLLISION.CHARACTERS)
    inst.Physics:CollidesWith(COLLISION.GIANTS)
    inst.Physics:Teleport(inst.Transform:GetWorldPosition())]]
	
	inst.sounds = carratsounds
	
	inst:AddComponent("locomotor")
	inst.components.locomotor.walkspeed = TUNING.DSTU.RAIDRAT_WALKSPEED
	inst.components.locomotor.runspeed = TUNING.DSTU.RAIDRAT_RUNSPEED
	inst.components.locomotor:EnableGroundSpeedMultiplier(false)
	inst.components.locomotor:SetTriggersCreep(false)
	inst:SetStateGraph("SGuncompromising_rat")
	
	inst:SetBrain(brain)
	
	----------------------------
	if TheWorld ~= nil and TheWorld.ismastershard then
		inst:AddComponent("embarker")
		inst.components.embarker.embark_speed = inst.components.locomotor.walkspeed
        inst.components.embarker.antic = true

	    inst.components.locomotor:SetAllowPlatformHopping(true)
		inst:AddComponent("amphibiouscreature")
		inst.components.amphibiouscreature:SetBanks("carrat", "uncompromising_rat_water")
        inst.components.amphibiouscreature:SetEnterWaterFn(
            function(inst)
				inst.AnimState:SetBuild("uncompromising_rat_water")
                inst.landspeed = inst.components.locomotor.runspeed
                inst.components.locomotor.runspeed = TUNING.HOUND_SWIM_SPEED
                inst.hop_distance = inst.components.locomotor.hop_distance
                inst.components.locomotor.hop_distance = 4
            end)            
        inst.components.amphibiouscreature:SetExitWaterFn(
            function(inst)
				inst.AnimState:SetBuild("uncompromising_rat")
                if inst.landspeed then
                    inst.components.locomotor.runspeed = inst.landspeed 
                end
                if inst.hop_distance then
                    inst.components.locomotor.hop_distance = inst.hop_distance
                end
            end)
	-------------------------
	
		inst.components.locomotor.pathcaps = { allowocean = true }
	end

	inst:AddComponent("eater")
	inst.components.eater:SetDiet({ FOODTYPE.MEAT, FOODTYPE.VEGGIE }, { FOODTYPE.MEAT, FOODTYPE.VEGGIE })
	--inst.components.eater:SetCanEatHorrible()
	inst.components.eater:SetCanEatRaw()
	inst.components.eater:SetStrongStomach(true) -- can eat monster meat!
	
	inst:AddComponent("workmultiplier")
	inst.components.workmultiplier:AddMultiplier(ACTIONS.HAMMER, -0.8, inst)
	
	inst:AddComponent("combat")
	inst.components.combat:SetDefaultDamage(TUNING.DSTU.RAIDRAT_DAMAGE)
	inst.components.combat:SetAttackPeriod(TUNING.DSTU.RAIDRAT_ATTACK_PERIOD)
	inst.components.combat:SetRange(TUNING.DSTU.RAIDRAT_ATTACK_RANGE)
	inst.components.combat.hiteffectsymbol = "carrat_body"
    --inst.components.combat.onhitotherfn = OnHitOther
	--inst.components.combat:SetRetargetFunction(3, rattargetfn)
    --inst.components.combat:SetKeepTargetFunction(KeepTargetFn)

    inst:AddComponent("thief")
	--inst.components.thief:SetOnStolenFn(StealItem)
	
	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(TUNING.DSTU.RAIDRAT_HEALTH)
	
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:AddRandomLoot("monstersmallmeat", 0.34)
	inst.components.lootdropper:AddRandomLoot("disease_puff", 0.34)
	inst.components.lootdropper:AddRandomLoot("rat_tail", 0.34)
	inst.components.lootdropper.numrandomloot = 1
	
	inst:AddComponent("sleeper")
    inst.components.sleeper:SetSleepTest(ShouldSleep)
    inst.components.sleeper:SetWakeTest(ShouldWake)
	inst.components.sleeper:SetResistance(1)
	
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.nobounce = true
	inst.components.inventoryitem.canbepickedup = false
	inst.components.inventoryitem.cangoincontainer = false
	inst.components.inventoryitem:SetSinks(false)
	
	inst:AddComponent("follower")
	inst:AddComponent("herdmember")
	
	inst:AddComponent("knownlocations")
	
	inst:AddComponent("cookable")
	inst.components.cookable.product = "cookedmonstersmallmeat"
	inst.components.cookable:SetOnCookedFn(on_cooked_fn)
	
	inst:AddComponent("inventory")
	inst.components.inventory.maxslots = 1
	
	inst:AddComponent("inspectable")
	
    inst:AddComponent("periodicspawner")
    inst.components.periodicspawner:SetPrefab("ratdroppings")
    inst.components.periodicspawner:SetRandomTimes(5, 15)
    --inst.components.periodicspawner:SetDensityInRange(20, 2)
    inst.components.periodicspawner:SetMinimumSpacing(10)
    inst.components.periodicspawner:Start()
	--inst.components.periodicspawner.spawnoffscreen = true
	
    inst:AddComponent("trader")
    inst.components.trader:SetAcceptTest(ShouldAcceptItem_Winky)
    inst.components.trader:SetAbleToAcceptTest(ShouldAcceptItem_Winky)
    inst.components.trader.onaccept = OnGetItemFromPlayer_Winky
    inst.components.trader.onrefuse = OnRefuseItem_Winky
    inst.components.trader.deleteitemonaccept = false
	
	inst:ListenForEvent("onattackother", OnAttackOther)
	inst:ListenForEvent("attacked", OnAttacked)
	inst:ListenForEvent("death", OnDeath)
	inst:ListenForEvent("onpickupitem", OnPickup)
	--inst:ListenForEvent("trapped", Trapped)
	
	MakeHauntablePanic(inst)
	
	--MakeFeedableSmallLivestock(inst, TUNING.CARRAT.PERISH_TIME, nil, on_dropped)
	
	MakeSmallBurnableCharacter(inst, "carrat_body")
	MakeSmallFreezableCharacter(inst, "carrat_body")
	
    inst.PiedPiperBuff = PiedPiperBuff
	
	inst.OnSave = onsave_rat
	inst.OnLoad = onload_rat

	return inst
end

local function junkretargetfn(inst)
	local x,y,z = inst.Transform:GetWorldPosition()
	if inst.shouldhide == false then
		local rats = TheSim:FindEntities(x,y,z,10,{"raidrat"})
		if #rats > 5 then --Only try and target the player this way if there's a bunch of rats nearby
			local victim = FindEntity(
					inst, TUNING.HOUND_TARGET_DIST,
					function(guy)
						return inst.components.combat:CanTarget(guy)
					end,
					nil,
					RETARGET_CANT_TAGS
				)
		
			if victim ~= nil then
				for i,v in ipairs(rats) do
					if v.components.combat ~= nil and v.components.combat.target == nil then
						v.components.combat:SuggestTarget(victim)
					end
				end
				return victim
			else
				return nil
			end
		end
	elseif inst.sg:HasStateTag("hiding") then
		local victim = FindEntity(
				inst, 12,
				function(guy)
					return inst.components.combat:CanTarget(guy)
				end,
				nil,
				RETARGET_CANT_TAGS
			)	
		if victim ~= nil then
			inst.shouldhide = false
			inst.trashhome = nil
			return victim
		else
			return nil
		end
	
	end
end

local function KeepTarget(inst, target)
	return inst:IsNear(target, TUNING.HOUND_FOLLOWER_TARGET_KEEP)
end

local function SetHarassPlayer(inst, player)
    if inst.harassplayer ~= player then
        if inst._harassovertask ~= nil then
            inst._harassovertask:Cancel()
            inst._harassovertask = nil
        end
        if inst.harassplayer ~= nil then
            inst:RemoveEventCallback("onremove", inst._onharassplayerremoved, inst.harassplayer)
            inst.harassplayer = nil
        end
        if player ~= nil then
            inst:ListenForEvent("onremove", inst._onharassplayerremoved, player)
            inst.harassplayer = player
            inst._harassovertask = inst:DoTaskInTime(120, SetHarassPlayer, nil)
        end
    end
end


local function _ForgetTarget(inst)
    inst.components.combat:SetTarget(nil)
end


local function OnJunkAttacked(inst, data)
    inst.components.combat:SetTarget(data.attacker)
    SetHarassPlayer(inst, nil)
    if inst.task ~= nil then
        inst.task:Cancel()
    end
    inst.task = inst:DoTaskInTime(math.random(55, 65), _ForgetTarget) --Forget about target after a minute

	--[[inst.components.combat:ShareTarget(data.attacker, 30, function(dude) --Don't Share Target
		return dude:HasTag("raidrat")
			and not dude.components.health:IsDead()
			and not dude:HasTag("packrat")
	end, 10)]] 
end

local function FindTargetOfInterest(inst)
    --[[if not inst.curious then
        return
    end]]
	if inst.shouldhide == false then
		if inst.harassplayer == nil and inst.components.combat.target == nil then
			local x, y, z = inst.Transform:GetWorldPosition()
			-- Get all players in range
			local targets = FindPlayersInRange(x, y, z, 25)
			-- randomly iterate over all players until we find one we're interested in.
			for i = 1, #targets do
				local randomtarget = math.random(#targets)
				local target = targets[randomtarget]
				table.remove(targets, randomtarget)
				--Higher chance to follow if he has bananas
				if target.components.inventory ~= nil and math.random() < (1) then
					SetHarassPlayer(inst, target)
					return
				end
			end
		end
		if math.random() > 0.25 then 
			inst.shouldhide = true
		end
	else
		if math.random() > 0.75 then 
			inst.shouldhide = false
			inst.sg:GoToState("idle")
		end
	end
end

local function junkfn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddDynamicShadow()
	inst.entity:AddNetwork()
	
	MakeCharacterPhysics(inst, 1, 0.5)
	
	inst.DynamicShadow:SetSize(1, .75)
	inst.DynamicShadow:Enable(false)
	inst.Transform:SetSixFaced()
	
	inst.AnimState:SetBank("carrat")
	inst.AnimState:SetBuild("uncompromising_junkrat")
	inst.AnimState:PlayAnimation("idle")
	
	inst:AddTag("raidrat")
	inst:AddTag("animal")
	inst:AddTag("hostile")
	inst:AddTag("herdmember")
	inst:AddTag("smallcreature")
	inst:AddTag("canbetrapped")
	inst:AddTag("cattoy")
	inst:AddTag("catfood")
	inst:AddTag("cookable")
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("drownable")
	inst.components.drownable.enabled = false

	
	inst.sounds = carratsounds
	
	inst:AddComponent("locomotor")
	inst.components.locomotor.walkspeed = TUNING.DSTU.RAIDRAT_WALKSPEED/1.5
	inst.components.locomotor.runspeed = TUNING.DSTU.RAIDRAT_RUNSPEED/1.5
	inst.components.locomotor:EnableGroundSpeedMultiplier(false)
	inst.components.locomotor:SetTriggersCreep(false)
	inst:SetStateGraph("SGuncompromising_junkrat")
	
	inst:SetBrain(junkbrain)
	
	inst.Transform:SetScale(1.25,1.25,1.25)
	
	inst:AddComponent("eater")
	inst.components.eater:SetDiet({ FOODTYPE.MEAT, FOODTYPE.VEGGIE }, { FOODTYPE.MEAT, FOODTYPE.VEGGIE })
	inst.components.eater:SetCanEatHorrible()
	inst.components.eater:SetCanEatRaw()
	inst.components.eater:SetStrongStomach(true) -- can eat monster meat!
	
	inst:AddComponent("workmultiplier")
	inst.components.workmultiplier:AddMultiplier(ACTIONS.HAMMER, -0.8, inst)
	
	inst:AddComponent("combat")
	inst.components.combat:SetDefaultDamage(TUNING.DSTU.RAIDRAT_DAMAGE)
	inst.components.combat:SetAttackPeriod(TUNING.DSTU.RAIDRAT_ATTACK_PERIOD)
	inst.components.combat:SetRange(TUNING.DSTU.RAIDRAT_ATTACK_RANGE)
	inst.components.combat.hiteffectsymbol = "carrat_body"
	
	inst.components.combat:SetRetargetFunction(3, junkretargetfn)
    inst.components.combat:SetKeepTargetFunction(KeepTarget)
	
	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(1.5*TUNING.DSTU.RAIDRAT_HEALTH)
	
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:AddRandomLoot("monstersmallmeat", 0.34)
	inst.components.lootdropper:AddRandomLoot("disease_puff", 0.34)
	inst.components.lootdropper:AddRandomLoot("rat_tail", 0.34)
	inst.components.lootdropper.numrandomloot = 1
	
	inst:AddComponent("sleeper")
    inst.components.sleeper:SetSleepTest(ShouldSleep)
    inst.components.sleeper:SetWakeTest(ShouldWake)
	inst.components.sleeper:SetResistance(1)
	
	inst:AddComponent("herdmember")
	
	inst:AddComponent("knownlocations")
	
	inst:AddComponent("inspectable")
	
    inst:AddComponent("periodicspawner")
    inst.components.periodicspawner:SetPrefab("ratdroppings")
    inst.components.periodicspawner:SetRandomTimes(5, 15)
    --inst.components.periodicspawner:SetDensityInRange(20, 2)
    inst.components.periodicspawner:SetMinimumSpacing(10)
    inst.components.periodicspawner:Start()
	--inst.components.periodicspawner.spawnoffscreen = true
	
	inst:ListenForEvent("onattackother", OnAttackOther)
	inst:ListenForEvent("attacked", OnJunkAttacked)
	inst:ListenForEvent("death", OnDeath)
	MakeHauntablePanic(inst)
	
	--MakeFeedableSmallLivestock(inst, TUNING.CARRAT.PERISH_TIME, nil, on_dropped)
	
	MakeSmallBurnableCharacter(inst, "carrat_body")
	MakeSmallFreezableCharacter(inst, "carrat_body")
	
	inst.FindTargetOfInterestTask = inst:DoPeriodicTask(10, FindTargetOfInterest) --Find something to be interested in!

    inst.harassplayer = nil
    inst._onharassplayerremoved = function() SetHarassPlayer(inst, nil) end
	
	inst.OnSave = onsave_rat
	inst.OnLoad = onload_rat
	
	inst.shouldhide = false
	return inst
end

local function packfn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddDynamicShadow()
	inst.entity:AddNetwork()
	
	MakeCharacterPhysics(inst, 1, 0.5)
	
	inst.DynamicShadow:SetSize(1, .75)
	inst.DynamicShadow:Enable(false)
	inst.Transform:SetSixFaced()
	
	inst.AnimState:SetBank("packrat")
	inst.AnimState:SetBuild("uncompromising_packrat")
	inst.AnimState:PlayAnimation("planted")
	
	inst:AddTag("raidrat")
	inst:AddTag("packrat")
	inst:AddTag("animal")
	--inst:AddTag("hostile")
	inst:AddTag("herdmember")
	inst:AddTag("smallcreature")
	inst:AddTag("canbetrapped")
	inst:AddTag("cattoy")
	inst:AddTag("catfood")
	inst:AddTag("cookable")
	
	inst.entity:SetCanSleep(false)
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("drownable")
	inst.components.drownable.enabled = false
	
	if inst.gooserippletask == nil then
            inst.gooserippletask = inst:DoPeriodicTask(.25, DoRipple, FRAMES)
        end
	
	--[[inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.GROUND)
    --inst.Physics:CollidesWith(COLLISION.OBSTACLES)
    --inst.Physics:CollidesWith(COLLISION.SMALLOBSTACLES)
    inst.Physics:CollidesWith(COLLISION.CHARACTERS)
    inst.Physics:CollidesWith(COLLISION.GIANTS)
    inst.Physics:Teleport(inst.Transform:GetWorldPosition())]]
	
	inst.sounds = carratsounds
	
	inst:AddComponent("locomotor")
	inst.components.locomotor.walkspeed = TUNING.DSTU.RAIDRAT_WALKSPEED / 1.25
	inst.components.locomotor.runspeed = TUNING.DSTU.RAIDRAT_RUNSPEED / 1.25
	inst.components.locomotor:EnableGroundSpeedMultiplier(false)
	inst.components.locomotor:SetTriggersCreep(false)
	inst:SetStateGraph("SGuncompromising_rat")
	
	inst:SetBrain(brain)
	
	
	
	----------------------------
	if TheWorld ~= nil and TheWorld.ismastershard then
		inst:AddComponent("embarker")
		inst.components.embarker.embark_speed = inst.components.locomotor.walkspeed
        inst.components.embarker.antic = true

	    inst.components.locomotor:SetAllowPlatformHopping(true)
		inst:AddComponent("amphibiouscreature")
		inst.components.amphibiouscreature:SetBanks("packrat", "packrat_water")
        inst.components.amphibiouscreature:SetEnterWaterFn(
            function(inst)
				inst.AnimState:SetBuild("uncompromising_packrat_water")
                inst.landspeed = inst.components.locomotor.runspeed
                inst.components.locomotor.runspeed = TUNING.HOUND_SWIM_SPEED
                inst.hop_distance = inst.components.locomotor.hop_distance
                inst.components.locomotor.hop_distance = 4
            end)            
        inst.components.amphibiouscreature:SetExitWaterFn(
            function(inst)
				inst.AnimState:SetBuild("uncompromising_packrat")
                if inst.landspeed then
                    inst.components.locomotor.runspeed = inst.landspeed 
                end
                if inst.hop_distance then
                    inst.components.locomotor.hop_distance = inst.hop_distance
                end
            end)
	-------------------------
	
		inst.components.locomotor.pathcaps = { allowocean = true }
	end

	inst:AddComponent("eater")
	inst.components.eater:SetDiet({ FOODTYPE.MEAT, FOODTYPE.VEGGIE }, { FOODTYPE.MEAT, FOODTYPE.VEGGIE })
	inst.components.eater:SetCanEatHorrible()
	inst.components.eater:SetCanEatRaw()
	inst.components.eater:SetStrongStomach(true) -- can eat monster meat!
	
	inst:AddComponent("workmultiplier")
	inst.components.workmultiplier:AddMultiplier(ACTIONS.HAMMER, -0.8, inst)
	
	inst:AddComponent("combat")
	inst.components.combat:SetDefaultDamage(TUNING.DSTU.RAIDRAT_DAMAGE)
	inst.components.combat:SetAttackPeriod(TUNING.DSTU.RAIDRAT_ATTACK_PERIOD)
	inst.components.combat:SetRange(TUNING.DSTU.RAIDRAT_ATTACK_RANGE)
	inst.components.combat.hiteffectsymbol = "carrat_body"
	
	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(TUNING.DSTU.RAIDRAT_HEALTH * 1.5)
	
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetChanceLootTable('packrat')
	inst.components.lootdropper:AddRandomLoot("monstersmallmeat", 0.34)
	inst.components.lootdropper:AddRandomLoot("disease_puff", 0.34)
	inst.components.lootdropper:AddRandomLoot("rat_tail", 0.34)
	inst.components.lootdropper.numrandomloot = 1
	
	inst:AddComponent("sleeper")
    inst.components.sleeper:SetSleepTest(ShouldSleep)
    inst.components.sleeper:SetWakeTest(ShouldWake)
	inst.components.sleeper:SetResistance(1)
	
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.nobounce = true
	inst.components.inventoryitem.canbepickedup = false
	inst.components.inventoryitem.cangoincontainer = false
	inst.components.inventoryitem:SetSinks(false)
	
	inst:AddComponent("herdmember")
	
	inst:AddComponent("knownlocations")
	
	inst:AddComponent("cookable")
	inst.components.cookable.product = "cookedmonstersmallmeat"
	inst.components.cookable:SetOnCookedFn(on_cooked_fn)
	
	inst:AddComponent("inventory")
	inst.components.inventory.maxslots = 5
	
	inst:AddComponent("inspectable")
	
    inst:AddComponent("periodicspawner")
    inst.components.periodicspawner:SetPrefab("ratdroppings")
    inst.components.periodicspawner:SetRandomTimes(5, 15)
    --inst.components.periodicspawner:SetDensityInRange(20, 2)
    inst.components.periodicspawner:SetMinimumSpacing(10)
    inst.components.periodicspawner:Start()
	--inst.components.periodicspawner.spawnoffscreen = true
	
	inst:ListenForEvent("onattackother", OnAttackOther)
	inst:ListenForEvent("attacked", OnAttacked)
	inst:ListenForEvent("death", OnDeath)
	--inst:ListenForEvent("trapped", Trapped)
	
	MakeHauntablePanic(inst)
	
	--MakeFeedableSmallLivestock(inst, TUNING.CARRAT.PERISH_TIME, nil, on_dropped)
	
	MakeSmallBurnableCharacter(inst, "carrat_body")
	MakeSmallFreezableCharacter(inst, "carrat_body")
	
	inst.OnSave = onsave_rat
	inst.OnLoad = onload_rat
	
	return inst
end

local function onfinishcallback(inst)
	inst.components.lootdropper:DropLoot()
	inst.components.inventory:DropEverything()
	inst:Remove()
end

local function onworked(inst, worker, workleft)
    inst.components.thief:StealItem(inst)
    inst.components.thief:StealItem(inst)
    inst.components.thief:StealItem(inst)
	inst.components.lootdropper:SpawnLootPrefab("rocks", inst:GetPosition())
	inst.AnimState:PlayAnimation("dig")
	inst.AnimState:PushAnimation("idle")
	for rats,_ in pairs(inst.components.herd.members) do
		inst.components.combat:ShareTarget(worker, 30, function(dude)
			return dude:HasTag("raidrat")
				and not dude.components.health:IsDead()
				and not dude:HasTag("packrat")
		end, 10)
	end
end

local function OnSpawned(inst, newent)
	if inst.components.herd ~= nil then
		inst.components.herd:AddMember(newent)
	end
	
	--[[if TheWorld.state.cycles > 50 then
		local x, y, z = inst.Transform:GetWorldPosition()
		
		local ents = #TheSim:FindEntities(x, y, z, 40, {"player"})
		
		if ents ~= nil and ents == 0 then
			if inst.ratguard then
				inst.ratguard = false
				inst.components.periodicspawner:TrySpawn("uncompromising_buffrat")
			end
		end
	end]]
end

local function BurrowKilled(inst)
	--[[if inst.components.periodicspawner ~= nil then
		inst.components.periodicspawner:Stop()
	end
	
	inst:Remove()]]
end

local function BurrowAnim(inst)
	inst.SoundEmitter:KillSound("shuffle")
	if not inst:HasTag("raiding") then
		if not inst.AnimState:IsCurrentAnimation("idle_eyes_loop") then
			inst.AnimState:PlayAnimation("idle_eyes_pre")
			inst.AnimState:PushAnimation("idle_eyes_loop", true)
		else
			if math.random() > 0.5 then
				inst.AnimState:PlayAnimation("idle_eyes_blink")
				inst.AnimState:PushAnimation("idle_eyes_loop", true)
			else
				inst.AnimState:PlayAnimation("idle_eyes_pst")
				inst.AnimState:PushAnimation("idle", true)
			end

			if inst.components.timer ~= nil then
				local scouttimer = inst.components.timer:GetTimeLeft("scoutingparty")
				
				if scouttimer ~= nil and scouttimer < 480 then
					inst.AnimState:PlayAnimation("dig")
					inst.SoundEmitter:PlaySound("turnoftides/creatures/together/carrat/submerge")
					inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/mole/move", "shuffle")
				end
			end
		end
	end
	inst:DoTaskInTime(3 + math.random(), BurrowAnim)
end

local function MakeRatBurrow(inst)
	local x, y, z = inst.Transform:GetWorldPosition()

    local function IsValidRatBurrowPosition(x, z)
        if #TheSim:FindEntities(x, 0, z, TUNING.ANTLION_SINKHOLE.RADIUS * 2, { "antlion_sinkhole_blocker" }) > 0 then
            return false
        end
		
        if #TheSim:FindEntities(x, 0, z, 60, { "player", "playerghost" }) > 0 then
            return false
        end
		
        if #TheSim:FindEntities(x, 0, z, 60, { "ratburrow"} ) > 0 then
            return false
        end
		
        for dx = -1, 1 do
            for dz = -1, 1 do
                if not TheWorld.Map:IsPassableAtPoint(x + dx * TUNING.ANTLION_SINKHOLE.RADIUS, 0, z + dz * TUNING.ANTLION_SINKHOLE.RADIUS, false, true) then
                    return false
                end
            end
        end
        return true
    end
	
	for i = 1, 8 do
		inst.x1, inst.z1 = x + math.random(-250, 250), z + math.random(-250, 250)
		
		if IsValidRatBurrowPosition(inst.x1, inst.z1) then
			inst.Transform:SetPosition(inst.x1, 0, inst.z1)
			
			local x, y, z = inst.Transform:GetWorldPosition()
			
			if math.random() >= 0.7 then
				local players = #TheSim:FindEntities(x, y, z, 30, { "player" })
						
				if players < 1 then
					local piper = SpawnPrefab("pied_rat")
						
					piper.Transform:SetPosition(inst.Transform:GetWorldPosition())
					inst.components.herd:AddMember(piper)
				end
			end
			
			break
		end
	end
end

--GetClosestInstWithTag(tag, inst, radius or 1000)





local function AbleToAcceptTest(inst, item, giver)
	return true
end

local function AcceptTest(inst, item, giver)
    return item.components and item.components.edible
end

local function OnGetItemFromPlayer(inst, giver, item)
	if item.components.edible:GetHunger() >= 75 then
		for k = 1, 5 do
			local v = inst.components.inventory:FindItem(function(item) return not item:HasTag("nosteal") end)
			if v ~= nil then
				inst.components.inventory:DropItem(v, true, true)
				v:AddTag("ratimmune")
				v:DoTaskInTime(10, function(v) v:RemoveTag("ratimmune") end)
			end
		end
	elseif item.components.edible:GetHunger() >= 50 then
		for k = 1, 3 do
			--local v = inst.components.inventory.itemslots[k]
			local v = inst.components.inventory:FindItem(function(item) return not item:HasTag("nosteal") end)
			if v ~= nil then
				inst.components.inventory:DropItem(v, true, true)
				v:AddTag("ratimmune")
				v:DoTaskInTime(10, function(v) v:RemoveTag("ratimmune") end)
			end
		end
	elseif item.components.edible:GetHunger() >= 15 then
		for k = 1, 1 do
			--local v = inst.components.inventory.itemslots[k]
			local v = inst.components.inventory:FindItem(function(item) return not item:HasTag("nosteal") end)
			if v ~= nil then
				inst.components.inventory:DropItem(v, true, true)
				v:AddTag("ratimmune")
				v:DoTaskInTime(10, function(v) v:RemoveTag("ratimmune") end)
			end
		end
	elseif item.components.edible:GetHunger() >= 5 and math.random() > 0.5 then
		for k = 1, 1 do
			--local v = inst.components.inventory.itemslots[k]
			local v = inst.components.inventory:FindItem(function(item) return not item:HasTag("nosteal") end)
			if v ~= nil then
				inst.components.inventory:DropItem(v, true, true)
				v:AddTag("ratimmune")
				v:DoTaskInTime(10, function(v) v:RemoveTag("ratimmune") end)
			end
		end
	end
	
	inst.AnimState:PlayAnimation("dig")
	inst.SoundEmitter:PlaySound("turnoftides/creatures/together/carrat/submerge")
end

local function OnRefuseItem(inst, giver, item)
	inst.AnimState:PlayAnimation("dig")
	inst.SoundEmitter:PlaySound("turnoftides/creatures/together/carrat/submerge")
end

local function EndRaid(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	local players = FindPlayersInRange(x, y, z, 50)
        for i, v in ipairs(players) do
			v.components.talker:Say(GetString(v, "ANNOUNCE_RATRAID_OVER"))
		end
		
	if inst.raiding	then
		MakeRatBurrow(inst)
	end

	for rats,_ in pairs(inst.components.herd.members) do
		
	end
	
	inst.AnimState:PlayAnimation("spawn")
	inst.AnimState:PushAnimation("idle", true)
	
	inst:RemoveTag("NOBLOCK")
	inst:RemoveTag("NOCLICK")
	inst:RemoveTag("raiding")
	inst:AddTag("ratburrow")
	
	if inst.components.workable == nil then
		inst:AddComponent("workable")
	end
		
	if inst.components.inspectable == nil then
		inst:AddComponent("inspectable")
	end
	
	if not inst.components.timer:TimerExists("scoutingparty") then
		inst.components.timer:StartTimer("scoutingparty", 1920 + math.random(480))
	end
	
	if inst.components.workable ~= nil then
		inst.components.workable:SetOnFinishCallback(onfinishcallback)
		inst.components.workable:SetOnWorkCallback(onworked)
		inst.components.workable:SetWorkAction(ACTIONS.DIG)
		inst.components.workable:SetWorkLeft(3)
	end
		
	inst.components.periodicspawner:Start()
	inst.components.herd:SetOnEmptyFn(BurrowKilled)
	inst.components.herd.updatepos = false
    inst.components.herd.updateposincombat = false
	
    inst:AddTag("trader")
	
    inst:AddComponent("trader")
    inst.components.trader:SetAbleToAcceptTest(AbleToAcceptTest)
    inst.components.trader:SetAcceptTest(AcceptTest)
    inst.components.trader.onaccept = OnGetItemFromPlayer
    inst.components.trader.onrefuse = OnRefuseItem
	
	inst.entity:SetCanSleep(false)
	
	inst.raiding = false
	
    inst:DoTaskInTime(0, OnInit)
    inst:ListenForEvent("onremove", OnRemoved)
end

local function OnInitHerd(inst)
	if inst.raiding == nil then
		inst.raiding = true
	end

	if inst.raiding then
		for i = 1, 3 do
			inst:DoTaskInTime((i - 1) * 15, function(inst)
			--print("i = "..i)
				for n = 1, (i + 2) do
					local x, y, z = inst.Transform:GetWorldPosition()
					local angle = math.random() * 8 * PI
					local rat = SpawnPrefab("uncompromising_rat")
					rat.Transform:SetPosition(x + math.cos(angle), 0, z + math.sin(angle))
					inst.components.herd:AddMember(rat)
				end
				
				if i > 1 then
					local x, y, z = inst.Transform:GetWorldPosition()
					local angle = math.random() * 8 * PI
					local packrat = SpawnPrefab("uncompromising_packrat")
					packrat.Transform:SetPosition(x + math.cos(angle), 0, z + math.sin(angle))
					inst.components.herd:AddMember(packrat)
				end
				
			end)
		end
		inst.components.herd:SetUpdateRange(20)
		inst:DoTaskInTime(45, EndRaid)
		inst:AddTag("raiding")
	end
end

local function onsave_burrow(inst, data)
	if inst.raiding ~= nil then
		data.raiding = inst.raiding
	end
	
	if inst.ratguard ~= nil then
		data.ratguard = inst.ratguard
	end
end

local function onpreload_burrow(inst, data)
	if data ~= nil then
		if data.raiding ~= nil then
			inst.raiding = data.raiding
		end
	end
end

local function onload_burrow(inst, data)
	if data ~= nil then
		if data.raiding ~= nil then
			inst.raiding = data.raiding
		end
		
		if data.ratguard ~= nil then
			inst.ratguard = data.ratguard
		end
	end	
	
	if not inst.raiding then
		inst.AnimState:PushAnimation("idle", true)
		
		inst.components.herd:SetOnEmptyFn(BurrowKilled)
		inst.components.herd.updatepos = false
		inst.components.herd.updateposincombat = false
		
		inst:DoTaskInTime(0, EndRaid)
	end
end

local function MakeScoutBurrow(inst)
	local x, y, z = inst.Transform:GetWorldPosition()

    local function IsValidRatBurrowPosition(x, z)
        if #TheSim:FindEntities(x, 0, z, TUNING.ANTLION_SINKHOLE.RADIUS * 2, { "antlion_sinkhole_blocker" }) > 0 then
            return false
        end
		
        if #TheSim:FindEntities(x, 0, z, 80, { "player", "playerghost" }) > 0 then
            return false
        end
		
        if #TheSim:FindEntities(x, 0, z, 80, { "ratburrow" }) > 0 then
            return false
        end
		
        for dx = -1, 1 do
            for dz = -1, 1 do
                if not TheWorld.Map:IsPassableAtPoint(x + dx * TUNING.ANTLION_SINKHOLE.RADIUS, 0, z + dz * TUNING.ANTLION_SINKHOLE.RADIUS, false, true) then
                    return false
                end
            end
        end
        return true
    end
	
	for i = 1, 8 do
		inst.x1, inst.z1 = x + math.random(-200, 200), z + math.random(-200, 200)
		
		if IsValidRatBurrowPosition(inst.x1, inst.z1) then
			local ratcrew = SpawnPrefab("uncompromising_rat")
			ratcrew.Transform:SetPosition(x, 0, z)
			ratcrew:AddTag("ratscout")
			
			local ratcrew2 = SpawnPrefab("uncompromising_rat")
			ratcrew2.Transform:SetPosition(x, 0, z)
			ratcrew2:AddTag("ratscout")
			
			local ratcrew3 = SpawnPrefab("uncompromising_rat")
			ratcrew3.Transform:SetPosition(x, 0, z)
			ratcrew3:AddTag("ratscout")
			
			
			local burrow = SpawnPrefab("uncompromising_scoutburrow")
			burrow.Transform:SetPosition(inst.x1, 0, inst.z1)
			burrow.components.herd:AddMember(ratcrew)
			burrow.components.herd:AddMember(ratcrew2)
			burrow.components.herd:AddMember(ratcrew3)
			--print("make a den!")
			break
		end
		
		if i >= 8 then
			--print("NO FUCKING SPACE SHITBOI")
			inst.components.timer:StartTimer("scoutingparty", 1920 + math.random(480))
		end
	end
end

local function OnTimerDone(inst, data)
	--print("timer")
	if data.name == "scoutingparty" then
		local x, y, z = inst.Transform:GetWorldPosition()
		
        if #TheSim:FindEntities(x, 0, z, 1000, { "ratburrow" }) >= 10 then
			--print("Reduce Timer Too Many Burrows")
			inst.components.timer:StartTimer("scoutingparty", 1920 + math.random(480))
            return
        end
	
		--print("scouts go!")
		MakeScoutBurrow(inst)
	end
end

local function fn_herd()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
	inst.entity:AddNetwork()
	
	inst.AnimState:SetBank("uncompromising_rat_burrow")
	inst.AnimState:SetBuild("uncompromising_rat_burrow")
	
	inst:AddTag("herd")
	inst:AddTag("NOBLOCK")
	inst:AddTag("NOCLICK")
	
    inst.MiniMapEntity:SetIcon("uncompromising_ratburrow.tex")
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
    inst:AddComponent("thief")
	
	inst.ratguard = true
	
	inst:AddComponent("herd")
	inst.components.herd:SetGatherRange(40)
	inst.components.herd:SetUpdateRange(nil)
	inst.components.herd:SetOnEmptyFn(inst.Remove)
	inst.components.herd.maxsize = 8
	inst.components.herd.nomerging = true
    inst.components.herd.updateposincombat = true
	
	inst:AddComponent("timer")
	inst:ListenForEvent("timerdone", OnTimerDone)
	
	inst:AddComponent("periodicspawner")
	inst.components.periodicspawner:SetRandomTimes(10, 13)
	inst.components.periodicspawner:SetPrefab("uncompromising_rat")
	inst.components.periodicspawner:SetOnSpawnFn(OnSpawned)
	inst.components.periodicspawner:SetDensityInRange(30, 8)
	--inst.components.periodicspawner.spawnoffscreen = true
	
	inst:AddComponent("combat")
	
	inst:AddComponent("inventory")
	inst.components.inventory.maxslots = 100
	
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetChanceLootTable('ratburrow')
	
	inst.OnSave = onsave_burrow
	inst.OnPreLoad = onpreload_burrow
	inst.OnLoad = onload_burrow
	
	inst:DoTaskInTime(0, OnInitHerd)

	inst:DoTaskInTime(1, BurrowAnim)
	
	return inst
end

local function fn_burrow()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
	inst.entity:AddNetwork()
	
	inst.AnimState:SetBank("uncompromising_rat_burrow")
	inst.AnimState:SetBuild("uncompromising_rat_burrow")
	inst.AnimState:PushAnimation("idle", true)
	
	inst:AddTag("ratburrow")
	inst:AddTag("herd")
    inst:AddTag("trader")
	
    inst.MiniMapEntity:SetIcon("uncompromising_ratburrow.tex")
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
    inst:AddComponent("thief")
	
	inst:AddComponent("herd")
	inst.components.herd:SetGatherRange(40)
	inst.components.herd:SetUpdateRange(nil)
	inst.components.herd.maxsize = 8
	inst.components.herd.nomerging = true
    inst.components.herd.updateposincombat = true
	inst.components.herd:SetOnEmptyFn(BurrowKilled)
	inst.components.herd.updatepos = false
	inst.components.herd.updateposincombat = false
	
	inst:AddComponent("timer")
    inst.components.timer:StartTimer("scoutingparty", 1920 + math.random(480))
	inst:ListenForEvent("timerdone", OnTimerDone)
	
	inst:AddComponent("periodicspawner")
	inst.components.periodicspawner:SetRandomTimes(10, 13)
	inst.components.periodicspawner:SetPrefab("uncompromising_rat")
	inst.components.periodicspawner:SetOnSpawnFn(OnSpawned)
	inst.components.periodicspawner:SetDensityInRange(30, 8)
	inst.components.periodicspawner:Start()
	--inst.components.periodicspawner.spawnoffscreen = true
	
	inst:AddComponent("combat")
	inst:AddComponent("inventory")
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetChanceLootTable('ratburrow_small')
	inst:AddComponent("inspectable")
	
	inst:AddComponent("workable")
	inst.components.workable:SetOnFinishCallback(onfinishcallback)
	inst.components.workable:SetOnWorkCallback(onworked)
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetWorkLeft(3)
	
    inst:AddComponent("trader")
    inst.components.trader:SetAbleToAcceptTest(AbleToAcceptTest)
    inst.components.trader:SetAcceptTest(AcceptTest)
    inst.components.trader.onaccept = OnGetItemFromPlayer
    inst.components.trader.onrefuse = OnRefuseItem
	
	inst:DoTaskInTime(1, BurrowAnim)
	
    inst:DoTaskInTime(0, OnInit)
    inst:ListenForEvent("onremove", OnRemoved)
	
	return inst
end

local function WinkyInteract(inst, doer)
	if doer:HasTag("ratwhisperer") and doer.components.hunger and doer.components.hunger.current >= 20 then
		doer.components.hunger:DoDelta(-20)
	
		local newrat = SpawnPrefab("uncompromising_rat")
		newrat.Transform:SetPosition(inst.Transform:GetWorldPosition())
		doer.components.leader:AddFollower(newrat)
		
		inst.ratcount = inst.ratcount + 1
		
		if inst.ratcount >= 3 then
			inst:winkyburrowremove()
		end
		
		inst.AnimState:PlayAnimation("dig")
		inst.SoundEmitter:PlaySound("turnoftides/creatures/together/carrat/submerge")
	end
end

local function onsave_winkyburrow(inst, data)
	if inst.ratcount ~= nil then
		data.ratcount = inst.ratcount
	end
	
	if inst.myowner ~= nil then
		data.myowner = inst.myowner
	end
end

local function onload_winkyburrow(inst, data)
	if data ~= nil then
		if data.ratcount ~= nil then
			inst.ratcount = data.ratcount
		end
		
		if data.myowner ~= nil then
			inst.myowner = data.myowner
		end
	end
end

local function winkyburrowremove(inst)
	inst:AddTag("NOCLICK")
	inst.components.container:Close()
	inst.components.sizetweener:StartTween(0.05, 1, inst.Remove)
end

local function WinkyBurrowDespawn(inst)
	inst:winkyburrowremove()
	inst.persists = false
end

local function OnStopChanneling(inst)
	inst.channeler = nil
end

local function onopen(inst, data)
	if TheWorld.components.winkyburrowinventory.trunk and not TheWorld.components.winkyburrowinventory.trunk.components.container:IsOpen() then
		TheWorld.components.winkyburrowinventory.trunk.Transform:SetPosition(data.doer.Transform:GetWorldPosition())
		TheWorld.components.winkyburrowinventory.trunk.components.container:Open(data.doer)
	else
		inst.components.container:Close(data.doer)
	end
	
	inst.AnimState:PlayAnimation("dig")
end

local function onclose(inst, data)
	if TheWorld.components.winkyburrowinventory.trunk then
		TheWorld.components.winkyburrowinventory.trunk.components.container:Close(data.doer)
	end
	
	inst.AnimState:PlayAnimation("dig")
end

local function GetActivateVerb(inst)
	return "OPEN"
end

local function fn_winkyburrow()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
	inst.entity:AddNetwork()
	
	inst.AnimState:SetBank("uncompromising_rat_burrow")
	inst.AnimState:SetBuild("uncompromising_rat_burrow")
	inst.AnimState:PushAnimation("idle", true)
	
	inst:AddTag("winky_storage")
	inst:AddTag("herd")
    inst:AddTag("trader")
	inst:AddTag("chest")
	
    inst.MiniMapEntity:SetIcon("uncompromising_ratburrow.tex")
	
	inst.Transform:SetScale(0.8, 0.8, 0.8)
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		inst.OnEntityReplicated = function(inst) 
			if inst.replica.container ~= nil then
				inst.replica.container:WidgetSetup("winkyburrow_child") 
			end
		end
        return inst
	end
	
	inst.ratcount = 0

	inst:AddComponent("combat")
	inst:AddComponent("inspectable")
	inst:AddComponent("sizetweener")
	
	inst:AddComponent("container")
	inst.components.container:WidgetSetup("winkyburrow_child")
	inst.components.container.onopenfn = onopen
	inst.components.container.onclosefn = onclose
	inst.components.container.skipclosesnd = true
	inst.components.container.skipopensnd = true
	
	inst:AddComponent("workable")
	inst.components.workable:SetOnFinishCallback(WinkyBurrowDespawn)
	inst.components.workable:SetOnWorkCallback(nil)
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetWorkLeft(1)
	
    inst:AddComponent("channelable")
    inst.components.channelable:SetChannelingFn(WinkyInteract, OnStopChanneling)
    inst.components.channelable.use_channel_longaction_noloop = true
    --inst.components.channelable.skip_state_stopchanneling = true
    inst.components.channelable.skip_state_channeling = true
    --inst.components.channelable.ignore_prechannel = true
	
	inst.GetActivateVerb = GetActivateVerb
	
	inst:DoTaskInTime(1, BurrowAnim)
	
	inst.winkyburrowremove = winkyburrowremove
	inst.OnSave = onsave_winkyburrow
	inst.OnLoad = onload_winkyburrow
	
    inst:DoTaskInTime(60, WinkyBurrowDespawn)
	
	return inst
end

local function fn_winkyhomeburrow()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
	inst.entity:AddNetwork()
	
	inst.AnimState:SetBank("uncompromising_rat_burrow")
	inst.AnimState:SetBuild("uncompromising_rat_burrow")
	inst.AnimState:PushAnimation("idle", true)
	
	inst:AddTag("winkyburrow")
	inst:AddTag("winky_storage")
	inst:AddTag("herd")
    inst:AddTag("trader")
	inst:AddTag("chest")
	
    inst.MiniMapEntity:SetIcon("uncompromising_winkyhomeburrow.tex")
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		inst.OnEntityReplicated = function(inst) 
			if inst.replica.container ~= nil then
				inst.replica.container:WidgetSetup("winkyburrow_child") 
			end
		end
        return inst
	end
	
	inst.ratcount = 0
	inst.myowner = nil
	
	inst:AddComponent("combat")
	inst:AddComponent("inspectable")
	inst:AddComponent("sizetweener")

	inst:AddComponent("container")
	inst.components.container:WidgetSetup("winkyburrow_child")
	inst.components.container.onopenfn = onopen
	inst.components.container.onclosefn = onclose
	inst.components.container.skipclosesnd = true
	inst.components.container.skipopensnd = true
	
	inst:AddComponent("workable")
	inst.components.workable:SetOnFinishCallback(WinkyBurrowDespawn)
	inst.components.workable:SetOnWorkCallback(nil)
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetWorkLeft(1)
	
	inst:DoTaskInTime(1, BurrowAnim)
	
	inst.winkyburrowremove = winkyburrowremove
	inst.OnSave = onsave_winkyburrow
	inst.OnLoad = onload_winkyburrow
	
	return inst
end

local function fn_winkyburrow_master()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()
	
	inst:AddTag("chest")
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		inst.OnEntityReplicated = function(inst) 
			if inst.replica.container ~= nil then
				inst.replica.container:WidgetSetup("winkyburrow") 
			end
		end
        return inst
	end
	
	inst:AddComponent("container")
	inst.components.container:WidgetSetup("winkyburrow")
	--inst.components.container.onopenfn = onopen
	--inst.components.container.onclosefn = onclose
	--inst.components.container.skipclosesnd = true
	--inst.components.container.skipopensnd = true
	
	return inst
end

local function SlumberParty(inst)
	if inst.components.herd.members ~= nil and inst.components.herd.membercount > 0 then
		local x, y, z = inst.Transform:GetWorldPosition()
		
		local ents = #TheSim:FindEntities(x, y, z, 8, { "ratscout" })
		if ents ~= nil and ents > 0 then
			--print("The girls are here, commencing pillowfort construction...")
			local burrow = SpawnPrefab("uncompromising_ratburrow")
			burrow.Transform:SetPosition(x, 0, z)
			burrow.AnimState:PlayAnimation("spawn")
			
			local players = #TheSim:FindEntities(x, y, z, 30, { "player" })
			
			if math.random() >= 0.7 then
				if players < 1 then
					local piper = SpawnPrefab("pied_rat")
				
					piper.Transform:SetPosition(inst.Transform:GetWorldPosition())
					burrow.components.herd:AddMember(piper)
				end
			end
			
			for i, b in ipairs(inst.components.herd.members) do
				b:RemoveTag("ratscout")
				burrow.components.herd:AddMember(b)
			end
			
			inst:Remove()
		end
	else
		inst:Remove()
	end
end

local function CheckIfEmpty(inst)
	if inst.components.herd.membercount == 0 then
		inst:Remove()
	end
end

local function fn_scoutburrow()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.AnimState:SetBank("uncompromising_rat_burrow")
	inst.AnimState:SetBuild("uncompromising_rat_burrow")
	inst.AnimState:PushAnimation("idle_pile", true)
	
	inst:AddTag("herd")
	inst.entity:SetCanSleep(false)
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("herd")
	inst.components.herd:SetGatherRange(40)
	inst.components.herd:SetUpdateRange(nil)
	inst.components.herd:SetOnEmptyFn(inst.Remove)
	inst.components.herd:SetRemoveMemberFn(CheckIfEmpty)
	inst.components.herd.maxsize = 8
	inst.components.herd.nomerging = true
    inst.components.herd.updateposincombat = true
	inst.components.herd.updatepos = false
	inst.components.herd.updateposincombat = false
	
	inst:DoPeriodicTask(5, SlumberParty) -- !!!
	
	return inst
end

local function IsAVersionOfRot(v)
	if v.prefab == "spoiled_food" or v.prefab == "rottenegg" or v.prefab == "spoiled_fish" or v.prefab == "spoiled_fish_small" then
		return true
	end
end

local NOTAGS =
{
	"smallcreature",
	"_container",
	"spore",
}

local function IsHeavyObject(v)
	if v:HasTag("heavy") or v:HasTag("heavyobject") then
		return true
	end
end

local function SmellProtection(v,container)
	local x,y,z = v.Transform:GetWorldPosition()
	local flowers = #TheSim:FindEntities(x,y,z,5,{"flower"})
	local decoratedSisturn = FindEntity(v,10,function(inst) return (inst.prefab == "sisturn" and (inst.components.container and inst.components.container:IsFull())) end)
	local potted_ = TheSim:FindEntities(x,y,z,6,{"cavedweller"})
	local potted = 0 -- both potted plants have the cavedweller tag for some reason I have no idea
	local forget_me_lots = 0 -- The end-all-beat-all, forget-me-lots's ability to make those who smell or eat them forgetful is the perfect insulator for rats
	local item_forget_me_lots = TheSim:FindEntities(x,y,z,3,{"vasedecoration"}) 
	local mod = 1
	local vases = TheSim:FindEntities(x,y,z,10,{"vase"}) -- Best Range!
	
	--- Forget-me-lots (and flowers)
	for i,j in ipairs(vases) do
		if j.prefab == "endtable" then
			if j.flowerid == 1 or j.flowerid == 2 or j.flowerid == 3 or j.flowerid == 4 or j.flowerid == 6 or j.flowerid == 10 or j.flowerid == 11 or j.flowerid == 12 or j.flowerid == 15 then --Moon tree blossoms might as well count towards flowers
				flowers = flowers + 1
			end
			if j.flowerid == 13 or j.flowerid == 14 then
				forget_me_lots = forget_me_lots + 1
			end
		end
	end
	for i,j in ipairs(item_forget_me_lots) do
		if j.prefab == "forgetmelots" then
			forget_me_lots = forget_me_lots + 1
		end
	end
	--- Forget-me-lots
	
	--- Potted
	for i,j in ipairs(potted_) do
		if j.prefab == "pottedfern" then
			potted = potted + 1
		end
		if j.prefab == "succulent_potted" then
			potted = potted + 1
		end
	end
	--- Potted

	if FindEntity(v,8,function(guy) if guy.components.bloomness and guy.components.bloomness.level and guy.components.bloomness.level > 2 then return true end end,{"plantkin"}) ~= nil then
		flowers = flowers + 10
	end
	if decoratedSisturn ~= nil then
		flowers = 25
	end
	flowers = flowers / 50
	--print(flowers)
	potted = potted / 20
	--print(potted)
	forget_me_lots = forget_me_lots / 10
	--print(forget_me_lots)
	
	mod = 1 - flowers - potted - forget_me_lots
	
	if mod < 0.5 then
		mod = 0.5
	end
	--[[
	local total_weighted_score = flowers + potted + 2 * forget_me_lots
	if container ~= true then
		-- There's not much we can do for things on the ground, not even forget-me-lots
		if total_weighted_score > 0 then
			mod = 0.8
		end
		if total_weighted_score > 3 then
			mod = 0.7
		end
	else
		if v:HasTag("stale") then
			if total_weighted_score > 0 then
				mod = 0.6
			end
			if total_weighted_score > 2 then
				mod = 0.3
			end
			if total_weighted_score > 4 then
				mod = 0 --Stale foods can actually reduce the mod to zero with just flowers and potted plants
			end
			if forget_me_lots > 0 then
				mod = 0 -- But Forget-me-lots are better
			end
		end
		if v:HasTag("spoiled") then
			if total_weighted_score > 0 then
				mod = 0.8
			end
			if total_weighted_score > 2 then
				mod = 0.6
			end
			if total_weighted_score > 4 then
				mod = 0.3 --Spoiled foods have been left for too long to fully negate without forget-me-lots
			end
			if forget_me_lots > 3 then --Forget-me-lots are capable of fully negating spoiled food issue if enough are used
				mod = 0
			end
		end
		if IsAVersionOfRot(v) then
			if total_weighted_score > 0 then
				mod = 0.9
			end
			if total_weighted_score > 2 then
				mod = 0.8
			end
			if total_weighted_score > 4 then
				mod = 0.7 --Rot is nearly hopeless to reduce all the way, not without strong forget-me-lots
			end
			if forget_me_lots > 3 then
				mod = 0.7
			end
			if forget_me_lots > 5 then
				mod = 0.5
			end
			if forget_me_lots > 10 then
				mod = 0.3 -- This is as much as we can do... enough rot will eventually break through the guise of the forget-me-lots, with just 40 you'll end up with a decently large foodscore
			end
		end
	end]]
	if v.prefab == "forgetmelots" then --Forget-me-lots conceal themselves as long has they have not fully rotted!
		mod = 0
	end
	return mod
end

local function FoodScoreCalculations(inst,container,v)
	local delta = 0
	inst.multiplier = v.components.stackable and v.components.stackable:StackSize() or 1
	inst.preparedmultiplier = v:HasTag("preparedfood") and 2 or 1
	
	if container == true then
		if v:HasTag("stale") and v.components.farmplantable == nil then
			delta = ((2.5 * inst.preparedmultiplier) * inst.multiplier) * SmellProtection(v,container)
		end
		if v:HasTag("spoiled") and v.components.farmplantable == nil then
			delta = ((5 * inst.preparedmultiplier) * inst.multiplier) * SmellProtection(v,container)
		end
		if IsAVersionOfRot(v) then
			delta = ((5 * inst.preparedmultiplier) * inst.multiplier) * SmellProtection(v,container)
		end
	else
		if v:HasTag("fresh") and v.components.farmplantable == nil then
			delta = ((5 * inst.preparedmultiplier) * inst.multiplier) * SmellProtection(v,container)
		end
		if v:HasTag("stale") and v.components.farmplantable == nil then
			delta = ((10 * inst.preparedmultiplier) * inst.multiplier) * SmellProtection(v,container)
		end
		if v:HasTag("spoiled") and v.components.farmplantable == nil then
			delta = ((15 * inst.preparedmultiplier) * inst.multiplier) * SmellProtection(v,container)
		end
		if IsAVersionOfRot(v) then
			delta = ((15 * inst.preparedmultiplier) * inst.multiplier) * SmellProtection(v,container)
		end
	end
	inst.foodscore = inst.foodscore + delta
end

local function TimeForACheckUp(inst,dev)
	local x, y, z = inst.Transform:GetWorldPosition()

	local ents = TheSim:FindEntities(x, 0, z, 40, {"_inventoryitem"},NOTAGS)
	--[[print("THE RAT SNIFFS")
	print("                o")
	print("    =========B  *sniff* *sniff*")
	print("---========vv")
	print("   ========")
	print("    V V    V V")]]
	
	inst.ratscore = -60
	inst.itemscore = 0
	inst.foodscore = 0
	--print(#ents)
	
	if ents ~= nil then
		for i, v in ipairs(ents) do
			--if ShouldCountTowardsCheck(v) then
				if v.components.inventoryitem:IsHeld() then
					if v.components.inventoryitem and v.components.inventoryitem:GetGrandOwner() ~= nil and (v.components.inventoryitem:GetGrandOwner().prefab == "lureplant"or v.components.inventoryitem:GetGrandOwner().prefab == "catcoon") then
						--print("lureplant is holding!")
					else
						if not v:HasTag("frozen") then
							FoodScoreCalculations(inst,true,v)
						end
					end
				else
					if not v:HasTag("frozen") then
						FoodScoreCalculations(inst,false,v)
					end
					
	--[[
					if v.components.inventoryitem and v.components.inventoryitem:GetGrandOwner() ~= nil and (v.components.inventoryitem:GetGrandOwner():HasTag("_container") or v.components.inventoryitem:GetGrandOwner():HasTag("player")) then
						print("uncheckable entity is holding!")
					else
						if not v:HasTag("frozen") then
							inst.multiplier = v.components.stackable and v.components.stackable:StackSize() or 1
							inst.preparedmultiplier = v:HasTag("preparedfood") and 2 or 1
							
							if v:HasTag("stale") then
								inst.foodscore = inst.foodscore + ((2.5 * inst.preparedmultiplier) * inst.multiplier)
							elseif v:HasTag("spoiled") then
								inst.foodscore = inst.foodscore + ((5 * inst.preparedmultiplier) * inst.multiplier)
							elseif IsAVersionOfRot(v) then
								inst.multiplier = v.components.stackable and v.components.stackable:StackSize() or 1
								inst.foodscore = inst.foodscore + ((5 * inst.preparedmultiplier) * inst.multiplier)
							end
						end
					end
				else
					if not v:HasTag("frozen") then
						inst.multiplier = v.components.stackable and v.components.stackable:StackSize() or 1
						inst.preparedmultiplier = v:HasTag("preparedfood") and 2 or 1
							
						if v:HasTag("fresh") then
							inst.foodscore = inst.foodscore + ((5 * inst.preparedmultiplier) * inst.multiplier)
						elseif v:HasTag("stale") then
							inst.foodscore = inst.foodscore + ((10 * inst.preparedmultiplier) * inst.multiplier)
						elseif v:HasTag("spoiled") then
							inst.foodscore = inst.foodscore + ((15 * inst.preparedmultiplier) * inst.multiplier)
						elseif IsAVersionOfRot(v) then
							inst.multiplier = v.components.stackable and v.components.stackable:StackSize() or 1
							inst.foodscore = inst.foodscore + ((15 * inst.preparedmultiplier) * inst.multiplier)
						end
					end
	]]				
					if not (v:HasTag("balloon") or v:HasTag("heavy") or v:HasTag("projectile") or v:HasTag("NORATCHECK")) then
						if (v:HasTag("_equippable") or v:HasTag("gem") or v:HasTag("tool"))  then
							inst.itemscore = inst.itemscore + 30 -- Oooh, wants wants! We steal!
						elseif v:HasTag("molebait") then
							inst.itemscore = inst.itemscore + 2 -- Oooh, wants wants! We steal!
						end
					end
				end
		end
	end
	
	inst.ratburrows = TheWorld.components.ratcheck ~= nil and TheWorld.components.ratcheck:GetBurrows() or 0
	inst.burrowbonus = 15 * inst.ratburrows
	
	
	inst.ratscore = inst.ratscore + inst.itemscore + inst.foodscore + inst.burrowbonus
	--print("------------------------")
	--print("Itemscore = "..inst.itemscore)
	--print("Foodscore = "..inst.foodscore)
	--print("Burrowbonus = "..inst.burrowbonus)
	--print("Ratscore = "..inst.ratscore)
	--print("------------------------")
	--just use the command if you wanna see i guess.
	if TUNING.DSTU.ANNOUNCE_BASESTATUS == true then
		TheNet:SystemMessage("-------------------------")
		TheNet:SystemMessage("Itemscore = "..inst.itemscore)
		TheNet:SystemMessage("Foodscore = "..inst.foodscore)
		TheNet:SystemMessage("Burrowbonus = "..inst.burrowbonus)
		TheNet:SystemMessage("Ratscore = "..inst.ratscore)
	end
	if inst.ratscore > 240 then
		inst.ratscore = 240
	end
	if TUNING.DSTU.ANNOUNCE_BASESTATUS == true then
		TheNet:SystemMessage("True Ratscore = "..inst.ratscore)
		TheNet:SystemMessage("-------------------------")
	end
	TheWorld:PushEvent("reducerattimer", {value = inst.ratscore})
	
	
	inst.ratwarning = inst.ratscore / 48
	
	
		--[[
		for c = 1, (inst.ratwarning) do
			inst:DoTaskInTime((c/4), function(inst)
				local warning = SpawnPrefab("uncompromising_ratwarning")
				warning.Transform:SetPosition(inst.Transform:GetWorldPosition())
				--warning.entity:SetParent(b)
				--b.SoundEmitter:PlaySound("UCSounds/ratsniffer/warning")
				--warning.entity:SetParent(TheFocalPoint.b.entity)
			end)
		end
	end]]
	if inst.ratscore >= 60 then
		if math.random() > 0.85 then
			if inst.ratwarning > 5 then
				inst.ratwarning = 5
			end
			
			for c = 1, (inst.ratwarning) do
				inst:DoTaskInTime((c/5), function(inst)
					local warning = SpawnPrefab("uncompromising_ratwarning")
					warning.Transform:SetPosition(inst.Transform:GetWorldPosition())
					--warning.entity:SetParent(b)
					--b.SoundEmitter:PlaySound("UCSounds/ratsniffer/warning")
					--warning.entity:SetParent(TheFocalPoint.b.entity)
				end)
			end
			
			local players = TheSim:FindEntities(x, y, z, 40, {"player"},{"playerghost"})
			for a, b in ipairs(players) do
				
				if math.random() > 0.5 then
					if inst.burrowbonus > inst.itemscore and inst.burrowbonus > inst.foodscore then
						b:DoTaskInTime(2+math.random(), function(b)
							b.components.talker:Say(GetString(b, "ANNOUNCE_RATSNIFFER_BURROWS", "LEVEL_1"))
						end)
					elseif inst.itemscore > inst.burrowbonus and inst.itemscore > inst.foodscore then
						b:DoTaskInTime(2+math.random(), function(b)
							b.components.talker:Say(GetString(b, "ANNOUNCE_RATSNIFFER_ITEMS", "LEVEL_1"))
						end)
					elseif inst.foodscore > inst.burrowbonus and inst.foodscore > inst.itemscore then
						b:DoTaskInTime(2+math.random(), function(b)
							b.components.talker:Say(GetString(b, "ANNOUNCE_RATSNIFFER_FOOD", "LEVEL_1"))
						end)
					end
				end
			end
		end
	end
end

local function fn_sniffer()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst:AddTag("rat_sniffer")
	inst:AddTag("NOBLOCK")
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:ListenForEvent("rat_sniffer", TimeForACheckUp)
	
	return inst
end

local function fn_droppings()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    --inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(3)
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetBank("ratdroppings")
    inst.AnimState:SetBuild("ratdroppings")
    inst.AnimState:PlayAnimation("idle"..math.random(4))
	
    MakeInventoryPhysics(inst)

	--inst:AddTag("fx")
	inst:AddTag("raidrat")
	
	MakeInventoryFloatable(inst)
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then 
		return inst
	end
	
	inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.nobounce = true
	inst.components.inventoryitem:SetOnPutInInventoryFn(
		function(inst)
			inst:DoTaskInTime(.5, inst.Remove) 
		end
	)

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
	inst.components.perishable.onperishreplacement = "disease_puff"
	
    return inst
end

local function PlayWarningSound(inst)

    --inst.entity:SetParent(TheFocalPoint.entity)
	--print(TheFocalPoint.entity)
    local theta = math.random() * 2 * PI

	local x, y, z = inst.Transform:GetWorldPosition()
    inst.Transform:SetPosition(x + (15 * math.cos(theta)), 0, z + 15 * (math.sin(theta)))

	local x, y, z = inst.Transform:GetWorldPosition()
	--print(x, y, z)
	--TheFocalPoint.SoundEmitter:PlaySound("UCSounds/ratsniffer/warning")
    inst.SoundEmitter:PlaySound("UCSounds/ratsniffer/warning")
    
	inst:DoTaskInTime(3, inst.Remove)
end

local function fn_warning()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	inst:AddTag("FX")		
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then 
		return inst
	end

	inst:DoTaskInTime(0, function() 
		PlayWarningSound(inst)
	end)

	inst.persists = false

	return inst
end


--[[
local function TimeForACheckUpDev(inst)
	local x, y, z = inst.Transform:GetWorldPosition()

	local ents = TheSim:FindEntities(x, 0, z, 40, {"_inventoryitem"})
	print("THE RAT SNIFFS")
	print("                o")
	print("    =========B  *sniff* *sniff*")
	print("---========vv")
	print("   ========")
	print("    V V    V V")
	
	inst.ratscore = -60
	inst.itemscore = 0
	inst.foodscore = 0
	--print(#ents)
	
	if ents ~= nil then
		for i, v in ipairs(ents) do
			if not v:HasTag("_container") and not v:HasTag("smallcreature") then
				if v.components.inventoryitem:IsHeld() then
				
				
					if v.components.inventoryitem and v.components.inventoryitem:GetGrandOwner() ~= nil and v.components.inventoryitem:GetGrandOwner().prefab == "lureplant" then
						--print("lureplant is holding!")
					else
						if not v:HasTag("frozen") then
							inst.multiplier = v.components.stackable and v.components.stackable:StackSize() or 1
						
							if v:HasTag("stale") then
								inst.foodscore = inst.foodscore + (5 * inst.multiplier)
							elseif v:HasTag("spoiled") then
								inst.foodscore = inst.foodscore + (10 * inst.multiplier)
							elseif IsAVersionOfRot(v)  then
								inst.multiplier = v.components.stackable and v.components.stackable:StackSize() or 1
								inst.foodscore = inst.foodscore + (15 * inst.multiplier)
							end
						end
					end
				else
					if not v:HasTag("frozen") then
						inst.multiplier = v.components.stackable and v.components.stackable:StackSize() or 1
						
						if v:HasTag("fresh") then
							inst.foodscore = inst.foodscore + (10 * inst.multiplier)
						elseif v:HasTag("stale") then
							inst.foodscore = inst.foodscore + (20 * inst.multiplier)
						elseif v:HasTag("spoiled") then
							inst.foodscore = inst.foodscore + (30 * inst.multiplier)
						elseif IsAVersionOfRot(v) then
							inst.multiplier = v.components.stackable and v.components.stackable:StackSize() or 1
							inst.foodscore = inst.foodscore + (35 * inst.multiplier)
						end
					end
					
					if v:HasTag("_equippable") or v:HasTag("gem") or v:HasTag("tool") then
						inst.itemscore = inst.itemscore + 30 -- Oooh, wants wants! We steal!
					elseif v:HasTag("molebait") then
						inst.itemscore = inst.itemscore + 2 -- Oooh, wants wants! We steal!
					end
				end
			end
		end
	end
	
	inst.ratburrows = TheWorld.components.ratcheck ~= nil and TheWorld.components.ratcheck:GetBurrows() or 0
	inst.burrowbonus = 15 * inst.ratburrows
	
	
	inst.ratscore = inst.ratscore + inst.itemscore + inst.foodscore + inst.burrowbonus
	print("------------------------")
	print("Itemscore = "..inst.itemscore)
	print("Foodscore = "..inst.foodscore)
	print("Burrowbonus = "..inst.burrowbonus)
	print("Ratscore = "..inst.ratscore)
	print("------------------------")
	if TUNING.DSTU.ANNOUNCE_BASESTATUS == true then
		TheNet:SystemMessage("-------------------------")
		TheNet:SystemMessage("Itemscore = "..inst.itemscore)
		TheNet:SystemMessage("Foodscore = "..inst.foodscore)
		TheNet:SystemMessage("Burrowbonus = "..inst.burrowbonus)
		TheNet:SystemMessage("Ratscore = "..inst.ratscore)
		TheNet:SystemMessage("-------------------------")
	end
	if inst.ratscore > 240 then
		inst.ratscore = 240
	end
	TheWorld:PushEvent("reducerattimer", {value = inst.ratscore})
	
	
	inst.ratwarning = inst.ratscore / 48
	
	if inst.ratscore >= 60 then
		--if math.random() > 0.85 then
			if inst.ratwarning > 5 then
				inst.ratwarning = 5
			end
			
			for c = 1, (inst.ratwarning) do
				inst:DoTaskInTime((c/5), function(inst)
					local warning = SpawnPrefab("uncompromising_ratwarning")
					warning.Transform:SetPosition(inst.Transform:GetWorldPosition())
					--warning.entity:SetParent(b)
					--b.SoundEmitter:PlaySound("UCSounds/ratsniffer/warning")
					--warning.entity:SetParent(TheFocalPoint.b.entity)
				end)
			end
			
			local players = TheSim:FindEntities(x, y, z, 40, {"player"},{"playerghost"})
			for a, b in ipairs(players) do
				if b.prefab == "wilson" then
					--if math.random() > 0.5 then
						if inst.burrowbonus > inst.itemscore and inst.burrowbonus > inst.foodscore then
							b:DoTaskInTime(2+math.random(), function(b)
								b.components.talker:Say(GetString(b, "ANNOUNCE_RATSNIFFER_BURROWS", "LEVEL_1"))
							end)
						elseif inst.itemscore > inst.burrowbonus and inst.itemscore > inst.foodscore then
							b:DoTaskInTime(2+math.random(), function(b)
								b.components.talker:Say(GetString(b, "ANNOUNCE_RATSNIFFER_ITEMS", "LEVEL_1"))
							end)
						elseif inst.foodscore > inst.burrowbonus and inst.foodscore > inst.itemscore then
							b:DoTaskInTime(2+math.random(), function(b)
								b.components.talker:Say(GetString(b, "ANNOUNCE_RATSNIFFER_FOOD", "LEVEL_1"))
							end)
						end
					--end
				end
			end
		--end
	end
	
	inst:Remove()
end]] --This does nothing different than the other one

local function fn_devwarning()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst:AddTag("rat_sniffer")
	inst:AddTag("NOBLOCK")
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:DoTaskInTime(5, function(inst) TimeForACheckUp(inst,true) end)
	
	return inst
end

return Prefab("uncompromising_rat", fn, assets, prefabs),
	Prefab("uncompromising_junkrat", junkfn),
	Prefab("uncompromising_packrat", packfn, assets, prefabs),
	Prefab("uncompromising_ratherd", fn_herd, assets, prefabs),
	Prefab("uncompromising_ratburrow", fn_burrow, assets, prefabs),
	Prefab("uncompromising_winkyburrow", fn_winkyburrow, assets, prefabs),
	Prefab("uncompromising_winkyhomeburrow", fn_winkyhomeburrow, assets, prefabs),
	Prefab("uncompromising_winkyburrow_master", fn_winkyburrow_master, assets, prefabs),
	Prefab("uncompromising_scoutburrow", fn_scoutburrow, assets, prefabs),
	Prefab("uncompromising_ratsniffer", fn_sniffer, assets, prefabs),
	Prefab("ratdroppings", fn_droppings, assets),
	Prefab("uncompromising_ratwarning", fn_warning),
	Prefab("devtestratwarning", fn_devwarning)