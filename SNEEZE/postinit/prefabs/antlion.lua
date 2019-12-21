local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
local function onothertimer(inst, data)
print("but does it even register")
    if data.name == "rage" then
		if ThePlayer ~= nil and ThePlayer.components.firerain then
			inst:DoTaskInTime(17, function(inst)
			inst:PushEvent("firefall")
			end)
			inst:DoTaskInTime(21, function(inst)
			inst:PushEvent("firefall")
			end)
			inst:DoTaskInTime(25, function(inst)
			inst:PushEvent("firefall")
			end)
			inst:DoTaskInTime(29, function(inst)
			inst:PushEvent("firefall")
			end)
			inst:DoTaskInTime(30, function(inst)
			ThePlayer.components.firerain:StartShower(2)
			end)
		end
    end
end
--[[
local function ontimerdone(inst, data)
    if data.name == "rage" then
		print("aigh")
        inst.components.sinkholespawner:StartSinkholes()

        inst.maxragetime = math.max(inst.maxragetime * TUNING.ANTLION_RAGE_TIME_FAILURE_SCALE, TUNING.ANTLION_RAGE_TIME_MIN)
        inst.components.timer:StartTimer("rage", inst.maxragetime)
		--if ThePlayer ~= nil and ThePlayer.components.firerain then
			inst:DoTaskInTime(17, function(inst)
			inst:PushEvent("firefall")
			end)
			inst:DoTaskInTime(21, function(inst)
			inst:PushEvent("firefall")
			end)
			inst:DoTaskInTime(25, function(inst)
			inst:PushEvent("firefall")
			end)
			inst:DoTaskInTime(29, function(inst)
			inst:PushEvent("firefall")
			end)
			inst:DoTaskInTime(30, function(inst)
			ThePlayer.components.firerain:StartShower(2)
			end)
		--end
    end
end
--]]
env.AddPrefabPostInit("antlion", function(inst)
--[[
	if not TheWorld.ismastersim then
	
        return inst
    end
	--]]
	inst:ListenForEvent("timerdone", onothertimer)
	
	inst:AddComponent("firefallwarning")
	inst:AddComponent("explosiveresist")



end)