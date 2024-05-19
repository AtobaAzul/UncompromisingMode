local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddPrefabPostInit("lighter", function(inst)
    if not TheWorld.ismastersim then return end

    local _testforattunedskill = inst.testforattunedskill

    inst.testforattunedskill = function(inst, owner)
        _testforattunedskill(inst, owner)
        if owner.components.skilltreeupdater:IsActivated("willow_attuned_lighter") and inst.components.channelcastable ~= nil then
            local _onstartchannelingfn                          = inst.components.channelcastable.onstartchannelingfn
            local _onstopchannelingfn                           = inst.components.channelcastable.onstopchannelingfn

            inst.components.channelcastable.onstopchannelingfn  = function(inst, user)
                _onstopchannelingfn(inst, user)
                if inst.smog_task then
                    inst.smog_task:Cancel()
                    inst.smog_task = nil
                end
            end

            inst.components.channelcastable.onstartchannelingfn = function(inst, user)
                _onstartchannelingfn(inst, user)
                inst.smog_task = inst:DoPeriodicTask(0.3, function(inst)
                    local x, y, z = inst.Transform:GetWorldPosition()
                    local smog = TheSim:FindEntities(x, y, z, 12, { "smog" })
                    for k, v in pairs(smog) do
                        v:Remove()
                        inst.SoundEmitter:PlaySound("meta3/willow_lighter/ember_absorb")
                    end
                end, nil, user)
            end
        end
    end
end)


if env.GetModConfigData("no_bee_embers") then
    env.AddPrefabPostInitAny(function(inst)
        if not TheWorld.ismastersim then
            return inst
        end
        --if inst.components.health ~= nil and inst:HasTag("insect") and inst.components.health ~= nil and not inst.components.health:IsDead() and inst.components.health.maxhealth <= 100 then
        if inst:HasTag("butterfly") or inst:HasTag("bird") or inst:HasTag("bee") then
            inst:AddTag("noember")
        end
    end)
end
