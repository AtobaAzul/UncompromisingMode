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
self.storedrne = {}
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
	
	--print("default")
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
	
	--[[if not mob:HasTag("shadow") and not mob:HasTag("shadowchesspiece") and not mob:HasTag("shadowteleporter") then
		local smoke = SpawnPrefab("thurible_smoke")
		if smoke ~= nil then
			smoke.entity:SetParent(mob.entity)
		end
	end]]
	
	mob.AnimState:SetHaunted(true)
	
	mob.AnimState:SetMultColour(0, 0, 0, 0.6)
	
	mob.persists = false
	
	mob:AddTag("soulless")
    mob:AddTag("swilson") 
	mob:AddTag("nightmarecreature")
	mob:AddTag("shadow")
	
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
local function SkeleBros(player)
MultiFogAuto(player,10)
player:DoTaskInTime(8,function(player)
local CHANNELER_SPAWN_RADIUS = 30
    if player.components.health:IsDead() then
        return
    end
	for i = 1,3 do
	local x, y, z = player.Transform:GetWorldPosition()
    local angle = math.random() * 2 * PI
    x = x + CHANNELER_SPAWN_RADIUS * math.cos(angle)
    z = z + CHANNELER_SPAWN_RADIUS * math.sin(angle)
    if TheWorld.Map:IsAboveGroundAtPoint(x, 0, z) then
        local skele = SpawnPrefab("rneskeleton")
		if skele.components.combat ~= nil then
		skele.components.combat:SuggestTarget(player)
		end
        skele.Transform:SetPosition(x, 0, z)
	else
	CHANNELER_SPAWN_RADIUS = CHANNELER_SPAWN_RADIUS/2
    end
	end
end)
end

local function TrySpawnStanton(player)
local x,y,z = player.Transform:GetWorldPosition()
x = x+math.random(-4,4)
z = z+math.random(-4,4)
if TheWorld.Map:IsAboveGroundAtPoint(x,y,z) then 
	SpawnPrefab("stanton").Transform:SetPosition(x,y,z)
else
	TrySpawnStanton(player)
end
end

local function Stanton(player)
MultiFogAuto(player,10)
player:DoTaskInTime(8,function(player)
	TrySpawnStanton(player)
end)
end

local function SpawnGnomes(player)
	local x, y, z = player.Transform:GetWorldPosition()
	if TheWorld.state.isnight then
		player:DoTaskInTime(2 * math.random() * 0.3, function()
					
			local x1 = x + math.random(-10, 10)
			local z1 = z + math.random(-10, 10)
			local gnomes = SpawnPrefab("gnome_organizer")
			if TheWorld.Map:IsPassableAtPoint(x1, 0, z1) then
				gnomes.Transform:SetPosition(x1, y, z1)
			else
				player:DoTaskInTime(0.1, function(player) SpawnGnomes(player) end)
			end
		
		end)
	end
end

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
	if TheWorld.state.isnight then
		player:DoTaskInTime(2 * math.random() * 0.3, function()
					
			local x1 = x + math.random(-10, 10)
			local z1 = z + math.random(-10, 10)
			--local nutters = math.random() >= 0.7 and SpawnPrefab("nightmarebeak") or SpawnPrefab("crawlingnightmare")
			local nutters = SpawnPrefab("birchnutdrake")
			
			if TheWorld.Map:IsPassableAtPoint(x1, 0, z1) then
				nutters.Transform:SetPosition(x1, y, z1)
				nutters:DoTaskInTime(0, function(nutters) DayBreak(nutters) end)
				nutters.components.combat:SetTarget(player)
			else
				player:DoTaskInTime(0.1, function(player) SpawnBirchNutters(player) end)
			end
		end)
	end
end

local function SpawnEyePlants(player)
	local x, y, z = player.Transform:GetWorldPosition()
	if TheWorld.state.isnight then
		player:DoTaskInTime(2 * math.random() * 0.3, function()
					
			local x1 = x + math.random(-10, 10)
			local z1 = z + math.random(-10, 10)
			local eyeplant = SpawnPrefab("rneshadowskittish")
			if TheWorld.Map:IsPassableAtPoint(x1, 0, z1) then
				eyeplant.Transform:SetPosition(x1, y, z1)
				eyeplant:DoTaskInTime(0, function(eyeplant) DayBreak(eyeplant) end)
				--eyeplant.sg:GoToState("spawn")
				--eyeplant:AddTag("planted")
			else
				player:DoTaskInTime(0.1, function(player) SpawnEyePlants(player) end)
			end
		end)
	end
end

