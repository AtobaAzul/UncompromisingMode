local easing = require("easing")

local assets =
{
    Asset("ANIM", "anim/cavein_boulder.zip"),
    Asset("ANIM", "anim/swap_minotaur_boulder.zip"),
    Asset("MINIMAP_IMAGE", "cavein_formation"),
}

local dustassets =
{
    Asset("ANIM", "anim/cavein_dust_fx.zip"),
}

local prefabs =
{
    "rocks",
    "flint",
    "rock_break_fx",
    "cavein_dust_low",
    "cavein_dust_high",
}

SetSharedLootTable("cavein_boulder",
{
	{ "rocks",  .1 },
    { "flint",  .1 },
})



local PHYSICS_RADIUS = 1.5

local PLAYER_OVERLAP_RADIUS = 1
local OVERLAP_RADIUS = 1
local FORMATION_RADIUS = 2.5
local MINIMAP_RADIUS = 3

--------------------------------------------------------------------------
--Minimap icons

local function SetIconEnabled(inst, enable)
    if enable then
        if inst._iconpos == nil then
            inst._iconpos = inst:GetPosition()
            inst.MiniMapEntity:SetEnabled(true)
        end
    elseif inst._iconpos ~= nil then
        inst._iconpos = nil
        inst.MiniMapEntity:SetEnabled(false)
    end
end

local function UpdateIcon(inst)
    if inst._inittask ~= nil then
        inst._inittask:Cancel()
        inst._inittask = nil
    end
    if inst.fallingtask ~= nil then
        SetIconEnabled(inst, false)
    elseif inst.raised or inst.components.heavyobstaclephysics:IsItem() then
        SetIconEnabled(inst, true)
    elseif inst.formed or inst.components.heavyobstaclephysics:IsFalling() then
        SetIconEnabled(inst, false)
    else
        local x, y, z = inst.Transform:GetWorldPosition()
        for i, v in ipairs(TheSim:FindEntities(x, 0, z, MINIMAP_RADIUS, { "caveindebris" }, { "INLIMBO" })) do
            if v ~= inst and v._iconpos ~= nil and v.prefab == inst.prefab then
                SetIconEnabled(inst, false)
                return
            end
        end
        SetIconEnabled(inst, true)
    end
end

local function OnRemoveIcon(inst)
    if inst._iconpos ~= nil then
        local ents = TheSim:FindEntities(inst._iconpos.x, 0, inst._iconpos.z, MINIMAP_RADIUS, { "caveindebris" }, { "INLIMBO" })
        SetIconEnabled(inst, false)
        for i, v in ipairs(ents) do
            if v ~= inst and v._iconpos == nil and v.prefab == inst.prefab then
                UpdateIcon(v)
            end
        end
    end
end

--------------------------------------------------------------------------
--workable, inventoryitem, etc.

local function OnWorked(inst, worker)
    local pt = inst:GetPosition()
    SpawnPrefab("rock_break_fx").Transform:SetPosition(pt:Get())
    SpawnPrefab("collapse_big").Transform:SetPosition(pt:Get())
    if inst.raised then
        pt.y = 2
        inst.components.lootdropper:DropLoot(pt)
    elseif inst.formed and worker ~= nil and worker.sg ~= nil and worker.sg:HasStateTag("working") then
        for i, v in ipairs(inst.components.lootdropper:GenerateLoot()) do
            local loot = SpawnPrefab(v)
            --loot.components.inventoryitem:InheritMoisture(inst.components.inventoryitem:GetMoisture(), inst.components.inventoryitem:IsWet())
            LaunchAt(loot, inst, worker, 1, 1)
        end
    else
        inst.components.lootdropper:DropLoot(pt)
    end

	
	
    inst:Remove()
end

local function UpdateActions(inst)
    --inst.components.inventoryitem.canbepickedup = not inst.raised and not inst.components.heavyobstaclephysics:IsFalling() and inst.fallingtask == nil
    inst.components.workable:SetWorkable(not inst.raised and inst.fallingtask == nil)
end

--------------------------------------------------------------------------
--Wobbling base boulders

local function CancelWobbleTask(inst)
    if inst.wobbletask ~= nil then
        inst.wobbletask:Cancel()
        inst.wobbletask = nil
    end
