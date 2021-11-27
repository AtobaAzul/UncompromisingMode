local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
local function onequip(inst, owner)
        local skin_build = inst:GetSkinBuild()
        if skin_build ~= nil then
            owner:PushEvent("equipskinneditem", inst:GetSkinName())
            owner.AnimState:OverrideItemSkinSymbol("swap_hat", skin_build, "swap_hat", inst.GUID, "hat_feather")
        else
            owner.AnimState:OverrideSymbol("swap_hat", "hat_feather", "swap_hat")
        end
        owner.AnimState:Show("HAT")
        owner.AnimState:Show("HAIR_HAT")
        owner.AnimState:Hide("HAIR_NOHAT")
        owner.AnimState:Hide("HAIR")

        if owner:HasTag("player") then
            owner.AnimState:Hide("HEAD")
            owner.AnimState:Show("HEAD_HAT")
        end

        if inst.components.fueled ~= nil then
            inst.components.fueled:StartConsuming()
        end
    end

    local function onunequip(inst, owner)
        local skin_build = inst:GetSkinBuild()
        if skin_build ~= nil then
            owner:PushEvent("unequipskinneditem", inst:GetSkinName())
        end

        owner.AnimState:ClearOverrideSymbol("swap_hat")
        owner.AnimState:Hide("HAT")
        owner.AnimState:Hide("HAIR_HAT")
        owner.AnimState:Show("HAIR_NOHAT")
        owner.AnimState:Show("HAIR")

        if owner:HasTag("player") then
            owner.AnimState:Show("HEAD")
            owner.AnimState:Hide("HEAD_HAT")
        end

        if inst.components.fueled ~= nil then
            inst.components.fueled:StopConsuming()
        end
    end

local function feather_equip(inst, owner)
	onequip(inst, owner)
		
    local attractor = owner.components.birdattractor
    if attractor then
		attractor.spawnmodifier:SetModifier(inst, TUNING.BIRD_SPAWN_MAXDELTA_FEATHERHAT, "maxbirds")
		attractor.spawnmodifier:SetModifier(inst, TUNING.BIRD_SPAWN_DELAYDELTA_FEATHERHAT.MIN, "mindelay")
		attractor.spawnmodifier:SetModifier(inst, TUNING.BIRD_SPAWN_DELAYDELTA_FEATHERHAT.MAX, "maxdelay")
            
	local birdspawner = TheWorld.components.birdspawner
		if birdspawner ~= nil then
			birdspawner:ToggleUpdate(true)
		end
	end
end

local function feather_unequip(inst, owner)
	onunequip(inst, owner)

	local attractor = owner.components.birdattractor
	if attractor then
		attractor.spawnmodifier:RemoveModifier(inst)

	local birdspawner = TheWorld.components.birdspawner
		if birdspawner ~= nil then
			birdspawner:ToggleUpdate(true)
		end
	end
end

env.AddPrefabPostInit("featherhat", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	if inst.components.equippable ~= nil then
		local _OldOnEquip = inst.components.equippable.onequipfn

		inst.components.equippable.onequipfn = function(inst, owner)
			owner:AddTag("penguin_protection")
			
			if _OldOnEquip ~= nil then
			   _OldOnEquip(inst, owner)
			end
		end
		
		local _OldOnUnequip = inst.components.equippable.onunequipfn
		
		inst.components.equippable.onunequipfn = function(inst, owner)
			owner:RemoveTag("penguin_protection")
			
			if _OldOnUnequip ~= nil then
			   _OldOnUnequip(inst, owner)
			end
		end
	end
end)