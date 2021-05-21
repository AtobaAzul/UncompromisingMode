local env = env
GLOBAL.setfenv(1, GLOBAL)
--[[local function testfortransformonload(inst)
    return TheWorld.state.isfullmoon
end]]
local function Revert(inst)
		local obj = SpawnPrefab("flower")
		local x, y, z = inst.Transform:GetWorldPosition()
			obj.Transform:SetPosition(x,y,z)
			inst:Remove()
end
local function Transform(inst)
		local obj = SpawnPrefab("flower_evil")
		local x, y, z = inst.Transform:GetWorldPosition()
			obj.Transform:SetPosition(x,y,z)
			obj:AddTag("transformed")
			obj:DoTaskInTime(math.random()*100+480, function(inst) Revert(inst) end)
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
	
	local _OnSave = inst.OnSave
	local _OnLoad = inst.OnLoad

	local function onsaveevil(inst, data)
		data.anim = inst.animname
		
		_OnSave(inst, data)
	end

	local function onloadevil(inst, data)
		if data and data.anim and data.transformed == true then
			inst:DoTaskInTime(0.1,Revert)
		end

		_OnLoad(inst, data)
	end
	
	inst.OnSave = onsaveevil
    inst.OnLoad = onloadevil
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