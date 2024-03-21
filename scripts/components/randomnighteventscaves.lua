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
self.storedcaverne = {}
local STRUCTURE_DIST = 20
self.caveevents = nil
self.secondarycaveevents = nil
self.totalrandomcaveweight = nil
self.totalrandomsecondarycaveweight = nil
self.dreamcatchers = {}

--------------------------------
--RNE Player Scaling function
--------------------------------

local function PlayerScaling(player)
	local x, y, z = player.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x, 0, z, 50, {"player"}, {"playerghost"})

	if #ents >= 0 and #ents < 3 then
		return 1
	elseif #ents >= 2 and #ents < 5 then
		return 2
	elseif #ents >= 5 and #ents < 7 then
		return 3
	elseif #ents > 6 then
		return 4
	end
	
	return 1
end
	
--------------------------------
--RNE Fog Controller Functions Below
--------------------------------

local function StopFog(player)
	if player:HasTag("infog") then
		player:RemoveTag("infog")
	end
end

local function StartFog(player)
player.components.talker:Say(GetString(player, "ANNOUNCE_RNEFOG"))
	if not player:HasTag("infog") then
		player:AddTag("infog")
	end
end

local function StartFogAuto(player,x) --This should deactivate fog after 15 seconds or x time if you don't want to include StopFog(player)
player.components.talker:Say(GetString(player, "ANNOUNCE_RNEFOG"))
	if not player:HasTag("infog") then
		player:AddTag("infog")
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

local function SpawnGnomes(player)
	local x, y, z = player.Transform:GetWorldPosition()
	if TheWorld.state.iscavenight then
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

local function SpawnShadowCharsFunction(player)
	local x, y, z = player.Transform:GetWorldPosition()
	local x1 = x + math.random(6, 8)
	local z1 = z + math.random(6, 8)
	local x2 = x - math.random(6, 8)
	local z2 = z - math.random(6, 8)
	

	if TheWorld.state.iscavenight then
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
	
	if TheWorld.state.iscavenight then 
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

local function SpawnBats(player)
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
					--bat:AddTag("shadow")
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
					--bat:AddTag("shadow")
				end)
			end
		end
	end)
end

local function SpawnDroppersFunction(player)
	local x, y, z = player.Transform:GetWorldPosition()
	local x2 = x + math.random(-8, 8)
	local z2 = z + math.random(-8, 8)
	if TheWorld.state.iscavenight then
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
	local skitttime = 10 * math.random() * 2
	if TheWorld.state.iscavenight then
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
	
	if TheWorld.state.iscavenight then
		if TheWorld.Map:IsPassableAtPoint(x2, 0, z2) then
			SpawnPrefab("rnefissure").Transform:SetPosition(x2, 0, z2)
		else
			player:DoTaskInTime(0.1, function(player) SpawnFissuresFunction(player) end)
		end
	end
end

local function SpawnFissures(player)
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

local function SpawnLightFlowersNFernsFunction(player)
	local x, y, z = player.Transform:GetWorldPosition()
	local x2 = x + math.random(-8, 8)
	local z2 = z + math.random(-8, 8)
	
	if TheWorld.state.iscavenight then
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

local function DropRneFuel(piece)
	if piece.components.lootdropper ~= nil then
		piece.components.lootdropper:SpawnLootPrefab("nightmarefuel")
		piece.components.lootdropper:SpawnLootPrefab("nightmarefuel")
		piece.components.lootdropper:SpawnLootPrefab("nightmarefuel")
	end
end

local function SpawnPhonographFunction(player)
	local x, y, z = player.Transform:GetWorldPosition()
	local x2 = x + math.random(-15, 15)
	local z2 = z + math.random(-15, 15)
	if TheWorld.state.iscavenight then
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

local function SpawnShadowTalker(player, mathmin, mathmax)
	if TheWorld.state.iscavenight then
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
	
	if TheWorld.state.iscavenight then
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
                ent:AddTag("noember")

				ent:WatchWorldState("isday", function() 
					ent.components.health:Kill()
				end)
				
				ent.persists = false
			end
			
			player:DoTaskInTime(0.1, function(player) SpawnShadowBoomer(player) end)
		end)
	end
end

