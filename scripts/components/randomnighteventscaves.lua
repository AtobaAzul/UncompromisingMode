--------------------------------------------------------------------------
--[[ Dependencies ]]
--------------------------------------------------------------------------
local easing = require("easing")

--------------------------------------------------------------------------
--[[ RandomNightEvents class definition ]]
--------------------------------------------------------------------------
return Class(function(self, inst)
assert(TheWorld.ismastersim, "RandomNightEvents should not exist on client")

self.inst = inst
local _targetplayer = nil
local _activeplayers = {}
local STRUCTURE_DIST = 20
self.wildevents = nil
self.baseevents = nil
self.caveevents = nil
self.totalrandomwildweight = nil
self.totalrandombaseweight = nil
self.totalrandomcaveweight = nil


--------------------------------
--RNE Player Scaling function
--------------------------------

local function PlayerScaling(player)
	local x, y, z = player.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x, 0, z, 50, {"player"}, {"playerghost"})

	if #ents >= 0 and #ents < 3 then
		--print("1")
		return 1
	elseif #ents >= 2 and #ents < 5 then
		--print("2")
		return 2
	elseif #ents >= 5 and #ents < 7 then
		--print("3")
		return 3
	elseif #ents > 6 then
		--print("4")
		return 4
	end
	
	print("default")
	return 1
end
	
--------------------------------
--RNE Fog Controller Functions Below
--------------------------------

local function StopFog(player)
	if player:HasTag("infog") then
		player:RemoveTag("infog")
--print("stopfog") 
	end
end

local function StartFog(player)
player.components.talker:Say(GetString(player, "ANNOUNCE_RNEFOG"))
	if not player:HasTag("infog") then
		player:AddTag("infog")
	--print("startfog") 
	end
end

local function StartFogAuto(player,x) --This should deactivate fog after 15 seconds or x time if you don't want to include StopFog(player)
player.components.talker:Say(GetString(player, "ANNOUNCE_RNEFOG"))
	if not player:HasTag("infog") then
		player:AddTag("infog")
--print("startfog") 
	end
	if x then
		player:DoTaskInTime(x,StopFog)
	else
		player:DoTaskInTime(15,StopFog)
	end
end

local function MultiFogAuto(player,x)
StartFogAuto(player,x)
local m,n,o = player.Transform:GetWorldPosition()
local fogtargets = TheSim:FindEntities(m,n,o, STRUCTURE_DIST, {"player"})
	for k,v in pairs(fogtargets) do
	StartFogAuto(v,x)
	end
end

----------------------------------------------------
--RNE despawning during day time effect
----------------------------------------------------

local function DayBreak(mob)
	
	if not mob:HasTag("shadow") and not mob:HasTag("shadowchesspiece") and not mob:HasTag("shadowteleporter") then
		local smoke = SpawnPrefab("thurible_smoke")
		if smoke ~= nil then
			smoke.entity:SetParent(mob.entity)
		end
	end
	
	mob.persists = false
	
	mob:WatchWorldState("isday", function() 
		local x, y, z = mob.Transform:GetWorldPosition()
		local despawnfx = SpawnPrefab("shadow_despawn")
		despawnfx.Transform:SetPosition(x, y, z)
		
		if mob.components.inventory ~= nil then
			mob.components.inventory:DropEverything(true)
		end
		
		mob:Remove()
	end)
end

----------------------------------------------------
--RNE list below
----------------------------------------------------
local function find_leif_spawn_target(item)
    return not item.noleif
        and item.components.growable ~= nil
        and item.components.growable.stage <= 3
end

local function spawn_leif(target)
    --assert(GetBuild(target).leif ~= nil)
    local leif = SpawnPrefab("leif")--only normal working
    leif.AnimState:SetMultColour(target.AnimState:GetMultColour())
    leif:SetLeifScale(target.leifscale)

    if target.chopper ~= nil then
        leif.components.combat:SuggestTarget(target.chopper)
    end

    local x, y, z = target.Transform:GetWorldPosition()
    target:Remove()

    leif.Transform:SetPosition(x, y, z)
    leif.sg:GoToState("spawn")
end

local function SpawnBirchNutters(player)
	local x, y, z = player.Transform:GetWorldPosition()
	player:DoTaskInTime(2 * math.random() * 0.3, function()
				
		local x1 = x + math.random(-10, 10)
		local z1 = z + math.random(-10, 10)
		local nutters = SpawnPrefab("birchnutdrake")
		if TheWorld.Map:IsPassableAtPoint(x1, 0, z1) then
			nutters.Transform:SetPosition(x1, y, z1)
			nutters:DoTaskInTime(0, function(nutters) DayBreak(nutters) end)
			nutters.components.combat:SetTarget(player)
		else
			SpawnBirchNutters(player)
		end
	end)
end

local function LeifAttack(player)
--print("leifattack")
local leiftime = 8 + math.random() * 3
MultiFogAuto(player,leiftime)

local days_survived = player.components.age ~= nil and player.components.age:GetAgeInDays()
    local target = FindEntity(player, TUNING.LEIF_MAXSPAWNDIST, find_leif_spawn_target, { "evergreens", "tree" }, { "leif", "stump", "burnt" })
    if target ~= nil then
		for k = 1, (days_survived <= 30 and 1) or math.random(days_survived <= 80 and 2 or 3) do
			print("targetfound")
			target.noleif = true
			target.chopper = player
			target.leifscale = 1 --GetGrowthStages(target)[target.components.growable.stage].leifscale or 1 Getting size is muck
				--assert(GetBuild(target).leif ~= nil)
			target:DoTaskInTime(leiftime, spawn_leif)
		end
	else
		player:DoTaskInTime(10 * math.random() + 3, function()
			local level = PlayerScaling(player)
			for i = 1, level + 2 do
				SpawnBirchNutters(player)
			end
			print("leifattackfailed")
		end)
	end
end

local function spawn_stumpling(target)
    local stumpling = SpawnPrefab("stumpling")

    if target.chopper ~= nil then
        stumpling.components.combat:SuggestTarget(target.chopper)
    end

    local x, y, z = target.Transform:GetWorldPosition()
    target:Remove()
	local effect = SpawnPrefab("round_puff_fx_hi")
	effect.Transform:SetPosition(x, y, z)
	stumpling:DoTaskInTime(0, function(nutters) DayBreak(nutters) end)
    stumpling.Transform:SetPosition(x, y, z)
    stumpling.sg:GoToState("hit")
