local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
local UpvalueHacker = require("tools/upvaluehacker")

local function DisableThatStuff(inst)
	TheWorld:PushEvent("beequeenkilled")
		
	if TheWorld.net ~= nil then
		TheWorld.net:AddTag("queenbeekilled")
	end
	
	SendModRPCToShard(GetShardModRPC("UncompromisingSurvival", "Hayfever_Stop"), nil)
end
env.AddPrefabPostInit("beeguard", function(inst)
	inst:AddTag("ignorewalkableplatforms")
end)

local function StompHandler(inst,data)
	TheNet:Announce(inst.stomprage)
	inst.stomprage = inst.stomprage + 0.25
	if data.attacker ~= nil and inst.stompready then
		if inst.components.combat.target ~= nil then
			if data.attacker ~= inst.components.combat.target then
				TheNet:Announce("Was attacked by multiple things")
				inst.stomprage = inst.stomprage + 1
			end
		end
		local x,y,z = data.attacker.Transform:GetWorldPosition()
		if TheWorld.Map:GetPlatformAtPoint(x, z) ~= nil then
			inst.stomprage = inst.stomprage + 10
		end
		if inst.stomprage > 20 then
			inst:ForceFacePoint(x,y,z)
			inst.stomprage = 0
			inst.stompready = false
			inst:DoTaskInTime(math.random(8,10),function(inst) inst.stompready = true end)
			inst.sg:GoToState("stomp")
		end
	end
end

local function StompRageCalmDown(inst)
	if inst.stomprage < 3 then
		inst.stomprage = 0
	else
		inst.stomprage = inst.stomprage - 3
	end
end


env.AddPrefabPostInit("beequeen", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	
    inst.Physics:CollidesWith(COLLISION.FLYERS)
	
	if inst.components.health ~= nil then
		inst.components.health:SetMaxHealth(TUNING.DSTU.BEEQUEEN_HEALTH)
	end
	
	inst:AddComponent("groundpounder") --Groundpounder is visual only
	inst.components.groundpounder.destroyer = true
	inst.components.groundpounder.damageRings = 0
    inst.components.groundpounder.destructionRings = 1
    inst.components.groundpounder.platformPushingRings = 2
    inst.components.groundpounder.numRings = 1
	inst:ListenForEvent("death", DisableThatStuff)
	
	inst.stomprage = 0
	inst.stompready = true
	inst:DoPeriodicTask(3, StompRageCalmDown)
	inst:ListenForEvent("attacked", StompHandler)
	
	
	-- No more honey when attacking
	local OnMissOther = UpvalueHacker.GetUpvalue(Prefabs.beequeen.fn, "OnMissOther")
	local OnAttackOther = UpvalueHacker.GetUpvalue(Prefabs.beequeen.fn, "OnAttackOther")
    inst:RemoveEventCallback("onattackother", OnAttackOther)
    inst:RemoveEventCallback("onmissother", OnMissOther)
end)

local function OnTagTimer(inst, data)
	if data.name == "hivegrowth" then
		TheWorld:PushEvent("beequeenrespawned")
		if TheWorld.net ~= nil then
			TheWorld.net:RemoveTag("queenbeekilled")
		end
		
		SendModRPCToShard(GetShardModRPC("UncompromisingSurvival", "Hayfever_Start"), nil)
	end
end

env.AddPrefabPostInit("beequeenhive", function(inst)
	if not TheWorld.ismastersim then
		return
	end

    inst:ListenForEvent("timerdone", OnTagTimer)
end)