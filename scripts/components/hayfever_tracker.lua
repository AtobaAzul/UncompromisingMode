return Class(function(self, inst)

assert(TheWorld.ismastersim, "Hayfever_tracker should not exist on client")

self.inst = inst

--local _isspring = false
local _queenkilled = nil

local _targetplayer = nil
local _activeplayers = {}
local queenkill = nil

local function OnPlayerJoined(src,player)
    for i, v in ipairs(_activeplayers) do
        if v == player then
            return
        end
    end
    table.insert(_activeplayers, player)
	
	if TheWorld.components.hayfever_tracker:CheckQueen() then
		_queenkilled = true
	end
		
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
	for i, v in ipairs(AllPlayers) do
            if TheWorld.state.isspring and TheWorld.state.remainingdaysinseason <= TUNING.SPRING_LENGTH - 1 and not v.components.hayfever.enabled and TheWorld.state.cycles > TUNING.DSTU.WEATHERHAZARD_START_DATE then
				v.components.hayfever:Enable()
			elseif not TheWorld.state.isspring then
				v.components.hayfever:Disable()
			end
    end
end

local function QueenFalse()
	_queenkilled = false
	OnSeasonTick()
	print(_queenkilled)
end

local function QueenTrue()
	_queenkilled = true
	
	for i, v in ipairs(AllPlayers) do
		if v.components.hayfever and v.components.hayfever.enabled then
			v.components.talker:Say(GetString(v, "ANNOUNCE_HAYFEVER_OFF"))   
		end
	end

	print(_queenkilled)
end

function self:CheckQueen()
	return _queenkilled
end

function self:OnSave()
    return
    {
        queenkilled = _queenkilled
    }
end

function self:OnLoad(data)
    if data.queenkilled ~= nil then
        _queenkilled = data.queenkilled
    end
end

for i, v in ipairs(AllPlayers) do
    table.insert(_activeplayers, v)
end

self.inst:ListenForEvent("ms_playerjoined", OnPlayerJoined, TheWorld)
self.inst:ListenForEvent("ms_playerleft", OnPlayerLeft, TheWorld)

self.inst:ListenForEvent("seasontick", OnSeasonTick, TheWorld)
self.inst:ListenForEvent("beequeenkilled", QueenTrue, TheWorld)
self.inst:ListenForEvent("beequeenrespawned", QueenFalse, TheWorld)

end)