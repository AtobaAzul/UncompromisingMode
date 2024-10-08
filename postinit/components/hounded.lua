local UpvalueHacker = GLOBAL.require("tools/upvaluehacker")

--We can hack our way through the hounded component and create our own variables so we don't have to touch any of the private data --KoreanWaffles
AddComponentPostInit("hounded", function(self)
    if not self.inst:HasTag("forest") or (self.inst:HasTag("island") or self.inst:HasTag("volcano")) then return end

    --------------------------------------------------
    -- THE IMPORTANT STUFF --
    --------------------------------------------------
    self.spawn_boss = false
    self.boss_grace = 100               --TUNING.DSTU.VARGWAVES_BOSS_GRACE --grace period in days before boss hounds can spawn

    self.seasonal_chance = 0.33         --chance for seasonal hounds to spawn in their respective seasons
    self.spawnamount = 0
    self.seasonal_boss_chance = 0.5     --chance to spawn a seasonal boss hound instead of the default boss (defined on the line below)
    self.default_boss_prefab = "warg"
    self.varggraceperiod = 15           --TUNING.DSTU.VARGWAVES_BOSS_GRACE - TUNING.DSTU.VARGWAVES_DELAY_PERIOD

    --framework for future spawn additions
    --seasonal boss hounds will be chosen randomly from their respective season tables
    self.seasonal_boss_prefabs = {
        ["autumn"] = {},
        ["winter"] = {},
        ["spring"] = {},
        ["summer"] = {},
    }
    --seasonal hound variants will be chosen randomly from their respective season tables
    --seasonal hound variants will be chosen randomly from their respective season tables
    self.seasonal_prefabs = {
        ["autumn"] = { "" },
        ["winter"] = { "" },
        ["spring"] = { "" },
        ["summer"] = { "" },
    }
    if TUNING.DSTU.SPOREHOUNDS and not (self.inst:HasTag("island") or self.inst:HasTag("volcano")) then
        self.seasonal_prefabs["autumn"] = { "sporehound" }
    end

    if TUNING.DSTU.GLACIALHOUNDS and not (self.inst:HasTag("island") or self.inst:HasTag("volcano")) then
        self.seasonal_prefabs["winter"] = { "glacialhound" }
    end

    if TUNING.DSTU.LIGHTNINGHOUNDS and not (self.inst:HasTag("island") or self.inst:HasTag("volcano")) then
        self.seasonal_prefabs["spring"] = { "lightninghound" }
    end

    if TUNING.DSTU.MAGMAHOUNDS and not (self.inst:HasTag("island") or self.inst:HasTag("volcano")) then
        self.seasonal_prefabs["summer"] = { "magmahound" }
    end

    self.spawnlimit = 0

    --------------------------------------------------
    -- THE ALSO IMPORTANT STUFF --
    --------------------------------------------------

    local function CalcSpawnLimit(value)
        if GLOBAL.TheWorld.state.cycles < 10 then
            return 0
        elseif GLOBAL.TheWorld.state.cycles < 30 then
            return 1
        elseif GLOBAL.TheWorld.state.cycles < 70 then
            return 2
        elseif GLOBAL.TheWorld.state.cycles < 100 then
            return 3
        else
            return 4
        end
    end

    local _OnUpdate = self.OnUpdate
    self.OnUpdate = function(self, dt)
        if self.GetTimeToAttack(self) > 0 and self.spawnamount > 0 then
            self.spawnamount = 0
        end

        --[[if self.GetTimeToAttack(self) > 0 and GLOBAL.TheWorld.state.cycles >= self.boss_grace then
                self.spawn_boss = true
            end]]
        _OnUpdate(self, dt)
    end

    local _SummonSpawn = UpvalueHacker.GetUpvalue(self.SummonSpawn, "SummonSpawn")
    local _GetSpawnPoint = UpvalueHacker.GetUpvalue(self.SummonSpawn, "SummonSpawn", "GetSpawnPoint")

    --fallback in case _GetSpawnPoint is nil (or not a function)
    local function NoHoles(pt)
        return not GLOBAL.TheWorld.Map:IsPointNearHole(pt)
    end
    local SPAWN_DIST = 30

    local function GetSpawnPointUM(pt)
        if GLOBAL.TheWorld.has_ocean then
            local function OceanSpawnPoint(offset)
                local x = pt.x + offset.x
                local y = pt.y + offset.y
                local z = pt.z + offset.z
                return GLOBAL.TheWorld.Map:IsAboveGroundAtPoint(x, y, z, true) and NoHoles(pt)
            end

            local offset = GLOBAL.FindValidPositionByFan(math.random() * 2 * GLOBAL.PI, SPAWN_DIST, 12, OceanSpawnPoint)
            if offset ~= nil then
                offset.x = offset.x + pt.x
                offset.z = offset.z + pt.z
                return offset
            end
        else
            if not GLOBAL.TheWorld.Map:IsAboveGroundAtPoint(pt:Get()) then
                pt = GLOBAL.FindNearbyLand(pt, 1) or pt
            end
            local offset = GLOBAL.FindWalkableOffset(pt, math.random() * 2 * GLOBAL.PI, SPAWN_DIST, 12, true, true, NoHoles)
            if offset ~= nil then
                offset.x = offset.x + pt.x
                offset.z = offset.z + pt.z
                return offset
            end
        end
    end

    local function SpawnHounded(prefab, pt, spawn_pt)
        if not prefab then
            return _SummonSpawn(pt)
        else
            local spawn = GLOBAL.SpawnPrefab(prefab)
            if spawn and spawn_pt ~= nil then
                spawn.Physics:Teleport(spawn_pt:Get())
                spawn:FacePoint(pt)
                if spawn.components.spawnfader then
                    spawn.components.spawnfader:FadeIn()
                end
                return spawn
            else
                return _SummonSpawn(pt)
            end
        end
    end


    local SPAWN_DIST = 30

    local function GetMagmaSpawnPoint(pt)
        if not GLOBAL.TheWorld.Map:IsAboveGroundAtPoint(pt:Get()) then
            pt = GLOBAL.FindNearbyLand(pt, 1) or pt
        end
        local offset = GLOBAL.FindWalkableOffset(pt, math.random() * 2 * GLOBAL.PI, SPAWN_DIST, 12, true, true,
            NoHoles)
        if offset ~= nil then
            offset.x = offset.x + pt.x
            offset.z = offset.z + pt.z
            return offset
        end
    end

    local function SummonSpawn(pt, upgrade)
        local spawn_pt = _GetSpawnPoint ~= nil and _GetSpawnPoint(pt) or GetSpawnPointUM(pt)
        local magmaspawn_pt = GetMagmaSpawnPoint(pt)
        local season = GLOBAL.TheWorld.state.season
        local chance = math.random()
        local prefab_list = {}
        local prefab = nil
        local SpawnLimit = CalcSpawnLimit()

        if self.varggraceperiod ~= nil and
            GLOBAL.TheWorld.state.cycles > (self.varggraceperiod + TUNING.DSTU.VARGWAVES_DELAY_PERIOD) then
            self.spawn_boss = true
        end

        --replaces the first hound in a wave with a random boss hound
        if pt and self.spawn_boss and magmaspawn_pt ~= nil and TUNING.DSTU.VARGWAVES then
            self.varggraceperiod = GLOBAL.TheWorld.state.cycles

            self.spawn_boss = false
            prefab_list = self.seasonal_boss_prefabs[season]
            prefab = --[[math.random() < self.seasonal_boss_chance and #prefab_list > 0 and prefab_list[math.random(#prefab_list)] or]] self
                .default_boss_prefab

            return SpawnHounded(prefab, pt, magmaspawn_pt)
        end
        --spawn a random seasonal hound
        if pt and chance < self.seasonal_chance and self.spawnamount <= SpawnLimit and
            GLOBAL.TheWorld.state.cycles >= 22 then
            self.spawnamount = self.spawnamount + 1

            prefab_list = self.seasonal_prefabs[season]
            prefab = #prefab_list > 0 and prefab_list[math.random(#prefab_list)] or nil
            if prefab == "magmahound" then
                if magmaspawn_pt ~= nil then
                    return SpawnHounded(prefab, pt, magmaspawn_pt)
                else
                    prefab = "hound"
                    return SpawnHounded(prefab, pt, spawn_pt)
                end
            else
                return SpawnHounded(prefab, pt, spawn_pt)
            end
        else
            return _SummonSpawn(pt, upgrade)
        end
    end

    UpvalueHacker.SetUpvalue(self.SummonSpawn, SummonSpawn, "SummonSpawn")

    local _OnSave = self.OnSave
    self.OnSave = function(self)
        local _houndedData = _OnSave(self)
        local houndedData = {
            varggraceperiod = self.varggraceperiod,
        }
        for k, v in pairs(_houndedData) do
            houndedData[k] = v
        end
        -- code for new variables
        return houndedData
    end

    local _OnLoad = self.OnLoad
    self.OnLoad = function(self, data)
        if data.varggraceperiod ~= nil then
            self.varggraceperiod = data.varggraceperiod
        end

        return _OnLoad(self, data)
    end

    --override the global SummonSpawn with the old local SummonSpawn function because Vargs use this to summon hounds
    self.SummonSpawn = function(self, pt)
        return pt ~= nil and _SummonSpawn(pt) or nil
    end
end)

AddPrefabPostInit("cave", function(inst)
    --lazy fix, not exactly mod compatible either
    --but I really don't know what Korean's stuff does
    --nor am patient enough to learn it right now.
    local wormspawn_um =
    {
        base_prefab = "worm",
        winter_prefab = "worm",
        summer_prefab = "worm",

        attack_levels =
        {
            intro = { warnduration = function() return 120 end, numspawns = function() return 1 end },
            light = { warnduration = function() return 60 end, numspawns = function() return 1 + math.random(0, 1) end },
            med   = { warnduration = function() return 45 end, numspawns = function() return 1 + math.random(0, 1) end },
            heavy = { warnduration = function() return 30 end, numspawns = function() return 2 + math.random(0, 1) end },
            crazy = { warnduration = function() return 30 end, numspawns = function() return 3 + math.random(0, 2) end },
        },

        attack_delays =
        {
            intro      = function() return TUNING.TOTAL_DAY_TIME * 6, math.random() * TUNING.TOTAL_DAY_TIME * 2.5 end,
            rare       = function() return TUNING.TOTAL_DAY_TIME * 7, math.random() * TUNING.TOTAL_DAY_TIME * 2.5 end,
            occasional = function() return TUNING.TOTAL_DAY_TIME * 8, math.random() * TUNING.TOTAL_DAY_TIME * 2.5 end,
            frequent   = function() return TUNING.TOTAL_DAY_TIME * 9, math.random() * TUNING.TOTAL_DAY_TIME * 2.5 end,
            crazy      = function() return TUNING.TOTAL_DAY_TIME * 10, math.random() * TUNING.TOTAL_DAY_TIME * 2.5 end,
        },

        warning_speech = "ANNOUNCE_WORMS",

        --Key = time, Value = sound prefab
        warning_sound_thresholds =
        {
            { time = 30,  sound = "LVL4_WORM" },
            { time = 60,  sound = "LVL3_WORM" },
            { time = 90,  sound = "LVL2_WORM" },
            { time = 500, sound = "LVL1_WORM" },
        },
    }
    if TUNING.DSTU.DEPTHSEELS then
        wormspawn_um.winter_prefab = "shockworm"
    end
    if TUNING.DSTU.DEPTHSVIPERS then
        wormspawn_um.summer_prefab = "viperworm"
    end
    if inst.components.hounded ~= nil then
        inst.components.hounded:SetSpawnData(wormspawn_um)
    end
end)
--[[
    AddComponentPostInit("hounded", function(self) --We can see if we can copy korean's stuff for worms
        if not self.inst:HasTag("cave") then return end

    --------------------------------------------------
    -- THE IMPORTANT STUFF --
    --------------------------------------------------
        self.spawn_boss = false
        self.boss_grace = 100 --grace period in days before boss hounds can spawn

        self.seasonal_chance = 0.33 --chance for seasonal hounds to spawn in their respective seasons
        self.spawnamount = 0
        self.seasonal_boss_chance = 0.5 --chance to spawn a seasonal boss hound instead of the default boss (defined on the line below)
        self.default_boss_prefab = "worm" --temp

        --framework for future spawn additions
        --seasonal boss hounds will be chosen randomly from their respective season tables
        self.seasonal_boss_prefabs = {
            ["autumn"] = {},
            ["winter"] = {},
            ["spring"] = {},
            ["summer"] = {},
        }
        --seasonal hound variants will be chosen randomly from their respective season tables
        --seasonal hound variants will be chosen randomly from their respective season tables
        self.seasonal_prefabs = {
            ["autumn"] = {""},
            ["winter"] = {""},
            ["spring"] = {""},
            ["summer"] = {""},
        }
        if TUNING.DSTU.DEPTHSVIPERS then
        self.seasonal_prefabs["autumn"] = {"viperworm"}
        end

        if TUNING.DSTU.DEPTHSEELS then
        self.seasonal_prefabs["winter"] = {"shockworm"}
        end

        if TUNING.DSTU.DEPTHSEELS then
        self.seasonal_prefabs["spring"] = {"shockworm"}
        end

        if TUNING.DSTU.DEPTHSVIPERS then
        self.seasonal_prefabs["summer"] = {"viperworm"}
        end
        self.spawnlimit = 0

    --------------------------------------------------
    -- THE ALSO IMPORTANT STUFF --
    --------------------------------------------------

        local function CalcSpawnLimit(value)
            if GLOBAL.TheWorld.state.cycles < 10 then
                return 0
            elseif GLOBAL.TheWorld.state.cycles < 30 then
                return 1
            elseif GLOBAL.TheWorld.state.cycles < 70 then
                return 2
            elseif GLOBAL.TheWorld.state.cycles < 100 then
                return 3
            else
                return 4
            end
        end

        local _OnUpdate = self.OnUpdate
        self.OnUpdate = function(self, dt)
            if self.GetTimeToAttack(self) > 0 and self.spawnamount > 0 then
                self.spawnamount = 0
            end

            if self.GetTimeToAttack(self) > 0 and GLOBAL.TheWorld.state.cycles >= self.boss_grace then
                self.spawn_boss = true
            end
            _OnUpdate(self, dt)
        end

        local _SummonSpawn = UpvalueHacker.GetUpvalue(self.SummonSpawn, "SummonSpawn")
        local _GetSpawnPoint = UpvalueHacker.GetUpvalue(self.SummonSpawn, "SummonSpawn", "GetSpawnPoint")

        local function SpawnHounded(prefab, pt, spawn_pt)
            if not prefab then
                return _SummonSpawn(pt)
            else
                local spawn = GLOBAL.SpawnPrefab(prefab)
                if spawn and spawn_pt ~= nil then
                    spawn.Physics:Teleport(spawn_pt:Get())
                    spawn:FacePoint(pt)
                    if spawn.components.spawnfader then
                        spawn.components.spawnfader:FadeIn()
                    end
                    return spawn
                end
            end
        end

        local function NoHoles(pt)
            return not GLOBAL.TheWorld.Map:IsPointNearHole(pt)
        end

        local SPAWN_DIST = 30

        local function GetMagmaSpawnPoint(pt)
            if not GLOBAL.TheWorld.Map:IsAboveGroundAtPoint(pt:Get()) then
                pt = GLOBAL.FindNearbyLand(pt, 1) or pt
            end
            local offset = GLOBAL.FindWalkableOffset(pt, math.random() * 2 * GLOBAL.PI, SPAWN_DIST, 12, true, true, NoHoles)
            if offset ~= nil then
                offset.x = offset.x + pt.x
                offset.z = offset.z + pt.z
                return offset
            end
        end

        local function SummonSpawn(pt)
            local spawn_pt = _GetSpawnPoint(pt)
            local magmaspawn_pt = GetMagmaSpawnPoint(pt)
            local season = GLOBAL.TheWorld.state.season
            local chance = math.random()
            local prefab_list = {}
            local prefab = nil
            local SpawnLimit = CalcSpawnLimit()

            --replaces the first hound in a wave with a random boss hound
            if pt and self.spawn_boss and magmaspawn_pt ~= nil and TUNING.DSTU.VARGWAVES and not TUNING.DSTU.BETA_COMPATIBILITY then
                self.spawn_boss = false
                prefab_list = self.seasonal_boss_prefabs[season]
                prefab = math.random() < self.seasonal_boss_chance and #prefab_list > 0 and prefab_list[math.random(#prefab_list)] or self.default_boss_prefab

                return SpawnHounded(prefab, pt, magmaspawn_pt)

            end
            --spawn a random seasonal hound
            if pt and chance < self.seasonal_chance and self.spawnamount <= SpawnLimit and GLOBAL.TheWorld.state.cycles >= 22 then
                self.spawnamount = self.spawnamount + 1

                prefab_list = self.seasonal_prefabs[season]
                prefab = #prefab_list > 0 and prefab_list[math.random(#prefab_list)] or nil
                if prefab == "magmahound" then
                    if magmaspawn_pt ~= nil then
                        return SpawnHounded(prefab, pt, magmaspawn_pt)
                    else
                        prefab = "hound"
                        return SpawnHounded(prefab, pt, spawn_pt)
                    end
                else
                    return SpawnHounded(prefab, pt, spawn_pt)
                end
            else
                return _SummonSpawn(pt)
            end
        end

        UpvalueHacker.SetUpvalue(self.SummonSpawn, SummonSpawn, "SummonSpawn")

        --override the global SummonSpawn with the old local SummonSpawn function because Vargs use this to summon hounds
        self.SummonSpawn = function(self, pt)
            return pt ~= nil and _SummonSpawn(pt) or nil
        end
    end)]]
