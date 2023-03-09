local assets =
{
    Asset("ANIM", "anim/snowball.zip"),
}

local prefabs =
{
    "splash_snow_fx",
}

local function OnHitSnow(inst, attacker, target)
    SpawnPrefab("splash_snow_fx").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/firesupressor_impact")
	local x, y, z = inst.Transform:GetWorldPosition() 
	local ents = TheSim:FindEntities(x, y, z, 3, nil, { "shadow", "INLIMBO" })
	if #ents > 0 then
		for i, v in ipairs(ents) do
			if v:IsValid() and not v:IsInLimbo() then

				if v.components.burnable ~= nil then
					if v.components.burnable:IsBurning() then
						v.components.burnable:Extinguish()
					elseif v.components.burnable:IsSmoldering() then
						v.components.burnable:SmotherSmolder()
					end
				end

				if v.components.sleeper ~= nil and v.components.sleeper:IsAsleep() then
					v.components.sleeper:WakeUp()
				end
										-- For SnowMong Vomit
				if v.sg ~= nil and not inst:HasTag("canthit") and not v.sg:HasStateTag("frozen") and not v:HasTag("abigail") and not v:HasTag("companion") and not v:HasTag("player") then
					v:PushEvent("attacked", { attacker = attacker, damage = 0} )
				elseif v.sg ~= nil and not inst:HasTag("canthit") then
					v:PushEvent("attacked", { attacker = inst, damage = 0} )
				end
				
				if v.components.freezable ~= nil then
					v.components.freezable:AddColdness(0.68)
				end
			end
		end
    end
	
    inst:Remove()
end

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_snowball_throwable", "swap_snowball_throwable")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

local function onthrown(inst)
    inst:AddTag("NOCLICK")
    inst.persists = false

    inst.AnimState:SetBank("firefighter_projectile")
    inst.AnimState:SetBuild("firefighter_projectile")
    
    inst.AnimState:PlayAnimation("spin_loop", true)

    inst.Physics:SetMass(1)
    inst.Physics:SetCapsule(0.2, 0.2)
    inst.Physics:SetFriction(0)
    inst.Physics:SetDamping(0)
    inst.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.GROUND)
    inst.Physics:CollidesWith(COLLISION.OBSTACLES)
    inst.Physics:CollidesWith(COLLISION.ITEMS)
end

local function ReticuleTargetFn()
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

local function onperish(inst)
    local owner = inst.components.inventoryitem.owner
    if owner ~= nil then
        local stacksize = inst.components.stackable:StackSize()
        if owner.components.moisture ~= nil then
            owner.components.moisture:DoDelta(2 * stacksize)
        elseif owner.components.inventoryitem ~= nil then
            owner.components.inventoryitem:AddMoisture(4 * stacksize)
        end
        inst:Remove()
    else
        inst.components.inventoryitem.canbepickedup = false
        --inst:DoTaskInTime(1, inst.Remove())
    end
		inst:Remove()
end

local function onfiremelt(inst)
    inst.components.perishable.frozenfiremult = true
end

local function onstopfiremelt(inst)
    inst.components.perishable.frozenfiremult = false
end

local function onuseaswatersource(inst)
    if inst.components.stackable:IsStack() then
        inst.components.stackable:Get():Remove()
    else
        inst:Remove()
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    --projectile (from complexprojectile component) added to pristine state for optimization
	
    inst.AnimState:SetBank("snowball")
    inst.AnimState:SetBuild("snowball")
    inst.AnimState:PlayAnimation("idle")
	
    inst:AddTag("projectile")
	inst:AddTag("weapon")
	inst:AddTag("thrown")
    
	inst:AddTag("frozen")
    inst:AddTag("watersource")
	
    MakeInventoryFloatable(inst, "med", 0.05, 0.65)

    inst.entity:SetPristine()
	
	inst:AddComponent("reticule")
    inst.components.reticule.targetfn = ReticuleTargetFn
    inst.components.reticule.ease = true

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("locomotor")

    inst:AddComponent("wateryprotection")

    inst:AddComponent("complexprojectile")
    inst.components.complexprojectile:SetHorizontalSpeed(15)
    inst.components.complexprojectile:SetGravity(-35)
    inst.components.complexprojectile:SetLaunchOffset(Vector3(0, 0, 0))
    inst.components.complexprojectile:SetOnLaunch(onthrown)
    inst.components.complexprojectile:SetOnHit(OnHitSnow)
	
    inst:AddComponent("edible")
    inst.components.edible.foodtype = "HORRIBLE"
    inst.components.edible.healthvalue = 0
    inst.components.edible.hungervalue = 1
	
    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_TWO_DAY)
    inst.components.perishable:StartPerishing()
    inst.components.perishable:SetOnPerishFn(onperish)
	
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(0)
    inst.components.weapon:SetRange(20, 10)
	
    inst.components.wateryprotection.extinguishheatpercent = TUNING.FIRESUPPRESSOR_EXTINGUISH_HEAT_PERCENT
    inst.components.wateryprotection.temperaturereduction = TUNING.FIRESUPPRESSOR_TEMP_REDUCTION
    inst.components.wateryprotection.witherprotectiontime = TUNING.FIRESUPPRESSOR_PROTECTION_TIME
    inst.components.wateryprotection.addcoldness = TUNING.FIRESUPPRESSOR_ADD_COLDNESS
    inst.components.wateryprotection:AddIgnoreTag("player")
	
    --inst.persists = false
	
	
    inst:ListenForEvent("firemelt", onfiremelt)
    inst:ListenForEvent("stopfiremelt", onstopfiremelt)
	
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/snowball_throwable.xml"
    inst.components.inventoryitem:SetOnPickupFn(onstopfiremelt)
	
	
    inst:AddComponent("watersource")
    inst.components.watersource.onusefn = onuseaswatersource
    inst.components.watersource.override_fill_uses = 1
	
    inst:AddComponent("inspectable")
	
    inst:AddComponent("stackable")
	
	inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable.equipstack = true

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("snowball_throwable", fn, assets, prefabs)
