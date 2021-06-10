local TARGET_IGNORE_TAGS = { "INLIMBO", "moonglasscreature" }

local function destroystuff(inst)
	if inst.WINDSTAFF_CASTER == nil then
		inst:Remove()
	end
    local x, y, z = inst.Transform:GetWorldPosition()
	
    local ents = TheSim:FindEntities(x, y, z, 3, nil, TARGET_IGNORE_TAGS, TARGET_TAGS)
    for i, v in ipairs(ents) do
        if v ~= inst.WINDSTAFF_CASTER and v:IsValid() and inst.destroy == true then
            if v.components.health ~= nil and
                not v.components.health:IsDead() and
                v.components.combat ~= nil and
                v.components.combat:CanBeAttacked() then
                local damage = TUNING.TORNADO_DAMAGE
                v.components.combat:GetAttacked(inst, damage, nil, "glass")
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

local function lavaering_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	inst.entity:AddLight()
	inst.entity:AddDynamicShadow()
	
	inst.DynamicShadow:SetSize(2, 2)
	
	
	inst.AnimState:SetFinalOffset(2)
    inst.AnimState:SetBank("moonmaw_lavae")
    inst.AnimState:SetBuild("moonmaw_lavae")
    inst.AnimState:PlayAnimation("hover", true)

    --inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/tornado", "spinLoop")
	inst.Transform:SetFourFaced()
	
    MakeInventoryPhysics(inst)
    RemovePhysicsColliders(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
    local light = inst.entity:AddLight()
    inst.Light:Enable(true)
    inst.Light:SetRadius(2)
    inst.Light:SetFalloff(0.5)
    inst.Light:SetIntensity(.75)
    inst.Light:SetColour(121/255,235/255,12/255)	

	inst:AddComponent("linearcircler")

    inst.WINDSTAFF_CASTER = nil
	inst:AddComponent("inspectable")
	inst:AddTag("moonglasscreature")

	inst.Destroy = false
	
	inst:DoTaskInTime(1, function(inst)
		inst:DoPeriodicTask(.4, destroystuff)
	end)
	inst:DoTaskInTime(0.1,Reposition)
    return inst
end

local function KeepTargetFn(inst, target)
   return target
          and target.components.combat
          and target.components.health
          and not target.components.health:IsDead()
end

local function NormalRetarget(inst)
    local targetDist = 10
    return FindEntity(inst, targetDist, 
        function(guy) 
            if inst.components.combat:CanTarget(guy) then
                return not guy:HasTag("moonglasscreature")
            end
    end)
end

local brain = require "brains/moonmaw_lavaebrain"
local function lavae_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	inst.entity:AddLight()
	inst.entity:AddDynamicShadow()
	
	inst.DynamicShadow:SetSize(2, 2)
	
	
	inst.AnimState:SetFinalOffset(2)
    inst.AnimState:SetBank("moonmaw_lavae")
    inst.AnimState:SetBuild("moonmaw_lavae")
    inst.AnimState:PlayAnimation("hover", true)

    --inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/tornado", "spinLoop")
	inst.Transform:SetFourFaced()
	
    MakeInventoryPhysics(inst)
    RemovePhysicsColliders(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
    local light = inst.entity:AddLight()
    inst.Light:Enable(true)
    inst.Light:SetRadius(2)
    inst.Light:SetFalloff(0.5)
    inst.Light:SetIntensity(.75)
    inst.Light:SetColour(121/255,235/255,12/255)	

    inst.WINDSTAFF_CASTER = nil
	inst:AddComponent("inspectable")
	inst:AddTag("moonglasscreature")


    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(350)
    inst.components.health.destroytime = 5
    inst.components.health.fire_damage_scale = 0

    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(50)
    inst.components.combat.playerdamagepercent = .5
    inst.components.combat:SetRange(2)
    inst.components.combat:SetAttackPeriod(1)
    inst.components.combat:SetRetargetFunction(3, NormalRetarget)
    inst.components.combat:SetKeepTargetFunction(KeepTargetFn)
    inst.components.combat.battlecryenabled = false
    inst.components.combat:SetHurtSound("dontstarve_DLC001/creatures/dragonfly/hurt")
	

    inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = 6
    inst.components.locomotor.runspeed = 8

    inst:SetStateGraph("SGmoonmaw_lavae")
    inst:SetBrain(brain)

	
    return inst
end

return Prefab("moonmaw_lavae_ring", lavaering_fn),
Prefab("moonmaw_lavae",lavae_fn)