end

local function StumpsAttack(player)
--print("myshins!")
local leiftime = 8 + math.random() * 3
MultiFogAuto(player,leiftime)

local days_survived = player.components.age ~= nil and player.components.age:GetAgeInDays()
	for k = 1, (days_survived <= 30 and 4) or math.random(days_survived <= 80 and 8 or 12) do
    local target = FindEntity(player, TUNING.LEIF_MAXSPAWNDIST, find_leif_spawn_target, {"stump","evergreen"}, { "leif","burnt","deciduoustree" })
		if target ~= nil then
			print("targetfound")
			target.noleif = true
			target.chopper = player--GetGrowthStages(target)[target.components.growable.stage].leifscale or 1 Getting size is muck
				--assert(GetBuild(target).leif ~= nil)
			target:DoTaskInTime(leiftime, spawn_stumpling)
		else
	
		player:DoTaskInTime(10 * math.random() + 3, function()
			local level = PlayerScaling(player)
			for i = 1, level do
				SpawnBirchNutters(player)
			end
			print("leifattackfailed")
		end)
		end
	end
end

local function SpawnShadowCharsFunction(player)
	local x, y, z = player.Transform:GetWorldPosition()
	local x1 = x + math.random(12, 16)
	local z1 = z + math.random(12, 16)
	local x2 = x - math.random(12, 16)
	local z2 = z - math.random(12, 16)
	
	local shadow = SpawnPrefab("swilson")
	if TheWorld.Map:IsPassableAtPoint(x1, 0, z1) then
		shadow.Transform:SetPosition(x1, y, z1)
		shadow:DoTaskInTime(0, function(shadow) DayBreak(shadow) end)
	end

end

local function SpawnShadowChars(player)
	--print("SpawnShadowChars")
	player:DoTaskInTime(5 + math.random(0,5), function()
			local x, y, z = player.Transform:GetWorldPosition()
			local day = TheWorld.state.cycles
			local extras = 0
			local level = PlayerScaling(player)
			if day > 30 then
			extras = extras + level
			end
			if day > 60 then
			extras = extras + 1 + level
			end
			local numshad = 1+extras
			for i = 1, numshad do
				player:DoTaskInTime(0.2 * i + math.random(4) * 0.3, function()
					SpawnShadowCharsFunction(player)
				end)
			end
	end)
end

local function SpawnMonkeysFunction(player)
	local x, y, z = player.Transform:GetWorldPosition()
	local x1 = x + math.random(12, 16)
	local z1 = z + math.random(12, 16)
	local x2 = x - math.random(12, 16)
	local z2 = z - math.random(12, 16)
	
	local monkey = SpawnPrefab("chimp")
	
	if math.random()>0.5 then
		if TheWorld.Map:IsPassableAtPoint(x1, 0, z1) then
			monkey.Transform:SetPosition(x1, y, z1)
			monkey:DoTaskInTime(0, function(monkey) DayBreak(monkey) end)
		else
			SpawnMonkeysFunction(player)
		end
	else
		if TheWorld.Map:IsPassableAtPoint(x2, 0, z2) then
			monkey.Transform:SetPosition(x2, y, z2)
			monkey:DoTaskInTime(0, function(monkey) DayBreak(monkey) end)
		else
			SpawnMonkeysFunction(player)
		end
	end

end

local function SpawnMonkeys(player)
	--print("SpawnMonkeys")
	player:DoTaskInTime(5 + math.random(0,5), function()
			local x, y, z = player.Transform:GetWorldPosition()
			local day = TheWorld.state.cycles
			local num_monkey = 3+math.floor(math.random()*4, 6)
			for i = 1, num_monkey do
				player:DoTaskInTime(0.2 * i + math.random(4) * 0.3, function()
					SpawnMonkeysFunction(player)
				end)
			end
	end)
end

local function SpawnWerePigsFunction(player)
	local x, y, z = player.Transform:GetWorldPosition()
	local x1 = x + math.random(12, 16)
	local z1 = z + math.random(12, 16)
	local x2 = x - math.random(12, 16)
	local z2 = z - math.random(12, 16)
	
	local pig = SpawnPrefab("pigman")
	
	if math.random()>0.5 then
		if TheWorld.Map:IsPassableAtPoint(x1, 0, z1) then
			local fx = SpawnPrefab("statue_transition_2")
			if fx ~= nil then
			fx.Transform:SetPosition(x1, 0, z1)
			fx.Transform:SetScale(.8, .8, .8)
			end
			fx = SpawnPrefab("statue_transition")
			if fx ~= nil then
				fx.Transform:SetPosition(x1, 0, z1)
				fx.Transform:SetScale(.8, .8, .8)
			end
			pig.Transform:SetPosition(x1, y, z1)
			if pig.components.werebeast ~= nil then
			pig.components.werebeast:SetWere(math.max(TUNING.SEG_TIME, TUNING.TOTAL_DAY_TIME * (1 - TheWorld.state.time)) + math.random() * TUNING.SEG_TIME)
			end
			if pig.components.combat ~= nil then
			pig.components.combat:SuggestTarget(player)
			end
			pig:DoTaskInTime(0, function(pig) DayBreak(pig) end)
		else
			SpawnWerePigsFunction(player)
		end
	else
		if TheWorld.Map:IsPassableAtPoint(x2, 0, z2) then
		local fx = SpawnPrefab("statue_transition_2")
			if fx ~= nil then
			fx.Transform:SetPosition(x2, 0, z2)
			fx.Transform:SetScale(.8, .8, .8)
			end
			fx = SpawnPrefab("statue_transition")
			if fx ~= nil then
				fx.Transform:SetPosition(x2, 0, z2)
				fx.Transform:SetScale(.8, .8, .8)
			end
			pig.Transform:SetPosition(x2, y, z2)
			if pig.components.werebeast ~= nil then
			pig.components.werebeast:SetWere(math.max(TUNING.SEG_TIME, TUNING.TOTAL_DAY_TIME * (1 - TheWorld.state.time)) + math.random() * TUNING.SEG_TIME)
			end
			if pig.components.combat ~= nil then
			pig.components.combat:SuggestTarget(player)
			end
			pig:DoTaskInTime(0, function(pig) DayBreak(pig) end)
		else
			SpawnWerePigsFunction(player)
		end
	end

