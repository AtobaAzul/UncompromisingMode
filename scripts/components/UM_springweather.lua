return Class(function(self, inst)

assert(TheWorld.ismastersim, "UM_springweather should not exist on client")

self.inst = inst

self.threat = "lush"   

local _targetplayer = nil
local _activeplayers = {}

function self:PickThreat(inst)
	if math.random() > 0 then -- Monsoons are nonfunctional as of now... changing this value allows testing either threat... add config to limit threats later
		return "lush"
	else
		return "monsoon" --Consider a name change? hmm
	end
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
	for i, v in ipairs(AllPlayers) do
            if TheWorld.state.isspring and TheWorld.state.remainingdaysinseason <= TUNING.SPRING_LENGTH - 1 and not v.components.UM_hayfever.enabled and TheWorld.state.cycles >= TUNING.DSTU.WEATHERHAZARD_START_DATE then
				v.components.UM_hayfever:Enable()
			elseif not TheWorld.state.isspring then
				v.components.UM_hayfever:Disable()
			end
    end
end

for i, v in ipairs(AllPlayers) do
    table.insert(_activeplayers, v)
end

self.inst:ListenForEvent("ms_playerjoined", OnPlayerJoined, TheWorld)
self.inst:ListenForEvent("ms_playerleft", OnPlayerLeft, TheWorld)

self.inst:ListenForEvent("seasontick", OnSeasonTick, TheWorld)

end)