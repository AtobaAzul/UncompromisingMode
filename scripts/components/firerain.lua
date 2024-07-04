local easing = require("easing")

local RETRY_INTERVAL = TUNING.SEG_TIME / 3
local RETRY_PERIOD = TUNING.TOTAL_DAY_TIME / 2
local NUM_RETRIES = math.floor(RETRY_PERIOD / RETRY_INTERVAL + .5)

local SHOWER_LEVELS =
{
    --level: 1
    {
        duration =
        {
            base = TUNING.METEOR_SHOWER_LVL1_DURATION_BASE,
            min_variance = TUNING.METEOR_SHOWER_LVL1_DURATIONVAR_MIN,
            max_variance = TUNING.METEOR_SHOWER_LVL1_DURATIONVAR_MAX,
        },
        rate =
        {
            base = 0,
            min_variance = TUNING.METEOR_SHOWER_LVL1_METEORSPERSEC_MIN,
            max_variance = TUNING.METEOR_SHOWER_LVL1_METEORSPERSEC_MAX,
        },
        max_medium =
        {
            base = 0,
            min_variance = TUNING.METEOR_SHOWER_LVL1_MEDMETEORS_MIN,
            max_variance = TUNING.METEOR_SHOWER_LVL1_MEDMETEORS_MAX,
        },
        max_large =
        {
            base = 0,
            min_variance = TUNING.METEOR_SHOWER_LVL1_LRGMETEORS_MIN,
            max_variance = TUNING.METEOR_SHOWER_LVL1_LRGMETEORS_MAX,
        },
        cooldown =
        {
            base = TUNING.METEOR_SHOWER_LVL1_BASETIME,
            min_variance = 0,
            max_variance = TUNING.METEOR_SHOWER_LVL1_VARTIME,
        },
    },

    --level: 2
    {
        duration =
        {
            base = TUNING.METEOR_SHOWER_LVL2_DURATION_BASE,
            min_variance = TUNING.METEOR_SHOWER_LVL2_DURATIONVAR_MIN,
            max_variance = TUNING.METEOR_SHOWER_LVL2_DURATIONVAR_MAX,
        },
        rate =
        {
            base = 0,
            min_variance = TUNING.METEOR_SHOWER_LVL2_METEORSPERSEC_MIN,
            max_variance = TUNING.METEOR_SHOWER_LVL2_METEORSPERSEC_MAX,
        },
        max_medium =
        {
            base = 0,
            min_variance = TUNING.METEOR_SHOWER_LVL2_MEDMETEORS_MIN,
            max_variance = TUNING.METEOR_SHOWER_LVL2_MEDMETEORS_MAX,
        },
        max_large =
        {
            base = 0,
            min_variance = TUNING.METEOR_SHOWER_LVL2_LRGMETEORS_MIN,
            max_variance = TUNING.METEOR_SHOWER_LVL2_LRGMETEORS_MAX,
        },
        cooldown =
        {
            base = TUNING.METEOR_SHOWER_LVL2_BASETIME,
            min_variance = 0,
            max_variance = TUNING.METEOR_SHOWER_LVL2_VARTIME,
        },
    },

    --level: 3
    {
        duration =
        {
            base = TUNING.METEOR_SHOWER_LVL3_DURATION_BASE,
            min_variance = TUNING.METEOR_SHOWER_LVL3_DURATIONVAR_MIN,
            max_variance = TUNING.METEOR_SHOWER_LVL3_DURATIONVAR_MAX,
        },
        rate =
        {
            base = 0,
            min_variance = TUNING.METEOR_SHOWER_LVL3_METEORSPERSEC_MIN,
            max_variance = TUNING.METEOR_SHOWER_LVL3_METEORSPERSEC_MAX,
        },
        max_medium =
        {
            base = 0,
            min_variance = TUNING.METEOR_SHOWER_LVL3_MEDMETEORS_MIN,
            max_variance = TUNING.METEOR_SHOWER_LVL3_MEDMETEORS_MAX,
        },
        max_large =
        {
            base = 0,
            min_variance = TUNING.METEOR_SHOWER_LVL3_LRGMETEORS_MIN,
            max_variance = TUNING.METEOR_SHOWER_LVL3_LRGMETEORS_MAX,
        },
        cooldown =
        {
            base = TUNING.METEOR_SHOWER_LVL3_BASETIME,
            min_variance = 0,
            max_variance = TUNING.METEOR_SHOWER_LVL3_VARTIME,
        },
    },
}

local function RandomizeInteger(params)
    return params.base + math.random(params.min_variance, params.max_variance)
end

local function RandomizeFloat(params)
    return params.base + params.min_variance + math.random() * (params.max_variance - params.min_variance)
end

