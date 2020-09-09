local assets =
{
    Asset("ANIM", "anim/spider_queen_build.zip"),
    Asset("ANIM", "anim/spider_queen.zip"),
    Asset("ANIM", "anim/spider_queen_2.zip"),
    --Asset("ANIM", "anim/spider_queen_3.zip"),
    --Asset("SOUND", "sound/spider.fsb"),
}

local prefabs =
{
    "monstermeat",
    "silk",
    "spiderhat",
    "spidereggsack",
}

local brain = require "brains/hoodedwidowbrain"

local loot =
{
    "monstermeat",
    "monstermeat",
    "monstermeat",
    "monstermeat",
    "silk",
    "silk",
    "silk",
    "silk",
	"widowsgrasp",
}


local RETARGET_MUST_TAGS = { "character", "_combat" }
local RETARGET_CANT_TAGS = { "INLIMBO" }
local function Retarget(inst)
    if not inst.components.health:IsDead() and not inst.components.sleeper:IsAsleep() then
        local oldtarget = inst.components.combat.target
        local newtarget = FindEntity(inst, 10, 
            function(guy) 
                return (guy:HasTag("player"))
                    and inst.components.combat:CanTarget(guy) 
            end,
            RETARGET_MUST_TAGS,
            RETARGET_CANT_TAGS
        )

        if newtarget ~= nil and newtarget ~= oldtarget then
            inst.components.combat:SetTarget(newtarget)
        end
    end
end

local function CalcSanityAura(inst, observer)
    return observer:HasTag("spiderwhisperer") and 0 or -TUNING.SANITYAURA_HUGE
end

local function OnAttacked(inst, data)
    if data.attacker ~= nil then
        inst.components.combat:SetTarget(data.attacker)
    end
end


local PLAYER_TAGS = { "player" }
local PLAYER_IGNORE_TAGS = { "playerghost" }



local function OnDead(inst)
    AwardRadialAchievement("spiderqueen_killed", inst:GetPosition(), TUNING.ACHIEVEMENT_RADIUS_FOR_GIANT_KILL)
end

local function DoDespawn(inst)
    --Schedule new spawn time
    --Called at the time the hooded widow actually leaves the world.
    local home = inst.components.homeseeker ~= nil and inst.components.homeseeker.home or nil
    if home ~= nil then
        home.components.childspawner:GoHome(inst)
        home.components.childspawner:StartSpawning()
		--print("despawn")
		inst:AddTag("home")
    else
        inst:Remove() --Hooded Widow was probably debug spawned in?
		print("removed, OH NO!")
    end
	
end

local projectile_prefabs =
{
    "spat_splat_fx",
    "spat_splash_fx_full",
    "spat_splash_fx_med",
    "spat_splash_fx_low",
    "spat_splash_fx_melted",
}
local function EquipWeapons(inst)
    if inst.components.inventory ~= nil and not inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) then
        local snotbomb = CreateEntity()
        snotbomb.name = "Snotbomb"
        --[[Non-networked entity]]
        snotbomb.entity:AddTransform()
        snotbomb:AddComponent("weapon")
        snotbomb.components.weapon:SetDamage(TUNING.SPAT_PHLEGM_DAMAGE)
        snotbomb.components.weapon:SetRange(TUNING.SPAT_PHLEGM_ATTACKRANGE)
        snotbomb.components.weapon:SetProjectile("web_bomb")
        snotbomb:AddComponent("inventoryitem")
        snotbomb.persists = false
        snotbomb.components.inventoryitem:SetOnDroppedFn(snotbomb.Remove)
        snotbomb:AddComponent("equippable")
        snotbomb:AddTag("snotbomb")

        inst.components.inventory:GiveItem(snotbomb)
        inst.weaponitems.snotbomb = snotbomb

        local meleeweapon = CreateEntity()
        meleeweapon.name = "Claw"
        --[[Non-networked entity]]
        meleeweapon.entity:AddTransform()
        meleeweapon:AddComponent("weapon")
        meleeweapon.components.weapon:SetDamage(TUNING.SPIDERQUEEN_DAMAGE)
        meleeweapon.components.weapon:SetRange(TUNING.SPAT_MELEE_ATTACKRANGE/4)
        meleeweapon:AddComponent("inventoryitem")
        meleeweapon.persists = false
        meleeweapon.components.inventoryitem:SetOnDroppedFn(meleeweapon.Remove)
        meleeweapon:AddComponent("equippable")
        meleeweapon:AddTag("meleeweapon")

        inst.components.inventory:GiveItem(meleeweapon)
        inst.weaponitems.meleeweapon = meleeweapon

    end
end

local function OnLoad(inst)
inst.WebReady = true
inst.LeapReady = true
end

