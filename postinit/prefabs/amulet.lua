local env = env
GLOBAL.setfenv(1, GLOBAL)
local UpvalueHacker = require("tools/upvaluehacker")
-----------------------------------------------------------------

-----------------------------------------------------------------
-- Magiluminesence doesn't break at 0%
-----------------------------------------------------------------

-----------------------------------------------------------------
--Try to initialise all functions locally outside of the post-init so they exist in RAM only once
-----------------------------------------------------------------

-------Red Amulet changes are hosted in init_lifeamulet

local function YellowAmuletPostInit(inst)
    local function onremovelight(light)
        light._yellowamulet._light = nil
    end

    local function turnon(inst, owner)
        if not inst.components.fueled:IsEmpty() then
            if inst.components.fueled ~= nil then
                inst.components.fueled:StartConsuming()
            end
            inst.components.equippable.walkspeedmult = 1.2
            inst.components.equippable.dapperness = TUNING.DAPPERNESS_SMALL

            local owner = inst.components.inventoryitem.owner

            if inst._light == nil or not inst._light:IsValid() then
                inst._light = SpawnPrefab("yellowamuletlight")
                inst._light._yellowamulet = inst
                inst:ListenForEvent("onremove", onremovelight, inst._light)
            end
            inst._light.entity:SetParent((owner or inst).entity)

            if owner.components.bloomer ~= nil then
                owner.components.bloomer:PushBloom(inst, "shaders/anim.ksh", 1)
            else
                owner.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
            end
        end
    end

    local function turnoff(inst, owner)
        inst.components.equippable.walkspeedmult = 1
        inst.components.equippable.dapperness = 0

        if owner.components.bloomer ~= nil then
            owner.components.bloomer:PopBloom(inst)
        else
            owner.AnimState:ClearBloomEffectHandle()
        end

        if inst.components.fueled ~= nil then
            inst.components.fueled:StopConsuming()
        end

        if inst._light ~= nil then
            if inst._light:IsValid() then
                inst._light:Remove()
            end
        end
    end

    local function nofuel(inst)
        if inst.components.equippable:IsEquipped() and inst.components.inventoryitem.owner ~= nil then
            local data = {
                prefab = inst.prefab,
                equipslot = inst.components.equippable.equipslot
            }
            turnoff(inst, inst._owner)
            inst.components.inventoryitem.owner:PushEvent("torchranout", data)
        else
            turnoff(inst, inst._owner)
        end
    end

    local function onequip(inst, owner)
        inst._owner = owner

        local skin_build = inst:GetSkinBuild()
        if skin_build ~= nil then
            owner:PushEvent("equipskinneditem", inst:GetSkinName())
            owner.AnimState:OverrideItemSkinSymbol("swap_body", skin_build, "swap_body", inst.GUID, "torso_amulets")
        else
            owner.AnimState:OverrideSymbol("swap_body", "torso_amulets", "yellowamulet")
        end

        turnon(inst, owner)
    end

    local function onunequip(inst, owner)
        inst._owner = nil
        owner.AnimState:ClearOverrideSymbol("swap_body")

        local skin_build = inst:GetSkinBuild()
        if skin_build ~= nil then
            owner:PushEvent("unequipskinneditem", inst:GetSkinName())
        end

        turnoff(inst, owner)
    end

    local function GetShowItemInfo(inst)
        if inst.components.equippable.walkspeedmult == 1 and inst.components.equippable.dapperness == 0 then
            return "Sanity: +1.8", "Speed: +20%"
        end
    end

    local function _onownerequip(owner, data)
        if data.item ~= inst and (data.eslot == (EQUIPSLOTS.BODY or EQUIPSLOTS.NECK) and data.item:HasTag("heavy")) then
            turnoff(inst, owner)
        end
    end

    local fueled = inst.components.fueled
    if fueled then
        local OldOnTakeFuelFn = fueled.ontakefuelfn
        local function ontakefuel(inst)
            if inst.components.equippable:IsEquipped() then
                turnon(inst, inst._owner)
            end
            if OldOnTakeFuelFn ~= nil then
                return OldOnTakeFuelFn(inst)
            end
        end

        fueled:SetDepletedFn(nofuel)
        fueled:SetTakeFuelFn(ontakefuel)
    end

    local equippable = inst.components.equippable
    if equippable then
        equippable:SetOnEquip(onequip)
        equippable:SetOnUnequip(onunequip)
        equippable.walkspeedmult = 1
        equippable.dapperness = 0
    end

    inst.GetShowItemInfo = GetShowItemInfo
    inst._onownerequip = _onownerequip
