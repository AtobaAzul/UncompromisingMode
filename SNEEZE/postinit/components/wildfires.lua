local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddComponentPostInit("wildfires", function(self)

local function LightFireForPlayer(player, rescheduleFn)
    _scheduledtasks[player] = nil
    if math.random() <= _chance then
	print("hoogus")
        local x, y, z = player.Transform:GetWorldPosition()
        local firestarters = TheSim:FindEntities(x, y, z, _radius, nil, _excludetags)
        if #firestarters > 0 then
            local highprio = {}
            local lowprio = {}
            for i, v in ipairs(firestarters) do
                if v.components.burnable ~= nil then
                    table.insert(v:HasTag("wildfirepriority") and highprio or lowprio, v)
                end
            end
            firestarters = #highprio > 0 and highprio or lowprio
            while #firestarters > 0 do
                local i = math.random(#firestarters)
                if CheckValidWildfireStarter(firestarters[i]) then
                    firestarters[i].components.burnable:StartWildfire()
                    break
                else
                    table.remove(firestarters, i)
                end
            end
        end
    end

    rescheduleFn(player)
end

local function ScheduleSpawn(player)
    if _scheduledtasks[player] == nil then
        _scheduledtasks[player] = player:DoTaskInTime(TUNING.WILDFIRE_RETRY_TIME, LightFireForPlayer, ScheduleSpawn)
    end
end

local function ForceWildfireForPlayer(inst, player)
    if ShouldActivateWildfires() then
        CancelSpawn(player)
        LightFireForPlayer(player, ScheduleSpawn)
    end
end

end)