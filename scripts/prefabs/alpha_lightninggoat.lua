local assets =
{
    Asset("ANIM", "anim/lightning_goat_build.zip"),
    Asset("ANIM", "anim/lightning_goat_shocked_build.zip"),
    Asset("ANIM", "anim/lightning_goat_basic.zip"),
    Asset("ANIM", "anim/lightning_goat_actions.zip"),
    Asset("SOUND", "sound/lightninggoat.fsb"),
}

local prefabs =
{
    "meat",
    "lightninggoathorn",
    "goatmilk",
    "lightninggoatherd",
}

local brain = require("brains/alpha_lightninggoatbrain")

SetSharedLootTable( 'alpha_lightninggoat',
{
    {'meat',              1.00},
    {'meat',              1.00},
    {'meat',              1.00},
    {'goatmilk',          1.00},
    {'lightninggoathorn', 1.00},
})

local RETARGET_MUST_TAGS = { "_combat" }
local RETARGET_CANT_TAGS = { "lightninggoat", "wall" }
local RETARGET_WALL_MUST_TAGS = { "_combat", "wall" }
local RETARGET_WALL_CANT_TAGS = { "lightninggoat" }
local function RetargetFn(inst)
    if inst.charged or inst.pissed_count >= 2 then
        local function CheckTarget(guy)
            return inst.components.combat:CanTarget(guy)
        end
        return
            -- Look for non-wall targets first
            FindEntity(
                inst,
                TUNING.LIGHTNING_GOAT_TARGET_DIST,
                CheckTarget,
                RETARGET_MUST_TAGS,
                RETARGET_CANT_TAGS)
            or
            -- If none, look for walls
            FindEntity(
                inst,
                TUNING.LIGHTNING_GOAT_TARGET_DIST,
                CheckTarget,
                RETARGET_WALL_MUST_TAGS,
                RETARGET_WALL_CANT_TAGS)
            or
            nil
    end
end

local function KeepTargetFn(inst, target)
    if target:HasTag("wall") then
        --Don't keep wall target if a non-wall target is available
        return
            FindEntity(
                inst,
                TUNING.LIGHTNING_GOAT_TARGET_DIST,
                function(guy)
                    return inst.components.combat:CanTarget(guy)
                end,
                RETARGET_MUST_TAGS,
                RETARGET_CANT_TAGS) == nil
    end
    --Don't keep target if we chased too far from our herd
    local herd = inst.components.herdmember ~= nil and inst.components.herdmember:GetHerd() or nil
    return herd == nil or inst:IsNear(herd, TUNING.LIGHTNING_GOAT_CHASE_DIST)
end

local function setcharged(inst, instant)
	local x, y, z = inst.Transform:GetWorldPosition()
    inst:AddTag("charged")
	local shocktime = 1
	
    if not instant then
        inst.sg:GoToState("shocked")
	else
		shocktime = .2
    end
	
	inst:DoTaskInTime(shocktime, function(inst)
		local lightning = SpawnPrefab("hound_lightning")
		for i = 1, 5 do 
			lightning.Transform:SetPosition(x + math.random(-6, 6), 0, z + math.random(-6, 6))
			lightning.NoTags = { "INLIMBO", "shadow", "structure", "wall", "lightninggoat" }
		end
	end)
end

local function IsChargedGoat(dude)
    return dude:HasTag("lightninggoat") and (dude:HasTag("charged") or dude:HasTag("alpha_goat"))
end

local function OnAttacked(inst, data)
    if data ~= nil and data.attacker ~= nil then
        if inst.charged then
            if data.attacker.components.health ~= nil and not data.attacker.components.health:IsDead() and
                (data.weapon == nil or ((data.weapon.components.weapon == nil or data.weapon.components.weapon.projectile == nil) and data.weapon.components.projectile == nil)) and
                not (data.attacker.components.inventory ~= nil and data.attacker.components.inventory:IsInsulated()) then

                data.attacker.components.health:DoDelta(-TUNING.LIGHTNING_GOAT_DAMAGE, nil, inst.prefab, nil, inst)
                if data.attacker:HasTag("player") and not data.attacker.sg:HasStateTag("dead") then
                    data.attacker.sg:GoToState("electrocute")
                end
            end
        elseif data.stimuli == "electric" or (data.weapon ~= nil and data.weapon.components.weapon ~= nil and data.weapon.components.weapon.stimuli == "electric") then
            setcharged(inst)
        end

        inst.components.combat:SetTarget(data.attacker)
        inst.components.combat:ShareTarget(data.attacker, 20, IsChargedGoat, 3)
    end
end

local function onspawnedforhunt(inst)
	TheWorld:PushEvent("ms_sendlightningstrike", inst:GetPosition())
end

local function OnSave(inst, data)
    if inst.charged then
        data.charged = inst.charged
        data.chargeleft = inst.chargeleft
    end
end

local function OnLoad(inst, data)
    if data and data.charged and data.chargeleft then
        setcharged(inst, true)
        inst.chargeleft = data.chargeleft
    end
end

