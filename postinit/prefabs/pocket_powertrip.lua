local env = env
GLOBAL.setfenv(1, GLOBAL)

local function ExplodeInventory(inst)
    if inst.components.container ~= nil then
        inst.components.container:DropEverything()
    end

    inst:Remove()
end

local function Folded(inst)
    if inst.components.container ~= nil then
        inst:DoTaskInTime(0,function(inst)
            local owner = inst.components.inventoryitem.owner

            if not inst.components.equippable:IsEquipped() and owner ~= nil then
                if #inst.components.container:FindItems(function(item) return item.components.inventoryitem ~= nil end) > 0 then
                    if owner.SoundEmitter ~= nil and TUNING.DSTU.POCKET_POWERTRIP == 1 then
                        owner.SoundEmitter:PlaySound("dontstarve/common/tool_slip")
                    end
                end
                if TUNING.DSTU.POCKET_POWERTRIP == 1 then
                    inst.components.container:DropEverything()
                end
            end
        end)
    end
end

env.AddPrefabPostInit("trunkvest_summer", function(inst)
    if not TheWorld.ismastersim then
        inst.OnEntityReplicated = function(inst)
            inst.replica.container:WidgetSetup("puffvest_big")
        end
        return inst
    end
    inst:AddComponent("container")
    inst.components.container:WidgetSetup("puffvest_big")
    if inst.components.equippable ~= nil then
        local OnEquip_old = inst.components.equippable.onequipfn

        inst.components.equippable.onequipfn = function(inst, owner)
            if inst.components.container ~= nil then
                inst.components.container:Open(owner)
            end
            if OnEquip_old ~= nil then
                OnEquip_old(inst, owner)
            end
        end

        local OnUnequip_old = inst.components.equippable.onunequipfn

        inst.components.equippable.onunequipfn = function(inst, owner)
            if inst.components.container ~= nil then
                inst.components.container:Close(owner)
            end
            if OnUnequip_old ~= nil then
                OnUnequip_old(inst, owner)
            end
        end
    end

    if TUNING.DSTU.POCKET_POWERTRIP == 2 then
        inst.components.inventoryitem.cangoincontainer = false
    end

    if inst.components.waterproofer ~= nil then
        inst.components.waterproofer:SetEffectiveness(0.3)
    end
	
    if inst.components.insulator ~= nil then
        inst.components.insulator:SetInsulation(120)
    end

    if inst.components.inventoryitem ~= nil then
        inst.components.inventoryitem:SetOnPutInInventoryFn(Folded)
    end

    if inst.components.fueled ~= nil then
        inst.components.fueled:SetDepletedFn(ExplodeInventory)
    end

	if EQUIPSLOTS["BACK"] ~= nil then
		if inst.components.equippable ~= nil then
			inst.components.equippable.equipslot = EQUIPSLOTS.BACK--:)))))))))))))))))))))))|
		end
    end

    inst:ListenForEvent("itemget", Folded)
    --return inst
end)

env.AddPrefabPostInit("trunkvest_winter", function(inst)
    if not TheWorld.ismastersim then
        inst.OnEntityReplicated = function(inst)
            inst.replica.container:WidgetSetup("puffvest")
        end
        return inst
    end

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("puffvest")

    if inst.components.equippable ~= nil then
        local OnEquip_old = inst.components.equippable.onequipfn

        inst.components.equippable.onequipfn = function(inst, owner)
            if inst.components.container ~= nil then
                inst.components.container:Open(owner)
            end
            if OnEquip_old ~= nil then
                OnEquip_old(inst, owner)
            end
        end

        local OnUnequip_old = inst.components.equippable.onunequipfn

        inst.components.equippable.onunequipfn = function(inst, owner)
            if inst.components.container ~= nil then
                inst.components.container:Close(owner)
            end
            if OnUnequip_old ~= nil then
                OnUnequip_old(inst, owner)
            end
        end
    end

    if TUNING.DSTU.POCKET_POWERTRIP == 2 then
        inst.components.inventoryitem.cangoincontainer = false
    end

    if inst.components.inventoryitem ~= nil then
        inst.components.inventoryitem:SetOnPutInInventoryFn(Folded)
    end

    if inst.components.fueled ~= nil then
        inst.components.fueled:SetDepletedFn(ExplodeInventory)
    end

	if EQUIPSLOTS["BACK"] ~= nil then
		if inst.components.equippable ~= nil then
			inst.components.equippable.equipslot = EQUIPSLOTS.BACK--:)))))))))))))))))))))))|
		end
    end

    inst:ListenForEvent("itemget", Folded)
    --return inst
end)