local function LeifAttack(player)
print("leifattack")
local leiftime = 8 + math.random() * 3

	local days_survived = player.components.age ~= nil and player.components.age:GetAgeInDays()
    local target = FindEntity(player, TUNING.LEIF_MAXSPAWNDIST, find_leif_spawn_target, { "evergreens", "tree" }, { "leif", "stump", "burnt" })
    if target ~= nil and days_survived >= 30 then
		MultiFogAuto(player,leiftime)
		for k = 1, (days_survived <= 50 and 1) or math.random(days_survived <= 80 and 2 or 3) do
			--print("targetfound")
			target.noleif = true
			target.chopper = player
			target.leifscale = 1 --GetGrowthStages(target)[target.components.growable.stage].leifscale or 1 Getting size is muck
				--assert(GetBuild(target).leif ~= nil)
			target:DoTaskInTime(leiftime, spawn_leif)
		end
	else
		player:DoTaskInTime(5 + (10 * math.random() + 3), function()
			local level = PlayerScaling(player)
			for i = 1, level + 2 do
				player:DoTaskInTime(1 + i, function()
					SpawnBirchNutters(player)
				end)
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
print("myshins!")
local leiftime = 8 + math.random() * 3
MultiFogAuto(player,leiftime)

local days_survived = player.components.age ~= nil and player.components.age:GetAgeInDays()
	for k = 1, (days_survived <= 30 and 4) or math.random(days_survived <= 80 and 8 or 12) do
    local target = FindEntity(player, TUNING.LEIF_MAXSPAWNDIST, find_leif_spawn_target, {"stump","evergreen"}, { "leif","burnt","deciduoustree" })
		if target ~= nil then
			--print("targetfound")
			target.noleif = true
			target.chopper = player--GetGrowthStages(target)[target.components.growable.stage].leifscale or 1 Getting size is muck
				--assert(GetBuild(target).leif ~= nil)
			target:DoTaskInTime(leiftime, spawn_stumpling)
		else
	
		player:DoTaskInTime(10 * math.random() + 3, function()
			local level = PlayerScaling(player)
			for i = 1, level * 3 do
				SpawnEyePlants(player)
			end
			print("leifattackfailed")
		end)
		end
	end
end

local function SpawnShadowCharsFunction(player)
	local x, y, z = player.Transform:GetWorldPosition()
	local x1 = x + math.random(6, 8)
	local z1 = z + math.random(6, 8)
	local x2 = x - math.random(6, 8)
	local z2 = z - math.random(6, 8)
	

	if TheWorld.state.isnight then
		if TheWorld.Map:IsPassableAtPoint(x1, 0, z1) then
			local shadow = SpawnPrefab("swilson")
			shadow.Transform:SetPosition(x1, y, z1)
			shadow:DoTaskInTime(0, function(shadow) DayBreak(shadow) end)
		else
			player:DoTaskInTime(0.1, function(player) SpawnShadowCharsFunction(player) end)
		end
	end

end

local function SpawnShadowChars(player)
	--print("SpawnShadowChars")
	MultiFogAuto(player,8)
	player:DoTaskInTime(8 + math.random(0,5), function()
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
	
	if TheWorld.state.isnight then 
	local monkey = SpawnPrefab("chimp")
		if math.random()>0.5 then
			if TheWorld.Map:IsPassableAtPoint(x1, 0, z1) then
				monkey.Transform:SetPosition(x1, y, z1)
				monkey:DoTaskInTime(0, function(monkey) DayBreak(monkey) end)
			else
				player:DoTaskInTime(0.1, function(player) SpawnMonkeysFunction(player) end)
			end
		else
			if TheWorld.Map:IsPassableAtPoint(x2, 0, z2) then
				monkey.Transform:SetPosition(x2, y, z2)
				monkey:DoTaskInTime(0, function(monkey) DayBreak(monkey) end)
			else
				player:DoTaskInTime(0.1, function(player) SpawnMonkeysFunction(player) end)
			end
		end
	end

end

local function SpawnMonkeys(player)
	print("SpawnMonkeys")
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
	
	if TheWorld.state.isnight then
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
				player:DoTaskInTime(0.1, function(player) SpawnWerePigsFunction(player) end)
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
				player:DoTaskInTime(0.1, function(player) SpawnWerePigsFunction(player) end)
			end
		end
	end

end

local function SpawnWerePigs(player)
		print("SpawnWerePigs")
	player:DoTaskInTime(5 + math.random(0,5), function()
			local x, y, z = player.Transform:GetWorldPosition()
			local day = TheWorld.state.cycles
			local level = PlayerScaling(player)
			local num_pig = 1+level
			for i = 1, num_pig do
				player:DoTaskInTime(0.2 * i + math.random(4) * 0.3, function()
					SpawnWerePigsFunction(player)
				end)
			end
	end)
end

local function FireHungryGhostAttack(player)
	print("ooooOOOOoooo")
	local ghosttime = 6 + math.random(0,5)
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
	print("SpawnBats")
	
	local battime = 5 + (10 * math.random() * 2)
	MultiFogAuto(player,battime)
	player:DoTaskInTime(battime, function()
		if TheWorld.state.cycles <= 10 then
			local x, y, z = player.Transform:GetWorldPosition()
			local day = TheWorld.state.cycles
			
			local level = PlayerScaling(player)
			local num_bats = 4
			for i = 1, num_bats do
				player:DoTaskInTime(0.2 * i + math.random(4) * 0.3, function()
					local bat = SpawnPrefab("bat")
					bat.Transform:SetPosition(x + math.random(-8,8), y, z + math.random(-8,8))
					bat:PushEvent("fly_back")
					bat:DoTaskInTime(0, function(bat) DayBreak(bat) end)
					bat:AddTag("shadow")
				end)
			end
		else
			local x, y, z = player.Transform:GetWorldPosition()
			local day = TheWorld.state.cycles
			
			local level = PlayerScaling(player)
			local num_bats = math.min(3 + math.floor(day/35), 6)
			for i = 1, num_bats do
				player:DoTaskInTime(0.2 * i + math.random(4) * 0.3, function()
					local bat = TUNING.DSTU.ADULTBATILISKS and SpawnPrefab("vampirebat") or SpawnPrefab("bat")
					bat.Transform:SetPosition(x + math.random(-8,8), y, z + math.random(-8,8))
					bat:PushEvent("fly_back")
					bat:DoTaskInTime(0, function(bat) DayBreak(bat) end)
					bat:AddTag("shadow")
				end)
			end
		end
	end)
end

local function SpawnBaseBats(player)
	print("SpawnBaseBats")
	
	local battime = 5 + (10 * math.random() * 2)
	MultiFogAuto(player,battime)
	player:DoTaskInTime(battime, function()
		if TheWorld.state.cycles <= 10 then
			local x, y, z = player.Transform:GetWorldPosition()
			local day = TheWorld.state.cycles
			
			local level = PlayerScaling(player)
			local num_bats = 4 + level
			for i = 1 * level, num_bats do
				player:DoTaskInTime(0.2 * i + math.random(4) * 0.3, function()
					local bat = SpawnPrefab("bat")
					bat.Transform:SetPosition(x + math.random(-10,12), y, z + math.random(-10,12))
					bat:PushEvent("fly_back")
					bat:DoTaskInTime(0, function(bat) DayBreak(bat) end)
				end)
			end
		else
			local x, y, z = player.Transform:GetWorldPosition()
			local day = TheWorld.state.cycles
			
			local level = PlayerScaling(player)
			local num_bats = math.min(3 + math.floor(day/35), 6) + level
			for i = 1 * level, num_bats do
				player:DoTaskInTime(0.2 * i + math.random(4) * 0.3, function()
					local bat = TUNING.DSTU.ADULTBATILISKS and SpawnPrefab("vampirebat") or SpawnPrefab("bat")
					bat.Transform:SetPosition(x + math.random(-12,12), y, z + math.random(-12,12))
					bat:PushEvent("fly_back")
					bat:DoTaskInTime(0, function(bat) DayBreak(bat) end)
				end)
			end
		end
	end)
end

local function SpawnDroppersFunction(player)
	local x, y, z = player.Transform:GetWorldPosition()
	local x2 = x + math.random(-8, 8)
	local z2 = z + math.random(-8, 8)
	if TheWorld.state.isnight then
		if TheWorld.Map:IsPassableAtPoint(x2, 0, z2) then
			local dropper = SpawnPrefab("spider_dropper")
			dropper.Transform:SetPosition(x2, 0, z2)
			dropper.sg:GoToState("dropper_enter")
			dropper.persists = false
		else
			player:DoTaskInTime(0.1, function(player) SpawnDroppersFunction(player) end)
		end
	end
end

local function SpawnDroppers(player)
	print("SpawnDropper")
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
	print("SpawnSkitts")
	local skitttime = 10 * math.random() * 2
	if TheWorld.state.isnight then
		player:DoTaskInTime(skitttime, function()
			local x, y, z = player.Transform:GetWorldPosition()
			local num_skitts = 150
			for i = 1, num_skitts do
				player:DoTaskInTime(0.2 * i + math.random() * 0.3, function()
					local skitts = SpawnPrefab("rneshadowskittish")
					skitts.Transform:SetPosition(x + math.random(-12,12), y, z + math.random(-12,12))
				end)
			end
		end)
	end
end

local function SpawnFissuresFunction(player)
	local x, y, z = player.Transform:GetWorldPosition()
	local x2 = x + math.random(-10, 10)
	local z2 = z + math.random(-10, 10)
	
	if TheWorld.state.isnight then
		if TheWorld.Map:IsPassableAtPoint(x2, 0, z2) then
			SpawnPrefab("rnefissure").Transform:SetPosition(x2, 0, z2)
		else
			player:DoTaskInTime(0.1, function(player) SpawnFissuresFunction(player) end)
		end
	end
end

local function SpawnFissures(player)
	print("SpawnFissures")
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
	print("kramping")
	
	if not TheWorld.state.israining then
		TheWorld:PushEvent("ms_forceprecipitation")
	end
	
	player:DoTaskInTime(10 * math.random() * 2, function()
			local x, y, z = player.Transform:GetWorldPosition()
			SpawnPrefab("krampuswarning_lvl3").Transform:SetPosition(player.Transform:GetWorldPosition())
			player:DoTaskInTime(2 * math.random(4) * 0.3, function()
				--local thunder = SpawnPrefab("thunder_far")
				--thunder.Transform:SetPosition(x + math.random(-10,10), y, z + math.random(-10,10))
				local level = 2 + PlayerScaling(player) --Canis said to set to 1

				TheWorld:PushEvent("ms_forcenaughtinessrne", { player = player, numspawns = level })
				--TheWorld:PushEvent("ms_forcenaughtiness", { player = nil, numspawns = level })
			end)
	end)
end


local function SpawnLureplagueRat(player)
	local x, y, z = player.Transform:GetWorldPosition()
	if TheWorld.state.isnight then
		player:DoTaskInTime(2 * math.random() * 0.3, function()
			
			local x1 = x + math.random(6, 10)
			local z1 = z + math.random(6, 10)

			local rat = SpawnPrefab("lureplague_rat")
			if TheWorld.Map:IsPassableAtPoint(x1, 0, z1) then
				rat.Transform:SetPosition(x1, y, z1)
				rat.components.combat:SetTarget(player)
			else
				player:DoTaskInTime(0.1, function(player) SpawnLureplagueRat(player) end)
			end
		end)
	end
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
					if math.random() > 0.33 then
						local pos = Vector3(x + math.random(-10,10), y, z + math.random(-10,10))
						TheWorld:PushEvent("ms_sendlightningstrike", pos)
					else
						local lightningstrike = SpawnPrefab("hound_lightning")
						lightningstrike.Transform:SetPosition(x + math.random(-10,10), y, z + math.random(-10,10))
					end
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
	print("Thundering")
	
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
	
	if TheWorld.state.isnight then
		if not TheWorld.Map:IsPassableAtPoint(xoff, 0, zoff) then
			squid.Transform:SetPosition(xoff, y, zoff)
			splash.Transform:SetPosition(xoff, y, zoff)
			squid:PushEvent("spawn")
			squid.components.combat:SetTarget(player)
			--squid:PushEvent("attacked", {attacker = player, damage = 0, weapon = nil})
		else
			player:DoTaskInTime(0.1, function(player) SpawnSquidFunction(player) end)
		end
	end
end

local function SpawnSquids(player)
	print("Spawnsquids")
	local squidtime = 5 + (10 * math.random() * 2)
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
	if TheWorld.state.isnight then
		if not TheWorld.Map:IsPassableAtPoint(xoff, 0, zoff) then
			gnarwail.Transform:SetPosition(xoff, y, zoff)
			splash.Transform:SetPosition(xoff, y, zoff)
			gnarwail.sg:GoToState("emerge")
			gnarwail.components.combat:SetTarget(player)
			gnarwail:DoTaskInTime(0, function(gnarwail) DayBreak(gnarwail) end)
			gnarwail:PushEvent("attacked", {attacker = player, damage = 0, weapon = nil})
			
			--shark.sg:GoToState("eat_pre")
		else
			player:DoTaskInTime(0.1, function(player) SpawnGnarwailFunction(player) end)
		end
	end
end

local function SpawnGnarwail(player)
	print("Spawnsquids")
	local sharktime = 5 + (10 * math.random() * 2)
	MultiFogAuto(player,sharktime)
	player:DoTaskInTime(sharktime, function()
		SpawnGnarwailFunction(player)
	end)
end

local function SpawnLightFlowersNFernsFunction(player)
	local x, y, z = player.Transform:GetWorldPosition()
	local x2 = x + math.random(-8, 8)
	local z2 = z + math.random(-8, 8)
	
	if TheWorld.state.isnight then
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
			player:DoTaskInTime(0.1, function(player) SpawnLightFlowersNFernsFunction(player) end)
		end
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
		print("The Moon is Crying")
		local x, y, z = player.Transform:GetWorldPosition()
		player:DoTaskInTime(0.6 + math.random(4), function()
			local tear = SpawnPrefab("moon_tear_meteor")
			tear.Transform:SetPosition(x + math.random(-5,5), y, z + math.random(-5,5))
		end)
	end
end

local function DropRneFuel(piece)
	if piece.components.lootdropper ~= nil then
		piece.components.lootdropper:SpawnLootPrefab("nightmarefuel")
		piece.components.lootdropper:SpawnLootPrefab("nightmarefuel")
		piece.components.lootdropper:SpawnLootPrefab("nightmarefuel")
	end
end

local function ChessPiece(player)
	if TheWorld.state.isnewmoon and TheWorld.state.cycles > 10 then
		MultiFogAuto(player,10)
		print("Shadows...")
		local x, y, z = player.Transform:GetWorldPosition()
		local chesscheck = math.random()
		
		local level = PlayerScaling(player)
		for i = 1, level do
			player:DoTaskInTime(10 + math.random(4), function()
				if chesscheck >= 0.66 then
					local piece = SpawnPrefab("shadow_bishop")
					piece.Transform:SetPosition(x + math.random(-7,7), y, z + math.random(-7,7))
					piece:DoTaskInTime(0, function(piece) DayBreak(piece) end)
					piece:DoTaskInTime(0, function(piece) piece:ListenForEvent("levelup", nil) end)--, piece.OnLevelUp)
					piece:DoTaskInTime(0, function(piece) piece:ListenForEvent("death", DropRneFuel) end)--, piece.OnLevelUp)
					
				elseif chesscheck >= 0.33 and chesscheck < 0.66 then
					local piece = SpawnPrefab("shadow_rook")
					piece.Transform:SetPosition(x + math.random(-7,7), y, z + math.random(-7,7))
					piece:DoTaskInTime(0, function(piece) DayBreak(piece) end)
					piece:DoTaskInTime(0, function(piece) piece:ListenForEvent("levelup", nil) end)--, piece.OnLevelUp)
					piece:DoTaskInTime(0, function(piece) piece:ListenForEvent("death", DropRneFuel) end)--, piece.OnLevelUp)
					
				else
					local piece = SpawnPrefab("shadow_knight")
					piece.Transform:SetPosition(x + math.random(-7,7), y, z + math.random(-7,7))
					piece:DoTaskInTime(0, function(piece) DayBreak(piece) end)
					piece:DoTaskInTime(0, function(piece) piece:ListenForEvent("levelup", nil) end)
					piece:DoTaskInTime(0, function(piece) piece:ListenForEvent("death", DropRneFuel) end)--, piece.OnLevelUp)
					
				end
			end)
		end
	end
