local assets =
{
    Asset("ANIM", "anim/slingshot.zip"),
    Asset("ANIM", "anim/swap_slingshot.zip"),
}

local prefabs =
{
	"slingshotammo_rock_proj",
}

local easing = require("easing")

local PROJECTILE_DELAY = 2 * FRAMES

local function OnEquip(inst, owner)
    local skin_build = inst:GetSkinBuild()
    if skin_build ~= nil then
        owner:PushEvent("equipskinneditem", inst:GetSkinName())
        owner.AnimState:OverrideItemSkinSymbol("swap_object", skin_build, "swap_slingshot", inst.GUID, "swap_slingshot")
    else
        owner.AnimState:OverrideSymbol("swap_object", "swap_slingshot_matilda", "swap_slingshot")
    end
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")

    if inst.components.container ~= nil then
        inst.components.container:Open(owner)
    end
end

local function OnUnequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    local skin_build = inst:GetSkinBuild()
    if skin_build ~= nil then
        owner:PushEvent("unequipskinneditem", inst:GetSkinName())
    end

    if inst.components.container ~= nil then
        inst.components.container:Close()
    end
end

local function OnProjectileLaunched(inst, attacker, target)
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

local function OnAmmoLoaded(inst, data)
	if inst.components.weapon ~= nil then
		if data ~= nil and data.item ~= nil then
			inst.components.weapon:SetProjectile(data.item.prefab.."_proj")
			data.item:PushEvent("ammoloaded", {slingshot = inst})
		end
	end
end

local function OnAmmoUnloaded(inst, data)
	if inst.components.weapon ~= nil then
		inst.components.weapon:SetProjectile(nil)
		if data ~= nil and data.prev_item ~= nil then
			data.prev_item:PushEvent("ammounloaded", {slingshot = inst})
		end
	end
end

local floater_swap_data = {sym_build = "swap_slingshot"}

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

local function LaunchSpit(inst, caster, target, fixedpowerlevel, shadow)
	if caster ~= nil then
		local x, y, z = caster.Transform:GetWorldPosition()
		local ammo = shadow ~= nil and "slingshotammo_shadow_proj_secondary" or inst.components.weapon.projectile.."_secondary"
		
		if ammo ~= nil then
			local targetpos = target:GetPosition()
			targetpos.y = 0.5

			local projectile = SpawnPrefab(ammo)
			projectile.Transform:SetPosition(x, y, z)
			projectile.powerlevel = fixedpowerlevel
			 
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
					projectile.components.projectile:SetSpeed(20)
				else
					projectile.components.projectile:SetSpeed(20)
				end
					
				projectile.components.projectile:Throw(caster, target, caster)
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

local function Proxy_Shoot(inst, owner, fixedpowerlevel)
	local ammo = inst.components.weapon.projectile and inst.components.weapon.projectile.."_secondary"
	
	if inst.components.weapon.projectile ~= nil then
		local wx = nil
		local wz = nil
		
		if owner.wixiepointx ~= nil then
			wx = owner.wixiepointx
			wz = owner.wixiepointz
		end

		if wx then
			if ammo ~= nil then
				if ammo == "slingshotammo_shadow_proj_secondary" then
					local xmod = owner.wixiepointx
					local zmod = owner.wixiepointz
				
					local pattern = false
						
					if math.random() > 0.5 then
						pattern = true
					end
					
					for i = 1, 3 do
						inst:DoTaskInTime(0.03 * i, function()
							local caster = inst.components.inventoryitem.owner
							local spittarget = SpawnPrefab("slingshot_target")
							
							local multipl = (pattern and -100 or 100) / (inst.powerlevel * 2)
							
							local maxangle = multipl / 2
							
							local varangle = (maxangle - multipl) + math.random(-4, 4)
							
							maxangle = maxangle - (varangle / 2)
							
							local theta = (inst:GetAngleToPoint(owner.wixiepointx, 0.5, owner.wixiepointz) + (maxangle + (varangle * (i-1)))) * DEGREES
									
							xmod = owner.wixiepointx + 15*math.cos(theta)
							zmod = owner.wixiepointz - 15*math.sin(theta)

							spittarget.Transform:SetPosition(xmod, 0.5, zmod)
							LaunchSpit(inst, caster, spittarget, fixedpowerlevel, true)
							spittarget:DoTaskInTime(.1, spittarget.Remove)
						end)
					end
				else
					local caster = inst.components.inventoryitem.owner
					local spittarget = SpawnPrefab("slingshot_target")

					local theta = (inst:GetAngleToPoint(owner.wixiepointx, 0.5, owner.wixiepointz) + math.random(-15, 15)) * DEGREES

					wx = wx + 15*math.cos(theta)
					wz = wz - 15*math.sin(theta)
									
					spittarget.Transform:SetPosition(wx, 0.5, wz)
									
					LaunchSpit(inst, caster, spittarget, fixedpowerlevel)
					spittarget:DoTaskInTime(0, spittarget.Remove)
				end
				
				UnloadAmmo(inst)
			end
		end
	end
