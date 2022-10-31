local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

env.AddPrefabPostInit("icestaff", function(inst)
    if not TheWorld.ismastersim then
		return
	end
    local _onattack = inst.components.weapon.onattack

    local function OnAttack(inst, attacker, target, skipsanity)
        if attacker:HasTag("wathom") then
            local ret = _onattack(inst, attacker, target, skipsanity)
            local x, y, z = target.Transform:GetWorldPosition()

            local ents = TheSim:FindEntities(x, y, z, 4, nil, { "player", "playerghost", "notarget", "companion", "abigail", "INLIMBO" })
            target.components.freezable:AddColdness(1)

            for k, v in ipairs(ents) do
                if v ~= target then
                    if v.components.freezable ~= nil then
                        v.components.freezable:AddColdness(2)
                        v.components.freezable:SpawnShatterFX()
                    end
                end
            end
            if target.components.health ~= nil then
                target.components.health:DoDelta(-34)
            end
            return ret
        else
            return _onattack(inst, attacker, target, skipsanity)
        end
    end

    inst.components.weapon:SetOnAttack(OnAttack)
end)

env.AddPrefabPostInit("firestaff", function(inst)
    if not TheWorld.ismastersim then
		return
	end
    local _onattack = inst.components.weapon.onattack

    local function OnAttack(inst, attacker, target, skipsanity)
        if attacker:HasTag("wathom") then
            local ret = _onattack(inst, attacker, target, skipsanity)
            local x, y, z = target.Transform:GetWorldPosition()

            local ents = TheSim:FindEntities(x, y, z, 4, { "_health" }, { "player", "playerghost", "notarget", "companion", "abigail", "INLIMBO" })

            for k, v in ipairs(ents) do
                if v ~= target then
                    if v.components.burnable ~= nil then
                        v.components.burnable:Ignite(true)
                    end
                end
                if v.components.health ~= nil and not v.components.health:IsDead() and v.components.combat ~= nil then
                    v.components.combat:GetAttacked(attacker, 34, nil)
                end
            end
            return ret
        else
            return _onattack(inst, attacker, target, skipsanity)
        end
    end

    inst.components.weapon:SetOnAttack(OnAttack)
end)

if env.GetModConfigData("cooldown_orangestaff") then
    local function onblink(staff, pos, caster)
        if caster and staff.components.rechargeable:IsCharged() then
            if caster.components.staffsanity then
                caster.components.staffsanity:DoCastingDelta(-TUNING.SANITY_MED)
            elseif caster.components.sanity ~= nil then
                caster.components.sanity:DoDelta(-TUNING.SANITY_MED)
            end
            staff.components.rechargeable:Discharge(5)
        else
            staff.components.blinkstaff.blinktask:Cancel()
        end
    end

    env.AddPrefabPostInit("orangestaff", function(inst)
        if not TheWorld.ismastersim then
            return
        end
        inst:AddComponent("rechargeable")

        inst:RemoveComponent("finiteuses")
        if inst ~= nil and inst.components.blinkstaff ~= nil then
            inst.components.blinkstaff.onblinkfn = onblink
        end
    end)
end
