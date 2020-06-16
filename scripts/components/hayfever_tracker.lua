return Class(function(self, inst)

assert(TheWorld.ismastersim, "Hayfever_tracker should not exist on client")

self.inst = inst

--local _isspring = false
local _queenkilled = nil

local _targetplayer = nil
local _activeplayers = {}

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

local function AddQueenBeeKilledTag(src, data)
	TheWorld.net:AddTag("queenbeekilled")
	--[[
		for i, v in ipairs(AllPlayers) do
			v:AddTag("queenbeekilled")
			if v.components.hayfever and v.components.hayfever.enabled then
				v.components.talker:Say(GetString(v, "ANNOUNCE_HAYFEVER_OFF"))   
			end
		end
		--]]
end

		
local function OnSeasonTick(src, data)
    --_isspring = data.season == SEASONS.SPRING
	for i, v in ipairs(AllPlayers) do
            if TheWorld.state.isspring and TheWorld.state.remainingdaysinseason <= TUNING.SPRING_LENGTH - 1 and not v.components.hayfever.enabled and TheWorld.state.cycles > TUNING.DSTU.WEATHERHAZARD_START_DATE and not TheWorld.net:HasTag("queenbeekilled") and _queenkilled ~= true then
				v.components.hayfever:Enable()
			elseif _queenkilled == true or not TheWorld.state.isspring then
				v.components.hayfever:Disable()
				print("Queen Dead")
			end
    end
	print(_queenkilled)
	
end

local function QueenFalse()
	_queenkilled = false
	OnSeasonTick()
	print(_queenkilled)
end

local function QueenTrue()
	_queenkilled = true
	OnSeasonTick()
	print(_queenkilled)
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

--inst:ListenForEvent("addqueenbeekilledtag", AddQueenBeeKilledTag)
self.inst:ListenForEvent("seasontick", OnSeasonTick, TheWorld)
self.inst:ListenForEvent("beequeenkilled", QueenTrue, TheWorld)
self.inst:ListenForEvent("beequeenrespawned", QueenFalse, TheWorld)

end)