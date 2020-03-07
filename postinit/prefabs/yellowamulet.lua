local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

-----------------------------------------------------------------
-- Magiluminesence doesn't break at 0%
-----------------------------------------------------------------

-----------------------------------------------------------------
--Try to initialise all functions locally outside of the post-init so they exist in RAM only once
-----------------------------------------------------------------
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
        local data =
        {
            prefab = inst.prefab,
            equipslot = inst.components.equippable.equipslot,
        }
        turnoff(inst, inst._owner)
        inst.components.inventoryitem.owner:PushEvent("torchranout", data)
    else
        turnoff(inst, inst._owner)
    end
end

local function ontakefuel(inst)
    if inst.components.equippable:IsEquipped() then
        turnon(inst, inst._owner)
    end
end

local function onequip(inst, owner)
    inst._owner = owner
    owner.AnimState:OverrideSymbol("swap_body", "torso_amulets", "yellowamulet")
    turnon(inst, owner)
end

local function onunequip(inst, owner)
    inst._owner = nil
    owner.AnimState:ClearOverrideSymbol("swap_body")
    turnoff(inst, owner)
end

local function GetShowItemInfo(inst)
    if inst.components.equippable.walkspeedmult == 1 and inst.components.equippable.dapperness == 0 then
        return "Sanity: +1.8", "Speed: +20%"
    end
end

local function _onownerequip(owner, data)
    if data.item ~= inst and
        (data.eslot == EQUIPSLOTS.BODY and data.item:HasTag("heavy") 
        ) then
        turnoff(inst, owner)
    end
end

env.AddPrefabPostInit("yellowamulet", function(inst)
    if not TheWorld.ismastersim then
        return
    end

    if inst.components.fueled then
        inst.components.fueled:SetDepletedFn(nofuel)
        inst.components.fueled:SetTakeFuelFn(ontakefuel)
    end

    if inst.components.equippable then
        inst.components.equippable:SetOnEquip(onequip)
        inst.components.equippable:SetOnUnequip(onunequip)
    end

	if inst.components.equippable then
		inst.components.equippable.walkspeedmult = 1
		inst.components.equippable.dapperness = 0
	end
	
    inst.GetShowItemInfo = GetShowItemInfo

    inst._onownerequip = _onownerequip
end)