end

env.AddPrefabPostInit("yellowamulet", function(inst)
    if not TheWorld.ismastersim then
        return
    end

    YellowAmuletPostInit(inst)
end)

-------Orange

local function OrangeAmuletPostInit(inst)
    local ORANGE_PICKUP_MUST_TAGS = {
        "_inventoryitem",
        "plant",
        "witherable",
        "kelp",
        "lureplant",
        "waterplant",
        "oceanvine",
        "lichen"
    }
    local ORANGE_PICKUP_CANT_TAGS = {
        "INLIMBO",
        "NOCLICK",
        "knockbackdelayinteraction",
        "catchable",
        "fire",
        "minesprung",
        "mineactive",
        "irreplaceable",
        "moonglass_geode"
    }

    local function pickup_UM(inst, owner)
        if owner == nil or owner.components.inventory == nil then
            return
        end
        local x, y, z = inst.Transform:GetWorldPosition()
        local ents = TheSim:FindEntities(x, y, z, 1.2 * TUNING.ORANGEAMULET_RANGE, nil, ORANGE_PICKUP_CANT_TAGS, ORANGE_PICKUP_MUST_TAGS)
        for i, v in ipairs(ents) do
            if v.components.inventoryitem ~= nil and --Inventory stuff
                v.components.inventoryitem.canbepickedup and
                v.components.inventoryitem.cangoincontainer and
                not v.components.inventoryitem:IsHeld() and
                owner.components.inventory:CanAcceptCount(v, 1) > 0 then
                if owner.components.minigame_participator ~= nil then
                    local minigame = owner.components.minigame_participator:GetMinigame()
                    if minigame ~= nil then
                        minigame:PushEvent("pickupcheat", {cheater = owner, item = v})
                        inst.components.fueled:DoDelta(-2)
                    end
                end

                --Amulet will only ever pick up items one at a time. Even from stacks.
                SpawnPrefab("sand_puff").Transform:SetPosition(v.Transform:GetWorldPosition())

                local v_pos = v:GetPosition()
                if v.components.stackable ~= nil then
                    v = v.components.stackable:Get()
                end
                inst.components.fueled:DoDelta(-2)
                if v.components.trap ~= nil and v.components.trap:IsSprung() then
                    v.components.trap:Harvest(owner)
                else
                    owner.components.inventory:GiveItem(v, nil, v_pos)
                end
                return
            end
            if v.components.pickable ~= nil and v.components.pickable:CanBePicked() then --Pickable stuff
                v.components.pickable:Pick(owner)
                inst.components.fueled:DoDelta(-2)
                SpawnPrefab("sand_puff").Transform:SetPosition(v.Transform:GetWorldPosition())
                owner.components.sanity:DoDelta(-0.25) --Can't take too much sanity if the purpose is to use in large farms
                return
            end
        end
    end

    local function onequip_orange_UM(inst, owner)
        owner.AnimState:OverrideSymbol("swap_body", "torso_amulets", "orangeamulet")
        if inst.components.fueled ~= nil and not inst.components.fueled:IsEmpty() then
            inst.task = inst:DoPeriodicTask(TUNING.ORANGEAMULET_ICD, pickup_UM, nil, owner)
        end
        inst._owner = owner
    end

    local function ontakefuel_orange(inst)
        local SERVER_PlayFuelSound = UpvalueHacker.GetUpvalue(_G.Prefabs.orangeamulet.fn, "SERVER_PlayFuelSound")
        if SERVER_PlayFuelSound ~= nil then
            SERVER_PlayFuelSound(inst)
        end
        if inst.components.equippable:IsEquipped() then
            if inst.task == nil then
                inst.task = inst:DoPeriodicTask(TUNING.ORANGEAMULET_ICD, pickup_UM, nil, inst._owner)
            end
        end
    end

    local function nofuel_orange(inst)
        if inst.task ~= nil then
            inst.task:Cancel()
            inst.task = nil
        end
    end

    inst:RemoveComponent("finiteuses")
    inst:AddTag("lazy_forager")

    local fueled = inst:AddComponent("fueled")
    fueled:InitializeFuelLevel(2 * TUNING.ORANGEAMULET_USES)
    fueled.fueltype = FUELTYPE.NIGHTMARE
    fueled:SetDepletedFn(nofuel_orange)
    fueled:SetTakeFuelFn(ontakefuel_orange)
    fueled.accepting = true

    local equippable = inst.components.equippable
    if equippable then
        equippable:SetOnEquip(onequip_orange_UM)
    end
