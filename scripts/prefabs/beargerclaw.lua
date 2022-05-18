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

local function charged(inst)
	local fx = SpawnPrefab("dr_warmer_loop")
	
	local owner = inst.components.inventoryitem.owner
	
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

local function LaunchSpit(caster, target)
    local x, y, z = caster.Transform:GetWorldPosition()
	
	local ents = TheSim:FindEntities(x, y, z, 5, {"antlion_sinkhole"})
	local pt = caster:GetPosition()
	local boat = TheWorld.Map:GetPlatformAtPoint(pt.x, pt.z)
	
	if #ents == 0 and not boat then
		for i = 1, 4 do 
			local targetpos = target:GetPosition()

			local projectile = SpawnPrefab("beargerclaw_boulder")
			projectile.coolingtime = 8
			projectile.Transform:SetPosition(x, y, z)
			projectile.clawer = caster
			
			targetpos.x = targetpos.x + math.random(-2, 2)
			targetpos.z = targetpos.z + math.random(-2, 2)
			
			local dx = targetpos.x - x
			local dz = targetpos.z - z
			
		
			--local rangesq = (dx * dx + dz * dz) / 1.2
			local rangesq = dx * dx + dz * dz
			local maxrange = TUNING.FIRE_DETECTOR_RANGE
			--local speed = easing.linear(rangesq, 15, 3, maxrange * maxrange)
			local speed = easing.linear(rangesq, maxrange, 5, maxrange * maxrange)
			projectile.components.complexprojectile:SetHorizontalSpeed(speed * 1.1)
			projectile.components.complexprojectile:SetGravity(-35)
			projectile.components.complexprojectile:Launch(targetpos, caster, caster)
			projectile.components.complexprojectile:SetLaunchOffset(Vector3(1.5, 1.5, 0))
		end
		
		SpawnPrefab("beargerclaw_sinkhole").Transform:SetPosition(x, 0, z)
	end
	
	
	if boat ~= nil then
		boat:PushEvent("spawnnewboatleak", {pt = pt, leak_size = "small_leak", playsoundfx = true})
	else
		SpawnPrefab("groundpound_fx").Transform:SetPosition(x, 0, z)
	end
end

local function getspawnlocation(inst, target)
    local x1, y1, z1 = inst.Transform:GetWorldPosition()
    local x2, y2, z2 = target.Transform:GetWorldPosition()
    return x1 + .15 * (x2 - x1), 0, z1 + .15 * (z2 - z1)
end

local function createlight(staff, target, pos)
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
	owner.AnimState:OverrideSymbol("swap_object", "swap_beargerclaw", "swap_shovel")
	owner.AnimState:Show("ARM_carry")
	owner.AnimState:Hide("ARM_normal")
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

    inst.AnimState:SetBank("beargerclaw")
    inst.AnimState:SetBuild("beargerclaw")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("nopunch")

    --Sneak these into pristine state for optimization
    inst:AddTag("beargerclaw")
    inst:AddTag("quickcast")
	inst:AddTag("vetsitem")
	
	MakeInventoryFloatable(inst)

    inst.spelltype = "SCIENCE"

    inst.entity:SetPristine()
	
    inst:AddComponent("reticule")
    inst.components.reticule.targetfn = light_reticuletargetfn
    inst.components.reticule.ease = true
    inst.components.reticule.ispassableatallpoints = true

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/beargerclaw.xml"

    inst:AddComponent("equippable")
    inst.components.equippable.restrictedtag = "vetcurse"
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.DIG)
	
    inst:AddInherentAction(ACTIONS.DIG)
	
    inst:AddComponent("spellcaster")
    inst.components.spellcaster:SetSpellFn(createlight)
    inst.components.spellcaster.canuseontargets = true
    inst.components.spellcaster.canonlyuseonworkable = true
    inst.components.spellcaster.canonlyuseoncombat = true
    inst.components.spellcaster.canuseonpoint = true
    inst.components.spellcaster.canuseonpoint_water = true

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("beargerclaw", staff_fn, assets, prefabs)
