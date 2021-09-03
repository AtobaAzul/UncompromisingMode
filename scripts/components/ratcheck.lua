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
local _initialrattimer = 24000

local _worldsettingstimer = TheWorld.components.worldsettingstimer
local RATRAID_TIMERNAME = "rat_raid"

--------------------------------------------------------------------------
--[[ Private member functions ]]
--------------------------------------------------------------------------

local function CooldownRaid(src, data)
		_respawntime = nil
		_raided = false
		print("cooldown raid")
end

local function Print()
	print(_respawntime)
	print(_raided)
end

local function StartTimer()
	--local _time = 20 + math.random(20)
	local _time = 9600 + math.random(4800)
	_worldsettingstimer:StartTimer(RATRAID_TIMERNAME, _time)
end

local function StartTimerShort()
	--local _time = 20 + math.random(20)
	local _time = 3840 + math.random(960)
	_worldsettingstimer:StartTimer(RATRAID_TIMERNAME, _time)
end

function self:OnPostInit()										    --VVVV-- INPUT CONFIG BOOL HERE
    _worldsettingstimer:AddTimer(RATRAID_TIMERNAME, _initialrattimer, true, CooldownRaid)
	_worldsettingstimer:StartTimer(RATRAID_TIMERNAME, _initialrattimer)
end

local function ChangeRatTimer(data)

	local value = data ~= nil and data.value ~= nil and data.value or 240

	
	if _worldsettingstimer:GetTimeLeft(RATRAID_TIMERNAME) ~= nil then
		local currenttime = _worldsettingstimer:GetTimeLeft(RATRAID_TIMERNAME)
		local timeleft = (currenttime - value)
		
		print(currenttime)
		print(timeleft)
		
		if timeleft <= 0 then
			_worldsettingstimer:SetTimeLeft(RATRAID_TIMERNAME, 1)
		else
			_worldsettingstimer:SetTimeLeft(RATRAID_TIMERNAME, timeleft)
		end
	end
		
			

--[[
    if _respawntime ~= nil and value ~= nil then
        _respawntime = _respawntime - value
		_cooldown = TheWorld:DoTaskInTime(_respawntime, CooldownRaid)
		print(value)
		print(_respawntime)
		TheWorld:DoTaskInTime(0, Print)
    end]]
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
			local ratburrow = SpawnPrefab("uncompromising_ratburrow")
			ratburrow.Transform:SetPosition(inst.x1, 0, inst.z1)
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
				TheWorld:PushEvent("ratcooldown", inst)
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
			TheWorld:PushEvent("ratcooldown", inst)
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
		print("No burrow, so make one ya dink!")
		MakeRatBurrow(inst)
		TheWorld:PushEvent("ratcooldownshort", inst)
	end
	
	--print("Rat Raid Warning :", ratwarning)
end

local function ActiveRaid(src, data)
	print("Active Raid")
	
	if data.doer == nil and data.container ~= nil then
		data.doer = data.container:GetNearestPlayer(true)
	end
	
    if data ~= nil and data.doer ~= nil and data.container ~= nil then
		print("Found a Doer!")
		if not data.doer or not data.doer:IsValid() or not data.doer.Transform or not IsEligible(data.doer) then
			return
		end
		
		print("Doer is valid!")
		
		local x, y, z = data.doer.Transform:GetWorldPosition()
		local ents = TheSim:FindEntities(x, y, z, 20, nil, nil, {"_inventoryitem"})
		if IsEligible(data.doer) and
			not TheWorld:HasTag("cave") and
			not (_raided ~= nil and _raided) and
			not data.container.components.container:IsEmpty() and
			#ents >= 20 then
			print("GOGO NINJA RATORIO")
			
			_raided = true
			
			data.container:DoTaskInTime(3, StartRaid, data.doer)
		else
			local currenttime = _worldsettingstimer:GetTimeLeft(RATRAID_TIMERNAME)
			print(currenttime)
			
			if #ents <= 20 then
				print("CAN'T SPAWN RATS! There aren't enough items around!")
			end
			
			if data.container.components.container:IsEmpty() then
				print("CAN'T SPAWN RATS! This container is empty!")
			end
			
			if not IsEligible(data.doer) then
				print("CAN'T SPAWN RATS! Player is in a 'safe' zone!")
			end
			
			if (_raided ~= nil and _raided) then
				print("CAN'T SPAWN RATS! They are on break!")
			end
			
			return
		end
    end
end

function self:OnSave()

	--[[if _respawntime ~= nil then
        local _time = GetTime()
        if _respawntime > _time then
            _respawntimeremaining = _respawntime - _time
        end
    end]]
	
	local data =
	{
		raided = _raided,
		--respawntimeremaining = _respawntimeremaining,
	}
	
	return data
end

function self:OnLoad(data)
    if data.raided ~= nil then
		_raided = data.raided
	end
		
    --[[if data.respawntimeremaining ~= nil then
        _respawntime = data.respawntimeremaining + GetTime()
		_cooldown = TheWorld:DoTaskInTime(_respawntime, CooldownRaid)
		print(_respawntime)
		TheWorld:DoTaskInTime(0, Print)
    end]]
end

self.inst:ListenForEvent("ratcooldown", StartTimer, TheWorld)
self.inst:ListenForEvent("ratcooldownshort", StartTimerShort, TheWorld)
self.inst:ListenForEvent("activeraid", ActiveRaid, TheWorld)
self.inst:ListenForEvent("ms_oncroprotted", ChangeRatTimer, TheWorld)
self.inst:ListenForEvent("reducerattimer", ChangeRatTimer, TheWorld)

end)