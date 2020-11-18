local UpvalueHacker = GLOBAL.require("tools/upvaluehacker")

--We can hack our way through the hounded component and create our own variables so we don't have to touch any of the private data --KoreanWaffles
AddComponentPostInit("dynamicmusic", function(self)
    if not self.inst:HasTag("forest") then return end
	
    local _StartBusy = UpvalueHacker.GetUpvalue(self.StartBusy, "StartBusy")
   -- local _StopBusy = UpvalueHacker.GetUpvalue(self.StartBusy, "StartBusy", "StopBusy")
	
	local function StopBusy(inst, istimeout)
		if _busytask ~= nil then
			if not istimeout then
				_busytask:Cancel()
			elseif _extendtime > 0 then
				local time = GetTime()
				if time < _extendtime then
					_busytask = inst:DoTaskInTime(_extendtime - time, StopBusy, true)
					_extendtime = 0
					return
				end
			end
			_busytask = nil
			_extendtime = 0
			_soundemitter:SetParameter("busy", "intensity", 0)
		end
	end

	local function IsInHF(player)
		return player.components.areaaware ~= nil
			and player.components.areaaware:CurrentlyInTag("hoodedcanopy")
	end

	local function StartBusy(player)
		if IsInHF(player) then
			if not (_iscave or _isday) then        
				return
			elseif _busytask ~= nil then
				_extendtime = GetTime() + 15
			elseif _dangertask == nil and (_extendtime == 0 or GetTime() >= _extendtime) and _isenabled then

				if _busytheme ~= BUSYTHEMES.HOODEDFOREST then
					_soundemitter:KillSound("busy")
					_soundemitter:PlaySound("UCSounds/music/creepyforest", "busy")
				end
				_busytheme = BUSYTHEMES.HOODEDFOREST
				
				_soundemitter:SetParameter("busy", "intensity", 1)
				_busytask = inst:DoTaskInTime(15, StopBusy, true)
				_extendtime = 0
			end
		else
			_StartBusy(player)
		end
	end

    UpvalueHacker.SetUpvalue(self.CheckAction, StartBusy, "StartBusy")
end)