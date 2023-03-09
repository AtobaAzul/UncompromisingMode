local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

env.AddPrefabPostInit("wormhole", function(inst) 
	if not TheWorld.ismastersim then
		return
	end
	
	if inst.components.teleporter ~= nil then
		local _OldOnActivate = inst.components.teleporter.onActivate
		inst.components.teleporter.onActivate = function(inst, doer)
			if doer:HasTag("troublemaker") then
				ProfileStatsSet("wormhole_used", true)
				AwardPlayerAchievement("wormhole_used", doer)

				local other = inst.components.teleporter.targetTeleporter
				if other ~= nil then
					DeleteCloseEntsWithTag({"WORM_DANGER"}, other, 15)
				end

				if doer.components.talker ~= nil then
					doer.components.talker:ShutUp()
				end
				if doer.components.sanity ~= nil and not doer:HasTag("nowormholesanityloss") and not inst.disable_sanity_drain then
					doer.components.sanity:DoDelta(-TUNING.SANITY_MED * 2)
				end
			else
				return _OldOnActivate(inst, doer)
			end
		end
	end
end)

