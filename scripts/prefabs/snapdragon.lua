require "brains/snapdragonbrain"
require "stategraphs/SGSnapdragon"

local assets=
{
    Asset("ANIM", "anim/snapdragon.zip"),
    Asset("ANIM", "anim/snapdragon_build.zip"),
	Asset("SOUND", "sound/beefalo.fsb"),
}

local prefabs =
{
    "snapdragonherd",
}

SetSharedLootTable( 'snapdragon',
{
    --{'whisperpod',             1.00},
    {'plantmeat',        1.00},
    {'pale_vomit',        3.00},
    {'petals',                 1.00},
})

local sounds = 
{
    walk = "dontstarve/creatures/eyeplant/eye_emerge",
    grunt = "UCSounds/snapdragon/grunt",
    yell = "UCSounds/snapdragon/yell",
    swish = "dontstarve/beefalo/tail_swish",
    curious = "dontstarve/beefalo/curious",
    angry = "UCSounds/snapdragon/angry",
}

local spawns =
{
    carrot_seeds	= 1,
    corn_seeds	= 1,
    asparagus_seeds	= 0.75,
    garlic_seeds	= 0.5,
    onion_seeds	= 0.5,
    pepper_seeds	= 0.5,
    potato_seeds	= 1,
	tomato_seeds	= 1,
}

local RETARGET_MUST_TAGS = { "_combat", "player" }
local RETARGET_CANT_TAGS = { "snapdragon", "wall", "plantkin", "INLIMBO" }

local function Retarget(inst)
    return TheWorld.state.issummer and FindEntity(
                inst,
                TUNING.BEEFALO_TARGET_DIST,
                function(guy)
                    return inst.components.combat:CanTarget(guy)
                end,
                RETARGET_MUST_TAGS, --See entityreplica.lua (re: "_combat" tag)
                RETARGET_CANT_TAGS
            )
        or nil
end

local function KeepTarget(inst, target)
    return inst.components.combat:CanTarget(target) and inst:IsNear(target, 10)
end

local function OnNewTarget(inst, data)
    if inst.components.follower and data and data.target and data.target == inst.components.follower.leader then
        inst.components.follower:SetLeader(nil)
    end
end

local function IsSnapDragon(dude)
    return dude:HasTag("snapdragon")
end

local function OnAttacked(inst, data)
    local attacker = data.attacker
	
	if attacker ~= nil then
		inst.components.combat:SetTarget(attacker)
		inst.components.combat:ShareTarget(attacker, 30, IsSnapDragon, 5)
	end
end

local function OnEat(inst, data)
	if data ~= nil and data:HasTag("pollenmites") then
		inst.SoundEmitter:PlaySound("UCSounds/pollenmite/die")
	end
end

local function GetStatus(inst)
    if inst.components.follower and inst.components.follower.leader ~= nil then
        return "FOLLOWER"
    end
end

local function isnotsnapdragon(ent)
	if ent ~= nil and not ent:HasTag("snapdragon") then -- fix to friendly AOE: refer for later AOE mobs -Axe
		return true
	end
end

local function OnRestoreItemPhysics(item)
    item.Physics:CollidesWith(COLLISION.OBSTACLES)
end

local function LaunchItem(inst, item, angle, minorspeedvariance)
    inst.SoundEmitter:PlaySound("dontstarve/common/farm_harvestable")
	
    local x, y, z = inst.Transform:GetWorldPosition()
    local spd = 1.5 + math.random() * (minorspeedvariance and 1 or 3.5)
    item.Physics:ClearCollisionMask()
    item.Physics:CollidesWith(COLLISION.WORLD)
    item.Physics:CollidesWith(COLLISION.SMALLOBSTACLES)
    item.Physics:Teleport(x, 2.5, z)
    item.Physics:SetVel(math.cos(angle) * spd, 11.5, math.sin(angle) * spd)
    item:DoTaskInTime(.6, OnRestoreItemPhysics)
end

local function ShouldAcceptItem(inst, item)
    return inst.components.eater:CanEat(item)
        and not inst.components.combat:HasTarget()
		and not item:HasTag("snapdragons_cant_eat") and ((item.components.edible.hungervalue ~= nil and item.components.edible.hungervalue > 5) or item:HasTag("insect"))
end

