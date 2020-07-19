--------------------------------------------------------------------------
--[[ Dependencies ]]
--------------------------------------------------------------------------
local easing = require("easing")

--------------------------------------------------------------------------
--[[ RandomNightEvents class definition ]]
--------------------------------------------------------------------------
return Class(function(self, inst)
assert(TheWorld.ismastersim, "Monsoons shouldn't exist on the client")

self.inst = inst
local _targetplayer = nil
local _activeplayers = {}
local springdaycounter = 0


local function ResetSpringDaycount()
springdaycounter = 0
	if TheWorld:HasTag("monsooning") then
		TheWorld:RemoveTag("monsooning")
		TheWorld.net:RemoveTag("monsooning")
	end
end

local function DoMonsoon()
--print("didmonsoon")
TheWorld:AddTag("monsooning")
TheWorld.net:AddTag("monsooning")
end
local function SpringDaycount()
springdaycounter = springdaycounter+1
--print(springdaycounter)
	if TheWorld.state.israining and springdaycounter > 2 and springdaycounter < 18 then
	DoMonsoon()
	end
end
local function NotMonsoon()
	if TheWorld:HasTag("monsooning") then
		TheWorld:RemoveTag("monsooning")
		TheWorld.net:RemoveTag("monsooning")
	end
end

local function TryMonsoon()
--print("triedmonsoon")
--print(springdaycounter)
if TheWorld:HasTag("monsoons") or TheWorld.net:HasTag("monsoons") then
	if springdaycounter > 2 and springdaycounter < 18 then
		DoMonsoon()
	elseif math.random() > 0.5 then
		DoMonsoon()
		else
		NotMonsoon()
	end
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
inst:WatchWorldState("israining", TryMonsoon) 
inst:WatchWorldState("isnight", SpringDaycount) 
inst:WatchWorldState("issummer", ResetSpringDaycount) 
end)