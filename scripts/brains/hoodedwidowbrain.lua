require "behaviours/wander"
require "behaviours/chaseandattack"
require "behaviours/follow"
require "behaviours/doaction"
require "behaviours/minperiod"
require "behaviours/panic"


local HoodedWidowBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

-----------------------------------------------------------------
local MAX_CHASE_TIME = 5
local MAX_CHASE_DIST = 30
local FLEE_WARNING_DELAY = 3.5
local FORCE_MELEE_DIST = 4
local MAX_WANDER_DIST = 7
local function EquipMeleeAndResetCooldown(inst)
    if not inst.weaponitems.meleeweapon.components.equippable:IsEquipped() then
        inst.components.combat:ResetCooldown()
        inst.components.inventory:Equip(inst.weaponitems.meleeweapon)
        -- print("melee equipped and cooldown reset")
    end
end

local function EquipMelee(inst)
    if not inst.weaponitems.meleeweapon.components.equippable:IsEquipped() then
        inst.components.inventory:Equip(inst.weaponitems.meleeweapon)
        -- print("melee equipped")
    end
end
local function EquipLeapAndResetCooldown(inst)
    if not inst.weaponitems.meleeweapon.components.equippable:IsEquipped() then
        inst.components.combat:ResetCooldown()
        inst.components.inventory:Equip(inst.weaponitems.leapweapon)
        -- print("melee equipped and cooldown reset")
    end
end

local function GoHomeAction(inst)
    local home = inst.components.homeseeker ~= nil and inst.components.homeseeker.home or nil
    return home ~= nil
        and home:IsValid()
        and home.components.childspawner ~= nil
        and (home.components.health == nil or not home.components.health:IsDead())
        and BufferedAction(inst, home, ACTIONS.GOHOME)
        or nil
end
local function JumpHomeAction(inst)
    local home = inst.components.homeseeker ~= nil and inst.components.homeseeker.home or nil
    return home ~= nil
        and home:IsValid()
        and home.components.childspawner ~= nil
        and (home.components.health == nil or not home.components.health:IsDead())
        and inst.sg:GoToState("jumphome") --Instead we should be just jumping back into the canopy
        or nil
end
local function EquipLeap(inst)
    if not inst.weaponitems.meleeweapon.components.equippable:IsEquipped() then
        inst.components.inventory:Equip(inst.weaponitems.leapweapon)
        -- print("melee equipped")
    end
end
local function CanLeapNow(inst)
    local target = inst.components.combat.target
    return target ~= nil and inst.LeapReady == true and not inst.sg:HasStateTag("noleap")
end
local function CanRangeNow(inst)
    local target = inst.components.combat.target
    return target ~= nil and target.components.pinnable and target.components.pinnable:IsValidPinTarget() and inst:GetDistanceSqToInst(target) > 3
end

local function EquipRange(inst)
    if not inst.weaponitems.snotbomb.components.equippable:IsEquipped() then
        inst.components.inventory:Equip(inst.weaponitems.snotbomb)
        -- print("phlegm equipped")
    end
end
local function BossCheck(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, 50, { "epic" }, { "hoodedwidow" } )
	if #ents >= 1 then
	inst.sg:GoToState("jumphome")
	end
end
local function CanMeleeNow(inst)
    local target = inst.components.combat.target
    if target == nil or inst.components.combat:InCooldown() then
        return false
    end
    if target.components.pinnable ~= nil then
        return not target.components.pinnable:IsValidPinTarget()
    end
    return inst:IsNear(target, FORCE_MELEE_DIST)
end
local function EquipMeleeAndResetCooldown(inst)
    if not inst.weaponitems.meleeweapon.components.equippable:IsEquipped() then
        inst.components.combat:ResetCooldown()
        inst.components.inventory:Equip(inst.weaponitems.meleeweapon)
        -- print("melee equipped and cooldown reset")
    end
end

local function EquipMelee(inst)
    if not inst.weaponitems.meleeweapon.components.equippable:IsEquipped() then
        inst.components.inventory:Equip(inst.weaponitems.meleeweapon)
        -- print("melee equipped")
    end
end

local function TargetLeavingArena(inst)
if inst.components.combat~= nil and inst.components.combat.target ~= nil then
    local target = inst.components.combat.target
	local home = inst.components.homeseeker ~= nil and inst.components.homeseeker.home or nil
	if (target ~= nil and home ~= nil) then
	local dx, dy, dz = target.Transform:GetWorldPosition()
    local spx, spy, spz = home.Transform:GetWorldPosition()
    return target ~= nil and home ~= nil and distsq(spx, spz, dx, dz) >= (TUNING.DRAGONFLY_RESET_DIST*10)
	else
	return false
	end
else
return false
end
end


local function NoTarget(inst)
	if inst.investigated and inst.components.combat.target == nil then
	return true
	end
end
local function GettingBullied(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, 50, { "epic" }, { "hoodedwidow" } )
	if #ents >= 1 then
	return true
	else
	return false
	end
end
function HoodedWidowBrain:OnStart()
    local root = PriorityNode(
    {	
		WhileNode(function() return self.inst.bullier == true end,"Being Bullied",
		DoAction(self.inst, JumpHomeAction)),
        WhileNode(function() return CanMeleeNow(self.inst) or not TargetLeavingArena(self.inst) end, "Hit Stuck Target or Creature",
            SequenceNode({
                ActionNode(function() EquipMeleeAndResetCooldown(self.inst) end, "Equip melee"),
                ChaseAndAttack(self.inst) })),
        WhileNode(function() return TargetLeavingArena(self.inst) and CanRangeNow(self.inst) end, "AttackMomentarily",
            SequenceNode({
                ActionNode(function() EquipRange(self.inst) end, "Equip phlegm"),
                ChaseAndAttack(self.inst) })),
                
		WhileNode(function() return NoTarget(self.inst) end,"No Target",
		DoAction(self.inst, GoHomeAction)),
        Wander(self.inst, function() return self.inst.components.knownlocations:GetLocation("home") end, MAX_WANDER_DIST),
    }, 2)
    
    self.bt = BT(self.inst, root)
    
end

return HoodedWidowBrain