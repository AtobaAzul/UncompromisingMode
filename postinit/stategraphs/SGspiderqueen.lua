local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddStategraphPostInit("spiderqueen", function(inst)
local events={
    EventHandler("doattack", function(inst, data)
        if not inst.components.health:IsDead() then
            local weapon = inst.components.combat and inst.components.combat:GetWeapon()
            if weapon then
                if weapon:HasTag("snotbomb") then
                    inst.sg:GoToState("launchprojectile", data.target)
                else
                    inst.sg:GoToState("attack", data.target)
                end
            end
        end
    end),
	}


local states = {
    State{
        name = "launchprojectile",
        tags = {"attack", "busy"},
        
        onenter = function(inst, target)    
			inst.sg.statemem.target = target
            inst.components.combat:StartAttack()
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("poop_pre")
            inst.AnimState:PushAnimation("poop_loop", false)
            inst.AnimState:PushAnimation("poop_pst", false)
        end,
        
        
        timeline=
        {
            TimeEvent(19*FRAMES, function(inst)
                --inst.SoundEmitter:PlaySound(inst.sounds.spit)
            end),
            TimeEvent(27*FRAMES, function(inst)
                inst.components.combat:DoAttack(inst.sg.statemem.target)
				inst.WebReady = false
				inst:DoTaskInTime(35,function(inst) inst.WebReady = true end)
            end),
        },
        
        events=
        {
            EventHandler("animqueueover", function(inst) inst.sg:GoToState("idle") end),
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