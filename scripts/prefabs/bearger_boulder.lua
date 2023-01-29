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

local COLLAPSIBLE_TAGS = { "_combat", "pickable", "NPC_workable" }
local NON_COLLAPSIBLE_TAGS = { "bearger", "bird", "playerghost", "FX", "NOCLICK", "DECOR", "INLIMBO" }

local easing = require("easing")

local function OnHitInk(inst, attacker, target)
	local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, 0, z, 3, nil, NON_COLLAPSIBLE_TAGS, COLLAPSIBLE_TAGS)
    for i, v in ipairs(ents) do
        if v:IsValid() then
            if v.components.combat ~= nil
                and v.components.health ~= nil
                and not v:HasTag("bearger")
                and not v.components.health:IsDead() then
                if v.components.combat:CanBeAttacked() then
                    v.components.combat:GetAttacked(inst, 30)
                end
            end
        end
    end
	
	local boat = TheWorld.Map:GetPlatformAtPoint(x, z)
		
	inst.fx = "groundpound_fx"
	
	if boat then
		inst.SoundEmitter:PlaySound("dontstarve/wilson/rock_break")
		local sinkhole = SpawnPrefab("antlion_sinkhole_boat")
		sinkhole.Transform:SetPosition(x, 0, z)
	elseif inst:IsOnOcean() then
		inst.fx = "splash_green"
	else
		inst.SoundEmitter:PlaySound("dontstarve/wilson/rock_break")
		
		if inst.big == nil then
			local a, b, c = inst.Transform:GetWorldPosition()
			local targetpos = inst:GetPosition()
			local theta = inst.Transform:GetRotation()
			
			theta = theta*DEGREES
			
			--local variableanglex = math.random(0, 30)
			--local variableanglez = math.random(0, 30)
			--targetpos.x = targetpos.x + variableanglex*math.cos(theta)
			--targetpos.z = targetpos.z - variableanglez*math.sin(theta)
			
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
			projectile.components.complexprojectile:SetLaunchOffset(Vector3(0, 1, 0))
			projectile.big = true
			projectile.Transform:SetScale(0.9 + math.random(0, 0.2), 0.9 + math.random(0, 0.2), 0.9 + math.random(0, 0.2))
		end
	end
					
	SpawnPrefab(inst.fx).Transform:SetPosition(x, 0, z)
	local ring = SpawnPrefab("groundpoundring_fx")
	ring.Transform:SetPosition(x, 0, z)
	ring.Transform:SetScale(0.65, 0.65, 0.65)
	
    inst:Remove()
end

local function oncollide(inst, other)
	local x, y, z = inst.Transform:GetWorldPosition()
	if other ~= nil and other:IsValid() and other:HasTag("_combat") and not other:HasTag("bearger_boulder") or y <= inst:GetPhysicsRadius() + 0.001 then
		inst.big = true
		OnHitInk(inst, other)
	end
end


local function onthrown(inst)
    inst:AddTag("NOCLICK")
    inst.persists = false
    inst.AnimState:SetBank("bearger_boulder")
    inst.AnimState:SetBuild("bearger_boulder")
    inst.AnimState:PlayAnimation("spin_loop"..math.random(4), true)

	inst.Transform:SetScale(1.1, 1.1, 1.1)
	
    inst.Physics:SetMass(1)
    inst.Physics:SetFriction(10)
    inst.Physics:SetDamping(5)
    inst.Physics:SetCollisionGroup(COLLISION.OBSTACLES)
    inst.Physics:ClearCollisionMask()
    inst:SetPhysicsRadiusOverride(2.5)
	--inst.Physics:CollidesWith(COLLISION.WORLD)
    inst.Physics:CollidesWith(COLLISION.CHARACTERS)
    inst.Physics:SetCapsule(1.5, 1.5)
	
    inst.Physics:SetCollisionCallback(oncollide)
end

local function projectilefn()
    local inst = CreateEntity()
	
    inst:AddTag("bearger_boulder")

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddPhysics()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("bearger_boulder")
    inst.AnimState:SetBuild("bearger_boulder")
    inst.AnimState:PlayAnimation("idle")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("complexprojectile")
    inst.components.complexprojectile:SetHorizontalSpeed(15)
    inst.components.complexprojectile:SetGravity(-20)
    inst.components.complexprojectile:SetLaunchOffset(Vector3(0, .1, 0))
    inst.components.complexprojectile:SetOnLaunch(onthrown)
    inst.components.complexprojectile:SetOnHit(OnHitInk)
    inst.components.complexprojectile.usehigharc = false

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.canbepickedup = false
    inst.components.inventoryitem.owner = inst.clawer

    inst.persists = false

    inst:AddComponent("locomotor")

	inst:DoTaskInTime(5, inst.Remove)

    return inst
