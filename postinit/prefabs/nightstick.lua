local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

local function onlightningground(inst)
    inst.components.fueled:DoDelta(TUNING.MED_FUEL)
    inst.components.fueled.ontakefuelfn(inst, TUNING.SMALL_FUEL)
    if inst.components.fueled:GetPercent() > 1 then
        inst.components.fueled:SetPercent(1)
    end
end


local function onremovefire(fire)
    fire.nightstick._fire = nil
end

local function turnon(inst)
    if not inst.components.fueled:IsEmpty() then
        inst.components.weapon:SetElectric()
        inst.SoundEmitter:PlaySound("dontstarve/wilson/lantern_on")
        inst.components.fueled:StartConsuming()

        local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner or nil

        if owner ~= nil then
            if inst.components.equippable:IsEquipped() and inst.components.inventoryitem.owner ~= nil then
                owner.AnimState:OverrideSymbol("swap_object", "swap_nightstick", "swap_nightstick")
            end
        end

        inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/morningstar", "torch")

        if inst._fire == nil and not inst.components.fueled:IsEmpty() then
            inst._fire = SpawnPrefab("nightstickfire")
            inst._fire.nightstick = inst
            inst:ListenForEvent("onremove", onremovefire, inst._fire)
        end
        inst._fire.entity:SetParent(owner.entity)
    end
end


local function Strike(owner)
    --onlightningground(inst)

    if owner ~= nil then
        local fx = SpawnPrefab("electrichitsparks")

        fx.entity:SetParent(owner.entity)
        fx.entity:AddFollower()
        fx.Follower:FollowSymbol(owner.GUID, "swap_object", 0, -145, 0)
        --fx.Transform:SetScale(.66, .66, .66)
        local item = owner.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        item.components.fueled:DoDelta(TUNING.MED_FUEL)
        item.components.fueled.ontakefuelfn(item, TUNING.SMALL_FUEL)
        if item.components.fueled:GetPercent() > 1 then
            item.components.fueled:SetPercent(1)
        end

    end
end

local function turnoff(inst)
    inst.components.weapon:RemoveElectric()

    local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner or nil
    if owner ~= nil then
        if inst.components.equippable:IsEquipped() and inst.components.inventoryitem.owner ~= nil then
            owner.AnimState:OverrideSymbol("swap_object", "swap_nightstick_off", "swap_nightstick_off")
        end
    end

    inst.SoundEmitter:KillSound("torch")
    inst.SoundEmitter:PlaySound("dontstarve/wilson/lantern_on")
    if inst.components.fueled ~= nil then
        inst.components.fueled:StopConsuming()
    end

    if inst._fire ~= nil then
        if inst._fire:IsValid() then
            inst._fire:Remove()
        end
    end
end

local function ontakefuel(inst, owner)
    if inst.components.equippable:IsEquipped() then
        inst.SoundEmitter:PlaySound("dontstarve/common/lightningrod")
        turnon(inst)
    end
end

local function nofuel(inst)
    if inst.components.equippable:IsEquipped() and inst.components.inventoryitem.owner ~= nil then
        local data =
        {
            prefab = inst.prefab,
            equipslot = inst.components.equippable.equipslot,
        }
        turnoff(inst)
        inst.components.inventoryitem.owner:PushEvent("torchranout", data)
    else
        turnoff(inst)
    end
end

local function spark(inst)
    local fx = SpawnPrefab("electrichitsparks")

    local owner = inst.components.inventoryitem.owner

    if inst.components.equippable:IsEquipped() and owner ~= nil then
        fx.entity:SetParent(owner.entity)
        fx.entity:AddFollower()
        fx.Follower:FollowSymbol(owner.GUID, "swap_object", 0, -145, 0)
        fx.Transform:SetScale(.66, .66, .66)
        inst.sparktask = inst:DoTaskInTime(math.random() * 0.5, spark)
    else
        fx.entity:SetParent(inst.entity)
        --fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
        fx.Transform:SetPosition(0, 1, 0)
        fx.Transform:SetScale(.66, .66, .66)
        --fx.Follower:FollowSymbol(inst.GUID, inst, 0, -150, 0)
        inst.sparktask = inst:DoTaskInTime(math.random() * 0.5, spark)
    end
end


local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_nightstick", "swap_nightstick")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")

    --inst.SoundEmitter:SetParameter("torch", "intensity", 1)

    if inst.components.fueled:IsEmpty() or owner:HasTag("equipmentmodel") then
        owner.AnimState:OverrideSymbol("swap_object", "swap_nightstick_off", "swap_nightstick_off")
    else
        inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/morningstar", "torch")
        inst.components.burnable:Ignite()
        turnon(inst)
        owner.AnimState:OverrideSymbol("swap_object", "swap_nightstick", "swap_nightstick")

        if inst.overcharged then
            inst.sparktask = inst:DoTaskInTime(math.random(), spark)
        end
    end
    owner:AddTag("batteryuser") -- from batteryuser component
    owner:AddTag("lightningrod")
    owner.lightningpriority = 0
    owner:ListenForEvent("lightningstrike", Strike, owner)
end

