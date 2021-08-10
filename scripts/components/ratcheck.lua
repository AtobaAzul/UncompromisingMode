--local Ratcheck = Class(function(self, inst)

return Class(function(self, inst)

--assert(TheWorld.ismastersim, "Ratcheck should not exist on client")

self.inst = inst

local _ratraid = nil
local _cooldown = nil
local _respawntime = nil
local _time = nil
local _raided = nil
local _respawntimeremaining = nil
local ratwarning = nil

local function CooldownRaid()
	_respawntime = nil

	if TheWorld.net ~= nil then
		TheWorld.net:RemoveTag("raided")
	end
	TheWorld:RemoveTag("raided")
	print("Rat Raid Cooldown is over.")
end

local function Print()
	print(_respawntime)
	if TheWorld.net ~= nil then
		TheWorld.net:AddTag("raided")
	end
	TheWorld:AddTag("raided")
end

local function StartTimer()
	--local _time = 20 + math.random(20)
	local _time = 9600 + math.random(4800)
	_cooldown = TheWorld:DoTaskInTime(_time, CooldownRaid)
    _respawntime = _time
	print(_respawntime)
end

function self:OnSave()
	
	if (TheWorld.net ~= nil and TheWorld.net:HasTag("raided")) or TheWorld:HasTag("raided") then
		_raided = true
	end

	if _respawntime ~= nil then
        local _time = GetTime()
        if _respawntime > _time then
            _respawntimeremaining = _respawntime - _time
        end
    end
	
	local data =
	{
		raided = _raided,
		respawntimeremaining = _respawntimeremaining,
	}
	
	return data
end

function self:OnLoad(data)
		
    if data.respawntimeremaining ~= nil then
        _respawntime = data.respawntimeremaining + GetTime()
		_cooldown = TheWorld:DoTaskInTime(_respawntime, CooldownRaid)
		print(_respawntime)
		TheWorld:DoTaskInTime(0, Print)
    end
end

local function ChangeRatTimer(data)

	local value = data ~= nil and data.value ~= nil and data.value or 240

    if _respawntime ~= nil and value ~= nil then
        _respawntime = _respawntime - value
		_cooldown = TheWorld:DoTaskInTime(_respawntime, CooldownRaid)
		print(value)
		print(_respawntime)
		TheWorld:DoTaskInTime(0, Print)
    end
end

local function CooldownRaid(inst)
	if TheWorld.net ~= nil then
		TheWorld.net:RemoveTag("raided")
	end

	TheWorld:RemoveTag("raided")
	--print("Rat Raid Cooldown is over.")
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
		local playerage = data.doer.components.age ~= nil and data.doer.components.age:GetAgeInDays()
		local ents = TheSim:FindEntities(x, y, z, 20, nil, nil, {"_inventoryitem"})
		if playerage >= 50 and math.random() > 0.05 and IsEligible(data.doer) and
			not TheWorld:HasTag("cave") and
			not (TheWorld.net ~= nil and TheWorld.net:HasTag("raided")) and
			not data.container.components.container:IsEmpty() and
			#ents >= 20 then
			print(playerage.." day's have passed! Go!")
			if TheWorld.net ~= nil then
				TheWorld.net:AddTag("raided")
			end
			
			TheWorld:AddTag("raided")
			--print("Rat Raid Triggered !")
			data.container:DoTaskInTime(3, StartRaid, data.doer)
		else
			print("But only "..playerage.." day's have passed, needs to be 50+!")
			print("...or, there aren't enough inventory items around.")
			return
		end
    end
end

self.inst:ListenForEvent("ratcooldown", StartTimer, TheWorld)
self.inst:ListenForEvent("activeraid", ActiveRaid, TheWorld)
self.inst:ListenForEvent("ms_oncroprotted", ChangeRatTimer, TheWorld)

end)