local function OnGetItemFromPlayer(inst, giver, item)
    if inst.components.eater:CanEat(item) then
        inst.components.eater:Eat(item, giver)
        inst.sg:GoToState("eat")

		-- Increase the amount of food in the stomach.
		inst.foodItemsEatenCount = inst.foodItemsEatenCount + 1
		
		local angle = math.random() * 2 * PI
		local delta = 2 * PI / 3 --/ (numgold + numprops + 1) --purposely leave a random gap
		local variance = delta * .4
		inst.sg:GoToState("taunt")

		if inst.foodItemsEatenCount >= 2 then
			
			if not inst.podspawned then
				inst.AnimState:SetMultColour(0.9, 0.8, 0.8, 1)
				inst.podspawned = true
				
				inst.components.timer:StopTimer("podreset")
				inst.components.timer:StartTimer("podreset", 19200)
	
				local item = SpawnPrefab("whisperpod")
				
				LaunchItem(inst, item, GetRandomWithVariance(angle, variance))
			else
				local item = SpawnPrefab("pale_vomit")
					
				LaunchItem(inst, item, GetRandomWithVariance(angle, variance))
			end
			
			inst.foodItemsEatenCount = 0
		end
		
    end
end

local function OnGetItemFromPlayer_Buddy(inst, giver, item)
    if inst.components.eater:CanEat(item) then
        inst.components.eater:Eat(item, giver)
        inst.sg:GoToState("eat")

		-- Increase the amount of food in the stomach.
		inst.foodItemsEatenCount = inst.foodItemsEatenCount + 1
		
		inst.rewarditem = inst.seeds.."_vomit"

		local angle = math.random() * 2 * PI
		local delta = 2 * PI / 3 --/ (numgold + numprops + 1) --purposely leave a random gap
		local variance = delta * .4
		inst.sg:GoToState("taunt")
		
		if inst.foodItemsEatenCount >= 2 then
			local bonusitem = SpawnPrefab(inst.rewarditem)
			LaunchItem(inst, bonusitem, GetRandomWithVariance(angle, variance))
			inst.foodItemsEatenCount = 0
		end
    end
end

local function OnRefuseItem(inst, item)
    inst.sg:GoToState("taunt")
    if inst.components.sleeper:IsAsleep() then
        inst.components.sleeper:WakeUp()
    end
end

local function OnAttackOther(inst, data)
    if data.target ~= nil and data.target.components ~= nil and data.target.components.edible ~= nil and data.target:HasTag("insect") then
        inst.components.eater:Eat(data.target)--, giver)
		inst.sg:GoToState("eat")
    end
end

local function OnSave(inst, data)
	if inst.podspawned ~= nil then
		data.podspawned = inst.podspawned
	end
	
	if inst.seeds ~= nil then
		data.seeds = inst.seeds
	end
end

local function OnLoad(inst, data)
	if data ~= nil and data.podspawned ~= nil then
		inst.podspawned = data.podspawned
	end
	
	if data ~= nil and data.seeds ~= nil then
		inst.seeds = data.seeds
	end
end

local function InitPodSpawned(inst)
	if inst.podspawned ~= nil then
		if inst.podspawned then
			inst.AnimState:SetMultColour(0.9, 0.8, 0.8, 1)
		end
	end
	
	if inst.seeds ~= nil then
		inst.AnimState:SetBuild("snapdragon_build_"..inst.seeds)
	end
end

local function ontimerdone(inst, data)
    if data.name == "podreset" then
		inst.podspawned = false
		inst.AnimState:SetMultColour(1, 1, 1, 1)
    end
    if data.name == "vomit_time" then
        inst.vomit_time = true
    end
end

local function on_buddytimerdone(inst, data)
    if data.name == "vomit_time" then
        inst.vomit_time = true
    end
end

local function OnIsSummer(inst, issummer)
    if issummer then
		if inst.components.eater ~= nil then
			inst.components.eater:SetDiet({ FOODTYPE.INSECT, FOODTYPE.VEGGIE, FOODTYPE.MEAT }, { FOODTYPE.INSECT, FOODTYPE.VEGGIE, FOODTYPE.MEAT })
		end
		inst.AnimState:OverrideSymbol("neck", "snapdragon_build_neck", "neck")
    else
		if inst.components.eater ~= nil then
			inst.components.eater:SetDiet({ FOODTYPE.INSECT, FOODTYPE.VEGGIE }, { FOODTYPE.INSECT, FOODTYPE.VEGGIE })
		end
		inst.AnimState:OverrideSymbol("neck", "snapdragon_build", "neck")
    end
end

