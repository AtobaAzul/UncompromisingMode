--------------------------------------------------------------------------
--[[ Dependencies ]]
--------------------------------------------------------------------------
local easing = require("easing")

STRINGS.CHARACTERS.GENERIC.ANNOUNCE_FIREFALL = {"More?!", "It's heating up!", "Is that... sulfur?!",}
--------------------------------------------------------------------------
--[[ BaseHassler class definition ]]
--------------------------------------------------------------------------
return Class(function(self, inst)

assert(TheWorld.ismastersim, "FireFallspawner should not exist on client")

--------------------------------------------------------------------------
--[[ Private constants ]]
--------------------------------------------------------------------------

--------------------------------------------------------------------------
--[[ Public Member Variables ]]
--------------------------------------------------------------------------

self.inst = inst

--------------------------------------------------------------------------
--[[ Private Member Variables ]]
--------------------------------------------------------------------------

local _activeplayers = {}
local _targetplayer = {}

--------------------------------------------------------------------------
--[[ Private member functions ]]
--------------------------------------------------------------------------
--------------------------------------------------------------------------
--[[ Private event handlers ]]
--------------------------------------------------------------------------

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

--------------------------------------------------------------------------
--[[ Public member functions ]]
--------------------------------------------------------------------------
local function DoTargetWarning(_activeplayers)
			--ShakeAllCameras(CAMERASHAKE.FULL, .7 * 10, .02 * 10, .5 * 10, inst, 40 * 10)
    ThePlayer.components.talker:Say(GetString(ThePlayer, "ANNOUNCE_FIREFALL"))

    SpawnPrefab("antlionwarning").Transform:SetPosition(ThePlayer.Transform:GetWorldPosition())
end
--------------------------------------------------------------------------
--[[ Initialization ]]
--------------------------------------------------------------------------
for i, v in ipairs(AllPlayers) do
    table.insert(_activeplayers, v)
end

self.inst:ListenForEvent("ms_playerjoined", OnPlayerJoined, TheWorld)
self.inst:ListenForEvent("ms_playerleft", OnPlayerLeft, TheWorld)
self.inst:ListenForEvent("firefall", DoTargetWarning, TheWorld)

end)
