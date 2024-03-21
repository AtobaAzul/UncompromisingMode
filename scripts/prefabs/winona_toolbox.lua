require "prefabutil"

local function onopen(inst)
	if not inst:HasTag("burnt") then
		inst.AnimState:PlayAnimation("open", false)
		inst.SoundEmitter:PlaySound("hookline/common/fishbox/open")
	end
end

local function onclose(inst)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("close", false)
    inst.SoundEmitter:PlaySound("saltydog/common/saltbox/close")
    end
end

local function OnPutInInventory(inst)
	inst.components.container:Close()
	inst.AnimState:PlayAnimation("idle", false)
end

local function onsave(inst, data)
    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() or inst:HasTag("burnt") then
        data.burnt = true
    end
end

local function onload(inst, data)
    if data ~= nil and data.burnt and inst.components.burnable ~= nil then
        inst.components.burnable.onburnt(inst)
    end
end

local function MakeTackleContainer(name, bank, build, assets)
    assets = assets or {}
    table.insert(assets, Asset("ANIM", "anim/"..build..".zip"))

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddMiniMapEntity()
        inst.entity:AddNetwork()

		inst.MiniMapEntity:SetIcon(name..".png")
		
		inst:AddTag("waterproofer")

        inst.AnimState:SetBank(bank)
        inst.AnimState:SetBuild(build)
        inst.AnimState:PlayAnimation("idle")
		inst.Transform:SetScale(2, 2, 2)

		MakeInventoryPhysics(inst)

        local swap_data = {bank = bank, anim = "idle"}
        MakeInventoryFloatable(inst, "small", nil, nil, nil, nil, swap_data)

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

		inst:AddComponent("inspectable")

		inst:AddComponent("waterproofer")
		inst.components.waterproofer:SetEffectiveness(0)

        inst:AddComponent("container")
        inst.components.container:WidgetSetup("winona_toolbox")
        inst.components.container.onopenfn = onopen
		inst.components.container.onclosefn = onclose
        inst.components.container.skipclosesnd = true
        inst.components.container.skipopensnd = true
		inst.components.container.droponopen = true

		inst:AddComponent("inventoryitem")
		inst.components.inventoryitem:SetOnPutInInventoryFn(OnPutInInventory)
		inst.components.inventoryitem.atlasname = "images/inventoryimages/winona_toolbox.xml"

		inst:AddComponent("lootdropper")

        inst:AddComponent("hauntable")
        inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)


        inst.OnSave = onsave
        inst.OnLoad = onload

        return inst
    end

    return Prefab(name, fn, assets, prefabs)
end

return MakeTackleContainer("winona_toolbox", "winona_toolbox", "winona_toolbox", { Asset("ANIM", "anim/ui_tacklecontainer_3x5.zip") })