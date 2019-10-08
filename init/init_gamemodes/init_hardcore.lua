------------------------------------------------------------------------------------------
-- Hardcore mode 
------------------------------------------------------------------------------------------
local UserCommands = GLOBAL.require("usercommands")

-----------------------------------------------------------------
-- No more rollbacks
-----------------------------------------------------------------
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

-----------------------------------------------------------------
-- Players cannot move on death, and revive is done now on bodies
-----------------------------------------------------------------
-- TODO: Fix this, ghosts still spawns
-- TODO: Bug on no movement
AddPrefabPostInit("skeleton_player", function (inst)
	local function OnInit(inst)
		if inst ~= nil and inst.AnimState ~= nil and inst.components.workable ~= nil then
			local character = inst.playername
			inst:AddComponent("locomotor")
			inst.AnimState:SetBank("wilson")
			--inst.AnimState:SetBuild(character) TODO: setbuild has a crash here, please check
			inst.AnimState:PlayAnimation("death2_idle")
			inst.components.workable.workable = false
		end
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
	
	if inst ~= nil then 
			if inst.components.trade == nil then 
				inst:AddComponent("trader")
			end
		inst.components.trader:SetAcceptTest(ShouldAcceptItem)
		inst.components.trader.onaccept = OnGetItem
	end
end)

-----------------------------------------------------------------
--Amulet auto-respawn if worn, like in DS
-----------------------------------------------------------------
--TODO: FIx this, not working
AddPrefabPostInit("amulet", function (inst)
	if inst ~= nil and inst.components.inventoryitem ~= nil then
		inst.components.inventoryitem.keepondeath = true
	end
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