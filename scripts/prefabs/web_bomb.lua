local splashprefabs =
{
    "web_splash_fx_melted",
    "web_splash_fx_low",
    "web_splash_fx_med",
    "web_splash_fx_full",
}
local function doprojectilehit(inst, attacker, other)
	inst.SoundEmitter:PlaySound("dontstarve/creatures/spider/spider_egg_sack")
    local x, y, z = inst.Transform:GetWorldPosition()
    SpawnPrefab("web_net_splat_fx").Transform:SetPosition(x, 0, z)

    if attacker ~= nil and not attacker:IsValid() then
        attacker = nil
    end

    -- stick whatever got actually hit by the projectile
    -- otherwise stick our target, if he was in splash radius
    if other == nil and attacker ~= nil then
        other = attacker.components.combat.target
        if other ~= nil and not (other:IsValid() and other:IsNear(inst, TUNING.SPAT_PHLEGM_RADIUS)) then
            other = nil
        end
    end

    if other ~= nil and other:IsValid() then
        if attacker ~= nil and attacker.components.weapon then
            attacker.components.combat:DoAttack(other, inst.components.complexprojectile.owningweapon, inst)
        end
        if other.components.pinnable ~= nil then
			
           other.components.pinnable:Stick("web_net_trap",splashprefabs)
				local widow = TheSim:FindFirstEntityWithTag("hoodedwidow")
				if widow ~= nil then
				widow.sg:GoToState("tossplayer")
				other:DoTaskInTime(1.3, function(other)
				other.components.pinnable:Unstick()
				local widowweb = TheSim:FindFirstEntityWithTag("widowweb")
				if widowweb ~= nil then
					if other:HasTag("wereplayer") then
						other.sg:GoToState("hit")
					else
						other.sg:GoToState("knockback")
					end	
                    local x, y, z = widowweb.Transform:GetWorldPosition() --Ripped knockback code, but it's rigged to go backwards.
                    local distsq = other:GetDistanceSqToPoint(x, y, z)
                    local rot = other.Transform:GetRotation()
                    local rot1 = distsq > 0 and other:GetAngleToPoint(x, y, z) or widowweb.Transform:GetRotation() + 180
                    local drot = math.abs(rot - rot1)
                    while drot > 180 do
                        drot = math.abs(drot - 360)
                    end
                    if drot > 90 then
                        other.Transform:SetRotation(rot1 + 180)
                        other.Physics:SetMotorVel(-30, 0, 0)
                    else
                        other.Transform:SetRotation(rot1)
                        other.Physics:SetMotorVel(30, 0, 0)
                    end
					local strings = TheSim:FindEntities(x,y,z,20,{"webchord"})
					for i, v in ipairs(strings) do
					    if drot > 90 then
							v.Transform:SetRotation(rot1 + 180)
							v.Physics:SetMotorVel(-30, 0, 0)
						else
							v.Transform:SetRotation(rot1)
							v.Physics:SetMotorVel(30, 0, 0)
						end
					end
					other:DoTaskInTime(0.6,function(other) other.Physics:SetMotorVel(0, 0, 0) end)
				end
			end)
			end
       end
    end
return other
end

local function OnProjectileHit(inst, attacker, other)
    doprojectilehit(inst, attacker, other)
    inst:Remove()
end
local function oncollide(inst, other)
    -- If there is a physics collision, try to do some damage to that thing.
    -- This is so you can't hide forever behind walls etc.

    local attacker = inst.components.complexprojectile.attacker
    if other ~= doprojectilehit(inst, attacker) and
        other ~= nil and
        other:IsValid() and
        other.components.combat ~= nil then
        if attacker ~= nil and attacker:IsValid() and attacker.components.weapon then
            attacker.components.combat:DoAttack(other, inst.components.complexprojectile.owningweapon, inst)
        end
        if other.components.pinnable ~= nil then
            other.components.pinnable:Stick("web_net_trap", splashprefabs)
        end
    end

    inst:Remove()
end

local function SpawnString(inst)
local x,y,z = inst.Transform:GetWorldPosition()
SpawnPrefab("widow_web_detrius").Transform:SetPosition(x,y,z)
end