local function DoSuper(inst)
--if not inst.sg:HasStateTag("superbusy") and not inst:HasTag("gonnasuper") and not inst.components.health:IsDead() and inst.components.combat.target then
if math.random()>0.1 then
inst.sg:GoToState("preleapattack")
else
inst.sg:GoToState("precanopy")
end
--end
end
local function TryPowerMove(inst)
--print("powermovetried")
--print(inst.LeapReady)
if not inst.sg:HasStateTag("superbusy") and not inst:HasTag("gonnasuper") and not inst.components.health:IsDead() and inst.components.combat.target then
	if inst.LeapReady == true then
		if not inst.sg:HasStateTag("superbusy") then
			if not inst.sg:HasStateTag("nointerrupts") then
			inst:AddTag("gonnasuper")
			inst:DoTaskInTime(1, function(inst) if not inst.components.health:IsDead() then DoSuper(inst) end end)
			else
			inst:AddTag("gonnasuper")
			DoSuper(inst)
			end
		end
	else
	inst:DoTaskInTime(10,function(inst) 
	inst.LeapReady = true
	end)
	end
end
end

local function Reset(inst)
    inst.reset = true
end
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddLightWatcher()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()

    MakeCharacterPhysics(inst, 1000, 1)

    inst.DynamicShadow:SetSize(7, 3)
    inst.Transform:SetFourFaced()

    inst:AddTag("cavedweller")
    inst:AddTag("monster")
    inst:AddTag("hostile")
    inst:AddTag("epic")
    inst:AddTag("largecreature")
    inst:AddTag("spiderqueen")
    inst:AddTag("spider")

    inst.AnimState:SetBank("spider_queen")
    inst.AnimState:SetBuild("widow")
    inst.AnimState:PlayAnimation("idle", true)
	inst.Transform:SetScale(1.5,1.5,1.5)
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:SetStateGraph("SGhoodedwidow")

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot(loot)

    ---------------------
    MakeLargeBurnableCharacter(inst, "body")
    MakeLargeFreezableCharacter(inst, "body")
    inst.components.burnable.flammability = TUNING.SPIDER_FLAMMABILITY

    ------------------
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.SPIDERQUEEN_HEALTH)

    ------------------
    inst:AddComponent("knownlocations")
    inst:AddComponent("combat")
    inst.components.combat:SetRange(TUNING.SPIDERQUEEN_ATTACKRANGE)
    inst.components.combat:SetDefaultDamage(TUNING.SPIDERQUEEN_DAMAGE)
    inst.components.combat:SetAttackPeriod(TUNING.SPIDERQUEEN_ATTACKPERIOD)
    inst.components.combat:SetRetargetFunction(3, Retarget)

    ------------------

    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aurafn = CalcSanityAura

    ------------------

    inst:AddComponent("sleeper")
    inst.components.sleeper:SetResistance(4)
    ------------------

    inst:AddComponent("locomotor")
    inst.components.locomotor:SetSlowMultiplier( 1 )
    inst.components.locomotor:SetTriggersCreep(false)
    inst.components.locomotor.pathcaps = { ignorecreep = true }
    inst.components.locomotor.walkspeed = 3

    ------------------

    inst:AddComponent("eater")
    inst.components.eater:SetDiet({ FOODTYPE.MEAT }, { FOODTYPE.MEAT })
    inst.components.eater:SetCanEatHorrible()
    inst.components.eater.strongstomach = true -- can eat monster meat!

    ------------------

    ------------------

    inst:AddComponent("inspectable")

    inst:AddComponent("leader")

    MakeHauntableGoToState(inst, "poop", TUNING.HAUNT_CHANCE_OCCASIONAL, TUNING.HAUNT_COOLDOWN_MEDIUM, TUNING.HAUNT_CHANCE_LARGE)
	inst:AddComponent("groundpounder")
	inst.components.groundpounder.destroyer = true
	inst.components.groundpounder.damageRings = 2
    inst.components.groundpounder.destructionRings = 2
    inst.components.groundpounder.platformPushingRings = 2
    inst.components.groundpounder.numRings = 3
    ------------------
	inst.WebReady = true
	inst.LeapReady = false
	inst.CanopyReady = false
	inst.Reset = Reset
    inst.DoDespawn = DoDespawn
	inst:AddComponent("inventory")
    inst.weaponitems = {}
	EquipWeapons(inst)
    inst:SetBrain(brain)
	inst.OnLoad = OnLoad
    inst:ListenForEvent("attacked", OnAttacked)
    inst:ListenForEvent("death", OnDead)
	inst:DoPeriodicTask(3, TryPowerMove)


    return inst
end

return Prefab("hoodedwidow", fn, assets, prefabs)