end

env.AddPrefabPostInit("orangeamulet", function(inst)
    if not TheWorld.ismastersim then
        return
    end

    OrangeAmuletPostInit(inst)
end)

---
--Postinits for the spikey pickables
---

local function CactusPostInit(inst)
    local pickable = inst.components.pickable
    if pickable then
        local _OnPick = pickable.onpickedfn
        local function onpickedchannel(inst, picker)
            inst.Physics:SetActive(false)
            inst.AnimState:PlayAnimation(inst.has_flower and "picked_flower" or "picked")
            inst.AnimState:PushAnimation("empty", true)
            if picker ~= nil then
                if inst.has_flower then
                    -- You get a cactus flower, yay.
                    local loot = SpawnPrefab("cactus_flower")
                    loot.components.inventoryitem:InheritMoisture(TheWorld.state.wetness, TheWorld.state.iswet)
                    if picker.components.inventory ~= nil then
                        picker.components.inventory:GiveItem(loot, nil, inst:GetPosition())
                    else
                        local x, y, z = inst.Transform:GetWorldPosition()
                        loot.components.inventoryitem:DoDropPhysics(x, y, z, true)
                    end
                end
            end
            inst.has_flower = false
        end

        local function OnPickNew(inst, picker)
            if (picker.components.inventory ~= nil and picker.components.inventory:EquipHasTag("lazy_forager")) then
                local amulet = picker.components.inventory:GetEquippedItem(EQUIPSLOTS.NECK)
                if amulet == nil then
                    amulet = picker.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY)
                end
                if amulet ~= nil and amulet.components.fueled ~= nil and not amulet.components.fueled:IsEmpty() then
                    amulet:AddTag("bramble_resistant")
                    _OnPick(inst, picker)
                    amulet:RemoveTag("bramble_resistant")
                else
                    _OnPick(inst, picker)
                end
            else
                if picker:HasTag("channelingpicker") then
                    onpickedchannel(inst, picker)
                else
                    _OnPick(inst, picker)
                end
            end
        end

        pickable.onpickedfn = OnPickNew
    end
end

env.AddPrefabPostInit("cactus", function(inst)
    if not TheWorld.ismastersim then
        return
    end

    CactusPostInit(inst)
end)

