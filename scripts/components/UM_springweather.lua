return Class(function(self, inst)

assert(TheWorld.ismastersim, "UM_springweather should not exist on client")

self.inst = inst

self.threat = nil   
self.time = 0
self.previousthreat = self.threat

local _targetplayer = nil
local _activeplayers = {}

function self:PickThreat() -- This function is called when the world decides to pick the springthreat
	local threat = "monsoon"
	if self.previousthreat == nil then -- First choice is always a 50/50
		if math.random() > 0.5 then
			threat = "monsoon"
		else
			threat = "lush"
		end
	end
	if self.previousthreat ~= nil then
		TheNet:Announce("previousthreat wasn't nil!")
		if TheWorld.state.cycles < 120 then -- Always pick the opposite threat during the second year
			TheNet:Announce("world age is less than 120, cycles! previousthreat was ".. self.previousthreat)
			if self.previousthreat == "lush" then
				self.threat = "monsoon"
			else
				self.threat = "lush"
			end
		else
			if self.previousthreat == "lush" then -- Make it more likely, but not guaranteed, to choose the opposite
				if math.random() > 0.25 then
					self.threat = "monsoon"
				else
					self.threat = "lush"
				end
			else
				if math.random() > 0.25 then
					self.threat = "lush"
				else
					self.threat = "monsoon"
				end
			end
		end
	end
	return threat
end

local function OnPlayerJoined(src,player)
    for i, v in ipairs(_activeplayers) do
        if v == player then
            return
        end
    end
    table.insert(_activeplayers, player)	
end

local function OnPlayerLeft(src,player)
	--print("Player ", player, "left, targetplayer is ", _targetplayer or "nil")
    for i, v in ipairs(_activeplayers) do
        if v == player then
            table.remove(_activeplayers, i)
            if player == _targetplayer then 
            	_targetplayer = nil
            end
            return
        end
    end
end

local function OnSeasonTick(src, data)
	--TheNet:SystemMessage("Time is: "..self.time)
	if self.time <= 0 then
		if TheWorld.state.isspring then
			TheNet:SystemMessage("DECIDING")
			self.threat = self:PickThreat()
			self.previousthreat = self.threat -- For earlygame, making sure you can't get double early, and later making it less likely.
			
			self.time = 25 -- How many ticks it should take till the next flip-flop of threats... it's longer than the default season length
		else			   -- If for some reason there were a spring-only world then the seasons might actually flip-flop during the same spring
			self.threat = nil
		end
	else
		self.time = self.time - 1
	end
	
	for i, v in ipairs(AllPlayers) do
		if TheWorld.state.isspring and TheWorld.state.remainingdaysinseason <= TUNING.SPRING_LENGTH - 1 and self.threat == "lush" and not v.components.UM_hayfever.enabled and TheWorld.state.cycles >= TUNING.DSTU.WEATHERHAZARD_START_DATE then
				v.components.UM_hayfever:Enable()
		elseif not TheWorld.state.isspring or not self.threat == "lush" then
				v.components.UM_hayfever:Disable()
		end
    end
	if self.threat ~= nil then
		TheNet:SystemMessage("Threat is: "..self.threat)
	else
		TheNet:SystemMessage("No defined springthreat")
	end
	if self.previousthreat ~= nil then
		TheNet:SystemMessage("Previous Threat is: "..self.previousthreat)
	else
		TheNet:SystemMessage("No defined previousthreat")
	end
end

for i, v in ipairs(AllPlayers) do
    table.insert(_activeplayers, v)
end

function self:OnSave()
	local data = {}
	data.threat = self.threat
	data.time = self.time
	data.previousthreat = self.previousthreat
	return data
end

function self:OnLoad(data)
	if data then
		self.threat = data.threat
		self.time = data.time
		self.previousthreat = data.previousthreat
	end
end

self.inst:ListenForEvent("ms_playerjoined", OnPlayerJoined, TheWorld)
self.inst:ListenForEvent("ms_playerleft", OnPlayerLeft, TheWorld)

self.inst:ListenForEvent("seasontick", OnSeasonTick, TheWorld)

end)