end

local function SpawnWerePigs(player)
		print("SpawnWerePigs")
	player:DoTaskInTime(5 + math.random(0,5), function()
			local x, y, z = player.Transform:GetWorldPosition()
			local day = TheWorld.state.cycles
			local level = PlayerScaling(player)
			local num_pig = 3+level
			for i = 1, num_pig do
				player:DoTaskInTime(0.2 * i + math.random(4) * 0.3, function()
					SpawnWerePigsFunction(player)
				end)
			end
	end)
end

local function FireHungryGhostAttack(player)
	--print("ooooOOOOoooo")
	local ghosttime = 5 + math.random(0,5)
	MultiFogAuto(player,ghosttime)
	player:DoTaskInTime(ghosttime, function()
			local x, y, z = player.Transform:GetWorldPosition()
			local day = TheWorld.state.cycles
			local num_ghost = 3+math.floor(math.random()*4, 6)
			for i = 1, num_ghost do
				player:DoTaskInTime(0.2 * i + math.random(4) * 0.3, function()
					local ghost = SpawnPrefab("rneghost")
					ghost.Transform:SetPosition(x + math.random(-8,8), y, z + math.random(-8,8))
					ghost:DoTaskInTime(0, function(ghost) DayBreak(ghost) end)
				end)
			end
	end)
end

local function SpawnBats(player)
	--print("SpawnBats")
	
	local battime = 10 * math.random() * 2
	MultiFogAuto(player,battime)
	player:DoTaskInTime(battime, function()
		if TheWorld.state.cycles <= 10 then
			local x, y, z = player.Transform:GetWorldPosition()
			local day = TheWorld.state.cycles
			
			local level = PlayerScaling(player)
			local num_bats = 3 + level
			for i = 1, num_bats do
				player:DoTaskInTime(0.2 * i + math.random(4) * 0.3, function()
					local bat = SpawnPrefab("bat")
					bat.Transform:SetPosition(x + math.random(-8,8), y, z + math.random(-8,8))
					bat:PushEvent("fly_back")
				end)
			end
		else
			local x, y, z = player.Transform:GetWorldPosition()
			local day = TheWorld.state.cycles
			
			local level = PlayerScaling(player)
			local num_bats = math.min(2 + math.floor(day/35), 6) + level
			for i = 1, num_bats do
				player:DoTaskInTime(0.2 * i + math.random(4) * 0.3, function()
					local bat = SpawnPrefab("vampirebat")
					bat.Transform:SetPosition(x + math.random(-8,8), y, z + math.random(-8,8))
					bat:PushEvent("fly_back")
				end)
			end
		end
	end)
end

local function SpawnBaseBats(player)
	print("SpawnBaseBats")
	
	local battime = 10 * math.random() * 2
	MultiFogAuto(player,battime)
	player:DoTaskInTime(battime, function()
		if TheWorld.state.cycles <= 10 then
			local x, y, z = player.Transform:GetWorldPosition()
			local day = TheWorld.state.cycles
			
			local level = PlayerScaling(player)
			local num_bats = 3
			for i = 1 * level, num_bats do
				player:DoTaskInTime(0.2 * i + math.random(4) * 0.3, function()
					local bat = SpawnPrefab("bat")
					bat.Transform:SetPosition(x + math.random(-10,12), y, z + math.random(-10,12))
					bat:PushEvent("fly_back")
				end)
			end
		else
			local x, y, z = player.Transform:GetWorldPosition()
			local day = TheWorld.state.cycles
			
			local level = PlayerScaling(player)
			local num_bats = math.min(3 + math.floor(day/35), 6)
			for i = 1 * level, num_bats do
				player:DoTaskInTime(0.2 * i + math.random(4) * 0.3, function()
					local bat = SpawnPrefab("vampirebat")
					bat.Transform:SetPosition(x + math.random(-12,12), y, z + math.random(-12,12))
					bat:PushEvent("fly_back")
				end)
			end
		end
	end)
end

local function SpawnDroppersFunction(player)
	local x, y, z = player.Transform:GetWorldPosition()
	local x2 = x + math.random(-8, 8)
	local z2 = z + math.random(-8, 8)
	if TheWorld.Map:IsPassableAtPoint(x2, 0, z2) then
		local dropper = SpawnPrefab("spider_dropper")
		dropper.Transform:SetPosition(x2, 0, z2)
		dropper.sg:GoToState("dropper_enter")
		dropper.persists = false
	else
		SpawnDroppersFunction(player)
	end
end

local function SpawnDroppers(player)
	--print("SpawnDropper")
	player:DoTaskInTime(10 * math.random() * 2, function()
			local x, y, z = player.Transform:GetWorldPosition()
			local day = TheWorld.state.cycles
			
			local level = PlayerScaling(player)
			local num_droppers = 2 + level
			for i = 1, num_droppers do
				player:DoTaskInTime(0.2 * i + math.random(4) * 0.3, function()
					SpawnDroppersFunction(player)
				end)
			end
	end)
end

local function SpawnSkitts(player)
	--print("SpawnSkitts")
	local skitttime = 10 * math.random() * 2
	player:DoTaskInTime(skitttime, function()
			local x, y, z = player.Transform:GetWorldPosition()
			local num_skitts = 150
			for i = 1, num_skitts do
				player:DoTaskInTime(0.2 * i + math.random() * 0.3, function()
					local skitts = SpawnPrefab("shadowskittish")
					if TheWorld.state.isnight then
						skitts.Transform:SetPosition(x + math.random(-12,12), y, z + math.random(-12,12))
					end
				end)
			end
	end)
end

local function SpawnFissuresFunction(player)
	local x, y, z = player.Transform:GetWorldPosition()
	local x2 = x + math.random(-10, 10)
	local z2 = z + math.random(-10, 10)
	if TheWorld.Map:IsPassableAtPoint(x2, 0, z2) then
		SpawnPrefab("rnefissure").Transform:SetPosition(x2, 0, z2)
	else
		SpawnFissuresFunction(player)
	end
