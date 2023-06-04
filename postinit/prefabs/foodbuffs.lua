local env = env
GLOBAL.setfenv(1, GLOBAL)
env.AddPrefabPostInit("foodbuffs", function(inst)
    MakeBuff("lesserelectricattack", electric_attach, electric_extend, electric_detach,
        TUNING.BUFF_ELECTRICATTACK_DURATION / 2, 2, { "electrichitsparks", "electricchargedfx" })

    local function OnCooldown(inst)
        inst._cdtask = nil
    end

    local function Retaliate(owner, data, inst)
        if inst._cdtask == nil and data ~= nil and not data.redirected then
            --V2C: tiny CD to limit chain reactions
            inst._cdtask = inst:DoTaskInTime(.3, OnCooldown)

            SpawnPrefab("bramblefx_armor"):SetFXOwner(owner)

            if owner.SoundEmitter ~= nil then
                owner.SoundEmitter:PlaySound("dontstarve/common/together/armor/cactus")
            end
        end
    end

    local function attachretaliationdamage(inst, owner)
        inst:ListenForEvent("blocked", Retaliate, owner)
        inst:ListenForEvent("attacked", Retaliate, owner)
        SpawnPrefab("electricchargedfx"):SetTarget(owner)
    end

    local function removeretaliationdamageretaliationdamage(inst, owner)
        inst:RemoveEventCallback("blocked", Retaliate, owner)
        inst:RemoveEventCallback("attacked", Retaliate, owner)
    end
    return MakeBuff("electricretaliation", attachretaliationdamage, electric_extend,
        removeretaliationdamageretaliationdamage, TUNING.BUFF_ELECTRICATTACK_DURATION, 2,
        { "electrichitsparks", "electricchargedfx" })
end)
