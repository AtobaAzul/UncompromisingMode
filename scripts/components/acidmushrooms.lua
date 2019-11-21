--------------------------------------------------------------------------
--[[ AcidMushrooms class definition ]]
--------------------------------------------------------------------------

return Class(function(self, inst)

assert(TheWorld.ismastersim, "AcidMushrooms should not exist on client")

--------------------------------------------------------------------------
--[[ Member variables ]]
--------------------------------------------------------------------------

--Public
self.inst = inst

--Private
local _ismastershard = TheWorld.ismastershard

local _targets = {}

--------------------------------------------------------------------------
--[[ Private member functions ]]
--------------------------------------------------------------------------

local function GetPlayerFromUserHash(c)
    for _, v in ipairs(AllPlayers) do
        if smallhash(v.userid) == c then
            return v
        end
    end
end

function SpawnAcidMushrooms(spawnpt)
    local x = GetRandomWithVariance(spawnpt.x, TUNING.DSTU.TOADSTOOL_ACIDMUSHROOM.RADIUS)
    local z = GetRandomWithVariance(spawnpt.z, TUNING.DSTU.TOADSTOOL_ACIDMUSHROOM.RADIUS)

    local function IsValidAcidMushroomPosition(offset)
        local x1, z1 = x + offset.x, z + offset.z
        if #TheSim:FindEntities(x1, 0, z1, TUNING.DSTU.TOADSTOOL_ACIDMUSHROOM.RADIUS * 1.9, { "antlion_sinkhole_blocker" --[[TODO?]]}) > 0 then
            return false
        end
        for dx = -1, 1 do
            for dz = -1, 1 do
                if not TheWorld.Map:IsPassableAtPoint(x1 + dx * TUNING.DSTU.TOADSTOOL_ACIDMUSHROOM.RADIUS, 0, z1 + dz * TUNING.DSTU.TOADSTOOL_ACIDMUSHROOM.RADIUS) then
                    return false
                end
            end
        end
        return true
    end

    local offset = IsValidAcidMushroomPosition(offset) and offset or
    FindValidPositionByFan(math.random() * 2 * PI, TUNING.DSTU.TOADSTOOL_ACIDMUSHROOM.RADIUS * 1.8 + math.random(), 9, IsValidAcidMushroomPosition) or
    FindValidPositionByFan(math.random() * 2 * PI, TUNING.DSTU.TOADSTOOL_ACIDMUSHROOM.RADIUS * 2.9 + math.random(), 17, IsValidAcidMushroomPosition) or
    FindValidPositionByFan(math.random() * 2 * PI, TUNING.DSTU.TOADSTOOL_ACIDMUSHROOM.RADIUS * 3.9 + math.random(), 17, IsValidAcidMushroomPosition) or
    nil

    if offset ~= nil then
        SpawnAt("mushroomsprout_overworld", spawnpt, nil, offset)
    end
end

local WARNING_RADIUS = 3.5
local function DoTargetWarning(targetinfo)
    if targetinfo.warnings == nil then
        targetinfo.warnings = TUNING.DSTU.TOADSTOOL_ACIDMUSHROOM.NUM_WARNINGS
        targetinfo.next_warning = math.random() * TUNING.DSTU.TOADSTOOL_ACIDMUSHROOM.WARNING_DELAY_VARIANCE
    elseif targetinfo.warnings >= 0 then
        --Handle locally
        ShakeAllCameras(CAMERASHAKE.SIDE, TUNING.DSTU.TOADSTOOL_ACIDMUSHROOM.WARNING_DELAY, .04, .05, targetinfo.pos, 6)

        --TODO?
        for i = 1, math.ceil((TUNING.DSTU.TOADSTOOL_ACIDMUSHROOM.NUM_WARNINGS - (targetinfo.warnings or 0) + 1) / 3.2) do
            local fxpt = targetinfo.pos + Vector3((math.random() * (WARNING_RADIUS*2)) - WARNING_RADIUS, 0, (math.random() * (WARNING_RADIUS*2)) - WARNING_RADIUS)
            local rocks = SpawnPrefab("sinkhole_warn_fx_"..math.random(3)).Transform:SetPosition(fxpt:Get())
        end

        if TheWorld.state.isautumn and ((targetinfo.warnings or 0) % 4 == 0) and targetinfo.player ~= nil and targetinfo.player:IsValid() then
            targetinfo.player.components.talker:Say(GetString(targetinfo.player, "ANNOUNCE_TOADSTOOLED"))
        end

        targetinfo.warnings = targetinfo.warnings - 1

        if targetinfo.warnings <= 0 or targetinfo.client == nil then
            targetinfo.warnings = nil
            targetinfo.next_warning = nil
            targetinfo.next_attack = TUNING.DSTU.TOADSTOOL_ACIDMUSHROOM.WARNING_DELAY + math.random() * TUNING.DSTU.TOADSTOOL_ACIDMUSHROOM.WARNING_DELAY_VARIANCE
        else
            targetinfo.next_warning = TUNING.DSTU.TOADSTOOL_ACIDMUSHROOM.WARNING_DELAY + math.random() * TUNING.DSTU.TOADSTOOL_ACIDMUSHROOM.WARNING_DELAY_VARIANCE
        end
    end
end

local function DoTargetAttack(targetinfo)
    --Handle locally
    targetinfo.attacks = targetinfo.attacks - 1
    targetinfo.next_attack = targetinfo.attacks > 0 and TUNING.DSTU.TOADSTOOL_ACIDMUSHROOM.WAVE_ATTACK_DELAY + math.random() * TUNING.DSTU.TOADSTOOL_ACIDMUSHROOM.WAVE_ATTACK_DELAY_VARIANCE or nil

    for shard_id, uuids in pairs(_targets) do
        for uuid, targets in pairs(uuids) do
            for k, v in pairs(targets) do
                if v ~= targetinfo and v.pos ~= nil and v.pos:DistSq(targetinfo.pos) < TUNING.DSTU.TOADSTOOL_ACIDMUSHROOM.WAVE_MERGE_ATTACKS_DIST_SQ then
                    --Skip attack
                    return
                end
            end
        end
    end
    SpawnAcidMushrooms(targetinfo.pos)
end

--------------------------------------------------------------------------
--[[ Private event handlers ]]
--------------------------------------------------------------------------

local function OnAcidmushroomsUpdate(inst, data)
    if not _targets[data.shard_id] then
        _targets[data.shard_id] = {}
    end

    if not _targets[data.shard_id][data.uuid] then
        _targets[data.shard_id][data.uuid] = {}
    end
    local targets = _targets[data.shard_id][data.uuid]

    local year_length = TUNING.AUTUMN_LENGTH + TUNING.WINTER_LENGTH + TUNING.SPRING_LENGTH + TUNING.SUMMER_LENGTH
    local base_num_attacks = TheWorld.state.remainingdaysinseason <= 2 and 1 or 0
    for k, v in pairs(data.targets) do
        if v then
            targets[k] = nil
        else
            local player = GetPlayerFromUserHash(k)
            local c = TheNet:GetClientTableForUser(player.userid)
            local num_attacks = math.min(base_num_attacks + math.floor((((c.playerage or 1) - 1) / year_length)) * 2 + TUNING.DSTU.TOADSTOOL_ACIDMUSHROOM.WAVE_MIN_ATTACKS, TUNING.DSTU.TOADSTOOL_ACIDMUSHROOM.WAVE_MAX_ATTACKS)
            if num_attacks > 0 then
                local targetinfo = {
                    client = c,
                    userhash = k,
                    attacks = num_attacks,
                    player = player,
                    pos = player:GetPosition(),
                }
                if targetinfo.client ~= nil then
                    targets[k] = targetinfo
                    DoTargetWarning(targetinfo)
                end
            end
        end
    end
    for shard_id, uuids in pairs(_targets) do
        for uuid, v in pairs(uuids) do
            if next(v) ~= nil then
                inst:StartUpdatingComponent(self)
                return
            end
        end
    end
    _targets = {}
    inst:StopUpdatingComponent(self)
end

--------------------------------------------------------------------------
--[[ Initialization ]]
--------------------------------------------------------------------------

--Register events
inst:ListenForEvent("slave_acidmushroomsupdate", OnAcidmushroomsUpdate, _world)

--------------------------------------------------------------------------
--[[ Update ]]
--------------------------------------------------------------------------

function self:OnUpdate(dt)
    local towarn = {}
    local toattack = {}
    for shard_id, uuids in pairs(_targets) do
        for uuid, targets in pairs(uuids) do
            for k, v in pairs(targets) do
                if v.client ~= nil then
                    if v.player ~= nil and v.player:IsValid() then
                        if TheWorld.Map:IsVisualGroundAtPoint(v.player.Transform:GetWorldPosition()) then
                            v.pos.x, v.pos.y, v.pos.z = v.player.Transform:GetWorldPosition()
                        end
                    else
                        v.client = nil
                        v.player = nil
                    end
                end
                if v.next_warning ~= nil then
                    v.next_warning = v.next_warning - dt
                    if v.next_warning <= 0 then
                        table.insert(towarn, v)
                    end
                elseif v.next_attack ~= nil then
                    v.next_attack = v.next_attack - dt
                    if v.next_attack <= 0 then
                        table.insert(toattack, 1, {{shard_id = shard_id, uuid = uuid}, v})
                    end
                end
            end
        end
    end

    for i, v in ipairs(towarn) do
        DoTargetWarning(v)
    end

    for i, v in ipairs(toattack) do
        DoTargetAttack(v[2])
        if v[2].attacks <= 0 then
            if v[1].shard_id == 0 then
                _targets[v[1].shard_id][v[1].uuid][v[2].userhash] = nil
            elseif v[1].shard_id ~= TheShard:GetShardId() then
                USSR.SendShardRPC(USSR.SHARD_RPC.UncompromisingSurvival.AcidMushroomsTargetFinished, v[1].shard_id, {uuid = v[1].uuid, userhash = v[2].userhash})
            else
                _world:PushEvent("master_acidmushrooms_reportplayervalidity", {uuid = v[1].uuid, userhash = v[2].userhash})
            end
        end
    end
end

--------------------------------------------------------------------------
--[[ Save/Load ]]
--------------------------------------------------------------------------

function self:OnSave()
    local data = {}
    for shard_id, uuids in pairs(_targets) do
        for uuid, targets in pairs(uuids) do
            for k, v in pairs(targets) do
                table.insert(data, {
                    shard_id = 0,
                    uuid = uuid,
                    userhash = k,
                    x = v.pos.x,
                    z = v.pos.z,
                    attacks = v.attacks,
                    next_attack = v.next_attack ~= nil and math.floor(v.next_attack) or nil,
                    next_warning = v.next_warning ~= nil and math.floor(v.next_warning) or nil,                    
                })
            end
        end
    end
    return #data > 0 and { targets = data } or nil
end

function self:OnLoad(data)
    if data.targets ~= nil then
        local targetcount = 0
        for i, v in ipairs(data.targets) do
            if (v.attacks or 0) > 0 and v.x ~= nil and v.z ~= nil then
                local targetinfo =
                {
                    pos = Vector3(v.x, 0, v.z),
                    attacks = v.attacks,
                    next_attack = v.next_attack,
                    warnings = 0,
                    next_warning = v.next_warning,
                }
                _targets[v.shard_id] = _targets[v.shard_id] or {}
                _targets[v.shard_id][v.uuid] = _targets[v.shard_id][v.uuid] or {}
                _targets[v.shard_id][v.uuid][v.userhash] = targetinfo
                targetcount = targetcount + 1
            end

            if targetcount > 0 then
                inst:StartUpdatingComponent(self)
            end
        end
    end
end

--------------------------------------------------------------------------
--[[ Debug ]]
--------------------------------------------------------------------------

function self:GetDebugString()
    local s
    for shard_id, uuids in pairs(_targets) do
        for uuid, targets in pairs(uuids) do
            for k, v in pairs(targets) do
                if v.next_warning ~= nil then
                    s = (s ~= nil and (s.."\n") or "")..string.format("  Warning %s (%d/%d) at (%.1f, %.1f) in %.2fs", tostring(v.player), TUNING.DSTU.TOADSTOOL_ACIDMUSHROOM.NUM_WARNINGS - v.warnings, TUNING.DSTU.TOADSTOOL_ACIDMUSHROOM.NUM_WARNINGS, v.pos ~= nil and v.pos.x or 0, v.pos ~= nil and v.pos.z or 0, v.next_warning)
                elseif v.next_attack ~= nil then
                    s = (s ~= nil and (s.."\n") or "")..string.format("  Attacking %s (%d/%d) at (%.1f, %.1f) in %.2fs", tostring(v.player), TUNING.DSTU.TOADSTOOL_ACIDMUSHROOM.WAVE_MAX_ATTACKS - v.attacks, TUNING.DSTU.TOADSTOOL_ACIDMUSHROOM.WAVE_MAX_ATTACKS, v.pos ~= nil and v.pos.x or 0, v.pos ~= nil and v.pos.z or 0, v.next_attack)
                end
            end
        end
    end
    return s
end

--------------------------------------------------------------------------
--[[ End ]]
--------------------------------------------------------------------------

end)
