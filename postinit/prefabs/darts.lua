local env = env
GLOBAL.setfenv(1, GLOBAL)


env.AddPrefabPostInit("blowdart_fire", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	local _attackfn = inst.components.weapon.onattack -- Store the old function.
	
	local function fireattack(inst, attacker, target)
		local groundfire = SpawnPrefab("houndfire")
		groundfire.Transform:SetPosition(target.Transform:GetWorldPosition())
		groundfire.Transform:SetScale(1.1, 1.1, 1.1)
		
		-- This next block is a very cut down version of the 'lootdropper' component.
		local function spawn_extra_fire(target)
			local dropitem = SpawnPrefab("houndfire")
			local pt = target:GetPosition()
			
			local angle = math.random(359)
			local sinangle = math.sin(angle)
			local cosangle = math.cos(angle)
			local speed = math.random() * 2
			dropitem.Physics:SetVel(speed * cosangle, GetRandomWithVariance(8, 4), speed * -sinangle)
			dropitem.Transform:SetPosition(pt.x + cosangle * 1, pt.y, pt.z - sinangle * 1)
			dropitem.Transform:SetScale(0.5, 0.5, 0.5)
		end
		
		spawn_extra_fire(target)
		spawn_extra_fire(target)
		
		if attacker:HasTag("pyromaniac") then
			groundfire.Transform:SetScale(1.5, 1.5, 1.5)
			
			spawn_extra_fire(target)
			spawn_extra_fire(target)
		end
		
		
		
		-- If the target is already on fire, do extra stuff.
		if target.components.burnable ~= nil and target.components.burnable:IsBurning() then
			SpawnPrefab("magmafire").Transform:SetPosition(target.Transform:GetWorldPosition())
			SpawnPrefab("explode_small").Transform:SetPosition(target.Transform:GetWorldPosition())
			inst.SoundEmitter:PlaySound("dontstarve/common/balloon_pop")
			inst.SoundEmitter:PlaySound("dontstarve/creatures/hound/firehound_explo")
	
			-- Instantly damages anything within a radius.
			local x, y, z = target.Transform:GetWorldPosition()
			local ents = TheSim:FindEntities(x, y, z, 3, nil, { "INLIMBO", "invisible", "noattack" })
			if #ents > 0 then
				for i, v in pairs(ents) do
					if v.components.burnable ~= nil then
						v.components.burnable:Ignite(true, attacker)
					end
					if v.components.combat ~= nil then
						v.components.combat:GetAttacked(inst, 50, inst, "fire")
						if attacker:HasTag("pyromaniac") then
							v.components.combat:GetAttacked(inst, 25, inst, "fire")
						end
						
						v.components.combat:SetTarget(attacker)
					end
				end
			end
		end
		
	--	_attackfn(inst, attacker, target) -- Run the old function.
		-- ACTUALLY DON'T BECAUSE VANILLA IS BROKEN (counts as a melee attack, triggers effects like Volt Goat counter-shock)
		-- Until that's fixed, use the below instead.
		if target.SoundEmitter ~= nil then
			target.SoundEmitter:PlaySound("dontstarve/wilson/blowdart_impact_fire")
		end
		if target.components.burnable ~= nil then
			target.components.burnable:Ignite(true, attacker)
		end
		if target.components.freezable then
			target.components.freezable:Unfreeze()
		end
		if target.components.combat ~= nil then
			target.components.combat:SetTarget(attacker)
		end
	end
	
	inst.entity:AddSoundEmitter()
	
	inst.components.weapon:SetDamage(20)
	inst.components.weapon:SetOnAttack(fireattack)
end)


env.AddPrefabPostInit("blowdart_yellow", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	local _attackfn = inst.components.weapon.onattack
	
	local function yellowattack(inst, attacker, target)
		if target:IsValid() and (target:HasTag("chess") or target:HasTag("uncompromising_pawn") or target:HasTag("twinofterror") and not target:HasTag("fleshyeye")) then
			if not target.components.debuffable then
				target:AddComponent("debuffable")
			end
			target.components.debuffable:AddDebuff("shockstundebuff", "shockstundebuff")
			
		end

		_attackfn(inst, attacker, target)
	end
	inst.components.weapon:SetOnAttack(yellowattack)
end)
