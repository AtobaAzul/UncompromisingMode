
local UpvalueHacker = GLOBAL.require("tools/upvaluehacker")

-- Oh the hoops you have to jump through to modify local functions 
-- It's basically lua debug hacker dark magic --KoreanWaffles
AddComponentPostInit("dynamicmusic", function(self)
    local inst = self.inst
    local source = "scripts/components/dynamicmusic.lua"
    local _OnPlayerActivated
    local index
    for i, func in ipairs(inst.event_listeners["playeractivated"][inst]) do
        -- We can find the correct func by the function's source since the
        -- event listeners likely won't have two different events of the same source
        if GLOBAL.debug.getinfo(func, "S").source == source then
            index = i
            break
        end
    end
    _OnPlayerActivated = UpvalueHacker.GetComponentEvent(self.inst, "dynamicmusic", "playeractivated")

    local _StartBusy = UpvalueHacker.GetUpvalue(_OnPlayerActivated, "StartPlayerListeners", "StartBusy")
    local _StopBusy = UpvalueHacker.GetUpvalue(_OnPlayerActivated, "StartPlayerListeners", "StartBusy", "StopBusy")
        
    local BUSYTHEMES = UpvalueHacker.GetUpvalue(_StartBusy, "BUSYTHEMES")
    BUSYTHEMES["HOODEDFOREST"] = #BUSYTHEMES + 1

    local function IsInHoodedForest(player)
        return player.components.areaaware ~= nil
            and player.components.areaaware:CurrentlyInTag("hoodedcanopy")
    end

    local function StartBusy(player)
        -- get updated private variables
        local BUSYTHEMES = UpvalueHacker.GetUpvalue(_StartBusy, "BUSYTHEMES")
        local _iscave = UpvalueHacker.GetUpvalue(_StartBusy, "_iscave")
        local _isday = UpvalueHacker.GetUpvalue(_StartBusy, "_isday")
        local _busytask = UpvalueHacker.GetUpvalue(_StartBusy, "_busytask")
        local _busytheme = UpvalueHacker.GetUpvalue(_StartBusy, "_busytheme")
        local _extendtime = UpvalueHacker.GetUpvalue(_StartBusy, "_extendtime")
        local _dangertask = UpvalueHacker.GetUpvalue(_StartBusy, "_dangertask")
        local _isenabled = UpvalueHacker.GetUpvalue(_StartBusy, "_isenabled")
        local _soundemitter = UpvalueHacker.GetUpvalue(_StartBusy, "_soundemitter")

        -- Note: We only have references to the private variables
        -- In order to modify the actual variables, we have to use debug.setupvalue
        if not (_iscave or _isday) then
            return
        elseif _busytask ~= nil then
            local extendtime = GLOBAL.GetTime() + 15
            UpvalueHacker.SetUpvalue(_StartBusy, extendtime, "_extendtime")
        elseif _dangertask == nil and (_extendtime == 0 or GLOBAL.GetTime() >= _extendtime) and 
            _isenabled and not _iscave and IsInHoodedForest(player) then
            if _busytheme ~= BUSYTHEMES.HOODEDFOREST then
                _soundemitter:KillSound("busy")
                _soundemitter:PlaySound("UMMusic/music/hoodedforest_work", "busy")
            end
            local busytheme = BUSYTHEMES.HOODEDFOREST
            UpvalueHacker.SetUpvalue(_StartBusy, busytheme, "_busytheme")
            _soundemitter:SetParameter("busy", "intensity", 0.75)
            local busytask = inst:DoTaskInTime(15, _StopBusy, true)
            UpvalueHacker.SetUpvalue(_StartBusy, busytask, "_busytask")
            UpvalueHacker.SetUpvalue(_StartBusy, 0, "_extendtime")
        else
            _StartBusy(player)
        end
    end

    -- All that just to modify one function ಠ_ಠ
    UpvalueHacker.SetUpvalue(_OnPlayerActivated, StartBusy, "StartPlayerListeners", "StartBusy")
end)