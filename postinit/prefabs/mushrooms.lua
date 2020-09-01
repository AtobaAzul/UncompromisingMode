local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

env.AddPrefabPostInit("green_cap", function(inst)

	inst:AddTag("mushroom_fuel")
	inst:AddTag("green_mushroom_fuel")
	
	if not TheWorld.ismastersim then
		return
	end

end)

env.AddPrefabPostInit("red_cap", function(inst)

	inst:AddTag("mushroom_fuel")
	inst:AddTag("red_mushroom_fuel")
	
	if not TheWorld.ismastersim then
		return
	end

end)

env.AddPrefabPostInit("blue_cap", function(inst)

	inst:AddTag("mushroom_fuel")
	inst:AddTag("blue_mushroom_fuel")
	
	if not TheWorld.ismastersim then
		return
	end

end)

env.AddPrefabPostInit("spore_small", function(inst)

	inst:AddTag("mushroom_fuel")
	inst:AddTag("green_mushroom_fuel")
	
	if not TheWorld.ismastersim then
		return
	end

end)

env.AddPrefabPostInit("spore_medium", function(inst)

	inst:AddTag("mushroom_fuel")
	inst:AddTag("red_mushroom_fuel")
	
	if not TheWorld.ismastersim then
		return
	end

end)

env.AddPrefabPostInit("spore_tall", function(inst)

	inst:AddTag("mushroom_fuel")
	inst:AddTag("blue_mushroom_fuel")
	
	if not TheWorld.ismastersim then
		return
	end

end)

-----------
local function Revert(inst, prefab)
--print("code ran")
    local x, y, z = inst.Transform:GetWorldPosition()
    if #TheSim:FindEntities(x, 0, z, 3, {"canopy"}) > 0 then
        local obj = SpawnPrefab(prefab)
        obj.Transform:SetPosition(x,y,z)
        inst:Remove()
    end
end
local function Transform(inst, prefab, revert)
--print("code ran")
		local obj = SpawnPrefab(prefab)
		local x, y, z = inst.Transform:GetWorldPosition()
			obj.Transform:SetPosition(x,y,z)
			obj:AddTag("transformed")
			obj:DoTaskInTime(math.random()*100+480, function(inst) Revert(inst, revert) end)
			inst:Remove()
end
-----------
local TREESTATES =
{
    BLOOMING = "bloom",
    NORMAL = "normal",
}

-----------
local function loadred(inst)
if TheWorld:HasTag("forest") then
inst:DoTaskInTime(1, Revert(inst, "red_mushroom"))
end
end
local function OnFullMoonRed(inst, isfullmoon)
        if isfullmoon then
			inst:DoTaskInTime(math.random()*4+3, function(inst) 
			Transform(inst,"mushtree_medium","red_mushroom") 
            end)
        else
        end
end
env.AddPrefabPostInit("red_mushroom", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	inst:WatchWorldState("isfullmoon", OnFullMoonRed)
    OnFullMoonRed(inst, TheWorld.state.isfullmoon)
	
--return inst
end)
env.AddPrefabPostInit("mushtree_medium", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	inst.OnPreLoad= loadred
    --inst.OnLoad = onloadred
	--inst.OnSave = onsavered
--return inst
end)
----------------------

------------
local function loadgreen(inst)
if TheWorld:HasTag("forest") then
inst:DoTaskInTime(1, Revert(inst, "green_mushroom"))
end
end
local function OnFullMoonGreen(inst, isfullmoon)
        if isfullmoon then
			inst:DoTaskInTime(math.random()*4+3, function(inst) 
			Transform(inst,"mushtree_small","green_mushroom") 
            end)
        else
        end
end
env.AddPrefabPostInit("green_mushroom", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	inst:WatchWorldState("isfullmoon", OnFullMoonGreen)
    OnFullMoonGreen(inst, TheWorld.state.isfullmoon)

--return inst
end)

env.AddPrefabPostInit("mushtree_small", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	inst.OnPreLoad= loadgreen
    --inst.OnLoad = onloadgreen
	--inst.OnSave = onsavegreen
--return inst
end)
----------------

----------------
local function loadblue(inst)
if TheWorld:HasTag("forest") then
inst:DoTaskInTime(1, Revert(inst, "blue_mushroom"))
end
end
local function OnFullMoonBlue(inst, isfullmoon)
        if isfullmoon then
			inst:DoTaskInTime(math.random()*4+3, function(inst) 
			Transform(inst,"mushtree_tall","blue_mushroom") 
            end)
        else
        end
end
env.AddPrefabPostInit("blue_mushroom", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	inst:WatchWorldState("isfullmoon", OnFullMoonBlue)
    OnFullMoonBlue(inst, TheWorld.state.isfullmoon)
	
--return inst
end)


env.AddPrefabPostInit("mushtree_tall", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	inst.OnPreLoad= loadblue
    --inst.OnLoad = onloadblue
	--inst.OnSave = onsaveblue
--return inst
end)
