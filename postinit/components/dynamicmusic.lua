local UpvalueHacker = GLOBAL.require("tools/upvaluehacker")

-- Oh the hoops you have to jump through to modify local functions
-- It's basically lua debug hacker dark magic --KoreanWaffles

--ok, turning this off from the modimport side didn't really work.
if GetModConfigData("um_music") and not TUNING.DSTU.ISLAND_ADVENTURES then
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
        _OnPlayerActivated = inst.event_listeners["playeractivated"][inst][index]

        local _StartBusy = UpvalueHacker.GetUpvalue(_OnPlayerActivated, "StartPlayerListeners", "StartBusy")
        local _StopBusy = UpvalueHacker.GetUpvalue(_OnPlayerActivated, "StartPlayerListeners", "StartBusy", "StopBusy")
        
        local _StartDanger = UpvalueHacker.GetUpvalue(_OnPlayerActivated, "StartPlayerListeners", "CheckAction", "StartDanger")

        local BUSYTHEMES = UpvalueHacker.GetUpvalue(_StartBusy, "BUSYTHEMES")
        BUSYTHEMES["HOODEDFOREST"] = 1337
        BUSYTHEMES["PINETREE_PIONEER"] = 1338
        
        local function IsInHoodedForest(player)
            return player.components.areaaware ~= nil
                and player.components.areaaware:CurrentlyInTag("hoodedcanopy")
        end

        local function StartBusy(player)
            -- get updated private variables
            local BUSYTHEMES = UpvalueHacker.GetUpvalue(_StartBusy, "BUSYTHEMES")
            local SEASON_DANGER_MUSIC = UpvalueHacker.GetUpvalue(_StartBusy, "SEASON_DANGER_MUSIC")
            local _iscave = UpvalueHacker.GetUpvalue(_StartBusy, "_iscave")
            local _isday = UpvalueHacker.GetUpvalue(_StartBusy, "_isday")
            local _busytask = UpvalueHacker.GetUpvalue(_StartBusy, "_busytask")
            local _busytheme = UpvalueHacker.GetUpvalue(_StartBusy, "_busytheme")
            local _extendtime = UpvalueHacker.GetUpvalue(_StartBusy, "_extendtime")
            local _dangertask = UpvalueHacker.GetUpvalue(_StartBusy, "_dangertask")
            local _isenabled = UpvalueHacker.GetUpvalue(_StartBusy, "_isenabled")
            local _soundemitter = UpvalueHacker.GetUpvalue(_StartBusy, "_soundemitter")
            local _pirates_near = UpvalueHacker.GetUpvalue(_StartBusy, "_pirates_near")

            -- Note: We only have references to the private variables
            -- In order to modify the actual variables, we have to use debug.setupvalue
            if not (_iscave or _isday) then
                return
            elseif _busytask ~= nil then
                local extendtime = GLOBAL.GetTime() + 15
                UpvalueHacker.SetUpvalue(_StartBusy, extendtime, "_extendtime")
            elseif _dangertask == nil and _pirates_near == nil and (_extendtime == 0 or GLOBAL.GetTime() >= _extendtime) and 
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
        
		local function StartWoby(player)
            -- get updated private variables
            local BUSYTHEMES = UpvalueHacker.GetUpvalue(_StartBusy, "BUSYTHEMES")
            local SEASON_DANGER_MUSIC = UpvalueHacker.GetUpvalue(_StartBusy, "SEASON_DANGER_MUSIC")
            local _iscave = UpvalueHacker.GetUpvalue(_StartBusy, "_iscave")
            local _isday = UpvalueHacker.GetUpvalue(_StartBusy, "_isday")
            local _busytask = UpvalueHacker.GetUpvalue(_StartBusy, "_busytask")
            local _busytheme = UpvalueHacker.GetUpvalue(_StartBusy, "_busytheme")
            local _extendtime = UpvalueHacker.GetUpvalue(_StartBusy, "_extendtime")
            local _dangertask = UpvalueHacker.GetUpvalue(_StartBusy, "_dangertask")
            local _isenabled = UpvalueHacker.GetUpvalue(_StartBusy, "_isenabled")
            local _soundemitter = UpvalueHacker.GetUpvalue(_StartBusy, "_soundemitter")
            local _pirates_near = UpvalueHacker.GetUpvalue(_StartBusy, "_pirates_near")

            -- Note: We only have references to the private variables
            -- In order to modify the actual variables, we have to use debug.setupvalue
			if not (_iscave or _isday) then
				if inst.wobytask ~= nil then
					inst.wobytask:Cancel()
					inst.wobytask = nil
				end
			
                return
			elseif (player.replica.rider ~= nil and player.replica.rider:IsRiding()) and not player:HasTag("dismounting") 
			and player.replica.rider:GetMount() ~= nil and player.replica.rider:GetMount():HasTag("woby") then
				
				if inst.wobytask == nil then
					inst.wobytask = player:DoPeriodicTask(3, function()
						StartWoby(player)
					end)
				end
				
				if _busytask ~= nil then
				print("busytask ~= nil")
							
					local extendtime = GLOBAL.GetTime() + 5
					UpvalueHacker.SetUpvalue(_StartBusy, extendtime, "_extendtime")
							
					--local busytask = inst:DoTaskInTime(5, _StopBusy, true)
					--UpvalueHacker.SetUpvalue(_StartBusy, busytask, "_busytask")
						
					--UpvalueHacker.SetUpvalue(_StartBusy, busytask, "_busytask")
				elseif _dangertask == nil and _pirates_near == nil and (_extendtime == 0 or GLOBAL.GetTime() >= _extendtime) and _isenabled then
						
				print("danger, pirates, extendtime == nil")
						
						
					if _busytheme ~= BUSYTHEMES.PINETREE_PIONEER then
						_soundemitter:KillSound("busy")
						_soundemitter:PlaySound("UMMusic/music/follow_me_woby", "busy")
					end
							
					local busytheme = BUSYTHEMES.PINETREE_PIONEER
					UpvalueHacker.SetUpvalue(_StartBusy, busytheme, "_busytheme")
					_soundemitter:SetParameter("busy", "intensity", 1)
							
					local busytask = inst:DoTaskInTime(10, _StopBusy, true)
					UpvalueHacker.SetUpvalue(_StartBusy, busytask, "_busytask")
					UpvalueHacker.SetUpvalue(_StartBusy, 0, "_extendtime")
				end
			elseif inst.wobytask ~= nil then
				inst.wobytask:Cancel()
				inst.wobytask = nil
			end
        end
		
        local EPIC_TAGS = { "epic" }
        local NO_EPIC_TAGS = { "noepicmusic" }
        local function StartDanger(player)
            -- get updated private variables
            local SEASON_DANGER_MUSIC = UpvalueHacker.GetUpvalue(_StartDanger, "SEASON_DANGER_MUSIC")
            local SEASON_EPICFIGHT_MUSIC = UpvalueHacker.GetUpvalue(_StartDanger, "SEASON_EPICFIGHT_MUSIC")
            local _iscave = UpvalueHacker.GetUpvalue(_StartDanger, "_iscave")
            local _extendtime = UpvalueHacker.GetUpvalue(_StartDanger, "_extendtime")
            local _dangertask = UpvalueHacker.GetUpvalue(_StartDanger, "_dangertask")
            local _isenabled = UpvalueHacker.GetUpvalue(_StartDanger, "_isenabled")
            local _soundemitter = UpvalueHacker.GetUpvalue(_StartDanger, "_soundemitter")
            local _IsInRuins = UpvalueHacker.GetUpvalue(_StartDanger, "IsInRuins")
            local _hasinspirationbuff = UpvalueHacker.GetUpvalue(_StartDanger, "_hasinspirationbuff")
            local _triggeredlevel = UpvalueHacker.GetUpvalue(_StartDanger, "_triggeredlevel")
            local _StopDanger = UpvalueHacker.GetUpvalue(_StartDanger, "StopDanger")
            local _pirates_near = UpvalueHacker.GetUpvalue(_StartDanger, "_pirates_near")

            -- Note: We only have references to the private variables
            -- In order to modify the actual variables, we have to use debug.setupvalue
            if not _soundemitter:PlayingSound("fogfear") and not _soundemitter:PlayingSound("tiddlestranger") then
                if IsInHoodedForest(player) then
                    if _dangertask ~= nil then
                        local extendtime = GLOBAL.GetTime() + 10
                        UpvalueHacker.SetUpvalue(_StartDanger, extendtime, "_extendtime")
                    elseif _isenabled then
                        _StopBusy()
                        local x, y, z = player.Transform:GetWorldPosition()
                        _soundemitter:PlaySound(
                            TheSim ~= nil and #TheSim:FindEntities(x, y, z, 30, EPIC_TAGS, NO_EPIC_TAGS) > 0
                            and ((_IsInRuins(player) and "dontstarve/music/music_epicfight_ruins") or
                                (_iscave and "dontstarve/music/music_epicfight_cave") or
                                (IsInHoodedForest(player) and "UMMusic/music/hoodedforest_efs") or
                                (SEASON_EPICFIGHT_MUSIC[inst.state.season]))
                            or ((_IsInRuins(player) and "dontstarve/music/music_danger_ruins") or
                                (_iscave and "dontstarve/music/music_danger_cave") or
                                (SEASON_DANGER_MUSIC[inst.state.season])),
                            "danger")
                        local dangertask = inst:DoTaskInTime(10, _StopDanger, true)
                        UpvalueHacker.SetUpvalue(_StartDanger, dangertask, "_dangertask")
                        UpvalueHacker.SetUpvalue(_StartDanger, nil, "_triggeredlevel")
                        UpvalueHacker.SetUpvalue(_StartDanger, 0, "_extendtime")

						if _pirates_near then
							_soundemitter:SetVolume("danger", 0)
						end
		
                        if _hasinspirationbuff then
                            _soundemitter:SetParameter("danger", "wathgrithr_intensity", _hasinspirationbuff)
                        end
                    end
                else
                    _StartDanger(player)
                end
            end
        end
        
        
    local function CheckAction(player)
        if player:HasTag("attack") then
            local target = player.replica.combat:GetTarget()
            if target ~= nil and
                target:HasTag("_combat") and
                not ((target:HasTag("prey") and not target:HasTag("hostile")) or
                    target:HasTag("bird") or
                    target:HasTag("butterfly") or
                    target:HasTag("shadow") or
                    target:HasTag("shadowchesspiece") or
                    target:HasTag("noepicmusic") or
                    target:HasTag("thorny") or
                    target:HasTag("smashable") or
                    target:HasTag("wall") or
                    target:HasTag("engineering") or
                    target:HasTag("smoldering") or
                    target:HasTag("veggie")) then
                if target:HasTag("shadowminion") or target:HasTag("abigail") then
                    local follower = target.replica.follower
                    if not (follower ~= nil and follower:GetLeader() == player) then
                        StartDanger(player)
                        return
                    end
                else
                    StartDanger(player)
                    return
                end
            end
        end
        if player:HasTag("working") then
            StartBusy(player)
        end
		
		if player:HasTag("polite") and (player.replica.rider ~= nil and player.replica.rider:IsRiding())
		and player.replica.rider:GetMount() ~= nil and player.replica.rider:GetMount():HasTag("woby") then
			inst:DoTaskInTime(1, function()
				StartWoby(player)
			end)
		elseif inst.wobytask ~= nil then
			inst.wobytask:Cancel()
			inst.wobytask = nil
		end
    end

    local function OnAttacked(player, data)
        if data ~= nil and
            --For a valid client side check, shadowattacker must be
            --false and not nil, pushed from player_classified
            (data.isattackedbydanger or
            --For a valid server side check, attacker must be non-nil
            (data.attacker ~= nil and
            not (data.attacker:HasTag("shadow") or
                data.attacker:HasTag("shadowchesspiece") or
                data.attacker:HasTag("noepicmusic") or
                data.attacker:HasTag("thorny") or
                data.attacker:HasTag("smolder")))) then

            StartDanger(player)
        end
    end

        -- All that just to modify one function ಠ_ಠ
        UpvalueHacker.SetUpvalue(_OnPlayerActivated, StartBusy, "StartPlayerListeners", "StartBusy")
        UpvalueHacker.SetUpvalue(_OnPlayerActivated, CheckAction, "StartPlayerListeners", "CheckAction")
        UpvalueHacker.SetUpvalue(_OnPlayerActivated, OnAttacked, "StartPlayerListeners", "OnAttacked")
        UpvalueHacker.SetUpvalue(_OnPlayerActivated, StartDanger, "StartPlayerListeners", "StartDanger")
    end)
end