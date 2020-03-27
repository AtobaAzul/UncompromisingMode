local assets =
{
    Asset("ANIM", "anim/sporecloud.zip"),
    Asset("ANIM", "anim/sporecloud_base.zip"),
    Asset("ANIM", "anim/sleepcloud.zip"),
    Asset("ANIM", "anim/sporecloud_base.zip"),
    Asset("ANIM", "anim/swap_diseasecurebomb.zip"),
}

local prefabs =
{
    "sporecloud_overlay",
    "sleepcloud_overlay",
}

local bombassets =
{
    Asset("ANIM", "anim/diseasecurebomb.zip"),
    Asset("ANIM", "anim/swap_diseasecurebomb.zip"),
}

local bombprefabs =
{
    "sleepbomb_burst",
    "sleepcloud",
    "reticule",
    "reticuleaoe",
    "reticuleaoeping",
}


local TICK_PERIOD = 3

local OVERLAY_COORDS =
{
    { 0,0,0,               1 },
    { 5/2,0,0,             0.8, 0 },
    { 2.5/2,0,-4.330/2,    0.8 , 5/3*180 },
    { -2.5/2,0,-4.330/2,   0.8, 4/3*180 },
    { -5/2,0,0,            0.8, 3/3*180 },
    { 2.5/2,0,4.330/2,     0.8, 1/3*180 },
    { -2.5/2,0,4.330/2,    0.8, 2/3*180 },
}
--[[
local function SpawnOverlayFX(inst, i, set, isnew)
    if i ~= nil then
        inst._overlaytasks[i] = nil
        if next(inst._overlaytasks) == nil then
            inst._overlaytasks = nil
        end
    end

    local fx = SpawnPrefab("sleepcloud_overlay")
    fx.entity:SetParent(inst.entity)
    fx.Transform:SetPosition(set[1] * .85, 0, set[3] * .85)
    fx.Transform:SetScale(set[4], set[4], set[4])
    if set[5] ~= nil then
        fx.Transform:SetRotation(set[4])
    end

    if not isnew then
        fx.AnimState:PlayAnimation("sleepcloud_overlay_loop")
        fx.AnimState:SetTime(math.random() * .7)
    end

    if inst._overlayfx == nil then
        inst._overlayfx = { fx }
    else
        table.insert(inst._overlayfx, fx)
    end
end
--]]

local function CreateBase(isnew)
    local inst = CreateEntity()

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")
    --[[Non-networked entity]]
    inst.entity:SetCanSleep(false)
    inst.persists = false

    inst.entity:AddTransform()
    inst.entity:AddAnimState()

    inst.AnimState:SetBank("sporecloud_base")
    inst.AnimState:SetBuild("sporecloud_base")
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(3)
    inst.AnimState:SetFinalOffset(-1)
	inst.AnimState:SetMultColour(1, 0.3, 0.9, 1)

    if isnew then
        inst.AnimState:PlayAnimation("sporecloud_base_pre")
        inst.AnimState:SetTime(12 * FRAMES)
        inst.AnimState:PushAnimation("sporecloud_base_idle", false)
    else
        inst.AnimState:PlayAnimation("sporecloud_base_idle")
    end

    return inst
end

local function OnStateDirty(inst)
    if inst._state:value() > 0 then
        if inst._inittask ~= nil then
            inst._inittask:Cancel()
            inst._inittask = nil
        end
        if inst._state:value() == 1 then
            if inst._basefx == nil then
                inst._basefx = CreateBase(false)
                inst._basefx.entity:SetParent(inst.entity)
            end
        elseif inst._basefx ~= nil then
            inst._basefx.AnimState:PlayAnimation("sporecloud_base_pst")
        end
    end
end

local function OnAnimOver(inst)
    inst:RemoveEventCallback("animover", OnAnimOver)
    inst._state:set(1)
end

local function OnOverlayAnimOver(fx)
    fx.AnimState:PlayAnimation("sleepcloud_overlay_loop")
end

local function KillOverlayFX(fx)
    fx:RemoveEventCallback("animover", OnOverlayAnimOver)
    fx.AnimState:PlayAnimation("sleepcloud_overlay_pst")
end

