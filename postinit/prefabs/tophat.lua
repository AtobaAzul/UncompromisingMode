local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddPrefabPostInit("tophat", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	local _SetOnEquip = inst.components.equippable.onequipfn

	inst.components.equippable.onequipfn = function(inst, owner)
		if _SetOnEquip ~= nil then
			_SetOnEquip(inst, owner)
		end
		owner:AddTag("Funny_Words_Magic_Man")
	end

	local _SetOnUnEquip = inst.components.equippable.onunequipfn

	inst.components.equippable.onunequipfn = function(inst, owner)
		if _SetOnUnEquip ~= nil then
			_SetOnUnEquip(inst, owner)
		end
		owner:RemoveTag("Funny_Words_Magic_Man")
	end
end)
