local SnowStormWatcher = Class(function(self, inst)
    self.inst = inst

    self.snowstormspeedmult = .75
    self.delay = nil
	self.task = nil
	inst:ListenForEvent("weathertick", function(src, data) self:ToggleSnowstorms() end, TheWorld)
	
	inst:ListenForEvent("seasontick", function(src, data) self:ToggleSnowstorms() end, TheWorld)
	
	
	
end,
nil,
{
    --snowstormlevel = onsnowstormlevel,
})

local INVALID_TILES = table.invert(
{
        GROUND.DRAGONFLY
})

local function UpdateSnowstormWalkSpeed(inst)
    inst.components.snowstormwatcher:UpdateSnowstormWalkSpeed()
end

local function StormStart(self)
	self.stormtask = nil

	TheWorld:AddTag("snowstormstart")
	TheWorld.net:AddTag("snowstormstartnet")
end

local function StormStop(self)
	self.stopstormtask = nil

	TheWorld:RemoveTag("snowstormstart")
	TheWorld.net:RemoveTag("snowstormstartnet")
end

function SnowStormWatcher:ToggleSnowstorms(active, src, data)
	
	if not TheWorld.state.issnowing then
		self:UpdateSnowstormWalkSpeed()
		self.inst:PushEvent("snowoff")
        self.inst:StopUpdatingComponent(self)
		self.task = nil
		self.stormtask = nil
		self.stopstormtask = nil
		TheWorld:RemoveTag("snowstormstart")
    elseif TheWorld.state.cycles > TUNING.DSTU.WEATHERHAZARD_START_DATE then
        self.inst:StartUpdatingComponent(self)
		if self.stormtask == nil then
			self.stormtask = self.inst:DoTaskInTime(80 + math.random(10,40), StormStart, self)--, self)
		end
		
		if self.stopstormtask == nil then
			self.stopstormtask = self.inst:DoTaskInTime(580 + math.random(20,40), StormStop, self)--, self)
		end
		
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
		local ents = TheSim:FindEntities(x, y, z, 4, {"wall"})
		local suppressorNearby1 = (#ents > 2)
		
		local ents2 = TheSim:FindEntities(x, y, z, 6, {"fire"})
		local suppressorNearby2 = (#ents2 > 0)
		
		local ents3 = TheSim:FindEntities(x, y, z, 5.5, {"shelter"})
		local suppressorNearby3 = (#ents3 > 2)
		
		local ents4 = TheSim:FindEntities(x, y, z, 6, {"snowstorm_protection_high"})
		local suppressorNearby4 = (#ents4 > 0)
		
    if TheWorld.state.issnowing then
        if self.inst.components.playervision:HasGoggleVision() or
            self.inst.components.playervision:HasGhostVision() or
            self.inst.components.rider:IsRiding() or
			suppressorNearby1 or suppressorNearby2 or suppressorNearby3 or suppressorNearby4 then
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
	local nearbyplayers2 = TheSim:FindEntities(x1, y1, z1, 50, nil, nil, { "player"})
	
	local playervalue2 = #nearbyplayers2 * 0.1
	
	if TheWorld.state.iswinter and ( TheWorld.net:HasTag("snowstormstartnet") or TheWorld:HasTag("snowstormstart") )  then--and self.snowstormstart then
		if math.random() <= 0.15 - playervalue2 then
				--local spawn_pt = GetSpawnPoint(origin_pt, PLAYER_CHECK_DISTANCE + 5)
				
			local ents5 = TheSim:FindEntities(x1, y1, z1, 3, nil, nil, { "snowpileradius"})
			local ents6 = TheSim:FindEntities(x1, y1, z1, 8, nil, nil, { "fire" })
			local ents7 = TheSim:FindEntities(x1, y1, z1, 2, nil, nil, { "snowpiledin"})
				--local ents = TheSim:FindEntities(x, y, z, 40, {"wall" "player" "campfire"})
			if #ents5 < 1 and #ents6 < 1 and #ents7 < 1 and not INVALID_TILES[TheWorld.Map:GetTileAtPoint(x1, 0, z1)] then
				local snowpilespawn = SpawnPrefab("snowpile")
				snowpilespawn.Transform:SetPosition(x1, 0.05, z1)
			end
		end
	end
		
end

local NOTAGS = { "playerghost", "HASHEATER" }

local function SnowpileChance(inst, self)
	local x, y, z = self.inst.Transform:GetWorldPosition()
    local nearbyplayers1 = TheSim:FindEntities(x, y, z, 50, nil, nil, { "player" })
    local ents4 = TheSim:FindEntities(x, y, z, 50, nil, { "snowpiledin", "hive" }, { "structure" })
	local chancer = math.random()
	
	
	if TheWorld.state.iswinter and ( TheWorld.net:HasTag("snowstormstartnet") or TheWorld:HasTag("snowstormstart") ) then--and self.snowstormstart then
		if chancer < 0.30 - #nearbyplayers1 * 0.025 then
				local xrandom = math.random(-20, 20)
				local zrandom = math.random(-20, 20)
				local ents7 = TheSim:FindEntities(x + xrandom, y, z + zrandom, 6, nil, nil, { "snowpileradius"})
				local ents8 = TheSim:FindEntities(x + xrandom, y, z + zrandom, 8, nil, nil, { "fire" })

				if TheWorld.Map:IsPassableAtPoint(x + xrandom, 0, z + zrandom) and #ents7 < 1 and #ents8 < 1 and not INVALID_TILES[TheWorld.Map:GetTileAtPoint(x + xrandom, 0, z + zrandom)] then
					local snowpilespawn = SpawnPrefab("snowpile")

					snowpilespawn.Transform:SetPosition(x + xrandom, 0.05, z + zrandom)
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

TUNING.SNOW_CHANCE_TIME = 60
TUNING.SNOW_CHANCE_VARIANCE = 30


function SnowStormWatcher:StartSnowPileTask()

		if self.task == nil then
			self.task = self.inst:DoTaskInTime(60 + math.random()*30, SnowpileChance, self)--, self)
		end
end

function SnowStormWatcher:OnUpdate(dt)
   
        self:UpdateSnowstormLevel()
		
		self:ToggleSnowstorms()
		
		self:StartSnowPileTask()
		
end


return SnowStormWatcher

--[[

@@ -26,20 +26,6 @@ local function UpdateSnowstormWalkSpeed(inst)
    inst.components.snowstormwatcher:UpdateSnowstormWalkSpeed()
end

local function AddSnowstormWalkSpeedListeners(inst)
    inst:ListenForEvent("gogglevision", UpdateSnowstormWalkSpeed)
    inst:ListenForEvent("ghostvision", UpdateSnowstormWalkSpeed)
    inst:ListenForEvent("mounted", UpdateSnowstormWalkSpeed)
    inst:ListenForEvent("dismounted", UpdateSnowstormWalkSpeed)
end

local function RemoveSnowstormWalkSpeedListeners(inst)
    inst:RemoveEventCallback("gogglevision", UpdateSnowstormWalkSpeed)
    inst:RemoveEventCallback("ghostvision", UpdateSnowstormWalkSpeed)
    inst:RemoveEventCallback("mounted", UpdateSnowstormWalkSpeed)
    inst:RemoveEventCallback("dismounted", UpdateSnowstormWalkSpeed)
    inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "snowstorm")
end

function SnowStormWatcher:ToggleSnowstorms(active, src, data)
	
@ -50,10 +36,6 @@ function SnowStormWatcher:ToggleSnowstorms(active, src, data)
		self.task = nil
    elseif TheWorld.state.cycles > TUNING.DSTU.WEATHERHAZARD_START_DATE then
        self.inst:StartUpdatingComponent(self)
                AddSnowstormWalkSpeedListeners(self.inst)
            self:UpdateSnowstormLevel()
			self:UpdateSnowstormWalkSpeed()
			self.inst:PushEvent("snowon")
    end
end

@ -170,15 +152,6 @@ function SnowStormWatcher:OnUpdate(dt)
		
		self:StartSnowPileTask()
		
		--self:SnowpileChance()
		
		if TheWorld.state.issnowing then
			self.inst:PushEvent("snowon")
			--self.inst:PushEvent("snowondirty")
		else
			self.inst:PushEvent("snowoff")
			--self.inst:PushEvent("snowoffdirty")
		end
end

--]]
