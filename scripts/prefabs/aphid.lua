require "stategraphs/SGaphid"

local assets =
{
    Asset("ANIM", "anim/aphid.zip"),
}

local prefabs =
{
    --"weevole_carapace",
    "monstersmallmeat",
}
if TUNING.DSTU.MONSTERSMALLMEAT then
    SetSharedLootTable("aphid_loot",
        {
            --{'weevole_carapace', 1},
            { 'monstersmallmeat', 0.25 },
            { 'steelwool', 0.25 },
        })
else
    SetSharedLootTable("aphid_loot",
        {
            --{'weevole_carapace', 1},
            { 'monstermeat', 0.25 },
            { 'steelwool', 0.25 },
        })
end

local brain = require "brains/aphidbrain"

local function OnDropped(inst)
    inst.sg:GoToState("idle")
    if inst.components.workable ~= nil then
        inst.components.workable:SetWorkLeft(1)
    end
    if inst.components.stackable ~= nil then
        while inst.components.stackable:StackSize() > 1 do
            local item = inst.components.stackable:Get()
            if item ~= nil then
                if item.components.inventoryitem ~= nil then
                    item.components.inventoryitem:OnDropped()
                end
                item.Physics:Teleport(inst.Transform:GetWorldPosition())
            end
        end
    end
end

local function retargetfn(inst)
    local dist = 8
    local notags = { "FX", "NOCLICK", "INLIMBO", "wall", "aphid", "structure", "aquatic", "smallcreature" }
    return FindEntity(inst, dist, function(guy)
        return inst.components.combat:CanTarget(guy)
    end, nil, notags)
end

local function keeptargetfn(inst, target)
    return target ~= nil
        and target.components.combat ~= nil
        and target.components.health ~= nil
        and not target.components.health:IsDead()
end

local function OnAttacked(inst, data)
    inst.components.combat:SetTarget(data.attacker)
    inst.components.combat:ShareTarget(data.attacker, 30,
        function(dude)
            return dude:HasTag("aphid")
                and not dude.components.health:IsDead()
        end, 10)
end

local function OnFlyIn(inst)
    inst.DynamicShadow:Enable(false)
    inst.components.health:SetInvincible(true)
    local x, y, z = inst.Transform:GetWorldPosition()
    inst.Transform:SetPosition(x, 15, z)
end

local function OnWorked(inst, worker)
    if worker.components.inventory ~= nil then
        inst.SoundEmitter:KillAllSounds()

        worker.components.inventory:GiveItem(inst, nil, inst:GetPosition())
    end
end



local function TryToInfestTree(inst)
    if inst.components.combat ~= nil then
        if not inst.components.combat.target then
            if math.random() > 0.95 or inst:HasTag("fromthebush") then
                local tree = FindEntity(inst, 30,
                function(tree) return not tree:HasTag("infestedtree") and tree:HasTag("giant_tree") end)
                if tree ~= nil then
                    if inst.brain ~= nil then
                        inst.brain:Stop()
                    end
                    inst.sg:GoToState("flyintree")
                    if tree.components.timer ~= nil then
                        tree.components.timer:StartTimer("infest", 1600)
                    end
                end
            end
        end
    end
end

local function FindNymph(inst)
	if not inst.nymph then
		local nymph = FindEntity(inst,20^2,nil,{"nymph"})
		if nymph then
			inst.components.follower:SetLeader(nymph)
			inst.Transform:SetPosition(inst.Transform:GetWorldPosition())
			if not nymph.posse then
				nymph.posse = {}
			end
			table.insert(nymph.posse,inst)
		else
			inst:Remove()
		end
	end
end

