local env = env
GLOBAL.setfenv(1, GLOBAL)

local easing = require("easing")

--[[
local function ReticuleTargetFn()
    return Vector3(ThePlayer.entity:LocalToWorldSpace(6.5, 0, 0))
end]]

local function ReticuleTargetFn(inst)
    return Vector3(inst.entity:LocalToWorldSpace(6.5, 0, 0))
end

local function ReticuleMouseTargetFn(inst, mousepos)
    if mousepos ~= nil then 
        local x, y, z = inst.Transform:GetWorldPosition()
        local dx = mousepos.x - x
        local dz = mousepos.z - z
        local l = dx * dx + dz * dz
        if l <= 0 then
            return inst.components.reticule.targetpos
        end
        l = 6.5 / math.sqrt(l)
        return Vector3(x + dx * l, 0, z + dz * l)
    end
end

local function ReticuleUpdatePositionFn(inst, pos, reticule, ease, smoothing, dt)
    local x, y, z = inst.Transform:GetWorldPosition()
    reticule.Transform:SetPosition(x, 0, z)
    local rot = -math.atan2(pos.z - z, pos.x - x) / DEGREES
    if ease and dt ~= nil then
        local rot0 = reticule.Transform:GetRotation()
        local drot = rot - rot0
        rot = Lerp((drot > 180 and rot0 + 360) or (drot < -180 and rot0 - 360) or rot0, rot, dt * smoothing)
    end
    reticule.Transform:SetRotation(rot)
end
--[[
local function createlight(staff, target, pos)
	local ammo = staff.components.weapon.projectile.."_secondary"
	local spittarget = SpawnPrefab("lavaspit_target")
	
	if ammo ~= nil then
		if pos ~= nil then
			spittarget.Transform:SetPosition(pos:Get())
			spittarget:DoTaskInTime(1, spittarget.Remove)
			local proj = SpawnPrefab(ammo)
			local x, y, z = staff.Transform:GetWorldPosition()
			proj.Transform:SetPosition(x, y, z)
			proj.components.projectile:Throw(staff, spittarget, staff)
		elseif target ~= nil then
			local proj = SpawnPrefab(ammo)
			local x, y, z = staff.Transform:GetWorldPosition()
			proj.Transform:SetPosition(x, y, z)
			proj.components.projectile:Throw(staff, target, staff)
		end
	end
end]]



local function LaunchSpit(inst, caster, target, shadow)
	if caster ~= nil then
		local x, y, z = caster.Transform:GetWorldPosition()
		local ammo = shadow ~= nil and "slingshotammo_shadow_proj_secondary" or inst.components.weapon.projectile.."_secondary"
		
		if ammo ~= nil then 
			if ammo == "slingshotammo_spread_proj_secondary" and inst.powerlevel >= 2 then --spread ammo is not a thing, im just removing the spread from rock ammo
				for i = 1, 5 do
					local targetpos = target:GetPosition()
					targetpos.x = targetpos.x + math.random(-2.2, 2.2)
					targetpos.y = 0.5
					targetpos.z = targetpos.z + math.random(-2.2, 2.2)

					local projectile = SpawnPrefab("slingshotammo_spread_proj_secondary")
					projectile.Transform:SetPosition(x, y, z)
					projectile.powerlevel = inst.powerlevel / 4
					projectile.Transform:SetScale(0.7, 0.7, 0.7)
					projectile.Physics:SetCapsule(0.6, 0.6)
					
					projectile.components.projectile:SetSpeed(60 * projectile.powerlevel)
					projectile.components.projectile:Throw(caster, target, caster)
					projectile:DoTaskInTime(1, projectile.Remove)
					SpawnPrefab("slingshotammo_hitfx_rocks").Transform:SetPosition(x, y, z)
				end
			else
				local targetpos = target:GetPosition()
				targetpos.y = 0.5

				local projectile = SpawnPrefab(ammo)
				projectile.Transform:SetPosition(x, y, z)
				
				projectile.powerlevel = inst.powerlevel
				
				if projectile.components.complexprojectile ~= nil then
					local theta = caster.Transform:GetRotation()
					theta = theta*DEGREES
		
					local dx = targetpos.x - x
					local dz = targetpos.z - z
					
					--local rangesq = (dx * dx + dz * dz) / 1.2
					local rangesq = dx * dx + dz * dz
					local maxrange = TUNING.FIRE_DETECTOR_RANGE * 2
					--local speed = easing.linear(rangesq, 15, 3, maxrange * maxrange)
					local speed = easing.linear(rangesq, maxrange, 1, maxrange * maxrange)
					projectile.caster = caster
					projectile.components.complexprojectile.usehigharc = true
					projectile.components.complexprojectile:SetHorizontalSpeed(speed)
					projectile.components.complexprojectile:SetGravity(-45)
					projectile.components.complexprojectile:Launch(targetpos, caster, caster)
					projectile.components.complexprojectile:SetLaunchOffset(Vector3(1.5, 1.5, 0))
				else
					if ammo == "slingshotammo_moonglass_proj_secondary" then
						projectile.components.projectile:SetSpeed(10 + 10 * projectile.powerlevel)
					else
						projectile.components.projectile:SetSpeed(10 + 10 * projectile.powerlevel)
					end
					
					projectile.components.projectile:Throw(caster, target, caster)
				end
			end
		end
	end
