local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
local beardlordloot = { "beardhair", "beardhair", "monstermeat" }
local forced_beardlordloot = { "nightmarefuel", "beardhair", "beardhair", "monstermeat" }

local function IsForcedNightmare(inst)
	return inst.components.timer:TimerExists("forcenightmare")
end

local function IsCrazyGuy(guy)
	local sanity = guy ~= nil and guy.replica.sanity or nil
	return sanity ~= nil and sanity:IsInsanityMode() and
		sanity:GetPercentNetworked() <=
		(guy:HasTag("dappereffects") and TUNING.DAPPER_BEARDLING_SANITY or TUNING.BEARDLING_SANITY)
end

local function LootSetupFunction(lootdropper)
	local guy = lootdropper.inst.causeofdeath
	if IsForcedNightmare(lootdropper.inst) then
		-- forced beard lord
		lootdropper:SetLoot(forced_beardlordloot)
	elseif IsCrazyGuy(guy ~= nil and guy.components.follower ~= nil and guy.components.follower.leader or guy) then
		-- beard lord
		lootdropper:SetLoot(beardlordloot)
	else
		-- regular loot
		lootdropper.inst.components.lootdropper:AddChanceLoot("manrabbit_tail", .25)
		lootdropper.inst.components.lootdropper:AddRandomLoot("carrot", 1)
		lootdropper.inst.components.lootdropper:AddRandomLoot("meat", 1)
		lootdropper.numrandomloot = 1
	end
end

env.AddPrefabPostInit("bunnyman", function(inst)
	if not TheWorld.ismastersim then
		return
	end

	inst:AddTag("bunnyattacker")

	inst:RemoveComponent("lootdropper")
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLootSetupFn(LootSetupFunction)
	LootSetupFunction(inst.components.lootdropper)
end)