local function OasisCactusPostInit(inst)
    local pickable = inst.components.pickable
    if pickable then
        local _OnPick = pickable.onpickedfn
        local function onpickedchannel(inst, picker)
            inst.Physics:SetActive(false)
            inst.AnimState:PlayAnimation(inst.has_flower and "picked_flower" or "picked")
            inst.AnimState:PushAnimation("empty", true)
            if picker ~= nil then
                if inst.has_flower then
                    -- You get a cactus flower, yay.
                    local loot = SpawnPrefab("cactus_flower")
                    loot.components.inventoryitem:InheritMoisture(TheWorld.state.wetness, TheWorld.state.iswet)
                    if picker.components.inventory ~= nil then
                        picker.components.inventory:GiveItem(loot, nil, inst:GetPosition())
                    else
                        local x, y, z = inst.Transform:GetWorldPosition()
                        loot.components.inventoryitem:DoDropPhysics(x, y, z, true)
                    end
                end
            end
            inst.has_flower = false
        end

        local function OnPickNew(inst, picker)
            if (picker.components.inventory ~= nil and picker.components.inventory:EquipHasTag("lazy_forager")) then
                local amulet = picker.components.inventory:GetEquippedItem(EQUIPSLOTS.NECK)
                if amulet == nil then
                    amulet = picker.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY)
                end
                if amulet ~= nil and amulet.components.fueled ~= nil and not amulet.components.fueled:IsEmpty() then
                    amulet:AddTag("bramble_resistant")
                    _OnPick(inst, picker)
                    amulet:RemoveTag("bramble_resistant")
                else
                    _OnPick(inst, picker)
                end
            else
                if picker:HasTag("channelingpicker") then
                    onpickedchannel(inst, picker)
                else
                    _OnPick(inst, picker)
                end
            end
        end

        pickable.onpickedfn = OnPickNew
    end
end

env.AddPrefabPostInit("oasis_cactus", function(inst)
    if not TheWorld.ismastersim then
        return
    end

    OasisCactusPostInit(inst)
end)

local function MarshBushPostInit(inst)
    local pickable = inst.components.pickable
    if pickable then
        local _OnPick = pickable.onpickedfn
        local function onpickedchannel(inst, picker)
            inst.AnimState:PlayAnimation("picking")
            inst.AnimState:PushAnimation("picked", false)
        end

        local function OnPickNew(inst, picker)
            if (picker.components.inventory ~= nil and picker.components.inventory:EquipHasTag("lazy_forager")) then
                local amulet = picker.components.inventory:GetEquippedItem(EQUIPSLOTS.NECK)
                if amulet == nil then
                    amulet = picker.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY)
                end
                if amulet ~= nil and amulet.components.fueled ~= nil and not amulet.components.fueled:IsEmpty() then
                    amulet:AddTag("bramble_resistant")
                    _OnPick(inst, picker)
                    amulet:RemoveTag("bramble_resistant")
                else
                    _OnPick(inst, picker)
                end
            else
                if picker:HasTag("channelingpicker") then
                    onpickedchannel(inst, picker)
                else
                    _OnPick(inst, picker)
                end
            end
        end

        pickable.onpickedfn = OnPickNew
    end
end

env.AddPrefabPostInit("marsh_bush", function(inst)
    if not TheWorld.ismastersim then
        return
    end

    MarshBushPostInit(inst)
end)

local function PurpleAmuletPostInit(inst)
    local equippable = inst.components.equippable
    if equippable then
        local onequip_ = equippable.onequipfn
        local onunequip_ = equippable.onunequipfn
        local function OnNewEquip(inst, owner)
            if not owner:HasTag("fuelfarming") then
                owner:AddTag("fuelfarming")
            end
            onequip_(inst, owner)
        end

        local function OnNewUnEquip(inst, owner)
            if owner:HasTag("fuelfarming") then
                owner:RemoveTag("fuelfarming")
            end
            onunequip_(inst, owner)
        end

        equippable:SetOnEquip(OnNewEquip)
        equippable:SetOnUnequip(OnNewUnEquip)
    end
end

env.AddPrefabPostInit("purpleamulet", function(inst)
    if not TheWorld.ismastersim then
        return
    end

    PurpleAmuletPostInit(inst)
end)
