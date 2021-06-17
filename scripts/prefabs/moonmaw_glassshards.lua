local TARGET_IGNORE_TAGS = { "INLIMBO", "moonglasscreature" }

local function destroystuff(inst)
	
	if inst.WINDSTAFF_CASTER == nil then
		inst:Remove()
	end
	if inst.destroy == true and inst.hidden ~= true then
    local x, y, z = inst.Transform:GetWorldPosition()
	
    local ents = TheSim:FindEntities(x, y, z, 2, nil, TARGET_IGNORE_TAGS, {"_health"})
    for i, v in ipairs(ents) do
        if v ~= inst.WINDSTAFF_CASTER and v:IsValid() then
            if v.components.health ~= nil and
                not v.components.health:IsDead() and
                v.components.combat ~= nil and
                v.components.combat:CanBeAttacked() then
                local damage = 40
                v.components.combat:GetAttacked(inst, damage, nil, "glass")
				
				if v:HasTag("player") and not (v.components.rider ~= nil and v.components.rider:IsRiding())then
					if v.moonmaw_lavae_stun == nil then
						v.moonmaw_lavae_stun = 0
					end
					v.moonmaw_lavae_stun = v.moonmaw_lavae_stun+1
					if v.moonmaw_lavae_stun > 4 then
					v:PushEvent("knockback", {knocker = inst.WINDSTAFF_CASTER, radius = 1, strengthmult = 1})
					v:DoTaskInTime(1.5,function(v) v.moonmaw_lavae_stun = 0 end)
					end
				end
            end
        end
    end
	end
end

local function Reposition(inst)
if inst.WINDSTAFF_CASTER ~= nil then
	local x,y,z = inst.WINDSTAFF_CASTER.Transform:GetWorldPosition()
	if x ~= nil and y ~= nil and z ~= nil then
		inst.Transform:SetPosition(x,y,z)
	else
		inst:Remove()
	end
end
end

local function CheckDist(inst)
if inst.WINDSTAFF_CASTER ~= nil then
	if inst:GetDistanceSqToInst(inst.WINDSTAFF_CASTER) > 15 then
		local x,y,z = inst.WINDSTAFF_CASTER.Transform:GetWorldPosition()
		inst.Transform:SetPosition(x,y,z)
	end
else
	inst:Remove()
end
end

local function shardring_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	inst.entity:AddLight()
	inst.entity:AddDynamicShadow()
	
	
	inst.AnimState:SetFinalOffset(0.5)
    inst.AnimState:SetBank("armor_glassmail_shards")
    inst.AnimState:SetBuild("armor_glassmail_shards")
	
    MakeInventoryPhysics(inst)
    RemovePhysicsColliders(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	inst.anim = math.random(0,4)
	inst.AnimState:PlayAnimation(inst.anim, true)
    local light = inst.entity:AddLight()
    inst.Light:Enable(true)
    inst.Light:SetRadius(2)
    inst.Light:SetFalloff(0.5)
    inst.Light:SetIntensity(.75)
    inst.Light:SetColour(121/255,235/255,12/255)	

	inst:AddComponent("linearcircler")
	inst:AddComponent("leader")

    inst.WINDSTAFF_CASTER = nil
	inst:AddComponent("inspectable")
	inst:AddTag("moonglasscreature")

	inst.Destroy = false
	
	inst:DoTaskInTime(1, function(inst)
		inst:DoPeriodicTask(.2, destroystuff)
		inst:DoPeriodicTask(10,CheckDist)
	end)
	inst.damagetime = 0.1
	inst:DoTaskInTime(inst.damagetime,Reposition)
    return inst
end

local function pipethrown(inst)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:PlayAnimation(inst.anim)
    inst:AddTag("NOCLICK")
    inst.persists = false
end

local function onhit(inst, attacker, target)

    if not target:IsValid() or target:HasTag("moonglasscreature") then
        --target killed or removed in combat damage phase
        return
    end

    if target.components.sleeper ~= nil and target.components.sleeper:IsAsleep() then
        target.components.sleeper:WakeUp()
    end


    if target.components.combat ~= nil then
        target.components.combat:SuggestTarget(attacker)
    end

    if target.sg ~= nil and not target.sg:HasStateTag("frozen") then
        target:PushEvent("attacked", { attacker = attacker, damage = 50, weapon = inst })
    end

	inst:Remove()
end

local function shard_fn()
	local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    RemovePhysicsColliders(inst)
	
	inst.AnimState:SetFinalOffset(0.5)
    inst.AnimState:SetBank("armor_glassmail_shards")
    inst.AnimState:SetBuild("armor_glassmail_shards")

	
    inst:AddTag("NOCLICK")
    inst:AddTag("sharp")
    inst:AddTag("weapon")
    inst:AddTag("projectile")
	
    inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	inst.anim = 1
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(0)
	
    inst:AddComponent("projectile")
    inst.components.projectile:SetSpeed(25)
    inst.components.projectile:SetOnThrownFn(pipethrown)
    inst.components.projectile:SetHoming(false)
    inst.components.projectile:SetHitDist(math.sqrt(3))
    inst.components.projectile:SetOnHitFn(onhit)
    inst.components.projectile:SetOnMissFn(inst.Remove)
    inst.components.projectile:SetLaunchOffset(Vector3(0, 0.5, 0))
	
    inst.persists = false

    return inst
end
return Prefab("moonmaw_glassshards_ring", shardring_fn),
Prefab("moonmaw_glassshards",shard_fn)
