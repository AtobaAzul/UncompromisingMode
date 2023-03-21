local env = env
GLOBAL.setfenv(1, GLOBAL)

local function BonusDamage(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x, y, z, 40, { "crabking" })
	if #ents > 0 then
		for i, v in ipairs(ents) do
			if v:IsValid() and not v:IsInLimbo() then
				if v.components.health ~= nil and not v.components.health:IsDead() then
					v.components.health:DoDelta(-inst.components.health.maxhealth)
				end
			end
		end
	end
end

local CLAMPDAMAGE_CANT_TAGS = { "flying", "shadow", "ghost", "playerghost", "FX", "NOCLICK", "DECOR", "INLIMBO" }
local function clamp(inst)
	if inst.boat and not inst.boat.components.health:IsDead() then
		local bumper = FindEntity(inst, 2, nil, { "boatbumper" })

		local x, y, z = inst.boat.Transform:GetWorldPosition()
		local _ents = TheSim:FindEntities(x, y, z, 4)
		local mult = 1
		-- look for the pirate hat
		if _ents and #_ents > 0 then
			for i, ent in ipairs(_ents) do
				if ent:GetCurrentPlatform() and ent:GetCurrentPlatform() == inst then
					if ent:HasTag("boat_health_buffer") then
						mult = 0.33
					end
				end
			end
		end

		if bumper then
			bumper.components.health:DoDelta((-TUNING.CRABKING_CLAW_BOATDAMAGE) * mult)
		else
			inst.boat.components.health:DoDelta((-TUNING.CRABKING_CLAW_BOATDAMAGE) * mult)
		end

		ShakeAllCameras(CAMERASHAKE.VERTICAL, 0.3, 0.03, 0.5, inst.boat, inst.boat:GetPhysicsRadius(4))
		local pos = Vector3(inst.Transform:GetWorldPosition())
		local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, 3, nil, CLAMPDAMAGE_CANT_TAGS)

		for i, v in pairs(ents) do
			if v ~= inst and v:IsValid() and not v:IsInLimbo() then
				if v.components.health ~= nil and
					not v.components.health:IsDead() and
					inst.components.combat:CanTarget(v) then
					inst.components.combat:DoAttack(v)
				end
			end
		end

		ShakeAllCameras(CAMERASHAKE.VERTICAL, 0.3, 0.03, 0.5, inst.boat, inst.boat:GetPhysicsRadius(4))

		if inst.boat.components.boatphysics ~= nil then
			inst.boat.components.boatphysics:AddBoatDrag(inst)
		end

		inst._releaseclamp = function() inst:releaseclamp() end
		inst:ListenForEvent("onremove", inst._releaseclamp, inst.boat)
		inst.clamptask = inst:DoTaskInTime(math.random() + 3, function() inst.crunchboat(inst, inst.boat) end)
	end
end

env.AddPrefabPostInit("crabking_claw", function(inst)
	if not TheWorld.ismastersim then
		return
	end

	inst.clamp = clamp
	inst:AddTag("crab")
	inst:ListenForEvent("death", BonusDamage)
end)
