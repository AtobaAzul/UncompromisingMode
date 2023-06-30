--[[
	THANK YOU ADM!!!
--]]

local HF_AMBIENT_SOUND =
{
	[WORLD_TILES.HOODEDFOREST] = {sound = "dontstarve/AMB/meadow", wintersound = "dontstarve/AMB/meadow_winter", springsound = "dontstarve/AMB/meadow", summersound = "dontstarve_DLC001/AMB/meadow_summer", rainsound = "dontstarve/AMB/meadow_rain"},--springsound = "dontstarve_DLC001/spring/springmeadowAMB", summersound = "dontstarve_DLC001/AMB/meadow_summer", rainsound = "dontstarve/AMB/meadow_rain"},
	[WORLD_TILES.ANCIENTHOODEDFOREST] = {sound = "dontstarve/AMB/meadow", wintersound = "dontstarve/AMB/meadow_winter", springsound = "dontstarve/AMB/meadow", summersound = "dontstarve_DLC001/AMB/meadow_summer", rainsound = "dontstarve/AMB/meadow_rain"},--springsound = "dontstarve_DLC001/spring/springmeadowAMB", summersound = "dontstarve_DLC001/AMB/meadow_summer", rainsound = "dontstarve/AMB/meadow_rain"},
    [WORLD_TILES.UM_FLOODWATER] = {sound = "dontstarve/AMB/caves/void", wintersound = "dontstarve/AMB/caves/void", springsound = "dontstarve/AMB/caves/void", summersound = "dontstarve/AMB/caves/void", rainsound = "dontstarve/AMB/caves/void"},
	--[[GROUND.HOODEDFOREST] = {sound = "dontstarve/AMB/chess", wintersound = "dontstarve/AMB/chess_winter", springsound = "dontstarve/AMB/chess", summersound = "dontstarve_DLC001/AMB/chess_summer", rainsound = "dontstarve_DLC001/AMB/chess_summer"},]]
    --[[GROUND.ANCIENTHOODEDFOREST] = {sound = "dontstarve/AMB/chess", wintersound = "dontstarve/AMB/chess_winter", springsound = "dontstarve/AMB/chess", summersound = "dontstarve_DLC001/AMB/chess_summer", rainsound = "dontstarve_DLC001/AMB/chess_summer"},]]
	--[[GROUND.HOODEDFOREST] = {sound = "dontstarve/AMB/grassland", wintersound = "dontstarve/AMB/forest_winter", springsound = "dontstarve/AMB/forest", summersound = "dontstarve_DLC001/AMB/forest_summer", rainsound = "dontstarve/AMB/forest_rain"},]]
	--[[GROUND.ANCIENTHOODEDFOREST] = {sound = "cherryforest/AMB/cherryambient", wintersound = "dontstarve/AMB/forest_winter", springsound = "cherryforest/AMB/cherryambient", summersound = "cherryforest/AMB/cherryambient", rainsound = "dontstarve/AMB/forest_rain"},]]
}

local function SoundUpvalue(fn, upvalue_name)
	i = 1
	while true do
	local val, v = GLOBAL.debug.getupvalue(fn, i)
	if not val then break end
		if val == upvalue_name then 
			return v, i
		end
		i = i + 1
	end
end

AddComponentPostInit("ambientsound", function(self)

	local AMBIENT_SOUNDS, SOUND = SoundUpvalue(self.OnUpdate, "AMBIENT_SOUNDS")
	if SOUND then
		for k, v in pairs(HF_AMBIENT_SOUND) do
			AMBIENT_SOUNDS[k] = HF_AMBIENT_SOUND[k]
		end
	end
	
end)