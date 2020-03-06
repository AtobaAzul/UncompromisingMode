local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

local function onothertimerdone(inst, data)
	if data.name == "rage" then
			inst:DoTaskInTime(17, function(inst)
			--print("bingo")
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
			inst:PushEvent("firefallstart")
			end)
	end
end

env.AddPrefabPostInit("antlion", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	inst:ListenForEvent("timerdone", onothertimerdone)
	inst:AddComponent("firefallwarning")
	inst:AddComponent("explosiveresist")
end)