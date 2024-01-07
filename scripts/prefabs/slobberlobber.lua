local assets =
{
    Asset("ANIM", "anim/staffs.zip"),
    Asset("ANIM", "anim/swap_staffs.zip"),
    Asset("ANIM", "anim/floating_items.zip"),
}

local prefabs =
{
    "stafflight",
    "reticule",
}

local easing = require("easing")

local function OnCharged(inst)
    local fx = SpawnPrefab("dr_warmer_loop")

    local owner = inst.components.inventoryitem.owner
    inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/angry", nil, 0.6)

    if inst.components.equippable:IsEquipped() and owner ~= nil then
        fx.entity:SetParent(owner.entity)
        fx.entity:AddFollower()
        fx.Follower:FollowSymbol(owner.GUID, "swap_object", 0, -275, 0)
        fx.Transform:SetScale(1.11, 1.11, 1.11)
    else
        fx.entity:SetParent(inst.entity)
        fx.Transform:SetPosition(0, 2.35, 0)
        fx.Transform:SetScale(1.11, 1.11, 1.11)
    end
end
--[[
local function fuelme(inst)
	if inst.components.fueled:GetPercent() < 1 then
		inst.components.fueled:DoDelta(5)
		if inst.components.fueled:GetPercent() >= 1 then
			inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/angry", nil, 0.6)

			charged(inst)
			
			if inst.task ~= nil then
				inst.task:Cancel()
				inst.task = nil
			end
		end
	else
		if inst.task ~= nil then
			inst.task:Cancel()
			inst.task = nil
		end
	end
end
]]
local function LaunchSpit(caster, target)
    local x, y, z = caster.Transform:GetWorldPosition()
    local targetpos = target:GetPosition()
    local theta = caster.Transform:GetRotation()

    theta = theta * DEGREES

    local projectile = SpawnPrefab("lavaspit_projectile")
    projectile.coolingtime = 15
    projectile.Transform:SetPosition(x, y, z)
    projectile.lobber = caster
    projectile.LaunchMoreSpit = true
    --V2C: scale the launch speed based on distance
    --     because 15 does not reach our max range.
    local dx = targetpos.x - x
    local dz = targetpos.z - z

    --local rangesq = (dx * dx + dz * dz) / 1.2
    local rangesq = dx * dx + dz * dz
    local maxrange = TUNING.FIRE_DETECTOR_RANGE
    --local speed = easing.linear(rangesq, 15, 3, maxrange * maxrange)
    local speed = easing.linear(rangesq, maxrange, 5, maxrange * maxrange)
    projectile.components.complexprojectile:SetHorizontalSpeed(speed)
    projectile.components.complexprojectile:SetGravity(-35)
    projectile.components.complexprojectile:Launch(targetpos, caster, caster)
    projectile.components.complexprojectile:SetLaunchOffset(Vector3(1.5, 1.5, 0))
end

local function getspawnlocation(inst, target)
    local x1, y1, z1 = inst.Transform:GetWorldPosition()
    local x2, y2, z2 = target.Transform:GetWorldPosition()
    return x1 + .15 * (x2 - x1), 0, z1 + .15 * (z2 - z1)
end

local function createlight(staff, target, pos)
    if staff.components.rechargeable:IsCharged() then
        staff.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/vomit")
        local spittarget = SpawnPrefab("lavaspit_target")
        local caster = staff.components.inventoryitem.owner

        if pos ~= nil then
            spittarget.Transform:SetPosition(pos:Get())
            spittarget:DoTaskInTime(5, spittarget.Remove)
            LaunchSpit(caster, spittarget)
        elseif target ~= nil then
            spittarget.Transform:SetPosition(getspawnlocation(staff, target))
            spittarget:DoTaskInTime(5, spittarget.Remove)
            LaunchSpit(caster, target)
        end

        local x1, y1, z1 = staff.Transform:GetWorldPosition()

        local owner = staff.components.inventoryitem.owner

        for i, v in pairs(TheSim:FindEntities(x1, y1, z1, 8, { "slobberlobber" })) do
            if v ~= staff then
                local vowner = v.components.inventoryitem:GetGrandOwner()
                if vowner ~= nil and (vowner == owner or not vowner:HasTag("player")) or vowner == nil then
                    v.components.rechargeable:Discharge(45)
                end
            end
        end

        staff.components.rechargeable:Discharge(45) --whatever, do what you want with that number
    else
        staff.SoundEmitter:PlaySound("dontstarve/common/teleportworm/sick_cough")
    end
end

local function light_reticuletargetfn()
    local player = ThePlayer
    local ground = TheWorld.Map
    local pos = Vector3()
    --Attack range is 8, leave room for error
    --Min range was chosen to not hit yourself (2 is the hit range)
    for r = 6.5, 3.5, -.25 do
        pos.x, pos.y, pos.z = player.entity:LocalToWorldSpace(r, 0, 0)
        if ground:IsPassableAtPoint(pos:Get()) and not ground:IsGroundTargetBlocked(pos) then
            return pos
        end
    end
    return pos
end

local function onequip(inst, owner)
    if not owner:HasTag("vetcurse") then
        inst:DoTaskInTime(0, function(inst, owner)
            local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner
            local tool = owner ~= nil and owner.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
            if tool ~= nil and owner ~= nil then
                owner.components.inventory:Unequip(EQUIPSLOTS.HANDS)
                owner.components.inventory:DropItem(tool)
                owner.components.inventory:GiveItem(inst)
                owner.components.talker:Say(GetString(owner, "CURSED_ITEM_EQUIP"))
                inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/HUD_hot_level1")

                if owner.sg ~= nil then
                    owner.sg:GoToState("hit")
                end
            end
        end)
    else
        owner.AnimState:OverrideSymbol("swap_object", "swap_slobberlobber", "swap_slobberlobber")
        owner.AnimState:Show("ARM_carry")
        owner.AnimState:Hide("ARM_normal")
    end
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

local function staff_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("slobberlobber")
    inst.AnimState:SetBuild("slobberlobber")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("nopunch")
    inst:AddTag("slobberlobber")
    inst:AddTag("vetcurse_item")

    --Sneak these into pristine state for optimization
    inst:AddTag("quickcast")

    --inst.spelltype = "SCIENCE"

    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    inst:AddComponent("reticule")
    inst.components.reticule.targetfn = light_reticuletargetfn
    inst.components.reticule.ease = true
    inst.components.reticule.ispassableatallpoints = true

    if not TheWorld.ismastersim then
        return inst
    end

    -------

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/slobberlobber.xml"

    inst:AddComponent("shadowlevel")
    inst.components.shadowlevel:SetDefaultLevel(TUNING.AMULET_SHADOW_LEVEL)

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    inst:AddComponent("spellcaster")
    inst.components.spellcaster:SetSpellFn(createlight)
    inst.components.spellcaster.canuseontargets = true
    inst.components.spellcaster.canonlyuseonworkable = true
    inst.components.spellcaster.canonlyuseoncombat = true
    inst.components.spellcaster.canuseonpoint = true
    inst.components.spellcaster.canuseonpoint_water = false
    inst.components.spellcaster.quickcast = true

    inst:AddComponent("rechargeable")
    inst.components.rechargeable:SetOnChargedFn(OnCharged)

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("slobberlobber", staff_fn, assets, prefabs)
