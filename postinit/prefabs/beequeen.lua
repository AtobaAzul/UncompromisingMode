local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

local function DisableThatStuff(inst)
		--inst:PushEvent("addqueenbeekilledtag")
		TheWorld.net:AddTag("queenbeekilled")
end

env.AddPrefabPostInit("beequeen", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	
    inst.Physics:CollidesWith(COLLISION.FLYERS)
	
	if inst.components.health ~= nil then
		inst.components.health:SetMaxHealth(TUNING.DSTU.BEEQUEEN_HEALTH)
	end
	
    if inst.components.combat ~= nil then
		local function isnotbee(ent)
			if ent ~= nil and not ent:HasTag("bee") and not ent:HasTag("hive") then -- fix to friendly AOE: refer for later AOE mobs -Axe
				return true
			end
		end
        inst.components.combat:SetAreaDamage(TUNING.DEERCLOPS_AOE_RANGE/2, TUNING.DEERCLOPS_AOE_SCALE, isnotbee) -- you can edit these values to your liking -Axe
	end         
	inst:ListenForEvent("death", DisableThatStuff)
	
end)

local function OnTagTimer(inst, data)
	if data.name == "hivegrowth" then
		TheWorld.net:RemoveTag("queenbeekilled")
	end
end

env.AddPrefabPostInit("beequeenhive", function(inst)
	if not TheWorld.ismastersim then
		return
	end

    inst:ListenForEvent("timerdone", OnTagTimer)
end)