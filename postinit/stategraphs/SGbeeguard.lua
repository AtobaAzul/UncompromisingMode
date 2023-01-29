local env = env
GLOBAL.setfenv(1, GLOBAL)
local function StartBuzz(inst)
	inst:EnableBuzz(true)
end

local function StopBuzz(inst)
	inst:EnableBuzz(false)
end

local function StopCollide(inst)
	inst.Physics:ClearCollisionMask()
	inst.Physics:CollidesWith(COLLISION.GROUND)
end

local function StartCollide(inst)
	inst.Physics:CollidesWith(COLLISION.FLYERS)
	inst.Physics:CollidesWith(COLLISION.CHARACTERS)
end

local function ArtificialLocomote(inst, destination, speed)
	if destination and speed and inst:IsValid() then
		speed = speed * FRAMES
		local hypoten = math.sqrt(inst:GetDistanceSqToPoint(destination))
		local x, y, z = inst.Transform:GetWorldPosition()
		local x_final, y_final, z_final
		if x ~= nil and y ~= nil and z ~= nil then
			x_final = ((destination.x - x) / hypoten) * speed + x
			z_final = ((destination.z - z) / hypoten) * speed + z

			inst.Transform:SetPosition(x_final, y, z_final)
		end
	end
end

local function FindSpotForShadow(inst, target, shadow)
	if not (target and target:IsValid()) then
		local queen = inst.components.entitytracker:GetEntity("queen")
		if queen and queen.prioritytarget and queen.prioritytarget.components.health and
			not queen.prioritytarget.components.health:IsDead() then
			target = queen.prioritytarget
		end
	end
	local distance = 7
	if target and target:IsValid() then
		local x, y, z = target.Transform:GetWorldPosition()
		x = x + math.random(-distance, distance)
		z = z + math.random(-distance, distance)
		shadow.Transform:SetPosition(x, 0, z)
	else
		--TheNet:Announce("removing")
		inst:Remove()
	end
end

local function UpdateShadow(inst)
	if inst.bee then
		local x, y, z = inst.bee.Transform:GetWorldPosition()
		if y ~= nil and y > 0.5 then
			local scaleFactor = Lerp(.5, 1.5, y / 35)
			inst.Transform:SetScale(scaleFactor, scaleFactor, scaleFactor)
			if inst.bee.stabtarget and inst.bee.stabtarget:IsValid() then
				if inst.prefab == "um_beeguard_seeker" then
					ArtificialLocomote(inst, inst.bee.stabtarget:GetPosition(), 6)
				else
					ArtificialLocomote(inst, inst.bee.stabtarget:GetPosition(), 4)
				end
				inst.bee:ForceFacePoint(inst:GetPosition())
				local x1, y1, z1 = inst.Transform:GetWorldPosition()
				inst.bee.Transform:SetPosition(x1, y - 1, z1)
			else
				inst.bee.Transform:SetPosition(x, y - 1, z)
			end
		else
			inst:Remove()
		end
	else
		inst:Remove()
	end
end

local function UpdateShadowShooter(inst)
	if inst.bee then
		local x, y, z = inst.bee.Transform:GetWorldPosition()
		if y ~= nil and y > 0.5 then
			if inst.circle then
				inst.Transform:SetPosition(x, 0, z)
			end
			local scaleFactor = Lerp(.5, 1.5, y / 35)
			inst.Transform:SetScale(scaleFactor, scaleFactor, scaleFactor)
			if not inst.circle then
				local x1, y1, z1 = inst.Transform:GetWorldPosition()
				inst.bee.Transform:SetPosition(x1, y - 1, z1)
			end
		else
			inst:Remove()
		end
	else
		inst:Remove()
	end
end

local function Pop(inst)
	local honey = SpawnPrefab("honeyexplosion")
	if inst.queen ~= nil and inst.queen.prefab == "cherry_beequeen" then
		honey.AnimState:SetHue(0.7)
	end
	honey.Transform:SetPosition(inst.Transform:GetWorldPosition())
	honey.SoundEmitter:PlaySound("turnoftides/creatures/together/starfishtrap/trap")
	inst.dohoney(inst)
	inst:Remove()
end

