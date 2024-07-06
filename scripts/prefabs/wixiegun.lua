local assets =
{
    Asset("ANIM", "anim/slingshot.zip"),
    Asset("ANIM", "anim/swap_slingshot.zip"),
}

local prefabs =
{
	"slingshotammo_rock_proj",
}

local PROJECTILE_DELAY = 2 * FRAMES

local function OnEquip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_wixiegun", "swap_wixiegun")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
	
	owner.SoundEmitter:PlaySound("wixie/characters/wixie/wixiesgotagun", "evilmode")
	
end

local function OnUnequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
	
	owner.SoundEmitter:KillSound("evilmode")
end

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

local function LaunchSpit(inst, caster, target)
    local x, y, z = caster.Transform:GetWorldPosition()
	local ammo = "slingshotammo_marble_proj_secondary"

	local projectile = SpawnPrefab(ammo)
	projectile.Transform:SetPosition(x, y, z)
	projectile.powerlevel = 5
	projectile.Transform:SetScale(0.7, 0.7, 0.7)
	projectile.Physics:SetCapsule(0.6, 0.6)
				
	projectile.components.projectile:SetSpeed(80)
	projectile.components.projectile:SetLaunchOffset(Vector3(1.5, 0.5, 0))
	projectile.components.projectile:Throw(caster, target, caster)
	projectile:DoTaskInTime(1, projectile.Remove)
end

local function getspawnlocation(inst, target)
    local x1, y1, z1 = inst.Transform:GetWorldPosition()
    local x2, y2, z2 = target.Transform:GetWorldPosition()
    return x1 + .15 * (x2 - x1), 0.5, z1 + .15 * (z2 - z1)
end

local function createlight(inst, target, pos)
	--if caster.sg.currentstate.name == "slingshot_cast" then
		local owner = inst.components.inventoryitem.owner

		if owner ~= nil and owner.wixiepointx ~= nil then
			owner.SoundEmitter:PlaySound("wixie/characters/wixie/glock")
		
			local caster = inst.components.inventoryitem.owner
			local spittarget = SpawnPrefab("slingshot_target")
			--local pos = TheInput:GetWorldPosition()

			spittarget.Transform:SetPosition(owner.wixiepointx + math.random(-1.2, 1.2), 0.5, owner.wixiepointz + math.random(-1.2, 1.2))
			LaunchSpit(inst, caster, spittarget)
			spittarget:DoTaskInTime(0, spittarget.Remove)
		end
end

local function can_cast_fn(doer, target, pos)
	if doer:HasTag("pebblemaker") then
		return true
	else
		return false
	end
end

local function OnProjectileLaunched(inst, attacker, target)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("swap_wixiegun")
    inst.AnimState:SetBuild("swap_wixiegun")
    inst.AnimState:PlayAnimation("BUILD")

    inst:AddTag("rangedweapon")
    inst:AddTag("wixiegun")
    inst:AddTag("veryquickcast")
    inst:AddTag("allow_action_on_impassable")

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")
    inst:AddTag("donotautopick")
    --inst.projectiledelay = PROJECTILE_DELAY

	--MakeInventoryFloatable(inst, "med", 0.075, {0.5, 0.4, 0.5}, true, -7, floater_swap_data)

    inst.spelltype = "SLINGSHOT"

    inst:AddComponent("reticule")
    inst.components.reticule.reticuleprefab = "reticuleline2"
    inst.components.reticule.pingprefab = "reticulelongping"
    --inst.components.reticule.reticuleprefab = "reticuleline2"
    --inst.components.reticule.pingprefab = "reticulelineping"
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
        return inst
    end

	inst.powerlevel = 1

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/wixiegun.xml"

    inst:AddComponent("equippable")
    inst.components.equippable.restrictedtag = "slingshot_sharpshooter"
    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)
	
    inst:AddComponent("spellcaster")
    inst.components.spellcaster:SetSpellFn(createlight)
    inst.components.spellcaster:SetCanCastFn(can_cast_fn)
    inst.components.spellcaster.veryquickcast = true
    inst.components.spellcaster.canuseontargets = true
    inst.components.spellcaster.canuseondead = true
    inst.components.spellcaster.canuseonpoint = true
    inst.components.spellcaster.canuseonpoint_water = true
    inst.components.spellcaster.canusefrominventory = false

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("wixiegun", fn, assets, prefabs)