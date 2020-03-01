require "stategraphs/SGsnowmong"
local brain = require "brains/snowmongbrain"
local assets =
{
	Asset("ANIM", "anim/giant_grub.zip")
}

local prefabs =
{
"ice",
"charcoal",
}

local giantgrubsounds =
{
	-- TODO: Put related audio here.
}


local SEE_VICTIM_DIST = 25

--local function IsCompleteDisguise(target)
--   return target:HasTag("has_antmask") and target:HasTag("has_antsuit")
--end

--local function IsPreferedTarget(target)
--	return IsCompleteDisguise(target) or (target.prefab == "antman")
--end

local function SetUnderPhysics(inst)
    if inst.isunder ~= true then
        inst.isunder = true
		inst:AddTag("notdrawable")
		inst:AddTag("INLIMBO")
        inst.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
        inst.Physics:ClearCollisionMask()
        inst.Physics:CollidesWith(COLLISION.WORLD)
        inst.Physics:CollidesWith(COLLISION.OBSTACLES)
    end
end

local function SetAbovePhysics(inst)
    if inst.isunder ~= false then
        inst.isunder = false
		inst:RemoveTag("INLIMBO")
		inst:RemoveTag("notdrawable")
        ChangeToCharacterPhysics(inst)
    end
end

local function SetState(inst, state)
	--"under" or "above"
    inst.State = string.lower(state)
    if inst.State == "under" then
    SetUnderPhysics(inst)
    elseif inst.State == "above" then
    SetAbovePhysics(inst)
    end
end

local function IsState(inst, state)
    return inst.State == string.lower(state)
end

local function CanBeAttacked(inst, attacker)
	return inst.State == "above"
end

local function Retarget(inst)
    local targetDist = 30
    local notags = {"FX", "NOCLICK","INLIMBO", "playerghost", "shadowcreature"}
    return FindEntity(inst, targetDist, 
        function(guy) 
            if inst.components.combat:CanTarget(guy)
               and not (inst.components.follower and inst.components.follower.leader == guy and target.components.health:IsDead())
               and not (inst.components.follower and guy:HasTag("companion")) then
                return not (guy:HasTag("snowish"))
            end
    end, nil, notags)
end

local function KeepTarget(inst, target)
    return inst.components.combat:CanTarget(target)
end

local function OnSleep(inst)
    inst.SoundEmitter:KillAllSounds()
end

local function OnRemove(inst)
    inst.SoundEmitter:KillAllSounds()
end

local function fn(Sim)
	local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    --inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()
    inst.entity:AddLightWatcher()

    --inst.DynamicShadow:SetSize(1, .75)
    inst.Transform:SetFourFaced()

	--shadow:SetSize(1, 0.75)
	inst.Transform:SetFourFaced()
	inst.Transform:SetScale(3, 3, 3)

	MakeCharacterPhysics(inst, 99999, 0.5)
	--MakePoisonableCharacter(inst)

	--MakeSmallBurnableCharacter(inst, "chest")
	--MakeTinyFreezableCharacter(inst, "chest")
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        inst.isunder = nil --this flag is not valid on clients

        return inst
    end

	inst.AnimState:SetBank("giant_grub")
	inst.AnimState:SetBuild("giant_grub")
	inst.AnimState:PlayAnimation("idle", true)

	inst:AddTag("scarytoprey")
    inst:AddTag("monster")
    inst:AddTag("hostile")
    inst:AddTag("snowish")

	inst:AddComponent("locomotor")
	inst.components.locomotor.walkspeed = 2

	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(600)
	inst.components.health.murdersound = "dontstarve/rabbit/scream_short"

	inst:AddComponent("inspectable")
	inst:AddComponent("sleeper")

	inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot({"charcoal", "charcoal", "charcoal", "charcoal", "ice", "ice", "ice", "ice", "ice",})

	inst:AddComponent("knownlocations")
	inst:DoTaskInTime(0, function() inst.components.knownlocations:RememberLocation("home", Point(inst.Transform:GetWorldPosition()), true) end)

    inst:AddComponent("groundpounder")
  	inst.components.groundpounder.destroyer = true
	inst.components.groundpounder.damageRings = 2
	inst.components.groundpounder.destructionRings = 0
	inst.components.groundpounder.numRings = 2

	inst.CanGroundPound = true

	inst:AddComponent("combat")
	inst.components.combat:SetDefaultDamage(44)
	inst.components.combat:SetAttackPeriod(3)
	inst.components.combat:SetRange(5, 5)
	inst.components.combat:SetRetargetFunction(3, Retarget)
	inst.components.combat:SetKeepTargetFunction(KeepTarget)
	inst.components.combat.canbeattackedfn = CanBeAttacked
	inst.components.combat.hiteffectsymbol = "chest"

	inst:SetStateGraph("SGsnowmong")
	inst:SetBrain(brain)
	inst.data = {}

	inst.sounds = giantgrubsounds

	inst.attackUponSurfacing = false
    inst.SetUnderPhysics = SetUnderPhysics
    inst.SetAbovePhysics = SetAbovePhysics

	inst.OnEntitySleep = OnSleep
    inst.OnRemoveEntity = OnRemove
    inst:ListenForEvent("enterlimbo", OnRemove)
	SetState(inst, "under")
    inst.SetState = SetState
    inst.IsState = IsState
	return inst
end

return Prefab("snowmong", fn, assets, prefabs)