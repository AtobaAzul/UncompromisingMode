local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

local function DisableThatStuff(inst)
	if ThePlayer ~= nil and ThePlayer.components.hayfever and not ThePlayer:HasTag("queenbeekilled") then
		--ThePlayer.components.hayfever:Disable()
		inst:PushEvent("addqueenbeekilledtag")
		
	end
end

env.AddPrefabPostInit("beequeen", function(inst)
	if not TheWorld.ismastersim then
		return
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