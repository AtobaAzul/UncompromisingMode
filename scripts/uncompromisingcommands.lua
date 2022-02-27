-- not local - debugkeys use it too
function ConsoleCommandPlayer()
    return (c_sel() ~= nil and c_sel():HasTag("player") and c_sel()) or ThePlayer or AllPlayers[1]
end

function ConsoleWorldPosition()
    return TheInput.overridepos or TheInput:GetWorldPosition()
end

function ConsoleWorldEntityUnderMouse()
    if TheInput.overridepos == nil then
        return TheInput:GetWorldEntityUnderMouse()
    else
        local x, y, z = TheInput.overridepos:Get()
        local ents = TheSim:FindEntities(x, y, z, 1)
        for i, v in ipairs(ents) do
            if v.entity:IsVisible() then
                return v
            end
        end
    end
end

local function ListingOrConsolePlayer(input)
    if type(input) == "string" or type(input) == "number" then
        return UserToPlayer(input)
    end
    return input or ConsoleCommandPlayer()
end

local function Spawn(prefab)
    --TheSim:LoadPrefabs({prefab})
    return SpawnPrefab(prefab)
end

--toggle snowstorm
function dstu_snowstorm()
    if TheWorld:HasTag("snowstormstart") == false and TheWorld.state.iswinter then
        TheWorld:AddTag("snowstormstart")
        if TheWorld.net ~= nil then
            TheWorld.net:AddTag("snowstormstartnet")
        end
        print("starting snowstorm...")
    elseif TheWorld:HasTag("snowstormstart") then
        TheWorld:RemoveTag("snowstormstart")
		if TheWorld.net ~= nil then
			TheWorld.net:RemoveTag("snowstormstartnet")
		end
        print("stopping snowstorm...")
    end
end

--toggles vetcurse
function dstu_vetcurse()
    local player = ConsoleCommandPlayer()
    if player ~= nil and player.components.health ~= nil and not player:HasTag("playerghost") then
        if player:HasTag("vetcurse") == false then
            player:AddTag("vetcurse")
            print("added vetcurse")
        elseif player:HasTag("vetcurse") then
            player:RemoveTag("vetcurse")
            print("removed vetcurse")
        end
    end
end

--gives all current vet curse items
function dstu_vetcurseitems()
    c_give("cursed_antler")
    c_give("beargerclaw")
    c_give("slobberlobber")
    c_give("feather_frock")
    c_give("gore_horn_hat")
    c_give("klaus_amulet")
    c_give("crabclaw")
end

--function dstu_rne(rnetype)
--    TheWorld:PushEvent(rnetype)
--end