local env = env
GLOBAL.setfenv(1, GLOBAL)

local function OnPlayerNear(inst)
	if inst.task == nil then
		inst.task = inst:DoPeriodicTask(0.6, function(inst)
			if inst.components.fueled:GetPercent() < 0.7 and (TheWorld.state.isnight or TheWorld:HasTag("cave")) and not TheWorld.state.isfullmoon then
				local x, y, z = inst.Transform:GetWorldPosition()
			
				for i, v in ipairs(FindPlayersInRangeSq(x, y, z, 150, true)) do
					if v.components.sanity ~= nil and v.components.sanity:IsSane() then
						v.components.sanity:DoDelta(-1)
					
						local proj = SpawnPrefab("nightlightfuel")
						local x1, y1, z1 = v.Transform:GetWorldPosition()
						proj.Transform:SetPosition(x1, y1, z1)
						proj.components.projectile:Throw(v, inst, v)
					end
				end
			end
		end)
	end
end
	
local function OnPlayerFar(inst)
	if inst.task ~= nil then
		inst.task:Cancel()
	end
	
	inst.task = nil
end

env.AddPrefabPostInit("nightlight", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	inst:AddTag("funkylight")
	
	--inst.task = nil

	inst:AddComponent("playerprox")
    inst.components.playerprox:SetOnPlayerNear(OnPlayerNear)
    inst.components.playerprox:SetOnPlayerFar(OnPlayerFar)
    inst.components.playerprox:SetDist(20, 21)
    inst.components.playerprox:SetPlayerAliveMode(true)


end)