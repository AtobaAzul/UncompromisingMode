local env = env
GLOBAL.setfenv(1, GLOBAL)

local function DoSmog(inst)
    local smog = SpawnPrefab("smog")
    local x, y, z = inst.Transform:GetWorldPosition()

    smog.Transform:SetPosition(x + math.random(-160, 160) / 10, math.random(0, 4),
        z + math.random(-160, 160) / 10)
    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
        inst.smog_task = inst:DoTaskInTime(math.random(5, 15) / 10, DoSmog)
    end
end

env.AddPrefabPostInitAny(function(inst)
    if not TheWorld.ismastersim then return end
    if inst:HasTag("plant") and inst.components.burnable ~= nil then
        local _OnIgnite = inst.components.burnable.onignite

        inst.components.burnable.onignite = function(inst, source, doer, ...)
            if TheWorld.state.issummer then
                inst.smog_task = inst:DoTaskInTime(math.random(5, 15) / 10, DoSmog)
            end

            if _OnIgnite ~= nil then
                _OnIgnite(inst, source, doer, ...)
            end
        end
    end
end)
