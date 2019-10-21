-----------------------------------------------------------------
-- Remove pathing collision exploit by making objects noclip
-----------------------------------------------------------------

local IMPASSABLES = 
{
    "chesspiece_pawn",
    "chesspiece_rook",
    "chesspiece_knight",
    "chesspiece_bishop",
    "chesspiece_muse",
    "chesspiece_formal",
    "chesspiece_deerclops",
    "chesspiece_bearger",
    "chesspiece_moosegoose",
    "chesspiece_dragonfly",
    "chesspiece_clayhound",
    "chesspiece_claywarg",
    "chesspiece_butterfly",
    "chesspiece_anchor",
    "chesspiece_moon",
    "endtable",
    "fossil_stalker",
    "homesign",
    "statueharp",
    "statue_marble",
    "gravestone",
    "arrowsign_post",
}

for k, v in pairs(IMPASSABLES) do
	AddPrefabPostInit(v, function(inst)
        if inst.Physics ~= nil then
            GLOBAL.RemovePhysicsColliders(inst)
        end
    end)
end

-----------------------------------------------------------------
-- Tooth traps burn (they are literally logs with teeth)
-----------------------------------------------------------------
AddPrefabPostInit("trap_teeth", function(inst)
	if not GLOBAL.TheWorld.ismastersim then
		return
	end

    GLOBAL.MakeSmallBurnable(inst)
    GLOBAL.MakeSmallPropagator(inst)
end)


AddPrefabPostInit("cave", function(inst)
	if not GLOBAL.TheWorld.ismastersim then
		return
	end
	
	inst:AddComponent("cavedeerclopsspawner")
end)

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








