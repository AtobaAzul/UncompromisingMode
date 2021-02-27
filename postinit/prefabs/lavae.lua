local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
local function ondeath(inst)
	local slime = SpawnPrefab("lavaeslime")
	if slime ~= nil then
		local x, y, z = inst.Transform:GetWorldPosition()
		slime.Transform:SetPosition(x, y, z)
	end
end

env.AddPrefabPostInit("lavae", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	inst:AddTag("insect")
	
    inst:ListenForEvent("death", ondeath)
end)