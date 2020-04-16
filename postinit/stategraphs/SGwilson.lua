local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddStategraphPostInit("wilson", function(inst)

local events =
{
EventHandler("sneeze", function(inst, data)
        if not inst.components.health:IsDead() and not inst.components.health.invincible then
            if inst.sg:HasStateTag("busy") then
                inst.wantstosneeze = true
            else
                inst.sg:GoToState("sneeze")
            end
        end
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
        name = "sneeze",
        tags = {"busy","sneeze"},
        
        onenter = function(inst)
            inst.wantstosneeze = false
            inst.SoundEmitter:PlaySound("dontstarve/wilson/hit",nil,.02)
			
			
			if inst.components.rider ~= nil and not inst.components.rider:IsRiding() then
				inst.AnimState:PlayAnimation("sneeze")
			end
			
            inst.SoundEmitter:PlaySound("UCSounds/Sneeze/sneeze")
            inst:ClearBufferedAction()
            
            if inst.prefab ~= "wes" then
                local sound_name = inst.soundsname or inst.prefab
                local path = inst.talker_path_override or "dontstarve/characters/"
                --local equippedHat = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
                --if equippedHat and equippedHat:HasTag("muffler") then
                    --inst.SoundEmitter:PlaySound(path..sound_name.."/gasmask_hurt")
                --else
                    local sound_event = path..sound_name.."/hurt"
                    inst.SoundEmitter:PlaySound(inst.hurtsoundoverride or sound_event)
                --end
            end
            inst.components.locomotor:Stop()  

            inst.components.talker:Say(GetString(inst.prefab, "ANNOUNCE_SNEEZE"))        
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

end)