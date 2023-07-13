local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
local easing = require("easing")

local function EquipWeapon(inst)
    if inst.components.inventory ~= nil and not inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) then
        local weapon = CreateEntity()
        --[[Non-networked entity]]
        weapon.entity:AddTransform()
        weapon:AddComponent("weapon")
        weapon.components.weapon:SetDamage(inst.components.combat.defaultdamage)
        weapon.components.weapon:SetRange(inst.components.combat.attackrange, inst.components.combat.attackrange+4)
        weapon.components.weapon:SetProjectile("bearger_boulder")
        weapon:AddComponent("inventoryitem")
        weapon.persists = false
        weapon.components.inventoryitem:SetOnDroppedFn(inst.Remove)
        weapon:AddComponent("equippable")
        
        inst.components.inventory:Equip(weapon)
    end
end

local function TeleportToFood(inst)
    local flower = GetClosestInstWithTag(inst.components.eater:GetEdibleTags(), inst, 600)
    if flower and flower:IsValid() --[[and inst.findnewfood]] then
		local init_pos = inst:GetPosition()
		local player_pos = flower:GetPosition()
		if player_pos then
			local angle = PlayerPosition:GetAngleToPoint(init_pos)
			local offset = FindWalkableOffset(player_pos, angle*DEGREES, 30, 10)
				
			if offset ~= nil then
				local pos = player_pos + offset
				if pos --[[and distsq(player_pos, init_pos) > 1600]] then
					inst.components.combat:SetTarget(nil)
					
					inst:DoTaskInTime(.1, function() 
						inst.Transform:SetPosition(pos:Get())
					end)
					return
				end
			end
		end
    end
	
	inst.components.timer:StopTimer("FindNewFood")
	inst.components.timer:StartTimer("FindNewFood", 10)
	
end

local function RockThrowTimer(inst, data)
    if data.name == "RockThrow" then
        inst.rockthrow = true
    end
	
    if data.name == "FindNewFood" then
        inst.findnewfood = true
    end
end
--[[
local function LaunchProjectile(inst, targetpos)
    local x, y, z = inst.Transform:GetWorldPosition()
	
    inst.rockthrow = false
	local theta = inst.Transform:GetRotation()
    local a, b, c = targetpos

    local projectile = SpawnPrefab("bearger_boulder")
    projectile.Transform:SetPosition(x, y, z)
	
	theta = theta*DEGREES
	
	targetpos.x = targetpos.x + 15*math.cos(theta)
	
	targetpos.z = targetpos.z - 15*math.sin(theta)
	
	local rangesq = ((a-x)^2) + ((c-z)^2)
    local maxrange = 15
    local bigNum = 10
    local speed = easing.linear(rangesq, bigNum, 3, maxrange * maxrange)
	--targetpos = targetpos.x, 0, targetpos.z
	
    projectile.components.complexprojectile:Launch(targetpos, inst, inst)
	
    --projectile.usehigharc = false
end]]

local function LaunchProjectile(inst, target)
	local x, y, z = inst.Transform:GetWorldPosition()
	
	for i = 1, 5 do
		if target ~= nil then
			inst.rockthrow = false
			
			local a, b, c = target.Transform:GetWorldPosition()
			local targetpos = target:GetPosition()
			--local theta = inst.Transform:GetRotation()
			
			
			
			local theta = (inst:GetAngleToPoint(a, 0, c) + (-30 + ((i-1)*15))) * DEGREES
			--local theta = (inst:GetAngleToPoint(a, 0, c) + GetRandomWithVariance(0, 30)) * DEGREES
			
			--theta = theta*DEGREES
			
			--local variableanglex = math.random(0, 30)
			--local variableanglez = math.random(0, 30)
			
			local variableanglex = (i - 1) * 7.5
			local variableanglez = (5 - i) * 7.5
			
			
			
			targetpos.x = targetpos.x + 15*math.cos(theta)
			targetpos.z = targetpos.z - 15*math.sin(theta)
			
			local rangesq = ((a-x)^2) + ((c-z)^2)
			local maxrange = 15
			local bigNum = 10
			local speed = easing.linear(rangesq, bigNum, 3, maxrange * maxrange)
			
			local projectile = SpawnPrefab("bearger_boulder")
			projectile.Transform:SetPosition(x, y, z)
			projectile.components.complexprojectile:SetHorizontalSpeed(speed + math.random(4, 6))
			projectile.components.complexprojectile:Launch(targetpos, inst, inst)
			projectile.Transform:SetScale(0.9 + math.random(0, 0.2), 0.9 + math.random(0, 0.2), 0.9 + math.random(0, 0.2))
		end
	end