end

local function SpawnPhonographFunction(player)
	local x, y, z = player.Transform:GetWorldPosition()
	local x2 = x + math.random(-15, 15)
	local z2 = z + math.random(-15, 15)
	if TheWorld.state.isnight then
		if TheWorld.Map:IsPassableAtPoint(x2, 0, z2) then
			local phonograph = SpawnPrefab("charliephonograph_20")
			phonograph.Transform:SetPosition(x2, y, z2)
		else
			player:DoTaskInTime(0.1, function(player) SpawnPhonographFunction(player) end)
		end
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
	if TheWorld.state.isnight then
		if TheWorld.Map:IsPassableAtPoint(x2, 0, z2) then
			local teleporter = SpawnPrefab("shadow_teleporter")
			teleporter.Transform:SetPosition(x2, y, z2)
		else
			player:DoTaskInTime(0.1, function(player) SpawnShadowTeleporterFunction(player) end)
		end
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
	if TheWorld.state.isnight then
		player:DoTaskInTime(1+math.random(5, 10), function()
			local ent = SpawnPrefab("shadowtalker")
			ent.Transform:SetPosition(player.Transform:GetWorldPosition())
			ent.speech = player
		end)
	end
end

local function OnCollide()
	return
end

local function SpawnShadowBoomer(player)
	if TheWorld.state.isnight then
		--MultiFogAuto(player,10)
		player:DoTaskInTime(0.1 + math.random(), function()
			local radius = 10 + math.random() * 10
			local theta = math.random() * 2 * PI
			local x, y, z = player.Transform:GetWorldPosition()
			local x1 = x + radius * math.cos(theta)
			local z1 = z - radius * math.sin(theta)
			local light = TheSim:GetLightAtPoint(x1, 0, z1)
			
			if light <= .1 and #TheSim:FindEntities(x1, 0, z1, 50, {"stalkerminion"}) <= 25 and TheWorld.Map:IsPassableAtPoint(x1, 0, z1) then
				local ent = SpawnPrefab("stalker_minion")
				ent.Transform:SetPosition(x1, 0, z1)
				ent:OnSpawnedBy(player)
				ent.sg:GoToState("emerge_noburst")
				ent.Physics:ClearCollisionMask()
				ent.Physics:CollidesWith(COLLISION.GROUND)
				ent.Physics:CollidesWith(COLLISION.CHARACTERS)
				ent.Physics:SetCollisionCallback(OnCollide)
				ent:AddTag("soulless")
				
				ent:WatchWorldState("isday", function() 
					ent.components.health:Kill()
				end)
				
				ent.persists = false
			end
			--print("what")
			player:DoTaskInTime(0.1, function(player) SpawnShadowBoomer(player) end)
		end)
	end
