local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

local function OnNightmarePhaseChanged(inst, phase)
	if phase == "warn" then
		if inst.trepspawners ~= nil then
			local chooseone = #inst.trepspawners > 1 and math.random(1, #inst.trepspawners) 
								or 1
								
			for i, v in ipairs(inst.trepspawners) do
				if v ~= nil and i == chooseone then
					v.components.childspawner:AddChildrenInside(1)
					v.components.childspawner:StartSpawning()
				end
			end
		end
	end
end

env.AddPrefabPostInit("cave", function(inst)
    if not TheWorld.ismastersim then
        return
    end
	
	inst.trepspawners = {}
	
	if TUNING.DSTU.TREPIDATIONS then
		inst:WatchWorldState("nightmarephase", OnNightmarePhaseChanged)
		OnNightmarePhaseChanged(inst, TheWorld.state.nightmarephase, true)
	end
end)