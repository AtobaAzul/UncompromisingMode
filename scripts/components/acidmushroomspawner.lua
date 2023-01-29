local MAX_TARGETS = 2

STRINGS.CHARACTERS.GENERIC.ANNOUNCE_TOADSTOOLED = {"That toads hopping mad!", "Something is growing beneath me!", "Mushrooms incoming!", }

local UUID = 0
local function UUIDGenerator()
    UUID = UUID + 1
    return UUID - 1
end

local AcidMushroomSpawner = Class(function(self, inst)
    self.inst = inst
    self.targets = {}
    self.uuid = UUIDGenerator()
end)

function AcidMushroomSpawner:StartAcidMushrooms()
    local function _onplayervaliditytestfinished(src, players)
        self.inst:RemoveEventCallback("master_acidmushrooms_playervaliditytestfinished", _onplayervaliditytestfinished, TheWorld)
        local weighted_players = {}
        local num_players = 0
        for i, v in ipairs(TheNet:GetClientTable()) do
            if #v.prefab > 0 and players[smallhash(v.userid)] then
                weighted_players[v] = math.sqrt(v.playerage or 1)
                num_players = num_players + 1
            end
        end

        if num_players > 0 then
            local target_players = { weighted_random_choice(weighted_players) }
            if num_players > 3 then
                weighted_players[target_players[1]] = nil
                table.insert(target_players, weighted_random_choice(weighted_players))
            end

            local year_length = TUNING.AUTUMN_LENGTH + TUNING.WINTER_LENGTH + TUNING.SPRING_LENGTH + TUNING.SUMMER_LENGTH
            local base_num_attacks = TheWorld.state.remainingdaysinseason <= 2 and 1 or 0
            for i, v in pairs(target_players) do
                local sharddata = players[smallhash(v.userid)]
                local targetinfo = {
                    client = v,
                    userhash = smallhash(v.userid),
                    component = sharddata.componenthandler,
                    player = sharddata.player
                }
                if #self.targets >= MAX_TARGETS then
                    table.remove(self.targets, 1)
                end
                table.insert(self.targets, targetinfo)
            end

            self:PushRemoteTargets()

            if #self.targets > 0 then
                self.inst:PushEvent("onacidmushroomssstarted")
            end
        end
    end
    self.inst:ListenForEvent("master_acidmushrooms_playervaliditytestfinished", _onplayervaliditytestfinished, TheWorld)
    TheWorld:PushEvent("master_acidmushrooms_testplayervalidity")
end

function AcidMushroomSpawner:StopAcidMushrooms()
    while #self.targets > 0 do
        table.remove(self.targets)
    end

	self.inst:PushEvent("onacidmushroomsfinished")
    self:PushRemoteTargets()
end

function AcidMushroomSpawner:PushRemoteTargets()
    local data = {}
    for i, v in ipairs(self.targets) do
        table.insert(data, {userhash = v.userhash})
    end
    TheWorld:PushEvent("master_acidmushroomsupdate", {uuid = self.uuid, targets = data})
    if #self.targets > 0 and self._acidmushroomsfinished == nil then
        function self._acidmushroomsfinished(src, data)
            if data.uuid ~= self.uuid then return end
            for i, v in ipairs(self.targets) do
                if v.userhash == data.userhash then
                    table.remove(self.targets, i)
                    break
                end
            end
            if #self.targets <= 0 then
                self.inst:RemoveEventCallback("master_acidmushroomsfinished", self._acidmushroomsfinished, TheWorld)
                self._acidmushroomsfinished = nil
                self.inst:PushEvent("onacidmushroomsfinished")
            end
        end
        self.inst:ListenForEvent("master_acidmushroomsfinished", self._acidmushroomsfinished, TheWorld)
    end
end

function AcidMushroomSpawner:GetDebugString()
    local s = string.format(" Shard ID %s UUID %s", TheShard:GetShardId(), tostring(self.uuid))
    for i, v in ipairs(self.targets) do
        s = (s ~= nil and (s.."\n") or "")..string.format(" Component %s is targeting %s", v.component, tostring(v.player))
    end
    return s
end

return AcidMushroomSpawner