local function DoDisperse(inst)
    if inst._inittask ~= nil then
        inst._inittask:Cancel()
        inst._inittask = nil
    end

    if inst._drowsytask ~= nil then
        inst._drowsytask:Cancel()
        inst._drowsytask = nil
    end

    inst:RemoveEventCallback("animover", OnAnimOver)
    inst._state:set(2)

    inst.AnimState:PlayAnimation("sleepcloud_pst")
    inst.SoundEmitter:KillSound("spore_loop")
    inst.persists = false
    inst:DoTaskInTime(3, inst.Remove) --anim len + 1.5 sec

    if inst._basefx ~= nil then
        inst._basefx.AnimState:PlayAnimation("sporecloud_base_pst")
    end

    if inst._overlaytasks ~= nil then
        for k, v in pairs(inst._overlaytasks) do
            v:Cancel()
        end
        inst._overlaytasks = nil
    end
    if inst._overlayfx ~= nil then
        for i, v in ipairs(inst._overlayfx) do
            v:DoTaskInTime(i == 1 and 0 or math.random() * .5, KillOverlayFX)
        end
    end
end

local function OnTimerDone(inst, data)
    if data.name == "disperse" then
        DoDisperse(inst)
    end
end

local function OnLoad(inst, data)
    --Not a brand new cloud, cancel initial sound and pre-anims
    if inst._inittask ~= nil then
        inst._inittask:Cancel()
        inst._inittask = nil
    end

    inst:RemoveEventCallback("animover", OnAnimOver)

    if inst._overlaytasks ~= nil then
        for k, v in pairs(inst._overlaytasks) do
            v:Cancel()
        end
        inst._overlaytasks = nil
    end
    if inst._overlayfx ~= nil then
        for i, v in ipairs(inst._overlayfx) do
            v:Remove()
        end
        inst._overlayfx = nil
    end

    local t = inst.components.timer:GetTimeLeft("disperse")
    if t == nil or t <= 0 then
        if inst._drowsytask ~= nil then
            inst._drowsytask:Cancel()
            inst._drowsytask = nil
        end
        inst._state:set(2)
        inst.SoundEmitter:KillSound("spore_loop")
        inst:Hide()
        inst.persists = false
        inst:DoTaskInTime(0, inst.Remove)
    else
        inst._state:set(1)
        inst.AnimState:PlayAnimation("sleepcloud_loop", true)

        --Dedicated server does not need to spawn the local fx
        if not TheNet:IsDedicated() then
            inst._basefx = CreateBase(false)
            inst._basefx.entity:SetParent(inst.entity)
        end

       --[[ for i, v in ipairs(OVERLAY_COORDS) do
            SpawnOverlayFX(inst, nil, v, false)
        end--]]
    end
end

local function InitFX(inst)
    inst._inittask = nil

    --Dedicated server does not need to spawn the local fx
    if not TheNet:IsDedicated() then
        inst._basefx = CreateBase(true)
        inst._basefx.entity:SetParent(inst.entity)
    end
end

local function TryPerish(item)
	if item:HasTag("diseased") and item.components.pickable then
		local x, y, z = item.Transform:GetWorldPosition()
		item:Remove()
		local cured = SpawnPrefab(item.prefab)
		cured.Transform:SetPosition(x, y, z)
		cured.components.pickable:OnTransplant()
		SpawnPrefab("halloween_moonpuff").Transform:SetPosition(x, y, z)
	end
	
	if item.components.health ~= nil then
		if not item.components.health:IsDead() then
			item.components.health:DoDelta(0.5)
		end
	end
end

local function DoAreaDrowsy(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, 9)
    for i, v in ipairs(ents) do
        TryPerish(v)
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()

    inst.AnimState:SetBank("sleepcloud")
    inst.AnimState:SetBuild("sleepcloud")
    inst.AnimState:PlayAnimation("sleepcloud_pre")

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")
    inst:AddTag("notarget")
	
	inst.AnimState:SetMultColour(1, 0.3, 0.9, 1)
	inst.Transform:SetScale(1.3,1.3,1.3)

    inst.SoundEmitter:PlaySound("dontstarve/creatures/together/toad_stool/spore_cloud_LP", "spore_loop")

    inst._state = net_tinybyte(inst.GUID, "sleepcloud._state", "statedirty")

    inst._inittask = inst:DoTaskInTime(0, InitFX)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        inst:ListenForEvent("statedirty", OnStateDirty)

        return inst
    end

    inst._drowsytask = inst:DoPeriodicTask(TICK_PERIOD, DoAreaDrowsy, nil, {}, {})

    inst.AnimState:PushAnimation("sleepcloud_loop", true)
    inst:ListenForEvent("animover", OnAnimOver)

    inst:AddComponent("timer")
    inst.components.timer:StartTimer("disperse", TUNING.SLEEPBOMB_DURATION * 4)

    inst:ListenForEvent("timerdone", OnTimerDone)

    inst.OnLoad = OnLoad

    inst._overlaytasks = {}
   --[[ for i, v in ipairs(OVERLAY_COORDS) do
        inst._overlaytasks[i] = inst:DoTaskInTime(i == 1 and 0 or math.random() * .7, SpawnOverlayFX, i, v, true)
    end--]]

    return inst
