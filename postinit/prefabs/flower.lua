local env = env
GLOBAL.setfenv(1, GLOBAL)
--[[local function testfortransformonload(inst)
    return TheWorld.state.isfullmoon
end]]
local function Revert(inst)
print("code ran")
		local obj = SpawnPrefab("flower")
		local x, y, z = inst.Transform:GetWorldPosition()
			obj.Transform:SetPosition(x,y,z)
			inst:Remove()
end
local function Transform(inst)
print("code ran")
		local obj = SpawnPrefab("flower_evil")
		local x, y, z = inst.Transform:GetWorldPosition()
			obj.Transform:SetPosition(x,y,z)
			obj:DoTaskInTime(math.random()*100+800, function(inst) Revert(inst) end)
			inst:Remove()
end
local function OnFullMoon(inst, isfullmoon)
    if not inst:HasTag("withered") then
        if isfullmoon then
			inst:DoTaskInTime(math.random()*4+3, function(inst) 
			Transform(inst) 
            end)
        else
        end
    end
end
env.AddPrefabPostInit("flower", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	inst:WatchWorldState("isfullmoon", OnFullMoon)
    OnFullMoon(inst, TheWorld.state.isfullmoon)
	
--return inst
end)
env.AddPrefabPostInit("flower_evil", function(inst)
	if not TheWorld.ismastersim then
		return
	end
--return inst
end)
env.AddPrefabPostInit("flower_planted", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	inst:WatchWorldState("isfullmoon", OnFullMoon)
    OnFullMoon(inst, TheWorld.state.isfullmoon)
--return inst
end)