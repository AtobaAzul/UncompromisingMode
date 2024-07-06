local function OnEquip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_blowdart_pipe", "swap_blowdart_pipe")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
    if inst.components.container ~= nil then
        inst.components.container:Open(owner)
    end
end

local function OnUnequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_object")
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    if inst.components.container ~= nil then
        inst.components.container:Close()
    end
end
local function OnProjectileLaunched(inst, attacker, target)
    if inst.components.container ~= nil then
        local ammo_stack = inst.components.container:GetItemInSlot(1)
        local item = inst.components.container:RemoveItem(ammo_stack, false)
        if item ~= nil then
            if item == ammo_stack then
                item:PushEvent("ammounloaded", { slingshot = inst })
            end

            item:Remove()
        end
    end
end

local function OnAmmoLoaded(inst, data)
    if inst.components.weapon ~= nil then
        if data ~= nil and data.item ~= nil then
            inst.components.weapon:SetProjectile(data.item.prefab .. "_proj")
            data.item:PushEvent("ammoloaded", { slingshot = inst })
        end
    end
end

local function OnAmmoUnloaded(inst, data)
    if inst.components.weapon ~= nil then
        inst.components.weapon:SetProjectile(nil)
        if data ~= nil and data.prev_item ~= nil then
            data.prev_item:PushEvent("ammounloaded", { slingshot = inst })
        end
    end
end

local floater_swap_data = { sym_build = "swap_slingshot" }

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("um_blowguns")
    inst.AnimState:SetBuild("um_blowguns")
    inst.AnimState:PlayAnimation("default")

    inst:AddTag("rangedweapon")
    inst:AddTag("blowdart")
    inst:AddTag("sharp")
    --inst:AddTag("slingshot")
    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")
    inst:AddTag("donotautopick")

    --inst.projectiledelay = PROJECTILE_DELAY

    MakeInventoryFloatable(inst, "small", 0.05, { 0.75, 0.5, 0.75 })

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        inst.OnEntityReplicated = function(inst)
            inst.replica.container:WidgetSetup("um_blowgun")
        end
        return inst
    end
    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/uncompromising_blowgun.xml"
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(0)
    inst.components.weapon:SetRange(8, 10)
    inst.components.weapon:SetOnProjectileLaunched(OnProjectileLaunched)
    inst.components.weapon:SetProjectile(nil)
    inst.components.weapon:SetProjectileOffset(1)

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("um_blowgun")
    inst.components.container.canbeopened = false
    inst:ListenForEvent("itemget", OnAmmoLoaded)
    inst:ListenForEvent("itemlose", OnAmmoUnloaded)

    MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
    MakeSmallPropagator(inst)
    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("uncompromising_blowgun", fn)
