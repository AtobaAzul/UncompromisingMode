local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
local function OnUse2(inst, target)
    local x, y, z = target.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, TUNING.FEATHERFAN_RADIUS, nil, { "FX", "NOCLICK", "DECOR", "INLIMBO", "playerghost" }, { "smolder", "fire", "player" })
    for i, v in pairs(ents) do
        if v.components.hayfever ~= nil then
            v.components.hayfever:SetNextSneezeTime(300)
        end
    end

    local smog = TheSim:FindEntities(x, y, z, TUNING.FEATHERFAN_RADIUS * 3, { "smog" }, { "INLIMBO" })
    for k, v in pairs(smog) do
        v:DoPeriodicTask(0.125, function(inst)
            inst.AnimState:SetMultColour(0.05, 0.05, 0.05, inst.mult)
            inst.mult = inst.mult - 0.025
            if inst.mult <= 0 then
                inst:Remove()
            end
        end)
    end
end

env.AddPrefabPostInit("featherfan", function(inst)
    if not TheWorld.ismastersim then
        return
    end

    if inst.components.fan ~= nil then
        local _onuse = inst.components.fan.onusefn
        inst.components.fan.onusefn = function(inst, target)
            if _onuse ~= nil then
                _onuse(inst, target)
                OnUse2(inst, target)
            end
        end
    end
end)

env.AddPrefabPostInit("perdfan", function(inst)
    if not TheWorld.ismastersim then
        return
    end

    if inst.components.fan ~= nil then
        local _onuse = inst.components.fan.onusefn
        inst.components.fan.onusefn = function(inst, target)
            if _onuse ~= nil then
                _onuse(inst, target)
                OnUse2(inst, target)
            end
        end
    end
end)
