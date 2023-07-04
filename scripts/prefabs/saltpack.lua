local assets = {
    Asset("ANIM", "anim/saltpack.zip"), Asset("ANIM", "anim/swap_saltpack.zip"),
    Asset("SOUND", "sound/wilson.fsb"), Asset("INV_IMAGE", "saltpack")
}

local prefabs = { "saltpack" }

local function DoTurnOffSound(inst, owner)
    inst._soundtask = nil
    inst.SoundEmitter:PlaySound("dontstarve/wilson/lantern_off")
end

local function PlayTurnOnSound(inst)
    if not inst.components.fueled:IsEmpty() then
        inst._soundtask = nil
        inst.SoundEmitter:PlaySound("dontstarve/wilson/lantern_on")
    end
end

local TALLER_FROSTYBREATHER_OFFSET = Vector3(.3, 3.75, 0)
local DEFAULT_FROSTYBREATHER_OFFSET = Vector3(.3, 1.15, 0)

local function GetOffset()
    local offset = Vector3(.3, 1.15, 0)
    return offset:Get()
end

local function Salted(inst)
    local offset = Vector3(.3, 1.15, 0)
    local owner = inst.components.inventoryitem.owner
    local x, y, z = inst.Transform:GetWorldPosition()
    local saltedfx = SpawnPrefab("mining_fx")

    if owner ~= nil then
        if owner.components.rider ~= nil and owner.components.rider:IsRiding() then
            saltedfx.Transform:SetPosition(x, 4, z)
        else
            saltedfx.Transform:SetPosition(x, 2, z)
        end
    else
        saltedfx.Transform:SetPosition(x, 1.6, z)
    end

    local salted = SpawnPrefab("saltpile")
    salted.Transform:SetPosition(x + math.random(-1, 1), y, z + math.random(-1, 1))

    inst.SoundEmitter:PlaySound("dontstarve/creatures/together/antlion/sfx/ground_break")

    local ents = TheSim:FindEntities(x, y, z, 6, { "salt_workable" })
    if #ents > 0 then
        for i, v in ipairs(ents) do
            if v:IsValid() then
                -- Don't net any insects when we do work
                -- if self.destroyer and

                if v.components.workable ~= nil and v.components.workable:CanBeWorked() then
                    SpawnPrefab("splash_snow_fx").Transform:SetPosition(v.Transform:GetWorldPosition())
                end
                v:Remove()
            end
        end
    end

    local ents2 = TheSim:FindEntities(x, y, z, 6, { "snowish" })
    if #ents2 > 0 then
        for i, v2 in ipairs(ents2) do
            if v2:IsValid() and v2.components.health ~= nil and not v2.components.health:IsDead() and inst.components.combat:CanTarget(v2) then
                inst.components.combat:DoAttack(v2, nil, nil, nil, 1)
            end
        end
    end

    --[[if not TheWorld.state.iswinter and TheWorld:HasTag("forest") then
			inst.components.equippable.walkspeedmult = 1
		end]]
end

local function Depleted(inst)

end

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("backpack", "swap_saltpack", "backpack")
    owner.AnimState:OverrideSymbol("swap_body", "swap_saltpack", "swap_body")
end

local function onunequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")
    owner.AnimState:ClearOverrideSymbol("backpack")
end

local function ontakefuel(inst)
    inst.SoundEmitter:PlaySound("dontstarve/common/fireAddFuel")
    inst.components.useableitem.inuse = false
end

local function OnUse(inst)
    if inst.components.rechargeable:IsCharged() and not inst.components.fueled:IsEmpty() then
        inst.components.fueled:SetPercent(inst.components.fueled:GetPercent() - 0.025) -- test num, feel free to tune
        Salted(inst)
        inst.components.rechargeable:Discharge(1)
    else
        inst.SoundEmitter:PlaySound("dangerous_sea/common/water_pump/LP", "pump")
        inst:DoTaskInTime(0.5, function(inst) inst.SoundEmitter:KillSound("pump") end)
    end
end

local function OnCharged(inst)
    inst.components.useableitem.inuse = false
end

--------------------------------------------------------------------------

--------------------------------------------------------------------------

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.Transform:SetScale(1.6, 1.6, 1.6)
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("umbrella")
    inst.AnimState:SetBuild("saltpack")
    inst.AnimState:PlayAnimation("idle")

    inst.foleysound = "dontstarve/movement/foley/backpack"

    inst.salttask = nil

    MakeInventoryFloatable(inst, "med", 0.2, 0.65)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/saltpack.xml"


    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY

    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(TUNING.BEEGUARD_DAMAGE)

    inst:AddComponent("insulator")

    --[[inst:AddComponent("machine")
    inst.components.machine.turnonfn = turnon
    inst.components.machine.turnofffn = turnoff
    inst.components.machine.cooldowntime = 0]]

    inst:AddComponent("rechargeable")
    inst.components.rechargeable:SetOnChargedFn(OnCharged)

    inst:AddComponent("useableitem")
    inst.components.useableitem:SetOnUseFn(OnUse)

    inst:AddComponent("fueled")
    inst.components.fueled.fueltype = FUELTYPE.SALT
    inst.components.fueled:InitializeFuelLevel(TUNING.TORCH_FUEL * 4)
    inst.components.fueled:SetTakeFuelFn(ontakefuel)
    inst.components.fueled:SetDepletedFn(Depleted)
    inst.components.fueled:SetFirstPeriod(TUNING.TURNON_FUELED_CONSUMPTION * 2, TUNING.TURNON_FULL_FUELED_CONSUMPTION * 2)
    inst.components.fueled.accepting = true
    inst.components.fueled:StopConsuming()

    MakeHauntableLaunch(inst)

    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    return inst
end

return Prefab("saltpack", fn, assets, prefabs)