end

local function SpawnFissures(player)
	--print("SpawnFissures")
	local tillrne = 10 + math.random(10,15)
	MultiFogAuto(player,tillrne)
		player:DoTaskInTime(tillrne, function()
			local fissures = 2+math.floor(math.random()*3, 3)
			local chances = 1
			for i = chances, fissures do
				player:DoTaskInTime(0.2 * i + math.random(4) * 0.3, function()
					SpawnFissuresFunction(player)
				end)
			end
		end)
end

local function SpawnKrampus(player)
	--print("Thundering")
	
	if not TheWorld.state.israining then
		TheWorld:PushEvent("ms_forceprecipitation")
	end
	
	player:DoTaskInTime(10 * math.random() * 2, function()
			local x, y, z = player.Transform:GetWorldPosition()
			SpawnPrefab("krampuswarning_lvl3").Transform:SetPosition(player.Transform:GetWorldPosition())
			player:DoTaskInTime(0.6 * math.random(4) * 0.3, function()
				--local thunder = SpawnPrefab("thunder_far")
				--thunder.Transform:SetPosition(x + math.random(-10,10), y, z + math.random(-10,10))
				local level = 1 + PlayerScaling(player)
				TheWorld:PushEvent("ms_forcenaughtiness", { player = player, numspawns = level })
			end)
	end)
end

---------------------------------------------------------------
----------------------------THUNDER----------------------------
---------------------------------------------------------------

local function SpawnLightning(player)
	--print("THUNDERRRRRR")
	player:DoTaskInTime(10 * math.random() * 2, function()
			local x, y, z = player.Transform:GetWorldPosition()
			local lightnings = 1
			for i = 1, lightnings do
				player:DoTaskInTime(0.2 * i + math.random(4) * 0.3, function()
				local pos = Vector3(x + math.random(-10,10), y, z + math.random(-10,10))
				TheWorld:PushEvent("ms_sendlightningstrike", pos)
				end)
			end
	end)
end

local function SpawnThunderClose(player)
	--print("THUNDER")
	player:DoTaskInTime(10 * math.random() * 2, function()
			local x, y, z = player.Transform:GetWorldPosition()
			local thunders = 1
			for i = 1, thunders do
				player:DoTaskInTime(0.2 * i + math.random(4) * 0.3, function()
					--local thunder = SpawnPrefab("thunder_close")
					--thunder.Transform:SetPosition(x + math.random(-10,10), y, z + math.random(-10,10))
					SpawnPrefab("thunder_close")
					player:DoTaskInTime(10 * math.random(), SpawnLightning)
				end)
			end
	end)
end

local function SpawnThunderFar(player)
	--print("Thundering")
	
	if not TheWorld.state.israining then
		TheWorld:PushEvent("ms_forceprecipitation")
	end
	
	player:DoTaskInTime(10 * math.random() * 2, function()
			local x, y, z = player.Transform:GetWorldPosition()
			local thunders = math.random(15,20)
			for i = 1, thunders do
				player:DoTaskInTime(0.6 * i + math.random(6) * 0.3, function()
					--local thunder = SpawnPrefab("thunder_far")
					--thunder.Transform:SetPosition(x + math.random(-10,10), y, z + math.random(-10,10))
					SpawnPrefab("thunder_far")
					player:DoTaskInTime(10 * math.random(), SpawnThunderClose)
				end)
			end
	end)
end

---------------------------------------------------------------
-----------------------------OCEAN-----------------------------
---------------------------------------------------------------
local SQUID_MAX_NUMBERS = {
    ["new"] = 4,
    ["quarter"] = 3,
    ["half"] = 3,
    ["threequarter"] = 2,
    ["full"] = 1,
}

local function SpawnSquidFunction(player)
	local x, y, z = player.Transform:GetWorldPosition()
	local xoff = x + math.random(-12, 12)
	local zoff = z + math.random(-12, 12)
	
	local squid = SpawnPrefab("squid")
	local splash = SpawnPrefab("splash_green")
	
	if not TheWorld.Map:IsPassableAtPoint(xoff, 0, zoff) then
		squid.Transform:SetPosition(xoff, y, zoff)
		splash.Transform:SetPosition(xoff, y, zoff)
		squid:PushEvent("spawn")
		squid.components.combat:SetTarget(player)
		--squid:PushEvent("attacked", {attacker = player, damage = 0, weapon = nil})
	else
		SpawnSquidFunction(player)
	end
end

local function SpawnSquids(player)
	--print("Spawnsquids")
	local squidtime = 10 * math.random() * 2
	MultiFogAuto(player,squidtime)
	player:DoTaskInTime(squidtime, function()
		local x, y, z = player.Transform:GetWorldPosition()
		local day = TheWorld.state.cycles
		
		local level = PlayerScaling(player)
		for i = 1, 1 + level do
			player:DoTaskInTime(0.2 * i + math.random(4) * 0.3, function()
				SpawnSquidFunction(player)
			end)
		end
	end)
end

local function SpawnGnarwailFunction(player)
	local x, y, z = player.Transform:GetWorldPosition()
	local xoff = x + math.random(-12, 12)
	local zoff = z + math.random(-12, 12)
	
	local gnarwail = SpawnPrefab("gnarwail")
	local splash = SpawnPrefab("splash_green")
	
	if not TheWorld.Map:IsPassableAtPoint(xoff, 0, zoff) then
		gnarwail.Transform:SetPosition(xoff, y, zoff)
		splash.Transform:SetPosition(xoff, y, zoff)
		gnarwail.sg:GoToState("emerge")
		gnarwail.components.combat:SetTarget(player)
		gnarwail:DoTaskInTime(0, function(gnarwail) DayBreak(gnarwail) end)
		gnarwail:PushEvent("attacked", {attacker = player, damage = 0, weapon = nil})
		
		--shark.sg:GoToState("eat_pre")
	else
		SpawnGnarwailFunction(player)
	end
end

