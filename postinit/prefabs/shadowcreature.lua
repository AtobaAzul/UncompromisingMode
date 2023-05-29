local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

local function onkilledbyother(inst, attacker)
    if attacker ~= nil and attacker.components.sanity ~= nil then
		local x, y, z = inst.Transform:GetWorldPosition()
		local ents = TheSim:FindEntities(x, y, z, 15, { "player" }, { "playerghost" } )
		
		inst.halfreward =  TUNING.SANITY_SMALL / 2
		
		if inst.sanityreward ~= nil then
			inst.halfreward = inst.sanityreward / 2
		end
		
		if inst.sanityreward ~= nil then
			inst.quarterreward = inst.sanityreward / 4
		end
		
		for i, v in ipairs(ents) do
			if v ~= attacker and v.components.sanity ~= nil and inst.sanityreward ~= nil then
				if v.components.sanity:IsInsane() then
					v.components.sanity:DoDelta(inst.halfreward)
				else
					v.components.sanity:DoDelta(inst.quarterreward)
				end
			end
		end
    end
	
	return inst.Oldonkilledbyother(inst, attacker)
end

local function retargetfn(inst)
	local maxrangesq = TUNING.SHADOWCREATURE_TARGET_DIST * TUNING.SHADOWCREATURE_TARGET_DIST
	local rangesq, rangesq1, rangesq2 = maxrangesq, math.huge, math.huge
	local target1, target2 = nil, nil
	for i, v in ipairs(AllPlayers) do
		if v.components.sanity:IsCrazy() and not v:HasTag("playerghost") and not v:HasTag("notarget_shadow") then
			local distsq = v:GetDistanceSqToInst(inst)
			if distsq < rangesq then
				if inst.components.shadowsubmissive:TargetHasDominance(v) then
					if distsq < rangesq1 and inst.components.combat:CanTarget(v) then
						target1 = v
						rangesq1 = distsq
						rangesq = math.max(rangesq1, rangesq2)
					end
				elseif distsq < rangesq2 and inst.components.combat:CanTarget(v) then
					target2 = v
					rangesq2 = distsq
					rangesq = math.max(rangesq1, rangesq2)
				end
			end
		end
	end

	if target1 ~= nil and rangesq1 <= math.max(rangesq2, maxrangesq * .25) then
		--Targets with shadow dominance have higher priority within half targeting range
		--Force target switch if current target does not have shadow dominance
		return target1, not inst.components.shadowsubmissive:TargetHasDominance(inst.components.combat.target)
	end
	return target2
end

env.AddPrefabPostInit("terrorbeak", function(inst)
	inst:AddTag("terrorbeak")

	if not TheWorld.ismastersim then
		return
	end
	
    inst.sanityreward = TUNING.SANITY_MEDLARGE
	
	if inst.components.combat ~= nil then
        inst.Oldonkilledbyother = inst.components.combat.onkilledbyother
		inst.components.combat.onkilledbyother = onkilledbyother
	end

	inst.components.combat:SetRetargetFunction(3, retargetfn)--yell at me if this causes problems later, I couldn't be bothered to function hook -Atobá

end)

env.AddPrefabPostInit("nightmarebeak", function(inst)
	inst:AddTag("terrorbeak")

	if not TheWorld.ismastersim then
		return
	end

	--inst.components.combat:SetRetargetFunction(3, retargetfn)--yell at me if this causes problems later, I couldn't be bothered to function hook -Atobá

end)

local easing = require("easing")

local function LaunchProjectile(inst)
	local theta = math.random() * 2 * PI
	local r = inst:GetPhysicsRadius(0) + 0.50 + math.sqrt(math.random()) * TUNING.WARG_GINGERBREAD_GOO_DIST_VAR
	local x, y, z = inst.Transform:GetWorldPosition()
	local dest_x, dest_z = math.cos(theta) * r + x, math.sin(theta) * r + z

	local goo = SpawnPrefab("shadow_goo")
    goo.Transform:SetPosition(x, y, z)
	goo.Transform:SetRotation(theta / DEGREES)
	goo._caster = inst

	Launch2(goo, inst, 1.5, 1, 3, .75)
end


local function onkilledbyother_crawlinghorror(inst, attacker)
    if attacker ~= nil and attacker.components.sanity ~= nil then
		local x, y, z = inst.Transform:GetWorldPosition()
		local ents = TheSim:FindEntities(x, y, z, 15, { "player" }, { "playerghost" } )
		
		inst.halfreward =  TUNING.SANITY_SMALL / 2
		
		if inst.sanityreward ~= nil then
			inst.halfreward = inst.sanityreward / 2
		end
		
		if inst.sanityreward ~= nil then
			inst.quarterreward = inst.sanityreward / 4
		end
		
		for i, v in ipairs(ents) do
			if v ~= attacker and v.components.sanity ~= nil then
				if v.components.sanity:IsInsane() then
					v.components.sanity:DoDelta(inst.halfreward)
				else
					v.components.sanity:DoDelta(inst.quarterreward)
				end
			end
		end
    end
	
	return inst.Oldonkilledbyother_crawlinghorror(inst, attacker)
end

env.AddPrefabPostInit("crawlinghorror", function(inst)
	inst:AddTag("crawlinghorror")

	if not TheWorld.ismastersim then
		return
	end
	
	inst.components.combat:SetRetargetFunction(3, retargetfn)--yell at me if this causes problems later, I couldn't be bothered to function hook -Atobá

    inst.sanityreward = TUNING.SANITY_SMALL
	
	if inst.components.combat ~= nil then
        inst.Oldonkilledbyother_crawlinghorror = inst.components.combat.onkilledbyother
		inst.components.combat.onkilledbyother = onkilledbyother_crawlinghorror
	end
	
    inst.LaunchProjectile = LaunchProjectile
end)

env.AddPrefabPostInit("crawlingnightmare", function(inst)
	inst:AddTag("crawlinghorror")


	if not TheWorld.ismastersim then
		return
	end

	--inst.components.combat:SetRetargetFunction(3, retargetfn)--yell at me if this causes problems later, I couldn't be bothered to function hook -Atobá

    inst.LaunchProjectile = LaunchProjectile
end)