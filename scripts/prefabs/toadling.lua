require "brains/toadlingbrain"
require "stategraphs/SGtoadling"

local easing = require("easing")

local assets=
{
	Asset("ANIM", "anim/hippo_basic.zip"),
    Asset("ANIM", "anim/hippo_attacks.zip"),    
    Asset("ANIM", "anim/hippo_water.zip"),
    Asset("ANIM", "anim/hippo_water_attacks.zip"),    
	Asset("ANIM", "anim/hippo_build.zip"),
	Asset("SOUND", "sound/chess.fsb"),
}

local prefabs =
{
    "meat",
}

SetSharedLootTable( 'toadling',
{
    {'shroom_skin_fragment',	1.00},
    {'meat',            1.00},
    {'meat',            0.50},
    {'froglegs',            1.00},
    {'froglegs',            0.50},
    {'blue_cap',            0.25},
    {'red_cap',            0.25},
    {'green_cap',            0.25},
})

local SLEEP_DIST_FROMHOME = 1
local SLEEP_DIST_FROMTHREAT = 20
local MAX_CHASEAWAY_DIST = 40
local MAX_TARGET_SHARES = 5
local SHARE_TARGET_DIST = 40



local function NoHoles(pt)
    return not TheWorld.Map:IsPointNearHole(pt)
end

