------------------------------------------------------------------------
-- Changes and additions to nightmare creature mechanics
------------------------------------------------------------------------

-----------------------------------------------------------------
-- Fuelweaver mind control screen overlay effect at 0 sanity
-----------------------------------------------------------------
-- Relevant: mindcontrolover.lua, mindcontroller.lua, stalker.lua, STALKER_ATRIUM, MindControlOver (playerhud.lua), AddDebuff("mindcontroller", "mindcontroller")
local function EnableInsanityOverlay(player)
    player:PushEvent("insanitylevel", 1)
    --todo: implement effect
end

local function DisableInsanityOverlay(player)
    --todo: remove effect
end

AddPlayerPostInit(function(inst)

	if not GLOBAL.TheWorld.ismastersim then
        return inst
    end
		
	if GLOBAL.TheWorld.ismastersim then
		inst:AddComponent("moreshadows")
	end
	
end)