end

local function overlayfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")

    inst.Transform:SetTwoFaced()

    inst.AnimState:SetBank("sleepcloud")
    inst.AnimState:SetBuild("sleepcloud")
    inst.AnimState:PlayAnimation("sleepcloud_overlay_pre")
	
	inst.AnimState:SetMultColour(1, 0.3, 0.9, 1)
	inst.Transform:SetScale(1.3,1.3,1.3)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:ListenForEvent("animover", OnOverlayAnimOver)

    inst.persists = false

    return inst
end


local function OnHit(inst, attacker, target)
    local x, y, z = inst.Transform:GetWorldPosition()
    --inst:Remove()
	
    inst.AnimState:PlayAnimation("used")
	inst.SoundEmitter:PlaySound("dontstarve/common/together/infection_burst")
	inst:DoTaskInTime(FRAMES*10, function(inst)
		inst:Remove()
	end)
    SpawnPrefab("diseasecure").Transform:SetPosition(x, y, z)
end

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_diseasecurebomb", "swap_waterballoon")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

local function onthrown(inst)
    inst:AddTag("NOCLICK")
    inst.persists = false

    inst.AnimState:PlayAnimation("spin_loop")

    inst.Physics:SetMass(1)
    inst.Physics:SetFriction(0)
    inst.Physics:SetDamping(0)
    inst.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.WORLD)
    inst.Physics:CollidesWith(COLLISION.OBSTACLES)
    inst.Physics:CollidesWith(COLLISION.ITEMS)
    inst.Physics:SetCapsule(.2, .2)
end

local function ReticuleTargetFn()
    local player = ThePlayer
    local ground = TheWorld.Map
    local pos = Vector3()
    --Attack range is 8, leave room for error
    --Min range was chosen to not hit yourself (2 is the hit range)
    for r = 6.5, 3.5, -.25 do
        pos.x, pos.y, pos.z = player.entity:LocalToWorldSpace(r, 0, 0)
        if ground:IsPassableAtPoint(pos:Get()) and not ground:IsGroundTargetBlocked(pos) then
            return pos
        end
    end
    return pos
end

local function bombfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	inst.Transform:SetTwoFaced()

    MakeInventoryPhysics(inst)

    --projectile (from complexprojectile component) added to pristine state for optimization
    inst:AddTag("projectile")

    inst.AnimState:SetBank("sleepbomb")
    inst.AnimState:SetBuild("diseasecurebomb")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetDeltaTimeMultiplier(.75)

    inst:AddComponent("reticule")
    inst.components.reticule.targetfn = ReticuleTargetFn
    inst.components.reticule.ease = true

    local advancedtargeting = TheNet:GetServerGameMode() == "lavaarena"
    if advancedtargeting then
        inst.components.reticule.reticuleprefab = "reticuleaoe"
        inst.components.reticule.pingprefab = "reticuleaoeping"
        inst.components.reticule.mouseenabled = true

        inst:AddTag("nopunch")
    else
        --weapon (from weapon component) added to pristine state for optimization
        inst:AddTag("weapon")
    end

    MakeInventoryFloatable(inst, "small", 0.1, 0.8)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("locomotor")

    inst:AddComponent("complexprojectile")
    inst.components.complexprojectile:SetHorizontalSpeed(15)
    inst.components.complexprojectile:SetGravity(-35)
    inst.components.complexprojectile:SetLaunchOffset(Vector3(.25, 1, 0))
    inst.components.complexprojectile:SetOnLaunch(onthrown)
    inst.components.complexprojectile:SetOnHit(OnHit)

    if not advancedtargeting then
        inst:AddComponent("weapon")
        inst.components.weapon:SetDamage(0)
        inst.components.weapon:SetRange(8, 10)
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/diseasecurebomb.xml"

    inst:AddComponent("stackable")

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable.equipstack = true

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("diseasecure", fn, assets, prefabs),
		Prefab("diseasecurebomb", bombfn, bombassets, bombprefabs),
		Prefab("diseasecure_overlay", overlayfn, assets)