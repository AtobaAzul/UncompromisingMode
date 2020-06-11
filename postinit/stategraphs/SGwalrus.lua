local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddStategraphPostInit("walrus", function(inst)

local function PlayCreatureSound(inst, sound, creature)
    local creature = creature or inst.soundgroup or inst.prefab
    inst.SoundEmitter:PlaySound("dontstarve/creatures/" .. creature .. "/" .. sound)
end

local states = {

	State{
        name = "taunt_newtarget", -- i don't want auto-taunt in combat
        tags = {"busy"},
        
        onenter = function(inst)
            inst.Physics:Stop()
			if TheWorld.state.issummer then
				inst.AnimState:PlayAnimation("idle_happy")
			else
				inst.AnimState:PlayAnimation("abandon")
			end
            PlayCreatureSound(inst, "taunt")
        end,
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },
	
	State{
        name = "taunt_attack",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.components.combat:StartAttack() -- reset combat attack timer
            inst.Physics:Stop()
			if TheWorld.state.issummer then
				inst.AnimState:PlayAnimation("idle_happy")
			else
				inst.AnimState:PlayAnimation("abandon")
			end
            PlayCreatureSound(inst, "taunt")
        end,
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },  
}


for k, v in pairs(states) do
    assert(v:is_a(State), "Non-state added in mod state table!")
    inst.states[v.name] = v
end

end)