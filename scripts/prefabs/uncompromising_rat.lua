local assets =
{
	Asset("ANIM", "anim/uncompromising_rat.zip"),
	Asset("ANIM", "anim/uncompromising_caverat.zip"),
	Asset("ANIM", "anim/carrat_basic.zip"),
	Asset("ANIM", "anim/uncompromising_rat_water.zip"),
	Asset("ANIM", "anim/uncompromising_rat_burrow.zip"),
	Asset("ANIM", "anim/uncompromising_junkrat.zip"),
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

SetSharedLootTable("raidrat",
{
	{"monstermeat",		1.00},
	{"goldnugget",		0.33},
})

local brain = require "brains/uncompromising_ratbrain"
local junkbrain = require "brains/uncompromising_junkratbrain"

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
	if data.target ~= nil and data.target:HasTag("player") and not data.target:HasTag("hasplaguemask") then
		data.target.components.health:DeltaPenalty(0.01)
	end
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
	if data.item.components.explosive == nil then
		inst:AddTag("carrying")
		data.item:AddTag("raided")
		local item = string.lower(data.item.prefab)
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
end

local function onload_rat(inst, data)
	if data ~= nil and data.carrying ~= nil then
		inst.components.inventory:DropEverything()
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

local RETARGET_CANT_TAGS = { "wall", "raidrat"}
local function rattargetfn(inst)
    return FindEntity(
                inst, 5,
                function(guy)
					local validitem = guy.components.inventory ~= nil and guy.components.inventory:FindItem(function(item) return not item:HasTag("nosteal") end)
                    return inst:GetTimeAlive() > 5 and not 
					inst:HasTag("carrying") and
					guy:HasTag("player") and
					validitem ~= nil and
					inst.components.combat:CanTarget(guy)
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
	inst.components.combat:DropTarget()
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
	--inst:AddTag("canbetrapped")
	inst:AddTag("cattoy")
	inst:AddTag("catfood")
	inst:AddTag("cookable")
	
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
	inst.components.eater:SetDiet({ FOODTYPE.HORRIBLE }, { FOODTYPE.HORRIBLE })
	inst.components.eater.strongstomach = true
	inst.components.eater:SetCanEatRaw()
	
	inst:AddComponent("workmultiplier")
	inst.components.workmultiplier:AddMultiplier(ACTIONS.HAMMER, -0.8, inst)
	
	inst:AddComponent("combat")
	inst.components.combat:SetDefaultDamage(TUNING.DSTU.RAIDRAT_DAMAGE)
	inst.components.combat:SetAttackPeriod(TUNING.DSTU.RAIDRAT_ATTACK_PERIOD)
	inst.components.combat:SetRange(TUNING.DSTU.RAIDRAT_ATTACK_RANGE)
	inst.components.combat.hiteffectsymbol = "carrat_body"
    inst.components.combat.onhitotherfn = OnHitOther
	inst.components.combat:SetRetargetFunction(3, rattargetfn)
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
	inst.components.inventoryitem:SetSinks(true)
	
	inst:AddComponent("herdmember")
	
	inst:AddComponent("knownlocations")
	
	inst:AddComponent("cookable")
	inst.components.cookable.product = "cookedmonstersmallmeat"
	inst.components.cookable:SetOnCookedFn(on_cooked_fn)
	
	inst:AddComponent("inventory")
	inst.components.inventory.maxslots = 1
	
	inst:AddComponent("inspectable")
	
	inst:ListenForEvent("onattackother", OnAttackOther)
	inst:ListenForEvent("attacked", OnAttacked)
	inst:ListenForEvent("death", OnDeath)
	inst:ListenForEvent("onpickupitem", OnPickup)
	inst:ListenForEvent("trapped", Trapped)
	
	MakeHauntablePanic(inst)
	
	--MakeFeedableSmallLivestock(inst, TUNING.CARRAT.PERISH_TIME, nil, on_dropped)
	
	MakeSmallBurnableCharacter(inst, "carrat_body")
	MakeSmallFreezableCharacter(inst, "carrat_body")
	
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
	--inst:AddTag("canbetrapped")
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
	
	inst.Transform:SetScale(1.5,1.5,1.5)
	
	inst:AddComponent("eater")
	inst.components.eater:SetDiet({ FOODTYPE.HORRIBLE }, { FOODTYPE.HORRIBLE })
	inst.components.eater.strongstomach = true
	inst.components.eater:SetCanEatRaw()
	
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
	inst:AddTag("hostile")
	inst:AddTag("herdmember")
	inst:AddTag("smallcreature")
	--inst:AddTag("canbetrapped")
	inst:AddTag("cattoy")
	inst:AddTag("catfood")
	inst:AddTag("cookable")
	
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
	inst.components.eater:SetDiet({ FOODTYPE.HORRIBLE }, { FOODTYPE.HORRIBLE })
	inst.components.eater.strongstomach = true
	inst.components.eater:SetCanEatRaw()
	
	inst:AddComponent("workmultiplier")
	inst.components.workmultiplier:AddMultiplier(ACTIONS.HAMMER, -0.8, inst)
	
	inst:AddComponent("combat")
	inst.components.combat:SetDefaultDamage(TUNING.DSTU.RAIDRAT_DAMAGE)
	inst.components.combat:SetAttackPeriod(TUNING.DSTU.RAIDRAT_ATTACK_PERIOD)
	inst.components.combat:SetRange(TUNING.DSTU.RAIDRAT_ATTACK_RANGE)
	inst.components.combat.hiteffectsymbol = "carrat_body"
	
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
	inst.components.inventoryitem:SetSinks(true)
	
	inst:AddComponent("herdmember")
	
	inst:AddComponent("knownlocations")
	
	inst:AddComponent("cookable")
	inst.components.cookable.product = "cookedmonstersmallmeat"
	inst.components.cookable:SetOnCookedFn(on_cooked_fn)
	
	inst:AddComponent("inventory")
	inst.components.inventory.maxslots = 10
	
	inst:AddComponent("inspectable")
	
	inst:ListenForEvent("onattackother", OnAttackOther)
	inst:ListenForEvent("attacked", OnAttacked)
	inst:ListenForEvent("death", OnDeath)
	--inst:ListenForEvent("onpickupitem", OnPickup)
	inst:ListenForEvent("trapped", Trapped)
	
	MakeHauntablePanic(inst)
	
	--MakeFeedableSmallLivestock(inst, TUNING.CARRAT.PERISH_TIME, nil, on_dropped)
	
	MakeSmallBurnableCharacter(inst, "carrat_body")
	MakeSmallFreezableCharacter(inst, "carrat_body")
	
	inst.OnSave = onsave_rat
	inst.OnLoad = onload_rat
	
	return inst
end

local function onfinishcallback(inst)
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
end

local function BurrowKilled(inst)
	inst.components.periodicspawner:Stop()
end

local function BurrowAnim(inst)
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
		end
	end
	inst:DoTaskInTime(3 + math.random(), BurrowAnim)
end

local function MakeRatBurrow(inst)
	local x, y, z = inst.Transform:GetWorldPosition()

    local function IsValidRatBurrowPosition(x, z)
        if #TheSim:FindEntities(x, 0, z, TUNING.ANTLION_SINKHOLE.RADIUS, { "antlion_sinkhole_blocker" }) > 0 then
            return false
        end
        if #TheSim:FindEntities(x, 0, z, 50, { "player", "playerghost" }) > 0 then
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
	
	for i = 1, 4 do
		inst.x1, inst.z1 = x + math.random(-200, 200), z + math.random(-200, 200)
		
		if IsValidRatBurrowPosition(inst.x1, inst.z1) then
			inst.Transform:SetPosition(inst.x1, 0, inst.z1)
			break
		end
	end
end

--GetClosestInstWithTag(tag, inst, radius or 1000)

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
	
	inst.raiding = false
end

local function OnInitHerd(inst)
	if inst.raiding == nil then
		inst.raiding = true
	end

	if inst.raiding then
		for i = 1, 4 do
			inst:DoTaskInTime((i - 1) * 12, function(inst)
				for i = 1, (math.random(4, 5) / i) do
					local x, y, z = inst.Transform:GetWorldPosition()
					local angle = math.random() * 8 * PI
					local rat = SpawnPrefab("uncompromising_rat")
					rat.Transform:SetPosition(x + math.cos(angle), 0, z + math.sin(angle))
					inst.components.herd:AddMember(rat)
				end
				
				if i < 4 then
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
end

local function onpreload_burrow(inst, data)
	if data ~= nil and data.raiding ~= nil then
		inst.raiding = data.raiding
	end
end

local function onload_burrow(inst, data)
	if data ~= nil and data.raiding ~= nil then
		inst.raiding = data.raiding
	end	
	
	if not inst.raiding then
		inst.AnimState:PushAnimation("idle", true)
		
		inst.components.herd:SetOnEmptyFn(BurrowKilled)
		inst.components.herd.updatepos = false
		inst.components.herd.updateposincombat = false
		
		inst:DoTaskInTime(0, EndRaid)
	end
end

local function fn_herd()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.AnimState:SetBank("uncompromising_rat_burrow")
	inst.AnimState:SetBuild("uncompromising_rat_burrow")
	
	inst:AddTag("herd")
	inst:AddTag("NOBLOCK")
	inst:AddTag("NOCLICK")
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("theif")
	
	inst:AddComponent("herd")
	inst.components.herd:SetGatherRange(40)
	inst.components.herd:SetUpdateRange(nil)
	inst.components.herd:SetOnEmptyFn(inst.Remove)
	inst.components.herd.maxsize = 8
	inst.components.herd.nomerging = true
    inst.components.herd.updateposincombat = true
	
	inst:AddComponent("periodicspawner")
	inst.components.periodicspawner:SetRandomTimes(10, 13)
	inst.components.periodicspawner:SetPrefab("uncompromising_rat")
	inst.components.periodicspawner:SetOnSpawnFn(OnSpawned)
	inst.components.periodicspawner:SetDensityInRange(30, 8)
	
	inst:AddComponent("combat")
	
	inst:AddComponent("inventory")
	inst.components.inventory.maxslots = 100
	
	inst:AddComponent("lootdropper")
	
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
	inst.entity:AddNetwork()
	
	inst.AnimState:SetBank("uncompromising_rat_burrow")
	inst.AnimState:SetBuild("uncompromising_rat_burrow")
	inst.AnimState:PushAnimation("idle", true)
	
	inst:AddTag("ratburrow")
	inst:AddTag("herd")
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("theif")
	
	inst:AddComponent("herd")
	inst.components.herd:SetGatherRange(40)
	inst.components.herd:SetUpdateRange(nil)
	inst.components.herd:SetOnEmptyFn(inst.Remove)
	inst.components.herd.maxsize = 8
	inst.components.herd.nomerging = true
    inst.components.herd.updateposincombat = true
	inst.components.herd:SetOnEmptyFn(BurrowKilled)
	inst.components.herd.updatepos = false
	inst.components.herd.updateposincombat = false
	
	inst:AddComponent("periodicspawner")
	inst.components.periodicspawner:SetRandomTimes(10, 13)
	inst.components.periodicspawner:SetPrefab("uncompromising_rat")
	inst.components.periodicspawner:SetOnSpawnFn(OnSpawned)
	inst.components.periodicspawner:SetDensityInRange(30, 8)
	inst.components.periodicspawner:Start()
	
	inst:AddComponent("combat")
	inst:AddComponent("inventory")
	inst:AddComponent("lootdropper")
	inst:AddComponent("inspectable")
	
	inst:AddComponent("workable")
	inst.components.workable:SetOnFinishCallback(onfinishcallback)
	inst.components.workable:SetOnWorkCallback(onworked)
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetWorkLeft(math.random(2, 5))
	
	inst:DoTaskInTime(1, BurrowAnim)
	
	return inst
end

return Prefab("uncompromising_rat", fn, assets, prefabs),
	Prefab("uncompromising_junkrat", junkfn),
	Prefab("uncompromising_packrat", packfn, assets, prefabs),
	Prefab("uncompromising_ratherd", fn_herd, assets, prefabs),
	Prefab("uncompromising_ratburrow", fn_burrow, assets, prefabs)