
-----------------------------------------------------------------
-- Remove pathing collision exploit by making objects noclip
-----------------------------------------------------------------
--TODO: Remove lava and make larvae destroy walls

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
    "lava_pond",
    "homesign",
    "statueharp",
    "statue_marble",
    "gravestone",
    "arrowsign_post",
}

for k, v in pairs(IMPASSABLES) do
	AddPrefabPostInit(v, function(inst)
        if inst~= nil and inst.Physics ~= nil then
            GLOBAL.RemovePhysicsColliders(inst)
        end
    end)
end

-----------------------------------------------------------------
-- Tooth traps burn (they are literally logs with teeth)
-----------------------------------------------------------------
AddPrefabPostInit("trap_teeth", function(inst)
    if inst~=nil then
        GLOBAL.MakeSmallBurnable(inst)
        GLOBAL.MakeSmallPropagator(inst)
    end
end)