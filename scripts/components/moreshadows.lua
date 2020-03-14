local MoreShadows = Class(function(self, inst)
    self.inst = inst

	--inst:ListenForEvent("weathertick", function(src, data) self:ToggleMoreShadows() end, TheWorld)
	
	self.inst:ListenForEvent("goinsane", function(src, data) self:ToggleMoreShadowsOn() end)
	self.inst:ListenForEvent("gosane", function(src, data) self:ToggleMoreShadowsOff() end)
	self.inst:ListenForEvent("death", function(src, data) self:ToggleMoreShadowsOff() end)
end,
nil,
{

})

function MoreShadows:ToggleMoreShadowsOn(active, src, data)
print("ON")
        self.inst:StartUpdatingComponent(self)

end

function MoreShadows:ToggleMoreShadowsOff(active, src, data)
print("OFF")
        self.inst:StopUpdatingComponent(self)
		if self.task ~= nil then
			self.task:Cancel()
			self.task = nil
		end

end

local NOTAGS = { "playerghost", "HASHEATER" }

local function ShadowSpawnChance(inst, self)
--print("chance")
	local x, y, z = self.inst.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x, y, z, 60, {"shadowcreature"})

	if #ents < 4 then
		--if math.random(1, 2500) == 1 then
		local xrandom = math.random(-15, 15)
		local zrandom = math.random(-15, 15)
		
		if math.random() <= 0.5 then
			print("CRAWLING HORRORS")
			local shadowcreaturespawn = SpawnPrefab("crawlinghorror")
			shadowcreaturespawn.Transform:SetPosition(x + xrandom, 0, z + zrandom)
		else
			print("TERRIFYING BEAKS")
			local shadowcreaturespawn = SpawnPrefab("terrorbeak")
			shadowcreaturespawn.Transform:SetPosition(x + xrandom, 0, z + zrandom)
		end
	--end
	end
	
	if self.task ~= nil then
		self.task:Cancel()
		self.task = nil
	end
		
end

TUNING.SHADOW_CHANCE_TIME = 60
TUNING.SHADOW_CHANCE_VARIANCE = 30


function MoreShadows:StartMoreShadowsTask(chancetime)

--print("task")
		chancetime = chancetime or (TUNING.SHADOW_CHANCE_TIME + math.random()*TUNING.SHADOW_CHANCE_VARIANCE)

		if self.task == nil then
			self.task = self.inst:DoTaskInTime(chancetime, ShadowSpawnChance, self)--, self)
		end
end

function MoreShadows:OnUpdate(dt)
   
		self:StartMoreShadowsTask()
		
end


return MoreShadows
