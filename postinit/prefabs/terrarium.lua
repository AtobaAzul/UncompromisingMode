local env = env
GLOBAL.setfenv(1, GLOBAL)

local UpvalueHacker = require("tools/upvaluehacker")

env.AddPrefabPostInit("terrarium", function(inst)

	if not TheWorld.ismastersim then
        return
    end

    inst:AddTag("terrarium")

    local _SpawnEyeOfTerror = UpvalueHacker.GetUpvalue(Prefabs.terrarium.fn, "TimerDone", "SpawnEyeOfTerror")
    local is_crimson = UpvalueHacker.GetUpvalue(_SpawnEyeOfTerror, "is_crimson")
    local SPAWN_OFFSET = UpvalueHacker.GetUpvalue(_SpawnEyeOfTerror, "SPAWN_OFFSET")
    local spawn_eye_prefab = UpvalueHacker.GetUpvalue(_SpawnEyeOfTerror, "spawn_eye_prefab")
    local hookup_eye_listeners = UpvalueHacker.GetUpvalue(_SpawnEyeOfTerror, "hookup_eye_listeners")

    local function SpawnEyeOfTerror(inst)
        if AllPlayers ~= nil and #AllPlayers > 0 then
            local targeted_player = inst:GetNearestPlayer()

            if not targeted_player then
                return _SpawnEyeOfTerror(inst)
            end

            local announce_template = (is_crimson(inst) and STRINGS.TWINS_TARGET) or STRINGS.EYEOFTERROR_TARGET
            TheNet:Announce(subfmt(announce_template, {player_name = targeted_player.name}))

            local angle = math.random() * 6.28318
            local player_pt = targeted_player:GetPosition()
            local spawn_offset = FindWalkableOffset(player_pt, angle, SPAWN_OFFSET, nil, false, true, nil, true, true)
                or Vector3(SPAWN_OFFSET * math.cos(angle), 0, SPAWN_OFFSET * math.sin(angle))
            local spawn_position = player_pt + spawn_offset

            if inst.eyeofterror ~= nil and inst.eyeofterror:IsInLimbo() then
                inst.eyeofterror:ReturnToScene()
                -- Needs to be done so the spawn fx spawn in the right place
                inst.eyeofterror.Transform:SetPosition(spawn_position:Get())
                if inst.eyeofterror.sg ~= nil then
                    inst.eyeofterror.sg:GoToState("flyback", targeted_player)
                else
                    inst.eyeofterror:PushEvent("flyback", targeted_player)
                end
            else
                inst.eyeofterror = spawn_eye_prefab(inst)
                -- Needs to be done so the spawn fx spawn in the right place
                inst.eyeofterror.Transform:SetPosition(spawn_position:Get())
                if inst.eyeofterror.sg ~= nil then
                    inst.eyeofterror.sg:GoToState("arrive", targeted_player)
                else
                    inst.eyeofterror:PushEvent("arrive", targeted_player)
                end
            end
            inst.eyeofterror:PushEvent("set_spawn_target", targeted_player)

            hookup_eye_listeners(inst, inst.eyeofterror)
        end
    end

    UpvalueHacker.SetUpvalue(Prefabs.terrarium.fn, SpawnEyeOfTerror, "TimerDone", "SpawnEyeOfTerror")
end)
