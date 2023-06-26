local function TransferLoot(inst)
	local klaus_sack = TheSim:FindFirstEntityWithTag("klaussacklock")
			
	if klaus_sack ~= nil and klaus_sack.components.inventory ~= nil then
		inst.components.inventory:TransferInventory(klaus_sack)
	end
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddNetwork()

	inst:AddTag("NOBLOCK")
	inst:AddTag("fx")
	inst:AddTag("krampus_middleman")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inventory")

	inst:DoTaskInTime(1, TransferLoot)
	
	inst:ListenForEvent("timerdone", function(inst, data)
		if data ~= nil and data.name == "klaussack_spawntimer" then
			TransferLoot(inst)
		end
	end, TheWorld)
	
	inst:WatchWorldState("cycles", TransferLoot)

	return inst
end

return Prefab("krampus_middleman_inventory", fn)