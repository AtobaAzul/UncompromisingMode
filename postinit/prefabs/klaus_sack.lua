local env = env
GLOBAL.setfenv(1, GLOBAL)
---------------------------------------

env.AddPrefabPostInit("klaus_sack", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	inst:AddComponent("inventory")
	
	local _OldOnUseKlausKey = inst.components.klaussacklock.onusekeyfn
	
    inst.components.klaussacklock:SetOnUseKey(function(inst, key, doer)
		if key.components.klaussackkey ~= nil and key.components.klaussackkey.truekey then
			inst.components.inventory:DropEverything()
		end
		
		return _OldOnUseKlausKey(inst, key, doer)
	end)
end)