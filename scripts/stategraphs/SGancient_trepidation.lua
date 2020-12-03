require("stategraphs/commonstates")

local actionhandlers = 
{
    --ActionHandler(ACTIONS.INVESTIGATE, "investigate"),
}
local function FinishExtendedSound(inst, soundid)
    inst.SoundEmitter:KillSound("sound_"..tostring(soundid))
    inst.sg.mem.soundcache[soundid] = nil
    if inst.sg.statemem.readytoremove and next(inst.sg.mem.soundcache) == nil then
        inst:Remove()
    end
end

local function PlayExtendedSound(inst, soundname)
    if inst.sg.mem.soundcache == nil then
        inst.sg.mem.soundcache = {}
        inst.sg.mem.soundid = 0
    else
        inst.sg.mem.soundid = inst.sg.mem.soundid + 1
    end
    inst.sg.mem.soundcache[inst.sg.mem.soundid] = true
    inst.SoundEmitter:PlaySound(inst.sounds[soundname], "sound_"..tostring(inst.sg.mem.soundid))
    inst:DoTaskInTime(5, FinishExtendedSound, inst.sg.mem.soundid)
end

local function OnAnimOverRemoveAfterSounds(inst)
    if inst.sg.mem.soundcache == nil or next(inst.sg.mem.soundcache) == nil then
        inst:Remove()
    else
        inst:Hide()
        inst.sg.statemem.readytoremove = true
    end
end
local events=
{

    EventHandler("doattack", function(inst, data) 
        if not inst.components.health:IsDead() and not inst.sg:HasStateTag("busy") and data and data.target  then 

        inst.sg:GoToState("attack", data.target) 

        end 
    end),
    EventHandler("death", function(inst) inst.sg:GoToState("death") end),
    
    
    EventHandler("locomote", function(inst) 
        if not inst.sg:HasStateTag("busy") then
            
            local is_moving = inst.sg:HasStateTag("moving")
            local wants_to_move = inst.components.locomotor:WantsToMoveForward()
            if not inst.sg:HasStateTag("attack") and is_moving ~= wants_to_move then
                if wants_to_move then
                    inst.sg:GoToState("premoving")
                else
                    inst.sg:GoToState("idle")
                end
            end
        end
    end),    
}

local states=
{
    
    
    State{
        name = "death",
        tags = {"busy"},
        
        onenter = function(inst)
            --inst.SoundEmitter:PlaySound("UCSounds/Scorpion/death")
			inst.Physics:Stop()
			PlayExtendedSound(inst, "death")
			PlayExtendedSound(inst, "death")
			PlayExtendedSound(inst, "death")
			RemovePhysicsColliders(inst) 
            inst.AnimState:PlayAnimation("death")
			inst:AddTag("NOCLICK")
			
        end,
        timeline=
        {	TimeEvent(10*FRAMES, function(inst) inst.components.lootdropper:DropLoot(Vector3(inst.Transform:GetWorldPosition()))  end),
			TimeEvent(14*FRAMES, function(inst) inst.components.lootdropper:DropLoot(Vector3(inst.Transform:GetWorldPosition()))  end),
			TimeEvent(18*FRAMES, function(inst) inst.components.lootdropper:DropLoot(Vector3(inst.Transform:GetWorldPosition()))  end),
			TimeEvent(22*FRAMES, function(inst) inst.components.lootdropper:DropLoot(Vector3(inst.Transform:GetWorldPosition()))  end),
			TimeEvent(26*FRAMES, function(inst) inst.components.lootdropper:DropLoot(Vector3(inst.Transform:GetWorldPosition()))  end),
			TimeEvent(30*FRAMES, function(inst) inst.components.lootdropper:DropLoot(Vector3(inst.Transform:GetWorldPosition()))  end),
			TimeEvent(34*FRAMES, function(inst) inst.components.lootdropper:DropLoot(Vector3(inst.Transform:GetWorldPosition()))  end),
        }, 
		        events=
        {
            EventHandler("animover", function(inst) 

			end),
        },

    },    
    
    State{
        name = "premoving",
        tags = {"moving", "canrotate"},
        
        onenter = function(inst)
            inst.components.locomotor:WalkForward()
            inst.AnimState:PlayAnimation("walk_pre")
        end,
        
        timeline=
        {
            --TimeEvent(3*FRAMES, function(inst) inst.SoundEmitter:PlaySound("UCSounds/Scorpion/walk") end),
            --TimeEvent(3*FRAMES, function(inst) inst.SoundEmitter:PlaySound("UCSounds/Scorpion/mumble") end),
        },
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("moving") end),
        },
    },
    
    State{
        name = "moving",
        tags = {"moving", "canrotate"},
        
        onenter = function(inst)
            inst.components.locomotor:RunForward()
            inst.AnimState:PushAnimation("walk_loop")
        end,
        
        timeline=
        {
        
        },
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("moving") end),
        },
        
    },    
    
    
    State{
        name = "idle",
        tags = {"idle", "canrotate"},
        
        ontimeout = function(inst)
			inst.sg:GoToState("taunt")
        end,
        
        onenter = function(inst, start_anim)
            inst.Physics:Stop()
            local animname = "idle"
            if math.random() < .3 then
				inst.sg:SetTimeout(math.random()*2 + 2)
			end

            if start_anim then
                inst.AnimState:PlayAnimation(start_anim)
                inst.AnimState:PushAnimation("idle", true)
            else
                inst.AnimState:PlayAnimation("idle", true)
            end

        end,
    },
    
    State{
        name = "taunt",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("taunt")
			PlayExtendedSound(inst, "taunt")
            --inst.SoundEmitter:PlaySound("UCSounds/Scorpion/taunt")
        end,
        timeline=
        {	TimeEvent(5*FRAMES, function(inst) PlayExtendedSound(inst, "taunt") end),
			TimeEvent(10*FRAMES, function(inst) PlayExtendedSound(inst, "taunt") end),
        },      
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },    
    State{
        name = "spawn",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("give_life")
            --inst.SoundEmitter:PlaySound("UCSounds/Scorpion/taunt")
        end,
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },        
    
    State{
        name = "attack",
        tags = {"attack", "busy", "no_stun"},
        
        onenter = function(inst, target)
            inst.Physics:Stop()
            inst.components.combat:StartAttack()
            inst.AnimState:PlayAnimation("attack")
            inst.sg.statemem.target = target
        end,
        
        timeline=
        {	TimeEvent(10*FRAMES, function(inst) PlayExtendedSound(inst, "attack") end),
			TimeEvent(12*FRAMES, function(inst) inst.components.combat:DoAttack(inst.sg.statemem.target) end),
			TimeEvent(22*FRAMES, function(inst) PlayExtendedSound(inst, "attack") end),
            TimeEvent(25*FRAMES, function(inst) inst.components.combat:DoAttack(inst.sg.statemem.target) end),
        },
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State{
        name = "hit",
        
        onenter = function(inst)
            inst.AnimState:PlayAnimation("hit")
            inst.Physics:Stop()            
        end,
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end ),
        },
    },    

}



return StateGraph("ancient_trepidation", states, events, "idle", actionhandlers)

