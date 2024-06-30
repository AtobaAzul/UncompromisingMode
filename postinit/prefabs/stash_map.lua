local env = env
GLOBAL.setfenv(1, GLOBAL)

local function PreReveal(inst, doer)
    doer.player_classified.MapExplorer:RevealArea(TheSim:FindFirstEntityWithTag("monkeyqueen").Transform:GetWorldPosition())
    return true
end


env.AddPrefabPostInit("stash_map", function(inst)
    if not TheWorld.ismastersim then
        return
    end

    inst.components.mapspotrevealer:SetPreRevealFn(PreReveal)

end)
