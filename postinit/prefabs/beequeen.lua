local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

local function DisableThatStuff(inst)
	TheWorld:PushEvent("beequeenkilled")
		
	if TheWorld.net ~= nil then
		TheWorld.net:AddTag("queenbeekilled")
	end
	
	SendModRPCToShard(GetShardModRPC("UncompromisingSurvival", "Hayfever_Stop"), nil)
end

env.AddPrefabPostInit("beequeen", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	
    inst.Physics:CollidesWith(COLLISION.FLYERS)
	
	if inst.components.health ~= nil then
		inst.components.health:SetMaxHealth(TUNING.DSTU.BEEQUEEN_HEALTH)
	end
	
	
	inst:ListenForEvent("death", DisableThatStuff)
	
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