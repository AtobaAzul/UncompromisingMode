

local UpvalueHacker = GLOBAL.require("tools/upvaluehacker")
local debug = GLOBAL.debug
local select = GLOBAL.select

-- Oh the hoops you have to jump through to modify local functions
-- It's basically lua debug hacker dark magic --KoreanWaffles

--ok, turning this off from the modimport side didn't really work.
if not GetModConfigData("um_music") or TUNING.DSTU.ISLAND_ADVENTURES then return end


AddComponentPostInit("dynamicmusic", function(self)

    --Public
    local inst = self.inst

    --Private
    local _iscave = inst:HasTag("cave")
    local _isenabled = nil
    local _isday = nil
    local _soundemitter = nil
    local _activatedplayer = nil
    local _hasinspirationbuff = nil

    local source = "scripts/components/dynamicmusic.lua"
    local _OnPlayerActivated
    for i, func in ipairs(inst.event_listeners["playeractivated"][inst]) do
        -- We can find the correct func by the function's source since the
        -- event listeners likely won't have two different events of the same source
        if GLOBAL.debug.getinfo(func, "S").source == source then
            _OnPlayerActivated = inst.event_listeners["playeractivated"][inst][i]
            break
        end
    end

    -- Note: I would recommend trying to avoid getting upvalues from start/stop danger/busy 
    -- as those are the most commonly wrapped functions
    local _StartPlayerListeners = UpvalueHacker.GetUpvalue(_OnPlayerActivated, "StartPlayerListeners")

    local _StartBusy = UpvalueHacker.GetUpvalue(_StartPlayerListeners, "StartBusy")
    local _StartDanger = UpvalueHacker.GetUpvalue(_StartPlayerListeners, "OnAttacked", "StartDanger")
    local _StartTriggeredDanger = UpvalueHacker.GetUpvalue(_StartPlayerListeners, "StartTriggeredDanger")
    local _StartBusyTheme = UpvalueHacker.GetUpvalue(_StartPlayerListeners, "StartFarming", "StartBusyTheme")
    -- since tables are mutable there is no need to reget this upvalue
    local BUSYTHEMES = UpvalueHacker.GetUpvalue(_StartPlayerListeners, "StartFarming", "BUSYTHEMES")

    local _StopSoundEmitter = UpvalueHacker.GetUpvalue(_OnPlayerActivated, "StopSoundEmitter")

    local _StopDanger = UpvalueHacker.GetUpvalue(_StopSoundEmitter, "StopDanger")
    local _StopBusy = UpvalueHacker.GetUpvalue(_StopSoundEmitter, "StopBusy")

    if not (_StartBusy and _StopBusy and _StartDanger and _StartTriggeredDanger and _StopDanger and _StartBusyTheme and BUSYTHEMES) then
        return
    end

    -- Optimization
    local _, i_busytask = UpvalueHacker.GetUpvalue(_StartBusyTheme, "_busytask")
    local _, i_extendtime = UpvalueHacker.GetUpvalue(_StartBusyTheme, "_extendtime")
    local _, i_dangertask = UpvalueHacker.GetUpvalue(_StartBusyTheme, "_dangertask")
    local _, i_triggeredlevel = UpvalueHacker.GetUpvalue(_StartTriggeredDanger, "_triggeredlevel")

    local get_busytask = function() return select(2, debug.getupvalue(_StartBusyTheme, i_busytask)) end
    local get_dangertask = function() return select(2, debug.getupvalue(_StartBusyTheme, i_dangertask)) end

    local set_extendtime = function(time) debug.setupvalue(_StartBusyTheme, i_extendtime, time) end
    local set_dangertask = function(task) debug.setupvalue(_StartBusyTheme, i_dangertask, task) end
    local set_triggeredlevel = function(level) debug.setupvalue(_StartTriggeredDanger, i_triggeredlevel, level) end

    --------------------------------------------------------------------------------------------------

    BUSYTHEMES["HOODEDFOREST"] = 1337
    BUSYTHEMES["PINETREE_PIONEER"] = 1338
	
    local function IsInHoodedForest(player)
        return player.components.areaaware ~= nil
            and player.components.areaaware:CurrentlyInTag("hoodedcanopy")
    end

    local function StartBusy(player, ...)
        -- Note: We only have references to the private variables
        -- In order to modify the actual variables, we have to use debug.setupvalue
        if IsInHoodedForest(player) then
            if not (_iscave or _isday) then
                return
            elseif get_busytask() ~= nil then
                set_extendtime(GLOBAL.GetTime() + 15)
            else
                -- use startbusytheme to reduce upvalue usage and increase compatibility with game updates
                _StartBusyTheme(player, BUSYTHEMES.HOODEDFOREST, "UMMusic/music/hoodedforest_work", 15)
            end
        else
            return _StartBusy(player, ...)
        end
    end

    local EPIC_TAGS = { "epic" }
    local NO_EPIC_TAGS = { "noepicmusic" }
    local function StartDanger(player, ...)
        if _soundemitter:PlayingSound("fogfear") or _soundemitter:PlayingSound("tiddlestranger") then
            return
        end

        -- Note: We only have references to the private variables
        -- In order to modify the actual variables, we have to use debug.setupvalue
        local x, y, z = player.Transform:GetWorldPosition()
        if IsInHoodedForest(player) and TheSim ~= nil and #TheSim:FindEntities(x, y, z, 30, EPIC_TAGS, NO_EPIC_TAGS) > 0 then
            if get_dangertask() ~= nil then
                set_extendtime(GLOBAL.GetTime() + 10)
            elseif _isenabled then
                -- Note: This sucks :/ maybe theres a better way by using StartTriggeredDanger? -Half
                _StopBusy()
                _soundemitter:PlaySound("UMMusic/music/hoodedforest_efs", "danger")
                set_dangertask(inst:DoTaskInTime(10, _StopDanger, true))
                set_triggeredlevel(nil)
                set_extendtime(0)

                -- does um efs music even have "wathgrithr_intensity"?
                if _hasinspirationbuff then
                    _soundemitter:SetParameter("danger", "wathgrithr_intensity", _hasinspirationbuff)
                end
            end
        else
            return _StartDanger(player, ...)
        end
    end

    local function StartWobyMusic(player)
        _StartBusyTheme(player, BUSYTHEMES.PINETREE_PIONEER, "UMMusic/music/follow_me_woby", 2)
    end

    local function StartWixieMusic(player, data)
		local level = math.max(1, math.floor(data ~= nil and data.level or 1))
		
		if get_dangertask() ~= nil then
			set_extendtime(GLOBAL.GetTime() + 3)
		elseif _isenabled then
			_StopBusy()
			_StopDanger()
			
			_soundemitter:PlaySound("UMMusic/music/shadow_boxing", "danger")
			if _hasinspirationbuff then
				_soundemitter:SetParameter("danger", "wathgrithr_intensity", _hasinspirationbuff)
			end

			set_dangertask(inst:DoTaskInTime(data.duration or 10, _StopDanger, true))
			set_extendtime(0)
		end
	end


    -- All that just to modify one function ಠ_ಠ
    UpvalueHacker.SetUpvalue(_StartPlayerListeners, StartBusy, "StartBusy")
    UpvalueHacker.SetUpvalue(_StartPlayerListeners, StartDanger, "OnAttacked", "StartDanger")

    --------------------------------------------------------------------------------------------------

    local function UM_OnHasInspirationBuff(player, data)
        _hasinspirationbuff = (data ~= nil and data.on) and 1 or 0
    end

    local function UM_OnPhase(inst, phase)
        _isday = phase == "day"
    end

    local function UM_StartPlayerListeners(player)
        inst:ListenForEvent("hasinspirationbuff", UM_OnHasInspirationBuff, player)
        inst:ListenForEvent("playwobymusic", StartWobyMusic, player)
        inst:ListenForEvent("playwixiemusic", StartWixieMusic, player)
    end

    local function UM_StopPlayerListeners(player)
        inst:RemoveEventCallback("hasinspirationbuff", UM_OnHasInspirationBuff, player)
        inst:RemoveEventCallback("playwobymusic", StartWobyMusic, player)
        inst:RemoveEventCallback("playwixiemusic", StartWixieMusic, player)
    end

    local function UM_StartSoundEmitter()
        if _soundemitter == nil then
            _soundemitter = GLOBAL.TheFocalPoint.SoundEmitter
            if not _iscave then
                _isday = inst.state.isday
                inst:WatchWorldState("phase", UM_OnPhase)
            end
        end
    end

    local function UM_StopSoundEmitter()
        if _soundemitter ~= nil then
            inst:StopWatchingWorldState("phase", UM_OnPhase)
            _soundemitter = nil
            _hasinspirationbuff = nil
        end
    end

    local function UM_OnPlayerActivated(_inst, player)
        if _activatedplayer == player then
            return
        elseif _activatedplayer ~= nil and _activatedplayer.entity:IsValid() then
            UM_StopPlayerListeners(_activatedplayer)
        end
        _activatedplayer = player
        UM_StopSoundEmitter()
        UM_StartSoundEmitter()
        UM_StartPlayerListeners(player)
    end

    local function UM_OnPlayerDeactivated(_inst, player)
        UM_StopPlayerListeners(player)
        if player == _activatedplayer then
            _activatedplayer = nil
            UM_StopSoundEmitter()
        end
    end

    local function UM_OnEnableDynamicMusic(_inst, enable)
        _isenabled = enable
    end

    inst:ListenForEvent("playeractivated", UM_OnPlayerActivated)
    inst:ListenForEvent("playerdeactivated", UM_OnPlayerDeactivated)
    inst:ListenForEvent("enabledynamicmusic", UM_OnEnableDynamicMusic)
end)