local function HomeCheck(inst) -- Backup, though would not advice using it, since if you spawn via console, they'll get removed, ones spawned from giant trees will also be removed.
	local excuse_to_live = false -- Why should I let you live, aphid?
	if inst.components.homeseeker and inst.components.homeseeker.home then
		excuse_to_live = true
	end
	if inst.components.follower and inst.components.follower.leader then
		excuse_to_live = true
	end
	if excuse_to_live == false then
		inst:Remove()
	end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()
    MakeCharacterPhysics(inst, 10, .5)
    inst.DynamicShadow:SetSize(1.5, .5)
    inst.Transform:SetSixFaced()

    inst.AnimState:SetBank("weevole")
    inst.AnimState:SetBuild("aphid")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("scarytoprey")
    inst:AddTag("monster")
    inst:AddTag("insect")
    inst:AddTag("hostile")
    inst:AddTag("canbetrapped")
    inst:AddTag("smallcreature")
    inst:AddTag("aphid")
    inst:AddTag("animal")
    inst:AddTag("soulless")
    inst:AddTag("noember")

    MakeInventoryFloatable(inst)

    MakeFeedableSmallLivestockPristine(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    -- locomotor must be constructed before the stategraph!
    inst:AddComponent("locomotor")
    inst.components.locomotor:SetSlowMultiplier(1)
    inst.components.locomotor:SetTriggersCreep(false)
    inst.components.locomotor.pathcaps = { ignorecreep = true }
    inst.components.locomotor.walkspeed = 3

    inst:AddComponent("inventory")

    inst:AddComponent("stackable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.canbepickedup = false
    inst.components.inventoryitem.canbepickedupalive = true
    inst.components.inventoryitem.nobounce = true
    inst.components.inventoryitem.pushlandedevents = false

    inst.components.inventoryitem.atlasname = "images/inventoryimages/aphid.xml"


	inst.NymphGroundCheck = function(inst)	
		--TheNet:Announce("checking")
		if inst.nymph and inst.nymph:IsValid() and inst.nymph.components.health and not inst.nymph.components.health:IsDead() then
			local x,y,z = inst.nymph.Transform:GetWorldPosition()
			if not TheWorld.Map:IsAboveGroundAtPoint(x,y,z) then
				inst.nymph.aphidpossedigging = true
				inst.sg:GoToState("flyintree")
			end
		else
			--TheNet:Announce("trying")
			if not (inst.components.combat and inst.components.combat.target) then
				inst.sg:GoToState("burrow")
			end
		end
	end,

--[[ --If we seek out making aphids fly over water, do this route.
    if TheWorld ~= nil then
        inst:AddComponent("embarker")
        inst.components.embarker.embark_speed = inst.components.locomotor.walkspeed
        inst.components.embarker.antic = true

        inst.components.locomotor:SetAllowPlatformHopping(true)
        inst:AddComponent("amphibiouscreature")
        inst.components.amphibiouscreature:SetBanks("carrat", "uncompromising_rat_water")
        inst.components.amphibiouscreature:SetEnterWaterFn(function(inst)
            inst.AnimState:SetBuild("uncompromising_rat_water")
            inst.landspeed = inst.components.locomotor.runspeed
            inst.components.locomotor.runspeed = TUNING.HOUND_SWIM_SPEED
            inst.hop_distance = inst.components.locomotor.hop_distance
            inst.components.locomotor.hop_distance = 4
        end)
        inst.components.amphibiouscreature:SetExitWaterFn(function(inst)
            inst.AnimState:SetBuild("uncompromising_rat")
            if inst.landspeed then inst.components.locomotor.runspeed = inst.landspeed end
            if inst.hop_distance then inst.components.locomotor.hop_distance = inst.hop_distance end
        end)
        -------------------------

        inst.components.locomotor.pathcaps = {allowocean = true}
    end
]]

    inst:AddComponent("tradable")

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable("aphid_loot")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.NET)
    inst.components.workable:SetWorkLeft(1)
    inst.components.workable:SetOnFinishCallback(OnWorked)

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(100)

    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "body"
    inst.components.combat:SetKeepTargetFunction(keeptargetfn)
    inst.components.combat:SetRetargetFunction(3, retargetfn)
    inst.components.combat:SetDefaultDamage(20)
    inst.components.combat:SetAttackPeriod(GetRandomMinMax(1, 3))
    inst.components.combat:SetRange(5, 2)
	inst:AddComponent("follower")
    inst:AddComponent("knownlocations")
    inst:AddComponent("inspectable")

    inst:ListenForEvent("attacked", OnAttacked)

    inst:AddComponent("eater")
    --inst.components.eater:SetDiet({ FOODGROUP.OMNI }, { FOODGROUP.OMNI })
    inst.components.eater:SetDiet({ FOODGROUP.OMNI, FOODTYPE.WOOD, FOODTYPE.SEEDS, FOODTYPE.ROUGHAGE },
    { FOODGROUP.OMNI, FOODTYPE.WOOD, FOODTYPE.SEEDS, FOODTYPE.ROUGHAGE })
    --inst:DoPeriodicTask(4 + 4 * math.random(), TryToInfestTree) --Deprecated, poor performance
    --inst.OnEntitySleep = OnEntitySleep
    --inst.OnEntityWake = OnEntityWake

    --inst.FindNewHomeFn = FindNewHome

    inst:SetStateGraph("SGaphid")
    inst:SetBrain(brain)

    MakeFeedableSmallLivestock(inst, TUNING.BUTTERFLY_PERISH_TIME, nil, OnDropped)

    MakeSmallBurnableCharacter(inst, "body")
    MakeSmallFreezableCharacter(inst, "body")

    inst:ListenForEvent("fly_in", OnFlyIn) -- matches enter_loop logic so it does not happen a frame late
	--inst:DoTaskInTime(0,HomeCheck) --Backup Aphid Extermination....

    return inst
end

return Prefab("aphid", fn, assets, prefabs)
