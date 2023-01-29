--currently only used for IA, but if we ever need more advanced mod checks, put 'em here!


local env = env
GLOBAL.setfenv(1, GLOBAL)

--improved check for IA, instead of just checking for the mod, it checks for the world tags *and* the mod.
--returns true if IA.

function TestForIA()
    if TheWorld ~= nil and not (TheWorld:HasTag("forest") or TheWorld:HasTag("cave")) and (TheWorld:HasTag("island") or TheWorld:HasTag("volcano")) and KnownModIndex:IsModEnabled("workshop-1467214795") then
        print("TestForIA: is IA world!")
        return true
    else
        print("TestForIA: not IA world!")
        return false
    end
end

