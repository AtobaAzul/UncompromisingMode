--local Ratcheck = Class(function(self, inst)

return Class(function(self, inst)

--assert(TheWorld.ismastersim, "Ratcheck should not exist on client")

--------------------------------------------------------------------------
--[[ Public Member Variables ]]
--------------------------------------------------------------------------

self.inst = inst

--------------------------------------------------------------------------
--[[ Private Member Variables ]]
--------------------------------------------------------------------------

local _ratraid = nil
local _cooldown = nil
local _respawntime = nil
local _time = nil
local _raided = true
local _respawntimeremaining = nil
local ratwarning = nil
--local _initialrattimer = 24000
local _initialrattimer = TUNING.DSTU.RATRAID_TIMERSTART --24000
local _rattimer = TUNING.DSTU.RATRAID_TIMERSTART --24000
local _rattimer_variance = _rattimer / 3 --24000
local _rattimer_short = TUNING.DSTU.RATRAID_TIMERSTART / 3 --24000
local _rattimer_short_variance = _rattimer_short / 3 --24000
local _ratsnifftimer = TUNING.DSTU.RATSNIFFER_TIMER
local _ratgrace = TUNING.DSTU.RATRAID_GRACE
local _ratburrows = 0

local RATRAID_TIMERNAME = "rat_raid"

--------------------------------------------------------------------------
--[[ Private member functions ]]
--------------------------------------------------------------------------

local function CooldownRaid(src, data)
		_respawntime = nil
		_raided = false
		--print("cooldown raid")
end

local function Print()
	--print(_respawntime)
	--print(_raided)
end

local function StartRatTimer()
	--local _time = 20 + math.random(20)
	local _time = _rattimer + math.random(_rattimer_variance)
	
	_initialrattimer = _time
end

local function StartTimerShort()
	--local _time = 20 + math.random(20)
	local _time = _rattimer_short + math.random(_rattimer_short_variance)
	
	_initialrattimer = _time
end

local function ChangeRatTimer(src, data)
	local value = data ~= nil and data.value ~= nil and data.value or 60
	if _initialrattimer > 0 then
		if value ~= nil and value < 0 and _initialrattimer < _rattimer then
			_initialrattimer = _initialrattimer - value
			--print("increase timer")
			--print(_initialrattimer)
		elseif value ~= nil and value > 0 then
			_initialrattimer = _initialrattimer - value
			--print("reduce timer")
			--print(_initialrattimer)
		end
	else
		--print("Rats are ready :)")
	end
end

local function MakeRatBurrow(inst)
	local x, y, z = inst.Transform:GetWorldPosition()

    local function IsValidRatBurrowPosition(x, z)
        if #TheSim:FindEntities(x, 0, z, TUNING.ANTLION_SINKHOLE.RADIUS, { "antlion_sinkhole_blocker" }) > 0 then
            return false
        end
        if #TheSim:FindEntities(x, 0, z, 50, { "player", "playerghost" }) > 0 then
            return false
        end
		
        for dx = -1, 1 do
            for dz = -1, 1 do
                if not TheWorld.Map:IsPassableAtPoint(x + dx * TUNING.ANTLION_SINKHOLE.RADIUS, 0, z + dz * TUNING.ANTLION_SINKHOLE.RADIUS, false, true) then
                    return false
                end
            end
        end
        return true
    end
	
	for i = 1, 4 do
		inst.x1, inst.z1 = x + math.random(-200, 200), z + math.random(-200, 200)
		
		if IsValidRatBurrowPosition(inst.x1, inst.z1) then
			TheFocalPoint.SoundEmitter:PlaySound("turnoftides/creatures/together/carrat/reaction")
		
			local ratburrow = SpawnPrefab("uncompromising_ratburrow")
			ratburrow.Transform:SetPosition(inst.x1, 0, inst.z1)
			
			local x, y, z = inst.Transform:GetWorldPosition()
	
			local players = #TheSim:FindEntities(x, y, z, 30, { "player" })
					
			if math.random() >= 0.7 then
				if players < 1 then
					local piper = SpawnPrefab("pied_rat")
						
					piper.Transform:SetPosition(inst.Transform:GetWorldPosition())
					ratburrow.components.herd:AddMember(piper)
				end
			end
			
			break
		end
	end
end

local function SpawnRaid(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	local players = FindPlayersInRange(x, y, z, 50)
	if players ~= nil then
		for i, v in ipairs(players) do
			local raid = SpawnPrefab("uncompromising_ratherd")
			local x2 = x + math.random(-10, 10)
			local z2 = z + math.random(-10, 10)
			if TheWorld.Map:IsPassableAtPoint(x2, 0, z2) then
				raid.Transform:SetPosition(x + math.random(-10, 10), y, z + math.random(-10, 10))
				--TheWorld:DoTaskInTime(9600 + math.random(4800), CooldownRaid)
				--TheWorld:PushEvent("ratcooldown", inst)
				--TheWorld.components.ratcheck:StartTimer()
			end
		end
	else
		local raid = SpawnPrefab("uncompromising_ratherd")
		local x2 = x + math.random(-10, 10)
		local z2 = z + math.random(-10, 10)
		if TheWorld.Map:IsPassableAtPoint(x2, 0, z2) then
			raid.Transform:SetPosition(x + math.random(-10, 10), y, z + math.random(-10, 10))
			--TheWorld:DoTaskInTime(9600 + math.random(4800), CooldownRaid)
			--TheWorld:PushEvent("ratcooldown", inst)
			--TheWorld.components.ratcheck:StartTimer()
		end
	end
end

local function SoundRaid(inst)
	if ratwarning ~= nil then
		inst.SoundEmitter:PlaySound("turnoftides/creatures/together/carrat/stunned", "ratwarning")
		inst.SoundEmitter:SetParameter("ratwarning", "size", ratwarning)
		inst:DoTaskInTime(math.random(10 / ratwarning, 15 / ratwarning), SoundRaid)
	end
end

local function IsEligible(doer)
	local area = doer.components.areaaware
	return TheWorld.Map:IsVisualGroundAtPoint(doer.Transform:GetWorldPosition())
			and area:GetCurrentArea() ~= nil 
			and not area:CurrentlyInTag("nohasslers")
end


local function StartRaid(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	local players = FindPlayersInRange(x, y, z, 50)
	
	local ratburrow = TheSim:FindFirstEntityWithTag("ratburrow")
	
	if ratburrow ~= nil then
		TheWorld:PushEvent("ratcooldown", inst)
		
		if ratwarning == nil then
			ratwarning = 0
		else
			ratwarning = ratwarning + 1
		end
		if ratwarning == 1 then
			inst:DoTaskInTime(0, SoundRaid)
		end
		if ratwarning == 3 then
			for i, v in ipairs(players) do
				if not IsEligible(v) then
					v.components.talker:Say(GetString(v, "ANNOUNCE_RATRAID"))
				end
			end
		end
		if ratwarning == 10 then
			inst:DoTaskInTime(1, SpawnRaid)
			ratwarning = nil
		else
			inst:DoTaskInTime(math.random(3, 6), StartRaid)
		end
		
	else
		TheWorld:PushEvent("ratcooldownshort", inst)
		--print("No burrow, so make one ya dink!")
		MakeRatBurrow(inst)
	end
	
	--print("Rat Raid Warning :", ratwarning)
end

local function ActiveRaid(src, data)
	--print("Active Raid")
	
	if data.doer == nil and data.container ~= nil then
		data.doer = data.container:GetNearestPlayer(true)
	end
	
	local x, y, z = data.doer.Transform:GetWorldPosition()
	
    if data ~= nil and data.doer ~= nil and data.container ~= nil then
		--print("Found a Doer!")
		if not data.doer or not data.doer:IsValid() or not data.doer.Transform or not IsEligible(data.doer) then
			return
		end
		
		--print("Doer is valid!")
		
		local ents = TheSim:FindEntities(x, y, z, 30, nil, {"cattoy"}, {"_inventoryitem"})
		if IsEligible(data.doer) and
			not TheWorld:HasTag("cave") and
			not (_raided ~= nil and _raided) and
			--[[not data.container.components.container:IsEmpty() and]]
			#ents >= 20 then
			--print("GOGO NINJA RATORIO")
			
			_raided = true
			
			data.container:DoTaskInTime(0, StartRaid, data.doer)
		else
			--print(_initialrattimer)
			
			if #ents <= 20 then
				--print("CAN'T SPAWN RATS! There aren't enough items around!")
			else
				if #TheSim:FindEntities(x, y, z, 30, { "structure" }) > 3 then
					local ratchecker = TheSim:FindFirstEntityWithTag("rat_sniffer")
					if ratchecker ~= nil then
						ratchecker.Transform:SetPosition(x, 0, z)
					else
						SpawnPrefab("uncompromising_ratsniffer").Transform:SetPosition(x, 0, z)
					end
				end
			end
			
			
			if data.container.components.container:IsEmpty() then
				--print("CAN'T SPAWN RATS! This container is empty!")
			end
			
			if not IsEligible(data.doer) then
				--print("CAN'T SPAWN RATS! Player is in a 'safe' zone!")
			end
			
			if (_raided ~= nil and _raided) then
				--print("CAN'T SPAWN RATS! They are on break!")
			end
		end
		
		
    end
end

local function IncreaseDens(data)
	_ratburrows = _ratburrows + 1
	--print("INCREASED RAT BURROWS TO ".._ratburrows)
end

local function DecreaseDens(data)
	_ratburrows = _ratburrows - 1
	--print("DECREASED RAT BURROWS TO ".._ratburrows)
end

function self:GetBurrows()
    return _ratburrows
end

function self:OnUpdate(dt)
	if _ratsnifftimer then
		if _ratsnifftimer > 0 then
			_ratsnifftimer = _ratsnifftimer - dt --(dt * _ratburrows)
			--print(_ratsnifftimer)
			--print(_ratburrows)
		else
			_ratsnifftimer = TUNING.DSTU.RATSNIFFER_TIMER
            --TheWorld:PushEvent("rat_sniffer")
			local ratchecker = TheSim:FindFirstEntityWithTag("rat_sniffer")
			
			if ratchecker ~= nil then
				ratchecker:PushEvent("rat_sniffer")
			end
		end
	end
	
	if _initialrattimer <= 0 and _raided then
		TheWorld:PushEvent("cooldownraid")
	end
end

function self:LongUpdate(dt)
	if TheWorld.state.cycles > _ratgrace then
		self:OnUpdate(dt)
	end
end

local function StartRespawnTimer()
	if TheWorld.state.cycles > _ratgrace then
		self.inst:StartUpdatingComponent(self)
	end
end

function self:OnSave()
	local data =
	{
		raided = _raided,
		ratsnifftimer = _ratsnifftimer,
		initialrattimer = _initialrattimer,
	}
	
	return data
end

function self:OnLoad(data)
    if data.raided ~= nil then
		_raided = data.raided
	end
		
    if data.ratsnifftimer ~= nil then
		_ratsnifftimer = data.ratsnifftimer
	end
		
    if data.initialrattimer ~= nil then
		_initialrattimer = data.initialrattimer
	end
	
	StartRespawnTimer()
end


StartRespawnTimer()
self.inst:WatchWorldState("cycles", StartRespawnTimer)
self.inst:ListenForEvent("ratcooldown", StartRatTimer, TheWorld)
self.inst:ListenForEvent("ratcooldownshort", StartTimerShort, TheWorld)
self.inst:ListenForEvent("activeraid", ActiveRaid, TheWorld)
self.inst:ListenForEvent("ms_oncroprotted", ChangeRatTimer, TheWorld)
self.inst:ListenForEvent("reducerattimer", ChangeRatTimer, TheWorld)
self.inst:ListenForEvent("DenSpawned", IncreaseDens, TheWorld)
self.inst:ListenForEvent("DenRemoved", DecreaseDens, TheWorld)
self.inst:ListenForEvent("cooldownraid", CooldownRaid, TheWorld)

end)