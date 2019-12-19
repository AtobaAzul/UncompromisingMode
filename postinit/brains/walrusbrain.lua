local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
local function WalrusLeashFix(brain)
    if brain.bt.root.children ~= nil then
        --TODO: fix this
        local run = brain.bt.root.children[3]
        local leash = brain.bt.root.children[2]
        table.insert(brain.bt.root.children, 2, run)
        table.insert(brain.bt.root.children, 3, leash)
    end
end

env.AddBrainPostInit("walrusbrain", WalrusLeashFix)