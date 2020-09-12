local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

-----------------------------------------------------------------
-- Remove pathing collision exploit by making objects noclip
-----------------------------------------------------------------
local IMPASSABLES = {
    ["chesspiece_pawn"] = true,
    ["chesspiece_rook"] = true,
    ["chesspiece_knight"] = true,
    ["chesspiece_bishop"] = true,
    ["chesspiece_muse"] = true,
    ["chesspiece_formal"] = true,
    ["chesspiece_deerclops"] = true,
    ["chesspiece_bearger"] = true,
    ["chesspiece_moosegoose"] = true,
    ["chesspiece_dragonfly"] = true,
    ["chesspiece_clayhound"] = true,
    ["chesspiece_claywarg"] = true,
    ["chesspiece_butterfly"] = true,
    ["chesspiece_anchor"] = true,
    ["chesspiece_moon"] = true,
	["chesspiece_minotaur"] = true,
	["chesspiece_toadstool"] = true,
	["chesspiece_beequeen"] = true,
	["chesspiece_klaus"] = true,
	["chesspiece_antlion"] = true,
	["chesspiece_ancientFuelweaver"] = true,
	["chesspiece_malbatross"] = true,
	["chesspiece_crabking"] = true,
    ["endtable"] = true,
    ["fossil_stalker"] = true, --Hornet: Why are we making the stalkers passable nocliped?
    ["homesign"] = true,
    ["statueharp"] = true,
    ["statue_marble"] = true,
    ["gravestone"] = true,
    ["arrowsign_post"] = true,
	["lureplant"] = true,
	["spiderden"] = true,
	["spiderden_2"] = true,
	["spiderden_3"] = true,
}

env.AddPrefabPostInitAny(function(inst)
    if IMPASSABLES[inst.prefab] and inst.Physics ~= nil then
        RemovePhysicsColliders(inst)
    end
    if TheWorld and TheWorld.shard == inst then
        inst:AddComponent("shard_acidmushrooms")
    end
end)

--hornet; i dont care enough to know where to put this
env.AddReplicableComponent("hayfever")