local function SpawnGnarwail(player)
	--print("Spawnsquids")
	local sharktime = 10 * math.random() * 2
	MultiFogAuto(player,sharktime)
	player:DoTaskInTime(sharktime, function()
		SpawnGnarwailFunction(player)
	end)
end

local function SpawnLightFlowersNFernsFunction(player)
	local x, y, z = player.Transform:GetWorldPosition()
	local x2 = x + math.random(-8, 8)
	local z2 = z + math.random(-8, 8)
	
	if TheWorld.Map:IsPassableAtPoint(x2, 0, z2) then
		if math.random() > 0.7 then
			local flowerdbl = SpawnPrefab("stalker_bulb_double")
			flowerdbl.Transform:SetPosition(x2, y, z2)
		else
			if math.random() > 0.7 then
				local flowersng = SpawnPrefab("stalker_bulb")
				flowersng.Transform:SetPosition(x2, y, z2)				
			else
				local fern = SpawnPrefab("stalker_fern")
				fern.Transform:SetPosition(x2, y, z2)
			end
		end
	else
		SpawnLightFlowersNFernsFunction(player)
	end
end	
											
local function SpawnLightFlowersNFerns(player)
	player:DoTaskInTime(5+math.random(5,10), function()
		local ents = 7+math.floor(math.random()*3)
		local chances = 1
		for i = chances, ents do
			player:DoTaskInTime(0.2 * i + math.random(4) * 0.3, function()
				SpawnLightFlowersNFernsFunction(player)
			end)
		end
	end)
end

local function MoonTear(player)
	if TheWorld.state.isfullmoon then
		--print("The Moon is Crying")
		local x, y, z = player.Transform:GetWorldPosition()
		player:DoTaskInTime(0.6 + math.random(4), function()
			local tear = SpawnPrefab("moon_tear_meteor")
			tear.Transform:SetPosition(x + math.random(-7,7), y, z + math.random(-7,7))
		end)
	end
end

local function ChessPiece(player)
	MultiFogAuto(player,10)
	if TheWorld.state.isnewmoon and TheWorld.state.cycles > 10 then
		--print("Shadows...")
		local x, y, z = player.Transform:GetWorldPosition()
		local chesscheck = math.random()
		
		local level = PlayerScaling(player)
		for i = 1, level do
			player:DoTaskInTime(10 + math.random(4), function()
				if chesscheck >= 0.66 then
					local piece = SpawnPrefab("shadow_bishop")
					piece.Transform:SetPosition(x + math.random(-7,7), y, z + math.random(-7,7))
					piece:DoTaskInTime(0, function(piece) DayBreak(piece) end)
				elseif chesscheck >= 0.33 and chesscheck < 0.66 then
					local piece = SpawnPrefab("shadow_rook")
					piece.Transform:SetPosition(x + math.random(-7,7), y, z + math.random(-7,7))
					piece:DoTaskInTime(0, function(piece) DayBreak(piece) end)
				else
					local piece = SpawnPrefab("shadow_knight")
					piece.Transform:SetPosition(x + math.random(-7,7), y, z + math.random(-7,7))
					piece:DoTaskInTime(0, function(piece) DayBreak(piece) end)
				end
			end)
		end
	end
end

local function SpawnPhonographFunction(player)
	local x, y, z = player.Transform:GetWorldPosition()
	local x2 = x + math.random(-15, 15)
	local z2 = z + math.random(-15, 15)
	
	if TheWorld.Map:IsPassableAtPoint(x2, 0, z2) then
		local phonograph = SpawnPrefab("charliephonograph")
		phonograph.Transform:SetPosition(x2, y, z2)
	else
		SpawnPhonographFunction(player)
	end
end	
											
local function SpawnPhonograph(player)
	player:DoTaskInTime(8, function()
		SpawnPhonographFunction(player)
	end)
end

local function SpawnShadowTeleporterFunction(player)
	local x, y, z = player.Transform:GetWorldPosition()
	local x2 = x + math.random(-8, 8)
	local z2 = z + math.random(-8, 8)
	
	if TheWorld.Map:IsPassableAtPoint(x2, 0, z2) then
		local teleporter = SpawnPrefab("shadow_teleporter")
		teleporter.Transform:SetPosition(x2, y, z2)
	else
		SpawnShadowTeleporterFunction(player)
	end
end	
											
local function SpawnShadowTeleporter(player)
	player:DoTaskInTime(10, function()
		SpawnShadowTeleporterFunction(player)
	end)
end

local function SpawnWalrusHuntFunction(player)
	local x, y, z = player.Transform:GetWorldPosition()
	local x2 = x + math.random(-40, 40)
	local z2 = z + math.random(-40, 40)
	if TheWorld.state.isnight then
		if TheWorld.Map:IsPassableAtPoint(x2, 0, z2) and #TheSim:FindEntities(x2, y, z2, 20, {"player"}) < 1 then
			local leader = SpawnPrefab("walrus")
			
			leader.Transform:SetPosition(x2, y, z2)
			leader:DoTaskInTime(0, function(leader) DayBreak(leader) end)
			if leader.components.sleeper ~= nil then
				leader:RemoveComponent("sleeper")
			end

			local level = PlayerScaling(player)
			for i = 1, level do
				if TheWorld.state.issummer then
					local companion = SpawnPrefab("firehound")
					companion.Transform:SetPosition(x2 + math.random(-1,1), y, z2 + math.random(-1,1))
					if not companion.components.follower then
						companion:AddComponent("follower")
					end
					companion.components.follower:SetLeader(leader)
					companion:DoTaskInTime(0, function(companion) DayBreak(companion) end)
				elseif TheWorld.state.iswinter then
					local companion = SpawnPrefab("icehound")
					companion.Transform:SetPosition(x2 + math.random(-1,1), y, z2 + math.random(-1,1))
					if not companion.components.follower then
						companion:AddComponent("follower")
					end
					companion.components.follower:SetLeader(leader)
					companion:DoTaskInTime(0, function(companion) DayBreak(companion) end)
				end
			end
		else
			player:DoTaskInTime(1, function(player) SpawnWalrusHuntFunction(player) end)
		end
	end
end	

local function SpawnWalrusHunt(player)
	player:DoTaskInTime(5+math.random(5,10), function()
		player:DoTaskInTime(0.2 * math.random(4) * 0.3, function()
			SpawnWalrusHuntFunction(player)
		end)
	end)
