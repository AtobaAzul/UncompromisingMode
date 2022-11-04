local env = env
GLOBAL.setfenv(1, GLOBAL)
-------------------------

local function VetCurseItem(inst, item)
    if not TheWorld.ismastersim then
		return
	end
	
	if TUNING.DSTU.VETCURSE ~= "off" then
		inst:AddComponent("vetcurselootdropper")
		inst.components.vetcurselootdropper.loot = item
	end
end

env.AddPrefabPostInit("cherry_beequeen", function(inst) VetCurseItem(inst, "um_beegun_cherry") end)
env.AddPrefabPostInit("beequeen", function(inst) VetCurseItem(inst, "um_beegun") end)
env.AddPrefabPostInit("bearger", function(inst) VetCurseItem(inst, "beargerclaw") end)
env.AddPrefabPostInit("deerclops", function(inst) VetCurseItem(inst, "cursed_antler") end)
env.AddPrefabPostInit("crabking", function(inst) VetCurseItem(inst, "crabclaw") end)
env.AddPrefabPostInit("minotaur", function(inst) VetCurseItem(inst, "gore_horn_hat") end)
env.AddPrefabPostInit("dragonfly", function(inst) VetCurseItem(inst, "slobberlobber") end)
