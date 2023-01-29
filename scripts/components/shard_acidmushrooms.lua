--------------------------------------------------------------------------
--[[ Shard_AcidMushrooms ]]
--------------------------------------------------------------------------

return Class(function(self, inst)

assert(TheWorld.ismastersim, "Shard_AcidMushrooms should not exist on client")

--------------------------------------------------------------------------
--[[ Constants ]]
--------------------------------------------------------------------------

local MAX_TARGETS = 2

--------------------------------------------------------------------------
--[[ Member variables ]]
--------------------------------------------------------------------------

--Public
self.inst = inst

--Private
local _world = TheWorld

local _targets = {}

local _playervaliditylist = {}
local _players = {}

--------------------------------------------------------------------------
--[[ Private event listeners ]]
--------------------------------------------------------------------------

local function AllShardsPlayerValidity()
    for k, v in pairs(USSR.SHARD_LIST) do
        if not _playervaliditylist[k] then
            return false
        end
    end
    return true
end

local function OnAcidMushroomsUpdate(src, data)
    local targets = {}
    _targets[data.uuid] = _targets[data.uuid] or {}
    for k, v in pairs(_targets[data.uuid]) do
        _targets[data.uuid][k] = not v or nil
    end
    for i, v in ipairs(data.targets) do
        _targets[data.uuid][v.userhash] = false
    end

    USSR.SendShardRPC(USSR.SHARD_RPC.UncompromisingSurvival.AcidMushroomsUpdate, nil, {uuid = data.uuid, targets = _targets[data.uuid]})
    TheWorld:PushEvent("acidmushroomsdirty", {shard_id = TheShard:GetShardId(), uuid = data.uuid, targets = _targets[data.uuid]})
end

local function OnAcidMushroomsDirty(src, data)
    local targets = {}
    local players = {}
    for i, v in ipairs(AllPlayers) do
        players[smallhash(v.userid)] = true
    end
    for k, v in pairs(data.targets) do
        if players[k] then
            targets[k] = v
        end
    end
    _world:PushEvent("slave_acidmushroomsupdate", {shard_id = data.shard_id, uuid = data.uuid, targets = targets})
end

local function OnReportPlayerValidity(src, data)
    _playervaliditylist[data.shard_id] = true
    for k, v in pairs(data.players) do
        _players[k] = v
    end
    if AllShardsPlayerValidity() then
        _world:PushEvent("master_acidmushrooms_playervaliditytestfinished", _players)
    end
end

local function TestAllPlayersValidity()
    _playervaliditylist = {}
    _players = {}
    USSR.SendShardRPC(USSR.SHARD_RPC.UncompromisingSurvival.TestAcidMushroomPlayerValidity, nil)
    _world:PushEvent("slave_acidmushrooms_testplayervalidity", TheShard:GetShardId())
end

local function TestPlayerValidity(src, shard_id)
    local players = {}
    for i, v in ipairs(AllPlayers) do
        if _world.components.acidmushrooms and _world.Map:IsVisualGroundAtPoint(v.Transform:GetWorldPosition()) then
            --todo, make some system that allows multiple different components to handle this spot.
            players[smallhash(v.userid)] = {componenthandler = "acidmushrooms", player = tostring(v)}
        end
    end
    if shard_id ~= TheShard:GetShardId() then
        USSR.SendShardRPC(USSR.SHARD_RPC.UncompromisingSurvival.ReportAcidMushroomPlayerValidity, shard_id, players)
    else
        _world:PushEvent("master_acidmushrooms_reportplayervalidity", {shard_id = tonumber(shard_id), players = players})
    end
end

--------------------------------------------------------------------------
--[[ Initialization ]]
--------------------------------------------------------------------------

--Zarklord: keeping the master/slave naming system despite not actually using _ismastershard checks,
--since any server can "be the master thats sending the update" and any server can "be the slave thats receiving the update"
--Register master shard events
inst:ListenForEvent("master_acidmushroomsupdate", OnAcidMushroomsUpdate, _world)
--Register network variable sync events
inst:ListenForEvent("acidmushroomsdirty", OnAcidMushroomsDirty, _world)
--used for reporting what players are valid targets on the sending shard.
inst:ListenForEvent("master_acidmushrooms_reportplayervalidity", OnReportPlayerValidity, _world)
--used for asking what players are valid targets on the current shard.
inst:ListenForEvent("master_acidmushrooms_testplayervalidity", TestAllPlayersValidity, _world)
--used for determining what players are valid targets on the current shard.
inst:ListenForEvent("slave_acidmushrooms_testplayervalidity", TestPlayerValidity, _world)

--------------------------------------------------------------------------
--[[ End ]]
--------------------------------------------------------------------------

end)