local function OnFreeze(inst)
    inst.AnimState:SetBuild("snapdragon_build_frozen")

	if inst.seeds ~= nil then
		inst:DoTaskInTime(0, function(inst) inst.AnimState:OverrideSymbol("hair", "snapdragon_build_"..inst.seeds, "hair") end)
		inst:DoTaskInTime(0, function(inst) inst.AnimState:OverrideSymbol("ear", "snapdragon_build_"..inst.seeds, "ear") end)
		inst:DoTaskInTime(0, function(inst) inst.AnimState:OverrideSymbol("face", "snapdragon_build_"..inst.seeds, "face") end)
		inst:DoTaskInTime(0, function(inst) inst.AnimState:OverrideSymbol("jaw", "snapdragon_build_"..inst.seeds, "jaw") end)
	end
	
	if TheWorld.state.issummer then
		inst:DoTaskInTime(0, function(inst) inst.AnimState:OverrideSymbol("neck", "snapdragon_build_neck", "neck") end)
    else
		inst:DoTaskInTime(0, function(inst) inst.AnimState:OverrideSymbol("neck", "snapdragon_build", "neck") end)
    end
end

local function OnThaw(inst)
	if inst.seeds ~= nil then
		inst:DoTaskInTime(0, function(inst) inst.AnimState:OverrideSymbol("hair", "snapdragon_build_"..inst.seeds, "hair") end)
		inst:DoTaskInTime(0, function(inst) inst.AnimState:OverrideSymbol("ear", "snapdragon_build_"..inst.seeds, "ear") end)
		inst:DoTaskInTime(0, function(inst) inst.AnimState:OverrideSymbol("face", "snapdragon_build_"..inst.seeds, "face") end)
		inst:DoTaskInTime(0, function(inst) inst.AnimState:OverrideSymbol("jaw", "snapdragon_build_"..inst.seeds, "jaw") end)
	end
	
	if TheWorld.state.issummer then
		inst:DoTaskInTime(0, function(inst) inst.AnimState:OverrideSymbol("neck", "snapdragon_build_neck", "neck") end)
    else
		inst:DoTaskInTime(0, function(inst) inst.AnimState:OverrideSymbol("neck", "snapdragon_build", "neck") end)
    end
end

local function OnUnFreeze(inst)
	if inst.seeds ~= nil then
		inst:DoTaskInTime(0, function(inst) inst.AnimState:SetBuild("snapdragon_build_"..inst.seeds) end)
		inst:DoTaskInTime(0, function(inst) inst.AnimState:OverrideSymbol("hair", "snapdragon_build_"..inst.seeds, "hair") end)
		inst:DoTaskInTime(0, function(inst) inst.AnimState:OverrideSymbol("ear", "snapdragon_build_"..inst.seeds, "ear") end)
		inst:DoTaskInTime(0, function(inst) inst.AnimState:OverrideSymbol("face", "snapdragon_build_"..inst.seeds, "face") end)
		inst:DoTaskInTime(0, function(inst) inst.AnimState:OverrideSymbol("jaw", "snapdragon_build_"..inst.seeds, "jaw") end)
	end
	
	if TheWorld.state.issummer then
		inst:DoTaskInTime(0, function(inst) inst.AnimState:OverrideSymbol("neck", "snapdragon_build_neck", "neck") end)
    else
		inst:DoTaskInTime(0, function(inst) inst.AnimState:OverrideSymbol("neck", "snapdragon_build", "neck") end)
    end
end

local function common_fn(scale)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	local sound = inst.entity:AddSoundEmitter()
	inst.sounds = sounds
	local shadow = inst.entity:AddDynamicShadow()
	
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	inst.entity:AddDynamicShadow()
	
	inst.DynamicShadow:SetSize( 6, 2 )
    inst.Transform:SetFourFaced()
    inst.foodItemsEatenCount = 0
    
    MakeCharacterPhysics(inst, 100, 0.2)
	
    inst.Transform:SetScale(scale, scale, scale)
    
    inst:AddTag("snapdragon")

    inst.AnimState:SetBank("snapdragon")
    inst.AnimState:SetBuild("snapdragon_build")
    inst.AnimState:PlayAnimation("idle", true)

    inst:AddTag("animal")
    inst:AddTag("veggie")
    inst:AddTag("largecreature")
    inst:AddTag("trader")
	
    if not TheWorld.ismastersim then
        return inst
    end
	
    inst:AddComponent("eater")
    inst.components.eater:SetDiet({ FOODTYPE.INSECT, FOODTYPE.VEGGIE }, { FOODTYPE.INSECT, FOODTYPE.VEGGIE })
	
    inst:WatchWorldState("issummer", OnIsSummer)
    if TheWorld.state.issummer then
        OnIsSummer(inst, true)
    end
	
    inst.components.eater:SetOnEatFn(OnEat)
    
    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "body"
    inst.components.combat:SetDefaultDamage(26 * scale)
    inst.components.combat:SetRetargetFunction(1, Retarget)
    inst.components.combat:SetKeepTargetFunction(KeepTarget)

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.BEEFALO_HEALTH)
    
    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = GetStatus
    
    inst:AddComponent("knownlocations")
	
    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable('snapdragon')
	
    inst:AddComponent("locomotor")
    
    inst:AddComponent("leader")
	
    inst:ListenForEvent("newcombattarget", OnNewTarget)
    inst:ListenForEvent("attacked", OnAttacked)
	inst:ListenForEvent("onattackother", OnAttackOther)

    MakeLargeBurnableCharacter(inst, "body")
    MakeLargeFreezableCharacter(inst, "body")
	
    inst:ListenForEvent("freeze", OnFreeze)
    inst:ListenForEvent("onthaw", OnThaw)
    inst:ListenForEvent("unfreeze", OnUnFreeze)
    
    inst:AddComponent("sleeper")
    inst.components.sleeper:SetResistance(3)
    
    local brain = require "brains/snapdragonbrain"
    inst:SetBrain(brain)
    inst:SetStateGraph("SGSnapdragon")
	
	inst.podspawned = nil
	
	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
	
	inst:DoTaskInTime(0, InitPodSpawned)
	
    return inst
