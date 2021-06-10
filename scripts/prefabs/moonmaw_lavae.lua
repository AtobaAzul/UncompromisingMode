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
local TARGET_IGNORE_TAGS = { "INLIMBO", "moonglasscreature" }

local function destroystuff(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
	
	local sizecheck = 1 + (inst.Transform:GetScale() * 2) or 0
	print(sizecheck)
    local ents = TheSim:FindEntities(x, y, z, sizecheck, nil, TARGET_IGNORE_TAGS, TARGET_TAGS)
    for i, v in ipairs(ents) do
        --stuff might become invalid as we work or damage during iteration
        if v ~= inst.WINDSTAFF_CASTER and v:IsValid() and inst.destroy == true then
            if v.components.health ~= nil and
                not v.components.health:IsDead() and
                v.components.combat ~= nil and
                v.components.combat:CanBeAttacked() then
                local damage = TUNING.TORNADO_DAMAGE
                v.components.combat:GetAttacked(inst, damage, nil, "wind")
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
	inst.components.sizetweener:StartTween(2, 1.5, shrinktask)
end

local function Reposition(inst)
if inst.WINDSTAFF_CASTER ~= nil then
	local x,y,z = inst.WINDSTAFF_CASTER.Transform:GetWorldPosition()
	inst.Transform:SetPosition(x,y,z)
end
end

local function lavaering_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	inst.entity:AddLight()
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
	--inst.timetorun = false

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
	inst:AddComponent("inspectable")
	inst:AddTag("moonglasscreature")
	
    --inst.SetDuration = SetDuration
    --inst:SetDuration(3000)
	
	inst.Destroy = false
	
	inst:DoTaskInTime(1, function(inst)
		inst:DoPeriodicTask(.4, destroystuff)
	end)
	inst:DoTaskInTime(0.1,Reposition)
    return inst
end


return Prefab("moonmaw_lavae_ring", lavaering_fn)