end

local function OnWobble(inst)
    inst.wobbletask = nil
    inst.AnimState:PlayAnimation("wobble_less")
    inst.AnimState:PushAnimation("idle", false)
end

local function Wobble(inst, delay)
    if inst.wobbletask ~= nil then
        inst.wobbletask:Cancel()
    end
    inst.wobbletask = inst:DoTaskInTime(delay, OnWobble)
end

--------------------------------------------------------------------------
--Tracking propped up boulders

local function CancelFallingTask(inst)
    if inst.fallingtask ~= nil then
        inst.fallingtask:Cancel()
        inst.fallingtask = nil
        inst.fallingpos = nil
        UpdateIcon(inst)
        UpdateActions(inst)
        inst.AnimState:PlayAnimation("idle")
    end
end

local function OnFalling(inst, startpos, starttime, duration)
    local t = math.max(0, GetTime() - starttime)
    if t < duration then
        local pos = startpos + (inst.fallingpos - startpos) * easing.inOutQuad(t, 0, 1, duration)
        inst.Transform:SetPosition(pos:Get())
    else
        inst.Physics:Teleport(inst.fallingpos:Get())
        inst.fallingtask:Cancel()
        inst.fallingtask = nil
        inst.fallingpos = nil
        UpdateIcon(inst)
        UpdateActions(inst)
    end
end

local function StopTrackingRaisedBoulder(base)
    local target = base.components.entitytracker:GetEntity("propped")
    if target ~= nil then
        base.components.entitytracker:ForgetEntity("propped")
        base:RemoveEventCallback("onremove", base._onremoveraisedboulder, target)
        base:RemoveEventCallback("enterlimbo", base._onremoveraisedboulder, target)
        base:RemoveEventCallback("dropraisedboulder", base._onremoveraisedboulder, target)
    end
    base._basepos = nil
end

local function TrackRaisedBoulder(base, target)
    base._basepos = base:GetPosition()
    base._basepos.y = 0
    base:ListenForEvent("onremove", base._onremoveraisedboulder, target)
    base:ListenForEvent("enterlimbo", base._onremoveraisedboulder, target)
    base:ListenForEvent("dropraisedboulder", base._onremoveraisedboulder, target)
end

local function StartTrackingRaisedBoulder(base, target)
    base.components.entitytracker:TrackEntity("propped", target)
    TrackRaisedBoulder(base, target)
end

--------------------------------------------------------------------------
--Boulder variations


local function SetRaised(inst, raised)
    if raised then
        if not (inst.raised) then
            inst.raised = true
            CancelWobbleTask(inst)
            inst.AnimState:PlayAnimation("idle_raised")
            inst.MiniMapEntity:SetIcon("cavein_formation.png")
            UpdateIcon(inst)
            UpdateActions(inst)
            if inst.components.entitytracker ~= nil then
                StopTrackingRaisedBoulder(inst)
                inst:RemoveComponent("entitytracker")
            end
        end
    elseif inst.raised then
        inst.raised = nil
        CancelWobbleTask(inst)
        if inst.AnimState:IsCurrentAnimation("idle_raised") then
            inst.AnimState:PlayAnimation("idle")
        end
        inst.MiniMapEntity:SetIcon("cavein_boulder.png")
        UpdateIcon(inst)
        UpdateActions(inst)
        if inst.formed then
            inst:AddComponent("entitytracker")
        end
        inst:PushEvent("dropraisedboulder")
    end
end

local function SetFormed(inst, formed)
    if formed then
        if not inst.formed then
            inst.formed = true
            UpdateIcon(inst)
            if not inst.raised then
                inst:AddComponent("entitytracker")
            end
        end
    elseif inst.formed then
        inst.formed = nil
        UpdateIcon(inst)
        if inst.components.entitytracker ~= nil then
            StopTrackingRaisedBoulder(inst)
            inst:RemoveComponent("entitytracker")
        end
    end
end

local function OnSave(inst, data)
    data.variation = inst.variation
    data.raised = inst.raised
    data.formed = inst.formed and not inst.raised or nil
    if inst.fallingpos ~= nil then
        data.fallx = inst.fallingpos.x
        data.fallz = inst.fallingpos.z
    end
