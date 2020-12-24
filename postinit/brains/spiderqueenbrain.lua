local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
--[[
local MAX_CHASE_TIME = 10
local MAX_CHASE_DIST = 30

local function CanMeleeNow(inst)
    local target = inst.components.combat.target
    if target == nil or inst.components.combat:InCooldown() then
        return false
    end
	if inst.WebReady == false then
	return true
	end
    if target.components.pinnable ~= nil then
        return not target.components.pinnable:IsValidPinTarget()
    end
    return inst:IsNear(target, 30)
end

local function EquipMeleeAndResetCooldown(inst)
    if not inst.weaponitems.meleeweapon.components.equippable:IsEquipped() then
        inst.components.combat:ResetCooldown()
        inst.components.inventory:Equip(inst.weaponitems.meleeweapon)
    end
end

local function EquipMelee(inst)
    if not inst.weaponitems.meleeweapon.components.equippable:IsEquipped() then
        inst.components.inventory:Equip(inst.weaponitems.meleeweapon)
    end
end

local function CanRangeNow(inst)
    local target = inst.components.combat.target
    return target ~= nil and target.components.pinnable and target.components.pinnable:IsValidPinTarget() and not inst.components.combat:InCooldown() and inst.WebReady == true
end

local function EquipRange(inst)
    if not inst.weaponitems.snotbomb.components.equippable:IsEquipped() then
        inst.components.inventory:Equip(inst.weaponitems.snotbomb)
    end
end

local function AddWeaponsToQueenBrain(self)
local melee = WhileNode(function() return CanMeleeNow(self.inst) end, "Hit Stuck Target or Creature",
            SequenceNode({
                ActionNode(function() EquipMeleeAndResetCooldown(self.inst) end, "Equip melee"),
                ChaseAndAttack(self.inst, MAX_CHASE_TIME) }))
				
local range = WhileNode(function() return CanRangeNow(self.inst) end, "AttackMomentarily",
            SequenceNode({
                ActionNode(function() EquipRange(self.inst) end, "Equip phlegm"),
                ChaseAndAttack(self.inst, MAX_CHASE_TIME) }))
			table.remove(self.bt.root.children, 5)	
			table.insert(self.bt.root.children, 5, melee)
			table.insert(self.bt.root.children, 6, range)
end			
				
				
				
env.AddBrainPostInit("spiderqueenbrain", AddWeaponsToQueenBrain)]]