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
	"widowshead",
}


local RETARGET_MUST_TAGS = { "_combat" }
local RETARGET_CANT_TAGS = { "INLIMBO", "structure", "bird", "snapdragon" }
local RETARGET_ONE_OF_TAGS = { "player" }
local function Retarget(inst)
    if not inst.components.health:IsDead() and not inst.components.sleeper:IsAsleep() and not inst.sg:HasStateTag("attack") then
        local newtarget = FindEntity(inst, 9, 
            function(guy)
                return inst.components.combat:CanTarget(guy)
					--distsq(spx, spz, dx, dz) >= (TUNING.DRAGONFLY_RESET_DIST*12) 
            end,
            RETARGET_MUST_TAGS,
            RETARGET_CANT_TAGS,
			RETARGET_ONE_OF_TAGS
        )

        if newtarget ~= nil then
            inst.components.combat:SetTarget(newtarget)
        end
    end
end

local function CalcSanityAura(inst, observer)	--Webber is caught offguard by her aggression?
    return observer:HasTag("spiderwhisperer") and -TUNING.SANITYAURA_HUGE*1.25 or -TUNING.SANITYAURA_HUGE
end

local function OnAttacked(inst, data)
    if data.attacker ~= nil and not inst.sg:HasStateTag("attack")then
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
        --home.components.childspawner:StartSpawning()
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
--inst.WebReady = true
inst.investigated = false
end

local function DoLeap(inst)
if inst.components.combat ~= nil and inst.components.combat.target and not inst.components.health:IsDead() then
if math.random()>0 then
inst.sg:GoToState("preleapattack")
end
end
end
local function DoMortar(inst)
if inst.components.combat ~= nil and inst.components.combat.target and not inst.components.health:IsDead() then
if math.random()>0 then
inst.sg:GoToState("lobprojectile")
end
end
end
local function TryPowerMove(inst,data)
if not inst.sg:HasStateTag("busy") and (inst.components.health ~= nil and not inst.components.health:IsDead()) and (inst.components.combat ~= nil and inst.components.combat.target ~= nil) and not inst.sg:HasStateTag("attack") then
	if data ~= nil and data.name == "pounce" then
			DoLeap(inst)	
	end
	if data ~= nil and data.name == "mortar" then
			DoMortar(inst)	
	end
end
end


local function Reset(inst)
    inst.reset = true
end

local function OnKilledOther(inst)
  if inst.components.combat ~= nil then
    inst.components.combat:TryRetarget()
  end

  if inst.investigatedtask ~= nil then
    inst.investigatedtask:Cancel()
    inst.investigatedtask = nil
  end
  inst.investigated = nil
  inst.investigatedtask = inst:DoTaskInTime(5, function(inst) inst.investigated = true end)
end

local function GettingBullied(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, 20, { "epic" }, { "hoodedwidow" } )
	if #ents >= 1 or inst:GetDistanceSqToInst(inst.components.homeseeker.home) > TUNING.DRAGONFLY_RESET_DIST*15 then
	inst.bullier = true
	else
	inst.bullier = false
	end
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
    inst:AddTag("hoodedwidow")
    --inst:AddTag("spiderqueen")  --She left this faction
    --inst:AddTag("spider")

    inst.AnimState:SetBank("widow")
    inst.AnimState:SetBuild("widow1")
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
    inst.components.health:SetMaxHealth(TUNING.DSTU.WIDOW_HEALTH)

    ------------------
    inst:AddComponent("knownlocations")
    inst:AddComponent("combat")
    inst.components.combat:SetRange(TUNING.SPIDERQUEEN_ATTACKRANGE)
	
    if inst.components.combat ~= nil then
		local function queensstuff(ent)
			if ent ~= nil and not ent:HasTag("queensstuff") then -- fix to friendly AOE: refer for later AOE mobs -Axe
				return true
			end
		end
        inst.components.combat:SetAreaDamage(4, TUNING.DEERCLOPS_AOE_SCALE, queensstuff) -- you can edit these values to your liking -Axe
    end
    inst.components.combat:SetDefaultDamage(TUNING.SPIDERQUEEN_DAMAGE * 2)
    inst.components.combat.playerdamagepercent = TUNING.DEERCLOPS_DAMAGE_PLAYER_PERCENT
    inst.components.combat:SetAttackPeriod(TUNING.SPIDERQUEEN_ATTACKPERIOD)
    inst.components.combat:SetRetargetFunction(1, Retarget)
	inst:AddComponent("groundpounder")
    inst.components.groundpounder.damageRings = 2
    inst.components.groundpounder.platformPushingRings = 2
    inst.components.groundpounder.numRings = 3

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
	inst.components.groundpounder.damageRings = 0
    inst.components.groundpounder.destructionRings = 2
    inst.components.groundpounder.platformPushingRings = 2
    inst.components.groundpounder.numRings = 3
    ------------------
	inst.investigated = false
	inst.Reset = Reset
    inst.DoDespawn = DoDespawn
	inst:AddComponent("inventory")
    inst.weaponitems = {}
	EquipWeapons(inst)
    inst:SetBrain(brain)
	inst.OnLoad = OnLoad
    inst:ListenForEvent("attacked", OnAttacked)
    inst:ListenForEvent("death", OnDead)
	inst.combo = 1
	inst:AddComponent("timer")
	inst:ListenForEvent("timerdone", TryPowerMove)
	inst.components.timer:StartTimer("pounce",10+math.random(-3,1))
	inst.components.timer:StartTimer("mortar",20+math.random(-1,5))
	inst:DoPeriodicTask(3, GettingBullied)
	inst.bullier = nil
	inst:ListenForEvent("killed", OnKilledOther)
	

    return inst
end
return Prefab("hoodedwidow", fn)
