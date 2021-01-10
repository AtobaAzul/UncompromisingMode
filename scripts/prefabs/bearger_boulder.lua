local snowball_assets =
{
    Asset("ANIM", "anim/firefighter_projectile.zip"),
}

local snowball_prefabs =
{
    "splash_snow_fx",
}

local waterballoon_assets =
{
    Asset("ANIM", "anim/waterballoon.zip"),
    Asset("ANIM", "anim/swap_waterballoon.zip"),
}

local waterballoon_prefabs =
{
    "waterballoon_splash",
    "reticule",
}

local ink_assets =
{
    Asset("ANIM", "anim/squid_watershoot.zip"),
}

local ink_prefabs =
{
    "ink_splash",
    "ink_puddle_land",
    "ink_puddle_water",
}

local waterstreak_assets =
{
    Asset("ANIM", "anim/waterstreak.zip"),
}

local waterstreak_prefabs =
{
    "waterstreak_burst",
}

local COLLAPSIBLE_TAGS = { "_combat", "pickable", "NPC_workable" }
local NON_COLLAPSIBLE_TAGS = { "bearger", "flying", "bird", "ghost", "playerghost", "FX", "NOCLICK", "DECOR", "INLIMBO" }

local function OnHitInk(inst, attacker, target)
	
    
	local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, 0, z, 5, nil, NON_COLLAPSIBLE_TAGS, COLLAPSIBLE_TAGS)
    for i, v in ipairs(ents) do
        if v:IsValid() then
            if v.components.combat ~= nil
                and v.components.health ~= nil
                and not v:HasTag("bearger")
                and not v.components.health:IsDead() then
                if v.components.combat:CanBeAttacked() then
                    v.components.combat:GetAttacked(inst, TUNING.ANTLION_SINKHOLE.DAMAGE)
                end
            end
        end
    end
	
	if not inst:IsOnOcean() then
		local sinkhole = SpawnPrefab("bearger_sinkhole")
		sinkhole.Transform:SetPosition(inst.Transform:GetWorldPosition())
		sinkhole.components.timer:StartTimer("nextrepair", 20 + (math.random() * 10))
	else
		local pt = inst:GetPosition()
		boat:PushEvent("spawnnewboatleak", {pt = pt, leak_size = "med_leak", playsoundfx = true})
	end
	
    if inst:IsOnOcean() then
        SpawnPrefab("splash_green").Transform:SetPosition(inst.Transform:GetWorldPosition())
		local ring = SpawnPrefab("groundpoundring_fx")
		ring.Transform:SetPosition(inst.Transform:GetWorldPosition())
		ring.Transform:SetScale(0.7, 0.7, 0.7)
    else
		SpawnPrefab("groundpound_fx").Transform:SetPosition(inst.Transform:GetWorldPosition())
		local ring = SpawnPrefab("groundpoundring_fx")
		ring.Transform:SetPosition(inst.Transform:GetWorldPosition())
		ring.Transform:SetScale(0.7, 0.7, 0.7)
    end
					
    inst:Remove()
end

local function oncollide(inst, other)
    -- If there is a physics collision, try to do some damage to that thing.
    -- This is so you can't hide forever behind walls etc.

	if other ~= nil and other:IsValid() and other:HasTag("_combat") and not other:HasTag("gingerbread") then
		OnHitInk(inst, other)
	end
end

local function common_fn(bank, build, anim, tag, isinventoryitem)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    if isinventoryitem then
        MakeInventoryPhysics(inst)
    else
        inst.entity:AddPhysics()
        inst.Physics:SetMass(1)
        inst.Physics:SetFriction(0)
        inst.Physics:SetDamping(0)
        inst.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
        inst.Physics:ClearCollisionMask()
        inst.Physics:CollidesWith(COLLISION.GROUND)
        inst.Physics:SetCapsule(0.2, 0.2)
        inst.Physics:SetDontRemoveOnSleep(true) -- so the object can land and put out the fire, also an optimization due to how this moves through the world
    end

    if tag ~= nil then
        inst:AddTag(tag)
    end

    --projectile (from complexprojectile component) added to pristine state for optimization
    inst:AddTag("projectile")

    inst.AnimState:SetBank("rock")
    inst.AnimState:SetBuild("rock")

    inst.AnimState:PlayAnimation("full")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
    inst.Physics:SetCollisionCallback(oncollide)

    inst:AddComponent("locomotor")

    inst:AddComponent("wateryprotection")

    inst:AddComponent("complexprojectile")

    return inst
end

local function ink_fn()
    local inst = common_fn("squid_watershoot", "squid_watershoot", "spin_loop", "NOCLICK")

    inst.AnimState:PlayAnimation("full")

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    inst.components.complexprojectile:SetHorizontalSpeed(15)
    inst.components.complexprojectile:SetGravity(-25)
    inst.components.complexprojectile:SetLaunchOffset(Vector3(0, 2.5, 0))
    inst.components.complexprojectile:SetOnHit(OnHitInk)

    inst.components.wateryprotection.extinguishheatpercent = TUNING.FIRESUPPRESSOR_EXTINGUISH_HEAT_PERCENT
    inst.components.wateryprotection.temperaturereduction = TUNING.FIRESUPPRESSOR_TEMP_REDUCTION
    inst.components.wateryprotection.witherprotectiontime = TUNING.FIRESUPPRESSOR_PROTECTION_TIME
    inst.components.wateryprotection.addcoldness = TUNING.FIRESUPPRESSOR_ADD_COLDNESS
    inst.components.wateryprotection:AddIgnoreTag("player")

    return inst
end

return Prefab("bearger_boulder", ink_fn, ink_assets, ink_prefabs)
