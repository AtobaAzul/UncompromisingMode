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

local function healowner(inst, owner)
	if inst.components.fueled and inst.components.fueled.currentfuel == 0 then
		if inst.task ~= nil then
			inst.task:Cancel()
			inst.task = nil
		end
		
		inst:RemoveComponent("hauntable")
		return
	end
	
    if (owner.components.health and owner.components.health:IsHurt())
    and (owner.components.hunger and owner.components.hunger.current > 5 )then
        owner.components.health:DoDelta(3,false,"redamulet")
        owner.components.hunger:DoDelta(-TUNING.REDAMULET_CONVERSION)
        inst.components.fueled:DoDelta(-36)
    end
end

local function onequip_red(inst, owner)
    local skin_build = inst:GetSkinBuild()
    if skin_build ~= nil then
        owner:PushEvent("equipskinneditem", inst:GetSkinName())
        owner.AnimState:OverrideItemSkinSymbol("swap_body", skin_build, "swap_body", inst.GUID, "torso_amulets")
    else
        owner.AnimState:OverrideSymbol("swap_body", "torso_amulets", "redamulet")
    end
    
    inst.task = inst:DoPeriodicTask(10, healowner, nil, owner)
end

local function onunequip_red(inst, owner)
    if owner.sg == nil or owner.sg.currentstate.name ~= "amulet_rebirth" then
        owner.AnimState:ClearOverrideSymbol("swap_body")
    end
    
    local skin_build = inst:GetSkinBuild()
    if skin_build ~= nil then
        owner:PushEvent("unequipskinneditem", inst:GetSkinName())
    end
    
    if inst.task ~= nil then
        inst.task:Cancel()
        inst.task = nil
    end
end

local function nofuel_red(inst)
    if inst.task ~= nil then
        inst.task:Cancel()
        inst.task = nil
    end
	
    inst:RemoveComponent("hauntable")
end

local function ontakefuel_red(inst)
    if inst.components.equippable:IsEquipped() then
		if inst.task == nil then
			inst.task = inst:DoPeriodicTask(10, healowner, nil, owner)
		end
	end
	
	if not inst.components.hauntable then
		inst:AddComponent("hauntable")
    end
end

local function OnInit(inst)
	if inst ~= nil and inst.components.fueled ~= nil then
		if inst.components.fueled.currentfuel == 0 then
			if inst.components.hauntable ~= nil then
				inst:RemoveComponent("hauntable")
			end
		end
	end
end

env.AddPrefabPostInit("amulet", function(inst)
    if not TheWorld.ismastersim then
        return
    end

    inst:RemoveComponent("finiteuses")

	inst:AddComponent("fueled")
    inst.components.fueled:InitializeFuelLevel(TUNING.LARGE_FUEL * 4)
	inst.components.fueled.fueltype = FUELTYPE.NIGHTMARE
    inst.components.fueled:SetDepletedFn(nofuel_red)
    inst.components.fueled:SetTakeFuelFn(ontakefuel_red)
	inst.components.fueled.accepting = true

    if inst.components.equippable ~= nil then
        inst.components.equippable:SetOnEquip(onequip_red)
        inst.components.equippable:SetOnUnequip(onunequip_red)
    end
	
    inst:DoTaskInTime(0, OnInit)

    --inst._onownerequip = _onownerequip
end)
