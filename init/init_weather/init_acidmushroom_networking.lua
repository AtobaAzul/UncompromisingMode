local USSR = GLOBAL.USSR

USSR.AddShardRPCHandler("UncompromisingSurvival", "AcidMushroomsUpdate", function(shard_id, data)
    GLOBAL.TheWorld:PushEvent("acidmushroomsdirty", {shard_id = shard_id, uuid = data.uuid, targets = data.targets})
end)

USSR.AddShardRPCHandler("UncompromisingSurvival", "TestAcidMushroomPlayerValidity", function(shard_id)
    GLOBAL.TheWorld:PushEvent("slave_acidmushrooms_testplayervalidity", shard_id)
end)

USSR.AddShardRPCHandler("UncompromisingSurvival", "ReportAcidMushroomPlayerValidity", function(shard_id, data)
    GLOBAL.TheWorld:PushEvent("master_acidmushrooms_reportplayervalidity", {shard_id = GLOBAL.tonumber(shard_id), players = data})
end)

USSR.AddShardRPCHandler("UncompromisingSurvival", "AcidMushroomsTargetFinished", function(shard_id, data)
    GLOBAL.TheWorld:PushEvent("master_acidmushroomsfinished", data)
end)