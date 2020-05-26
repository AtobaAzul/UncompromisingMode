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
--RNE Fog Controller Functions Below
--------------------------------
local function StopFog(player)
	if player:HasTag("infog") then
		player:RemoveTag("infog")
--print("stopfog") 
	end
end

local function StartFog(player)
	if not player:HasTag("infog") then
		player:AddTag("infog")
	--print("startfog") 
	end
end

local function StartFogAuto(player,x) --This should deactivate fog after 15 seconds or x time if you don't want to include StopFog(player)
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

--------------------------------
--RNE Moon Tear function
--------------------------------

local function MoonTear(player)
	if TheWorld.state.isfullmoon then
		print("The Moon is Crying")
		local x, y, z = player.Transform:GetWorldPosition()
		player:DoTaskInTime(0.6 + math.random(4), function()
			local tear = SpawnPrefab("moon_tear_meteor")
			tear.Transform:SetPosition(x + math.random(-7,7), y, z + math.random(-7,7))
		end)
	end
end

----------------------------------------------------
--RNE list below
----------------------------------------------------
local function SpawnBats(player)
	print("SpawnBats")
	player:DoTaskInTime(5, MoonTear)
	player:DoTaskInTime(10 * math.random() * 2, function()
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

local function SpawnSkitts(player)
	print("SpawnSkitts")
	player:DoTaskInTime(5, MoonTear)
	player:DoTaskInTime(10 * math.random() * 2, function()
			local x, y, z = player.Transform:GetWorldPosition()
			local num_skitts = 150
			for i = 1, num_skitts do
				player:DoTaskInTime(0.2 * i + math.random() * 0.3, function()
					local skitts = SpawnPrefab("shadowskittish")
					skitts.Transform:SetPosition(x + math.random(-12,12), y, z + math.random(-12,12))
				end)
			end
	end)
end

local function SpawnFissures(player)
	print("SpawnFissures")
	player:DoTaskInTime(5, MoonTear)
	local tillrne = 10 + math.random(10,15)
	MultiFogAuto(player,tillrne)
	player:DoTaskInTime(tillrne, function()
			local x, y, z = player.Transform:GetWorldPosition()
			local fissures = 3+math.floor(math.random()*3, 4)
			for i = 1, fissures do
				player:DoTaskInTime(0.2 * i + math.random(4) * 0.3, function()
					local fissure = SpawnPrefab("rnefissure")
					fissure.Transform:SetPosition(x + math.random(-10,10), y, z + math.random(-10,10))
				end)
			end
	end)
end

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
			local thunders = math.random(18,25)
			for i = 1, thunders do
				player:DoTaskInTime(0.6 * i + math.random(4) * 0.3, function()
					--local thunder = SpawnPrefab("thunder_far")
					--thunder.Transform:SetPosition(x + math.random(-10,10), y, z + math.random(-10,10))
					SpawnPrefab("thunder_far")
					player:DoTaskInTime(10 * math.random(), SpawnThunderClose)
				end)
			end
			StopFog(player)
	end)
end

local function SpawnLightFlowersNFerns(player)
	player:DoTaskInTime(5, MoonTear)
	player:DoTaskInTime(5+math.random(5,10), function()
			local x, y, z = player.Transform:GetWorldPosition()
			local ents = 7+math.floor(math.random()*3)
			for i = 1, ents do
				player:DoTaskInTime(0.2 * i + math.random(4) * 0.3, function()
				if math.random() > 0.7 then
					local flowerdbl = SpawnPrefab("stalker_bulb_double")
					flowerdbl.Transform:SetPosition(x + math.random(-8,8), y, z + math.random(-8,8))
				else
					if math.random() > 0.7 then
						local flowersng = SpawnPrefab("stalker_bulb")
						flowersng.Transform:SetPosition(x + math.random(-8,8), y, z + math.random(-8,8))				
					else
						local fern = SpawnPrefab("stalker_fern")
						fern.Transform:SetPosition(x + math.random(-8,8), y, z + math.random(-8,8))
					end
				end
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

local function AddSpringEvent(name, weight)
    if not self.springevents then
        self.springevents = {}
        self.totalrandomspringweight = 0
    end

    table.insert(self.springevents, { name = name, weight = weight })
    self.totalrandomspringweight = self.totalrandomspringweight + weight
end

------------------------
--Inclusion and Tuning
------------------------
--Wild
AddWildEvent(SpawnBats,1)
AddWildEvent(SpawnLightFlowersNFerns,0.3)
AddWildEvent(SpawnSkitts,.5)
--Base
AddBaseEvent(SpawnBats,.3)
AddBaseEvent(SpawnFissures,.3)
AddBaseEvent(SpawnSkitts,.5)
--Cave
AddCaveEvent(SpawnBats,1)
AddCaveEvent(SpawnFissures,1)
--Spring
AddSpringEvent(SpawnThunderFar,1)

------------------------
--Inclusion and Tuning
------------------------

local function DoBaseRNE(player)
print("done")
	if math.random() >= .5 and TheWorld.state.isspring and TheWorld.state.isnight then
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
	if math.random() >= .5 and TheWorld.state.isspring and TheWorld.state.isnight then
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
		local rnepl = 0
		local x,y,z = v.Transform:GetWorldPosition()
		local ents = TheSim:FindEntities(x,y,z, STRUCTURE_DIST, {"structure"})
		numStructures = #ents
			if numStructures >= 4 then
				local m,n,o = v.Transform:GetWorldPosition()
				local rnep = TheSim:FindEntities(m,n,o, STRUCTURE_DIST, {"rnetarget"})
				rnepl = #rnep
						if rnepl < 2 then
							DoBaseRNE(v)
				print("found base")
							v:AddTag("rnetarget")
							v:DoTaskInTime(60,inst:RemoveTag("rnetarget"))
						end
		else
		for i, v in ipairs(playerlist) do --noone was home, so we'll do RNEs at every player instead
				local rnepl = 0
				local m,n,o = v.Transform:GetWorldPosition()
				local rnep = TheSim:FindEntities(m,n,o, STRUCTURE_DIST, {"rnetarget"})
				rnepl = #rnep
					if rnepl < 2 then
						DoWildRNE(v)
						v:AddTag("rnetarget")
						v:DoTaskInTime(60,v:RemoveTag("rnetarget"))
					end
			print("no find base")
			end
		end
	end
end

local function TryRandomNightEvent()      --Canis said 20% chance each night to have a RNE, could possibly include a scaling effect later
	--if math.random >= 0.8 then		--enable after testing
	CheckPlayers()
	--print("trying RNE")
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
