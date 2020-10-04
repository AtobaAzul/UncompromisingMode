local env = env
local getupvalue = GLOBAL.debug.getupvalue
GLOBAL.setfenv(1, GLOBAL)
local easing = require("easing")
local UpvalueHacker = require("tools/upvaluehacker") --Baby's first upvaluehack, thanks Zark! -Axe





env.AddClassPostConstruct("components/wildfires", function(self) 
	local function _Old(player, rescheduleFn) --TODO: Grab the original value from wildfires to prevent any issues with using another mod that modifies wildfires.
    _scheduledtasks[player] = nil

    if math.random() <= _chance and
        not (_world.components.sandstorms ~= nil and
            _world.components.sandstorms:IsInSandstorm(player)) then
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
	
	local function LightFireForPlayer(player, rescheduleFn)
	if player.components.areaaware ~= nil then
	if not player.components.areaaware:CurrentlyInTag("hoodedcanopy") then
		--_Old(player, rescheduleFn)
		else
	    rescheduleFn(player)
	end
	end
	UpvalueHacker.SetUpvalue(LightFireForPlayer, "ScheduleSpawn")
	UpvalueHacker.SetUpvalue(LightFireForPlayer, "ForceWildfireForPlayer")
end
end)