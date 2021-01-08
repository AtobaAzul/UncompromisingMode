STRINGS = GLOBAL.STRINGS
STRINGS.NAMES.AMULET = "Lesser Life Amulet"
STRINGS.RECIPE_DESC.AMULET = "Protects you from death, while worn."

local env = env
GLOBAL.setfenv(1, GLOBAL)

--Classic DS Red Amulet revive (only when worn upon death), and health tick changes

local function healowner(inst, owner)
	if inst.components.fueled and inst.components.fueled.currentfuel == 0 then
		if inst.task ~= nil then
			inst.task:Cancel()
			inst.task = nil
		end
		
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
end

local function ontakefuel_red(inst)
    if inst.components.equippable:IsEquipped() then
	local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner or nil
	
		if inst.task == nil and owner ~= nil then
			inst.task = inst:DoPeriodicTask(10, healowner, nil, owner)
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
	
    inst:RemoveComponent("hauntable")
	
end)

env.AddPlayerPostInit(function(inst)
    
    local function amulet_resurrect(inst)
        for k, v in pairs(inst.components.inventory.equipslots) do
            if v.prefab == "amulet" then
                inst:DoTaskInTime(115/60, function(inst)
                    inst:PushEvent("respawnfromghost", { source = v })
                    v:DoTaskInTime(115/60, v.Remove)
                end)
            end
        end
    end

    inst:ListenForEvent("death", amulet_resurrect)    
end)