end

local function getspawnlocation(inst, target)
    local x1, y1, z1 = inst.Transform:GetWorldPosition()
    local x2, y2, z2 = target.Transform:GetWorldPosition()
    return x1 + .15 * (x2 - x1), 0.5, z1 + .15 * (z2 - z1)
end

local function UnloadAmmo(inst)
	if inst.components.container ~= nil then
		local ammo_stack = inst.components.container:GetItemInSlot(1)
		local item = inst.components.container:RemoveItem(ammo_stack, false)
		if item ~= nil then
			if item == ammo_stack then
				item:PushEvent("ammounloaded", {slingshot = inst})
			end

			item:Remove()
		end
	end
end

local function createlight(inst, target, pos)
	--if caster.sg.currentstate.name == "slingshot_cast" then
		local ammo = inst.components.weapon.projectile and inst.components.weapon.projectile.."_secondary"
		local owner = inst.components.inventoryitem.owner

		if owner ~= nil and owner.wixiepointx ~= nil then
			if ammo ~= nil then
				if ammo == "slingshotammo_shadow_proj_secondary" then
					local xmod = owner.wixiepointx
					local zmod = owner.wixiepointz
				
					local pattern = false
						
					if math.random() > 0.5 then
						pattern = true
					end
					
					for i = 1, 2 * inst.powerlevel + 1 do
						inst:DoTaskInTime(0.03 * i, function()
							local caster = inst.components.inventoryitem.owner
							local spittarget = SpawnPrefab("slingshot_target")
							
							local multipl = (pattern and -100 or 100) / (inst.powerlevel * 2)
							
							local maxangle = multipl / 2
							
							local varangle = maxangle - multipl
							
							maxangle = maxangle - (varangle / 2)
							
							local theta = (inst:GetAngleToPoint(owner.wixiepointx, 0.5, owner.wixiepointz) + (maxangle + (varangle * (i-1)))) * DEGREES
									
							xmod = owner.wixiepointx + 15*math.cos(theta)
							zmod = owner.wixiepointz - 15*math.sin(theta)

							spittarget.Transform:SetPosition(xmod, 0.5, zmod)
							LaunchSpit(inst, caster, spittarget, true)
							spittarget:DoTaskInTime(.1, spittarget.Remove)
						end)
					end
				else
					local caster = inst.components.inventoryitem.owner
					local spittarget = SpawnPrefab("slingshot_target")

					--local pos = TheInput:GetWorldPosition()

					spittarget.Transform:SetPosition(owner.wixiepointx, 0.5, owner.wixiepointz)
					LaunchSpit(inst, caster, spittarget)
					spittarget:DoTaskInTime(0, spittarget.Remove)
				end
				
				UnloadAmmo(inst)
			end
		end
end

local function can_cast_fn(doer, target, pos)
	if doer:HasTag("troublemaker") then
		return true
	else
		return false
	end
end

env.AddPrefabPostInit("slingshot", function(inst)
	
    inst.spelltype = "SLINGSHOT"

    inst:AddTag("allow_action_on_impassable")

    inst:AddComponent("reticule")
    inst.components.reticule.reticuleprefab = "reticuleline2"
    inst.components.reticule.pingprefab = "reticulelongping"
    inst.components.reticule.targetfn = ReticuleTargetFn
    inst.components.reticule.mousetargetfn = ReticuleMouseTargetFn
    inst.components.reticule.updatepositionfn = ReticuleUpdatePositionFn
    inst.components.reticule.validcolour = { 1, 1, 1, 1 }
    inst.components.reticule.invalidcolour = { .5, 0, 0, 1 }
    inst.components.reticule.ease = true
    inst.components.reticule.mouseenabled = true
    inst.components.reticule.ispassableatallpoints = true
	
	if not TheWorld.ismastersim then
		return
	end
	
	if inst.components.equippable ~= nil then
		inst.components.equippable.restrictedtag = "troublemaker"
	end
	
	inst.powerlevel = 1
	
    inst:AddComponent("spellcaster")
    inst.components.spellcaster:SetSpellFn(createlight)
    inst.components.spellcaster:SetCanCastFn(can_cast_fn)
    inst.components.spellcaster.canuseontargets = true
    inst.components.spellcaster.canuseondead = true
    inst.components.spellcaster.canuseonpoint = true
    inst.components.spellcaster.canuseonpoint_water = true
    inst.components.spellcaster.canusefrominventory = false

	if inst.components.weapon ~= nil then
		inst.components.weapon:SetDamage(10)
		inst.components.weapon:SetRange(0.5)
	end
end)