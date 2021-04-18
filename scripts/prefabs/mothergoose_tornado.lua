local assets =
{
    Asset("ANIM", "anim/tornado.zip"),
}

local function ontornadolifetime(inst)
    inst.task = nil
    inst.sg:GoToState("despawn")
end

local function SetDuration(inst, duration)
    if inst.task ~= nil then
        inst.task:Cancel()
    end
    inst.task = inst:DoTaskInTime(duration, ontornadolifetime)
end

local function shrink(inst)
	inst.timetorun = true
	inst.sg:GoToState("run")
	inst.components.sizetweener:StartTween(0.1, 2.9, inst.Remove)
end

local function shrinktask(inst)
	inst:DoTaskInTime(1, shrink)
end
		
local function grow(inst, time, startsize, endsize)
	inst.Transform:SetScale(0.1, 0.1, 0.1)
	inst.components.sizetweener:StartTween(1.5, 1.5, shrinktask)
end

local function tornado_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetFinalOffset(2)
    inst.AnimState:SetBank("tornado")
    inst.AnimState:SetBuild("tornado")

    inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/tornado", "spinLoop")

    MakeInventoryPhysics(inst)
    RemovePhysicsColliders(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.timetorun = false

    inst:AddComponent("knownlocations")
	
	inst:AddComponent("sizetweener")

    inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = 6
    inst.components.locomotor.runspeed = 6

    inst:SetStateGraph("SGmothergoose_tornado")
	inst.sg:GoToState("idle")

    inst.WINDSTAFF_CASTER = nil
    inst.persists = false
	inst.grow = grow
	inst:grow()

    inst.SetDuration = SetDuration
    inst:SetDuration(3000)
	

    return inst
end

return Prefab("mothergoose_tornado", tornado_fn, assets)
