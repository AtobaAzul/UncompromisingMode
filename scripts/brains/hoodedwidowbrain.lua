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
local MAX_CHASE_TIME = 10
local MAX_CHASE_DIST = 30

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
    return target ~= nil and target.components.pinnable and target.components.pinnable:IsValidPinTarget() and inst.WebReady == true and not inst.sg:HasStateTag("noweb")
end

local function EquipRange(inst)
    if not inst.weaponitems.snotbomb.components.equippable:IsEquipped() then
        inst.components.inventory:Equip(inst.weaponitems.snotbomb)
        -- print("phlegm equipped")
    end
end

local function GoHomeAction(inst)
    local home = inst.components.homeseeker ~= nil and inst.components.homeseeker.home or nil
    return home ~= nil
        and home:IsValid()
        and home.components.childspawner ~= nil
        and (home.components.health == nil or not home.components.health:IsDead())
        and BufferedAction(inst, nil, ACTIONS.GOHOME)
        or nil
end
local function ShouldResetFight(self)
		local home = self.inst.components.homeseeker ~= nil and self.inst.components.homeseeker.home or nil
		if home then
        local dx, dy, dz = self.inst.Transform:GetWorldPosition()
        local spx, spy, spz = home.Transform:GetWorldPosition()
        if distsq(spx, spz, dx, dz) >= (TUNING.DRAGONFLY_RESET_DIST*12) then
		return true
        else
        return false
        end
		end
end
function HoodedWidowBrain:OnStart()
    local root = PriorityNode(
    {	
	            WhileNode(function() return ShouldResetFight(self) or not self.inst.components.combat.target end, "Reset Fight",
                PriorityNode({
                    DoAction(self.inst, GoHomeAction),
                }, .25)),
		
    	WhileNode( function() return self.inst.components.hauntable and self.inst.components.hauntable.panic end, "PanicHaunted", Panic(self.inst)),
        WhileNode( function() return self.inst.components.health.takingfiredamage end, "OnFire", Panic(self.inst)),
		WhileNode(function() return CanRangeNow(self.inst) and not ShouldResetFight(self)  end, "AttackMomentarily",
            SequenceNode({
                ActionNode(function() EquipRange(self.inst) end, "Equip phlegm"),
                ChaseAndAttack(self.inst) })),

		--[[WhileNode(function() return CanLeapNow(self.inst) end, "AttackMomentarily",
            SequenceNode({
                ActionNode(function() EquipLeap(self.inst) end, "Equip phlegm"),
                ChaseAndAttack(self.inst, MAX_CHASE_TIME) })),]]
		WhileNode(function() return not ShouldResetFight(self) end, "Attack",
            SequenceNode({
                ActionNode(function() EquipMeleeAndResetCooldown(self.inst) end, "Equip melee"),
                ChaseAndAttack(self.inst) })),
        
        Wander(self.inst),
    }, 2)
    
    self.bt = BT(self.inst, root)
    
end

return HoodedWidowBrain