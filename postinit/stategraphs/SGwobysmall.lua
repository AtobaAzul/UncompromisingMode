local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddStategraphPostInit("SGcritter_puppy", function(inst)


local events=
{
    EventHandler("death", function(inst) inst.sg:GoToState("death") end),
	
	EventHandler("attacked", function(inst)
        if not inst.components.health:IsDead() then
            inst.sg:GoToState("hit") -- can still attack
        end
    end)
}

local states = {

	State{
        name = "hit",

        onenter = function(inst)
            inst.AnimState:PlayAnimation("hit")
			inst.SoundEmitter:PlaySound("dontstarve/characters/walter/woby/small/bark")
            inst.Physics:Stop()            
        end,

        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end ),
        },
    },

	State{
        name = "death",
        tags = {"busy"},

        onenter = function(inst)
            inst.components.container:Close()
            inst.components.container:DropEverything()
            inst.components.container.canbeopened = false
            inst.SoundEmitter:PlaySound("dontstarve/creatures/together/pupington/death")
            inst.AnimState:PlayAnimation("death")
            inst.Physics:Stop()
            RemovePhysicsColliders(inst)          
        end,
    }
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

env.AddStategraphPostInit("wobybig", function(inst)

local events=
{
    EventHandler("death", function(inst) inst.sg:GoToState("death") end),
	
	EventHandler("attacked", function(inst)
        if not inst.components.health:IsDead() then
            inst.sg:GoToState("hit") -- can still attack
        end
    end)
}

local states = {

	State{
        name = "hit",

        onenter = function(inst)
            inst.AnimState:PlayAnimation("hit_woby")
			inst.SoundEmitter:PlaySound("dontstarve/characters/walter/woby/big/bark")
            inst.Physics:Stop()            
        end,

        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end ),
        },
    },

	State{
        name = "death",
        tags = {"busy", "canrotate"},

        onenter = function(inst)
            inst.components.container:Close()
            inst.components.container:DropEverything()
            inst.components.container.canbeopened = false
            inst.SoundEmitter:PlaySound("dontstarve/characters/walter/woby/big/bark")
            inst.sg:GoToState("actual_death")
            inst.Physics:Stop()
            RemovePhysicsColliders(inst)          
        end,
    },
	
	State{
        name = "actual_death",
        tags = {"busy", "canrotate"},
        onenter = function(inst)
            inst.components.locomotor:StopMoving()
			
           if not inst.AnimState:IsCurrentAnimation("cower_woby_loop") then
                inst.AnimState:PlayAnimation("cower_woby_pre", false)
                inst.AnimState:PushAnimation("cower_woby_loop")
            end
        end,
        
        timeline=
        {
            TimeEvent(4*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/characters/walter/woby/big/foley") end),
            TimeEvent(11*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/characters/walter/woby/big/wimper") end),
        },
    }
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