end

local function Sinkholes(inst)
	local target = inst.components.combat.target ~= nil and inst.components.combat.target or nil
	if target ~= nil then
		local target_index = {}
		local found_targets = {}
		local ix, iy, iz = inst.Transform:GetWorldPosition()
		local targetfocus = target
		
		for i = 1,5 do
			local delay = i / 10
		
			local px, py, pz = targetfocus.Transform:GetWorldPosition()
			inst:DoTaskInTime(FRAMES * i * 1.5 + delay, function()
				if targetfocus ~= nil then
					--local px, py, pz = targetfocus.Transform:GetWorldPosition()
					local rad = math.rad(inst:GetAngleToPoint(px, py, pz))
					local velx = math.cos(rad) * 4.5
					local velz = -math.sin(rad) * 4.5
				
					local dx, dy, dz = ix + (i * velx), 0, iz + (i * velz)
					
					local ground = TheWorld.Map:IsPassableAtPoint(dx, dy, dz)
					local boat = TheWorld.Map:GetPlatformAtPoint(dx, dz)
					local pt = dx, 0, dz
					
					if boat then
						local fx1 = SpawnPrefab("antlion_sinkhole_boat")
						fx1.Transform:SetPosition(dx, dy, dz)
					elseif ground and not boat then
						local fx1 = SpawnPrefab("bearger_sinkhole")
						fx1.Transform:SetPosition(dx, dy, dz)
						fx1:PushEvent("startcollapse")
						fx1.bearger = inst
					else
						local fx1 = SpawnPrefab("splash_green")
						fx1.Transform:SetPosition(dx, dy, dz)
					end
				end
			end)
		end
	end
end

env.AddPrefabPostInit("bearger", function(inst)
	if not TheWorld.ismastersim then
		return
	end

	inst.entity:SetCanSleep(false)
	
	if inst.components.groundpounder then
		--inst.components.groundpounder.sinkhole = true
		inst.components.groundpounder.groundpoundFn = Sinkholes
	end
	
    inst:ListenForEvent("timerdone", RockThrowTimer)
	
	inst.rockthrow = true
	
    inst.LaunchProjectile = LaunchProjectile
	
    --inst.TeleportToFood = TeleportToFood
	
	if inst.components.combat ~= nil then
		--inst.components.combat:SetRange(TUNING.BEARGER_ATTACK_RANGE, TUNING.BEARGER_MELEE_RANGE + 0.5)
		inst.components.combat:SetAreaDamage(6 + 0.5, 0.8)
	end
	
	--inst:ListenForEvent("oneat", function(inst, data)
		--inst.components.timer:StopTimer("FindNewFood")
		--inst.components.timer:StartTimer("FindNewFood", 10)
                
	
		--[[if data.food ~= nil and data.food.components.edible ~= nil and data.food.components.edible.hungervalue ~= nil then
			if data.food.prefab == "honey" then
				inst.components.health:DoDelta(250)
			else
				inst.components.health:DoDelta(100 + (data.food.components.edible.hungervalue * 10))
			end
		end]]
	--end)
		--local function OnHitOther(inst, other)
			--if other:HasTag("creatureknockbackable") then
			--other:PushEvent("knockback", {knocker = inst, radius = 125, strengthmult = 1})
			--else
			--if other ~= nil and other.components.inventory ~= nil and not other:HasTag("fat_gang") and not other:HasTag("foodknockbackimmune") and not (other.components.rider ~= nil and other.components.rider:IsRiding()) and 
			--Don't knockback if you wear marble
			--(other.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY) ==nil or not other.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY):HasTag("marble") and not other.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY):HasTag("knockback_protection")) then
				--other:PushEvent("knockback", {knocker = inst, radius = 125, strengthmult = 1})
			--end
			--end
		--end
	
		--if inst.components.combat ~= nil then
			--inst.components.combat.onhitotherfn = OnHitOther
		--end
end)