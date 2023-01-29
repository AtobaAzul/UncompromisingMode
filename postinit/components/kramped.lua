local env = env
GLOBAL.setfenv(1, GLOBAL)
------------------------Used for Krampus RNE-----------------------------------------
local function NoHoles(pt)
    return not TheWorld.Map:IsPointNearHole(pt)
end

local function GetSpawnPoint(pt)
    if not TheWorld.Map:IsAboveGroundAtPoint(pt:Get()) then
        pt = FindNearbyLand(pt, 1) or pt
    end
	local SPAWN_DIST = 30
    local offset = FindWalkableOffset(pt, math.random() * 2 * PI, SPAWN_DIST, 12, true, true, NoHoles)
    if offset ~= nil then
        offset.x = offset.x + pt.x
        offset.z = offset.z + pt.z
        return offset
    end
end

local function MakeAKrampusForPlayer(player)
    local pt = player:GetPosition()
    local spawn_pt = GetSpawnPoint(pt)
    if spawn_pt ~= nil then
        local kramp = SpawnPrefab("krampus")
        kramp.Physics:Teleport(spawn_pt:Get())
        kramp:FacePoint(pt)
        kramp.spawnedforplayer = player
        kramp:ListenForEvent("onremove", function() kramp.spawnedforplayer = nil end, player)
		kramp:RemoveComponent("sleeper")
        return kramp
    end
end

local function OnForceNaughtinessRne(src, data)
    if data.player ~= nil then
        --[[local playerdata = _activeplayers[data.player]
        if playerdata ~= nil then
            --Reset existing naughtiness
            playerdata.threshold = TUNING.KRAMPUS_THRESHOLD + math.random(TUNING.KRAMPUS_THRESHOLD_VARIANCE)
            playerdata.actions = 0
        end]]

        for i = 1, data.numspawns or 0 do
            local kramp = MakeAKrampusForPlayer(data.player)
        end
    end
end

env.AddComponentPostInit("kramped", function(self, inst)

inst:ListenForEvent("ms_forcenaughtinessrne", OnForceNaughtinessRne, TheWorld)

end)