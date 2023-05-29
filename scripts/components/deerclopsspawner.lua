--------------------------------------------------------------------------
--[[ Dependencies ]]
--------------------------------------------------------------------------
local easing = require("easing")

--------------------------------------------------------------------------
--[[ Deerclopsspawner class definition ]]
--------------------------------------------------------------------------
return Class(function(self, inst)

    assert(TheWorld.ismastersim, "Deerclopsspawner should not exist on client")

    --------------------------------------------------------------------------
    --[[ Private constants ]]
    --------------------------------------------------------------------------

    local STRUCTURE_DIST = 20
    local HASSLER_SPAWN_DIST = 40
    local HASSLER_KILLED_DELAY_MULT = 6
    local STRUCTURES_PER_SPAWN = 4
    local DEERCLOPS_TIMERNAME = "deerclops_timetoattack"

    --------------------------------------------------------------------------
    --[[ Public Member Variables ]]
    --------------------------------------------------------------------------

    self.inst = inst

    --------------------------------------------------------------------------
    --[[ Private Member Variables ]]
    --------------------------------------------------------------------------
    local _warning = false
    local _warnduration = 60
    local _timetonextwarningsound = 0
    local _announcewarningsoundinterval = 4

    local _worldsettingstimer = TheWorld.components.worldsettingstimer

    local _attackdelay = nil
    local _attacksperseason = TUNING.DEERCLOPS_ATTACKS_PER_SEASON
    local _attackoffseason = TUNING.DEERCLOPS_ATTACKS_OFF_SEASON
    local _targetplayer = nil
    local _activehassler = nil
    local _storedhassler = nil

    local _timetoattack

    local _activeplayers = {}

    --------------------------------------------------------------------------
    --[[ Private member functions ]]
    --------------------------------------------------------------------------

    local function AllowedToAttack(data)
        return #_activeplayers > 0 and
            ((data and data.skipcycles) or TheWorld.state.cycles > TUNING.NO_BOSS_TIME) and
            (_attackoffseason or
                TheWorld.state.season == "winter")
    end

    local function IsEligible(player)
        local area = player.components.areaaware
        return TheWorld.Map:IsVisualGroundAtPoint(player.Transform:GetWorldPosition())
            and area:GetCurrentArea() ~= nil
            and not area:CurrentlyInTag("nohasslers")
    end

    local ATTACK_MUST_TAGS = { "structure" }
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
        while (numStructures < STRUCTURES_PER_SPAWN) and (loopCount < (#playerlist + 3)) do
            player = playerlist[1 + (loopCount % #playerlist)]

            local x, y, z = player.Transform:GetWorldPosition()
            local ents = TheSim:FindEntities(x, y, z, STRUCTURE_DIST, ATTACK_MUST_TAGS)

            numStructures = #ents
            loopCount = loopCount + 1
        end
		
        _targetplayer = player
    end

    local function PauseAttacks()
        _targetplayer = nil
        _warning = false
        self.inst:StopUpdatingComponent(self)
        _worldsettingstimer:PauseTimer(DEERCLOPS_TIMERNAME, true)
    end

    local function ResetAttacks()
        _worldsettingstimer:StopTimer(DEERCLOPS_TIMERNAME)
        PauseAttacks()
    end

    local function TryStartAttacks(killed)
        if AllowedToAttack() then
            if _activehassler == nil and _attacksperseason > 0 and
                _worldsettingstimer:GetTimeLeft(DEERCLOPS_TIMERNAME) == nil then
                local attackdelay = killed == true and _attackdelay * HASSLER_KILLED_DELAY_MULT or _attackdelay
                _worldsettingstimer:StartTimer(DEERCLOPS_TIMERNAME, attackdelay)
            end

            _worldsettingstimer:ResumeTimer(DEERCLOPS_TIMERNAME)
            self.inst:StartUpdatingComponent(self)
            self:StopWatchingWorldState("cycles", TryStartAttacks)
            self.inst.watchingcycles = nil
        else
            PauseAttacks()
            if not self.inst.watchingcycles then
                self:WatchWorldState("cycles", TryStartAttacks) -- keep checking every day until NO_BOSS_TIME is up
                self.inst.watchingcycles = true
            end
        end
    end

    local function TargetLost()
        local timetoattack = _worldsettingstimer:GetTimeLeft(DEERCLOPS_TIMERNAME)
        if timetoattack == nil then
            _warning = false
            _worldsettingstimer:StartTimer(DEERCLOPS_TIMERNAME, _warnduration + 1)
        elseif (timetoattack < _warnduration and _warning) then
            _warning = false
            _worldsettingstimer:SetTimeLeft(DEERCLOPS_TIMERNAME, _warnduration + 1)
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
        local offset = FindWalkableOffset(pt, math.random() * 2 * PI, HASSLER_SPAWN_DIST, 12, true)
        if offset ~= nil then
            offset.x = offset.x + pt.x
            offset.z = offset.z + pt.z
            return offset
        end
    end

    local STRUCTURE_TAGS = { "structure" }
    local function ReleaseHassler(targetPlayer)
        assert(targetPlayer)

        local hassler = TheSim:FindFirstEntityWithTag("deerclops")
        if hassler ~= nil then
            return hassler -- There's already a hassler in the world, we're done here.
        end

        local spawn_pt = GetSpawnPoint(targetPlayer:GetPosition())
        if spawn_pt ~= nil then
            if _storedhassler ~= nil then
                hassler = SpawnSaveRecord(_storedhassler, {})
                _storedhassler = nil
            else
                hassler = nil --SpawnPrefab("deerclops") No...
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

    local function OnPlayerJoined(src, player)
        for i, v in ipairs(_activeplayers) do
            if v == player then
                return
            end
        end
        table.insert(_activeplayers, player)

        TryStartAttacks()
    end

    local function OnPlayerLeft(src, player)
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

    local function OnDeerclopsTimerDone(src, data)
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

    local function OnMegaFlare(src, data)
        if data.sourcept and TheWorld.Map:IsVisualGroundAtPoint(data.sourcept.x, data.sourcept.y, data.sourcept.z) then
            if not _activehassler and math.random() < 0.6 and AllowedToAttack({ skipcycles = true }) then
                self.inst:DoTaskInTime(5 + (math.random() * 20), function()
                    local players = FindPlayersInRange(data.sourcept.x, data.sourcept.y, data.sourcept.z, 35)
                    if #players > 0 then
                        _targetplayer = players[1]
                        _activehassler = ReleaseHassler(players[1])
                        ResetAttacks()
                    end
                end)
            end
        end
    end

    --------------------------------------------------------------------------
    --[[ Public member functions ]]
    --------------------------------------------------------------------------

    function self:SetAttacksPerWinter(attacks)
        --depreciated
    end

    function self:OverrideAttacksPerSeason(name, num)
        --depreciated
    end

    function self:OverrideAttackDuringOffSeason(name, bool)
        --depreciated
    end

    function self:OnPostInit()
        -- Shorten the time used for winter to account for the time deerclops spends stomping around
        -- Then add one to _attacksperseason to shift the attacks so the last attack isn't right when the season changes to spring
        _attackdelay = (TheWorld.state.winterlength - 1) * TUNING.TOTAL_DAY_TIME / (_attacksperseason + 1)
        _worldsettingstimer:AddTimer(DEERCLOPS_TIMERNAME, _attackdelay, TUNING.SPAWN_DEERCLOPS, OnDeerclopsTimerDone)

        if _timetoattack then
            _worldsettingstimer:StartTimer(DEERCLOPS_TIMERNAME, math.min(_timetoattack, _attackdelay))
        end
        TryStartAttacks()
    end

    function self:DoWarningSpeech(_targetplayer)
        --No.
    end

    function self:DoWarningSound(_targetplayer)
        --No.
    end

    function self:OnUpdate(dt)
        local timetoattack = _worldsettingstimer:GetTimeLeft(DEERCLOPS_TIMERNAME)
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
            _timetonextwarningsound = _timetonextwarningsound - dt

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

        --retrofit old timer to new system
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
        return TheWorld.components.uncompromising_deerclopsspawner:GetDebugString()
    end

    function self:SummonMonster(player)
        if _worldsettingstimer:ActiveTimerExists(DEERCLOPS_TIMERNAME) then
            _worldsettingstimer:SetTimeLeft(DEERCLOPS_TIMERNAME, 10)
            _worldsettingstimer:ResumeTimer(DEERCLOPS_TIMERNAME)
        else
            _worldsettingstimer:StartTimer(DEERCLOPS_TIMERNAME, 10)
        end
        self.inst:StartUpdatingComponent(self)
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
    self.inst:ListenForEvent("hasslerremoved", OnHasslerRemoved, TheWorld)
    self.inst:ListenForEvent("hasslerkilled", OnHasslerKilled, TheWorld)
    self.inst:ListenForEvent("storehassler", OnStoreHassler, TheWorld)

    self.inst:ListenForEvent("megaflare_detonated", OnMegaFlare, TheWorld)

end)
