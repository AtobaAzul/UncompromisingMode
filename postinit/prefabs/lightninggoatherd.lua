local env = env
GLOBAL.setfenv(1, GLOBAL)

local PERIODICSPAWNER_CANTTAGS = { "INLIMBO" }
local function TrySpawnAlpha(inst, data)
	if data.name == "spawn_alpha" then
		local prefab = "alpha_lightninggoat"

		if not inst:IsAsleep() then
			inst.components.timer:StartTimer("spawn_alpha", 240 + math.random(240))

			return
		end
		
		local x, y, z = inst.Transform:GetWorldPosition()

		if inst.components.periodicspawner.range ~= nil or inst.components.periodicspawner.spacing ~= nil then
			local density = inst.components.periodicspawner.density or 0
			if density <= 0 then
				inst.components.timer:StartTimer("spawn_alpha", 240 + math.random(240))
			
				return
			end

			local ents = TheSim:FindEntities(x, y, z, inst.components.periodicspawner.range or inst.components.periodicspawner.spacing, nil, PERIODICSPAWNER_CANTTAGS)
			local count = 0
			for i, v in ipairs(ents) do
				if v.prefab == prefab then
					--know that FindEntities radius is within "spacing"
					if inst.components.periodicspawner.range == nil or (
						inst.components.periodicspawner.spacing ~= nil and (
							inst.components.periodicspawner.spacing >= inst.components.periodicspawner.range or
							v:GetDistanceSqToPoint(x, y, z) < inst.components.periodicspawner.spacing * inst.components.periodicspawner.spacing
						)
					) then
						inst.components.timer:StartTimer("spawn_alpha", 240 + math.random(240))
					
						return
					end
					count = count + 1
					if count >= density then
						inst.components.timer:StartTimer("spawn_alpha", 240 + math.random(240))
						
						return
					end
				end
			end
		end
		
		
		for i, v in pairs(inst.components.herd.members) do
			if i:HasTag("alpha_goat") then
				inst.components.timer:StartTimer("spawn_alpha", 240 + math.random(240))
				
				return
			end
		end
		
		local goat = SpawnPrefab(prefab)
		goat.Transform:SetPosition(x, y, z)
			
		if inst.components.periodicspawner.onspawn ~= nil then
			inst.components.periodicspawner.onspawn(inst, goat)
		end
	end
end

env.AddPrefabPostInit("lightninggoatherd", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	inst:AddComponent("timer")
	inst:ListenForEvent("timerdone", TrySpawnAlpha)
	
	if inst.components.herd ~= nil then
		local _OldOnFull = nil
	
		if inst.components.herd.onfull ~= nil then
			_OldOnFull = inst.components.herd.onfull
		end
		
		inst.components.herd:SetOnFullFn(function(inst)
			if _OldOnFull ~= nil then
				_OldOnFull(inst)
			end
		
			local has_alpha = false
		
			for i, v in pairs(inst.components.herd.members) do
				if i:HasTag("alpha_goat") then
					has_alpha = true
				end
			end
		
			if not has_alpha then
				inst.components.timer:StartTimer("spawn_alpha", 240 + math.random(240))
			end
		end)
		
		local _OldRemoveMember = nil
	
		if inst.components.herd.removemember ~= nil then
			_OldRemoveMember = inst.components.herd.removemember
		end
		
		inst.components.herd:SetRemoveMemberFn(function(inst)
			if _OldRemoveMember ~= nil then
				_OldRemoveMember(inst)
			end
			
			if inst.components.herd:IsFull() then
				local has_alpha = false
			
				for i, v in pairs(inst.components.herd.members) do
					if i:HasTag("alpha_goat") then
						has_alpha = true
					end
				end
			
				if not has_alpha then
					inst.components.timer:StartTimer("spawn_alpha", 240 + math.random(240))
				end
			end
		end)
		
		local _OldAddMember = nil
	
		if inst.components.herd.addmember ~= nil then
			_OldAddMember = inst.components.herd.addmember
		end
		
		inst.components.herd:SetAddMemberFn(function(inst)
			if _OldAddMember ~= nil then
				_OldAddMember(inst)
			end
			
			if inst.components.herd:IsFull() then
				local has_alpha = false
			
				for i, v in pairs(inst.components.herd.members) do
					if i:HasTag("alpha_goat") then
						has_alpha = true
					end
				end
			
				if not has_alpha then
					inst.components.timer:StartTimer("spawn_alpha", 240 + math.random(240))
				end
			end
		end)
	end
end)
