local env = env
GLOBAL.setfenv(1, GLOBAL)

local function ArtificialLocomote(inst, destination, speed) --Locomotor is basically running a similar code anyhow, this bypasses any physics interactions preventing
	if destination and speed then --our locomote from working... Inconsistencies in when the entity is supposed to walk forward led to this.
		speed = speed * FRAMES
		local hypoten = math.sqrt(inst:GetDistanceSqToPoint(destination))
		local x, y, z = inst.Transform:GetWorldPosition()
		local x_final, y_final, z_final
		local speedmult = inst.components.locomotor ~= nil and inst.components.locomotor:GetSpeedMultiplier() or 1
		x_final = ((destination.x - x) / hypoten) * (speed * speedmult) + x
		z_final = ((destination.z - z) / hypoten) * (speed * speedmult) + z

		inst.Transform:SetPosition(x_final, y, z_final)
	end
end

local function FindFarLandingPoint(inst, destination) --This makes the geese aim for a point behind the player instead of where the player is at.
	if destination then --If it aimed directly at the player, it'll do something similar to the bugged version.
		inst.hopPoint = destination
		local hypoten = math.sqrt(inst:GetDistanceSqToPoint(destination))
		local x, y, z = inst.Transform:GetWorldPosition()
		local x_far, z_far
		x_far = ((destination.x - x) / hypoten) * 20 + x --20 is arbitrary, another number could be used if desired, if it is low enough it may make m/goose undershoot the player too.
		z_far = ((destination.z - z) / hypoten) * 20 + z
		inst.hopPoint.x = x_far
		inst.hopPoint.z = z_far
	end
