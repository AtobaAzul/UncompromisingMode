local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddStategraphPostInit("moose", function(inst)

local function ShakeIfClose(inst)
    ShakeAllCameras(CAMERASHAKE.FULL, .35, .02, 1, inst, 40)
end

local actionhandlers =
{
	ActionHandler(ACTIONS.LAYEGG, function(inst)
        return not inst.components.combat:HasTarget() and "layegg2"
    end)
}

local events=
{
    EventHandler("locomote",
	function(inst)
		print("chumba1")
		if (not inst.sg:HasStateTag("idle") and not inst.sg:HasStateTag("moving") or inst.sg:HasStateTag("superhop")) then return end

		print("chumba2")
		if not inst.components.locomotor:WantsToMoveForward() then
			if not inst.sg:HasStateTag("idle") then
		print("chumba5")
				inst.sg:GoToState("idle", {softstop = true})
			end
		else
			local target = inst.components.combat ~= nil and inst.components.combat.target or nil
		
			if not inst.sg:HasStateTag("hopping") and inst.superhop == true and target ~= nil and math.random() < 0.5 then
		print("chumba3")
				inst.sg:GoToState("hopatk")
			elseif not inst.sg:HasStateTag("hopping") then
		print("chumba4")
				inst.sg:GoToState("hop")
			end
		end
	end),
	EventHandler("flyaway", function(inst)
		if not inst.components.combat:HasTarget() and not inst.components.health:IsDead() and not inst.sg:HasStateTag("busy") then
			inst.sg:GoToState("flyaway")
		end
	end),
}

local states = {
	State{
		name = "hopatk",
		tags = { "attack", "moving", "hopping", --[["canrotate",]] "busy", "superhop"},

		onenter = function(inst)
			--inst.Physics:Stop()
			inst.AnimState:PlayAnimation("hopatk")
			PlayFootstep(inst)
			--inst.components.locomotor:WalkForward()
			if inst.doublesuperhop ~= nil then
				inst.doublesuperhop = inst.doublesuperhop + 1
			else
				inst.doublesuperhop = 1
			end
			
            local target = inst.components.combat.target ~= nil and inst.components.combat.target or nil
			
			if target ~= nil and target.Transform ~= nil then
				inst:ForceFacePoint(target.Transform:GetWorldPosition())
			end
			
			if math.random() <= 0.3 or inst.doublesuperhop > 1 then
				inst.doublesuperhop = 0
				inst.superhop = false
			
				inst.components.timer:StopTimer("SuperHop")
				inst.components.timer:StartTimer("SuperHop", 10)
			end
                
		end,

		timeline=
		{
			TimeEvent(1*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/moose/preen") end),
			TimeEvent(30*FRAMES, function(inst)
				inst.components.locomotor:WalkForward()
			end),
		},

		events=
		{
			EventHandler("animover", function(inst) 
				inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/moose/swhoosh")
				inst.sg:GoToState("hopatk_loop") 
			end),
		},
	},
	
	State{
		name = "hopatk_loop",
		tags = { "attack", "moving", "hopping", "busy", "superhop"},

		onenter = function(inst)
			inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/moose/attack")
			inst.AnimState:PlayAnimation("hopatk_loop", true)
			inst.components.locomotor:WalkForward()
			inst.flapySound = inst:DoPeriodicTask(6*FRAMES,
				function(inst)
			inst.components.locomotor:WalkForward()
					inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/moose/flap")
				end)
			--inst.sg:SetTimeout(.5)
		end,

		onexit = function(inst)
			if inst.flapySound then
				inst.flapySound:Cancel()
				inst.flapySound = nil
			end
		end,

		--[[ontimeout= function(inst)
			inst.sg:GoToState("landatk")
		end,]]

		events=
		{
			EventHandler("animover", function(inst) inst.sg:GoToState("landatk") end),
		},
	},
	
	State{
		name = "landatk",
		tags = { "attack", "moving", "hopping", "busy", "superhop"},

		onenter = function(inst)
			inst.Physics:Stop()
			inst.AnimState:PlayAnimation("land")
			PlayFootstep(inst)
			ShakeIfClose(inst)
		end,

		timeline=
		{
			TimeEvent(2*FRAMES, function(inst) 
				inst.components.groundpounder:GroundPound()
				inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/land") 
			end)
		},

		events=
		{
			EventHandler("animover", function(inst) inst.sg:GoToState("idle", {softstop = true}) end),
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

for k, v in pairs(actionhandlers) do
    assert(v:is_a(ActionHandler), "Non-action added in mod state table!")
    inst.actionhandlers[v.action] = v
end

end)

env.AddStategraphPostInit("mothermoose", function(inst)

local function ShakeIfClose(inst)
    ShakeAllCameras(CAMERASHAKE.FULL, .35, .02, 1, inst, 40)
end

local actionhandlers =
{
	ActionHandler(ACTIONS.LAYEGG, function(inst)
        return not inst.components.combat:HasTarget() and "layegg2"
    end)
}

local events=
{
    EventHandler("locomote",
	function(inst)
		print("chumba1")
		if (not inst.sg:HasStateTag("idle") and not inst.sg:HasStateTag("moving") or inst.sg:HasStateTag("superhop")) then return end

		print("chumba2")
		if not inst.components.locomotor:WantsToMoveForward() then
			if not inst.sg:HasStateTag("idle") then
		print("chumba5")
				inst.sg:GoToState("idle", {softstop = true})
			end
		else
			local target = inst.components.combat ~= nil and inst.components.combat.target or nil
		
			if not inst.sg:HasStateTag("hopping") and inst.superhop == true and target ~= nil and math.random() < 0.5 then
		print("chumba3")
				inst.sg:GoToState("hopatk")
			elseif not inst.sg:HasStateTag("hopping") then
		print("chumba4")
				inst.sg:GoToState("hop")
			end
		end
	end),
}

local states = {
	State{
		name = "hopatk",
		tags = { "attack", "moving", "hopping", --[["canrotate",]] "busy", "superhop"},

		onenter = function(inst)
			--inst.Physics:Stop()
			inst.AnimState:PlayAnimation("hopatk")
			PlayFootstep(inst)
			--inst.components.locomotor:WalkForward()
			if inst.doublesuperhop ~= nil then
				inst.doublesuperhop = inst.doublesuperhop + 1
			else
				inst.doublesuperhop = 1
			end
			
            local target = inst.components.combat.target ~= nil and inst.components.combat.target or nil
			
			if target ~= nil and target.Transform ~= nil then
				inst:ForceFacePoint(target.Transform:GetWorldPosition())
			end
			
			if math.random() <= 0.3 or inst.doublesuperhop > 1 then
				inst.doublesuperhop = 0
				inst.superhop = false
			
				inst.components.timer:StopTimer("SuperHop")
				inst.components.timer:StartTimer("SuperHop", 10)
			end
                
		end,

		timeline=
		{
			TimeEvent(1*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/moose/preen") end),
			TimeEvent(30*FRAMES, function(inst)
				inst.components.locomotor:WalkForward()
			end),
		},

		events=
		{
			EventHandler("animover", function(inst) 
				inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/moose/swhoosh")
				inst.sg:GoToState("hopatk_loop") 
			end),
		},
	},
	
	State{
		name = "hopatk_loop",
		tags = { "attack", "moving", "hopping", "busy", "superhop"},

		onenter = function(inst)
			inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/moose/attack")
			inst.AnimState:PlayAnimation("hopatk_loop", true)
			inst.components.locomotor:WalkForward()
			inst.flapySound = inst:DoPeriodicTask(6*FRAMES,
				function(inst)
			inst.components.locomotor:WalkForward()
					inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/moose/flap")
				end)
			--inst.sg:SetTimeout(.5)
		end,

		onexit = function(inst)
			if inst.flapySound then
				inst.flapySound:Cancel()
				inst.flapySound = nil
			end
		end,

		--[[ontimeout= function(inst)
			inst.sg:GoToState("landatk")
		end,]]

		events=
		{
			EventHandler("animover", function(inst) inst.sg:GoToState("landatk") end),
		},
	},
	
	State{
		name = "landatk",
		tags = { "attack", "moving", "hopping", "busy", "superhop"},

		onenter = function(inst)
			inst.Physics:Stop()
			inst.AnimState:PlayAnimation("land")
			PlayFootstep(inst)
			ShakeIfClose(inst)
		end,

		timeline=
		{
			TimeEvent(2*FRAMES, function(inst) 
				inst.components.groundpounder:GroundPound()
				inst.components.combat:DoAreaAttack(inst, TUNING.MOOSE_ATTACK_RANGE * 1.1, nil, nil, nil, { "moose", "mossling" }) --GroundPound Is purely visual
				inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/land") 
			end)
		},

		events=
		{
			EventHandler("animover", function(inst) inst.sg:GoToState("idle", {softstop = true}) end),
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

for k, v in pairs(actionhandlers) do
    assert(v:is_a(ActionHandler), "Non-action added in mod state table!")
    inst.actionhandlers[v.action] = v
end

end)

