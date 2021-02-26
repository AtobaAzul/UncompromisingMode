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

local function RockThrowTimer(inst, data)
    if data.name == "RockThrow" then
        inst.rockthrow = true
		
		--EquipWeapon(inst)
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
	if target ~= nil then
	
		inst.rockthrow = false
		
		local x, y, z = inst.Transform:GetWorldPosition()
		local a, b, c = target.Transform:GetWorldPosition()
		local targetpos = target:GetPosition()
		local theta = inst.Transform:GetRotation()
		
		theta = theta*DEGREES
		
		local variableanglex = math.random(0, 30)
		local variableanglez = math.random(0, 30)
		targetpos.x = targetpos.x + variableanglex*math.cos(theta)
		targetpos.z = targetpos.z - variableanglez*math.sin(theta)
		
		local rangesq = ((a-x)^2) + ((c-z)^2)
		local maxrange = 15
		local bigNum = 10
		local speed = easing.linear(rangesq, bigNum, 3, maxrange * maxrange)
		
		local projectile = SpawnPrefab("bearger_boulder")
		projectile.Transform:SetPosition(x, y, z)
		projectile.components.complexprojectile:SetHorizontalSpeed(speed + math.random(3, 5))
		projectile.components.complexprojectile:Launch(targetpos, inst, inst)
	end
end

local function Sinkholes(inst)
	local target = inst.components.combat.target ~= nil and inst.components.combat.target
	if target ~= nil then
		local target_index = {}
		local found_targets = {}
		local ix, iy, iz = inst.Transform:GetWorldPosition()
		for i = 1,5 do
			local delay = i / 10
		
			inst:DoTaskInTime(FRAMES * i * 1.5 + delay, function()
				if target ~= nil then
					local px, py, pz = target.Transform:GetWorldPosition()
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
	
	if inst.components.groundpounder then
		--inst.components.groundpounder.sinkhole = true
		inst.components.groundpounder.groundpoundFn = Sinkholes
	end
	
    inst:ListenForEvent("timerdone", RockThrowTimer)
	
	inst.rockthrow = true
	
    inst.LaunchProjectile = LaunchProjectile
	
	--[[inst:ListenForEvent("oneat", function(inst, data)
		if data.food ~= nil and data.food.components.edible ~= nil and data.food.components.edible.hungervalue ~= nil then
			if data.food.prefab == "honey" then
				inst.components.health:DoDelta(250)
			else
				inst.components.health:DoDelta(100 + (data.food.components.edible.hungervalue * 10))
			end
		end
	end)]]
end)