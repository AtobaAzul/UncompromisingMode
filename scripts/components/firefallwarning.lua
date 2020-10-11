--------------------------------------------------------------------------
--[[ Dependencies ]]
--------------------------------------------------------------------------
local easing = require("easing")

--STRINGS.CHARACTERS.GENERIC.ANNOUNCE_FIREFALL = {"More?!?", "It's heating up!", "Is that... sulfur?!",}
--------------------------------------------------------------------------
--[[ BaseHassler class definition ]]
--------------------------------------------------------------------------
return Class(function(self, inst)

assert(TheWorld.ismastersim, "Firefallwarning should not exist on client")

--------------------------------------------------------------------------
--[[ Public Member Variables ]]
--------------------------------------------------------------------------

self.inst = inst

--------------------------------------------------------------------------
--[[ Private Member Variables ]]
--------------------------------------------------------------------------
local _targetplayer = nil
local _activeplayers = {}

------------------------------------------------------------------------------------------------

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

local function DoTargetWarning(_activeplayers, player)
	for i, v in ipairs(AllPlayers) do
            v.components.talker:Say(GetString(v, "ANNOUNCE_FIREFALL"))
			SpawnPrefab("antlionwarning").Transform:SetPosition(v.Transform:GetWorldPosition())
			if v.sg:HasStateTag("sleeping") and v.components.sleepingbaguser ~= nil then
				v.components.sleepingbaguser:DoWakeUp()
			end
    end
end

local function DoTargetFireFall(_activeplayers, player)
	for i, v in ipairs(AllPlayers) do
			v.components.firerain:StartShower(1)
			SpawnPrefab("antlionwarning").Transform:SetPosition(v.Transform:GetWorldPosition())
			if v.sg:HasStateTag("sleeping") and v.components.sleepingbaguser ~= nil then
				v.components.sleepingbaguser:DoWakeUp()
			end
    end
end

------------------------------------------------------------------------------------------------

for i, v in ipairs(AllPlayers) do
    table.insert(_activeplayers, v)
end

self.inst:ListenForEvent("ms_playerjoined", OnPlayerJoined, TheWorld)
self.inst:ListenForEvent("ms_playerleft", OnPlayerLeft, TheWorld)
--self.inst:ListenForEvent("seasontick", OnSeasonTick, TheWorld)
--self.inst:ListenForEvent("firefall", DoTargetWarning)
--self.inst:ListenForEvent("firefallstart", DoTargetFireFall)

self.inst:ListenForEvent("firefall", DoTargetWarning)
self.inst:ListenForEvent("firefallstart", DoTargetFireFall)

end)