env.AddPrefabPostInit("reflectivevest", function(inst)
    if not TheWorld.ismastersim then
        inst.OnEntityReplicated = function(inst)
            inst.replica.container:WidgetSetup("reflvest")
        end
        return inst
    end

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("reflvest")

    if inst.components.equippable ~= nil then
        local OnEquip_old = inst.components.equippable.onequipfn

        inst.components.equippable.onequipfn = function(inst, owner)
            if inst.components.container ~= nil then
                inst.components.container:Open(owner)
            end
            if OnEquip_old ~= nil then
                OnEquip_old(inst, owner)
            end
        end

        local OnUnequip_old = inst.components.equippable.onunequipfn

        inst.components.equippable.onunequipfn = function(inst, owner)
            if inst.components.container ~= nil then
                inst.components.container:Close(owner)
            end
            if OnUnequip_old ~= nil then
                OnUnequip_old(inst, owner)
            end
        end
    end

    if TUNING.DSTU.POCKET_POWERTRIP == 2 then
        inst.components.inventoryitem.cangoincontainer = false
    end

    if inst.components.inventoryitem ~= nil then
        inst.components.inventoryitem:SetOnPutInInventoryFn(Folded)
    end

    if inst.components.fueled ~= nil then
        inst.components.fueled:SetDepletedFn(ExplodeInventory)
    end

    if EQUIPSLOTS["BACK"] ~= nil then
		if inst.components.equippable ~= nil then
			inst.components.equippable.equipslot = EQUIPSLOTS.BACK--:)))))))))))))))))))))))|
		end
    end

    inst:ListenForEvent("itemget", Folded)
    --return inst
end)

env.AddPrefabPostInit("premiumwateringcan",function(inst)
    if not TheWorld.ismastersim then
        inst.OnEntityReplicated = function(inst)
            inst.replica.container:WidgetSetup("frigginbirdpail")
        end
        return inst
    end

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("frigginbirdpail")
    --inst.components.inventoryitem.cangoincontainer = false
    if inst.components.equippable ~= nil then
        local onequip_ = inst.components.equippable.onequipfn
        local onunequip_ = inst.components.equippable.onunequipfn
        local function OnEquipMalb(inst, owner)
            if inst.components.container ~= nil then
                inst.components.container:Open(owner)
            end
            onequip_(inst, owner)
        end
        local function OnUnequipMalb(inst, owner)
            if inst.components.container ~= nil then
                inst.components.container:Close()
            end
            onunequip_(inst, owner)
        end
        inst.components.equippable:SetOnEquip(OnEquipMalb)
        inst.components.equippable:SetOnUnequip(OnUnequipMalb)
    end
    if inst.components.fillable ~= nil then
        local OnFill_ = inst.components.fillable.overrideonfillfn
        local function NewOnFill(inst, from_object)
            if inst.components.preserver == nil then
                inst:AddComponent("preserver")
            end
            inst.components.preserver:SetPerishRateMultiplier(TUNING.FISH_BOX_PRESERVER_RATE)
            OnFill_(inst, from_object)
        end
        inst.components.fillable.overrideonfillfn = NewOnFill
    end
    if inst.components.wateringcan ~= nil then
        local OnDeplete_ = inst.components.wateringcan.ondepletefn
        local function NewOnDeplete(inst)
            if
                inst.components.finiteuses ~= nil and inst.components.finiteuses:GetPercent() == 0 and
                    inst.components.preserver ~= nil
             then
                inst:RemoveComponent("preserver")
            end
            OnDeplete_(inst)
        end
        inst.components.wateringcan.ondepletefn = NewOnDeplete(inst)
    end
    local _OnLoad = inst.OnLoad
    local function OnLoad(inst, data)
        inst:DoTaskInTime(
            0,
            function(inst)
                if inst.components.finiteuses.current > 0 then
                    inst:AddComponent("preserver")
                    inst.components.preserver:SetPerishRateMultiplier(TUNING.FISH_BOX_PRESERVER_RATE)
                end
            end
        )
        _OnLoad(inst, data)
    end
    inst.OnLoad = OnLoad
end)
--[[env.AddPrefabPostInit("steel_sweater", function(inst)
	if not TheWorld.ismastersim then
		inst.OnEntityReplicated = function(inst) 
			inst.replica.container:WidgetSetup("puffvest") 
		end
        return inst
    end
    inst:AddComponent("container")
    inst.components.container:WidgetSetup("puffvest")
	
	--inst.components.inventoryitem.cangoincontainer = false
	if inst.components.equippable ~= nil then
		inst.components.equippable:SetOnEquip(onequip_steel)
		inst.components.equippable:SetOnUnequip(onunequip)
	end
	
	if inst.components.inventoryitem ~= nil then
		inst.components.inventoryitem:SetOnPutInInventoryFn(Folded)
	end
	
	if inst.components.fueled ~= nil then
		inst.components.fueled:SetDepletedFn(ExplodeInventory)
	end
	
	inst:ListenForEvent("itemget", Folded)
--return inst
end)]]
