local assets =
{
	Asset("ANIM", "anim/uncompromising_rat.zip"),
	Asset("ANIM", "anim/carrat_basic.zip"),
	Asset("ANIM", "anim/uncompromising_rat_water.zip"),
	Asset("ANIM", "anim/uncompromising_rat_burrow.zip"),
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
	inst.components.combat:SetTarget(data.attacker)
	inst.components.combat:ShareTarget(data.attacker, 30, function(dude)
		return dude:HasTag("raidrat")
			and not dude.components.health:IsDead()
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
	local is_carrying = data.carrying or inst:HasTag("carrying")
	if is_carrying then
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
		inst.components.amphibiouscreature:SetBanks("packrat", "uncompromising_rat_water")
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
	inst.components.lootdropper:SpawnLootPrefab("rocks", inst:GetPosition())
	inst.AnimState:PlayAnimation("dig")
	inst.AnimState:PushAnimation("idle")
	for rats,_ in pairs(inst.components.herd.members) do
	inst.components.combat:ShareTarget(worker, 30, function(dude)
		return dude:HasTag("raidrat")
			and not dude.components.health:IsDead()
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

local function EndRaid(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	local players = FindPlayersInRange(x, y, z, 50)
        for i, v in ipairs(players) do
			v.components.talker:Say(GetString(v, "ANNOUNCE_RATRAID_OVER"))
		end
		
	if inst.raiding	then
		x = x + math.random(-200, 200)
		z = z + math.random(-200, 200)
	end
	if TheWorld.Map:IsPassableAtPoint(x, 0, z) then
		inst.Transform:SetPosition(x, 0, z)
	else
		inst:DoTaskInTime(0, EndRaid)
	end
	
	for rats,_ in pairs(inst.components.herd.members) do
		
	end
	
	inst.AnimState:PlayAnimation("spawn")
	inst.AnimState:PushAnimation("idle", true)
	
	inst:RemoveTag("NOBLOCK")
	inst:RemoveTag("NOCLICK")
	inst:RemoveTag("raiding")
	
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
		inst.components.workable:SetWorkLeft(math.random(2, 5))
	end
		
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
		local steps = math.random(3, 5)
		for i = 1, steps do
			local x, y, z = inst.Transform:GetWorldPosition()
			local angle = math.random() * 8 * PI
			local rat = SpawnPrefab("uncompromising_rat")
			rat.Transform:SetPosition(x + math.cos(angle), 0, z + math.sin(angle))
			inst.components.herd:AddMember(rat)
		end
		inst.components.herd:SetUpdateRange(20)
		inst:DoTaskInTime(math.random(30, 60), EndRaid)
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
	
	inst:AddComponent("herd")
	inst.components.herd:SetGatherRange(40)
	inst.components.herd:SetUpdateRange(nil)
	inst.components.herd:SetOnEmptyFn(inst.Remove)
	inst.components.herd.maxsize = 8
	inst.components.herd.nomerging = true
    inst.components.herd.updateposincombat = true
	
	inst:AddComponent("periodicspawner")
	inst.components.periodicspawner:SetRandomTimes(5, 7)
	inst.components.periodicspawner:SetPrefab("uncompromising_rat")
	inst.components.periodicspawner:SetOnSpawnFn(OnSpawned)
	inst.components.periodicspawner:SetDensityInRange(30, 8)
	inst.components.periodicspawner:Start()
	
	inst:AddComponent("combat")
	
	inst:AddComponent("inventory")
	
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
	
	inst:AddTag("herd")
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
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
	inst.components.periodicspawner:SetRandomTimes(5, 7)
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
	Prefab("uncompromising_packrat", packfn, assets, prefabs),
	Prefab("uncompromising_ratherd", fn_herd, assets, prefabs),
	Prefab("uncompromising_ratburrow", fn_burrow, assets, prefabs)