local function LightningAttack(inst)
	if inst.components.combat and inst.components.combat.target and inst.components.combat.target:IsValid() then
		local x,y,z = inst.Transform:GetWorldPosition()
		local x1,y1,z1 = inst.components.combat.target.Transform:GetWorldPosition()
		local angle = -math.atan2((z-z1),(x-x1))
		local newangle = angle+math.random(-2,2)*PI/16
		local shocker = SpawnPrefab("goat_lightning")
		shocker.destination = inst.components.combat.target:GetPosition()
		shocker.destination.x = x1 + 4*math.cos(newangle)
		shocker.destination.z = z1 + 4*math.sin(newangle)
		shocker.Transform:SetPosition(x,y,z)
	end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    inst.DynamicShadow:SetSize(1.75, .75)

    inst.Transform:SetFourFaced()

    MakeCharacterPhysics(inst, 100, .5)

    inst.AnimState:SetBank("lightning_goat")
    inst.AnimState:SetBuild("alpha_lightning_goat_build")
    inst.AnimState:PlayAnimation("idle_loop", true)
    inst.AnimState:Hide("fx")
	
	inst.Transform:SetScale(1.1, 1.1, 1.1)

    ------------------------------------------

    inst:AddTag("alpha_goat")
    inst:AddTag("lightninggoat")
    inst:AddTag("animal")
    inst:AddTag("lightningrod")

    --herdmember (from herdmember component) added to pristine state for optimization
    inst:AddTag("herdmember")

    --saltlicker (from saltlicker component) added to pristine state for optimization
    inst:AddTag("saltlicker")

    inst.Light:Enable(false)
    inst.Light:SetRadius(.85)
    inst.Light:SetFalloff(0.5)
    inst.Light:SetIntensity(.75)
    inst.Light:SetColour(255 / 255, 255 / 255, 236 / 255)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst.getting_angry = false
	inst.pissed_count = 0

    ------------------------------------------

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.LIGHTNING_GOAT_HEALTH)

    ------------------

    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(TUNING.LIGHTNING_GOAT_DAMAGE * 1.5)
    inst.components.combat:SetRange(TUNING.LIGHTNING_GOAT_ATTACK_RANGE * 1.1)
    inst.components.combat.hiteffectsymbol = "lightning_goat_body"
    inst.components.combat:SetAttackPeriod(TUNING.LIGHTNING_GOAT_ATTACK_PERIOD * 1.1)
    inst.components.combat:SetRetargetFunction(1, RetargetFn)
    inst.components.combat:SetKeepTargetFunction(KeepTargetFn)
    inst.components.combat:SetHurtSound("dontstarve_DLC001/creatures/lightninggoat/hurt")
	
    inst:AddComponent("groundpounder")
    inst.components.groundpounder.destroyer = false
    inst.components.groundpounder.damageRings = 0
    inst.components.groundpounder.destructionRings = 1
    inst.components.groundpounder.platformPushingRings = 1
    inst.components.groundpounder.numRings = 1
    inst.components.groundpounder.groundpoundfx = "sparks"
    inst.components.groundpounder.groundpoundringfx = "sparks"
    --inst.components.groundpounder.groundpoundringfx = "firering_fx"
	
    ------------------------------------------

    inst:AddComponent("sleeper")
    inst.components.sleeper:SetResistance(4)

    ------------------------------------------

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable('alpha_lightninggoat')

    ------------------------------------------

    inst:AddComponent("inspectable")

    ------------------------------------------

    inst:AddComponent("knownlocations")
    inst:AddComponent("herdmember")
    inst.components.herdmember:SetHerdPrefab("lightninggoatherd")

    ------------------------------------------

    inst:ListenForEvent("attacked", OnAttacked)

    ------------------------------------------

    inst:AddComponent("timer")
    inst:AddComponent("saltlicker")
    inst.components.saltlicker:SetUp(TUNING.SALTLICK_LIGHTNINGGOAT_USES)

    ------------------------------------------

    MakeMediumBurnableCharacter(inst, "lightning_goat_body")
    MakeMediumFreezableCharacter(inst, "lightning_goat_body")
	
	inst.LightningAttack = LightningAttack
	inst:ListenForEvent("spawnedforhunt", onspawnedforhunt)

    inst:ListenForEvent("lightningstrike", setcharged)
    inst.setcharged = setcharged

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad
	
	inst:DoPeriodicTask(10, function(inst)
		if not inst.getting_angry and not inst.components.combat:HasTarget() then
			if inst.pissed_count > 0 then
				inst.pissed_count = inst.pissed_count - 1
			end
		end
	end)
	
	inst.Recharge = function(inst)
		--TheNet:Announce("StartRecharge")
		inst.Recharging = inst:DoTaskInTime(10,function(inst)
			--TheNet:Announce("FinishRecharge")
			if inst.recharging_electric then
				inst.recharging_electric = nil
			end
		end)
	end,
    ------------------------------------------

    inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = TUNING.LIGHTNING_GOAT_WALK_SPEED
    inst.components.locomotor.runspeed = TUNING.LIGHTNING_GOAT_RUN_SPEED

    MakeHauntablePanic(inst)

    inst:SetStateGraph("SGalpha_lightninggoat")
    inst:SetBrain(brain)

    return inst
end

return Prefab("alpha_lightninggoat", fn, assets, prefabs)