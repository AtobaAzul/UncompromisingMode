local assets =
{
    Asset("ANIM", "anim/pig_king.zip"),
    Asset("SOUND", "sound/pig.fsb"),
}

local assets_minigame =
{
    Asset("ANIM", "anim/pig_guard_build.zip"),
    Asset("ANIM", "anim/pig_elite_build.zip"),
}

local prefabs =
{
    "goldnugget",
}

local function launchitem(item, angle)
    local speed = math.random() * 4 + 2
    angle = (angle + math.random() * 60 - 30) * DEGREES
    item.Physics:SetVel(speed * math.cos(angle), math.random() * 2 + 8, speed * math.sin(angle))
end

local function ontradeforgold(inst, item, giver)

    local x, y, z = inst.Transform:GetWorldPosition()
    y = 4.5

    local angle
    if giver ~= nil and giver:IsValid() then
        angle = 180 - giver:GetAngleToPoint(x, 0, z)
    else
        local down = TheCamera:GetDownVec()
        angle = math.atan2(down.z, down.x) / DEGREES
        giver = nil
    end

    for k = 1, 1 do
        local nug = SpawnPrefab("goldnugget")
        nug.Transform:SetPosition(x, y, z)
        launchitem(nug, angle)
    end
end

local function OnGetItemFromPlayer(inst, giver, item)
	inst:DoTaskInTime(2 / 3, ontradeforgold, item, giver)
end

local function OnRefuseItem(inst, giver, item)
end

local function AbleToAcceptTest(inst, item, giver)
	if item.prefab == "rat_tail" then
		return true
	end
	return false
end

local function AcceptTest(inst, item, giver)
    return item.prefab == "rat_tail"
end

local function OnHaunt(inst, haunter)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, 1, .5)

    inst.MiniMapEntity:SetIcon("pigking.png")
    inst.MiniMapEntity:SetPriority(1)

    inst.DynamicShadow:SetSize(5, 2.5)

    --inst.Transform:SetScale(1.5, 1.5, 1.5)

    inst.AnimState:SetBank("ratking")
    inst.AnimState:SetBuild("ratking")
    inst.AnimState:SetFinalOffset(1)

    inst.AnimState:PlayAnimation("idle", true)

    --trader (from trader component) added to pristine state for optimization
    inst:AddTag("trader")

    inst:AddTag("king")
    inst:AddTag("birdblocker")
    inst:AddTag("antlion_sinkhole_blocker")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("trader")

    inst.components.trader:SetAbleToAcceptTest(AbleToAcceptTest)
    inst.components.trader:SetAcceptTest(AcceptTest)
    inst.components.trader.onaccept = OnGetItemFromPlayer
    inst.components.trader.onrefuse = OnRefuseItem

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    inst.components.hauntable:SetOnHauntFn(OnHaunt)

    return inst
end

--------------------------------------------------------------------------

return Prefab("ratking", fn, assets, prefabs)