end

local function SpawnGingerDeadPigFunction(player)
	local x, y, z = player.Transform:GetWorldPosition()
	local x2 = x + math.random(-40, 40)
	local z2 = z + math.random(-40, 40)
	local ent = SpawnPrefab("gingerdeadpig_rne")
	ent:OnSpawnedBy(player)
	ent.Transform:SetPosition(x2, y, z2)
end	

local function SpawnGingerDeadPig(player)
	print("ginger dead")

	player:DoTaskInTime(5+math.random(5,10), function()
		player:DoTaskInTime(0.2 * math.random(4) * 0.3, function()
			SpawnGingerDeadPigFunction(player)
		end)
	end)
end

local function SpawnMushbooms(player)
	print("SpawnSkitts")
	if TheWorld.state.isnight then
		player:DoTaskInTime(15, function()
			local x, y, z = player.Transform:GetWorldPosition()
			local num_bombs = 20
			for i = 1, num_bombs do
				player:DoTaskInTime(i / 1.5, function()
					local skitts = SpawnPrefab("mushroombomb")
					skitts.Transform:SetPosition(x + math.random(-10,10), y, z + math.random(-10,10))
				end)
			end
		end)
	end
end

local function Earthquake(player)
	print("Quake")
	player:DoTaskInTime(15,function(player)
		if TheWorld.state.isnight then
			SpawnPrefab("rneearthquake").Transform:SetPosition(player.Transform:GetWorldPosition())
		end
	end)
end



local function SpawnLesserShadowVortex(player)
	if TheWorld.state.isnight then
		for i = 1, 2 do
			player:DoTaskInTime(15 + (i * 40), function()
				if TheWorld.state.isnight then
					for i = 1, 4 do
						local radius = 15 + math.random() * 15
						local theta = math.random() * 2 * PI
						local x, y, z = player.Transform:GetWorldPosition()
						local x1 = x + radius * math.cos(theta)
						local z1 = z - radius * math.sin(theta)
						local light = TheSim:GetLightAtPoint(x1, 0, z1)
						if light <= 0.1 and TheWorld.Map:IsPassableAtPoint(x1, 0, z1) then
							local ent = SpawnPrefab("shadowvortex")
							ent.Transform:SetPosition(x1, 0, z1)
							break
						end
					end
				end
			end)
		end
	end
end

local function SpawnLesserShadowGrabby(player)
	if TheWorld.state.isnight then
		local num_grabby = 10
		for i = 1, num_grabby do
			player:DoTaskInTime(15 + (6 * i) + math.random(), function()
				if TheWorld.state.isnight then
					local dupes = i / 3
					for i = 1, dupes do
						local radius = 15 + math.random() * 15
						local theta = math.random() * 2 * PI
						local x, y, z = player.Transform:GetWorldPosition()
						local x1 = x + radius * math.cos(theta)
						local z1 = z - radius * math.sin(theta)
						local light = TheSim:GetLightAtPoint(x1, 0, z1)
						
						for i = 1, 3 do
							if light <= 0.1 and TheWorld.Map:IsPassableAtPoint(x1, 0, z1) then
								local ent = SpawnPrefab("rne_grabbyshadows")
								ent.Transform:SetPosition(x1, 0, z1)
								break
							end
						end
					end
				end
			end)
		end
	end