local function onunequip(inst, owner)
    inst.components.burnable:Extinguish()
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    inst.SoundEmitter:KillSound("torch")

    turnoff(inst)

    owner:RemoveTag("lightningrod")
    owner.lightningpriority = nil
    owner:ListenForEvent("lightningstrike", nil)

    if not owner.UM_isBatteryUser then
        local item = owner.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
        if item ~= nil then
            if not item:HasTag("electricaltool") and owner:HasTag("batteryuser") then
                owner:RemoveTag("batteryuser")
            end
        else
            if owner:HasTag("batteryuser") then
                owner:RemoveTag("batteryuser")
            end
        end
    end

    if inst.sparktask ~= nil then
        inst.sparktask:Cancel()
        inst.sparktask = nil
    end
end

local function onfuelchange(newsection, oldsection, inst)
    if newsection <= 0 then
        --when we burn out
        if inst.components.burnable ~= nil then
            inst.components.burnable:Extinguish()
        end
        local equippable = inst.components.equippable
        if equippable ~= nil and equippable:IsEquipped() then
            local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner or nil
            if owner ~= nil then
                local data =
                {
                    prefab = inst.prefab,
                    equipslot = equippable.equipslot,
                    announce = "ANNOUNCE_TORCH_OUT",
                }
                turnoff(inst)
                owner:PushEvent("itemranout", data)
                return
            end
        end
        turnoff(inst)
    end
end

local function onattack(inst, attacker, target)
    if target ~= nil and target:IsValid() and attacker ~= nil and attacker:IsValid() and
        inst.components.weapon.stimuli == "electric" then
        SpawnPrefab("electrichitsparks"):AlignToTarget(target, attacker, true)
    end

    if inst.overcharged and target:IsValid() then
        if not target.components.debuffable then
            target:AddComponent("debuffable")
        end

        if not target:HasTag("epic") and not target:HasTag("shadow") or (target:HasTag("chess") or target:HasTag("uncompromising_pawn") or target:HasTag("twinofterror") and not target:HasTag("fleshyeye")) then
            target.components.debuffable:AddDebuff("shockstundebuff", "shockstundebuff")
        end

        if (target:HasTag("chess") or target:HasTag("uncompromising_pawn") or target:HasTag("twinofterror") and not target:HasTag("fleshyeye")) and (target.components.health ~= nil and not target.components.health:IsDead()) and not target.sg:HasStateTag("noattack") then
            target.components.health:DoDelta(-34, false, attacker, false, attacker)
        end
    end
end

local function OnOvercharge(inst, toggle)
    inst.overcharged = toggle
    inst.components.fueled.rate = toggle and 4 or 2

    if toggle and inst.sparktask == nil and inst.components.equippable:IsEquipped() then
        inst.sparktask = inst:DoTaskInTime(math.random(), spark)
    elseif not toggle and inst.sparktask ~= nil then
        inst.sparktask:Cancel()
        inst.sparktask = nil
    end
end

env.AddPrefabPostInit("nightstick", function(inst)
    inst:AddTag("overchargeable")

    if not TheWorld.ismastersim then
        return
    end

    if inst.components.fueled ~= nil then
        inst.components.fueled:SetSectionCallback(onfuelchange)
        --inst.components.fueled.maxfuel = TUNING.NIGHTSTICK_FUEL / 2
        --inst.components.fueled:InitializeFuelLevel(TUNING.NIGHTSTICK_FUEL / 2)
        inst.components.fueled.rate = 2
        --inst.components.fueled:InitializeFuelLevel(TUNING.LANTERN_LIGHTTIME / 1.25)
        --inst.components.fueled:SetFirstPeriod(TUNING.TURNON_FUELED_CONSUMPTION * 2, TUNING.TURNON_FULL_FUELED_CONSUMPTION * 2)

        inst.components.fueled:SetDepletedFn(nofuel)
        inst.components.fueled:SetTakeFuelFn(ontakefuel)
        inst.components.fueled.fueltype = FUELTYPE.BATTERYPOWER
        --inst.components.fueled.secondaryfueltype = FUELTYPE.CHEMICAL
        inst.components.fueled.accepting = true

        inst.components.fueled.rate = 1
        inst:AddTag("lightningrod")
        inst:ListenForEvent("lightningstrike", onlightningground)
    end

    if inst.components.equippable ~= nil then
        inst.components.equippable:SetOnEquip(onequip)
        inst.components.equippable:SetOnUnequip(onunequip)
    end

    if inst.components.weapon ~= nil then
        inst.components.weapon:RemoveElectric()
        inst.components.weapon:SetOnAttack(onattack)
    end

    inst:AddTag("electricaltool")

    inst:ListenForEvent("overcharged", OnOvercharge)

    local _OnSave = inst.OnSave
    local _OnLoad = inst.OnLoad

    inst.OnSave = function(inst, data)
        if data ~= nil then
            data.actual_fuel = inst.components.fueled:GetPercent()
        end

        if _OnSave ~= nil then
            return _OnSave(inst, data)
        end
    end

    inst.OnLoad = function(inst, data)
        if data ~= nil and data.actual_fuel ~= nil then
            inst:DoTaskInTime(0, function() inst.components.fueled:SetPercent(data.actual_fuel) end)
        end

        if _OnLoad ~= nil then
            return _OnLoad(inst, data)
        end
    end
end)