end

local function prime_fn()
    local inst = common_fn(1.33)

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("herdmember")
    inst.components.herdmember:SetHerdPrefab("snapdragonherd")

	inst:AddComponent("trader")
    inst.components.trader:SetAcceptTest(ShouldAcceptItem)
    inst.components.trader.onaccept = OnGetItemFromPlayer
    inst.components.trader.onrefuse = OnRefuseItem
    inst.components.trader.deleteitemonaccept = true
	
    inst:AddComponent("timer")
	inst.components.timer:StartTimer("vomit_time", 480)
    inst:ListenForEvent("timerdone", ontimerdone)
	
    inst.components.locomotor.walkspeed = 3
    inst.components.locomotor:SetTriggersCreep(false)
	
	
	inst:AddComponent("playerprox")
	inst.components.playerprox:SetDist(10,11)
	inst.components.playerprox:SetOnPlayerNear(function(inst)
		if inst.vomit_time ~= nil and inst.vomit_time then
			
		inst.rewarditem = "pale_vomit"

			local angle = math.random() * 2 * PI
			local delta = 2 * PI / 3 --/ (numgold + numprops + 1) --purposely leave a random gap
			local variance = delta * .4
			inst.sg:GoToState("taunt")
			
			local bonusitem = SpawnPrefab(inst.rewarditem)
			LaunchItem(inst, bonusitem, GetRandomWithVariance(angle, variance))
		end
	end)

    return inst
end

local function Rename(inst)
    inst.components.named:SetName(STRINGS.NAMES["SNAPDRAGON_BUDDY_"..inst.seeds]) 
end

local function buddy_fn()
    local inst = common_fn(1)

    if not TheWorld.ismastersim then
        return inst
    end
	
	if inst.seeds == nil then
		inst.seeds = "pale"
	end
	
    inst:AddComponent("named")
	inst:DoTaskInTime(0, Rename)
	
    inst:AddComponent("follower")
    inst.components.follower.canaccepttarget = false

	inst.components.lootdropper:AddChanceLoot((inst.seeds.."_vomit"), 1)
	
	inst:AddComponent("trader")
    inst.components.trader:SetAcceptTest(ShouldAcceptItem)
    inst.components.trader.onaccept = OnGetItemFromPlayer_Buddy
    inst.components.trader.onrefuse = OnRefuseItem
    inst.components.trader.deleteitemonaccept = true
	
    inst.components.locomotor.walkspeed = 2.77
    inst.components.locomotor:SetTriggersCreep(false)
	
	inst:AddComponent("playerprox")
	inst.components.playerprox:SetDist(10,11)
	inst.components.playerprox:SetOnPlayerNear(function(inst)
		if inst.vomit_time ~= nil and inst.vomit_time then
			
		inst.rewarditem = inst.seeds.."_vomit"

			local angle = math.random() * 2 * PI
			local delta = 2 * PI / 3 --/ (numgold + numprops + 1) --purposely leave a random gap
			local variance = delta * .4
			inst.sg:GoToState("taunt")
			
			local bonusitem = SpawnPrefab(inst.rewarditem)
			LaunchItem(inst, bonusitem, GetRandomWithVariance(angle, variance))
		end
	end)
	
	inst:AddComponent("timer")
	inst.components.timer:StartTimer("vomit_time", 480)
    inst:ListenForEvent("timerdone", on_buddytimerdone)

    return inst
end

return Prefab( "snapdragon", prime_fn, assets, prefabs),
		Prefab( "snapdragon_buddy", buddy_fn, assets, prefabs) 
