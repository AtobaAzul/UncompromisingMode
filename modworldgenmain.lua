GLOBAL.require("map/terrain")

if GetModConfigData("caveless") == false then

    AddTaskSetPreInitAny(function(tasksetdata)
    if tasksetdata.location ~= "forest" then
        return
    end

tasksetdata.set_pieces["ToadstoolArena"] = { 1, tasks={"Guarded Squeltch","Merms ahoy","Sane-Blocked Swamp","Squeltch","Swamp start","Tentacle-Blocked Spider Swamp",}}

end)

end
AddRoomPreInit("BGSavanna", function(room)					--This effects the outer areas of the Triple Mac and The Major Beefalo Plains
room.contents.distributepercent = .15
room.contents.distributeprefabs.trapdoor = 0.045
end)
AddRoomPreInit("Plain", function(room)						--This effects areas in the Major Beefalo Plains and the Grasslands next to the portal
room.contents.countprefabs=
									{
										trapdoor = function() return math.random(2,4) end,} --returned number for whole area should be multiplied between 2-4 due to multiple rooms
end)

--[[
("BarePlain", function(room)						If you want it to effect the desert area, uncomment this
room.contents.countprefabs=
									{
										trapdoor = function() return math.random(2,4) end,} --returned number for whole area should be multiplied between 2-4 due to multiple rooms
end)
--]]
--[[
	if GLOBAL.terrain.rooms.LightningBluffAntlion then
		GLOBAL.terrain.rooms.LightningBluffAntlion.contents.distributeprefabs.sandhill = 0.4
	end
	
	if GLOBAL.terrain.rooms.LightningBluffOasis then
	GLOBAL.terrain.rooms.LightningBluffOasis.contents.distributeprefabs.sandhill = 0.6
	end

	if GLOBAL.terrain.rooms.LightningBluffLightning then
		GLOBAL.terrain.rooms.LightningBluffLightning.contents.distributeprefabs.sandhill = 0.4
	end
	
	if GLOBAL.terrain.rooms.BGLightningBluff then
		GLOBAL.terrain.rooms.BGLightningBluff.contents.distributeprefabs.sandhill = 0.4
	end


	GLOBAL.terrain.filter.sandhill = {GLOBAL.GROUND.WOODFLOOR, GLOBAL.GROUND.CARPET, GLOBAL.GROUND.CHECKER, GLOBAL.GROUND.ROAD}
--]]

modimport("init/init_food/init_food_worldgen")
