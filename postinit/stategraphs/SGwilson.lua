local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddStategraphPostInit("wilson", function(inst)

local events =
{
EventHandler("sneeze", function(inst, data)
        if not inst.components.health:IsDead() and not inst.components.health.invincible then
            if inst.sg:HasStateTag("busy") and inst.sg.currentstate.name ~= "emote" then
                inst.wantstosneeze = true
            else
                inst.sg:GoToState("sneeze")
            end
        end
    end)
}

local actionhandlers =
{
	ActionHandler(ACTIONS.CASTSPELL,
        function(inst, action)
            return action.invobject ~= nil
                and ((action.invobject:HasTag("gnarwail_horn") and "play_gnarwail_horn")
                    or (action.invobject:HasTag("guitar") and "play_strum")
                    or (action.invobject:HasTag("cointosscast") and "cointosscastspell")
                    or (action.invobject:HasTag("quickcast") and "quickcastspell")
                    or (action.invobject:HasTag("veryquickcast") and "veryquickcastspell")
                    or (action.invobject:HasTag("lighter") and "castspelllighter")
                    )
                or "castspell"
        end)
}

local _OldIdleState = inst.states["idle"].onenter
    inst.states["idle"].onenter = function(inst, pushanim)
            _OldIdleState(inst, pushanim)
           if inst.wantstosneeze then
                    inst.sg:GoToState("sneeze")
            end
    end

local states = {

	State{
        name = "castspelllighter",
        tags = { "doing", "busy", "canrotate" },

        onenter = function(inst)
            if inst.components.playercontroller ~= nil then
                inst.components.playercontroller:Enable(false)
            end
            inst.AnimState:PlayAnimation("staff_pre")
            inst.AnimState:PushAnimation("staff", false)
            inst.components.locomotor:Stop()

            --Spawn an effect on the player's location
            local staff = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
            local colour = staff ~= nil and staff.fxcolour or { 1, 1, 1 }
			--[[
            inst.sg.statemem.stafffx = SpawnPrefab(inst.components.rider:IsRiding() and "staffcastfx_mount" or "frog")
            inst.sg.statemem.stafffx.entity:SetParent(inst.entity)
            inst.sg.statemem.stafffx.Transform:SetRotation(inst.Transform:GetRotation())
            inst.sg.statemem.stafffx:SetUp(colour)
			]]
            inst.sg.statemem.stafflight = SpawnPrefab("staff_castinglight")
            inst.sg.statemem.stafflight.Transform:SetPosition(inst.Transform:GetWorldPosition())
            inst.sg.statemem.stafflight:SetUp(colour, 1.9, .33)

            if staff ~= nil and staff.components.aoetargeting ~= nil and staff.components.aoetargeting.targetprefab ~= nil then
                local buffaction = inst:GetBufferedAction()
                if buffaction ~= nil and buffaction.pos ~= nil then
                    inst.sg.statemem.targetfx = SpawnPrefab(staff.components.aoetargeting.targetprefab)
                    if inst.sg.statemem.targetfx ~= nil then
                        inst.sg.statemem.targetfx.Transform:SetPosition(buffaction:GetActionPoint():Get())
                        inst.sg.statemem.targetfx:ListenForEvent("onremove", OnRemoveCleanupTargetFX, inst)
                    end
                end
            end

            inst.sg.statemem.castsound = staff ~= nil and staff.castsound or "dontstarve/wilson/use_gemstaff"
        end,

        timeline =
        {
            TimeEvent(13 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound(inst.sg.statemem.castsound)
            end),
            TimeEvent(53 * FRAMES, function(inst)
                if inst.sg.statemem.targetfx ~= nil then
                    if inst.sg.statemem.targetfx:IsValid() then
                        OnRemoveCleanupTargetFX(inst)
                    end
                    inst.sg.statemem.targetfx = nil
                end
                inst.sg.statemem.stafffx = nil --Can't be cancelled anymore
                inst.sg.statemem.stafflight = nil --Can't be cancelled anymore
                --V2C: NOTE! if we're teleporting ourself, we may be forced to exit state here!
                inst:PerformBufferedAction()
            end),
        },

        events =
        {
            EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },

        onexit = function(inst)
            if inst.components.playercontroller ~= nil then
                inst.components.playercontroller:Enable(true)
            end
            if inst.sg.statemem.stafffx ~= nil and inst.sg.statemem.stafffx:IsValid() then
                inst.sg.statemem.stafffx:Remove()
            end
            if inst.sg.statemem.stafflight ~= nil and inst.sg.statemem.stafflight:IsValid() then
                inst.sg.statemem.stafflight:Remove()
            end
            if inst.sg.statemem.targetfx ~= nil and inst.sg.statemem.targetfx:IsValid() then
                OnRemoveCleanupTargetFX(inst)
            end
        end,
    },


    State{
        name = "curse_controlled",
        tags = { "busy", "pausepredict", "nomorph", "nodangle" },

        onenter = function(inst)
            if not inst.AnimState:IsCurrentAnimation("mindcontrol_loop") then
                inst.AnimState:PlayAnimation("mindcontrol_loop", true)
            end
            inst.sg:SetTimeout(2)
        end,

        events =
        {
            EventHandler("mindcontrolled", function(inst)
                inst.sg.statemem.mindcontrolled = true
                inst.sg:GoToState("mindcontrolled_loop")
            end),
        },

        ontimeout = function(inst)
            inst.sg:GoToState("mindcontrolled_pst")
        end,

        onexit = function(inst)
            if not inst.sg.statemem.mindcontrolled then
                if inst.components.playercontroller ~= nil then
                    inst.components.playercontroller:Enable(true)
                end
                inst.components.inventory:Show()
            end
        end,
    },

State{
        name = "sneeze",
        tags = {"busy", "sneeze", "pausepredict" },
        
        onenter = function(inst)
            inst.wantstosneeze = false
            inst:ClearBufferedAction()
            inst.components.locomotor:Stop()
            inst.SoundEmitter:PlaySound("dontstarve/wilson/hit",nil,.02)
			
			
			if inst.components.rider ~= nil and not inst.components.rider:IsRiding() then
				inst.AnimState:PlayAnimation("sneeze")
			end
			
            
            if inst.prefab ~= "wes" then
				inst.SoundEmitter:PlaySound("UCSounds/Sneeze/sneeze")
                local sound_name = inst.soundsname or inst.prefab
                local path = inst.talker_path_override or "dontstarve/characters/"
                --local equippedHat = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
                --if equippedHat and equippedHat:HasTag("muffler") then
                    --inst.SoundEmitter:PlaySound(path..sound_name.."/gasmask_hurt")
                --else
                    local sound_event = path..sound_name.."/hurt"
                    inst.SoundEmitter:PlaySound(inst.hurtsoundoverride or sound_event)
                --end

				inst.components.talker:Say(GetString(inst.prefab, "ANNOUNCE_SNEEZE"))  
            end        
        end,
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end ),
        }, 
        
        timeline =
        {
            TimeEvent(10*FRAMES, function(inst)
                if inst.components.hayfever then
                    inst.components.hayfever:DoSneezeEffects()
                end
                inst.sg:RemoveStateTag("busy")
            end),
        },        
               
    },
}

for k, v in pairs(events) do
    assert(v:is_a(EventHandler), "Non-event added in mod events table!")
    inst.events[v.name] = v
end

for k, v in pairs(states) do
    assert(v:is_a(State), "Non-state added in mod state table!")
    inst.states[v.name] = v
end

for k, v in pairs(actionhandlers) do
    assert(v:is_a(ActionHandler), "Non-action added in mod state table!")
    inst.actionhandlers[v.action] = v
end

end)