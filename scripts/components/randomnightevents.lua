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

local function LeifAttack(player)
print("leifattack")
local leiftime = 8 + math.random() * 3
MultiFogAuto(player,leiftime)
local days_survived = player.components.age ~= nil and player.components.age:GetAgeInDays()
for k = 1, (days_survived <= 30 and 1) or math.random(days_survived <= 80 and 2 or 3) do
                    local target = FindEntity(player, TUNING.LEIF_MAXSPAWNDIST, find_leif_spawn_target, { "evergreens", "tree" }, { "leif", "stump", "burnt" })
                    if target ~= nil then
					print("targetfound")
                        target.noleif = true
						target.chopper = player
                        target.leifscale = 1 --GetGrowthStages(target)[target.components.growable.stage].leifscale or 1 Getting size is muck
                            --assert(GetBuild(target).leif ~= nil)
						target:DoTaskInTime(leiftime, spawn_leif)
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
					local monkey = SpawnPrefab("monkey")
					if math.random()>0.5 then
					monkey.Transform:SetPosition(x + math.random(12,16), y, z + math.random(12,16))
					else
					monkey.Transform:SetPosition(x - math.random(12,16), y, z - math.random(12,16))
					end
				end)
			end
	end)
end

local function FireHungryGhostAttack(player)
	print("ooooOOOOoooo")
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
				end)
			end
	end)
end

local function SpawnBats(player)
	print("SpawnBats")
	local battime = 10 * math.random() * 2
	MultiFogAuto(player,battime)
	player:DoTaskInTime(battime, function()
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
	local skitttime = 10 * math.random() * 2
	MultiFogAuto(player,skitttime)
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

local function SpawnFissures(player)
	print("SpawnFissures")
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

local function ChessPiece(player)
	if TheWorld.state.isnewmoon and TheWorld.state.cycles > 10 then
		print("Shadows...")
		local x, y, z = player.Transform:GetWorldPosition()
		local chesscheck = math.random()
		player:DoTaskInTime(0.6 + math.random(4), function()
			if chesscheck >= 0.66 then
				local piece = SpawnPrefab("shadow_bishop")
				piece.Transform:SetPosition(x + math.random(-7,7), y, z + math.random(-7,7))
			elseif chesscheck >= 0.33 and chesscheck < 0.66 then
				local piece = SpawnPrefab("shadow_rook")
				piece.Transform:SetPosition(x + math.random(-7,7), y, z + math.random(-7,7))
			else
				local piece = SpawnPrefab("shadow_knight")
				piece.Transform:SetPosition(x + math.random(-7,7), y, z + math.random(-7,7))
			end
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
AddWildEvent(SpawnBats,0.5)
AddWildEvent(SpawnLightFlowersNFerns,0.3)
AddWildEvent(SpawnSkitts,.5)
AddWildEvent(SpawnMonkeys,0.2)
AddWildEvent(LeifAttack,.3)
--Base
AddBaseEvent(SpawnBats,.3)
AddBaseEvent(SpawnFissures,.3)
AddBaseEvent(SpawnSkitts,.5)
AddBaseEvent(FireHungryGhostAttack,.5)
--Cave
AddCaveEvent(SpawnBats,1)
AddCaveEvent(SpawnFissures,1)
--Spring
AddSpringEvent(SpawnThunderFar,1)
--Full Moon
AddFullMoonEvent(MoonTear,1)
--New Moon
AddNewMoonEvent(ChessPiece,1)

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
	
	if math.random() >= 0.8 or TheWorld.state.isfullmoon and math.random() >= 0.5 or TheWorld.state.isnewmoon and math.random() >= 0.75 then
		
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
								if TheWorld.state.isfullmoon then
									print("fullmoon")
									DoFullMoonRNE(v)
								elseif TheWorld.state.isnewmoon then
									print("newmoon")
									DoNewMoonRNE(v)
								else
									DoBaseRNE(v)
								end
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
							if TheWorld.state.isfullmoon then
								print("fullmoon")
								DoFullMoonRNE(v)
							elseif TheWorld.state.isnewmoon then
								print("newmoon")
								DoNewMoonRNE(v)
							else
								DoWildRNE(v)
							end
							v:AddTag("rnetarget")
							v:DoTaskInTime(60,v:RemoveTag("rnetarget"))
						end
				print("no find base")
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
self:WatchWorldState("isnight", function() self.inst:DoTaskInTime(5, TryRandomNightEvent) end) --RNE could happen any night
--self:WatchWorldState("isnight", TryRandomNightEvent) --RNE could happen any night
end)
