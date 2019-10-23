local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
local function WerepigIgnoreFood(brain)
    attack_instead_eat = ChaseAndAttack(brain.inst, GLOBAL.SpringCombatMod(MAX_CHASE_TIME), GLOBAL.SpringCombatMod(MAX_CHASE_DIST))
    table.insert(brain.bt.root.children, 3, attack_instead_eat)
end

env.AddBrainPostInit("werepigbrain", WerepigIgnoreFood)