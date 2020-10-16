local easing = require("easing")

local assets =
{
    Asset("ANIM", "anim/moonrock_seed.zip"),
}

local function updatelight(inst)
    inst._light = inst._light < inst._targetlight and math.min(inst._targetlight, inst._light + .04) or math.max(inst._targetlight, inst._light - .02)
    inst.AnimState:SetLightOverride(inst._light)
    if inst._light == inst._targetlight then
        inst._task:Cancel()
        inst._task = nil
    end
end

local function fadelight(inst, target, instant)
    inst._targetlight = target
    if inst._light ~= target then
        if instant then
            if inst._task ~= nil then
                inst._task:Cancel()
                inst._task = nil
            end
            inst._light = target
            inst.AnimState:SetLightOverride(target)
        elseif inst._task == nil then
            inst._task = inst:DoPeriodicTask(FRAMES, updatelight)
        end
    elseif inst._task ~= nil then
        inst._task:Cancel()
        inst._task = nil
    end
end

local function cancelblink(inst)
    if inst._blinktask ~= nil then
        inst._blinktask:Cancel()
        inst._blinktask = nil
    end
end

local function updateblink(inst, data)
    local c = easing.outQuad(data.blink, 0, 1, 1)
    inst.AnimState:SetAddColour(c, c, c, 0)
    if data.blink > 0 then
        data.blink = math.max(0, data.blink - .05)
    else
        inst._blinktask:Cancel()
        inst._blinktask = nil
    end
end

local function blink(inst)
    if inst._blinktask ~= nil then
        inst._blinktask:Cancel()
    end
    local data = { blink = 1 }
    inst._blinktask = inst:DoPeriodicTask(FRAMES, updateblink, nil, data)
    updateblink(inst, data)
end

local function dodropsound(inst, taskid, volume)
    inst.SoundEmitter:PlaySound("dontstarve/movement/bodyfall_dirt", nil, volume)
    inst._tasks[taskid] = nil
end

local function canceldropsounds(inst)
    local k, v = next(inst._tasks)
    while k ~= nil do
        v:Cancel()
        inst._tasks[k] = nil
        k, v = next(inst._tasks)
    end
end

local function scheduledropsounds(inst)
    inst._tasks[1] = inst:DoTaskInTime(6.5 * FRAMES, dodropsound, 1)
    inst._tasks[2] = inst:DoTaskInTime(13.5 * FRAMES, dodropsound, 2, .5)
    inst._tasks[3] = inst:DoTaskInTime(18.5 * FRAMES, dodropsound, 2, .15)
end

local function onturnon(inst)
    canceldropsounds(inst)
    inst.AnimState:PlayAnimation("proximity_pre")
    inst.AnimState:PushAnimation("proximity_loop", true)
    fadelight(inst, .15, false)
    if not inst.SoundEmitter:PlayingSound("idlesound") then
        inst.SoundEmitter:PlaySound("dontstarve/common/together/celestial_orb/idle_LP", "idlesound")
    end
end

local function onturnoff(inst)
    canceldropsounds(inst)
    inst.SoundEmitter:KillSound("idlesound")
    if not inst.components.inventoryitem:IsHeld() then
        inst.AnimState:PlayAnimation("proximity_pst")
        inst.AnimState:PushAnimation("idle", false)
        fadelight(inst, 0, false)
        scheduledropsounds(inst)
    else
        inst.AnimState:PlayAnimation("idle")
        fadelight(inst, 0, true)
    end
end

local function onactivate(inst)
    blink(inst)
    inst.SoundEmitter:PlaySound("dontstarve/common/together/celestial_orb/active")
    inst._fx:push()
end

local function storeincontainer(inst, container)
    if container ~= nil and container.components.container ~= nil then
        inst:ListenForEvent("onputininventory", inst._oncontainerownerchanged, container)
        inst:ListenForEvent("ondropped", inst._oncontainerownerchanged, container)
        inst:ListenForEvent("onremove", inst._oncontainerremoved, container)
        inst._container = container
    end
end

