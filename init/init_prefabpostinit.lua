--Zarklord: HORNET move your changes somewhere better, I want to delete these.
----------------------Cave exit and entrance locked in winter---------------------
--[[local function SnowedIn(inst, season) Hornet: if we wanna do this for some dumb reason
	if season == "winter" then
		inst:AddTag("snowedin")
		inst:RemoveTag("migrator")
	else
		inst:RemoveTag("snowedin")
		inst:AddTag("migrator")
	end 
end

local function GetStatus(inst)
    return (inst:HasTag("snowedin") and "SNOWED")
		or (inst.components.worldmigrator:IsActive() and "OPEN")
        or (inst.components.worldmigrator:IsFull() and "FULL")
        or nil
end

AddPrefabPostInit("cave_entrance_open", function(inst)
	if not GLOBAL.TheWorld.ismastersim then
		return
	end
	
	inst:WatchWorldState("season", SnowedIn)
	SnowedIn(inst, GLOBAL.TheWorld.state.season)
	
	inst.components.inspectable.getstatus = GetStatus
end)]]

--Update this list when adding files
local component_post = {
    --example:
    --"container",
}

local prefab_post = {
    "yellowamulet",
    "trap_teeth",
    "cave",
}

local stategraph_post = {
    --example:
    --"wilson",
}

local class_post = {
    --example:
    --"components/inventoryitem_replica",
    --"screens/playerhud",
}

modimport("postinit/sim")
modimport("postinit/any")
modimport("postinit/player")

for _,v in pairs(component_post) do
    modimport("postinit/components/"..v)
end

for _,v in pairs(prefab_post) do
    modimport("postinit/prefabs/"..v)
end

for _,v in pairs(stategraph_post) do
    modimport("postinit/stategraphs/SG"..v)
end

for _,v in pairs(class_post) do
    --These contain a path already, e.g. v= "widgets/inventorybar"
    modimport("postinit/".. v)
end