end

local function SpawnShadowTalker(player, mathmin, mathmax)
	if TheWorld.state.isnight or TheWorld.state.iscavenight then
		local randommin = mathmin or 5
		local randommax = mathmax or 10
		player:DoTaskInTime(1+math.random(randommin, randommax), function()
			local radius = 5 + math.random() * 10
			local theta = math.random() * 2 * PI
			local x, y, z = player.Transform:GetWorldPosition()
			local x1 = x + radius * math.cos(theta)
			local z1 = z - radius * math.sin(theta)
			local light = TheSim:GetLightAtPoint(x1, 0, z1)
			
			if light <= .1 and #TheSim:FindEntities(x1, 0, z1, 50, {"shadowtalker"}) < 1 then
				local ent = SpawnPrefab("shadowtalker")
				ent.Transform:SetPosition(x1, 0, z1)
				ent.speech = player
			end
			
			SpawnShadowTalker(player, 1, 1)
		end)
	end
end

---------------------------------------------------
---RNE list above
---------------------------------------------------
local function AddWildEvent(name, weight)
    if not self.wildevents then
        self.wildevents = {}
        self.totalrandomwildweight = 0
    end

    table.insert(self.wildevents, { name = name, weight = weight })
    self.totalrandomwildweight = self.totalrandomwildweight + weight
end

local function AddSecondaryWildEvent(name, weight)
    if not self.secondarywildevents then
        self.secondarywildevents = {}
        self.totalrandomsecondarywildweight = 0
    end

    table.insert(self.secondarywildevents, { name = name, weight = weight })
    self.totalrandomsecondarywildweight = self.totalrandomsecondarywildweight + weight
end

local function AddBaseEvent(name, weight)
    if not self.baseevents then
        self.baseevents = {}
        self.totalrandombaseweight = 0
    end

    table.insert(self.baseevents, { name = name, weight = weight })
    self.totalrandombaseweight = self.totalrandombaseweight + weight
end

local function AddCaveEvent(name, weight)
    if not self.caveevents then
        self.caveevents = {}
        self.totalrandomcaveweight = 0
    end

    table.insert(self.caveevents, { name = name, weight = weight })
    self.totalrandomcaveweight = self.totalrandomcaveweight + weight
end

local function AddSecondaryCaveEvent(name, weight)
    if not self.secondarycaveevents then
        self.secondarycaveevents = {}
        self.totalrandomsecondarycaveweight = 0
    end

    table.insert(self.secondarycaveevents, { name = name, weight = weight })
    self.totalrandomsecondarycaveweight = self.totalrandomsecondarycaveweight + weight
end

local function AddWinterEvent(name, weight)
    if not self.winterevents then
        self.winterevents = {}
        self.totalrandomwinterweight = 0
    end

    table.insert(self.winterevents, { name = name, weight = weight })
    self.totalrandomwinterweight = self.totalrandomwinterweight + weight
end

local function AddSpringEvent(name, weight)
    if not self.springevents then
        self.springevents = {}
        self.totalrandomspringweight = 0
    end

    table.insert(self.springevents, { name = name, weight = weight })
    self.totalrandomspringweight = self.totalrandomspringweight + weight
end

local function AddSummerEvent(name, weight)
    if not self.summerevents then
        self.summerevents = {}
        self.totalrandomsummerweight = 0
    end

    table.insert(self.summerevents, { name = name, weight = weight })
    self.totalrandomsummerweight = self.totalrandomsummerweight + weight
end

local function AddOceanEvent(name, weight)
    if not self.oceanevents then
        self.oceanevents = {}
        self.totalrandomoceanweight = 0
    end

    table.insert(self.oceanevents, { name = name, weight = weight })
    self.totalrandomoceanweight = self.totalrandomoceanweight + weight
end

local function AddFullMoonEvent(name, weight)
    if not self.fullmoonevents then
        self.fullmoonevents = {}
        self.totalrandomfullmoonweight = 0
    end

    table.insert(self.fullmoonevents, { name = name, weight = weight })
    self.totalrandomfullmoonweight = self.totalrandomfullmoonweight + weight
end

local function AddNewMoonEvent(name, weight)
    if not self.newmoonevents then
        self.newmoonevents = {}
        self.totalrandomnewmoonweight = 0
    end

    table.insert(self.newmoonevents, { name = name, weight = weight })
    self.totalrandomnewmoonweight = self.totalrandomnewmoonweight + weight
end

------------------------
--Inclusion and Tuning
------------------------
--Wild
AddWildEvent(SpawnBats,.5)
AddWildEvent(SpawnLightFlowersNFerns,.3)
AddWildEvent(SpawnSkitts,.5)
AddWildEvent(SpawnMonkeys,.2)
AddWildEvent(LeifAttack,.2)
AddWildEvent(SpawnPhonograph,.1)
AddWildEvent(SpawnShadowTeleporter,.2)
AddWildEvent(StumpsAttack,.3)
AddWildEvent(SpawnShadowTalker,.5)
--Secondary Wild
AddSecondaryWildEvent(SpawnBats,.5)
AddSecondaryWildEvent(SpawnLightFlowersNFerns,.3)
AddSecondaryWildEvent(SpawnSkitts,.5)
AddSecondaryWildEvent(StumpsAttack,.2)
AddSecondaryWildEvent(SpawnShadowTalker,.5)
--Base
AddBaseEvent(SpawnBaseBats,.4)
AddBaseEvent(SpawnFissures,.3)
AddBaseEvent(SpawnSkitts,.5)
AddBaseEvent(FireHungryGhostAttack,.4)
AddBaseEvent(SpawnShadowChars,.2)
AddBaseEvent(SpawnMonkeys,.1)
AddBaseEvent(LeifAttack,.1)
AddBaseEvent(SpawnPhonograph,.1)
AddBaseEvent(SpawnShadowTeleporter,.2)
AddBaseEvent(StumpsAttack,.3)
AddBaseEvent(SpawnShadowTalker,.5)
--Cave
AddCaveEvent(SpawnBats,.5)
AddCaveEvent(SpawnFissures,.2)
AddCaveEvent(SpawnDroppers,.6)
AddCaveEvent(SpawnShadowTalker,.4)
AddCaveEvent(SpawnPhonograph,.1)
AddCaveEvent(SpawnLightFlowersNFerns,.3)
--Secondary Cave
AddSecondaryCaveEvent(SpawnBats,.5)
AddSecondaryCaveEvent(SpawnDroppers,.6)
AddSecondaryCaveEvent(SpawnShadowTalker,.4)
AddSecondaryCaveEvent(SpawnLightFlowersNFerns,.3)
--Winter
AddWinterEvent(SpawnKrampus,.5)
AddWinterEvent(SpawnWalrusHunt,.5)
--Spring
AddSpringEvent(SpawnThunderFar,1)
--Summer
AddSummerEvent(SpawnWalrusHunt,1)
--Full Moon
AddFullMoonEvent(MoonTear,.5)
AddFullMoonEvent(SpawnWerePigs,.5)
--New Moon
AddNewMoonEvent(ChessPiece,.5)
AddNewMoonEvent(SpawnPhonograph,.2)
--Ocean
AddOceanEvent(SpawnSquids,.8)
AddOceanEvent(SpawnBats,.4)
--AddOceanEvent(FireHungryGhostAttack,.2)
AddOceanEvent(SpawnSkitts,.3)
AddOceanEvent(SpawnShadowTalker,.4)
--AddOceanEvent(SpawnGnarwail,.5)

