local UpvalueHacker = GLOBAL.require("tools/upvaluehacker")

--We can hack our way through the hounded component and create our own variables so we don't have to touch any of the private data --KoreanWaffles
AddComponentPostInit("hounded", function(self)
    if not self.inst:HasTag("forest") then return end

--------------------------------------------------
-- THE IMPORTANT STUFF --
--------------------------------------------------
    self.spawn_boss = false
    self.boss_grace = 100 --grace period in days before boss hounds can spawn

    self.seasonal_chance = 0.33 --chance for seasonal hounds to spawn in their respective seasons
    self.seasonal_boss_chance = 0.5 --chance to spawn a seasonal boss hound instead of the default boss (defined on the line below)
    self.default_boss_prefab = "warg"

    --framework for future spawn additions
    --seasonal boss hounds will be chosen randomly from their respective season tables
    self.seasonal_boss_prefabs = {
        ["autumn"] = {},
        ["winter"] = {},
        ["spring"] = {},
        ["summer"] = {},
    }
    --seasonal hound variants will be chosen randomly from their respective season tables
    self.seasonal_prefabs = {
        ["autumn"] = {"sporehound"},
        ["winter"] = {"glacialhound"},
        ["spring"] = {"lightninghound"},
        ["summer"] = {"magmahound"},
    }

--------------------------------------------------
-- THE ALSO IMPORTANT STUFF --
--------------------------------------------------
    local _OnUpdate = self.OnUpdate
    self.OnUpdate = function(self, dt)
        if self.GetTimeToAttack(self) > 0 and GLOBAL.TheWorld.state.cycles >= self.boss_grace then
            self.spawn_boss = false
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
            if spawn then
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

        --replaces the first hound in a wave with a random boss hound
        if pt and self.spawn_boss then
            self.spawn_boss = false
            prefab_list = self.seasonal_boss_prefabs[season]
            prefab = math.random() < self.seasonal_boss_chance and #prefab_list > 0 and prefab_list[math.random(#prefab_list)] or self.default_boss_prefab
            SpawnHounded(prefab, pt, spawn_pt)
            return
        end
        --spawn a random seasonal hound
        if pt and chance < self.seasonal_chance then
            prefab_list = self.seasonal_prefabs[season]
            prefab = #prefab_list > 0 and prefab_list[math.random(#prefab_list)] or nil
			if prefab == "magmahound" then
				SpawnHounded(prefab, pt, magmaspawn_pt)
			else
				SpawnHounded(prefab, pt, spawn_pt)
			end
        else
            _SummonSpawn(pt)
        end
    end

    UpvalueHacker.SetUpvalue(self.SummonSpawn, SummonSpawn, "SummonSpawn")

    --override the global SummonSpawn with the old local SummonSpawn function because Vargs use this to summon hounds
    self.SummonSpawn = function(self, pt)
        return pt ~= nil and _SummonSpawn(pt) or nil
    end
end)