local function SpawnShadowGrabby(player)
	if TheWorld.state.iscavenight then
		MultiFogAuto(player,10)
		local num_grabby = 20
		for i = 1, num_grabby do
			player:DoTaskInTime(15 + (3 * i) + math.random(), function()
				if TheWorld.state.iscavenight then
					local dupes = i / 4
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

local function SpawnShadowVortex(player)
	if TheWorld.state.iscavenight then
		MultiFogAuto(player,10)
		for i = 1, 3 do
			player:DoTaskInTime(15 + (i * 30), function()
				if TheWorld.state.iscavenight then
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

local function SpawnMindWeavers(player)
	if TheWorld.state.iscavenight then
		MultiFogAuto(player,10)
		for i = 1, 3 do
			player:DoTaskInTime(15 + (i * 20), function()
				if TheWorld.state.iscavenight then
					local x, y, z = player.Transform:GetWorldPosition()
					local ent = SpawnPrefab("mindweaver")
					ent.Transform:SetPosition(x, y, z)
				end
			end)
		end
	end
end

local function SpawnNervousTicks(player)
	if TheWorld.state.iscavenight then
		MultiFogAuto(player,10)
		for i = 1, 3 do
			player:DoTaskInTime(15 + (i + 1) * 3, function()
				if TheWorld.state.iscavenight then
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

local function SpawnNightCrawlers(player)
	if TheWorld.state.iscavenight then
		MultiFogAuto(player,10)
		for i = 1, 10 do
			player:DoTaskInTime(15 + i + math.random(), function()
				if TheWorld.state.iscavenight then
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

local function SpawnFuelSeekers(player)
	if TheWorld.state.iscavenight then
		MultiFogAuto(player,10)
		for i = 1, 3 do
			player:DoTaskInTime(15 + (i * 4) + i, function()
				if TheWorld.state.iscavenight then
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


---------------------------------------------------
---RNE list above
---------------------------------------------------

local function AddCaveEvent(name, weight)
    if not self.caveevents then
        self.caveevents = {}
        self.totalrandomcaveweight = 0
    end
	
	if not table.contains(self.caveevents, name) then
		table.insert(self.caveevents, { name = name, weight = weight })
		self.totalrandomcaveweight = self.totalrandomcaveweight + weight
	end
end

local function AddSecondaryCaveEvent(name, weight)
    if not self.secondarycaveevents then
        self.secondarycaveevents = {}
        self.totalrandomsecondarycaveweight = 0
    end
	
	if not table.contains(self.secondarycaveevents, name) then
		table.insert(self.secondarycaveevents, { name = name, weight = weight })
		self.totalrandomsecondarycaveweight = self.totalrandomsecondarycaveweight + weight
	end
end

------------------------
--Inclusion and Tuning
------------------------

local CAVE = 
{
	SpawnBats = { name = SpawnBats, weight = .3, },
	SpawnFissures = { name = SpawnFissures, weight = .3, },
	SpawnSkitts = { name = SpawnSkitts, weight = .5, },
	SpawnShadowChars = { name = SpawnShadowChars, weight = .3, },
	SpawnMonkeys = { name = SpawnMonkeys, weight = .1, },
	SpawnShadowTalker = { name = SpawnShadowTalker, weight = .6, },
	SpawnShadowBoomer = { name = SpawnShadowBoomer, weight = .3, },
	SkeleBros = { name = SkeleBros, weight = .3, },
	--SpawnShadowGrabby = { name = SpawnShadowGrabby, weight = .5, },
	SpawnShadowVortex = { name = SpawnShadowVortex, weight = .5, },
	SpawnMindWeavers = { name = SpawnMindWeavers, weight = .5, },
	SpawnNervousTicks = { name = SpawnNervousTicks, weight = .5, },
	SpawnNightCrawlers = { name = SpawnNightCrawlers, weight = .5, },
	SpawnFuelSeekers = { name = SpawnFuelSeekers, weight = .5, },
}

for k, v in pairs(CAVE) do
	AddCaveEvent(v.name, v.weight)
end

local SECONDARYCAVE = 
{
	SpawnBats = { name = SpawnBats, weight = .3, },
	SpawnSkitts = { name = SpawnSkitts, weight = .5, },
	SpawnShadowTalker = { name = SpawnShadowTalker, weight = .6, },
	SkeleBros = { name = SkeleBros, weight = .3, },
	--SpawnShadowGrabby = { name = SpawnShadowGrabby, weight = .5, },
	SpawnMindWeavers = { name = SpawnMindWeavers, weight = .5, },
	SpawnNervousTicks = { name = SpawnNervousTicks, weight = .5, },
	SpawnNightCrawlers = { name = SpawnNightCrawlers, weight = .5, },
	SpawnFuelSeekers = { name = SpawnFuelSeekers, weight = .5, },
}

for k, v in pairs(SECONDARYCAVE) do
	AddSecondaryCaveEvent(v.name, v.weight)
end
------------------------
--Inclusion and Tuning
------------------------

local function DoCaveRNE(player)
	if TheWorld.state.iscavenight then
		if self.totalrandomcaveweight and self.totalrandomcaveweight > 0 and self.caveevents then
			local rnd = math.random()*self.totalrandomcaveweight
			for k,v in pairs(self.caveevents) do
				rnd = rnd - v.weight
				if rnd <= 0 and not table.contains(self.storedcaverne, v.name) then
					if #self.storedcaverne >= 9 then
						table.remove(self.storedcaverne, 1)
					end
					
					
					
					table.insert(self.storedcaverne, v.name)
					v.name(player)
					return
				end
			end
		end
	end
end

local function DoSecondaryCaveRNE(player)
	if TheWorld.state.iscavenight then
		if self.totalrandomsecondarycaveweight and self.totalrandomsecondarycaveweight > 0 and self.caveevents then
			local rnd = math.random()*self.totalrandomsecondarycaveweight
			for k,v in pairs(self.secondarycaveevents) do
				rnd = rnd - v.weight
				if rnd <= 0 and not table.contains(self.storedcaverne, v.name) then
					if #self.storedcaverne >= 9 then
						table.remove(self.storedcaverne, 1)
					end
					
					
					
					table.insert(self.storedcaverne, v.name)
					v.name(player)
					return
				end
			end
		end
	end
end

local function IsEligible(player)
	local x, y, z = player.Transform:GetWorldPosition()
	local theent = #TheSim:FindEntities(x, 0, z, 40, {"epic"}, {"leif", "crabking"})
	local hounding = TheWorld.components.hounded:GetWarning()
	
	local area = player.components.areaaware
	
	return not player:HasTag("playerghost") and theent == 0 and not hounding and
		area:GetCurrentArea() ~= nil
		and not area:CurrentlyInTag("nohasslers")
end


local function CheckPlayers(forced)
	if TheWorld.state.iscavenight then
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
		
		local playerchancescaling = TUNING.DSTU.RNE_CHANCE
		
		local days_survived = player.components.age ~= nil and player.components.age:GetAgeInDays()
		
		if self.rnequeued or forced then
			self.rnequeued = false
			--TheNet:Announce("DOING RNE BABY")
			if player ~= nil then
				local x,y,z = player.Transform:GetWorldPosition()
				
				if IsEligible(player) then
					DoCaveRNE(player)
				end
			end
			
			local k = #playerlist
			
			for _, i in ipairs(playerlist) do
				local days_survived_secondary = i.components.age ~= nil and i.components.age:GetAgeInDays()
		
				if i ~= player and days_survived_secondary >= 5 and math.random() >= 0.5 then
					local x,y,z = i.Transform:GetWorldPosition()
			
					if IsEligible(i) then
						DoSecondaryCaveRNE(i)
					end
				end
			end
		end
	end
end

local function TryRandomNightEvent(self)      --Canis said 20% chance each night to have a RNE, could possibly include a scaling effect later
	CheckPlayers(false)
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


function self:OnSave()
	local data = {}
	data.storedcaverne = self.storedcaverne
	data.LastNewMoonRNE = self.LastNewMoonRNE
	data.moontear_available = self.moontear_available
	data.rnequeued = self.rnequeued
	data.punish = self.punish
	return data
end

function self:OnLoad(data)
	if data ~= nil then
		if data.storedcaverne ~= nil then
			self.storedcaverne = data.storedcaverne
		end
		if data.rnequeued then
			self.rnequeued = true
		end
		if data.punish then
			self.punish = data.punish
		end
	end
end

function self:ForceRNE(forced)
	if forced ~= nil and forced then
		CheckPlayers(true)
	end
end

local function DoRNEChance(inst)
	if TheWorld.state.iscaveday then

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
		--TheNet:Announce("DIDRNECHANCE")
		local playerchancescaling = TUNING.DSTU.RNE_CHANCE
		local days_survived = player.components.age ~= nil and player.components.age:GetAgeInDays()
		if days_survived >= 5 and math.random() >= playerchancescaling then
			self.rnequeued = true
			self.playertarget = player
		end
		--[[if self.rnequeued then
			TheNet:Announce("true")
		else
			TheNet:Announce("false")
		end]]
	end
end

inst:ListenForEvent("ms_playerjoined", OnPlayerJoined)
inst:ListenForEvent("ms_playerleft", OnPlayerLeft)

self:WatchWorldState("iscavenight", function() self.inst:DoTaskInTime(10, TryRandomNightEvent) end)
self:WatchWorldState("iscaveday", function() self.inst:DoTaskInTime(0, DoRNEChance) end)
self:WatchWorldState("cycleschanged", function() self.inst:DoTaskInTime(5, TryRandomNightEvent) end)
self:WatchWorldState("cycleschanged", function() self.inst:DoTaskInTime(0, DoRNEChance) end)
end)