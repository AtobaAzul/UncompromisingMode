local env = env
GLOBAL.setfenv(1, GLOBAL)

local function UpdateCooldown1(inst)
	local x, y, z = inst.Transform:GetWorldPosition()

	local playercount = #TheSim:FindEntities(x, y, z, 50, {"player"}, {"playerghost"}) or 1

	if playercount <= 1 then
		playercount = 1
	end

	if playercount > 6 then
		inst._cooldowns.charge = 3.5
		inst._cooldowns.mouthcharge = 7
		inst._cooldowns.spawn = 5.4
	else
		inst._cooldowns.charge = 3.5 + (3.5 / playercount)
		inst._cooldowns.mouthcharge = 7 + (7 / playercount)
		inst._cooldowns.spawn = 5.4 + (10.8 / playercount)
	end

	local bosscount = TheSim:FindEntities(x, y, z, 20, {"epic"}, {"twinofterror"})

	if bosscount ~= nil and #bosscount > 0 then
		inst:PushEvent("leave")
		inst:PushEvent("turnoff_terrarium")

		local terrarium = TheSim:FindFirstEntityWithTag("terrarium")

		if terrarium ~= nil then
			terrarium.components.activatable.inactive = TUNING.SPAWN_EYEOFTERROR
			terrarium.AnimState:Show("terrarium_tree")
			terrarium.components.inventoryitem:ChangeImageName(nil) -- back to default
		end
	end
end

local function OnAttacked(inst, data)
    if data.attacker and not inst.components.commander:IsSoldier(data.attacker) then
		inst.components.combat:ShareTarget(data.attacker, 50, function(dude)
			local should_share = dude:HasTag("twinofterror")
				--and dude.prefab == "eyeofterror2"
				and not dude.components.health:IsDead()

				if should_share and dude.components.sleeper ~= nil then
					dude.components.sleeper:WakeUp()
				end

				if should_share and dude.components.combat.target == nil then
					dude.components.combat:SetTarget(data.attacker)
				end

			return should_share
		end, 5)
    end
end

local function teleport_override_fn(inst)
    local ipos = inst:GetPosition()
    local offset = FindWalkableOffset(ipos, 2*PI*math.random(), 10, 8, true, false)
        or FindWalkableOffset(ipos, 2*PI*math.random(), 14, 8, true, false)

    return (offset ~= nil and ipos + offset) or ipos
end

env.AddPrefabPostInit("twinofterror1", function(inst)

	inst:AddTag("twinofterror")

	if not TheWorld.ismastersim then
		return
	end

    inst:AddComponent("teleportedoverride")
    inst.components.teleportedoverride:SetDestPositionFn(teleport_override_fn)

	--if inst.components.health ~= nil then
		--inst.components.health:SetMaxHealth(TUNING.DSTU.TWIN1_HEALTH)
	--end

    inst:ListenForEvent("attacked", OnAttacked)

	inst:DoPeriodicTask(5, UpdateCooldown1)
end)

local function UpdateCooldown2(inst)
	local x, y, z = inst.Transform:GetWorldPosition()

	local playercount = #TheSim:FindEntities(x, y, z, 50, {"player"}, {"playerghost"}) or 1

	if playercount <= 1 then
		playercount = 1
	elseif playercount >= 6 then
		playercount = 6
	end

	inst._cooldowns.charge = 1.75 + (1.75 / playercount)
	inst._cooldowns.mouthcharge = 3.75 + (3.75 / playercount)
	inst._cooldowns.spawn = 18 + (36 / playercount)

	local bosscount = TheSim:FindEntities(x, y, z, 20, {"epic"}, {"twinofterror"})

	if bosscount ~= nil and #bosscount > 0 then
		inst:PushEvent("leave")
		inst:PushEvent("turnoff_terrarium")

		local terrarium = TheSim:FindFirstEntityWithTag("terrarium")

		if terrarium ~= nil then
			terrarium.components.activatable.inactive = TUNING.SPAWN_EYEOFTERROR
			terrarium.AnimState:Show("terrarium_tree")
			terrarium.components.inventoryitem:ChangeImageName(nil) -- back to default
		end
	end
end

env.AddPrefabPostInit("twinofterror2", function(inst)

	inst:AddTag("twinofterror")

	if not TheWorld.ismastersim then
		return
	end

    inst:AddComponent("teleportedoverride")
    inst.components.teleportedoverride:SetDestPositionFn(teleport_override_fn)

	--if inst.components.health ~= nil then
		--inst.components.health:SetMaxHealth(TUNING.DSTU.TWIN2_HEALTH)
	--end

    inst:ListenForEvent("attacked", OnAttacked)

	inst:DoPeriodicTask(5, UpdateCooldown2)
end)

local function UpdateCooldown(inst)
	local x, y, z = inst.Transform:GetWorldPosition()

	local bosscount = TheSim:FindEntities(x, y, z, 20, {"epic"}, {"twinofterror"})

	if bosscount ~= nil and #bosscount > 0 then
		inst:PushEvent("leave")
		inst:PushEvent("turnoff_terrarium")

		local terrarium = TheSim:FindFirstEntityWithTag("terrarium")

		if terrarium ~= nil then
			terrarium.components.activatable.inactive = TUNING.SPAWN_EYEOFTERROR
			terrarium.AnimState:Show("terrarium_tree")
			terrarium.components.inventoryitem:ChangeImageName(nil) -- back to default
		end
	end
end

env.AddPrefabPostInit("eyeofterror", function(inst)

	inst:AddTag("twinofterror")
	inst:AddTag("fleshyeye")

	if not TheWorld.ismastersim then
		return
	end

	inst:DoPeriodicTask(5, UpdateCooldown)
end)