end

local function SpawnLesserMindWeavers(player)
	if TheWorld.state.isnight then
		for i = 1, 2 do
			player:DoTaskInTime(15 + (i * 30), function()
				if TheWorld.state.isnight then
					local x, y, z = player.Transform:GetWorldPosition()
					local ent = SpawnPrefab("mindweaver")
					ent.Transform:SetPosition(x, y, z)
				end
			end)
		end
	end
end

local function SpawnLesserNervousTicks(player)
	if TheWorld.state.isnight then
		for i = 1, 2 do
			player:DoTaskInTime(15 + (i * 8), function()
				if TheWorld.state.isnight then
					for i = 1, 4 do
						local radius = 10 + math.random() * 10
						local theta = math.random() * 2 * PI
						local x, y, z = player.Transform:GetWorldPosition()
						local x1 = x + radius * math.cos(theta)
						local z1 = z - radius * math.sin(theta)
						local light = TheSim:GetLightAtPoint(x1, 0, z1)
			
						if light <= 0.1 and TheWorld.Map:IsPassableAtPoint(x1, 0, z1) then
							local ent = SpawnPrefab("nervoustickden")
							ent.Transform:SetPosition(x1, 0, z1)
							break
						end
					end
				end
			end)
		end
	end
end

local function SpawnLesserNightCrawlers(player)
	if TheWorld.state.isnight then
		for i = 1, 8 do
			player:DoTaskInTime((15 + i) * 2, function()
				if TheWorld.state.isnight then
					for i = 1, 4 do
						local radius = 15 + math.random() * 15
						local theta = math.random() * 2 * PI
						local x, y, z = player.Transform:GetWorldPosition()
						local x1 = x + radius * math.cos(theta)
						local z1 = z - radius * math.sin(theta)
						local light = TheSim:GetLightAtPoint(x1, 0, z1)
			
						if light <= 0.1 and TheWorld.Map:IsPassableAtPoint(x1, 0, z1) then
							local ent = SpawnPrefab("nightcrawler")
							ent.Transform:SetPosition(x1, 0, z1)
							break
						end
					end
				end
			end)
		end
	end
end

local function SpawnLesserFuelSeekers(player)
	if TheWorld.state.isnight then
		for i = 1, 2 do
			player:DoTaskInTime(15 + (i * 8) + i, function()
				if TheWorld.state.isnight then
					for i = 1, 4 do
						local radius = 15 + math.random() * 15
						local theta = math.random() * 2 * PI
						local x, y, z = player.Transform:GetWorldPosition()
						local x1 = x + radius * math.cos(theta)
						local z1 = z - radius * math.sin(theta)
						local light = TheSim:GetLightAtPoint(x1, 0, z1)
			
						if light <= 0.1 and TheWorld.Map:IsPassableAtPoint(x1, 0, z1) then
							local ent = SpawnPrefab("fuelseeker")
							ent.Transform:SetPosition(x1, 0, z1)
							break
						end
					end
				end
			end)
		end
	end
end

local function DoLesserThreat(player)
	if TheWorld.state.isnight then
		local weightheodds = math.random()
		
		if weightheodds >= 8.3 then
			SpawnLesserShadowVortex(player)
		elseif weightheodds < 8.3 and weightheodds >= 6.64 then
			SpawnLesserShadowGrabby(player)
		elseif weightheodds < 6.64 and weightheodds >= 4.98 then
			SpawnLesserMindWeavers(player)
		elseif weightheodds < 4.98 and weightheodds >= 3.32 then
			SpawnLesserNervousTicks(player)
		elseif weightheodds < 3.32 and weightheodds >= 1.66 then
			SpawnLesserNightCrawlers(player)
		elseif weightheodds < 1.66 then
			SpawnLesserFuelSeekers(player)
		end
	end
end

local function SpawnShadowVortex(player)
	if TheWorld.state.isnight then
		MultiFogAuto(player,10)
		for i = 1, 3 do
			player:DoTaskInTime(15 + (i * 30), function()
				if TheWorld.state.isnight then
					for i = 1, 4 do
						local radius = 15 + math.random() * 15
						local theta = math.random() * 2 * PI
						local x, y, z = player.Transform:GetWorldPosition()
						local x1 = x + radius * math.cos(theta)
						local z1 = z - radius * math.sin(theta)
						local light = TheSim:GetLightAtPoint(x1, 0, z1)
						if light <= 0.1 and TheWorld.Map:IsPassableAtPoint(x1, 0, z1) then
							local ent = SpawnPrefab("shadowvortex")
							ent.Transform:SetPosition(x1, 0, z1)
							break
						end
					end
				end
			end)
		end
		
		local days_survived = player.components.age ~= nil and player.components.age:GetAgeInDays()
		
		if days_survived >= 30 then
			DoLesserThreat(player)
		end
	end
end

local function SpawnShadowGrabby(player)
	if TheWorld.state.isnight then
		MultiFogAuto(player,10)
		local num_grabby = 20
		for i = 1, num_grabby do
			player:DoTaskInTime(15 + (3 * i) + math.random(), function()
				if TheWorld.state.isnight then
					local dupes = i / 3
					for i = 1, dupes do
						local radius = 15 + math.random() * 15
						local theta = math.random() * 2 * PI
						local x, y, z = player.Transform:GetWorldPosition()
						local x1 = x + radius * math.cos(theta)
						local z1 = z - radius * math.sin(theta)
						local light = TheSim:GetLightAtPoint(x1, 0, z1)
						
						for i = 1, 3 do
							if light <= 0.1 and TheWorld.Map:IsPassableAtPoint(x1, 0, z1) then
								local ent = SpawnPrefab("rne_grabbyshadows")
								ent.Transform:SetPosition(x1, 0, z1)
								break
							end
						end
						
						print("spawn grabby")
					end
				end
			end)
		end
		
		local days_survived = player.components.age ~= nil and player.components.age:GetAgeInDays()
		
		if days_survived >= 30 then
			DoLesserThreat(player)
		end
	end
end

local function SpawnMindWeavers(player)
	if TheWorld.state.isnight then
		MultiFogAuto(player,10)
		for i = 1, 3 do
			player:DoTaskInTime(15 + (i * 20), function()
				if TheWorld.state.isnight then
					local x, y, z = player.Transform:GetWorldPosition()
					local ent = SpawnPrefab("mindweaver")
					ent.Transform:SetPosition(x, y, z)
				end
			end)
		end
		
		local days_survived = player.components.age ~= nil and player.components.age:GetAgeInDays()
		
		if days_survived >= 30 then
			DoLesserThreat(player)
		end
	end