end

local COLLAPSIBLE_TAGS_PLAYER = { "_combat", "pickable", "NPC_workable" }
local NON_COLLAPSIBLE_TAGS_PLAYER = { "player", "bird", "rabbit", "playerghost", "FX", "NOCLICK", "DECOR", "INLIMBO", "wall", "companion"}
                                                --don't use biiiiiirrrddd the stupid moonstorm birds have that, I'll figure this out later.
local function OnHitInk_claw(inst, attacker, target)
	local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, 0, z, 3, nil, NON_COLLAPSIBLE_TAGS_PLAYER, COLLAPSIBLE_TAGS_PLAYER)
    for i, v in ipairs(ents) do
        if v:IsValid() then
            if v.components.combat ~= nil
                and v.components.health ~= nil
                and not v:HasTag("player")
                and not v.components.health:IsDead() then
                if v.components.combat:CanBeAttacked() then
                    v.components.combat:GetAttacked(inst.clawer, 20, inst)
                end
            end
        end
    end
	
	local boat = TheWorld.Map:GetPlatformAtPoint(x, z)
		
	inst.fx = "groundpound_fx"
	
	if boat then
		inst.SoundEmitter:PlaySound("dontstarve/wilson/rock_break")
		local sinkhole = SpawnPrefab("antlion_sinkhole_boat")
		sinkhole.Transform:SetPosition(x, 0, z)
	elseif inst:IsOnOcean() then
		inst.fx = "splash_green"
	else
		inst.SoundEmitter:PlaySound("dontstarve/wilson/rock_break")
	end
					
	SpawnPrefab(inst.fx).Transform:SetPosition(x, 0, z)
	local ring = SpawnPrefab("groundpoundring_fx")
	ring.Transform:SetPosition(x, 0, z)
	ring.Transform:SetScale(0.4, 0.4, 0.4)
	
    inst:Remove()
end

local function oncollide_claw(inst, other)
	local x, y, z = inst.Transform:GetWorldPosition()
	if other ~= nil and other:IsValid() and not other:HasTag("player") and other:HasTag("_combat") and not other:HasTag("bearger_boulder") or y <= inst:GetPhysicsRadius() + 0.001 then
		OnHitInk_claw(inst, other)
	end
end


local function onthrown_claw(inst)
    inst:AddTag("NOCLICK")
    inst.persists = false
    inst.AnimState:SetBank("bearger_boulder")
    inst.AnimState:SetBuild("bearger_boulder")
    inst.AnimState:PlayAnimation("spin_loop"..math.random(4), true)

	--inst.Transform:SetScale(0.9, 0.9, 0.9)
	
    inst.Physics:SetMass(1)
    inst.Physics:SetFriction(10)
    inst.Physics:SetDamping(5)
    inst.Physics:SetCollisionGroup(COLLISION.OBSTACLES)
    inst.Physics:ClearCollisionMask()
	--inst.Physics:CollidesWith(COLLISION.WORLD)
    inst.Physics:CollidesWith(COLLISION.GIANTS)
    inst.Physics:CollidesWith(COLLISION.CHARACTERS)
    inst.Physics:SetCapsule(0.15, 0.15)
	
    inst.Physics:SetCollisionCallback(oncollide_claw)
end

local function clawprojectilefn()
    local inst = CreateEntity()
	
    inst:AddTag("bearger_boulder")
	inst:AddTag("vetcurse_item")

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddPhysics()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("bearger_boulder")
    inst.AnimState:SetBuild("bearger_boulder")
    inst.AnimState:PlayAnimation("idle")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst.clawer = nil

    inst:AddComponent("complexprojectile")
    inst.components.complexprojectile:SetHorizontalSpeed(15)
    inst.components.complexprojectile:SetGravity(-20)
    inst.components.complexprojectile:SetLaunchOffset(Vector3(0, .5, 0))
    inst.components.complexprojectile:SetOnLaunch(onthrown_claw)
    inst.components.complexprojectile:SetOnHit(OnHitInk_claw)
    inst.components.complexprojectile.usehigharc = true

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.canbepickedup = false
    inst.components.inventoryitem.owner = inst.clawer

    inst.persists = false

    inst:AddComponent("locomotor")

	inst:DoTaskInTime(5, inst.Remove)

    return inst
end

return Prefab("bearger_boulder", projectilefn, ink_assets, ink_prefabs),
		Prefab("beargerclaw_boulder", clawprojectilefn, ink_assets, ink_prefabs)
