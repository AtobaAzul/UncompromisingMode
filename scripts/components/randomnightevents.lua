--------------------------------------------------------------------------
--[[ Dependencies ]]
--------------------------------------------------------------------------
local easing = require("easing")

--------------------------------------------------------------------------
--[[ RandomNightEvents class definition ]]
--------------------------------------------------------------------------
return Class(function(self, inst)
assert(TheWorld.ismastersim, "RandomNightEvents should not exist on client")

self.inst = inst
local _targetplayer = nil
local _activeplayers = {}
local STRUCTURE_DIST = 20

local function TryRandomNightEvent()      --Canis said 20% chance each night to have a RNE, could possibly include a scaling effect later
	--if math.random >= 0.8 then		--enable after testing
	CheckPlayers()
	print("trying RNE")
	--end								--enable after testing
end

local function IsEligible(player)
	local area = player.components.areaaware
	return TheWorld.Map:IsVisualGroundAtPoint(player.Transform:GetWorldPosition())
			and area:GetCurrentArea() ~= nil 
			--and not area:CurrentlyInTag("nohasslers")
end

local function CheckPlayers()
    _targetplayer = nil
    if #_activeplayers == 0 then
        return
    end

	local playerlist = {}
	for _, v in ipairs(_activeplayers) do
		if IsEligible(v) then
			table.insert(playerlist, v)
		end
	end
	shuffleArray(playerlist)
	if #playerlist == 0 then
		return
	end
	local numStructures = 0
		for i, v in ipairs(playerlist) do  --try a base RNE
		local x,y,z = v.Transform:GetWorldPosition()
		local ents = TheSim:FindEntities(x,y,z, STRUCTURE_DIST, {"structure"})
		numStructures = #ents
			if numStructures >= 4 then
			DoBaseRNE(v)
			print("found base")
			return
			end
		end
		for i, v in ipairs(playerlist) do --noone was home, so we'll do RNEs at every player instead
		DoWildRNE(v)
		print("no find base")
		end
end

local function DoBaseRNE(player)
	if player.components.health ~= nil
		player.components.health:DoDelta(-10)	--Test Effects to see if base detecting is working
	end
end
local function DoWildRNE(player)
	if player.components.sanity ~= nil
		player.components.sanity:DoDelta(-10)   --Test Effects to see if base detecting is working
	end
end





--Keep these incase we need them later (probably)
local function OnPlayerJoined(src,player)
    for i, v in ipairs(_activeplayers) do
        if v == player then
            return
        end
    end
    table.insert(_activeplayers, player)

    --TryStartAttacks()
end

local function OnPlayerLeft(src,player)
    for i, v in ipairs(_activeplayers) do
        if v == player then
            table.remove(_activeplayers, i)
            --
			-- if this was the activetarget...cease the attack
			--if player == _targetplayer then
				--TargetLost()
			--end
            return
        end
    end
end
inst:ListenForEvent("ms_playerjoined", OnPlayerJoined)
inst:ListenForEvent("ms_playerleft", OnPlayerLeft)
self:WatchWorldState("isnight", TryRandomNightEvent) --RNE could happen any night
end)