end

local function SpawnNervousTicks(player)
	if TheWorld.state.isnight then
		MultiFogAuto(player,10)
		for i = 1, 3 do
			player:DoTaskInTime(15 + (i + 1) * 3, function()
				if TheWorld.state.isnight then
					for i = 1, 4 do
						local radius = 10 + math.random() * 10
						local theta = math.random() * 2 * PI
						local x, y, z = player.Transform:GetWorldPosition()
						local x1 = x + radius * math.cos(theta)
						local z1 = z - radius * math.sin(theta)
						local light = TheSim:GetLightAtPoint(x1, 0, z1)
			
						if light <= 0.1 and TheWorld.Map:IsPassableAtPoint(x1, 0, z1) then
							local ent = SpawnPrefab("nervoustickden")
							ent.Transform:SetPosition(x1, 0, z1)
							break
						end
					end
				end
			end)
		end
		
		local days_survived = player.components.age ~= nil and player.components.age:GetAgeInDays()
		
		if days_survived >= 30 then
			DoLesserThreat(player)
		end
	end
end

local function SpawnNightCrawlers(player)
	if TheWorld.state.isnight then
		MultiFogAuto(player,10)
		for i = 1, 10 do
			player:DoTaskInTime(15 + i + math.random(), function()
				if TheWorld.state.isnight then
					for i = 1, 4 do
						local radius = 15 + math.random() * 15
						local theta = math.random() * 2 * PI
						local x, y, z = player.Transform:GetWorldPosition()
						local x1 = x + radius * math.cos(theta)
						local z1 = z - radius * math.sin(theta)
						local light = TheSim:GetLightAtPoint(x1, 0, z1)
			
						if light <= 0.1 and TheWorld.Map:IsPassableAtPoint(x1, 0, z1) then
							local ent = SpawnPrefab("nightcrawler")
							ent.Transform:SetPosition(x1, 0, z1)
							break
						end
					end
				end
			end)
		end
		
		local days_survived = player.components.age ~= nil and player.components.age:GetAgeInDays()
		
		if days_survived >= 30 then
			DoLesserThreat(player)
		end
	end
end

local function SpawnFuelSeekers(player)
	if TheWorld.state.isnight then
		MultiFogAuto(player,10)
		for i = 1, 3 do
			player:DoTaskInTime(15 + (i * 4) + i, function()
				if TheWorld.state.isnight then
					for i = 1, 4 do
						local radius = 15 + math.random() * 15
						local theta = math.random() * 2 * PI
						local x, y, z = player.Transform:GetWorldPosition()
						local x1 = x + radius * math.cos(theta)
						local z1 = z - radius * math.sin(theta)
						local light = TheSim:GetLightAtPoint(x1, 0, z1)
			
						if light <= 0.1 and TheWorld.Map:IsPassableAtPoint(x1, 0, z1) then
							local ent = SpawnPrefab("fuelseeker")
							ent.Transform:SetPosition(x1, 0, z1)
							break
						end
					end
				end
			end)
		end
		
		local days_survived = player.components.age ~= nil and player.components.age:GetAgeInDays()
		
		if days_survived >= 30 then
			DoLesserThreat(player)
		end
	end
end

local function MaskMan(player)
	player:DoTaskInTime(15, function()
		if TheWorld.state.isnight then
			for i = 1, 4 do
				local radius = 5 + math.random() * 5
				local theta = math.random() * 2 * PI
				local x, y, z = player.Transform:GetWorldPosition()
				local x1 = x + radius * math.cos(theta)
				local z1 = z - radius * math.sin(theta)
				
				if TheWorld.Map:IsPassableAtPoint(x1, 0, z1) then
					local ent = SpawnPrefab("tiddlestranger_rne")
					ent.Transform:SetPosition(x1, 0, z1)
					break
				end
			end
		end
	end)
end

---------------------------------------------------
---RNE list above
---------------------------------------------------

local function AddWildEvent(name, weight)
    if not self.wildevents then
        self.wildevents = {}
        self.totalrandomwildweight = 0
    end

	if not table.contains(self.wildevents, name) then
		table.insert(self.wildevents, { name = name, weight = weight })
		self.totalrandomwildweight = self.totalrandomwildweight + weight
	else	
		print("dupe event")
	end
end

local function RemoveWildEvent(name, weight)
    if not self.wildevents then
        self.wildevents = {}
        self.totalrandomwildweight = 0
    end
	
	for k, v in pairs(self.wildevents) do
		if name == v.name then
	print(name)
			table.remove(self.wildevents, k)
			print(k)
			self.totalrandomwildweight = self.totalrandomwildweight - weight
			print("reduce rneweight"..weight)
			print(self.totalrandomwildweight)
		end
	end
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
	print(name)
	if not table.contains(self.baseevents, name) then
		table.insert(self.baseevents, { name = name, weight = weight })
		self.totalrandombaseweight = self.totalrandombaseweight + weight
		print("rneweight"..weight)
			print(self.totalrandombaseweight)
	else	
		print("dupe event")
	end
end

local function RemoveBaseEvent(name, weight)
    if not self.baseevents then
        self.baseevents = {}
        self.totalrandombaseweight = 0
    end
	
	for k, v in pairs(self.baseevents) do
		if name == v.name then
	print(name)
			table.remove(self.baseevents, k)
			print(k)
			self.totalrandombaseweight = self.totalrandombaseweight - weight
			print("reduce rneweight"..weight)
			print(self.totalrandombaseweight)
		end
	end
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

local AUTUMN = 
{
	SpawnMushbooms = { name = SpawnMushbooms, weight = 0.3, },
}

local WINTER = 
{
	SpawnKrampus = { name = SpawnKrampus, weight = .2, },
	SpawnGingerDeadPig = { name = SpawnGingerDeadPig, weight = 0.6, },
}

local SPRING = 
{
	SpawnThunderFar = { name = SpawnThunderFar, weight = 0.3, },
	SpawnLureplagueRat = { name = SpawnLureplagueRat, weight = 0.1, },
}

local SUMMER = 
{
	--SpawnWalrusHunt = { name = SpawnWalrusHunt, weight = 1, },
}

local _maskmanchance = IsSpecialEventActive(SPECIAL_EVENTS.HALLOWED_NIGHTS) and .8 or 0.1

