local brain = require("brains/crittersbrain")

local WAKE_TO_FOLLOW_DISTANCE = 6
local SLEEP_NEAR_LEADER_DISTANCE = 5

local HUNGRY_PERISH_PERCENT = 0.5 -- matches stale tag
local STARVING_PERISH_PERCENT = 0.2 -- matches spoiked tag

local function IsLeaderSleeping(inst)
    return inst.components.follower.leader and inst.components.follower.leader:HasTag("sleeping")
end

local function ShouldWakeUp(inst)
    return (DefaultWakeTest(inst) and not IsLeaderSleeping(inst)) or not inst.components.follower:IsNearLeader(WAKE_TO_FOLLOW_DISTANCE)
end

local function ShouldSleep(inst)
    return (DefaultSleepTest(inst)
            or IsLeaderSleeping(inst))
            and inst.components.follower:IsNearLeader(SLEEP_NEAR_LEADER_DISTANCE)
end

local function oneat(inst, food)

	-- minigame around feeding, if fed at the right time, its max hunger goes up, if left too long, its max hunger goes down
	local perish = inst.components.perishable:GetPercent()
	local is_wellfed = inst.components.crittertraits:IsDominantTrait("wellfed")
	if perish <= STARVING_PERISH_PERCENT then
		inst.components.perishable.perishtime = math.max(inst.components.perishable.perishtime - TUNING.CRITTER_HUNGERTIME_DELTA, is_wellfed and TUNING.CRITTER_DOMINANTTRAIT_HUNGERTIME_MIN or TUNING.CRITTER_HUNGERTIME_MIN)
	elseif perish <= HUNGRY_PERISH_PERCENT then
		inst.components.perishable.perishtime = math.min(inst.components.perishable.perishtime + TUNING.CRITTER_HUNGERTIME_DELTA, is_wellfed and TUNING.CRITTER_DOMINANTTRAIT_HUNGERTIME_MAX or TUNING.CRITTER_HUNGERTIME_MAX)
	else
		if is_wellfed and inst.components.perishable.perishtime < TUNING.CRITTER_DOMINANTTRAIT_HUNGERTIME_MIN then
			inst.components.perishable.perishtime = TUNING.CRITTER_DOMINANTTRAIT_HUNGERTIME_MIN
		end
	end

    inst.components.perishable:SetPercent(1)
    inst.components.perishable:StartPerishing()
end

-------------------------------------------------------------------------------
local function GetPeepChance(inst)
    local hunger_percent = inst.components.perishable:GetPercent()
    if hunger_percent <= 0 then
        return 0.8
    elseif hunger_percent < STARVING_PERISH_PERCENT then -- matches spoiled tag
        return (0.2 - inst.components.perishable:GetPercent()) * 2
    elseif hunger_percent < HUNGRY_PERISH_PERCENT then
        return 0.025
    end

    return 0
end

local function IsAffectionate(inst)
    return (inst.components.perishable == nil or inst.components.perishable:GetPercent() > STARVING_PERISH_PERCENT)
            or false
end

local function IsPlayful(inst)
	return IsAffectionate(inst)
end

local function IsSuperCute(inst)
	return true
end

-------------------------------------------------------------------------------

local function OnSave(inst, data)
    if inst.wormlight ~= nil then
        data.wormlight = inst.wormlight:GetSaveRecord()
    end
end

local function OnLoad(inst, data)
    if data ~= nil and data.wormlight ~= nil and inst.wormlight == nil then
        local wormlight = SpawnSaveRecord(data.wormlight)
        if wormlight ~= nil and wormlight.components.spell ~= nil then
            wormlight.components.spell:SetTarget(inst)
            if wormlight:IsValid() then
                if wormlight.components.spell.target == nil then
                    wormlight:Remove()
                else
                    wormlight.components.spell:ResumeSpell()
                end
            end
        end
    end
end

local function OnLoadPostPass(inst)
	if inst._special_powers ~= nil then
		inst:PushEvent("perishchange", {percent = inst.components.perishable:GetPercent()}) -- to init special powers
	end
end


-------------------------------------------------------------------------------

