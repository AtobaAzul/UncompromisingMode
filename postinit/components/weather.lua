local env = env
GLOBAL.setfenv(1, GLOBAL)
local UpvalueHacker = require("tools/upvaluehacker")
env.AddComponentPostInit("weather", function(self)

    local _CalculatePrecipitationRate = UpvalueHacker.GetUpvalue(self.OnUpdate, "CalculatePrecipitationRate")

    local _OnUpdate = self.OnUpdate
    local _rainfx
    local _snowfx
    local _pollenfx
    local _hasfx = not TheNet:IsDedicated()
    for i, v in pairs(Ents) do
        if v.prefab then
            if v.prefab == "rain" then
                _rainfx = v
            elseif v.prefab == "snow" then
                _snowfx = v
            elseif v.prefab == "pollen" then
                _pollenfx = v
            end
        end
    end

    function self:OnUpdate(dt)
        _OnUpdate(self, dt) --fucking IA breaks this upvalue somehow.
        local preciprate = _CalculatePrecipitationRate ~= nil and _CalculatePrecipitationRate() or 1

        if TheWorld.state.issummer and TheWorld.net:HasTag("heatwavestartnet") then
            if _hasfx and _pollenfx ~= nil then
                _pollenfx.particles_per_tick = _pollenfx.particles_per_tick * 20 + 1 -- MOREEEEEEEEEEEEEEEE
            end
        end

        if ThePlayer ~= nil and ThePlayer:HasTag("under_the_weather") then
			local tornado = TheSim:FindFirstEntityWithTag("um_tornado")
            if _hasfx and tornado ~= nil and tornado:IsValid() and _rainfx ~= nil then
                local tornado_dist = math.sqrt(ThePlayer:GetDistanceSqToInst(tornado))
                local max_intensity = TUNING.DSTU.REDUCED_TORNADO_VFX and 5 or 10
                local intensity = Lerp(max_intensity, 1, tornado_dist / 300)
                _rainfx.particles_per_tick = preciprate * 5 + intensity
                _rainfx.splashes_per_tick = preciprate * 3 + intensity
            end
        end
    end
end)
