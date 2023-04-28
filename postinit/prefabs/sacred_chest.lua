local env = env
GLOBAL.setfenv(1, GLOBAL)


env.AddPrefabPostInit("sacred_chest", function(inst)
	-- There isn't a good way to edit the Metheus chest...
	-- So let's just make our own!
	local function ChestUpgrader(inst)
		local x, y, z = inst.Transform:GetWorldPosition()
		local UpgradedChestsNearby = TheSim:FindEntities(x, y, z, 1, {"um_sacred_chest"})
		if #UpgradedChestsNearby ~= nil then
			if #UpgradedChestsNearby < 1 then
				local SpawnUpgradedChest = SpawnPrefab("um_sacred_chest")
				if SpawnUpgradedChest ~= nil then
					SpawnUpgradedChest.Transform:SetPosition(inst.Transform:GetWorldPosition())
				end
				
			end
		end
	end
	
	inst:DoTaskInTime(1, ChestUpgrader)
	
	-- Then, turn the original invisible/uninteractable.
	-- Only if the config is turned on! This is in case of issues with the Metheus puzzle.
	if TUNING.DSTU.THE_COOLER_SACRED_CHEST then
		inst:Hide()
		inst.AnimState:SetMultColour(0,0,0,0)
		inst:AddTag("NOCLICK")
		inst:AddTag("NOBLOCK")
	else
		inst:Show()
		inst.AnimState:SetMultColour(1,1,1,1)
		inst:RemoveTag("NOCLICK")
		inst:RemoveTag("NOBLOCK")
	end
end)