end

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

	local events =
	{
		EventHandler("locomote",
			function(inst)
				if (not inst.sg:HasStateTag("idle") and not inst.sg:HasStateTag("moving") or inst.sg:HasStateTag("superhop")) then return end

				if not inst.components.locomotor:WantsToMoveForward() then
					if not inst.sg:HasStateTag("idle") then
						inst.sg:GoToState("idle", { softstop = true })
					end
				else
					local target = inst.components.combat ~= nil and inst.components.combat.target or nil

					if not inst.sg:HasStateTag("hopping") and inst.superhop and target ~= nil and math.random() < 0.5 then
						inst.sg:GoToState("hopatk")
					elseif not inst.sg:HasStateTag("hopping") then
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
		State {
			name = "hopatk",
			tags = { "attack", "moving", "hopping", --[["canrotate",]] "busy", "superhop" },

			onenter = function(inst)
				inst.components.locomotor:Stop()
				inst.AnimState:PlayAnimation("hopatk")
				PlayFootstep(inst)
				if inst.doublesuperhop ~= nil then
					inst.doublesuperhop = inst.doublesuperhop + 1
				else
					inst.doublesuperhop = 1
				end

				local target = inst.components.combat.target ~= nil and inst.components.combat.target or nil

				if target ~= nil and target.Transform ~= nil then
					inst:ForceFacePoint(target.Transform:GetWorldPosition())

					FindFarLandingPoint(inst, inst.components.combat.target:GetPosition())
				else
					FindFarLandingPoint(inst, inst:GetPosition())
				end

				if math.random() <= 0.3 or inst.doublesuperhop > 1 then
					inst.doublesuperhop = 0
					inst.superhop = false

					inst.components.timer:StopTimer("SuperHop")
					inst.components.timer:StartTimer("SuperHop", 10)
				end

			end,

			timeline =
			{
				TimeEvent(1 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/moose/preen") end),
			},

			events =
			{
				EventHandler("animover", function(inst)
					inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/moose/swhoosh")
					inst.sg:GoToState("hopatk_loop")
				end),
			},
		},

		State {
			name = "hopatk_loop",
			tags = { "attack", "moving", "hopping", "busy", "superhop" },

			onenter = function(inst)
				inst.Physics:ClearCollisionMask()
				inst.Physics:CollidesWith(COLLISION.WORLD)
				inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/moose/attack")
				inst.AnimState:PlayAnimation("hopatk_loop", true)
				inst.flapySound = inst:DoPeriodicTask(6 * FRAMES,
					function(inst)
						inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/moose/flap")
					end)
				--inst.sg:SetTimeout(.5)
			end,

			onexit = function(inst)
				inst.Physics:CollidesWith(COLLISION.OBSTACLES)
				inst.Physics:CollidesWith(COLLISION.CHARACTERS)
				inst.Physics:CollidesWith(COLLISION.GIANTS)

				if inst.flapySound then
					inst.flapySound:Cancel()
					inst.flapySound = nil
				end
			end,

			onupdate = function(inst)
				ArtificialLocomote(inst, inst.hopPoint, 15)
			end,

			events =
			{
				EventHandler("animover", function(inst) inst.sg:GoToState("landatk") end),
			},
		},

		State {
			name = "landatk",
			tags = { "attack", "moving", "hopping", "busy", "superhop" },

			onenter = function(inst)
				inst.components.locomotor:Stop()
				inst.AnimState:PlayAnimation("land")
				PlayFootstep(inst)
				ShakeIfClose(inst)
			end,

			timeline =
			{
				TimeEvent(2 * FRAMES, function(inst)

					inst.components.groundpounder:GroundPound()
					inst.components.combat:DoAreaAttack(inst, TUNING.MOOSE_ATTACK_RANGE * 1.3, nil, nil, nil, { "moose", "mossling" }) --GroundPound Is purely visual
					inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/land")
				end)
			},

			events =
			{
				EventHandler("animover", function(inst) inst.sg:GoToState("idle", { softstop = true }) end),
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

	local events =
	{
		EventHandler("locomote",
			function(inst)
				if (not inst.sg:HasStateTag("idle") and not inst.sg:HasStateTag("moving") or inst.sg:HasStateTag("superhop")) then return end

				if not inst.components.locomotor:WantsToMoveForward() then
					if not inst.sg:HasStateTag("idle") then
						inst.sg:GoToState("idle", { softstop = true })
					end
				else
					local target = inst.components.combat ~= nil and inst.components.combat.target or nil

					if not inst.sg:HasStateTag("hopping") and inst.superhop and target ~= nil and math.random() < 0.5 then
						inst.sg:GoToState("hopatk")
					elseif not inst.sg:HasStateTag("hopping") then
						inst.sg:GoToState("hop")
					end
				end
			end),
	}

	local states = {
		State {
			name = "hopatk",
			tags = { "attack", "moving", "hopping", --[["canrotate",]] "busy", "superhop" },

			onenter = function(inst)
				inst.components.locomotor:Stop()
				inst.AnimState:PlayAnimation("hopatk")
				PlayFootstep(inst)
				if inst.doublesuperhop ~= nil then
					inst.doublesuperhop = inst.doublesuperhop + 1
				else
					inst.doublesuperhop = 1
				end

				local target = inst.components.combat.target ~= nil and inst.components.combat.target or nil

				if target ~= nil and target.Transform ~= nil then
					inst:ForceFacePoint(target.Transform:GetWorldPosition())

					FindFarLandingPoint(inst, inst.components.combat.target:GetPosition())
				else
					FindFarLandingPoint(inst, inst:GetPosition())
				end

				if math.random() <= 0.3 or inst.doublesuperhop > 1 then
					inst.doublesuperhop = 0
					inst.superhop = false

					inst.components.timer:StopTimer("SuperHop")
					inst.components.timer:StartTimer("SuperHop", 10)
				end

			end,

			timeline =
			{
				TimeEvent(1 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/moose/preen") end),
			},

			events =
			{
				EventHandler("animover", function(inst)
					inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/moose/swhoosh")
					inst.sg:GoToState("hopatk_loop")
				end),
			},
		},

		State {
			name = "hopatk_loop",
			tags = { "attack", "moving", "hopping", "busy", "superhop" },

			onenter = function(inst)
				inst.Physics:ClearCollisionMask()
				inst.Physics:CollidesWith(COLLISION.WORLD)
				inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/moose/attack")
				inst.AnimState:PlayAnimation("hopatk_loop", true)
				inst.flapySound = inst:DoPeriodicTask(6 * FRAMES,
					function(inst)
						inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/moose/flap")
					end)
				--inst.sg:SetTimeout(.5)
			end,

			onupdate = function(inst)
				ArtificialLocomote(inst, inst.hopPoint, 15)
			end,

			onexit = function(inst)
				inst.Physics:CollidesWith(COLLISION.OBSTACLES)
				inst.Physics:CollidesWith(COLLISION.CHARACTERS)
				inst.Physics:CollidesWith(COLLISION.GIANTS)

				if inst.flapySound then
					inst.flapySound:Cancel()
					inst.flapySound = nil
				end
			end,

			--[[ontimeout= function(inst)
			inst.sg:GoToState("landatk")
		end,]]

			events =
			{
				EventHandler("animover", function(inst) inst.sg:GoToState("landatk") end),
			},
		},

		State {
			name = "landatk",
			tags = { "attack", "moving", "hopping", "busy", "superhop" },

			onenter = function(inst)
				inst.components.locomotor:Stop()
				inst.AnimState:PlayAnimation("land")
				PlayFootstep(inst)
				ShakeIfClose(inst)
			end,

			timeline =
			{
				TimeEvent(2 * FRAMES, function(inst)
					inst.components.groundpounder:GroundPound()
					inst.components.combat:DoAreaAttack(inst, TUNING.MOOSE_ATTACK_RANGE * 1.3, nil, nil, nil, { "moose", "mossling" }) --GroundPound Is purely visual
					inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/land")
				end)
			},

			events =
			{
				EventHandler("animover", function(inst) inst.sg:GoToState("idle", { softstop = true }) end),
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