local function projectilefn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddPhysics()
    inst.entity:AddNetwork()

    inst.Physics:SetMass(1)
    inst.Physics:SetFriction(10)
    inst.Physics:SetDamping(5)
    inst.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.WORLD)
    inst.Physics:CollidesWith(COLLISION.OBSTACLES)
    inst.Physics:CollidesWith(COLLISION.CHARACTERS)
    inst.Physics:SetCapsule(0.02, 0.02)

    inst.AnimState:SetBank("spat_bomb")
    inst.AnimState:SetBuild("web_net_shot")
    inst.AnimState:PlayAnimation("spin_loop", true)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.Physics:SetCollisionCallback(oncollide)

    inst.persists = false

    inst:AddComponent("locomotor")
    inst:AddComponent("complexprojectile")
    inst.components.complexprojectile:SetOnHit(OnProjectileHit)
    inst.components.complexprojectile:SetHorizontalSpeed(30)
    inst.components.complexprojectile:SetLaunchOffset(Vector3(3, 2, 0))
    inst.components.complexprojectile.usehigharc = false
	inst:DoPeriodicTask(0.05, SpawnString)

    return inst
end

local function doprojectilehit_queen(inst, attacker, other)
	inst.SoundEmitter:PlaySound("dontstarve/creatures/spider/spider_egg_sack")
    local x, y, z = inst.Transform:GetWorldPosition()
    SpawnPrefab("web_net_splat_fx").Transform:SetPosition(x, 0, z)

    if attacker ~= nil and not attacker:IsValid() then
        attacker = nil
    end

    -- stick whatever got actually hit by the projectile
    -- otherwise stick our target, if he was in splash radius
    if other == nil and attacker ~= nil then
        other = attacker.components.combat.target
        if other ~= nil and not (other:IsValid() and other:IsNear(inst, TUNING.SPAT_PHLEGM_RADIUS)) then
            other = nil
        end
    end

    if other ~= nil and other:IsValid() then
        if attacker ~= nil then
            attacker.components.combat:DoAttack(other, nil, inst)
        end
        if other.components.pinnable ~= nil then
            other.components.pinnable:Stick("web_net_trap",splashprefabs)
        end
    end

    return other
end

local function OnProjectileHit_queen(inst, attacker, other)
    doprojectilehit_queen(inst, attacker, other)
    inst:Remove()
end

local function oncollide_queen(inst, other)
    -- If there is a physics collision, try to do some damage to that thing.
    -- This is so you can't hide forever behind walls etc.

    local attacker = inst.components.complexprojectile.attacker
    if other ~= doprojectilehit_queen(inst, attacker) and
        other ~= nil and
        other:IsValid() and
        other.components.combat ~= nil then
        if attacker ~= nil and attacker:IsValid() and attacker.components.weapon then
            attacker.components.combat:DoAttack(other, nil, inst)
        end
        if other.components.pinnable ~= nil then
            other.components.pinnable:Stick("web_net_trap", splashprefabs)
        end
    end

    inst:Remove()
end

local function queenprojectilefn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddPhysics()
    inst.entity:AddNetwork()

    inst.Physics:SetMass(1)
    inst.Physics:SetFriction(10)
    inst.Physics:SetDamping(5)
    inst.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.WORLD)
    inst.Physics:CollidesWith(COLLISION.OBSTACLES)
    inst.Physics:CollidesWith(COLLISION.CHARACTERS)
    inst.Physics:SetCapsule(0.02, 0.02)

    inst.AnimState:SetBank("spat_bomb")
    inst.AnimState:SetBuild("web_net_shot")
    inst.AnimState:PlayAnimation("spin_loop", true)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.Physics:SetCollisionCallback(oncollide_queen)

    inst.persists = false

    inst:AddComponent("locomotor")
    inst:AddComponent("complexprojectile")
    inst.components.complexprojectile:SetOnHit(OnProjectileHit_queen)
    inst.components.complexprojectile:SetHorizontalSpeed(30)
    inst.components.complexprojectile:SetLaunchOffset(Vector3(3, 2, 0))
    inst.components.complexprojectile.usehigharc = false

    return inst
