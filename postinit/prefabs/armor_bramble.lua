local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
local function OnCooldown(inst)
    inst._cdtask = nil
end

local function OnBlocked(owner, data, inst)
    if inst._cdtask == nil and data ~= nil and not data.redirected then
        --V2C: tiny CD to limit chain reactions
        inst._cdtask = inst:DoTaskInTime(.3, OnCooldown)

        SpawnPrefab("bramblefx_armor"):SetFXOwner(owner)

        if owner.SoundEmitter ~= nil then
            owner.SoundEmitter:PlaySound("dontstarve/common/together/armor/cactus")
        end
    end
end

local function SpikeAttack(inst)
	
	if inst.spiketask ~= nil then
		inst.spiketask:Cancel()
		inst.spiketask = nil
	end
	
	local owner = inst.components.inventoryitem.owner
	
	if owner ~= nil then
		local x, y, z = owner.Transform:GetWorldPosition()
		local nearbymonster = TheSim:FindEntities(x, y, z, 4.5, { "_combat" }, { "player", "companion", "abigail", "shadow" }, { "largecreature", "monster", "hostile", "scarytoprey", "epic" })
		
		if #nearbymonster > 0 then
			--V2C: tiny CD to limit chain reactions

			SpawnPrefab("bramblefx_armor"):SetFXOwner(owner)

			if inst.SoundEmitter ~= nil then
				inst.SoundEmitter:PlaySound("dontstarve/common/together/armor/cactus")
			end
			
			inst.components.armor:TakeDamage(5)
			
		end
		
		if inst.spikeattack == nil then
			inst.spiketask = inst:DoTaskInTime(2, function(inst) SpikeAttack(inst) end)
		end
	end
end

local function onequip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_body", "armor_bramble", "swap_body")

	if owner.spiketask == nil then
		owner.spiketask = owner:DoTaskInTime(2, function(owner) SpikeAttack(owner, inst) end)
	end
	
    inst:ListenForEvent("blocked", inst._onblocked, owner)
    inst:ListenForEvent("attacked", inst._onblocked, owner)
end

local function onunequip(inst, owner) 
    owner.AnimState:ClearOverrideSymbol("swap_body")
	
	if owner.spiketask ~= nil then
		owner.spiketask:Cancel()
		owner.spiketask = nil
	end
	
    inst:RemoveEventCallback("blocked", inst._onblocked, owner)
    inst:RemoveEventCallback("attacked", inst._onblocked, owner)
end

env.AddPrefabPostInit("armor_bramble", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	--[[
	local _SetOnEquip = inst.components.equippable.onequipfn

	inst.components.equippable.onequipfn = function(inst, owner)
		if _SetOnEquip ~= nil then
		   _SetOnEquip(inst, owner)
		end
		
		if inst.spiketask ~= nil then
			inst.spiketask:Cancel()
			inst.spiketask = nil
		end
	
		if inst.spiketask == nil then
			inst.spiketask = inst:DoTaskInTime(2, function(inst) SpikeAttack(inst) end)
		end
	end
	
	local _SetOnUnequip = inst.components.equippable.onunequipfn

	inst.components.equippable.onunequipfn = function(inst, owner)
		if inst.spiketask ~= nil then
			inst.spiketask:Cancel()
			inst.spiketask = nil
		end
		
		if _SetOnUnequip ~= nil then
		   _SetOnUnequip(inst, owner)
		end

	end
	
	if inst.components.armor ~= nil then
		inst.components.armor:InitCondition(TUNING.ARMORBRAMBLE * 2, TUNING.ARMORBRAMBLE_ABSORPTION)
	end]]
	
end)
