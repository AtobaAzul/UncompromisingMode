local env = env
GLOBAL.setfenv(1, GLOBAL)

local function spawngeyser(inst)
	if TheWorld.state.issummer and math.random() < 0.05 then
		SpawnPrefab("flamegeyser").Transform:SetPosition(inst.Transform:GetWorldPosition())
	end
end

env.AddPrefabPostInit("ground_chunks_breaking", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	--if TheWorld.state.issummer then
		--if math.random() < 0.05 then
			inst:DoTaskInTime(0.1, spawngeyser)
		--end
	--end
end)