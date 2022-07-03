--------------------------------------------------------------------------
--[[ Dependencies ]]
--------------------------------------------------------------------------
local easing = require("easing")

--------------------------------------------------------------------------
--[[ Gmoosespawner class definition ]]
--------------------------------------------------------------------------
return Class(function(self, inst)

assert(TheWorld.ismastersim, "Gmoosespawner should not exist on client")

--------------------------------------------------------------------------
--[[ Private constants ]]
--------------------------------------------------------------------------

local STRUCTURE_DIST = 20
local HASSLER_SPAWN_DIST = 40
local HASSLER_KILLED_DELAY_MULT = 6
local STRUCTURES_PER_SPAWN = 4
local MOTHERGOOSE_TIMERNAME = "mothergoose_timetoattack"


--------------------------------------------------------------------------
--[[ Public Member Variables ]]
--------------------------------------------------------------------------

self.inst = inst

--------------------------------------------------------------------------
--[[ Private Member Variables ]]
--------------------------------------------------------------------------
local _warning = false
local _timetoattack = nil
local _moonmawdelay = nil
local _warnduration = 60
local _timetonextwarningsound = 0
local _announcewarningsoundinterval = 4

local _worldsettingstimer = TheWorld.components.worldsettingstimer
	
local _attackdelay = nil
local _attacksperseason = 4
local _attackduringoffseason = false
local _targetplayer = nil
local _activehassler = nil
local _storedhassler = nil

local _activeplayers = {}

--------------------------------------------------------------------------
--[[ Private member functions ]]
--------------------------------------------------------------------------

local function AllowedToAttack()
	--print("Deerclopsspawner allowed to attack?", TheWorld.state.cycles, _attackduringoffseason, TheWorld.state.season)
    return  (#_activeplayers > 0 and
            TheWorld.state.cycles > TUNING.NO_BOSS_TIME and  
                (_attackduringoffseason or
                TheWorld.state.season == "spring"))
end

local function IsEligible(player)
	local area = player.components.areaaware
	return TheWorld.Map:IsVisualGroundAtPoint(player.Transform:GetWorldPosition())
			and area:GetCurrentArea() ~= nil 
			and not area:CurrentlyInTag("nohasslers")
end

local function PickAttackTarget()
    _targetplayer = nil
    if #_activeplayers == 0 then
        return
    end

	local playerlist = {}
	for _, v in ipairs(_activeplayers) do
		if IsEligible(v) then
			table.insert(playerlist, v)
		end
	end
	shuffleArray(playerlist)
	if #playerlist == 0 then
		return
	end

	local numStructures = 0
	local loopCount = 0
	local player = nil
	while (numStructures <  STRUCTURES_PER_SPAWN) and (loopCount < (#playerlist + 3)) do 
		player = playerlist[1 + (loopCount % #playerlist)]

		local x,y,z = player.Transform:GetWorldPosition()
		local ents = TheSim:FindEntities(x,y,z, STRUCTURE_DIST, {"structure"}) 

		--print("Deerclopsspawner loop", #ents, loopCount, player)
		numStructures = #ents
		loopCount = loopCount + 1
	end
	--print("Deerclops picked target", player)
	_targetplayer = player
end

local function PauseAttacks()
	_targetplayer = nil
    _warning = false
    self.inst:StopUpdatingComponent(self)
    _worldsettingstimer:PauseTimer(MOTHERGOOSE_TIMERNAME, true)
end

local function ResetAttacks()
    _worldsettingstimer:StopTimer(MOTHERGOOSE_TIMERNAME)
    PauseAttacks()
end

local function TryStartAttacks(killed)
    if AllowedToAttack() then
        if _activehassler == nil and _attacksperseason > 0 and _timetoattack == nil then
            -- Shorten the time used for winter to account for the time deerclops spends stomping around
            -- Then add one to _attacksperwinter to shift the attacks so the last attack isn't right when the season changes to spring
            --local attackdelay = (TheWorld.state.summerlength - 1) * TUNING.TOTAL_DAY_TIME / (_attacksperseason + 1) 
			local attackdelay = killed == true and _attackdelay * HASSLER_KILLED_DELAY_MULT or _attackdelay
			
			_worldsettingstimer:StartTimer(MOTHERGOOSE_TIMERNAME, attackdelay)
        end

        _worldsettingstimer:ResumeTimer(MOTHERGOOSE_TIMERNAME)
        self.inst:StartUpdatingComponent(self)
        self:StopWatchingWorldState("cycles", TryStartAttacks)
        self.inst.watchingcycles = nil
    else
        PauseAttacks()
        if not self.inst.watchingcycles then
            self:WatchWorldState("cycles", TryStartAttacks)  -- keep checking every day until NO_BOSS_TIME is up
            self.inst.watchingcycles = true
        end
    end
end

local function TargetLost()
    local timetoattack = _worldsettingstimer:GetTimeLeft(MOTHERGOOSE_TIMERNAME)
    if timetoattack == nil then
        _warning = false
        _worldsettingstimer:StartTimer(MOTHERGOOSE_TIMERNAME, _warnduration + 1)
    elseif (timetoattack < _warnduration and _warning) then
        _warning = false
        _worldsettingstimer:SetTimeLeft(MOTHERGOOSE_TIMERNAME, _warnduration + 1)
    end

    PickAttackTarget()
    if _targetplayer == nil then
        PauseAttacks()
    end
end

local function GetSpawnPoint(pt)
    if not TheWorld.Map:IsAboveGroundAtPoint(pt:Get()) then
        pt = FindNearbyLand(pt, 1) or pt
    end
    local offset = FindWalkableOffset(pt, math.random() * 2 * PI, HASSLER_SPAWN_DIST / 2, 12, true)
    if offset ~= nil then
        offset.x = offset.x + pt.x
        offset.z = offset.z + pt.z
        return offset
    end
end

local STRUCTURE_TAGS = {"structure"}
local function ReleaseHassler(targetPlayer)
    assert(targetPlayer)

    local hassler = TheSim:FindFirstEntityWithTag("mothergoose")
    if hassler ~= nil or not AllowedToAttack() then
        return hassler -- There's already a hassler in the world, we're done here.
    end

    local spawn_pt = GetSpawnPoint(targetPlayer:GetPosition())
    if spawn_pt ~= nil then
		if _storedhassler ~= nil then
            hassler = SpawnSaveRecord(_storedhassler, {})
            _storedhassler = nil
        else
			hassler = SpawnPrefab("mothergoose")
			hassler.sg:GoToState("glide")
			hassler.components.timer:StartTimer("WantsToLayEgg", TUNING.SEG_TIME * math.random(4, 8))
        end

        if hassler ~= nil then
            hassler.Physics:Teleport(spawn_pt:Get())
            local target = GetClosestInstWithTag(STRUCTURE_TAGS, targetPlayer, 40)
            if target ~= nil then
                hassler.components.knownlocations:RememberLocation("targetbase", target:GetPosition())
            end
            -- Liz: home location is now chosen right before going there, to make sure that deerclops can walk there.
            return hassler
        end
    end
end

--------------------------------------------------------------------------
--[[ Private event handlers ]]
--------------------------------------------------------------------------

local function OnSeasonChange(self, season)
    TryStartAttacks()
end

local function OnPlayerJoined(src,player)
    for i, v in ipairs(_activeplayers) do
        if v == player then
            return
        end
    end
    table.insert(_activeplayers, player)

    TryStartAttacks()
end

local function OnPlayerLeft(src,player)
    for i, v in ipairs(_activeplayers) do
        if v == player then
            table.remove(_activeplayers, i)
            --
			-- if this was the activetarget...cease the attack
			if player == _targetplayer then
				TargetLost()
			end
            return
        end
    end
end

local function OnHasslerRemoved(src, hassler)
	_activehassler = nil
	TryStartAttacks()
end

local function OnStoreHassler(src, hassler)
	if hassler ~= nil then
		_storedhassler = hassler:GetSaveRecord()
	else
		_storedhassler = nil
	end
end

local function OnHasslerKilled(src, hassler)
	_activehassler = nil
	TryStartAttacks(true)
end

local function OnMotherGooseTimerDone(src, data)
    _warning = false
    if _targetplayer == nil then
        PickAttackTarget() -- In case a long update skipped the warning or something
    end
    if _targetplayer ~= nil then
        _activehassler = ReleaseHassler(_targetplayer)
        ResetAttacks()
    else
        TargetLost()
    end
end

--------------------------------------------------------------------------
--[[ Public member functions ]]
--------------------------------------------------------------------------

function self:SetAttacksPerspring(attacks)
    --_attacksperspring = attacks
end

function self:OverrideAttacksPerSeason(name, num)
	if name == "MOOSE" then
		--_attacksperspring = num
	end
end

function self:OverrideAttackDuringOffSeason(name, bool)
	if name == "MOOSE" then
		--_attackduringoffseason = bool
	end
end

function self:OnPostInit()
    -- Shorten the time used for winter to account for the time deerclops spends stomping around
    -- Then add one to _attacksperseason to shift the attacks so the last attack isn't right when the season changes to spring
    _attackdelay = (TheWorld.state.springlength - 1) * TUNING.TOTAL_DAY_TIME / (_attacksperseason + 1) 
	_worldsettingstimer:AddTimer(MOTHERGOOSE_TIMERNAME, _attackdelay, true, OnMotherGooseTimerDone)

    if _timetoattack then
        _worldsettingstimer:StartTimer(MOTHERGOOSE_TIMERNAME, math.min(_timetoattack, _attackdelay))
    end
    TryStartAttacks()
end

local function _DoWarningSpeech(player)
    player.components.talker:Say(GetString(player, "ANNOUNCE_DEERCLOPS"))
end

function self:DoWarningSpeech(_targetplayer)
    for i, v in ipairs(_activeplayers) do 
        if v == _targetplayer or v:IsNear(_targetplayer, HASSLER_SPAWN_DIST * 2) then
            v:DoTaskInTime(math.random() * 2, _DoWarningSpeech)
        end
    end
end

function self:DoWarningSound(_targetplayer)
	local timetoattack = _worldsettingstimer:GetTimeLeft(MOTHERGOOSE_TIMERNAME)
	SpawnPrefab("moosewarning_lvl"..
		(((timetoattack == nil or timetoattack < 30) and "4") or (timetoattack < 60 and "3") or (timetoattack < 90 and "2") or "1")
	).Transform:SetPosition(_targetplayer.Transform:GetWorldPosition())
end

function self:OnUpdate(dt)
    local timetoattack = _worldsettingstimer:GetTimeLeft(MOTHERGOOSE_TIMERNAME)
    if _activehassler ~= nil or not timetoattack then
        ResetAttacks()
        return
    end
	
    if not _warning then
        if timetoattack > 0 and timetoattack < _warnduration then
			-- let's pick a random player here
			PickAttackTarget()
			if not _targetplayer then
				PauseAttacks()
				return
			end
			_warning = true
			_timetonextwarningsound = 0
        end
    else
        _timetonextwarningsound	= _timetonextwarningsound - dt

		if _timetonextwarningsound <= 0 then
	        if _targetplayer == nil then
	        	PickAttackTarget()
	        	if _targetplayer == nil then
                    TargetLost()
		            return
		        end
	        end
			_announcewarningsoundinterval = _announcewarningsoundinterval - 1
			if _announcewarningsoundinterval <= 0 then
				_announcewarningsoundinterval = 10 + math.random(5)
				self:DoWarningSpeech(_targetplayer)
			end

            _timetonextwarningsound = timetoattack < 30 and 10 + math.random(1) or 15 + math.random(4)
			self:DoWarningSound(_targetplayer)
		end
	end
end

function self:LongUpdate(dt)
	self:OnUpdate(dt)
end

--------------------------------------------------------------------------
--[[ Save/Load ]]
--------------------------------------------------------------------------

function self:OnSave()
	local data =
	{
		warning = _warning,
		storedhassler = _storedhassler,
		moonmawdelay = _moonmawdelay
	}

	local ents = {}
	if _activehassler ~= nil then
		data.activehassler = _activehassler.GUID
		table.insert(ents, _activehassler.GUID)
	end

	return data, ents
end

function self:OnLoad(data)
	_warning = data.warning or false
	_storedhassler = data.storedhassler
	
    if data.timetoattack then
        _timetoattack = data.timetoattack
    end
end

function self:LoadPostPass(newents, savedata)
	if savedata.activehassler ~= nil and newents[savedata.activehassler] ~= nil then
		_activehassler = newents[savedata.activehassler].entity
	end
end


--------------------------------------------------------------------------
--[[ Debug ]]
--------------------------------------------------------------------------

function self:GetDebugString()
	local s = ""
	if not _timetoattack then
	    s = s .. "DORMANT <no time>"
	elseif self.inst.updatecomponents[self] == nil then
		s = s .. "DORMANT ".._timetoattack
	elseif _timetoattack > 0 then
		s = s .. string.format("%s Mothergoose is coming for %s in %2.2f", _warning and "WARNING" or "WAITING", tostring(_targetplayer) or "<nil>", _timetoattack)
	else
		s = s .. string.format("ATTACKING!!!")
	end
	s = s .. string.format(" active: %s", _activehassler ~= nil and tostring(_activehassler) or "<nil>")
	s = s .. string.format(" stored: %s", _storedhassler ~= nil and _storedhassler.prefab or "<nil>")
	return s
end

function self:SummonMonster(player)
    if _worldsettingstimer:ActiveTimerExists(MOTHERGOOSE_TIMERNAME) then
        _worldsettingstimer:SetTimeLeft(MOTHERGOOSE_TIMERNAME, 10)
        _worldsettingstimer:ResumeTimer(MOTHERGOOSE_TIMERNAME)
    else
        _worldsettingstimer:StartTimer(MOTHERGOOSE_TIMERNAME, 10)
    end
	self.inst:StartUpdatingComponent(self)
end

local function SummonMonsterFullMoon(player)
	if _moonmawdelay == nil and TheWorld.state.cycles > 50 and TheWorld.state.issummer and TheWorld.state.isfullmoon and not TheWorld.state.isalterawake then
		if _worldsettingstimer:ActiveTimerExists(MOTHERGOOSE_TIMERNAME) then
			_worldsettingstimer:SetTimeLeft(MOTHERGOOSE_TIMERNAME, 10)
			_worldsettingstimer:ResumeTimer(MOTHERGOOSE_TIMERNAME)
		else
			_worldsettingstimer:StartTimer(MOTHERGOOSE_TIMERNAME, 10)
		end
		self.inst:StartUpdatingComponent(self)
	end
end

function self:GetWarning()
	return _warning
end

--------------------------------------------------------------------------
--[[ Initialization ]]
--------------------------------------------------------------------------
for i, v in ipairs(AllPlayers) do
    table.insert(_activeplayers, v)
end

self.inst:ListenForEvent("ms_playerjoined", OnPlayerJoined, TheWorld)
self.inst:ListenForEvent("ms_playerleft", OnPlayerLeft, TheWorld)
self:WatchWorldState("season", OnSeasonChange)
self.inst:ListenForEvent("mothergooseremoved", OnHasslerRemoved, TheWorld)
self.inst:ListenForEvent("mothergoosekilled", OnHasslerKilled, TheWorld)

end)
