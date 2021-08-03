local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddPrefabPostInit("walrus", function(inst)

	if not TheWorld.ismastersim then
		return
	end
	
SetSharedLootTable( 'um_walrus',
{
    {'meat',            1.00},
    {'blowdart_pipe',   1.00},
    {'walrushat',       0.50},
    {'walrus_tusk',     1.00},
})

inst.components.lootdropper:SetChanceLootTable('um_walrus')
end)

env.AddPrefabPostInit("cane", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	

    inst:AddComponent("fueled")
    inst.components.fueled:InitializeFuelLevel(TUNING.TOPHAT_PERISHTIME*1.5)
    inst.components.fueled:SetDepletedFn(--[[generic_perish]]inst.Remove)
    inst.components.fueled:SetFirstPeriod(TUNING.TURNON_FULL_FUELED_CONSUMPTION)
	inst.components.fueled.no_sewing = true
    MakeHauntableLaunch(inst)
	
	
	local _onequip = inst.components.equippable.onequipfn
	local _onunequip = inst.components.equippable.onunequipfn


local function onequip(inst, owner)
    if inst._owner ~= nil then
        inst:RemoveEventCallback("locomote", inst._onlocomote, inst._owner)
    end
    inst._owner = owner
    inst:ListenForEvent("locomote", inst._onlocomote, owner)
	_onequip(inst,owner)
end

local function onunequip(inst, owner)
    if inst._owner ~= nil then
        inst:RemoveEventCallback("locomote", inst._onlocomote, inst._owner)
        inst._owner = nil
    end

    if inst.components.fueled ~= nil then
        inst.components.fueled:StopConsuming()
    end
	_onunequip(inst,owner)
end

    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
	
    inst._onlocomote = function(owner)
        if owner.components.locomotor.wantstomoveforward then
            if not inst.components.fueled.consuming then
                inst.components.fueled:StartConsuming()
            end
        elseif inst.components.fueled.consuming then
            inst.components.fueled:StopConsuming()
        end
    end
--return inst
end)