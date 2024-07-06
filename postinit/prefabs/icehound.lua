local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

local function OnHitOtherFreeze(inst, data)
    local other = data.target
    if other ~= nil and not (other.components.health ~= nil and other.components.health:IsDead()) then
        if other.components.freezable ~= nil and other.sg ~= nil and not other.sg:HasStateTag("frozen") then
            other.components.freezable:AddColdness(1.5, 1, true)
            other.components.freezable:SpawnShatterFX()
        end

        if other.components.temperature ~= nil then
            local mintemp = math.max(other.components.temperature.mintemp, 0)
            local curtemp = other.components.temperature:GetCurrent()
            if mintemp < curtemp then
                other.components.temperature:DoDelta(math.max(-5, mintemp - curtemp))
            end
        end
    end
end

env.AddPrefabPostInit("icehound", function(inst)
    if not TheWorld.ismastersim then
        return
    end

    if TUNING.DSTU.FROSTBITEHOUNDS then
        if inst.components.combat ~= nil then
            inst:ListenForEvent("onhitother", OnHitOtherFreeze)
        end
    end
end)