local BASE = 
{
	MaskMan = { name = MaskMan, weight = _maskmanchance, },
	SpawnBaseBats = { name = SpawnBaseBats, weight = .3, },
	SpawnFissures = { name = SpawnFissures, weight = .3, },
	SpawnSkitts = { name = SpawnSkitts, weight = .5, },
	--FireHungryGhostAttack = { name = FireHungryGhostAttack, weight = .2, },
	SpawnShadowChars = { name = SpawnShadowChars, weight = .3, },
	SpawnMonkeys = { name = SpawnMonkeys, weight = .1, },
	LeifAttack = { name = LeifAttack, weight = .1, },
	SpawnShadowTeleporter = { name = SpawnShadowTeleporter, weight = .1, },
	--StumpsAttack = { name = StumpsAttack, weight = .2, },
	SpawnShadowTalker = { name = SpawnShadowTalker, weight = .6, },
	SpawnShadowBoomer = { name = SpawnShadowBoomer, weight = .3, },
	SpawnGnomes = { name = SpawnGnomes, weight = .1, },
	SkeleBros = { name = SkeleBros, weight = .3, },
	Stanton = { name = Stanton, weight = .1, },
	Earthquake = { name = Earthquake, weight = .1, },
	SpawnShadowGrabby = { name = SpawnShadowGrabby, weight = .5, },
	SpawnShadowVortex = { name = SpawnShadowVortex, weight = .5, },
	SpawnMindWeavers = { name = SpawnMindWeavers, weight = .5, },
	SpawnNervousTicks = { name = SpawnNervousTicks, weight = .5, },
	SpawnNightCrawlers = { name = SpawnNightCrawlers, weight = .5, },
	SpawnFuelSeekers = { name = SpawnFuelSeekers, weight = .5, },
}

for k, v in pairs(BASE) do
	AddBaseEvent(v.name, v.weight)
end

local WILD = 
{
	SpawnBats = { name = SpawnBats, weight = .3, },
	SpawnLightFlowersNFerns = { name = SpawnLightFlowersNFerns, weight = .3, },
	SpawnSkitts = { name = SpawnSkitts, weight = .5, },
	SpawnMonkeys = { name = SpawnMonkeys, weight = .1, },
	LeifAttack = { name = LeifAttack, weight = .1, },
	SpawnShadowTeleporter = { name = SpawnShadowTeleporter, weight = .1, },
	--StumpsAttack = { name = StumpsAttack, weight = .2, },
	SpawnShadowTalker = { name = SpawnShadowTalker, weight = .6, },
	SpawnShadowBoomer = { name = SpawnShadowBoomer, weight = .3, },
	SkeleBros = { name = SkeleBros, weight = .3, },
	Stanton = { name = Stanton, weight = .1, },
	Earthquake = { name = Earthquake, weight = .1, },
	SpawnShadowGrabby = { name = SpawnShadowGrabby, weight = .5, },
	SpawnShadowVortex = { name = SpawnShadowVortex, weight = .4, },
	SpawnMindWeavers = { name = SpawnMindWeavers, weight = .5, },
	SpawnNervousTicks = { name = SpawnNervousTicks, weight = .5, },
	SpawnNightCrawlers = { name = SpawnNightCrawlers, weight = .5, },
	SpawnFuelSeekers = { name = SpawnFuelSeekers, weight = .5, },
}

for k, v in pairs(WILD) do
	AddWildEvent(v.name, v.weight)
end

local SECONDARYWILD = 
{
	SpawnBaseBats = { name = SpawnBaseBats, weight = .3, },
	SpawnSkitts = { name = SpawnSkitts, weight = .5, },
	SpawnLightFlowersNFerns = { name = SpawnLightFlowersNFerns, weight = .2, },
	--StumpsAttack = { name = StumpsAttack, weight = .3, },
	SpawnShadowTalker = { name = SpawnShadowTalker, weight = .6, },
	SpawnShadowBoomer = { name = SpawnShadowBoomer, weight = .2, },
}

for k, v in pairs(SECONDARYWILD) do
	AddSecondaryWildEvent(v.name, v.weight)
end

local FULLMOON = 
{
	MoonTear = { name = MoonTear, weight = 1, },
}

for k, v in pairs(FULLMOON) do
	AddFullMoonEvent(v.name, v.weight)
end

local NEWMOON = 
{
	--ChessPiece = { name = ChessPiece, weight = .5, },
	SpawnPhonograph = { name = SpawnPhonograph, weight = .2, },
}

for k, v in pairs(NEWMOON) do
	AddNewMoonEvent(v.name, v.weight)
end

local OCEAN = 
{
	SpawnSquids = { name = SpawnSquids, weight = .6, },
	SpawnBats = { name = SpawnBats, weight = .3, },
	SpawnSkitts = { name = SpawnSkitts, weight = .4, },
	SpawnShadowTalker = { name = SpawnShadowTalker, weight = .5, },
}

for k, v in pairs(OCEAN) do
	AddOceanEvent(v.name, v.weight)
end

local function OnSeasonTick(src, data)
	for ak, av in pairs(AUTUMN) do
		RemoveBaseEvent(av.name, av.weight)
		RemoveWildEvent(av.name, av.weight)
	end
	
	for wk, wv in pairs(WINTER) do
		RemoveBaseEvent(wv.name, wv.weight)
		RemoveWildEvent(wv.name, wv.weight)
	end
	
	for spk, spv in pairs(SPRING) do
		RemoveBaseEvent(spv.name, spv.weight)
		RemoveWildEvent(spv.name, spv.weight)
	end
	
	for suk, suv in pairs(SUMMER) do
		RemoveBaseEvent(suv.name, suv.weight)
		RemoveWildEvent(suv.name, suv.weight)
	end

	if TheWorld.state.isautumn or (data ~= nil and data.season == "autumn") then
		for k, v in pairs(AUTUMN) do
			AddBaseEvent(v.name, v.weight)
			AddWildEvent(v.name, v.weight)
			print("autumn")
		end
	elseif TheWorld.state.iswinter or (data ~= nil and data.season == "winter") then
		for k, v in pairs(WINTER) do
			AddBaseEvent(v.name, v.weight)
			AddWildEvent(v.name, v.weight)
			print("winter")
		end
	elseif TheWorld.state.spring or (data ~= nil and data.season == "spring") then
		for k, v in pairs(SPRING) do
			AddBaseEvent(v.name, v.weight)
			AddWildEvent(v.name, v.weight)
			print("spring")
		end
	elseif TheWorld.state.summer or (data ~= nil and data.season == "summer") then
		for k, v in pairs(SUMMER) do
			AddBaseEvent(v.name, v.weight)
			AddWildEvent(v.name, v.weight)
			print("summer")
		end
	end
end
------------------------
--Inclusion and Tuning
------------------------