local function FindMushroomBombTargets(inst)
    --ring with a random gap
    local maxbombs = inst.mushroombomb_variance > 0 and inst.mushroombomb_count + math.random(inst.mushroombomb_variance) or inst.mushroombomb_count
    local delta = (1 + math.random()) * PI / maxbombs
    local offset = 2 * PI * math.random()
    local angles = {}
    for i = 1, maxbombs do
        table.insert(angles, i * delta + offset)
    end

    --shorten range when mobbed by NPC
    local pt = inst:GetPosition()
    local maxrange = TUNING.TOADSTOOL_MUSHROOMBOMB_MAX_RANGE
    for i = 1, 2 do
        local closerange = (TUNING.TOADSTOOL_MUSHROOMBOMB_MIN_RANGE + maxrange) * .5
        local targets = TheSim:FindEntities(pt.x, 0, pt.z, closerange, { "_combat", "_health" }, { "player", "INLIMBO" })
        if #targets < inst.components.grouptargeter.num_targets then
            break
        end
        maxrange = closerange
    end

    local range = GetRandomMinMax(TUNING.TOADSTOOL_MUSHROOMBOMB_MIN_RANGE, maxrange)
    local targets = {}
    while #angles > 0 do
        local theta = table.remove(angles, math.random(#angles))
        local offset = FindWalkableOffset(pt, theta, range, 12, true, true, NoHoles)
        if offset ~= nil then
            offset.x = offset.x + pt.x
            offset.y = 0
            offset.z = offset.z + pt.z
            table.insert(targets, offset)
        end
    end

    return targets
end

local function SpawnMushroomBombProjectile(inst, targets)
    local x, y, z = inst.Transform:GetWorldPosition()
    local projectile = SpawnPrefab("mushroombomb_projectile")
    projectile.Transform:SetPosition(x, y, z)
    projectile.components.entitytracker:TrackEntity("toadstool", inst)

    --V2C: scale the launch speed based on distance
    --     because 15 does not reach our max range.
    local targetpos = table.remove(targets, 1)
    local dx = targetpos.x - x
    local dz = targetpos.z - z
    local rangesq = dx * dx + dz * dz
    local maxrange = 15
    local bigNum = 10 -- 13 + (math.random()*4)
    local speed = easing.linear(rangesq, bigNum, 3, maxrange * maxrange)
    projectile.components.complexprojectile:SetHorizontalSpeed(speed)
    projectile.components.complexprojectile:Launch(targetpos, inst, inst)

    if #targets > 0 then
        inst:DoTaskInTime(FRAMES, SpawnMushroomBombProjectile, targets)
    end
end

local function DoMushroomBomb(inst)
    local targets = FindMushroomBombTargets(inst)
    if #targets > 0 then
        inst:DoTaskInTime(FRAMES, SpawnMushroomBombProjectile, targets)
    end
end

local function UpdatePlayerTargets(inst)
    local toadd = {}
    local toremove = {}
    local pos = inst.components.knownlocations:GetLocation("home")

    for k, v in pairs(inst.components.grouptargeter:GetTargets()) do
        toremove[k] = true
    end
    for i, v in ipairs(FindPlayersInRange(pos.x, pos.y, pos.z, TUNING.TOADSTOOL_DEAGGRO_DIST, true)) do
        if toremove[v] then
            toremove[v] = nil
        else
            table.insert(toadd, v)
        end
    end

    for k, v in pairs(toremove) do
        inst.components.grouptargeter:RemoveTarget(k)
    end
    for i, v in ipairs(toadd) do
        inst.components.grouptargeter:AddTarget(v)
    end
end

local function ShouldSleep(inst)
    local homePos = inst.components.knownlocations:GetLocation("home")
    local myPos = Vector3(inst.Transform:GetWorldPosition() )
    if not (homePos and distsq(homePos, myPos) <= SLEEP_DIST_FROMHOME*SLEEP_DIST_FROMHOME)
       or (inst.components.combat and inst.components.combat.target)
       or (inst.components.burnable and inst.components.burnable:IsBurning() )
       or (inst.components.freezable and inst.components.freezable:IsFrozen() ) then
        return false
    end
    local nearestEnt = GetClosestInstWithTag("character", inst, SLEEP_DIST_FROMTHREAT)
    return nearestEnt == nil
end

local function ShouldWake(inst)
    local homePos = inst.components.knownlocations:GetLocation("home")
    local myPos = Vector3(inst.Transform:GetWorldPosition() )
    if (homePos and distsq(homePos, myPos) > SLEEP_DIST_FROMHOME*SLEEP_DIST_FROMHOME)
       or (inst.components.combat and inst.components.combat.target)
       or (inst.components.burnable and inst.components.burnable:IsBurning() )
       or (inst.components.freezable and inst.components.freezable:IsFrozen() ) then
        return true
    end
    local nearestEnt = GetClosestInstWithTag("character", inst, SLEEP_DIST_FROMTHREAT)
    return nearestEnt
end

local function Retarget(inst)

    UpdatePlayerTargets(inst)
   --[[ if inst.components.herdmember
       and inst.components.herdmember:GetHerd()
       and inst.components.herdmember:GetHerd().components.mood
       and inst.components.herdmember:GetHerd().components.mood:IsInMood() then--]]
        return FindEntity(inst, TUNING.BEEFALO_TARGET_DIST, function(guy)
            return not guy:HasTag("toadstool") and not guy:HasTag("frog") 
			and not guy:HasTag("prey") and not guy:HasTag("insect") and not guy:HasTag("small_creature") and
                    inst.components.combat:CanTarget(guy) and 
                    not guy:HasTag("wall")
        end)
    --end
end

local function KeepTarget(inst, target)
    --[[if inst.components.herdmember
       and inst.components.herdmember:GetHerd()
       and inst.components.herdmember:GetHerd().components.mood
       and inst.components.herdmember:GetHerd().components.mood:IsInMood() then
        local herd = inst.components.herdmember and inst.components.herdmember:GetHerd()
        if herd and herd.components.mood and herd.components.mood:IsInMood() then
            return distsq(Vector3(herd.Transform:GetWorldPosition() ), Vector3(inst.Transform:GetWorldPosition() ) ) < TUNING.BEEFALO_CHASE_DIST*TUNING.BEEFALO_CHASE_DIST
        end
    end--]]
    return true
end
--[[
local function Retarget(inst)
    local homePos = inst.components.knownlocations:GetLocation("home")
    local myPos = Vector3(inst.Transform:GetWorldPosition() )
    if (homePos and distsq(homePos, myPos) > 40*40)  and not
    (inst.components.follower and inst.components.follower.leader)then
        return
    end
    
    local newtarget = FindEntity(inst, HIPPO_TARGET_DIST, function(guy)
            return (guy:HasTag("character") or guy:HasTag("monster"))
                   and not (inst.components.follower and inst.components.follower.leader == guy)
                   and not (guy:HasTag("hippopotamoose") and (guy.components.follower and not guy.components.follower.leader))
                   and not ((inst.components.follower and inst.components.follower.leader == GetPlayer()) and (guy.components.follower and guy.components.follower.leader == GetPlayer()))
                   and inst.components.combat:CanTarget(guy)
    end)

    if not newtarget then
        inst:RemoveTag("enraged")
    end
    return newtarget
end

local function KeepTarget(inst, target)

    if (inst.components.follower and inst.components.follower.leader) then
        return true
    end

    if inst.sg and inst.sg:HasStateTag("running") then
        return true
    end

    local homePos = inst.components.knownlocations:GetLocation("home")
    local myPos = Vector3(inst.Transform:GetWorldPosition() )
    return (homePos and distsq(homePos, myPos) < 40*40)
end
]]
local function OnAttacked(inst, data)
    inst:AddTag("enraged")
    local attacker = data and data.attacker
    inst.components.combat:SetTarget(attacker)
    inst.components.combat:ShareTarget(attacker, SHARE_TARGET_DIST, function(dude) return dude:HasTag("toadstool") end, MAX_TARGET_SHARES)
end

local function HitShake()
        --       :Shake(shakeType, duration, speed, scale)
        -- TheCamera:Shake("SIDE", 0.2, 0.05, .1)
        TheCamera:Shake("SIDE", 0.5, 0.05, 0.1)
end

local function DoChargeDamage(inst, target)
    if not inst.recentlycharged then
        inst.recentlycharged = {}
    end

    for k,v in pairs(inst.recentlycharged) do
        if v == target then
            --You've already done damage to this by charging it recently.
            return
        end
    end
    inst.recentlycharged[target] = target
    inst:DoTaskInTime(3, function() inst.recentlycharged[target] = nil end)
    inst.components.combat:DoAttack(target, inst.weapon)
    inst.SoundEmitter:PlaySound("dontstarve/creatures/rook/explo") 
end

local function oncollide(inst, other)
    local v1 = Vector3(inst.Physics:GetVelocity())
    if other and other:HasTag("player") then
        return
    end
    if v1:LengthSq() < 42 then return end

    HitShake()

    inst:DoTaskInTime(2*FRAMES, function()   
            if  (other and other:HasTag("smashable")) then
                --other.Physics:SetCollides(false)
                other.components.health:Kill()
            elseif other and other.components.workable and other.components.workable.workleft > 0 then
                SpawnPrefab("collapse_small").Transform:SetPosition(other:GetPosition():Get())
                other.components.workable:Destroy(inst)
            elseif other and other.components.health and other.components.health:GetPercent() >= 0 then
                DoChargeDamage(inst, other)
            end
    end)

end

local function CreateWeapon(inst)
    local weapon = CreateEntity()
    weapon.entity:AddTransform()
    weapon:AddComponent("weapon")
    weapon.components.weapon:SetDamage(200)
    weapon.components.weapon:SetRange(0)
    weapon:AddComponent("inventoryitem")
    weapon.persists = false
    weapon.components.inventoryitem:SetOnDroppedFn(function() weapon:Remove() end)
    weapon:AddComponent("equippable")
    inst.components.inventory:GiveItem(weapon)
    inst.weapon = weapon
end

--[[
local function OnEntityWake(inst)
    inst.components.tiletracker:Start()
end

local function OnEntitySleep(inst)
end
--]]

local function MakeMoose(nightmare)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	local sound = inst.entity:AddSoundEmitter()
	local shadow = inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()

	shadow:SetSize( 3, 1.25 )
    inst.Transform:SetFourFaced()
    --inst.Transform:SetScale(0.66, 0.66, 0.66)
   -- MakeCharacterPhysics(inst, 50, 1.5)
    MakeCharacterPhysics(inst, 50, 1.5)
    inst.Physics:SetCollisionCallback(oncollide)

    anim:SetBank("hippo")
    anim:SetBuild("toadling")
    
    inst:AddTag("animal")
    inst:AddTag("hostile")
    inst:AddTag("toadstool")
    inst:AddTag("toadling")
    inst:AddTag("hippopotamoose")
    inst:AddTag("huff_idle")    
    inst:AddTag("wavemaker")        
    inst:AddTag("lightshake")
    inst:AddTag("antlion_sinkhole_blocker")

     inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
 
    inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = TUNING.DSTU.TOADLING_WALK_SPEED
    inst.components.locomotor.runspeed =  TUNING.DSTU.TOADLING_RUN_SPEED 
 
    inst:AddComponent("sleeper")
    inst.components.sleeper:SetWakeTest(ShouldWake)
    inst.components.sleeper:SetSleepTest(ShouldSleep)
    inst.components.sleeper:SetResistance(3)

    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "spring"
    inst.components.combat:SetAttackPeriod(2)
    inst.components.combat:SetRetargetFunction(3, Retarget)
    inst.components.combat:SetKeepTargetFunction(KeepTarget)
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.DSTU.TOADLING_HEALTH)
    inst.components.combat:SetDefaultDamage(TUNING.DSTU.TOADLING_DAMAGE)
    inst.components.combat:SetAttackPeriod(TUNING.DSTU.TOADLING_ATTACK_PERIOD)
    --inst.components.combat.playerdamagepercent = 2

    inst:AddComponent("grouptargeter")

    inst:AddComponent("groundpounder")
    inst.components.groundpounder.destroyer = true
    inst.components.groundpounder.damageRings = 2
    inst.components.groundpounder.destructionRings = 1
    inst.components.groundpounder.numRings = 2

    inst:AddComponent("inventory")
 

    inst:AddComponent("lootdropper")
	
    inst.components.lootdropper:SetChanceLootTable('toadling')
 
    inst:AddComponent("inspectable")

    inst:AddComponent("knownlocations")
    --inst:AddComponent("herdmember")
    --inst.components.herdmember:SetHerdPrefab("hippoherd")
 
    local brain = require "brains/toadlingbrain"
    inst:SetBrain(brain)
    inst:SetStateGraph("SGtoadling") 
	
    inst.DoMushroomBomb = DoMushroomBomb
	
    inst.mushroombomb_count = 6
    inst.mushroombomb_variance = 0
    inst.mushroombomb_maxchain = 1
    inst.mushroombomb_cd = TUNING.TOADSTOOL_MUSHROOMBOMB_CD
 
    inst:DoTaskInTime(2*FRAMES, function() inst.components.knownlocations:RememberLocation("home", Vector3(inst.Transform:GetWorldPosition()), true) end)

	inst:DoTaskInTime(0, function() 
		inst.sg:GoToState("enter_attack")
		local x, y, z = inst.Transform:GetWorldPosition()
		SpawnPrefab("sleepbomb_burst").Transform:SetPosition(x, y, z)
		
		inst:DoTaskInTime(0.1, function() 
			inst.sg:GoToState("enter_attack")
		end)
	end)
	
    --MakeLargeBurnableCharacter(inst, "swap_fire")
    --MakeMediumFreezableCharacter(inst, "spring")
    
    inst:ListenForEvent("attacked", OnAttacked)

    inst.OnEntityWake = OnEntityWake
    inst.OnEntitySleep = OnEntitySleep

    CreateWeapon(inst)

    --inst:AddComponent("debugger")

    return inst
end

return Prefab("chessboard/toadling", function() return MakeMoose() end , assets, prefabs)