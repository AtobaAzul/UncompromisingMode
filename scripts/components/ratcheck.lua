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

self.inst:ListenForEvent("ratcooldown", StartTimer, TheWorld)

end)