local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
local MAX_CHASE_TIME = 10
local MAX_CHASE_DIST = 30
local function WerepigIgnoreFood(brain)
    local attack_instead_eat = ChaseAndAttack(brain.inst, SpringCombatMod(MAX_CHASE_TIME),SpringCombatMod(MAX_CHASE_DIST))
    table.insert(brain.bt.root.children, 3, attack_instead_eat)
end

env.AddBrainPostInit("werepigbrain", WerepigIgnoreFood)