------------------------
--Inclusion and Tuning
------------------------

local function DoBaseRNE(player)
print("done")
	if math.random() >= .6 and TheWorld.state.iswinter and TheWorld.state.isnight then
		if self.totalrandomwinterweight and self.totalrandomwinterweight > 0 and self.winterevents then
			local rnd = math.random()*self.totalrandomwinterweight
			for k,v in pairs(self.winterevents) do
				rnd = rnd - v.weight
				if rnd <= 0 then
				v.name(player)
				return
				end
			end
		end
	elseif math.random() >= .6 and TheWorld.state.isspring and TheWorld.state.isnight then
		if self.totalrandomspringweight and self.totalrandomspringweight > 0 and self.springevents then
			local rnd = math.random()*self.totalrandomspringweight
			for k,v in pairs(self.springevents) do
				rnd = rnd - v.weight
				if rnd <= 0 then
				v.name(player)
				return
				end
			end
		end
	elseif math.random() >= .6 and TheWorld.state.issummer and TheWorld.state.isnight then
		if self.totalrandomsummerweight and self.totalrandomsummerweight > 0 and self.summerevents then
			local rnd = math.random()*self.totalrandomsummerweight
			for k,v in pairs(self.summerevents) do
				rnd = rnd - v.weight
				if rnd <= 0 then
				v.name(player)
				return
				end
			end
		end
	elseif TheWorld.state.isnight then
		if self.totalrandombaseweight and self.totalrandombaseweight > 0 and self.baseevents then
			local rnd = math.random()*self.totalrandombaseweight
			for k,v in pairs(self.baseevents) do
				rnd = rnd - v.weight
				if rnd <= 0 then
				v.name(player)
				return
				end
			end
		end
	end
end

local function DoWildRNE(player)
	if math.random() >= .6 and TheWorld.state.iswinter and TheWorld.state.isnight then
		if self.totalrandomwinterweight and self.totalrandomwinterweight > 0 and self.winterevents then
			local rnd = math.random()*self.totalrandomwinterweight
			for k,v in pairs(self.winterevents) do
				rnd = rnd - v.weight
				if rnd <= 0 then
				v.name(player)
				return
				end
			end
		end
	elseif math.random() >= .6 and TheWorld.state.isspring and TheWorld.state.isnight then
		if self.totalrandomspringweight and self.totalrandomspringweight > 0 and self.springevents then
			local rnd = math.random()*self.totalrandomspringweight
			for k,v in pairs(self.springevents) do
				rnd = rnd - v.weight
				if rnd <= 0 then
				v.name(player)
				return
				end
			end
		end
	elseif math.random() >= .6 and TheWorld.state.issummer and TheWorld.state.isnight then
		if self.totalrandomsummerweight and self.totalrandomsummerweight > 0 and self.summerevents then
			local rnd = math.random()*self.totalrandomsummerweight
			for k,v in pairs(self.summerevents) do
				rnd = rnd - v.weight
				if rnd <= 0 then
				v.name(player)
				return
				end
			end
		end
	elseif TheWorld.state.isnight then
		if self.totalrandomwildweight and self.totalrandomwildweight > 0 and self.wildevents then
			local rnd = math.random()*self.totalrandomwildweight
			for k,v in pairs(self.wildevents) do
				rnd = rnd - v.weight
				if rnd <= 0 then
				v.name(player)
				return
				end
			end
		end
	end
end

local function DoSecondaryWildRNE(player)
	if TheWorld.state.isnight then
		if self.totalrandomsecondarywildweight and self.totalrandomsecondarywildweight > 0 and self.secondarywildevents then
			local rnd = math.random()*self.totalrandomsecondarywildweight
			for k,v in pairs(self.secondarywildevents) do
				rnd = rnd - v.weight
				if rnd <= 0 then
				v.name(player)
				return
				end
			end
		end
	end
end

local function DoOceanRNE(player)
	if math.random() >= .6 and TheWorld.state.isspring and TheWorld.state.isnight then
		if self.totalrandomspringweight and self.totalrandomspringweight > 0 and self.springevents then
			local rnd = math.random()*self.totalrandomspringweight
			for k,v in pairs(self.springevents) do
				rnd = rnd - v.weight
				if rnd <= 0 then
				v.name(player)
				return
				end
			end
		end
	elseif TheWorld.state.isnight then
		if self.totalrandomoceanweight and self.totalrandomoceanweight > 0 and self.oceanevents then
			local rnd = math.random()*self.totalrandomoceanweight
			for k,v in pairs(self.oceanevents) do
				rnd = rnd - v.weight
				if rnd <= 0 then
				v.name(player)
				return
				end
			end
		end
	end
end

