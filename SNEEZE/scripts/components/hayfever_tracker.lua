return Class(function(self, inst)

self.inst = inst

local _isspring = false

local function AddQueenBeeKilledTag(src, data)
		if ThePlayer ~= nil then
			ThePlayer:AddTag("queenbeekilled")
			if ThePlayer ~= nil and ThePlayer.components.hayfever and ThePlayer.components.hayfever.enabled then
				ThePlayer.components.talker:Say(GetString(ThePlayer, "ANNOUNCE_HAYFEVER_OFF"))   
			end
		end
end
		

local function OnSeasonTick(src, data)
    _isspring = data.season == SEASONS.SPRING
		if TheWorld.state.isspring and ThePlayer ~= nil and ThePlayer.components.hayfever and not ThePlayer.components.hayfever.enabled then
				ThePlayer.components.hayfever:Enable()
				elseif TheWorld.state.iswinter and ThePlayer ~= nil and ThePlayer.components.hayfever then
				ThePlayer.components.hayfever:Disable()
			elseif not TheWorld.state.isspring and not TheWorld.state.iswinter and ThePlayer ~= nil and ThePlayer.components.hayfever then -- and ThePlayer.components.hayfever.enabled 
				ThePlayer.components.hayfever:Disable()
				ThePlayer:RemoveTag("queenbeekilled")
		end
		
		if ThePlayer ~= nil and ThePlayer:HasTag("queenbeekilled") then
					ThePlayer:AddTag("queenbeekilled")
				end
end

inst:ListenForEvent("addqueenbeekilledtag", AddQueenBeeKilledTag)
inst:ListenForEvent("seasontick", OnSeasonTick)

end)