local function RandomizeLevel()
    return math.random(#SHOWER_LEVELS)
end

local FireRain = Class(function(self, inst)
    self.inst = inst

    self.dt = nil
    self.spawn_mod = nil
    self.medium_remaining = nil
    self.large_remaining = nil
    self.retries_remaining = nil

    self.task = nil
    self.tasktotime = nil

    self.level = RandomizeLevel()
    self:StartCooldown()
end)

function FireRain:IsShowering()
    return self.dt ~= nil
end

function FireRain:IsCoolingDown()
    return self.task ~= nil and self.dt == nil
end

function FireRain:SpawnMeteor(mod)
    --Randomize spawn point
    local x, y, z = self.inst.Transform:GetWorldPosition()
    local theta = math.random() * 2 * PI
    -- Do some easing fanciness to make it less clustered around the spawner prefab
    local radius = easing.outSine(math.random(), math.random() * 7, TUNING.METEOR_SHOWER_SPAWN_RADIUS * 0.5, 1)

    local map = TheWorld.Map
    local fan_offset = FindValidPositionByFan(theta, radius, 30,
        function(offset)
            return not map:IsPassableAtPoint(x + offset.x, y + offset.y, z + offset.z)
        end)

    local function IsValidSinkholePosition(offset2)
        local x1, z1 = x + offset2.x, z + offset2.z
        for dx = -1, 1 do
            for dz = -1, 1 do
                if not TheWorld.Map:IsPassableAtPoint(x1 + dx * TUNING.ANTLION_SINKHOLE.RADIUS, 0, z1 + dz * TUNING.ANTLION_SINKHOLE.RADIUS) then
                    return true
                end
            end
        end
        return false
    end

    local offset2 = Vector3(0, 0, 0)
    offset2 =
        IsValidSinkholePosition(offset2) and offset2 or
        FindValidPositionByFan(math.random() * 2 * PI, TUNING.ANTLION_SINKHOLE.RADIUS * 1.8 + math.random(), 9, IsValidSinkholePosition) or
        FindValidPositionByFan(math.random() * 2 * PI, TUNING.ANTLION_SINKHOLE.RADIUS * 2.9 + math.random(), 17, IsValidSinkholePosition) or
        FindValidPositionByFan(math.random() * 2 * PI, TUNING.ANTLION_SINKHOLE.RADIUS * 3.9 + math.random(), 17, IsValidSinkholePosition) or
        nil

    if fan_offset ~= nil and offset2 ~= nil then
        local xrandom = x + math.random(-5, 5)
        local zrandom = z + math.random(-5, 5)

        local met = SpawnPrefab("antlion_sinkhole_boat")

        if math.random() >= 0.33 then
            met.Transform:SetPosition(xrandom, y, zrandom)
        end

        if mod == nil then
            mod = 1
        end

        --Randomize size, but only spawn small meteors on the periphery
        local peripheral = radius > TUNING.METEOR_SHOWER_SPAWN_RADIUS - TUNING.METEOR_SHOWER_CLEANUP_BUFFER
        local rand = not peripheral and math.random() or 1
        local cost = math.floor(1 / mod + .5)

        return met
    end
    --[[
	local x = GetRandomWithVariance(spawnpt.x, TUNING.ANTLION_SINKHOLE.RADIUS)
    local z = GetRandomWithVariance(spawnpt.z, TUNING.ANTLION_SINKHOLE.RADIUS)

    local function IsValidSinkholePosition(offset)
        local x1, z1 = x + offset.x, z + offset.z
        if #TheSim:FindEntities(x1, 0, z1, TUNING.ANTLION_SINKHOLE.RADIUS * 1.9, { "antlion_sinkhole_blocker" }) > 0 then
            return false
        end
        for dx = -1, 1 do
            for dz = -1, 1 do
                if not TheWorld.Map:IsPassableAtPoint(x1 + dx * TUNING.ANTLION_SINKHOLE.RADIUS, 0, z1 + dz * TUNING.ANTLION_SINKHOLE.RADIUS) then
                    return false
                end
            end
        end
        return true
    end

    local offset = Vector3(0, 0, 0)
    offset =
        IsValidSinkholePosition(offset) and offset or
        FindValidPositionByFan(math.random() * 2 * PI, TUNING.ANTLION_SINKHOLE.RADIUS * 1.8 + math.random(), 9, IsValidSinkholePosition) or
        FindValidPositionByFan(math.random() * 2 * PI, TUNING.ANTLION_SINKHOLE.RADIUS * 2.9 + math.random(), 17, IsValidSinkholePosition) or
        FindValidPositionByFan(math.random() * 2 * PI, TUNING.ANTLION_SINKHOLE.RADIUS * 3.9 + math.random(), 17, IsValidSinkholePosition) or
        nil

    if offset ~= nil then
        local sinkhole = SpawnPrefab("antlion_sinkhole")
        sinkhole.Transform:SetPosition(x + offset.x, 0, z + offset.z)
        sinkhole:PushEvent("startcollapse")
    end
	
	return sinkhole--]]
end

local function OnUpdate(inst, self)
    if inst:IsNearPlayer(TUNING.METEOR_SHOWER_SPAWN_RADIUS + 30) then
        self.spawn_mod = nil
        self:SpawnMeteor()
    else
        self.spawn_mod = (self.spawn_mod or 1) - TUNING.METEOR_SHOWER_OFFSCREEN_MOD
        if self.spawn_mod <= 0 then
            self.spawn_mod = self.spawn_mod + 1
            self:SpawnMeteor(TUNING.METEOR_SHOWER_OFFSCREEN_MOD)
        end
    end

    if GetTime() >= self.tasktotime then
        self:StartCooldown()
    end
end

function FireRain:StartShower(level)
    self:StopShower()

    self.level = level or RandomizeLevel()

    local level_params = SHOWER_LEVELS[self.level]
    local duration = RandomizeFloat(level_params.duration)
    local rate = RandomizeInteger(level_params.rate)

    if duration > 0 and rate > 0 then
        self.dt = 1 / rate
        self.medium_remaining = RandomizeInteger(level_params.max_medium)
        self.large_remaining = RandomizeInteger(level_params.max_large)

        self.task = self.inst:DoPeriodicTask(self.dt, OnUpdate, nil, self)
        self.tasktotime = GetTime() + duration
    end
end

function FireRain:StopShower()
    if self.task ~= nil then
        self.task:Cancel()
        self.task = nil
    end
    self.tasktotime = nil
    self.dt = nil
    self.spawn_mod = nil
    self.medium_remaining = nil
    self.large_remaining = nil
    self.retries_remaining = nil
end

--[[
local function OnCooldown(inst, self)
    if inst:IsNearPlayer(TUNING.METEOR_SHOWER_SPAWN_RADIUS + 60) then
        self:StartShower()
    elseif self.retries_remaining > 0 then
        -- delay the start just in case a player walks by, so they can witness it
        self.retries_remaining = self.retries_remaining - 1
        self.tasktotime = GetTime() + RETRY_INTERVAL
    else
        -- just do it anyways.
        self:StartShower()
    end
end
--]]
function FireRain:StartCooldown()
    self:StopShower()

    local level_params = SHOWER_LEVELS[self.level]
    local cooldown = RandomizeFloat(level_params.cooldown)

    if cooldown > 0 then
        self.retries_remaining = NUM_RETRIES
        --self.task = self.inst:DoPeriodicTask(RETRY_INTERVAL, OnCooldown, cooldown, self)
        self.tasktotime = GetTime() + cooldown
    end
end

function FireRain:OnSave()
    return
    {
        level = self.level,
        remainingtime = self.tasktotime ~= nil and self.tasktotime - GetTime() or nil,
        interval = self.dt,
        mediumleft = self.medium_remaining,
        largeleft = self.large_remaining,
        retriesleft = self.retries_remaining,
    }
end

function FireRain:OnLoad(data)
    if data ~= nil and data.level ~= nil then
        self:StopShower()
        self.level = math.clamp(data.level, 1, #SHOWER_LEVELS)
        if data.remainingtime ~= nil then
            local remaining_time = math.max(0, data.remainingtime)
            if data.interval ~= nil then
                self.dt = math.max(0, data.interval)
                self.medium_remaining = math.max(0, data.medium_remaining or 0)
                self.large_remaining = math.max(0, data.large_remaining or 0)
                self.task = self.inst:DoPeriodicTask(self.dt, OnUpdate, nil, self)
            else
                self.retries_remaining = math.max(0, data.retriesleft or NUM_RETRIES)
                --self.task = self.inst:DoPeriodicTask(RETRY_INTERVAL, OnCooldown, remaining_time, self)
            end
            self.tasktotime = GetTime() + remaining_time
        end
    end
end

function FireRain:GetDebugString()
    return string.format("Level %d ", self.level)
        .. ((self:IsShowering() and string.format("SHOWERING: %2.2f, interval: %2.2f (mod: %s), stock: (%d large, %d medium, unlimited small)", self.tasktotime - GetTime(), self.dt, self.spawn_mod ~= nil and string.format("%1.1f", TUNING.METEOR_SHOWER_OFFSCREEN_MOD) or "---", self.large_remaining, self.medium_remaining)) or
            (self:IsCoolingDown() and string.format("COOLDOWN: %2.2f, retry: %d/%d", self.tasktotime - GetTime(), NUM_RETRIES - self.retries_remaining, NUM_RETRIES)) or
            "STOPPED")
end

FireRain.OnRemoveFromEntity = FireRain.StopShower

return FireRain
