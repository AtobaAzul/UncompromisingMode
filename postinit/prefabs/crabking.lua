local env = env
GLOBAL.setfenv(1, GLOBAL)

local function removecrab(inst)
	inst.crab = nil
	inst:Remove()
end

local CRABKING_SPELLGENERATOR_TAGS = { "crabking_spellgenerator" }

--I LOVE MATH!!!
--I almost went down a Bézier curve rabbithole.

local function DoLineAttack(inst, rand_start)
	local ck_x, ck_y, ck_z = inst.Transform:GetWorldPosition()
	local target = #inst.all_targets > 1 and inst.all_targets[math.random(#inst.all_targets)] or
		inst.components.combat ~= nil and inst.components.combat.target

	if target == nil then
		local boats = TheSim:FindEntities(ck_x, ck_y, ck_z, 25, { "boat" })
		if #boats > 0 then
			target = boats[math.random(#boats)]
		end
	end

	if target ~= nil then
		local tar_x, tar_y, tar_z = target.Transform:GetWorldPosition()

		local variance_x, variance_z = math.random(-24, 24), math.random(-24, 24)

		if variance_x > 0 then --wonder if there's anything I could do to make this better
			variance_x = math.clamp(variance_x, 16, 24)
		else
			variance_x = math.clamp(variance_x, -16, -24)
		end

		if variance_z > 0 then
			variance_z = math.clamp(variance_z, 16, 24)
		else
			variance_z = math.clamp(variance_z, -16, -24)
		end
		local start_x, start_y, start_z

		if rand_start then
			start_x, start_y, start_z = tar_x + variance_x, tar_y, tar_z + variance_z
		else
			start_x, start_y, start_z = ck_x, ck_y, ck_z
			tar_x, tar_z = tar_x + variance_x * 0.1, tar_z + variance_z * 0.1
		end

		local deg = math.atan2(start_z - tar_z, tar_x - start_x) / DEGREES

		local rad = math.rad(deg)

		local velx = math.cos(rad) * 2.5
		local velz = -math.sin(rad) * 2.5

		local dist = distsq(start_x, start_z, tar_x, tar_z)

		dist = math.sqrt(dist)

		if not rand_start then
			dist = dist + 8
		end

		for i = 1, math.clamp(dist, 0, 24) do
			inst:DoTaskInTime(FRAMES * i, function()
				local dx, dy, dz = start_x + (i * velx), 0, start_z + (i * velz)

				local fx = SpawnPrefab("crabking_geyser_single")
				fx.Transform:SetPosition(dx, dy, dz)
				fx.chain_time = i
				fx.crab = inst
				fx.fisher_prefab = inst.prefab
				fx:ListenForEvent("onremove", function() removecrab(fx) end, inst)
				fx.dogeyserburbletask(fx)
			end)
		end
	end
end

local function DoSeekingAttack(inst)
	local ck_x, ck_y, ck_z = inst.Transform:GetWorldPosition()
	local target = #inst.all_targets > 1 and inst.all_targets[math.random(#inst.all_targets)] or
		inst.components.combat ~= nil and inst.components.combat.target

	if target == nil then
		local boats = TheSim:FindEntities(ck_x, ck_y, ck_z, 25, { "boat" })
		if #boats > 0 then
			target = boats[math.random(#boats)]
		end
	end

	if target ~= nil then
		local ix, iy, iz = inst.Transform:GetWorldPosition()
		local targetfocus = target

		local px, py, pz = targetfocus.Transform:GetWorldPosition()

		local dist = math.sqrt(distsq(ix, iz, px, pz)) + 24

		for i = 1, math.clamp(dist, 0, 48) do
			--local px, py, pz = targetfocus.Transform:GetWorldPosition()
			inst:DoTaskInTime((FRAMES * i) * Lerp(0, 1, dist / 10), function()
				if targetfocus == nil then
					return
				end
				px, py, pz = targetfocus.Transform:GetWorldPosition()
				if px == nil or pz == nil then
					return
				end
				local deg = math.atan2(iz - pz, px - ix) / DEGREES

				local rad = math.rad(deg)

				local velx = math.cos(rad)
				local velz = -math.sin(rad)

				local dx, dy, dz = ix + (i * velx), 0, iz + (i * velz)

				if targetfocus ~= nil then
					local fx = SpawnPrefab("crabking_geyser_single")
					fx.Transform:SetPosition(dx, dy, dz)
					fx.chain_time = i
					fx.crab = inst
					fx.fisher_prefab = inst.prefab
					fx:ListenForEvent("onremove", function() removecrab(fx) end, inst)
					fx.dogeyserburbletask(fx)
				end
			end)
		end
	end
end

local function spawnwaves(inst, numWaves, totalAngle, waveSpeed, wavePrefab, initialOffset, idleTime, instantActivate,
						  random_angle)
	SpawnAttackWaves(
		inst:GetPosition(),
		(not random_angle and inst.Transform:GetRotation()) or nil,
		initialOffset or (inst.Physics and inst.Physics:GetRadius()) or nil,
		numWaves,
		totalAngle,
		waveSpeed,
		wavePrefab,
		idleTime,
		instantActivate
	)
end

local function spawnwave(inst, time)
	spawnwaves(inst, 12, 360, Lerp(2, 6, inst.countgems(inst).blue / 10), nil, 2.5, time or 2, true, true)

	--need to manually push boats without being the waves, as the waves can try spawning on the boat itself, and then not moving it.
	local x, y, z = inst.Transform:GetWorldPosition()
	local boats = TheSim:FindEntities(x, y, z, 12, nil, nil, { "boat" })
	for k, v in ipairs(boats) do
		local bx, by, bz = v.Transform:GetWorldPosition()
		local push_dir_x, push_dir_z = VecUtil_Normalize(bx - x, bz - z)
		v.components.boatphysics:ApplyForce(push_dir_x, push_dir_z, Lerp(2, 6, inst.countgems(inst).blue / 10))
	end
end

local RETARGET_MUST_TAGS = { "_combat", }
local RETARGET_CANT_TAGS = { "wall", "INLIMBO", "prey", "bird", "crab" }
local TARGET_DIST = 48

local function RetargetFn(inst)
	local range = inst:GetPhysicsRadius(0) + 8
	local x, y, z = inst.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x, y, z, TARGET_DIST, RETARGET_MUST_TAGS, RETARGET_CANT_TAGS)
	inst.all_targets = {}

	for k, v in ipairs(ents) do
		if inst.components.combat:CanTarget(v)
			and (v.components.combat:TargetIs(inst) or v:IsNear(inst, range)) then
			table.insert(inst.all_targets, v)
		end
	end

	return FindEntity(
		inst,
		TARGET_DIST,
		function(guy)
			return inst.components.combat:CanTarget(guy)
				and (guy.components.combat:TargetIs(inst) or
				guy:IsNear(inst, range)
				)
		end,
		RETARGET_MUST_TAGS,
		RETARGET_CANT_TAGS
	)
end

local gems =
{
	"blue",
	"red",
	"purple",
	"orange",
	"yellow",
	"green",
}
if env.GetModConfigData("ck_loot") then
	SetSharedLootTable('crabkingy',
		{
			{ "chesspiece_crabking_sketch", 1.00 },
			--{"trident_blueprint",                   1.00},
			{ 'meat',                       1.00 },
			{ 'meat',                       1.00 },
			{ 'meat',                       1.00 },
			{ 'meat',                       1.00 },
			{ 'meat',                       1.00 },
			{ 'meat',                       1.00 },
			{ 'meat',                       1.00 },
			{ "singingshell_octave5",       1.00 },
			{ "singingshell_octave5",       1.00 },
			{ "singingshell_octave5",       1.00 },
			{ "singingshell_octave5",       1.00 },
			{ "singingshell_octave5",       0.50 },
			{ "singingshell_octave5",       0.25 },
			{ "singingshell_octave4",       1.00 },
			{ "singingshell_octave4",       1.00 },
			{ "singingshell_octave4",       1.00 },
			{ "singingshell_octave4",       0.50 },
			{ "singingshell_octave4",       0.25 },
			{ "singingshell_octave3",       1.00 },
			{ "singingshell_octave3",       1.00 },
			{ "singingshell_octave3",       0.50 },
			{ "barnacle",                   1.00 },
			{ "barnacle",                   1.00 },
			{ "barnacle",                   1.00 },
			{ "barnacle",                   0.25 },
			{ "barnacle",                   0.25 },
			{ "barnacle",                   0.25 },
			{ "barnacle",                   0.25 },
		})
end

local function OnAttacked(inst, data)
	if data.attacker.ck_attack_quote_cd ~= nil then
		data.attacker.ck_attack_quote_cd:Cancel()
		data.attacker.ck_attack_quote_cd = nil
		data.attacker.ck_attack_quote_cd = data.attacker:DoTaskInTime(10, function()
		end)
	end

	if data.attacker:HasTag("player") and data.attacker.components.talker ~= nil and data.attacker.ck_attack_quote_cd == nil then
		data.attacker.components.talker:Say(GetString(inst, "ATTACKED_CRABKING"))
		data.attacker.ck_attack_quote_cd = data.attacker:DoTaskInTime(10, function()
		end)
	end
end

env.AddPrefabPostInit("crabking", function(inst)
	inst:AddTag("crab")

	if not TheWorld.ismastersim then
		return
	end

	inst:ListenForEvent("attacked", OnAttacked)

	inst:RemoveComponent("burnable")
	inst:RemoveComponent("propagator")

	if env.GetModConfigData("ck_loot") then
		if inst.components.lootdropper ~= nil then
			inst.components.lootdropper:SetChanceLootTable('crabkingy')
		end
	end

	inst.attack_count = 0

	if inst.components.combat ~= nil then
		inst.components.combat:SetRetargetFunction(1, RetargetFn)
	end

	inst.wantstocast = true

	--local _startcastspell = inst.startcastspell
	local _endcastspell = inst.endcastspell

	inst.endcastspell = function(inst, lastwasfreeze)
		_endcastspell(inst, lastwasfreeze)

		local atk_cd = (TUNING.CRABKING_CAST_TIME - math.floor(inst.countgems(inst).yellow * 0.75)) * 0.2

		if inst.components.timer:TimerExists("spell_cooldown") then
			inst.components.timer:StopTimer("spell_cooldown")
		end

		inst.dofreezecast = nil -- NO FREEZE, BAD!

		local x, y, z = inst.Transform:GetWorldPosition()
		local ents = TheSim:FindEntities(x, y, z, 64, nil, nil, CRABKING_SPELLGENERATOR_TAGS)
		if #ents > 0 then
			for i, ent in pairs(ents) do
				if (not inst.components.freezable or not inst.components.freezable:IsFrozen()) and not inst.components.health:IsDead() then
					ent:PushEvent("endspell")
				else
					ent:Remove()
				end
			end
		end

		inst.attack_count = math.clamp(inst.attack_count + 1, 0, 10)

		if inst.attack_count > math.random(2, 4) then
			inst.components.timer:StartTimer("spell_cooldown", 30 - inst.countgems(inst).yellow)

			inst.vulnerable_shine_task = inst:DoPeriodicTask(2, function()
				for k, v in ipairs(gems) do
					inst.gemshine(inst, v)
				end
				inst.wantstocast = false --keep it that way!!!
			end)

			inst.long_cd = inst:DoTaskInTime(30 - inst.countgems(inst).yellow, function()
				inst.wantstocast = true
				inst.attack_count = 0
				if inst.vulnerable_shine_task ~= nil then
					inst.vulnerable_shine_task:Cancel()
					inst.vulnerable_shine_task = nil
				end
				spawnwave(inst)
			end)
		else
			inst.components.timer:StartTimer("spell_cooldown", atk_cd)
			inst:DoTaskInTime(atk_cd, function()
				inst.wantstocast = true
			end)
		end
	end

	inst.startcastspell = function(inst, freeze)
		for i = 1, math.clamp(3 + (#inst.all_targets - 1), 1, 10) do
			if math.random() >= 0.25 then
				if math.random() >= 0.66 then
					inst:DoTaskInTime(i * GetRandomWithVariance(0.5, 0.75), function()
						DoLineAttack(inst, true)
					end)
				else
					inst:DoTaskInTime(i * GetRandomWithVariance(0.5, 0.75), function()
						DoLineAttack(inst, false)
					end)
					--_startcastspell(inst, false)
				end
			else
				DoSeekingAttack(inst)
			end
		end
	end

	inst.components.lootdropper:AddChanceLoot("dormant_rain_horn", 1.00)

	local types =
	{
		"red",
		"blue",
		"purple",
		"yellow",
		"orange",
		"rainbow",
		"green",
	}

    inst:ListenForEvent("death", function(inst)
		if inst.long_cd ~= nil then
            inst.long_cd:Cancel()
			inst.long_cd = nil
		end

		if env.GetModConfigData("ck_loot") then
			TheWorld.crabking_active = false

			local pos = inst:GetPosition()
			local messagebottletreasures = require("messagebottletreasures_um")
			local pearl = inst.countgems(inst).pearl * 1.5
			local red = inst.countgems(inst).red - pearl
			local blue = inst.countgems(inst).blue - pearl
			local purple = inst.countgems(inst).purple - pearl
			local yellow = inst.countgems(inst).yellow - pearl
			local orange = inst.countgems(inst).orange - pearl
			local green = inst.countgems(inst).green - pearl
			local opal = inst.countgems(inst).opal
			local count = 0

			if math.random(6) < opal then
				messagebottletreasures.GenerateTreasure(pos, "sunkenchest_royal_rainbow").Transform:SetPosition(
					pos.x + math.random(-4, 4), pos.y, pos.z + math.random(-4, 4))
				count = count + 1
				if count > 3 then return end
			end

			if math.random(6) < red then
				messagebottletreasures.GenerateTreasure(pos, "sunkenchest_royal_red").Transform:SetPosition(
					pos.x + math.random(-4, 4), pos.y, pos.z + math.random(-4, 4))
				count = count + 1
				if count > 3 then return end
			end

			if math.random(6) < blue then
				messagebottletreasures.GenerateTreasure(pos, "sunkenchest_royal_blue").Transform:SetPosition(
					pos.x + math.random(-4, 4), pos.y, pos.z + math.random(-4, 4))
				count = count + 1
				if count > 3 then return end
			end

			if math.random(6) < purple then
				messagebottletreasures.GenerateTreasure(pos, "sunkenchest_royal_purple").Transform:SetPosition(
					pos.x + math.random(-4, 4), pos.y, pos.z + math.random(-4, 4))
				count = count + 1
				if count > 3 then return end
			end

			if math.random(6) < yellow then
				messagebottletreasures.GenerateTreasure(pos, "sunkenchest_royal_yellow").Transform:SetPosition(
					pos.x + math.random(-4, 4), pos.y, pos.z + math.random(-4, 4))
				count = count + 1
				if count > 3 then return end
			end

			if math.random(6) < orange then
				messagebottletreasures.GenerateTreasure(pos, "sunkenchest_royal_orange").Transform:SetPosition(
					pos.x + math.random(-4, 4), pos.y, pos.z + math.random(-4, 4))
				count = count + 1
				if count > 3 then return end
			end

			if math.random(6) < green then
				messagebottletreasures.GenerateTreasure(pos, "sunkenchest_royal_green").Transform:SetPosition(
					pos.x + math.random(-4, 4), pos.y, pos.z + math.random(-4, 4))
				count = count + 1
				if count > 3 then return end
			end

			if count == 0 then
				messagebottletreasures.GenerateTreasure(pos, "sunkenchest_royal_" .. types[math.random(#types)])
					.Transform:SetPosition(
					pos.x + math.random(-4, 4), pos.y, pos.z + math.random(-4, 4))
				count = count + 1
			end
		end
	end)

	local function OnCollide(inst, data)
		local boat_physics = data.other.components.boatphysics

		if (math.abs(boat_physics:GetVelocity() * data.hit_dot_velocity)) < 1.2 then
			return
		end

		if boat_physics ~= nil then
			if inst.components.health ~= nil then
				inst.components.health:DoDelta((-1500 * math.abs(boat_physics:GetVelocity() * data.hit_dot_velocity)) *
					0.33)
			end
		end

		inst.finishfixing(inst)

		if inst.attack_count <= 2 then
			inst:DoTaskInTime(3, function(inst)
				if inst.components.timer:TimerExists("claw_regen_timer") then
					inst.components.timer:StopTimer("claw_regen_timer")
				end
				inst.regenarm(inst)
			end)
		end
		spawnwave(inst)

		if inst.vulnerable_shine_task ~= nil then
			inst.vulnerable_shine_task:Cancel()
			inst.vulnerable_shine_task = nil
			inst.long_cd:Cancel()
			inst.long_cd = nil

			inst.wantstocast = true
			inst.attack_count = 0
		else
			inst.attack_count = math.clamp(inst.attack_count - 1, 0, 10)
		end
	end

	inst:ListenForEvent("activate", function()
		inst:DoTaskInTime(5, function()
			inst.wantstocast = true
			inst.attack_count = 0
			if inst.vulnerable_shine_task ~= nil then
				inst.vulnerable_shine_task:Cancel()
				inst.vulnerable_shine_task = nil
			end
			TheWorld.crabking_active = true
		end)
		inst:ListenForEvent("on_collide", OnCollide)
	end)

	inst:ListenForEvent("entitysleep", function(inst)
		inst:RemoveEventCallback("on_collide", OnCollide)
		TheWorld.crabking_active = false
	end)

	inst:ListenForEvent("unfreeze", function()
		inst.attack_count = math.clamp(inst.attack_count + -2, 0, 10)
		inst.gemshine(inst, "blue")
		local x, y, z = inst.Transform:GetWorldPosition()
		local fx = SpawnPrefab("crabking_feeze")
		fx.crab = inst
		fx:ListenForEvent("onremove", function() removecrab(fx) end, inst)
		fx.Transform:SetPosition(x, y, z)
		local scale = 0.75 + Remap(inst.countgems(inst).blue, 0, 9, 0, 1.55)
		fx.Transform:SetScale(scale, scale, scale)
	end)
end)
