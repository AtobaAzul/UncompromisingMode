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
----------------------------------------------------
--RNE list below
----------------------------------------------------
local function SpawnBats(player)
	print("SpawnBats")
	player:DoTaskInTime(5, function()
		if TheWorld.state.cycles <= 10 then
			local x, y, z = player.Transform:GetWorldPosition()
			local day = TheWorld.state.cycles
			local num_bats = 3
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
			local num_bats = math.min(2 + math.floor(day/35), 6)
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

local function SpawnFissures(player)
	print("SpawnFissures")
	player:DoTaskInTime(5, function()
			local x, y, z = player.Transform:GetWorldPosition()
			local fissures = 3+math.floor(math.random()*3)
			for i = 1, fissures do
				player:DoTaskInTime(0.2 * i + math.random(4) * 0.3, function()
					local fissure = SpawnPrefab("rnefissure")
					fissure.Transform:SetPosition(x + math.random(-8,8), y, z + math.random(-8,8))
				end)
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

    table.insert(self.wildevents, { name = name, weight = weight })
    self.totalrandomwildweight = self.totalrandomwildweight + weight
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
------------------------
--Inclusion and Tuning
------------------------
--Wild
AddWildEvent(SpawnBats,1)
--Base
AddBaseEvent(SpawnBats,1)
AddBaseEvent(SpawnFissures,1)
--Cave
AddCaveEvent(SpawnBats,1)

------------------------
--Inclusion and Tuning
------------------------

local function DoBaseRNE(player)
	if TheWorld.state.isnight then
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
	if TheWorld.state.isnight then
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
		if IsEligible(v) then
			table.insert(playerlist, v)
		end
	end
	shuffleArray(playerlist)
	if #playerlist == 0 then
		return
	end
	local numStructures = 0
		for i, v in ipairs(playerlist) do  --try a base RNE
		local x,y,z = v.Transform:GetWorldPosition()
		local ents = TheSim:FindEntities(x,y,z, STRUCTURE_DIST, {"structure"})
		numStructures = #ents
			if numStructures >= 4 then
			DoBaseRNE(v)
			print("found base")
			return
			end
		end
		for i, v in ipairs(playerlist) do --noone was home, so we'll do RNEs at every player instead
		DoWildRNE(v)
		print("no find base")
		end
end


local function TryRandomNightEvent()      --Canis said 20% chance each night to have a RNE, could possibly include a scaling effect later
	--if math.random >= 0.8 then		--enable after testing
	CheckPlayers()
	print("trying RNE")
	--end								--enable after testing
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
self:WatchWorldState("isnight", TryRandomNightEvent) --RNE could happen any night
end)