end

local function OnPreLoad(inst, data)
    SetRaised(inst, data ~= nil and data.raised)
    SetFormed(inst, data ~= nil and (data.formed or data.raised))
    if data ~= nil and not inst.raised and data.fallx ~= nil and data.fallz ~= nil then
        inst.Physics:Teleport(data.fallx, 0, data.fallz)
    end
end

local function OnLoadPostPass(inst)--, newents, data)
    if inst.formed and not inst.raised then
        local raisedboulder = inst.components.entitytracker:GetEntity("propped")
        if raisedboulder ~= nil then
            TrackRaisedBoulder(inst, raisedboulder)
        end
    end
    if inst._icontask ~= nil then
        UpdateIcon(inst)
    end
	
	inst.components.workable:Destroy(inst)
	
end

--------------------------------------------------------------------------
--Formations

local function GetBoulders()
    local t =
    {
        all = {},
        raised = { 1, 4, 6, 7 },
    }
    for i = 1, NUM_VARIATIONS do
        table.insert(t.all, i)
    end
    for i = #t.raised, 1, -1 do
        if t.raised[i] <= NUM_VARIATIONS then
            return t
        end
        table.remove(t.raised, i)
    end
    return t
end

local function PickBoulder(t, raised)
    if raised and #t.raised > 0 then
        local boulder = table.remove(t.raised, math.random(#t.raised))
        for i, v in ipairs(t.all) do
            if v == boulder then
                table.remove(t.all, i)
                break
            end
        end
        return boulder
    end
    local boulder = table.remove(t.all, math.random(#t.all))
    if not raised and #t.raised > 0 then
        for i, v in ipairs(t.raised) do
            if v == boulder then
                table.remove(t.raised, i)
                break
            end
        end
    end
    return boulder
end

local function MakeQuadFormation()
    local t = GetBoulders()
    return {
        { variation = PickBoulder(t, true), offset = { x = 0, z = 0 }, raised = true },
        { variation = PickBoulder(t, false), offset = { x = 0, z = 1 } },
        { variation = PickBoulder(t, false), offset = { x = -1, z = 0 } },
        { variation = PickBoulder(t, false), offset = { x = 0, z = -1 } },
        { variation = PickBoulder(t, false), offset = { x = 1, z = 0 } },
    }
end
--[[
local function MakeTriFormation()
    local t = GetBoulders()
    local r = .95
    local angle = 30 * DEGREES
    local dx = r * math.cos(angle)
    local dz = -r * math.sin(angle)
    return {
        { variation = PickBoulder(t, false), offset = { x = 0, z = r } },
        { variation = PickBoulder(t, false), offset = { x = dx, z = dz } },
        { variation = PickBoulder(t, false), offset = { x = -dx, z = dz } },
    }
end

local function MakeDuoFormation()
    local t = GetBoulders()
    return {
        { variation = PickBoulder(t, false), offset = { x = 0, z = .75 } },
        { variation = PickBoulder(t, false), offset = { x = 0, z = -.75 } },
    }
end
]]
local function CreateFormation(boulders)
    local x, z = 0, 0
    for i, v in ipairs(boulders) do
        local x1, y1, z1 = v.Transform:GetWorldPosition()
        x = x + x1
        z = z + z1
    end
    x = x / #boulders
    z = z / #boulders

    local formation = MakeQuadFormation()
    local angle = math.random() * PI * 2
    local cosa = math.cos(angle)
    local sina = math.sin(angle)
    local raisedboulder = nil
    for i, v in ipairs(formation) do
        local boulder = boulders[i]
        local x1 = x + v.offset.x * cosa - v.offset.z * sina
        local z1 = z + v.offset.x * sina + v.offset.z * cosa
        local fx = SpawnPrefab(v.raised and "cavein_dust_high" or "cavein_dust_low")
        fx.Transform:SetPosition(x1, 0, z1)
        fx:SkipToFull()
        if v.raised then
            fx:PlaySoundFX()
        end
        boulder.Physics:Teleport(x1, 0, z1)
        SetRaised(boulder, v.raised)
        SetFormed(boulder, true)
        if v.raised then
            raisedboulder = boulder
        elseif raisedboulder ~= nil then
            StartTrackingRaisedBoulder(boulder, raisedboulder)
        end
    end

    for i, v in ipairs(boulders) do
        if v.formed then
            local x1, y1, z1 = v.Transform:GetWorldPosition()
            for i2, v2 in ipairs(TheSim:FindEntities(x1, 0, z1, OVERLAP_RADIUS, { "boulder", "heavy" }, { "INLIMBO" })) do
                if not (v2.formed or (v2.components.heavyobstaclephysics ~= nil and v2.components.heavyobstaclephysics:IsFalling())) then
                    v2:Remove()
                end
            end
        end
    end
end

local function TryFormationAt(x, y, z)
    local boulders = {}
    local ents = TheSim:FindEntities(x, 0, z, FORMATION_RADIUS, { "boulder", "heavy" }, { "INLIMBO" })
    for i, v in ipairs(ents) do
        if v.prefab == "cavein_boulder" and
            not (v.formed or
                v.raised or
                (v.components.heavyobstaclephysics ~= nil and v.components.heavyobstaclephysics:IsFalling())) then
            table.insert(boulders, v)
            if #boulders >= 5 then
                CreateFormation(boulders)
                return
            end
        end
    end
end

--------------------------------------------------------------------------
--Physics stuff

local function OnPhysicsStateChanged(inst, state)
    UpdateIcon(inst)
    UpdateActions(inst)
end

local function OnChangeToItem(inst)
    SetFormed(inst, false)
    SetRaised(inst, false)
    CancelWobbleTask(inst)
    CancelFallingTask(inst)
    if not inst.AnimState:IsCurrentAnimation("idle") then
        inst.AnimState:PlayAnimation("idle")
    end
end

local function OnStartFalling(inst)
    inst.SoundEmitter:PlaySound("dontstarve/common/meteor_spawn")
    inst.SoundEmitter:PlaySound("dontstarve/common/meteor_spawn")
    SetFormed(inst, false)
    SetRaised(inst, false)
end

local function DestroyBoulder(inst)
	inst.components.workable:Destroy(inst)
end

local function OnStopFalling(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
	
    inst.components.groundpounder:GroundPound()
    inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/bearger/groundpound",nil,.5)
	
	
    if IsAnyPlayerInRange(x, 0, z, PLAYER_OVERLAP_RADIUS) then
        local fx = SpawnPrefab("cavein_dust_low")
        fx.Transform:SetPosition(x, 0, z)
        fx:PlaySoundFX()
        inst.components.workable:Destroy(inst)
    else
        TryFormationAt(x, 0, z)
        if not inst.formed then
            local fx = SpawnPrefab("cavein_dust_low")
            fx.Transform:SetPosition(x, 0, z)
            fx:PlaySoundFX()
            for i, v in ipairs(TheSim:FindEntities(x, 0, z, OVERLAP_RADIUS, { "boulder", "heavy" }, { "INLIMBO" })) do
                if v.formed then
                    inst.components.workable:Destroy(inst)
                    return
                end
            end
            inst.Physics:Teleport(x, 0, z)
        end
    end
	
	inst.components.timer:StartTimer("break", 100)
        
	--inst.components.workable:Destroy(inst)
end

local function OnTimerDone(inst, data)
    inst.components.workable:Destroy(inst)
end

--------------------------------------------------------------------------

local function OnRemoveRaisedBoulder(inst, target)
    SetFormed(inst, false)
    if target.fallingpos ~= nil then
        if inst:GetDistanceSqToPoint(target.fallingpos) > 2.25 then
            Wobble(inst, 3 * FRAMES)
        else
            Wobble(inst, (5 + math.random() * 3) * FRAMES)
        end
    end
end

local function OnRemoveFromScene(inst)
    OnRemoveIcon(inst)
    if inst.components.entitytracker ~= nil then
        local target = inst.components.entitytracker:GetEntity("propped")
        if target ~= nil and target.raised then
            CancelWobbleTask(inst)
            target.AnimState:PlayAnimation("fall")
            target.AnimState:PushAnimation("idle", false)
            if target.fallingtask ~= nil then
                target.fallingtask:Cancel()
            end
            target.fallingpos = inst._basepos
            target.fallingtask = target:DoPeriodicTask(FRAMES, OnFalling, 0, target:GetPosition(), GetTime(), 10 * FRAMES)
            OnRemoveIcon(target)
            UpdateIcon(inst)
            UpdateActions(inst)
            SetFormed(target, false)
            SetRaised(target, false)
        end
    end
end

local function GetStatus(inst)
    return inst.raised and "RAISED" or nil
end

--------------------------------------------------------------------------

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()

    inst.MiniMapEntity:SetIcon("cavein_boulder.png")
    inst.MiniMapEntity:SetEnabled(false)
	
	inst.DynamicShadow:SetSize(5, 3)

    inst.AnimState:SetBank("cavein_boulder")
    inst.AnimState:SetBuild("swap_minotaur_boulder")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("heavy")
    inst:AddTag("boulder")
    inst:AddTag("caveindebris")
    inst:AddTag("megaboulder")

    MakeHeavyObstaclePhysics(inst, PHYSICS_RADIUS )
    inst:SetPhysicsRadiusOverride(PHYSICS_RADIUS)
	
    inst.Transform:SetScale(1.8, 1.8, 1.8)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(120)
    inst.components.combat.playerdamagepercent = TUNING.DEERCLOPS_DAMAGE_PLAYER_PERCENT
    inst.components.combat:SetRange(6)
	
	inst:AddComponent("groundpounder")
    inst.components.groundpounder.destroyer = true
    inst.components.groundpounder.damageRings = 2
    inst.components.groundpounder.destructionRings = 0
    inst.components.groundpounder.numRings = 2

    inst:AddComponent("heavyobstaclephysics")
    inst.components.heavyobstaclephysics:SetRadius(PHYSICS_RADIUS)
    inst.components.heavyobstaclephysics:AddFallingStates()
    inst.components.heavyobstaclephysics:SetOnPhysicsStateChangedFn(OnPhysicsStateChanged)
    inst.components.heavyobstaclephysics:SetOnChangeToItemFn(OnChangeToItem)
    inst.components.heavyobstaclephysics:SetOnStartFallingFn(OnStartFalling)
    inst.components.heavyobstaclephysics:SetOnStopFallingFn(OnStopFalling)

    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = GetStatus

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable("cavein_boulder")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.MINE)
    inst.components.workable:SetWorkLeft(10)
    inst.components.workable:SetOnFinishCallback(OnWorked)

    inst:AddComponent("timer")
    inst:ListenForEvent("timerdone", OnTimerDone)

    MakeHauntableWork(inst)


    inst.OnSave = OnSave
    inst.OnPreLoad = OnPreLoad
    inst.OnLoadPostPass = OnLoadPostPass

    inst:ListenForEvent("onremove", OnRemoveFromScene)
    inst:ListenForEvent("enterlimbo", OnRemoveFromScene)

    --inst._iconpos = nil
    --inst._basepos = nil
    inst._onremoveraisedboulder = function(target) OnRemoveRaisedBoulder(inst, target) end

    inst._icontask = inst:DoTaskInTime(0, UpdateIcon)

    return inst
end

--------------------------------------------------------------------------

local function SkipToFull(inst)
    inst.AnimState:SetTime((5 + math.random() * 7) * FRAMES)
end

local function PlaySoundFX(inst)
    inst.SoundEmitter:PlaySoundWithParams("dontstarve/creatures/together/antlion/sfx/ground_break", { size = 1 })
end

local function MakeFX(name, anim)
    local function fn(inst)
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()

        inst.AnimState:SetBank("cavein_dust_fx")
        inst.AnimState:SetBuild("cavein_dust_fx")
        inst.AnimState:PlayAnimation(anim)

        inst:AddTag("FX")

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst.persists = false
        inst:DoTaskInTime(inst.AnimState:GetCurrentAnimationLength() + .5, inst.Remove)

        inst.SkipToFull = SkipToFull
        inst.PlaySoundFX = PlaySoundFX

        return inst
    end
    return Prefab(name, fn, dustassets)
end

return Prefab("minotaur_boulder_big", fn, assets, prefabs),
    MakeFX("cavein_dust_low", "dust_low"),
    MakeFX("cavein_dust_high", "dust_high")
