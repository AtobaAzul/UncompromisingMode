local env = env
GLOBAL.setfenv(1, GLOBAL)
local UpvalueHacker = require("tools/upvaluehacker")


--thanks korean!


local YES_TAGS_SHADECANOPY = {"shadecanopy"}
local YES_TAGS_SHADECANOPY_SMALL = {"shadecanopysmall"}
local function checkforcanopyshade(obj)
    local x,y,z = obj.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x,y,z, TUNING.SHADE_CANOPY_RANGE, YES_TAGS_SHADECANOPY)
    if #ents > 0 then
        return true
    end
    ents = TheSim:FindEntities(x,y,z, TUNING.SHADE_CANOPY_RANGE_SMALL, YES_TAGS_SHADECANOPY_SMALL)
    if #ents > 0 then
        return true
    end    
end

local notags =  { "wildfireprotected", "fire", "burnt", "player", "companion", "NOCLICK", "INLIMBO" }

env.AddComponentPostInit("wildfires", function(self)
    local _ShouldActivateWildfires
    local _CheckValidWildfireStarter
    local _ms_startwildfireforplayerfn
    local inst = self.inst
    -- simplify the for loop by adding [inst] to the end
    for k, func in pairs(inst.event_listening["ms_lightwildfireforplayer"][inst]) do
        -- check that the upvalue we want to grab is the correct one (i.e the function ShouldActivateWildfires)
        if UpvalueHacker.GetUpvalue(func, "ShouldActivateWildfires") then
            _ms_startwildfireforplayerfn = func
            _ShouldActivateWildfires = UpvalueHacker.GetUpvalue(func, "ShouldActivateWildfires")
            _CheckValidWildfireStarter = UpvalueHacker.GetUpvalue(func, "LightFireForPlayer", "CheckValidWildfireStarter")
            -- we can break out of the loop now since we found the upvalue we wanted
            break
        end
    end
    local ShouldActivateWildfires = function()
        return _ShouldActivateWildfires() and TheWorld:HasTag("heatwavestart")
    end



    --TODO: HOOK.
    local CheckValidWildfireStarter = function(obj)
        local x, y, z = obj.Transform:GetWorldPosition()
        return obj:IsValid() and not obj:HasTag("fireimmune") and not checkforcanopyshade(obj) and not (obj.components.witherable ~= nil and obj.components.witherable:IsProtected()) and GetTemperatureAtXZ(x, z) >= TUNING.WILDFIRE_THRESHOLD
    end

    UpvalueHacker.SetUpvalue(_ms_startwildfireforplayerfn, ShouldActivateWildfires, "ShouldActivateWildfires")
    UpvalueHacker.SetUpvalue(_ms_startwildfireforplayerfn, CheckValidWildfireStarter, "LightFireForPlayer",
        "CheckValidWildfireStarter")
end)
