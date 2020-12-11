local function OnBlocked(owner) 
    --owner.SoundEmitter:PlaySound("dontstarve/wilson/hit_nightarmour") 
end

local function OnTakeDamage(inst, damage_amount) --Simple Function that factors the durability of clothing into the durability of Armor
if inst.components.armor ~= nil and inst.components.fueled ~= nil then
inst.components.fueled:DoDelta(-15*damage_amount)
local percent = inst.components.fueled:GetPercent()
inst.components.armor:SetPercent(percent)	
end
end

local function onequip_steel(inst, owner)
    owner.AnimState:OverrideSymbol("swap_body", "armor_steelsweater", "swap_body")
    inst.components.fueled:StartConsuming()
	inst:ListenForEvent("blocked", OnBlocked, owner)
	if inst.components.armor ~= nil and inst.components.fueled ~= nil then
	local percent = inst.components.fueled:GetPercent()
	inst.components.armor:SetPercent(percent)	
	end
end

local function onunequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")
    inst.components.fueled:StopConsuming()
	if inst.components.armor ~= nil and inst.components.fueled ~= nil then
	local percent = inst.components.fueled:GetPercent()
	inst.components.armor:SetPercent(percent)	
	end
end
local function onactive(inst)
	if inst.components.armor ~= nil and inst.components.fueled ~= nil then
	local percent = inst.components.fueled:GetPercent()
	inst.components.armor:SetPercent(percent)	
	end
end
local function create_common(bankandbuild, iswaterproofer)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank(bankandbuild)
    inst.AnimState:SetBuild(bankandbuild)
    inst.AnimState:PlayAnimation("anim")

    inst.foleysound = "dontstarve/movement/foley/trunksuit"

    if iswaterproofer then
        --waterproofer (from waterproofer component) added to pristine state for optimization
        inst:AddTag("waterproofer")
    end

    MakeInventoryFloatable(inst, "small", 0.1, 0.8)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("tradable")

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem:SetOnActiveItemFn(onactive)
    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
    inst.components.equippable.dapperness = -TUNING.DAPPERNESS_SMALL
	
	inst:AddComponent("armor")
	inst.components.armor:InitCondition(500, 0.7)
	inst.components.armor.ontakedamage = OnTakeDamage
	--inst.components.armor.absorb_percent = .7	
    inst.components.equippable:SetOnUnequip(onunequip)

    inst:AddComponent("insulator")

    inst:AddComponent("fueled")
    inst.components.fueled.fueltype = FUELTYPE.SWEATERPOWER
    inst.components.fueled:InitializeFuelLevel(TUNING.TRUNKVEST_PERISHTIME)
    inst.components.fueled:SetDepletedFn(inst.Remove)
	inst.components.fueled.no_sewing = true
	inst.components.fueled.accepting = true
    MakeHauntableLaunch(inst)

    return inst
end

local function create_steel()
    local inst = create_common("steelsweater", true)

    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.equippable:SetOnEquip(onequip_steel)

    inst.components.insulator:SetInsulation(TUNING.INSULATION_SMALL)

    inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(.30)

    return inst
end



return Prefab("steel_sweater", create_steel)