local function DoFullMoonRNE(player)
	if TheWorld.state.isnight then
		if self.totalrandomfullmoonweight and self.totalrandomfullmoonweight > 0 and self.fullmoonevents then
			local rnd = math.random()*self.totalrandomfullmoonweight
			for k,v in pairs(self.fullmoonevents) do
				rnd = rnd - v.weight
				if rnd <= 0 then
				v.name(player)
				return
				end
			end
		end
	end
end

local function DoNewMoonRNE(player)
	if TheWorld.state.isnewmoon then
		if self.totalrandomnewmoonweight and self.totalrandomnewmoonweight > 0 and self.newmoonevents then
			local rnd = math.random()*self.totalrandomnewmoonweight
			for k,v in pairs(self.newmoonevents) do
				rnd = rnd - v.weight
				if rnd <= 0 then
				v.name(player)
				return
				end
			end
		end
	end
end

local function DoCaveRNE(player)
	if TheWorld.state.iscavenight then
		if self.totalrandomcaveweight and self.totalrandomcaveweight > 0 and self.caveevents then
			local rnd = math.random()*self.totalrandomcaveweight
			for k,v in pairs(self.caveevents) do
				rnd = rnd - v.weight
				if rnd <= 0 then
				v.name(player)
				return
				end
			end
		end
	end
end

local function DoSecondaryCaveRNE(player)
	if TheWorld.state.issecondarycavenight then
		if self.totalrandomsecondarycaveweight and self.totalrandomsecondarycaveweight > 0 and self.secondarycaveevents then
			local rnd = math.random()*self.totalrandomsecondarycaveweight
			for k,v in pairs(self.secondarycaveevents) do
				rnd = rnd - v.weight
				if rnd <= 0 then
				v.name(player)
				return
				end
			end
		end
	end
end

local function IsEligible(player)
	local area = player.components.areaaware
	return TheWorld.Map:IsVisualGroundAtPoint(player.Transform:GetWorldPosition())
			and area:GetCurrentArea() ~= nil 
			--and not area:CurrentlyInTag("nohasslers")
end

local function CheckPlayers()
    _targetplayer = nil
    if #_activeplayers == 0 then
        return
    end

	local playerlist = {}
	for _, v in ipairs(_activeplayers) do
		--if IsEligible(v) then
			table.insert(playerlist, v)
		--end
	end
	
		
	--shuffleArray(playerlist)
	if #playerlist == 0 then
		return
	end
	local player = playerlist[math.random(#playerlist)]
	local numStructures = 0
	
	local playerchancescaling = TUNING.DSTU.RNE_CHANCE - (#playerlist * 0.1)
	print(playerchancescaling)
	
	if TheWorld.state.cycles >= 5 and math.random() >= playerchancescaling or (TheWorld.state.isfullmoon and math.random() >= 0.5) or (TheWorld.state.isnewmoon and math.random() >= 0.75) then
		
		--for i, 1 in ipairs(playerlist) do  --try a base RNE
		if player ~= nil then
			local x,y,z = player.Transform:GetWorldPosition()--local x,y,z = v.Transform:GetWorldPosition()
			local ents = TheSim:FindEntities(x,y,z, STRUCTURE_DIST, {"structure"})
			numStructures = #ents
			
			if not IsEligible(player) then
				DoOceanRNE(player)
			elseif IsEligible(player) then
				if numStructures >= 4 then
					if TheWorld:HasTag("cave") then
						DoCaveRNE(player)
					else
						if TheWorld.state.isfullmoon then
							print("fullmoon")
							DoFullMoonRNE(player)--DoFullMoonRNE(v)
						elseif TheWorld.state.isnewmoon then
							print("newmoon")
							DoNewMoonRNE(player)--DoNewMoonRNE(v)
						else
							DoBaseRNE(player)--DoBaseRNE(v)
						end
					end
					print("found base")
				else
					if TheWorld:HasTag("cave") then
						DoCaveRNE(player)
					else
						if TheWorld.state.isfullmoon then
							print("fullmoon")
							DoFullMoonRNE(player)--DoFullMoonRNE(v)
						elseif TheWorld.state.isnewmoon then
							print("newmoon")
							DoNewMoonRNE(player)--DoNewMoonRNE(v)
						else
							DoWildRNE(player)--DoWildRNE(v)
						end
					end
					print("no find base")
				end
			else
				return
			end
		end
		
		local k = #playerlist
		
		for _, i in ipairs(playerlist) do
		
			if i ~= player and math.random() >= 0.5 then
				local x,y,z = i.Transform:GetWorldPosition()--local x,y,z = v.Transform:GetWorldPosition()
				local ents2 = TheSim:FindEntities(x,y,z, STRUCTURE_DIST, {"structure"})
				numStructures2 = #ents2
		
				if IsEligible(i) then
					if numStructures2 >= 4 then
						--nothing, not really accounting for other players in other bases but meh
					elseif TheWorld:HasTag("cave") then
						DoSecondaryCaveRNE(i)--DoWildRNE(v)
						print("no find base")
					end
				else
					return
				end
			end
		end
		
		
		
		
		
		
		
	end
end

local function TryRandomNightEvent(self)      --Canis said 20% chance each night to have a RNE, could possibly include a scaling effect later
	CheckPlayers()
end
--Keep these incase we need them later (probably)
local function OnPlayerJoined(src,player)
    for i, v in ipairs(_activeplayers) do
        if v == player then
            return
        end
    end
    table.insert(_activeplayers, player)

    --TryStartAttacks()
end

local function OnPlayerLeft(src,player)
    for i, v in ipairs(_activeplayers) do
        if v == player then
            table.remove(_activeplayers, i)
            --
			-- if this was the activetarget...cease the attack
			--if player == _targetplayer then
				--TargetLost()
			--end
            return
        end
    end
end
inst:ListenForEvent("ms_playerjoined", OnPlayerJoined)
inst:ListenForEvent("ms_playerleft", OnPlayerLeft)

--self:WatchWorldState("isnight", function() self.inst:DoTaskInTime(5, TryRandomNightEvent) end) --RNE could happen any night
self:WatchWorldState("iscavenight", function() self.inst:DoTaskInTime(5, TryRandomNightEvent) end)
--self:WatchWorldState("isnight", TryRandomNightEvent) --RNE could happen any night
end)