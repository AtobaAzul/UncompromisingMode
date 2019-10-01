------------------------------------------------------------------------------------------
-- Hardcore mode 
------------------------------------------------------------------------------------------
local UserCommands = GLOBAL.require("usercommands")

-- No more rollbacks
AddPrefabPostInit("world", function (inst)
	if GLOBAL.TheNet and GLOBAL.TheNet:GetIsServer() then
		local rollback = UserCommands.GetCommandFromName("rollback")
		if rollback ~= nil then
			rollback.serverfn = function(params, caller)
				if caller ~= nil then
					GLOBAL.TheNet:Announce("There is no turning back...")
				end
			end
		end
	end
end)

-- Players cannot move on death, and revive is done now on bodies
AddPrefabPostInit("skeleton_player", function (inst)
	local function OnInit(inst)
		local character = inst.playername
		inst:AddComponent("locomotor")
		inst.AnimState:SetBank("wilson")
		inst.AnimState:SetBuild(character)
		inst.AnimState:PlayAnimation("death2_idle")
		inst.components.workable.workable = false
	end
	
	local function ShouldAcceptItem(inst, item)
		return item.prefab == "reviver"
	end
	
	local function OnGetItem(inst, giver, item)
		local targets = {}
		for i, v in ipairs(GLOBAL.AllPlayers) do
			if item ~= nil and item.prefab == "reviver" then
				local playername = inst.playername
				if v.name == inst.playername then
					table.insert(targets, v)
				end
			else
				giver.components.talker:Say(GetString(inst, "ANNOUNCE_HARDCORE_RES"))
			end
		end
		if #targets > 0 then
			for i, v in ipairs(targets) do
				v:PushEvent("respawnfromghost", { source = item, user = giver })
				local fx = GLOBAL.SpawnPrefab("collapse_small")
				fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
				v.Transform:SetPosition(inst.Transform:GetWorldPosition())
				inst:Remove()
			end
		end
	end
	
	inst:DoTaskInTime(0, OnInit)
	
	inst:AddComponent("trader")
	inst.components.trader:SetAcceptTest(ShouldAcceptItem)
	inst.components.trader.onaccept = OnGetItem
end)

--Amulet auto-respawn if worn, like in DS
AddPrefabPostInit("amulet", function (inst)
	inst.components.inventoryitem.keepondeath = true
end)

AddPlayerPostInit(function (inst)
	local function checkamulet(inst)
		local item = inst.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.BODY)
		if item ~= nil and item.prefab == "amulet" then
			if item ~= nil then
				inst.sg.statemem.usedamulet = true
				inst:PushEvent("respawnfromghost", { source = item })
				item:Remove()
			end
		end
	end

	local function hardcoredeath(inst)
		inst:DoTaskInTime(5, checkamulet)
		if inst.components.trader ~= nil then
			inst.components.trader.enabled = false
		end
	end

	inst:ListenForEvent("death", hardcoredeath)
end)