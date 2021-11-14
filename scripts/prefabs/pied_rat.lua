local assets =
{
	Asset("ANIM", "anim/pied_piper.zip"),
	Asset("ANIM", "anim/rat_note.zip"),
	
}
local brain = require "brains/pied_ratbrain"

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

local RETARGET_CANT_TAGS = { "wall", "raidrat"}
local function rattargetfn(inst)
    return FindEntity(
                inst, 15,
                function(guy)
					inst.components.combat:CanTarget(guy)
                end,
                nil,
                RETARGET_CANT_TAGS
            )
        or nil
end

local TARGETS_MUST_TAGS = {"player"}
local TARGETS_CANT_TAGS = {"playerghost"}
local function NumHoundsToSpawn(inst)
    local numHounds = TUNING.WARG_BASE_HOUND_AMOUNT

    local pt = Vector3(inst.Transform:GetWorldPosition())
    local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, TUNING.WARG_NEARBY_PLAYERS_DIST, TARGETS_MUST_TAGS, TARGETS_CANT_TAGS)
    for i,player in ipairs(ents) do
        local playerAge = player.components.age:GetAgeInDays()
        local addHounds = math.clamp(Lerp(1, 4, playerAge/100), 1, 4)
        numHounds = numHounds + addHounds
    end
    local numFollowers = inst.components.leader:CountFollowers()
    local num = math.min(numFollowers+numHounds/2, numHounds) -- only spawn half the hounds per howl
    num = (math.log(num)/0.4)+1 -- 0.4 is approx log(1.5)

    num = RoundToNearest(num, 1)

    return num - numFollowers
end

local function fn()
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

    inst.AnimState:SetBank("pied_piper")
    inst.AnimState:SetBuild("pied_piper")
    inst.AnimState:PlayAnimation("idle")

	inst:AddTag("raidrat")
	inst:AddTag("animal")
	inst:AddTag("hostile")
	inst:AddTag("herdmember")
	--inst:AddTag("smallcreature")

    --trader (from trader component) added to pristine state for optimization
    --inst:AddTag("trader") If you want to trade <--

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("leader")

    -- locomotor must be constructed before the stategraph!
    inst:AddComponent("locomotor")
	inst.components.locomotor:EnableGroundSpeedMultiplier(false)
	inst.components.locomotor:SetTriggersCreep(false)

    inst:SetStateGraph("SGpied_rat")

    inst:AddComponent("lootdropper")	--must be initialized so it doesn't crash


    ---------------------        
    MakeMediumBurnableCharacter(inst, "body")
    MakeMediumFreezableCharacter(inst, "body")
    inst.components.burnable.flammability = TUNING.SPIDER_FLAMMABILITY
    ---------------------       

    inst:AddComponent("health")
	inst.components.health:SetMaxHealth(300)
	
    inst:AddComponent("combat")
	inst.components.combat:SetDefaultDamage(30)
	inst.components.combat:SetAttackPeriod(5)
	inst.components.combat:SetRange(12)
	inst.components.combat.hiteffectsymbol = "body"
	inst.components.combat:SetRetargetFunction(3, rattargetfn)
	
	inst:ListenForEvent("attacked", OnAttacked)
	
	inst:AddComponent("knownlocations")
	
	inst.NumHoundsToSpawn = NumHoundsToSpawn


    inst:AddComponent("inspectable")

    ------------------

    MakeHauntablePanic(inst)

    inst:SetBrain(brain)


    return inst
end

local function changeanim(inst)
    inst.AnimState:PlayAnimation("loop"..math.random(4), true)
end

local function notefn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")

    inst.AnimState:SetBank("rat_note")
    inst.AnimState:SetBuild("rat_note")
    inst.AnimState:PlayAnimation("loop"..math.random(4), true)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:ListenForEvent("animover", changeanim)

    inst.persists = false

    return inst
end


return Prefab("pied_rat", fn, assets),
		Prefab("rat_note", notefn, assets)
