--local function onsnowstormlevel(self, snowstormlevel)
    --self.inst.replica.hayfever:SetNextSneezeTime(sneezetime)
--end

local SnowStormWatcher = Class(function(self, inst)
    self.inst = inst

    --self.snowstormlevel = 0
    self.snowstormspeedmult = .55
    self.delay = nil
	inst:ListenForEvent("weathertick", function(src, data) self:ToggleSnowstorms() end, TheWorld)
	
	inst:ListenForEvent("seasontick", function(src, data) self:ToggleSnowstorms() end, TheWorld)
	
	
	
end,
nil,
{
    --snowstormlevel = onsnowstormlevel,
})


local function OnChangeArea(inst)
    local self = inst.components.stormwatcher
    self:UpdateSnowstormLevel()
end

local function UpdateSnowstormWalkSpeed(inst)
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
	
	if not TheWorld.state.issnowing then
		self:UpdateSnowstormWalkSpeed()
		self.inst:PushEvent("snowoff")
        self.inst:StopUpdatingComponent(self)
    elseif TheWorld.state.cycles > TUNING.DSTU.WEATHERHAZARD_START_DATE then
        self.inst:StartUpdatingComponent(self)
                AddSnowstormWalkSpeedListeners(self.inst)
            self:UpdateSnowstormLevel()
			self:UpdateSnowstormWalkSpeed()
			self.inst:PushEvent("snowon")
    end
end

function SnowStormWatcher:UpdateSnowstormLevel()

        self:UpdateSnowstormWalkSpeed()
    --end
end

function SnowStormWatcher:UpdateSnowstormWalkSpeed(src, data)
		local x, y, z = self.inst.Transform:GetWorldPosition()
		local ents = TheSim:FindEntities(x, y, z, 4, {"wall"})
		local suppressorNearby1 = (#ents > 2)
		
		local ents2 = TheSim:FindEntities(x, y, z, 6, {"fire"})
		local suppressorNearby2 = (#ents2 > 0)
		
		local ents3 = TheSim:FindEntities(x, y, z, 5.5, {"shelter"})
		local suppressorNearby3 = (#ents3 > 2)
		
    if TheWorld.state.issnowing then
        if self.inst.components.playervision:HasGoggleVision() or
            self.inst.components.playervision:HasGhostVision() or
            self.inst.components.rider:IsRiding() or
			suppressorNearby1 or suppressorNearby2 or suppressorNearby3 then
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

	if math.random(1, 2000) == 1 then
			--local spawn_pt = GetSpawnPoint(origin_pt, PLAYER_CHECK_DISTANCE + 5)
		local x1, y1, z1 = v.Transform:GetWorldPosition()
			
		local ents5 = TheSim:FindEntities(x1, y1, z1, 3, nil, nil, { "snowpileradius"})
		local ents6 = TheSim:FindEntities(x1, y1, z1, 8, nil, nil, { "fire" })
			--local ents = TheSim:FindEntities(x, y, z, 40, {"wall" "player" "campfire"})
		if TheWorld.Map:IsAboveGroundAtPoint(x1, y1, z1) and #ents5 < 1 and #ents6 < 1 then
			local snowpilespawn = SpawnPrefab("snowpile")
			snowpilespawn.Transform:SetPosition(x1, 0.05, z1)
		end
	end
		
end

local NOTAGS = { "playerghost", "HASHEATER" }

function SnowStormWatcher:SnowpileChance()

	local x, y, z = self.inst.Transform:GetWorldPosition()
    local ents4 = TheSim:FindEntities(x, y, z, 50, nil, NOTAGS, { "structure" })
    for i, v in ipairs(ents4) do
        TrySpawning(v)
    end

	if ents4 == nil or 0 then
		if math.random(1, 3200) == 1 then
		local xrandom = math.random(-20, 20)
		local zrandom = math.random(-20, 20)

		local ents7 = TheSim:FindEntities(x + xrandom, y, z + zrandom, 8, nil, nil, { "snowpileradius"})
		local ents8 = TheSim:FindEntities(x + xrandom, y, z + zrandom, 8, nil, nil, { "fire" })

				--local ents = TheSim:FindEntities(x, y, z, 40, {"wall" "player" "campfire"})
		if TheWorld.Map:IsAboveGroundAtPoint(x + xrandom, y, z + zrandom) and #ents7 < 1 and #ents8 < 1 then
			local snowpilespawnplayer = SpawnPrefab("snowpile")
			--snowpilespawnplayer.Transform:SetPosition(x + math.random(-20, 20), 0, z + math.random(-20, 20))
		
			snowpilespawnplayer.Transform:SetPosition(x + xrandom, 0, z + zrandom)
		end
	end
	end
		
end

function SnowStormWatcher:OnUpdate(dt)
   
        self:UpdateSnowstormLevel()
		
		self:ToggleSnowstorms()
		
		self:SnowpileChance()
		
		if TheWorld.state.issnowing then
			self.inst:PushEvent("snowon")
			self.inst:PushEvent("snowondirty")
		else
			self.inst:PushEvent("snowoff")
			self.inst:PushEvent("snowoffdirty")
		end
end


return SnowStormWatcher