env.AddStategraphPostInit("SGbeeguard", function(inst) --beeguard time

	local _OldOnEnter
	if inst.states["death"].onenter then
		_OldOnEnter = inst.states["death"].onenter
	end
	inst.states["death"].onenter = function(inst) --This specifically is for the seeker bee, just to make them not play the death animation and instead stay stuck in the ground vvhen they die.
		if inst.stabdied then
			inst.AnimState:PlayAnimation("explode")
			StopBuzz(inst)
			inst.components.locomotor:StopMoving()
			inst.components.lootdropper:DropLoot(inst:GetPosition())
			inst.SoundEmitter:PlaySound(inst.sounds.death)
			inst:ListenForEvent("animover", Pop)
		else
			_OldOnEnter(inst)
		end
	end

	local events = {}
	local states = {
		State {
			name = "flyup",
			tags = { "busy", "nosleep", "nofreeze", "noattack", "flight", "mortar" },

			onenter = function(inst)
				SpawnPrefab("bee_poof_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
				if inst.SoundEmitter:PlayingSound("buzz") then
					inst.SoundEmitter:KillSound("buzz")
					inst.SoundEmitter:PlaySound(inst.sounds.buzz, "buzz")
				end
				inst.DynamicShadow:Enable(false)
				StartBuzz(inst)
				inst.components.locomotor:StopMoving()
				inst.AnimState:PlayAnimation("ascend_pre", false)
				inst.AnimState:PushAnimation("ascend", true)
				inst.sg.statemem.vel = Vector3(3, 15, 0)
				inst.maxflyheight = math.random(30, 40)
			end,

			onupdate = function(inst)
				local x, y, z = inst.Transform:GetWorldPosition()
				if y > 4 then
					inst.sg.statemem.vel = Vector3(3, inst.maxflyheight + 5 - y, 0) --We kinda want it to arc a bit at the top
				end
				inst.Physics:SetMotorVel(inst.sg.statemem.vel:Get())
				if y > inst.maxflyheight then
					inst.sg:GoToState("flydown")
				end
			end,
		},
		State {
			name = "flyup_shooter",
			tags = { "busy", "nosleep", "nofreeze", "noattack", "flight", "mortar" },

			onenter = function(inst)
				SpawnPrefab("bee_poof_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
				if inst.SoundEmitter:PlayingSound("buzz") then
					inst.SoundEmitter:KillSound("buzz")
					inst.SoundEmitter:PlaySound(inst.sounds.buzz, "buzz")
				end
				inst.DynamicShadow:Enable(false)
				StartBuzz(inst)
				inst.components.locomotor:StopMoving()
				inst.AnimState:PlayAnimation("ascend_pre", false)
				inst.AnimState:PushAnimation("ascend", true)
				inst.sg.statemem.vel = Vector3(3, 30, 0)
				inst.maxflyheight = 20
			end,

			onupdate = function(inst)
				local x, y, z = inst.Transform:GetWorldPosition()
				if y > 4 then
					inst.sg.statemem.vel = Vector3(3, inst.maxflyheight + 5 - y, 0) --We kinda want it to arc a bit at the top
				end
				inst.Physics:SetMotorVel(inst.sg.statemem.vel:Get())
				if y > inst.maxflyheight then
					inst.sg:GoToState("flydown_shooter")
				end
			end,
		},
		State {
			name = "flydown",
			tags = { "busy", "nosleep", "nofreeze", "noattack", "flight", "mortar" },

			onenter = function(inst)
				StopCollide(inst)
				SpawnPrefab("bee_poof_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
				if inst.SoundEmitter:PlayingSound("buzz") then
					inst.SoundEmitter:KillSound("buzz")
					inst.SoundEmitter:PlaySound(inst.sounds.buzz, "buzz")
				end
				StartBuzz(inst)
				inst.components.locomotor:StopMoving()
				inst.AnimState:PlayAnimation("stab_pre", false)
				inst.AnimState:PushAnimation("stab", true)
				local horizVel = 3
				local verticalVel = 20
				local queen = inst.components.entitytracker:GetEntity("queen")
				if queen and queen.prioritytarget and queen.prioritytarget.components.health and
					not queen.prioritytarget.components.health:IsDead() then
					inst.stabtarget = queen.prioritytarget
				end
				if inst.stabtarget then
					local shadow = SpawnPrefab("warningshadow")
					shadow.Transform:SetPosition(inst.Transform:GetWorldPosition())
					if inst.prefab == "um_beeguard_seeker" then
						FindSpotForShadow(inst, inst.stabtarget, shadow)
					else
						FindSpotForShadow(inst, inst.stabtarget, shadow) --Aim the shadovv first, the bee aims at the shadovv after that, simple!
					end
					local scaleFactor = Lerp(.5, 1.5, 1)
					shadow.Transform:SetScale(scaleFactor, scaleFactor, scaleFactor)
					shadow.bee = inst
					shadow.updatetask = shadow:DoPeriodicTask(FRAMES, UpdateShadow, nil, 5)
				end
			end,

			onupdate = function(inst)
				local x, y, z = inst.Transform:GetWorldPosition()
				if y < 1 then
					if TheWorld.Map:IsOceanAtPoint(x, 0, z) then
						inst.components.health:Kill()
					else
						inst.DynamicShadow:Enable(true)
						inst.Transform:SetPosition(x, 0, z) --Level out the bee so it's not in the wrong plane
						inst.sg:GoToState("stab")
					end
				end
			end,

			onexit = function(inst)
				StartCollide(inst)
			end,
		},
		State {
			name = "flydown_shooter",
			tags = { "busy", "nosleep", "nofreeze", "noattack", "flight", "mortar" },

			onenter = function(inst)
				StopCollide(inst)
				if inst.circle then
					inst.CircleFormation(inst)
				end
				SpawnPrefab("bee_poof_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
				if inst.SoundEmitter:PlayingSound("buzz") then
					inst.SoundEmitter:KillSound("buzz")
					inst.SoundEmitter:PlaySound(inst.sounds.buzz, "buzz")
				end
				StartBuzz(inst)
				inst.components.locomotor:StopMoving()
				inst.AnimState:PushAnimation("walk_loop", true)
				local horizVel = 3
				local verticalVel = 40
				if inst.target then
					local shadow = SpawnPrefab("warningshadow")
					if inst.circle then
						shadow.Transform:SetPosition(inst.Transform:GetWorldPosition())
					elseif inst.pos1 then
						shadow.Transform:SetPosition(inst.pos1.x, inst.pos1.y, inst.pos1.z)
					end
					local scaleFactor = Lerp(.5, 1.5, 1)
					shadow.Transform:SetScale(scaleFactor, scaleFactor, scaleFactor)
					shadow.bee = inst
					shadow.updatetask = shadow:DoPeriodicTask(FRAMES, UpdateShadowShooter, nil, 5)
				end
			end,

			onupdate = function(inst)
				local x, y, z = inst.Transform:GetWorldPosition()
				if y < 1 then
					inst.DynamicShadow:Enable(true)
					inst.Transform:SetPosition(x, 0, z) --Level out the bee so it's not in the wrong plane
					inst.sg:GoToState("lineshoot")
				end
			end,

			onexit = function(inst)
				if inst.circle then
					StartCollide(inst)
				end
			end,
		},
		State {
			name = "stab",
			tags = { "busy", "nosleep", "nofreeze", "attack", "noattack", "mortar" }, --We don't want the beeguard to try and attack, but we do need to let the game know this is an attacking state.

			onenter = function(inst)
				inst.stuck = true
				inst.stuckcount = 0
				SpawnPrefab("bee_poof_small").Transform:SetPosition(inst.Transform:GetWorldPosition()) --I like the effects XD
				if inst.SoundEmitter:PlayingSound("buzz") then
					inst.SoundEmitter:KillSound("buzz")
					inst.SoundEmitter:PlaySound(inst.sounds.buzz, "buzz")
				end
				StopBuzz(inst)
				inst.components.locomotor:StopMoving()
				if inst.prefab == "um_beeguard_seeker" then
					inst.AnimState:PlayAnimation("stab_death", false)
				else
					inst.AnimState:PlayAnimation("stab_pst", false)
				end
			end,

			timeline = {
				TimeEvent(3 * FRAMES, function(inst)
					inst.SoundEmitter:PlaySound(inst.sounds.attack)
					inst.components.combat:SetDefaultDamage(2 * TUNING.BEEGUARD_DAMAGE)
					inst.components.combat:DoAreaAttack(inst, 2, nil, nil, nil,
						{ "INLIMBO", "bee", "notarget", "invisible", "playerghost", "shadow" })
					inst.components.combat:SetDefaultDamage(TUNING.BEEGUARD_DAMAGE)
					if inst.prefab == "um_beeguard_seeker" and inst.components.health and not inst.components.health:IsDead() then
						inst.stabdied = true
						inst.components.health:Kill()
					end
				end),
			},

			events =
			{
				EventHandler("animover", function(inst)
					StopCollide(inst)
					inst.sg:GoToState("stuck")
				end),
			},
			onexit = function(inst)
				inst.stuck = nil
			end,
		},

		State {
			name = "stuck",
			tags = { "busy", "stuck" },

			onenter = function(inst)
				StartBuzz(inst)
				inst.SoundEmitter:PlaySound(inst.sounds.hit)
				inst.components.locomotor:StopMoving()
				if inst.stuckcount > 5 then
					inst.AnimState:PushAnimation("stuck_pst", false)
				else
					inst.AnimState:PlayAnimation("stuck_loop", false)
				end
			end,

			timeline =
			{
				TimeEvent(10 * FRAMES, function(inst)
					StopBuzz(inst)
				end),
			},

			events =
			{
				EventHandler("animqueueover", function(inst)
					if inst.components.health and not inst.components.health:IsDead() then
						if inst.stuckcount > 5 then
							StartCollide(inst)
							inst.sg:GoToState("idle")
						else
							inst.stuckcount = inst.stuckcount + 1
							inst.sg:GoToState("stuck")
						end
					end
				end),
			},
		},
		State { --Need the shooter bees to stand still vvhen they're going to shoot in a line
			name = "lineshoot",
			tags = { "busy", "stuck" },

			onenter = function(inst)
				StartBuzz(inst)
				inst.SoundEmitter:PlaySound(inst.sounds.hit)
				inst.components.locomotor:StopMoving()
				inst.AnimState:PlayAnimation("idle", true)
			end,
		},

		State {
			name = "shoot_pre",
			tags = { "busy" },

			onenter = function(inst)
				if inst.target and inst.target:IsValid() then
					inst:ForceFacePoint(inst.target:GetPosition())
				end
				inst.SoundEmitter:PlaySound(inst.sounds.attack)
				if inst.circle then
					inst.components.linearcircler.distance_limit = 12
					inst.components.linearcircler:Start()
				end
				inst.AnimState:PlayAnimation("shoot_pre", true)

				inst:DoTaskInTime(1, function(inst) inst.Shoot(inst) end)
			end,

			onupdate = function(inst)
				if inst.components.linearcircler and inst.components.linearcircler.distance < 12 then
					inst.components.linearcircler.distance = 0.1 + inst.components.linearcircler.distance
				end
			end,
		},
		State {
			name = "charge", --CHARGE! Beeguards charge at the player in formation.
			tags = { "attack", "busy", "nofreeze", "nosleep", "noattack", "flight", "moving" }, --Tags galore...

			onenter = function(inst)
				inst.armorcrunch = true
				StopCollide(inst)
				inst.brain:Stop()
				inst.components.combat:RestartCooldown()
				SpawnPrefab("bee_poof_small").Transform:SetPosition(inst.Transform:GetWorldPosition()) --I like the effects XD
				if inst.SoundEmitter:PlayingSound("buzz") then
					inst.SoundEmitter:KillSound("buzz")
					inst.SoundEmitter:PlaySound(inst.sounds.buzz, "buzz")
				end
				inst.alreadyStabbed = {}
				inst.AnimState:PlayAnimation("run_loop", true)
			end,

			onupdate = function(inst)
				inst:ForceFacePoint(inst.chargePoint)
				ArtificialLocomote(inst, inst.chargePoint, inst.chargeSpeed)
				local stabbed = FindEntity(inst, 1, function(guy)
					for i, ent in ipairs(inst.alreadyStabbed) do
						if guy == ent then
							return false
						end
					end
					return true
				end,
					{ "_combat" }, { "bee", "shadow", "beehive" })
				if stabbed then
					table.insert(inst.alreadyStabbed, stabbed)
					if stabbed.components.health and not stabbed.components.health:IsDead() then
						local mult = (stabbed:HasTag("player") and 2) or 1
						stabbed.components.combat:GetAttacked(inst, mult * 75)
					end
				end
				if inst:IsValid() and inst:GetDistanceSqToPoint(inst.chargePoint) < 1 then
					inst.holdPoint = inst.chargePoint
					inst.sg:GoToState("hold_position")
				end
			end,

			onexit = function(inst)
				StartCollide(inst)
				inst.brain:Start()
				inst.armorcrunch = false
			end,

		},
		State {
			name = "hold_position", --All this does is make the beeguard stick on a single position after he finishes charging
			tags = { "busy", "nofreeze", "nosleep", "flight" }, --Tags galore...

			onenter = function(inst)
				StopCollide(inst)
				inst.holding = true
				inst.brain:Stop()
				inst.components.combat:RestartCooldown()
				inst.AnimState:PlayAnimation("idle", true)
				--inst:DoTaskInTime(3,function(inst) inst.sg:GoToState("charge") end) --Temp
				inst.sg:SetTimeout(5)
			end,

			ontimeout = function(inst)
				inst.sg:GoToState("idle")
			end,

			onupdate = function(inst)
				if inst.holdPoint then
					inst.Transform:SetPosition(inst.holdPoint.x, inst.holdPoint.y, inst.holdPoint.z)
				end
			end,

			onexit = function(inst)
				StartCollide(inst)
				inst.brain:Start()
				inst.holding = false
			end,
		},
		State {
			name = "hold_position_ring", --All this does is make the beeguard stick on a single position after he finishes charging
			tags = { "busy", },

			onenter = function(inst)
				inst.brain:Stop()
				StopCollide(inst)
				inst.AnimState:PlayAnimation("idle", true)
				inst.holding = true
			end,

			onupdate = function(inst)
				--[[if inst.components.combat and inst.components.combat.target then
				inst:ForceFacePoint(inst.components.combat.target:GetPosition())
			end]]
				local queen = inst.components.entitytracker:GetEntity("queen")
				local x, y, z = inst.Transform:GetWorldPosition()
				if inst.beeHolder and inst.beeHolder:IsValid() and queen and queen:IsValid() and
					math.sqrt(queen:GetDistanceSqToInst(inst.beeHolder)) < 20 then
					local x, y, z = inst.beeHolder.Transform:GetWorldPosition()
					if x == x and z == z then
						inst.Transform:SetPosition(x, y, z)
					end
				end
			end,

			onexit = function(inst)
				StartCollide(inst)
				inst.holding = false
			end,
		},
		State {
			name = "rally_at_point", --Similar to CHARGE but doesn't do damage, bees are just getting ready to charge
			tags = { "attack", "busy", "nofreeze", "nosleep", "noattack", "flight", "moving" }, --Tags galore...

			onenter = function(inst)
				StopCollide(inst)
				inst.brain:Stop()
				inst.components.combat:RestartCooldown()
				if inst.SoundEmitter:PlayingSound("buzz") then
					inst.SoundEmitter:KillSound("buzz")
					inst.SoundEmitter:PlaySound(inst.sounds.buzz, "buzz")
				end
				inst.AnimState:PlayAnimation("run_loop", true)
			end,

			onupdate = function(inst)
				if inst.beeHolder and inst.beeHolder:IsValid() then
					local position = inst.beeHolder:GetPosition()
					inst:ForceFacePoint(inst.beeHolder:GetPosition())
					ArtificialLocomote(inst, position, inst.chargeSpeed)
					if inst:IsValid() and inst:GetDistanceSqToPoint(position) < 1 then
						inst.sg:GoToState("hold_position_ring")
					end
				else
					inst:ForceFacePoint(inst.rallyPoint)
					ArtificialLocomote(inst, inst.rallyPoint, inst.chargeSpeed)
					if inst.rallyPoint and inst:IsValid() and inst:GetDistanceSqToPoint(inst.rallyPoint) and
						inst:GetDistanceSqToPoint(inst.rallyPoint) < 1 then
						inst.holdPoint = inst.rallyPoint
						inst.sg:GoToState("hold_position")
					end
				end
			end,

			onexit = function(inst)
				StartCollide(inst)
				inst.brain:Start()
				if inst.rallyPoint and inst:IsValid() and inst:GetDistanceSqToPoint(inst.rallyPoint) > 1 then
					--inst:DoTaskInTime(0.05,function(inst) TheNet:Announce("Tried to go to"..inst.sg.currentstate.name) end)
					inst:DoTaskInTime(0.1, function(inst)
						inst.sg:GoToState("rally_at_point")
					end)
				end
			end,
		},

		State {
			name = "defensiveattack",
			tags = { "attack", "busy", "caninterrupt" },

			onenter = function(inst)
				inst.components.locomotor:StopMoving()
				inst.AnimState:PlayAnimation("atk")
				inst.components.combat:StartAttack()
				inst.sg.statemem.target = inst.components.combat.target
			end,

			timeline =
			{
				TimeEvent(10 * FRAMES, function(inst)
					inst.SoundEmitter:PlaySound(inst.sounds.attack)
				end),
				TimeEvent(13 * FRAMES, function(inst)
					inst.components.combat:DoAttack(inst.sg.statemem.target)
				end),
				TimeEvent(21 * FRAMES, function(inst)
					inst.sg:RemoveStateTag("busy")
				end),
			},

			onupdate = function(inst)
				if inst.components.combat and inst.components.combat.target then
					inst:ForceFacePoint(inst.components.combat.target:GetPosition())
				end
				if inst.beeHolder and inst.beeHolder:IsValid() then
					local x, y, z = inst.beeHolder.Transform:GetWorldPosition()
					inst.Transform:SetPosition(x, y, z)
				end
			end,

			events =
			{
				EventHandler("animover", function(inst)
					inst.sg:GoToState("hold_position_ring")
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
