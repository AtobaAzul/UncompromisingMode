local SnowStormWatcher = Class(function(self, inst)
        self.inst = inst

        self.snowstormspeedmult = .75
        self.delay = nil
        self.task = nil
        self.storming = false
        --inst:ListenForEvent("weathertick", function(src, data) self:ToggleSnowstorms() end, TheWorld)
        --inst:ListenForEvent("forcestopsnowstorm", function(src, data) self:ToggleSnowstorms() end, TheWorld)
        self.inst:ListenForEvent("seasontick", function(src, data)
            self:ToggleSnowstorms()
        end, TheWorld)
        self.inst:StartUpdatingComponent(self)
    end,
    nil,
    {
        --snowstormlevel = onsnowstormlevel,
    })

local INVALID_TILES = table.invert(
    {
        GROUND.SCALE
    })

function SnowStormWatcher:ToggleSnowstorms(active, src, data)
    if TheWorld.state.iswinter then
        self.inst:StartUpdatingComponent(self)
    else
        self.inst:StopUpdatingComponent(self)
    end
end

function SnowStormWatcher:UpdateSnowstormLevel()
    self:UpdateSnowstormWalkSpeed()
    --end
end

function SnowStormWatcher:SnowstormLevel()
    return self.snowstormstart
end

function SnowStormWatcher:UpdateSnowstormWalkSpeed(src, data)
    local x, y, z = self.inst.Transform:GetWorldPosition()

    local ents = TheSim:FindEntities(x, y, z, 4, { "wall" })
    local suppressorNearby1 = (#ents > 2)

    local ents2 = TheSim:FindEntities(x, y, z, 6, { "fire" })
    local suppressorNearby2 = (#ents2 > 0)

    local ents3 = TheSim:FindEntities(x, y, z, 5.5, { "shelter" })
    local suppressorNearby3 = (#ents3 > 2)

    local ents4 = TheSim:FindEntities(x, y, z, 6, { "snowstorm_protection_high" })
    local suppressorNearby4 = (#ents4 > 0)


    if TheWorld.state.iswinter and ((TheWorld.net ~= nil and TheWorld.net:HasTag("snowstormstartnet")) or TheWorld:HasTag("snowstormstart")) then
        if self.inst.components.playervision:HasGoggleVision() or
            self.inst.components.playervision:HasGhostVision() or
            self.inst.components.rider:IsRiding() or
            suppressorNearby1 or suppressorNearby2 or suppressorNearby3 or suppressorNearby4 or
            (
                self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY) ~= nil and
                self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY).prefab == "beargervest") or IsUnderRainDomeAtXZ(x, z) or self.inst:HasTag("weerclops")
        then
            self.inst.components.locomotor:RemoveExternalSpeedMultiplier(self.inst, "snowstorm")
            self.inst:PushEvent("checksnowvision")
        else
            self.inst.components.locomotor:SetExternalSpeedMultiplier(self.inst, "snowstorm", self.snowstormspeedmult)
            self.inst:PushEvent("checksnowvision")
        end
    else
        self.inst.components.locomotor:RemoveExternalSpeedMultiplier(self.inst, "snowstorm")
        self.inst:PushEvent("checksnowvision")
    end
end

function TrySpawning(v)
    local x1, y1, z1 = v.Transform:GetWorldPosition()
    local nearbyplayers2 = TheSim:FindEntities(x1, y1, z1, 50, nil, nil, { "player" })

    local playervalue2 = #nearbyplayers2 * 0.1

    if TheWorld.state.iswinter and
        ((TheWorld.net ~= nil and TheWorld.net:HasTag("snowstormstartnet")) or TheWorld:HasTag("snowstormstart")) and
        TheWorld.Map:IsPassableAtPoint(x1, y1, z1, false, true) then --and self.snowstormstart then
        if math.random() <= 0.25 - playervalue2 then
            --local spawn_pt = GetSpawnPoint(origin_pt, PLAYER_CHECK_DISTANCE + 5)

            local ents5 = TheSim:FindEntities(x1, y1, z1, 3, nil, nil, { "snowpileradius" })
            local ents6 = TheSim:FindEntities(x1, y1, z1, 8, nil, nil, { "fire" })
            local ents7 = TheSim:FindEntities(x1, y1, z1, 2, nil, nil, { "snowpiledin" })
            --local ents = TheSim:FindEntities(x, y, z, 40, {"wall" "player" "campfire"})
            if #ents5 < 1 and #ents6 < 1 and #ents7 < 1 and not INVALID_TILES[TheWorld.Map:GetTileAtPoint(x1, 0, z1)] then
                if #TheSim:FindEntities(x1, y1, z1, 5, { "snowpileblocker" }) == 0 then --Using this specifically for salt here, we can combine it with others if wanted
                    local snowpilespawn = SpawnPrefab("snowpile")
                    snowpilespawn.Transform:SetPosition(x1, 0.05, z1)
                end
            end
        end
    end
end

local NOTAGS = { "playerghost", "HASHEATER" }

local function SnowpileChance(inst, self)
    local x, y, z = self.inst.Transform:GetWorldPosition()
    local nearbyplayers1 = TheSim:FindEntities(x, y, z, 50, nil, nil, { "player" })
    local ents4 = TheSim:FindEntities(x, y, z, 50, nil, { "snowpiledin", "hive", "snowpileblocker" }, { "structure" })
    local chancer = math.random()

    local playervalue1 = #nearbyplayers1 * 0.025

    if TheWorld.state.iswinter and
        ((TheWorld.net ~= nil and TheWorld.net:HasTag("snowstormstartnet")) or TheWorld:HasTag("snowstormstart")) and not IsUnderRainDomeAtXZ(x, z) then --and self.snowstormstart then
        if chancer < 0.40 - playervalue1 then
            local xrandom = math.random(-20, 20)
            local zrandom = math.random(-20, 20)
            local ents7 = TheSim:FindEntities(x + xrandom, y, z + zrandom, 6, nil, nil, { "snowpileradius" })
            local ents8 = TheSim:FindEntities(x + xrandom, y, z + zrandom, 8, nil, nil, { "fire" })

            if TheWorld.Map:IsPassableAtPoint(x + xrandom, 0, z + zrandom, false, true) and #ents7 < 1 and #ents8 < 1 and
                not INVALID_TILES[TheWorld.Map:GetTileAtPoint(x + xrandom, 0, z + zrandom)] then
                if #TheSim:FindEntities(x + xrandom, 0, z + zrandom, 5, { "snowpileblocker" }) == 0 then
                    local snowpilespawn = SpawnPrefab("snowpile")
                    snowpilespawn.Transform:SetPosition(x + xrandom, 0.05, z + zrandom)
                end
            end
        else
            for i, v in ipairs(ents4) do
                TrySpawning(v)
            end
        end
    end

    if self.task ~= nil then
        self.task:Cancel()
        self.task = nil
    end
end

TUNING.SNOW_CHANCE_TIME = 15
TUNING.SNOW_CHANCE_VARIANCE = 15


function SnowStormWatcher:StartSnowPileTask()
    if self.task == nil then
        self.task = self.inst:DoTaskInTime(TUNING.SNOW_CHANCE_TIME + math.random() * TUNING.SNOW_CHANCE_VARIANCE,
            SnowpileChance, self) --, self)
    end
end

function SnowStormWatcher:OnUpdate(dt)
    self:UpdateSnowstormLevel()

    self:UpdateSnowstormWalkSpeed()

    self:StartSnowPileTask()
end

return SnowStormWatcher
