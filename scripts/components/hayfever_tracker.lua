return Class(function(self, inst)

assert(TheWorld.ismastersim, "Hayfever_tracker should not exist on client")

self.inst = inst

local _isspring = false

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
	TheWorld:AddTag("queenbeekilled")
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
    _isspring = data.season == SEASONS.SPRING
	for i, v in ipairs(AllPlayers) do
            if TheWorld.state.isspring and not v.components.hayfever.enabled and TheWorld.state.cycles > TUNING.DSTU.WEATHERHAZARD_START_DATE then
				v.components.hayfever:Enable()
				elseif not TheWorld.state.isspring then
					v.components.hayfever:Disable()
					--TheWorld:RemoveTag("queenbeekilled")
			end
    end
	
end


for i, v in ipairs(AllPlayers) do
    table.insert(_activeplayers, v)
end

self.inst:ListenForEvent("ms_playerjoined", OnPlayerJoined, TheWorld)
self.inst:ListenForEvent("ms_playerleft", OnPlayerLeft, TheWorld)

--inst:ListenForEvent("addqueenbeekilledtag", AddQueenBeeKilledTag)
inst:ListenForEvent("seasontick", OnSeasonTick)

end)