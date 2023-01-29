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
	["chesspiece_stalker"] = true,
	["chesspiece_malbatross"] = true,
	["chesspiece_crabking"] = true,
	["chesspiece_guardianphase3"] = true,
	["chesspiece_eyeofterror"] = true,
	["chesspiece_twinsofterror"] = true,
	["chesspiece_beefalo"] = true,
	["chesspiece_carrat"] = true,
	["sunkenchest"] = true,
	["oceantreenut"] = true,
	["shell_cluster"] = true,
	["cavein_boulder"] = true,
	["glassspike_short"] = true,
	["glassspike_med"] = true,
	["glassspike_tall"] = true,
	["potatosack"] = true,

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
	["skeleton"] = true,
	["skeleton_player"] = true,
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
	
	["carrot_oversized_rotten"] = true,
	["onion_oversized_rotten"] = true,
	["garlic_oversized_rotten"] = true,
	["tomato_oversized_rotten"] = true,
	["potato_oversized_rotten"] = true,
	["pomegranate_oversized_rotten"] = true,
	["watermelon_oversized_rotten"] = true,
	["pumpkin_oversized_rotten"] = true,
	["pepper_oversized_rotten"] = true,
	["corn_oversized_rotten"] = true,
	["durian_oversized_rotten"] = true,
	["eggplant_oversized_rotten"] = true,
	["asparagus_oversized_rotten"] = true,
	["dragonfruit_oversized_rotten"] = true,
	
	["carrot_oversized_waxed"] = true,
	["onion_oversized_waxed"] = true,
	["garlic_oversized_waxed"] = true,
	["tomato_oversized_waxed"] = true,
	["potato_oversized_waxed"] = true,
	["pomegranate_oversized_waxed"] = true,
	["watermelon_oversized_waxed"] = true,
	["pumpkin_oversized_waxed"] = true,
	["pepper_oversized_waxed"] = true,
	["corn_oversized_waxed"] = true,
	["durian_oversized_waxed"] = true,
	["eggplant_oversized_waxed"] = true,
	["asparagus_oversized_waxed"] = true,
	["dragonfruit_oversized_waxed"] = true,
	
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
	["chesspiece_stalker"] = true,
	["chesspiece_malbatross"] = true,
	["chesspiece_crabking"] = true,
	["chesspiece_guardianphase3"] = true,
	["chesspiece_eyeofterror"] = true,
	["chesspiece_twinsofterror"] = true,
	["chesspiece_beefalo"] = true,
	["chesspiece_carrat"] = true,
	["chesspiece_kitcoon"] = true,
	["chesspiece_catcoon"] = true,
	["sunkenchest"] = true,
	["oceantreenut"] = true,
	["shell_cluster"] = true,
	["cavein_boulder"] = true,
	["glassspike_short"] = true,
	["glassspike_med"] = true,
	["glassspike_tall"] = true,
	["potatosack"] = true,
}
if TUNING.DSTU.IMPASSBLES then
	env.AddPrefabPostInitAny(function(inst)
		if IMPASSABLES[inst.prefab] and inst.Physics ~= nil then
			RemovePhysicsColliders(inst)
		end
		if IMPASSABLES_STATUES[inst.prefab] and inst.Physics ~= nil and inst.components.heavyobstaclephysics ~= nil then
		RemovePhysicsColliders(inst)
		inst.components.heavyobstaclephysics:SetRadius(0)
		end
	end)
end

env.AddPrefabPostInitAny(function(inst)
	if TheWorld and TheWorld.shard == inst then
		inst:AddComponent("shard_acidmushrooms")
	end
end)

--hornet; i dont care enough to know where to put this
env.AddReplicableComponent("hayfever")
env.AddReplicableComponent("adrenaline")

--I don't know where else to put this
env.AddPrefabPostInit("aphid", function(inst)
	if TestForIA() then
		inst:AddComponent("appeasement")
		inst.components.appeasement.appeasementvalue = TUNING.TOTAL_DAY_TIME
	end
end)

--for the super spawner tags
env.AddPrefabPostInitAny(function(inst)
	local old_OnSave = inst.OnSave
	inst.OnSave = function(inst, data)
		if inst.umss_tags then
			data.umss_tags = inst.umss_tags
		end

		if old_OnSave ~= nil then
			old_OnSave(inst, data)
		end
	end

	local old_OnLoad = inst.OnLoad
	inst.OnLoad = function(inst, data)
		if data ~= nil and data.umss_tags ~= nil then
			for k, v in ipairs(data.umss_tags) do
				inst:AddTag("umss_"..v)
			end
		end

		if old_OnLoad ~= nil then
			old_OnLoad(inst, data)
		end
	end
end)