local function DoBaseRNE(player)
	if TheWorld.state.isnight then
		if self.totalrandombaseweight and self.totalrandombaseweight > 0 and self.baseevents then
			local rnd = math.random()*self.totalrandombaseweight
			for k,v in pairs(self.baseevents) do
				rnd = rnd - v.weight
				if rnd <= 0 and not table.contains(self.storedrne, v.name) then
					if #self.storedrne >= 6 then
						table.remove(self.storedrne, 1)
					end
					
					
					
					table.insert(self.storedrne, v.name)
					v.name(player)
					return
				end
			end
		end
	end
end

local function DoWildRNE(player)
	if TheWorld.state.isnight then
		if self.totalrandomwildweight and self.totalrandomwildweight > 0 and self.wildevents then
			local rnd = math.random()*self.totalrandomwildweight
			for k,v in pairs(self.wildevents) do
				rnd = rnd - v.weight
				if rnd <= 0 and not table.contains(self.storedrne, v.name) then
					if #self.storedrne >= 6 then
						table.remove(self.storedrne, 1)
					end
				
					v.name(player)
					table.insert(self.storedrne, v.name)
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
	if math.random() >= .7 and TheWorld.state.isspring and TheWorld.state.isnight then
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

local function IsOcean(player)
	local area = player.components.areaaware
	return not TheWorld.Map:IsVisualGroundAtPoint(player.Transform:GetWorldPosition())
end

local function IsEligible(player)
	local x, y, z = player.Transform:GetWorldPosition()
	local theent = #TheSim:FindEntities(x, 0, z, 40, {"epic"}, {"leif", "crabking"})
	local hounding = TheWorld.components.hounded:GetWarning()
	local deerclopsed = TheWorld.components.uncompromising_deerclopsspawner:GetWarning()
	--local beargered = TheWorld.components.beargerspawner:GetWarning()
	
	local gmoosed, dragonflied
	if TheWorld.components.gmoosespawner ~= nil then
		gmoosed = TheWorld.components.gmoosespawner:GetWarning()
	else
		gmoosed = false
	end
	if TheWorld.components.mock_dragonflyspawner ~= nil then
		dragonflied = TheWorld.components.mock_dragonflyspawner:GetWarning()
	else
		dragonflied = false
	end
	
	local area = player.components.areaaware
	
	return not TheWorld:HasTag("snowstormstart") and not TheWorld.net:HasTag("snowstormstart") and not 
		player:HasTag("playerghost") and theent == 0 and not (hounding or deerclopsed --[[or beargered]] 
		or gmoosed or dragonflied) and
		area:GetCurrentArea() ~= nil
		and not area:CurrentlyInTag("nohasslers")
end


local function CheckPlayers()
    _targetplayer = nil
    if #_activeplayers == 0 then
        return
    end

	local playerlist = {}
	for _, v in ipairs(_activeplayers) do
		if IsEligible(v) then
			table.insert(playerlist, v)
		end
	end
	
		
	--shuffleArray(playerlist)
	if #playerlist == 0 then
		return
	end
	local player = playerlist[math.random(#playerlist)]
	local numStructures = 0
	local numStructures2 = 0
	
	local playerchancescaling = TUNING.DSTU.RNE_CHANCE -- - (#playerlist * 0.1)
	--print(playerchancescaling)
	
	local days_survived = player.components.age ~= nil and player.components.age:GetAgeInDays()
	
	if --[[TheWorld.state.cycles]]days_survived >= 5 and math.random() >= playerchancescaling or (days_survived >= 5 and TheWorld.state.isfullmoon and math.random() >= 0.5) or (days_survived >= 5 and TheWorld.state.isnewmoon and math.random() >= 0.75) then
		
		--for i, 1 in ipairs(playerlist) do  --try a base RNE
		if player ~= nil then
			local x,y,z = player.Transform:GetWorldPosition()--local x,y,z = v.Transform:GetWorldPosition()
			local ents = TheSim:FindEntities(x,y,z, STRUCTURE_DIST, {"structure"})
			numStructures = #ents
			
			if IsOcean(player) and IsEligible(player) then --Double Checking For Eligibility after chosen just in case.
				DoOceanRNE(player)
			elseif IsEligible(player) then --Double Checking For Eligibility after chosen just in case.
				if numStructures >= 4 then
					if TheWorld:HasTag("cave") then
						DoCaveRNE(player)
					else
						if TheWorld.state.isfullmoon then
							--print("fullmoon")
							DoFullMoonRNE(player)--DoFullMoonRNE(v)
						elseif TheWorld.state.isnewmoon then
							--print("newmoon")
							DoNewMoonRNE(player)--DoNewMoonRNE(v)
						else
							DoBaseRNE(player)--DoBaseRNE(v)
						end
					end
					--print("found base")
				else
					if TheWorld:HasTag("cave") then
						DoCaveRNE(player)
					else
						if TheWorld.state.isfullmoon then
							--print("fullmoon")
							DoFullMoonRNE(player)--DoFullMoonRNE(v)
						elseif TheWorld.state.isnewmoon then
							--print("newmoon")
							DoNewMoonRNE(player)--DoNewMoonRNE(v)
						else
							DoWildRNE(player)--DoWildRNE(v)
						end
					end
					--print("no find base")
				end
			end
		end
		
		local k = #playerlist
		
		for _, i in ipairs(playerlist) do
		
		local days_survived_secondary = i.components.age ~= nil and i.components.age:GetAgeInDays()
	
			if i ~= player and days_survived_secondary >= 5 and math.random() >= 0.5 then
				local x,y,z = i.Transform:GetWorldPosition()--local x,y,z = v.Transform:GetWorldPosition()
				local ents2 = TheSim:FindEntities(x,y,z, STRUCTURE_DIST, {"structure"})
				numStructures2 = #ents2
		
				if IsEligible(i) and not IsOcean(i) then
					if numStructures2 >= 4 then
						--nothing, not really accounting for other players in other bases but meh
					else
						DoSecondaryWildRNE(i)
					end
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

--function RandomNightEvents:OnSave()
local function OnSave()
	return {
		storedrne = self.storedrne,
	}
end

--function RandomNightEvents:OnLoad(data)
local function OnLoad(data)
	if data ~= nil then
		if data.storedrne ~= nil then
			self.storedrne = data.storedrne
		end
	end
end

function self:OnPostInit()
	OnSeasonTick()
end

inst:ListenForEvent("ms_playerjoined", OnPlayerJoined)
inst:ListenForEvent("ms_playerleft", OnPlayerLeft)
inst:ListenForEvent("seasontick", OnSeasonTick, TheWorld)

self:WatchWorldState("isnight", function() self.inst:DoTaskInTime(5, TryRandomNightEvent) end)
self:WatchWorldState("cycleschanged", function() self.inst:DoTaskInTime(5, TryRandomNightEvent) end)
end)