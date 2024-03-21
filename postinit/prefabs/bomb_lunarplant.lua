local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

env.AddPrefabPostInit("bomb_lunarplant", function(inst)
    if not TheWorld.ismastersim then
        return
    end

    local _onhitfn = inst.components.complexprojectile.onhitfn

    inst.components.complexprojectile.onhitfn = function(inst, attacker, target)
        _onhitfn(inst, attacker, target)
        local x, y, z = inst.Transform:GetWorldPosition()
        for i = 1, math.random(5, 10) do
            local fx2 = SpawnPrefab("warg_mutated_breath_fx")
            if fx2 ~= nil then
                fx2.Transform:SetPosition(x + math.random(-10, 10) / 10, y, z + math.random(-10, 10) / 10)
                fx2:RestartFX((math.max(0.25, 1.5)) * 0.33)
                fx2:DoTaskInTime(math.random() * 2 + 1 + (i * 0.25), fx2.KillFX)
            end
        end
    end
end)

