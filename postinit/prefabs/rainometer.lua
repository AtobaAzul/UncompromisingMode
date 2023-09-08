local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

local function getrevealtargetpos(inst, doer)
	local tornado = TheWorld:FindFirstEntityWithTag("um_tornado")

	if tornado == nil then
		return false, "MESSAGEBOTTLEMANAGER_NOT_FOUND"
	end
	
	local pos = tornado.Transform:GetPosition()
	local reason = "dunno lmao"
	
	return pos, reason
end

local function CheckForTornadoRevealers(inst)
	if not inst:HasTag("burnt") then
		local x, y, z = inst.Transform:GetWorldPosition()
		local players = FindPlayersInRange(x, y, z, 2)
		
		for i, v in pairs(players) do
			if v ~= nil then
				if v.um_tornado_revealer_task ~= nil then
					v.um_tornado_revealer_task:Cancel()
				end
				
				v.um_tornado_revealer_task = nil
				
				v.um_tornado_revealer_task = v:DoTaskInTime(2, function()
					v:RemoveTag("um_tornadotracker")
				end)
				
				v:AddTag("um_tornadotracker")
			end
		end
	end
end

local function OnActivate(inst, doer)
	CheckForTornadoRevealers(inst)
	local tornado = TheSim:FindFirstEntityWithTag("um_tornado")
	
	if tornado ~= nil and doer ~= nil and doer.player_classified ~= nil then
		local x, y, z = tornado.Transform:GetWorldPosition()
	
		doer.player_classified.revealmapspot_worldx:set(x)
		doer.player_classified.revealmapspot_worldz:set(z)
		doer.player_classified.revealmapspotevent:push()
	
	--[[
		local player = doer.player_classified
		local px, py, pz = doer.Transform:GetWorldPosition()

		if player ~= nil and player.HUD ~= nil then
			player.HUD.controls:ShowMap(Vector3(x, y, z))
		end]]
	else
		if doer ~= nil and doer.components.talker ~= nil then
			doer.components.talker:Say(GetString(doer, "ANNOUNCE_UM_NO_TORNADO"))
		end
	end

    inst.components.activatable.inactive = true
end

local function GetVerb(inst)
	return "UM_TORNADOTRACKER"
end

local function BurntCheck(inst)
	if inst:HasTag("burnt") then
		if inst.CheckTornadoTask ~= nil then
			inst.CheckTornadoTask:Cancel()
			inst.CheckTornadoTask = nil
		end
		
		inst:RemoveComponent("activatable")
		inst:RemoveComponent("mapspotrevealer")
	end
end

env.AddPrefabPostInit("rainometer", function(inst)
	inst.GetActivateVerb = GetVerb
	
	if not TheWorld.ismastersim then
		return
	end

    --inst:ListenForEvent("onbuilt", onbuilt)
    --inst:ListenForEvent("animover", StartCheckRain)
	
	inst:AddComponent("mapspotrevealer")
	inst.components.mapspotrevealer:SetGetTargetFn(getrevealtargetpos)
	--inst.components.mapspotrevealer:SetPreRevealFn(prereveal)

    inst:AddComponent("activatable")
    inst.components.activatable.OnActivate = OnActivate
    inst.components.activatable.inactive = true
	inst.components.activatable.quickaction = true
	
    inst:ListenForEvent("burntup", BurntCheck)
    inst:DoTaskInTime(0, BurntCheck)
	
	inst.CheckTornadoTask = inst:DoPeriodicTask(1, CheckForTornadoRevealers)
end)