end

local function OnLand(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	SpawnPrefab("widow_web_combat").Transform:SetPosition(x,y,z)
	local players = TheSim:FindEntities(x,y,z,1.5,{"player"},{"ghost","wereplayer"})
	for i, v in ipairs(players) do
	v.components.pinnable:Stick("web_net_trap",splashprefabs)
	v:DoTaskInTime(1.5,function(v) v.components.pinnable:Unstick() end)
	end
    inst:Remove()
	
end
local function TestProjectileLand(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	if y <= inst:GetPhysicsRadius() + 0.001 	then
		OnLand(inst)
		inst:Remove()
	end
end


local function onthrown(inst)
    inst:AddTag("NOCLICK")
    inst.persists = false
    inst.AnimState:SetBank("spat_bomb")
    inst.AnimState:SetBuild("web_net_shot")  
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
local function projectilelobfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddPhysics()
    inst.entity:AddNetwork()



    inst.AnimState:SetBank("spat_bomb")
    inst.AnimState:SetBuild("web_net_shot")
    inst.AnimState:PlayAnimation("spin_loop", true)
	


    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("complexprojectile")
    inst.components.complexprojectile:SetHorizontalSpeed(15)
    inst.components.complexprojectile:SetGravity(-35)
    inst.components.complexprojectile:SetLaunchOffset(Vector3(0, 1, 0))
    inst.components.complexprojectile:SetOnLaunch(onthrown)
    inst.components.complexprojectile:SetOnHit(OnLand)

    inst.persists = false

    inst:AddComponent("locomotor")
    return inst
end


local function webbingfn()
		local inst = CreateEntity()
		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddNetwork()
		inst.entity:AddDynamicShadow()
		inst.entity:AddSoundEmitter()
		inst.entity:AddGroundCreepEntity()

		inst.AnimState:SetBank("widowwebgoop")
		inst.AnimState:SetBuild("widowwebgoop")
		inst.AnimState:PlayAnimation("idle")
		MakeInventoryPhysics(inst)
		inst.GroundCreepEntity:SetRadius(3)
		inst:AddTag("queensstuff")
		inst:AddTag("noauradamage")
		
		inst.entity:SetPristine()

		if not TheWorld.ismastersim then
			return inst
		end
		--inst:DoPeriodicTask(60,function(inst) if inst.components.health ~= nil then inst.components.health:DoDelta(-25) end end)
		inst:ListenForEvent("death", function(inst) inst:Remove() end)
		-------------------
		inst:AddComponent("health")
		inst.components.health:SetMaxHealth(100)
		inst:AddTag("soulless")
        inst:AddTag("noember")
		inst:AddComponent("combat")
		inst:ListenForEvent("death", function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/spider/spiderLair_destroy") end)
		inst:DoTaskInTime(0,function(inst)
			if not TheWorld.Map:IsPassableAtPoint(inst.Transform:GetWorldPosition()) then
				inst:Remove()
			end
		end)
		inst:DoPeriodicTask(3,function(inst) if inst.components.health ~= nil then inst.components.health:DoDelta(-5) end end)
		return inst
end

local function webdetriusfn()
		local inst = CreateEntity()
		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddNetwork()
		inst.entity:AddDynamicShadow()
		inst.entity:AddSoundEmitter()

		inst.AnimState:SetBank("widowwebgoop")
		inst.AnimState:SetBuild("widowwebgoop")
		inst.AnimState:PlayAnimation("idle")
		MakeInventoryPhysics(inst)
		inst:AddTag("webchord")
		inst.entity:SetPristine()

		if not TheWorld.ismastersim then
			return inst
		end
		inst:DoTaskInTime(1.8,function(inst) inst:Remove() end)
		return inst
end

return Prefab("widow_web_detrius", webdetriusfn),
		Prefab("widow_web_combat", webbingfn),
		Prefab("web_mortar", projectilelobfn),
		Prefab("web_bomb", projectilefn),
		Prefab("queen_web_bomb", queenprojectilefn)