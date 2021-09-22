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
	["klaus_sack"] = true,
}
local IMPASSABLES_STATUES = {
	["carrot_oversized"] = true,
	["onion_oversized"] = true,
	["garlic_oversized"] = true,
	["tomato_oversized"] = true,
	["potato_oversized"] = true,
	["pomegranate_oversized"] = true,
	["watermelon_oversized"] = true,
	["pumpkin_oversized"] = true,
	["pepper_oversized"] = true,
	["corn_oversized"] = true,
	["durian_oversized"] = true,
	["eggplant_oversized"] = true,
	["asparagus_oversized"] = true,
	["dragonfruit_oversized"] = true,
	
	["chesspiece_hornucopia"] = true,
	["chesspiece_pipe"] = true,
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
	["sunkenchest"] = true,
	["oceantreenut"] = true,
	["shell_cluster"] = true,
}
env.AddPrefabPostInitAny(function(inst)
    if IMPASSABLES[inst.prefab] and inst.Physics ~= nil then
        RemovePhysicsColliders(inst)
    end
    if IMPASSABLES_STATUES[inst.prefab] and inst.Physics ~= nil and inst.components.heavyobstaclephysics ~= nil then
	RemovePhysicsColliders(inst)
	inst.components.heavyobstaclephysics:SetRadius(0)
	end
    if TheWorld and TheWorld.shard == inst then
        inst:AddComponent("shard_acidmushrooms")
    end
end)

--hornet; i dont care enough to know where to put this
env.AddReplicableComponent("hayfever")







