local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
local function onequip(inst, owner, symbol_override)
		owner.AnimState:OverrideSymbol("swap_hat", "hat_skeleton", "swap_hat")

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

local function skeleton_onequip(inst, owner)
        onequip(inst, owner)
		owner:AddTag("shadowdominant")
        if owner.components.sanity ~= nil then
            owner.components.sanity:SetInducedInsanity(inst, true)
        end
    end

    local function skeleton_onunequip(inst, owner)
        onunequip(inst, owner)
		owner:RemoveTag("shadowdominant")
        if owner.components.sanity ~= nil then
            owner.components.sanity:SetInducedInsanity(inst, false)
        end
    end
	
env.AddPrefabPostInit("skeletonhat", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
        inst.components.equippable:SetOnEquip(skeleton_onequip)
        inst.components.equippable:SetOnUnequip(skeleton_onunequip)
	
end)