end

local function createlight(inst, target, pos)
	--if caster.sg.currentstate.name == "slingshot_cast" then
	local owner = inst.components.inventoryitem.owner
	local fixedpowerlevel = inst.powerlevel

	for i = 1, inst.slingshot_amount do
		inst:DoTaskInTime((i / 10) - 0.1, function(inst)
			Proxy_Shoot(inst, owner, fixedpowerlevel)
			
			if i > 1 then
				inst.SoundEmitter:PlaySound("dontstarve/characters/walter/slingshot/shoot")
			end
		end)
	end
end

local function can_cast_fn(doer, target, pos)
	if doer:HasTag("troublemaker") then
		return true
	else
		return false
	end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("slingshot")
    inst.AnimState:SetBuild("slingshot_matilda")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("rangedweapon")
    inst:AddTag("slingshot")
    inst:AddTag("matilda")
    inst:AddTag("allow_action_on_impassable")

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")
    inst:AddTag("donotautopick")
    --inst.projectiledelay = PROJECTILE_DELAY

    MakeInventoryFloatable(inst, "med", 0.075, {0.5, 0.4, 0.5}, true, -7, floater_swap_data)

    inst.spelltype = "SLINGSHOT"

    inst:AddComponent("reticule")
    inst.components.reticule.reticuleprefab = "reticuleline2"
    inst.components.reticule.pingprefab = "reticulelongmultiping"
    inst.components.reticule.targetfn = ReticuleTargetFn
    inst.components.reticule.mousetargetfn = ReticuleMouseTargetFn
    inst.components.reticule.updatepositionfn = ReticuleUpdatePositionFn
    inst.components.reticule.validcolour = { 1, 1, 1, 1 }
    inst.components.reticule.invalidcolour = { .5, 0, 0, 1 }
    inst.components.reticule.ease = true
    inst.components.reticule.mouseenabled = true
    inst.components.reticule.ispassableatallpoints = true

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
		inst.OnEntityReplicated = function(inst) 
			if inst.replica.container ~= nil then
				inst.replica.container:WidgetSetup("slingshot") 
			end
		end
        return inst
    end

	inst.powerlevel = 1
	inst.slingshot_amount = 1

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/slingshot_matilda.xml"

    inst:AddComponent("equippable")
    inst.components.equippable.restrictedtag = "troublemaker"
    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(10)
    inst.components.weapon:SetRange(0.5)
    inst.components.weapon:SetOnProjectileLaunched(OnProjectileLaunched)
    inst.components.weapon:SetProjectile(nil)
	inst.components.weapon:SetProjectileOffset(1)
	
    inst:AddComponent("spellcaster")
    inst.components.spellcaster:SetSpellFn(createlight)
    inst.components.spellcaster:SetCanCastFn(can_cast_fn)
    inst.components.spellcaster.canuseontargets = true
    inst.components.spellcaster.canuseondead = true
    inst.components.spellcaster.canuseonpoint = true
    inst.components.spellcaster.canuseonpoint_water = true
    inst.components.spellcaster.canusefrominventory = false

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("slingshot")
	inst.components.container.canbeopened = false
    inst:ListenForEvent("itemget", OnAmmoLoaded)
    inst:ListenForEvent("itemlose", OnAmmoUnloaded)

    MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
    MakeSmallPropagator(inst)
    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("slingshot_matilda", fn, assets, prefabs)