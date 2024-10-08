local env = env
GLOBAL.setfenv(1, GLOBAL)

local function PreReveal(inst, doer)
    local queen = TheSim:FindFirstEntityWithTag("monkeyqueen")
    if queen ~= nil then
        doer.player_classified.MapExplorer:RevealArea(queen.Transform:GetWorldPosition())
    end
    return true
end


env.AddPrefabPostInit("stash_map", function(inst)
    if not TheWorld.ismastersim then
        return
    end

    inst.components.mapspotrevealer:SetPreRevealFn(PreReveal)
end)