local function unstore(inst)
    if inst._container ~= nil then
        inst:RemoveEventCallback("onputininventory", inst._oncontainerownerchanged, inst._container)
        inst:RemoveEventCallback("ondropped", inst._oncontainerownerchanged, inst._container)
        inst:RemoveEventCallback("onremove", inst._oncontainerremoved, inst._container)
        inst._container = nil
    end
end

local function tostore(inst, owner)
    if inst._container ~= owner then
        unstore(inst)
        storeincontainer(inst, owner)
    end
    owner = owner.components.inventoryitem ~= nil and owner.components.inventoryitem:GetGrandOwner() or owner
    if inst._owner ~= owner then
        inst._owner = owner
    end
end

local function topocket(inst, owner)
    cancelblink(inst)
    onturnoff(inst)
    tostore(inst, owner)
end

local function startcrying(inst)
    local owner = inst.components.inventoryitem.owner
	
    if owner ~= nil then
		if owner.components.moisture ~= nil and owner.components.moisture:GetMoisture() < 48 then
			owner.components.moisture:DoDelta(3)
		end
	else
		inst.task:Cancel()
		inst.task = nil
	end
end

local function topockettear(inst, owner)
    --cancelblink(inst)
	if inst.task == nil then
		inst.task = inst:DoPeriodicTask(1, startcrying)
	end
    --tostore(inst, owner)
end

local function togroundtear(inst)
	if inst.task ~= nil then
		inst.task:Cancel()
		inst.task = nil
	end
end

local function toground(inst)
    if inst.components.prototyper.on then
        onturnon(inst)
    end
    unstore(inst)
    inst._owner = nil
end

local function OnFX(inst)
    if not inst:HasTag("INLIMBO") then
        local fx = CreateEntity()

        fx:AddTag("FX")
        --[[Non-networked entity]]
        fx.entity:SetCanSleep(false)
        fx.persists = false

        fx.entity:AddTransform()
        fx.entity:AddAnimState()

        fx.Transform:SetFromProxy(inst.GUID)

        fx.AnimState:SetBank("moonrock_seed")
        fx.AnimState:SetBuild("moonrock_seed")
        fx.AnimState:PlayAnimation("use")
        fx.AnimState:SetFinalOffset(-1)

        fx:ListenForEvent("animover", fx.Remove)
    end
end

local function OnSpawned(inst)
    if not (inst.components.prototyper.on or inst.components.inventoryitem:IsHeld()) then
        canceldropsounds(inst)
        scheduledropsounds(inst)
        inst.AnimState:PlayAnimation("proximity_pst")
        inst.AnimState:PushAnimation("idle", false)
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("moonrock_seed")
    inst.AnimState:SetBuild("moontear")
    inst.AnimState:PlayAnimation("idle")
--[[
    inst:AddTag("irreplaceable")
    inst:AddTag("nonpotatable")

    inst._fx = net_event(inst.GUID, "moonrockseed._fx")

    if not TheNet:IsDedicated() then
        inst:ListenForEvent("moonrockseed._fx", OnFX)
    end
]]
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
--[[
    inst._tasks = {}
    inst._light = 0
    inst._targetlight = 0
    inst._owner = nil
    inst._container = nil

    inst._oncontainerownerchanged = function(container)
        tostore(inst, container)
    end

    inst._oncontainerremoved = function()
        unstore(inst)
    end
]]
    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/moon_tear.xml"
    inst.components.inventoryitem.nobounce = true
    inst.components.inventoryitem:SetSinks(true)

    --[[inst:AddComponent("prototyper")
    inst.components.prototyper.onturnon = onturnon
    inst.components.prototyper.onturnoff = onturnoff
    inst.components.prototyper.onactivate = onactivate
    inst.components.prototyper.trees = TUNING.PROTOTYPER_TREES.MOONORB_LOW]]

    MakeHauntableLaunch(inst)

    inst:ListenForEvent("onputininventory", topockettear)
    --inst:ListenForEvent("onputininventory", topocket)
    inst:ListenForEvent("ondropped", togroundtear)
    --inst:ListenForEvent("ondropped", toground)

    --inst.OnSpawned = OnSpawned

    return inst
end

return Prefab("moon_tear", fn, assets, prefabs)
