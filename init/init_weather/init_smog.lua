local env = env
GLOBAL.setfenv(1, GLOBAL)

local function DoSmog(inst)
    local smog = SpawnPrefab("smog")
    local x, y, z = inst.Transform:GetWorldPosition()

    smog.Transform:SetPosition(x + math.random(-160, 160) / 10, math.random(0, 4),
        z + math.random(-160, 160) / 10)
    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
        inst.smog_task = inst:DoTaskInTime(math.random(5, 15) / 10, DoSmog)
    end
end

env.AddPrefabPostInitAny(function(inst)
    if not TheWorld.ismastersim then return end
    inst:DoTaskInTime(0, function(inst) --maybe delaying this by a frame does soemthing.
        if (inst:HasTag("plant") or inst:HasTag("tree")) and inst.components.burnable ~= nil then
            local _OnIgnite = inst.components.burnable.onignite

            inst.components.burnable.onignite = function(inst, source, doer, ...)
                if TheWorld.state.issummer then
                    inst.smog_task = inst:DoTaskInTime(math.random(5, 15) / 10, DoSmog)
                end

                if _OnIgnite ~= nil then
                    _OnIgnite(inst, source, doer, ...)
                end
            end
        end
    end)
end)

-- Coughing:

local COUGH_FADE_TASK_RATE = 0.1

local function FadeCoughSound(inst, steps, volumeMult)
    inst.um_coughVolume = inst.um_coughVolume - ((inst.hurtsoundvolume or 1) * volumeMult) / steps
    inst.SoundEmitter:SetVolume("um_smog_cough", inst.um_coughVolume)

    if inst.um_coughVolume <= 0 then
        inst.SoundEmitter:KillSound("um_smog_cough")
        if inst.um_fadeCoughTask ~= nil then inst.um_fadeCoughTask:Cancel() end
    end
end

local function DoCoughSound(inst, fadeSteps, volumeMult)
    inst.SoundEmitter:KillSound("um_smog_cough")
    if inst.um_fadeCoughTask ~= nil then inst.um_fadeCoughTask:Cancel() end

    if inst.hurtsoundoverride ~= nil then
        inst.SoundEmitter:PlaySound(inst.hurtsoundoverride, "um_smog_cough", inst.hurtsoundvolume)
    elseif not inst:HasTag("mime") then
        inst.SoundEmitter:PlaySound(
            (inst.talker_path_override or "dontstarve/characters/") .. (inst.soundsname or inst.prefab) .. "/hurt",
            "um_smog_cough",
            inst.hurtsoundvolume)
    end

    inst.um_coughVolume = (inst.hurtsoundvolume or 1) * volumeMult
    inst.um_fadeCoughTask = inst:DoPeriodicTask(COUGH_FADE_TASK_RATE,
        function() FadeCoughSound(inst, fadeSteps, volumeMult) end)
end

env.AddStategraphState("wilson", State {
    name = "um_smog_cough",
    tags = { "um_smog_cough" },

    onenter = function(inst, sayQuote)
        inst.sg.statemem.do_exit_cough = true
        inst.sg.mem.um_smog_cough = true
        inst.AnimState:PlayAnimation("sing_pre", false)
        inst.AnimState:PushAnimation("sing_fail", false)

        -- Hide fx_icon in this state so Wigfrid's cough is consistent with other characters.
        inst.AnimState:HideSymbol("fx_icon")

        local talker = inst.components.talker
        if talker ~= nil and sayQuote ~= nil then
            talker:Say(GetString(inst, "GAS_DAMAGE"))
            inst.SoundEmitter:KillSound("talk")
        end
    end,

    timeline =
    {
        TimeEvent(11 * FRAMES, function(inst)
            DoCoughSound(inst, 5, 0.7)
            inst.sg.statemem.do_exit_cough = false
        end),

        TimeEvent(24 * FRAMES, function(inst)
            DoCoughSound(inst, 10, 0.8)
            inst.sg.mem.um_smog_cough = nil
            inst.sg.mem.queuetalk_timeout = nil
        end),
    },

    events =
    {
        EventHandler("animover", function(inst)
            if inst.AnimState:AnimDone() then
                inst.sg:GoToState("idle")
            end
        end),
    },

    onexit = function(inst)
        if inst.sg.statemem.do_exit_cough then DoCoughSound(inst, 5, 0.7) end
        inst.sg.statemem.do_exit_cough = false
        inst.AnimState:ShowSymbol("fx_icon")
    end
})

env.AddStategraphPostInit("wilson", function(sg)
    local _IdleOnEnter = sg.states["idle"].onenter
    sg.states["idle"].onenter = function(inst, pushanim, ...)
        local timeRemaining = inst.sg.mem.queuetalk_timeout ~= nil and inst.sg.mem.queuetalk_timeout - GetTime() or nil
        if inst.sg.mem.um_smog_cough == nil or timeRemaining == nil or timeRemaining <= 1 then
            _IdleOnEnter(inst, pushanim, ...)
            inst.sg.mem.um_smog_cough = nil
            return
        end

        inst.sg:GoToState("um_smog_cough")
        inst.sg.mem.queuetalk_timeout = nil
    end
end)
