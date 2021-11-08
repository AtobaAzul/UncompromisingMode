local assets =
{
    Asset("ANIM", "anim/tornado.zip"),
}

local WORK_ACTIONS =
{
    CHOP = true,
    DIG = true,
    HAMMER = true,
    MINE = true,
}
local TARGET_TAGS = { "_combat" }
for k, v in pairs(WORK_ACTIONS) do
    table.insert(TARGET_TAGS, k.."_workable")
end
local TARGET_IGNORE_TAGS = { "gmooseegg", "INLIMBO", "mothergoose", "mossling", "moose", "mothergoose" }

local function destroystuff(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
	
	local sizecheck = 1 + (inst.Transform:GetScale() * 1.9) or 0
	print(sizecheck)
    local ents = TheSim:FindEntities(x, y, z, sizecheck, nil, TARGET_IGNORE_TAGS, TARGET_TAGS)
    for i, v in ipairs(ents) do
        --stuff might become invalid as we work or damage during iteration
        if v ~= inst.WINDSTAFF_CASTER and v:IsValid() then
            if v.components.health ~= nil and
                not v.components.health:IsDead() and
                v.components.combat ~= nil and
                v.components.combat:CanBeAttacked() then
                local damage = TUNING.TORNADO_DAMAGE
                v.components.combat:GetAttacked(inst, damage, nil, "wind")
                if v:IsValid() and
                    inst.WINDSTAFF_CASTER ~= nil and inst.WINDSTAFF_CASTER:IsValid() and
                    v.components.combat ~= nil and
                    not (v.components.health ~= nil and v.components.health:IsDead()) and
                    not (v.components.follower ~= nil and
                        v.components.follower.keepleaderonattacked and
                        v.components.follower:GetLeader() == inst.WINDSTAFF_CASTER) then
                    v.components.combat:SuggestTarget(inst.WINDSTAFF_CASTER)
                end
            --[[elseif v.components.workable ~= nil and
                v.components.workable:CanBeWorked() and
                v.components.workable:GetWorkAction() and
                WORK_ACTIONS[v.components.workable:GetWorkAction().id] then
                SpawnPrefab("collapse_small").Transform:SetPosition(v.Transform:GetWorldPosition())
                v.components.workable:WorkedBy(inst, 2)
                --v.components.workable:Destroy(inst)]]
            end
        end
    end
end

local function destroystuff_mini(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
	
	local sizecheck = 1 + (inst.Transform:GetScale() * 1.9) or 0
	print(sizecheck)
    local ents = TheSim:FindEntities(x, y, z, sizecheck, nil, TARGET_IGNORE_TAGS, TARGET_TAGS)
    for i, v in ipairs(ents) do
        --stuff might become invalid as we work or damage during iteration
        if v ~= inst.WINDSTAFF_CASTER and v:IsValid() then
            if v.components.health ~= nil and
                not v.components.health:IsDead() and
                v.components.combat ~= nil and
                v.components.combat:CanBeAttacked() then
                local damage = TUNING.TORNADO_DAMAGE
                v.components.combat:GetAttacked(inst, damage, nil, "wind")
                if v:IsValid() and
                    inst.WINDSTAFF_CASTER ~= nil and inst.WINDSTAFF_CASTER:IsValid() and
                    v.components.combat ~= nil and
                    not (v.components.health ~= nil and v.components.health:IsDead()) and
                    not (v.components.follower ~= nil and
                        v.components.follower.keepleaderonattacked and
                        v.components.follower:GetLeader() == inst.WINDSTAFF_CASTER) then
                    v.components.combat:SuggestTarget(inst.WINDSTAFF_CASTER)
                end
            elseif v.components.workable ~= nil and
                v.components.workable:CanBeWorked() and
                v.components.workable:GetWorkAction() and
                WORK_ACTIONS[v.components.workable:GetWorkAction().id] then
                SpawnPrefab("collapse_small").Transform:SetPosition(v.Transform:GetWorldPosition())
                v.components.workable:WorkedBy(inst, 2)
                --v.components.workable:Destroy(inst)
            end
        end
    end
end

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

local function Disappear(inst)
	inst.components.sizetweener:StartTween(0.05, 0.8, inst.Remove)
end

local function shrink(inst)
	--inst.sg:GoToState("run")
	inst.components.sizetweener:StartTween(0.4, 2.8, Disappear)
end

local function shrinktask(inst)
	--inst:DoPeriodicTask(0.5, function(inst) inst.components.circler.distance = inst.components.circler.distance + 0.1 end)
	
    if inst.components.linearcircler.clockwise then
		inst:DoTaskInTime(1.5, shrink)
	else
		inst:DoTaskInTime(5, shrink)
	end
end
		
local function grow(inst, time, startsize, endsize)
	inst.Transform:SetScale(0.1, 0.1, 0.1)
	inst.components.sizetweener:StartTween(2, 1.35, shrinktask)
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
    inst.AnimState:PlayAnimation("tornado_loop", true)

    inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/tornado", "spinLoop")

    MakeInventoryPhysics(inst)
    RemovePhysicsColliders(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.timetorun = false

    --inst:AddComponent("knownlocations")
	
	inst:AddComponent("sizetweener")
	
	inst:AddComponent("linearcircler")
	--[[inst.components.circler.scale = 1
	inst.components.circler.speed = 6
	inst.components.circler.minSpeed = 6
	inst.components.circler.maxSpeed = 6
	inst.components.circler.minDist = 1
	inst.components.circler.maxDist = 1
	inst.components.circler.minScale = 1
	inst.components.circler.maxScale = 1]]

    --[[inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = 6
    inst.components.locomotor.runspeed = 6]]

    --inst:SetStateGraph("SGmothergoose_tornado")
	--inst.sg:GoToState("idle")

    inst.WINDSTAFF_CASTER = nil
    inst.persists = false
	inst.grow = grow
	inst:grow()

    inst.SetDuration = SetDuration
    inst:SetDuration(3000)
	
	inst:DoTaskInTime(1, function(inst)
		inst:DoPeriodicTask(.4, destroystuff)
	end)

    return inst
end

local function Disappear_mini(inst)
	inst.components.sizetweener:StartTween(0.05, 0.2, inst.Remove)
end

local function shrink_mini(inst)
	--inst.sg:GoToState("run")
	inst.components.sizetweener:StartTween(0.2, 0.8, Disappear_mini)
end

local function shrinktask_mini(inst)
	inst:DoTaskInTime(1.5, shrink_mini)
end
		
local function grow_mini(inst, time, startsize, endsize)
	inst.Transform:SetScale(0.1, 0.1, 0.1)
	inst.components.sizetweener:StartTween(0.8, 0.7, shrinktask_mini)
end

local function minitornado_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	inst.AnimState:SetFinalOffset(2)
    inst.AnimState:SetBank("tornado")
    inst.AnimState:SetBuild("tornado")
    inst.AnimState:PlayAnimation("tornado_loop", true)

    inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/tornado", "spinLoop")

    MakeInventoryPhysics(inst)
    RemovePhysicsColliders(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.timetorun = false

    --inst:AddComponent("knownlocations")
	
	inst:AddComponent("sizetweener")
	
	inst:AddComponent("linearcircler")
	--[[inst.components.circler.scale = 1
	inst.components.circler.speed = 6
	inst.components.circler.minSpeed = 6
	inst.components.circler.maxSpeed = 6
	inst.components.circler.minDist = 1
	inst.components.circler.maxDist = 1
	inst.components.circler.minScale = 1
	inst.components.circler.maxScale = 1]]

    --[[inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = 6
    inst.components.locomotor.runspeed = 6]]

    --inst:SetStateGraph("SGmothergoose_tornado")
	--inst.sg:GoToState("idle")

    inst.WINDSTAFF_CASTER = nil
    inst.persists = false
	inst.grow_mini = grow_mini
	inst:grow_mini()

    inst.SetDuration = SetDuration
    inst:SetDuration(3000)
	
	inst:DoTaskInTime(0.2, function(inst)
		inst:DoPeriodicTask(.4, destroystuff_mini)
	end)

    return inst
end

return Prefab("mothergoose_tornado", tornado_fn, assets),
		Prefab("mini_mothergoose_tornado", minitornado_fn, assets)
