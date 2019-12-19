local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
local function trip_damage(player)
    player.components.health:DoDelta(-TUNING.DSTU.TRIPOVER_HEALTH_DAMAGE)
end

local function trip_over(player)
    --trip over you scrubby eel
    player:PushEvent("knockback", {knocker = player, radius = TUNING.DSTU.TRIPOVER_KNOCKABCK_RADIUS, strengthmult = 0.5})
    player:DoTaskInTime(0.5, trip_damage)
end

local function trip_chance_check()
    return math.random() < TUNING.DSTU.TRIPOVER_ONMAXWET_CHANCE_PER_SEC
end

local function trip_over_chance_on_maxwet(player)
    if player ~= nil and player:HasTag("character") and (player:GetMoisture() >= player:GetMaxMoisture()-10) and player.sg ~= nil and player.sg:HasStateTag("moving") then
        local time = GetTime()
        if player.components.moisture.lastslip_check < time - 1 then
            if player.components.moisture.lastslip_time < time - TUNING.DSTU.TRIPOVER_ONMAXWET_COOLDOWN  then
                print("chance")
                if trip_chance_check() then
                    print("hit")
                    trip_over(player)
                    --play sound too
                    player.SoundEmitter:PlaySound("dontstarve/common/dropGeneric")
                    player.components.moisture.lastslip_time = time
                end
            end
            player.components.moisture.lastslip_check = time
        end
    end
end

AddComponentPostInit("moisture", function(self)
	self.lastslip_time = GetTime()
    self.lastslip_check = GetTime()
	
	local _OldOnUpdate = self.OnUpdate
        
    self.OnUpdate = function(self, dt)
		_OldOnUpdate(self, dt)
		trip_over_chance_on_maxwet(self.inst)
	end
end)
