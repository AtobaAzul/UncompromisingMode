local MAX_TARGET_SHARES = 5
local SHARE_TARGET_DIST = 30


local function ontalk(inst, script)
    inst.SoundEmitter:PlaySound("dontstarve/pig/grunt")
end

local function ShouldAcceptItem(inst, item)
    if item.components.edible ~= nil then
        local foodtype = item.components.edible.foodtype
		if item:HasTag("halloweencandy") or foodtype == FOODTYPE.GOODIE then
			return true
		end
    end
end

local function OnGetItemFromPlayer(inst, giver, item)
	if item.prefab == "taffy" or item.prefab == "pumpkincookie" then
		inst.Satisfaction = inst.Satisfaction + 5
	else
		inst.Satisfaction = inst.Satisfaction + 1
	end
	if inst.favorite == item.prefab then
		inst.Satisfaction = inst.Satisfaction + 10
	end
	RollSatisfaction(inst)
end

local function OnRefuseItem(inst, item)
    inst.sg:GoToState("refuse")
    if inst.components.sleeper:IsAsleep() then
        inst.components.sleeper:WakeUp()
    end
end

local SUGGESTTARGET_MUST_TAGS = { "_combat", "_health", "pig" }
local SUGGESTTARGET_CANT_TAGS = { "werepig", "guard", "INLIMBO" }

local function IsPig(dude)
    return dude:HasTag("pig")
end

local function IsNonWerePig(dude)
    return dude:HasTag("pig") and not dude:HasTag("werepig")
end

local function OnAttacked(inst, data)
    --print(inst, "OnAttacked")
    local attacker = data.attacker
    inst:ClearBufferedAction()

	if attacker ~= nil then
			if not (attacker:HasTag("pig") and attacker:HasTag("guard")) then
				inst.components.combat:ShareTarget(attacker, SHARE_TARGET_DIST, IsNonWerePig, MAX_TARGET_SHARES)
			end
	end
--Delete Myself and Spawn a Werepig Instead

--Delete Myself and Spawn a Werepig Instead
end


local builds = { "pig_build", "pigspotted_build" }

local trickbrain = require "brains/tricktreatpigbrain"

local function SetNormalPig(inst)
    inst:RemoveTag("werepig")
    inst:RemoveTag("guard")
    inst:SetBrain(trickbrain)
    inst:SetStateGraph("SGpig")
    inst.AnimState:SetBuild(inst.build)

    inst.components.locomotor.runspeed = TUNING.PIG_RUN_SPEED
    inst.components.locomotor.walkspeed = TUNING.PIG_WALK_SPEED

    inst.components.health:SetMaxHealth(100000)
    inst.components.trader:Enable()
end

local function GetStatus(inst)
    return (inst:HasTag("werepig") and "WEREPIG")
        or (inst:HasTag("guard") and "GUARD")
        or (inst.components.follower.leader ~= nil and "FOLLOWER")
        or nil
end

local function displaynamefn(inst)
    return inst.name
end

local function OnSave(inst, data)
    data.build = inst.build
end

local function OnLoad(inst, data)
    if data ~= nil then
        inst.build = data.build or builds[1]
    end
end

local function common()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
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

    if IsSpecialEventActive(SPECIAL_EVENTS.YOTB) then
        inst.AnimState:AddOverrideBuild("pigman_yotb")
    end

    --Sneak these into pristine state for optimization
    inst:AddTag("_named")

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

    ------------------------------------------

    inst:AddComponent("inventory")


    ------------------------------------------

    inst:AddComponent("knownlocations")


    inst:AddComponent("trader")
    inst.components.trader:SetAcceptTest(ShouldAcceptItem)
    inst.components.trader.onaccept = OnGetItemFromPlayer
    inst.components.trader.onrefuse = OnRefuseItem
    inst.components.trader.deleteitemonaccept = true

    ------------------------------------------
    MakeMediumFreezableCharacter(inst, "pig_torso")

    ------------------------------------------

    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = GetStatus
    ------------------------------------------

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad
    inst.Satisfaction = 0
	
	inst.favorite = "poop" --nonfunctional
	
	
    inst:ListenForEvent("attacked", OnAttacked)

    return inst
end

local function normal()
    local inst = common(false)

    if not TheWorld.ismastersim then
        return inst
    end

    -- boat hopping setup
    inst.components.locomotor:SetAllowPlatformHopping(true)
    inst:AddComponent("embarker")
    inst:AddComponent("drownable")

    inst.build = builds[math.random(#builds)]
    inst.AnimState:SetBuild(inst.build)
    SetNormalPig(inst)

	inst:DoTaskInTime(0, SetupPigToken)
    return inst
end

return Prefab("tricktreatpigman", normal)