local function MakeCritter(name, animname, face, diet, flying, data, prefabs)
    local assets =
    {
        Asset("ANIM", "anim/figgy_newton.zip"),
    }

    if data.allow_platform_hopping then
        table.insert(assets, Asset("ANIM", "anim/kittington_jump.zip"))
    end

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddDynamicShadow()
        inst.entity:AddNetwork()

        inst.DynamicShadow:SetSize(1, .33)

        if face == 2 then
            inst.Transform:SetTwoFaced()
        elseif face == 4 then
            inst.Transform:SetFourFaced()
        elseif face == 6 then
            inst.Transform:SetSixFaced()
        elseif face == 8 then
            inst.Transform:SetEightFaced()
        end

        inst.AnimState:SetBank("kitcoon")
        inst.AnimState:SetBuild("figgy_newton")
        inst.AnimState:PlayAnimation("idle_loop")

        if flying then
            --We want to collide with players
            --MakeFlyingCharacterPhysics(inst, 1, .5)
            inst.entity:AddPhysics()
            inst.Physics:SetMass(1)
            inst.Physics:SetFriction(0)
            inst.Physics:SetDamping(5)
            inst.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
            inst.Physics:ClearCollisionMask()
            inst.Physics:CollidesWith((TheWorld.has_ocean and COLLISION.GROUND) or COLLISION.WORLD)
            inst.Physics:CollidesWith(COLLISION.FLYERS)
            inst.Physics:CollidesWith(COLLISION.CHARACTERS)
            inst.Physics:SetCapsule(.5, 1)

            inst:AddTag("flying")
            inst:AddTag("ignorewalkableplatformdrowning")

            MakeInventoryFloatable(inst)
        else
            MakeCharacterPhysics(inst, 1, .5)
        end

		inst.Physics:SetDontRemoveOnSleep(true) -- critters dont really go do entitysleep as it triggers a teleport to near the owner, so no point in hitting the physics engine.

        inst:AddTag("critter")
        inst:AddTag("companion")
        inst:AddTag("notraptrigger")
        inst:AddTag("noauradamage")
        inst:AddTag("small_livestock")
        inst:AddTag("NOBLOCK")

        if data ~= nil and data.flyingsoundloop ~= nil then
            inst.SoundEmitter:PlaySound(data.flyingsoundloop, "flying")
        end

        inst:AddComponent("spawnfader")

		if data ~= nil and data.common_postinit ~= nil then
			data.common_postinit(inst)
		end

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

		inst.favoritefood = data.favoritefood

        inst.GetPeepChance = GetPeepChance
        inst.IsAffectionate = IsAffectionate
        inst.IsSuperCute = IsSuperCute
        inst.IsPlayful = IsPlayful

		inst.playmatetags = {"critter"}
		if data ~= nil and data.playmatetags ~= nil then
			inst.playmatetags = JoinArrays(inst.playmatetags, data.playmatetags)
		end

        inst:AddComponent("inspectable")

        inst:AddComponent("follower")
        inst.components.follower:KeepLeaderOnAttacked()
        inst.components.follower.keepdeadleader = true
        inst.components.follower.keepleaderduringminigame = true

        inst:AddComponent("knownlocations")

        inst:AddComponent("sleeper")
        inst.components.sleeper:SetResistance(3)
        inst.components.sleeper.testperiod = GetRandomWithVariance(6, 2)
        inst.components.sleeper:SetSleepTest(ShouldSleep)
        inst.components.sleeper:SetWakeTest(ShouldWakeUp)

        inst:AddComponent("eater")
        inst.components.eater:SetDiet(diet, diet)
        inst.components.eater:SetOnEatFn(oneat)

        inst:AddComponent("perishable")
        inst.components.perishable:SetPerishTime(TUNING.CRITTER_HUNGERTIME)
        inst.components.perishable:StartPerishing()

        inst:AddComponent("locomotor")
        inst.components.locomotor:EnableGroundSpeedMultiplier(not flying)
        inst.components.locomotor:SetTriggersCreep(false)
        inst.components.locomotor.softstop = true
        inst.components.locomotor.walkspeed = TUNING.CRITTER_WALK_SPEED
        if flying then
            -- Flying creatures can pathfind over the ocean/rivers
            inst.components.locomotor.pathcaps = { allowocean = true }
        end

        if data ~= nil and data.allow_platform_hopping then
            inst.components.locomotor:SetAllowPlatformHopping(true)

            inst:AddComponent("embarker")
            inst.components.embarker.embark_speed = inst.components.locomotor.walkspeed
		    inst:AddComponent("drownable")
        end

        inst:AddComponent("crittertraits")
        inst:AddComponent("timer")

        inst:SetBrain(brain)
        inst:SetStateGraph("SG"..name)

		if data ~= nil and data.special_powers_fn ~= nil then
			inst._special_powers = {}
			inst:ListenForEvent("perishchange", data.special_powers_fn)
			if not POPULATING then
				inst:PushEvent("perishchange", {percent = inst.components.perishable:GetPercent()}) -- to init special powers
			end
		end

		if data ~= nil and data.master_postinit ~= nil then
			data.master_postinit(inst, data)
		end

        inst.OnSave = OnSave
        inst.OnLoad = OnLoad
		inst.OnLoadPostPass = OnLoadPostPass

        return inst
    end

    return Prefab(name, fn, assets, prefabs)
end

-------------------------------------------------------------------------------
local function builder_onbuilt(inst, builder)
    local theta = math.random() * 2 * PI
    local pt = builder:GetPosition()
    local radius = 1
    local offset = FindWalkableOffset(pt, theta, radius, 6, true)
    if offset ~= nil then
        pt.x = pt.x + offset.x
        pt.z = pt.z + offset.z
    end
    builder.components.petleash:SpawnPetAt(pt.x, 0, pt.z, inst.pettype, inst.linked_skinname)
    inst:Remove()
end

local function MakeBuilder(prefab)
    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()

        inst:AddTag("CLASSIFIED")

        --[[Non-networked entity]]
        inst.persists = false

        --Auto-remove if not spawned by builder
        inst:DoTaskInTime(0, inst.Remove)

        if not TheWorld.ismastersim then
            return inst
        end

        inst.pettype = prefab
        inst.OnBuiltFn = builder_onbuilt

        return inst
    end

    return Prefab(prefab.."_builder", fn, nil, { prefab })
end

-------------------------------------------------------------------------------
local standard_diet = { FOODGROUP.OMNI }

return MakeCritter("critter_figgy", "sheepington", 6, standard_diet, false, {favoritefood="guacamole", allow_platform_hopping=true}),
       MakeBuilder("critter_figgy")