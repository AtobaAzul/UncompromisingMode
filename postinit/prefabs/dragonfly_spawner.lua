local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

local function BossCheck(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, 50, { "epic" }, { "dragonfly" } )
	
	if #ents > 0 or TheWorld.state.issummer then
		if inst.components.childspawner ~= nil then
			inst.components.childspawner:StopSpawning()
		end
	else
		if inst.components.childspawner ~= nil then
			inst.components.childspawner:StartSpawning()
		end
	end

end

local function onnear(inst)
	if inst.task == nil then
		inst.task = inst:DoPeriodicTask(10, BossCheck)
	end
end

local function onfar(inst)
	inst.task = nil
end

env.AddPrefabPostInit("dragonfly_spawner", function (inst)
    if not TheWorld.ismastersim then
		return
	end
	
	inst.task = nil

    inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(50, 51) --set specific values
    inst.components.playerprox:SetOnPlayerNear(onnear)
    inst.components.playerprox:SetOnPlayerFar(onfar)
	
	inst:ListenForEvent("seasontick", function() 
		if TheWorld.state.issummer then
			inst.components.childspawner:StopSpawning()
		else
			inst.components.childspawner:StartSpawning()
		end 
	end)
end)