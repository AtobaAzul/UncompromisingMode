local assets =
{
    Asset("ANIM", "anim/backpack.zip"),
    Asset("ANIM", "anim/swap_krampus_sack.zip"),
    Asset("ANIM", "anim/ui_krampusbag_2x5.zip"),
}

local function TryPerish(item)
    if item:IsInLimbo() then
        local owner = item.components.inventoryitem ~= nil and item.components.inventoryitem.owner or nil
        if owner == nil or
            (   owner.components.container ~= nil and
                (owner:HasTag("chest") or owner:HasTag("structure")) ) then
            --in limbo but not inventory or container?
            --or in a closed chest
            return
        end
    end
    item.components.perishable:ReducePercent(0.005)
end

local function DoAreaSpoil(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
	
    local ents = TheSim:FindEntities(x, y, z, 3, nil, { "small_livestock" }, { "fresh", "stale", "spoiled" })
	for i, v in ipairs(ents) do
        TryPerish(v)
    end
end

local function CreateBase()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")
    inst.persists = false

    inst.AnimState:SetBank("sporecloud_base")
    inst.AnimState:SetBuild("sporecloud_base")
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(3)
    inst.AnimState:SetFinalOffset(-1)

	inst.AnimState:PlayAnimation("sporecloud_base_pst")
	--inst.AnimState:PlayAnimation("sporecloud_base_pre")
	--inst.AnimState:PushAnimation("sporecloud_base_pst", false)
	
	inst.Transform:SetScale(0.6, 0.6, 0.6)
	inst.AnimState:SetMultColour(1, 1, 1, 0.7)
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.SoundEmitter:PlaySound("dontstarve/creatures/together/toad_stool/infection_post", nil, 0.5)
	--inst:ListenForEvent("animqueueover", function(inst) inst:Remove() end)
	inst:ListenForEvent("animover", function(inst) inst:Remove() end)

    return inst
end

local function InitFX(inst)
	local cloud = SpawnPrefab("sporepack_circle")
	--cloud.Transform:SetPosition(inst.Transform:GetWorldPosition())
	cloud.entity:SetParent(inst.entity)
end

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_body", "swap_sporepack", "backpack")
    owner.AnimState:OverrideSymbol("swap_body", "swap_sporepack", "swap_body")
    inst.components.container:Open(owner)
	
	if owner.sporepack_task ~= nil then
		owner.sporepack_task:Cancel()
		owner.sporepack_task = nil
	end
	
	if owner.sporespoil_task ~= nil then
		owner.sporespoil_task:Cancel()
		owner.sporespoil_task = nil
	end
	
	owner.sporepack_task = owner:DoPeriodicTask(3, InitFX)
	owner.sporespoil_task = owner:DoPeriodicTask(3, DoAreaSpoil)
end

local function onunequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")
    owner.AnimState:ClearOverrideSymbol("backpack")
    inst.components.container:Close(owner)
	
	if owner.sporepack_task ~= nil then
		owner.sporepack_task:Cancel()
		owner.sporepack_task = nil
	end
	
	if owner.sporespoil_task ~= nil then
		owner.sporespoil_task:Cancel()
		owner.sporespoil_task = nil
	end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.MiniMapEntity:SetIcon("sporepack_map.tex")

    inst.AnimState:SetBank("sporepack")
    inst.AnimState:SetBuild("sporepack")
    inst.AnimState:PlayAnimation("idle")
	
	inst.rottask = nil

    inst.foleysound = "dontstarve/movement/foley/backpack"

    inst:AddTag("backpack")
    inst:AddTag("sporepack")

    MakeInventoryFloatable(inst, "med", 0.1, 0.65)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
		inst.OnEntityReplicated = function(inst) 
			inst.replica.container:WidgetSetup("krampus_sack") 
		end
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.cangoincontainer = false
	inst.components.inventoryitem.atlasname = "images/inventoryimages/sporepack.xml"

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(0)

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("krampus_sack")
	
	inst:AddComponent("preserver")
	inst.components.preserver:SetPerishRateMultiplier(2)

    MakeHauntableLaunchAndDropFirstItem(inst)

    return inst
end

return Prefab("sporepack", fn, assets),
		Prefab("sporepack_circle", CreateBase, assets)
