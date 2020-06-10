local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
local function OnIsSummer(inst, issummer)
    if issummer and not inst.data.occupied then
		inst:DoTaskInTime(5, function(inst)
			SpawnPrefab("walrus_camp_summer").Transform:SetPosition(inst.Transform:GetWorldPosition())
			inst:Remove()
		end)
    end
end

env.AddPrefabPostInit("walrus_camp", function (inst)
    if not TheWorld.ismastersim then
		return
	end
	
	inst:WatchWorldState("issummer", OnIsSummer)
    if TheWorld.state.issummer then
        OnIsSummer(inst, true)
    end
end)