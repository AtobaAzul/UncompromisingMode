local brain = require("brains/armorlavaebrain")

local function OnAttackOther(inst,data)
if data.target ~= nil and data.target.components.combat ~= nil and data.target.components.combat.target == nil then
	if inst.components.follower.leader ~= nil then
		data.target.components.combat:SuggestTarget(inst.components.follower.leader)
	end
end
end
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    inst.DynamicShadow:SetSize(2, 1)
    inst.Transform:SetSixFaced()

    ----------------------------------------------------
    inst.entity:AddPhysics()
    inst.Physics:SetMass(1)
    inst.Physics:SetFriction(0)
    inst.Physics:SetDamping(5)
    inst.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.WORLD)
    inst.Physics:CollidesWith(COLLISION.OBSTACLES)
    inst.Physics:CollidesWith(COLLISION.SMALLOBSTACLES)
    inst.Physics:CollidesWith(COLLISION.CHARACTERS)
    inst.Physics:SetCapsule(.5, 1)
    ----------------------------------------------------

    inst.AnimState:SetBank("lavae")
    inst.AnimState:SetBuild("lavae")
    inst.AnimState:PlayAnimation("idle")


    inst.Light:SetRadius(.1)
    inst.Light:SetFalloff(0.5)
    inst.Light:SetIntensity(0.75)
    inst.Light:SetColour(235/255, 121/255, 12/255)
    inst.Light:Enable(true)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddTag("scarytoprey")
    inst:AddComponent("combat")
    inst:AddComponent("inspectable")
    inst:AddComponent("locomotor")
    inst:SetStateGraph("SGarmorlavae")
	
	inst:AddTag("shadow") --Prevent enemies from trying to target it
    inst:SetBrain(brain)
	inst.Transform:SetScale(0.6,0.6,0.6)


    inst.components.combat:SetDefaultDamage(20)
    inst.components.combat:SetRange(TUNING.LAVAE_ATTACK_RANGE*0.6, TUNING.LAVAE_HIT_RANGE*0.6)
    inst.components.combat:SetAttackPeriod(4)

    inst.components.locomotor.walkspeed = 11

	inst:AddComponent("follower")
	inst:AddComponent("lootdropper")
    MakeHauntablePanic(inst)
	--inst.persists = false
	inst:DoTaskInTime(0,function(inst) if inst.components.follower.leader == nil then inst:Remove() end end)
	
	inst:ListenForEvent("onattackother", OnAttackOther)
    return inst
end

return Prefab("armorlavae", fn)
