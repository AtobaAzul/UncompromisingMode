local assets = 
{
	Asset("ANIM", "anim/um_books.zip"),
	Asset("ATLAS", "images/inventoryimages/book_rain.xml"),
	Asset("IMAGE", "images/inventoryimages/book_rain.tex"),
}

local book_defs =
{
    {
        name = "book_rain",
        uses = 5,
        fn = function(inst, reader)
            reader.components.sanity:DoDelta(-125) --Eat Half Her Sanity
			TheWorld:PushEvent("ms_forceprecipitation", true)
			return true
        end,
        perusefn = function(inst,reader)
            if reader.peruse_silviculture then
                reader.peruse_silviculture(reader)
            end
            reader.components.talker:Say(GetString(reader, "ANNOUNCE_READ_BOOK","BOOK_SILVICULTURE"))
            return true
        end,
    },
}

local function MakeBook(def)
    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank("um_books") --temp
        inst.AnimState:SetBuild("um_books")
        inst.AnimState:PlayAnimation(def.name)

        MakeInventoryFloatable(inst, "med", nil, 0.75)

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        -----------------------------------

        inst:AddComponent("inspectable")
        inst:AddComponent("book")
        inst.components.book.onread = def.fn
        inst.components.book.onperuse = def.perusefn

		inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.atlasname = "images/inventoryimages/"..def.name..".xml"

        inst:AddComponent("finiteuses")
        inst.components.finiteuses:SetMaxUses(def.uses)
        inst.components.finiteuses:SetUses(def.uses)
        inst.components.finiteuses:SetOnFinished(inst.Remove)

        inst:AddComponent("fuel")
        inst.components.fuel.fuelvalue = TUNING.MED_FUEL

        MakeSmallBurnable(inst, TUNING.MED_BURNTIME)
        MakeSmallPropagator(inst)

        --MakeHauntableLaunchOrChangePrefab(inst, TUNING.HAUNT_CHANCE_OFTEN, TUNING.HAUNT_CHANCE_OCCASIONAL, nil, nil, morphlist)
        MakeHauntableLaunch(inst)

        return inst
    end

    return Prefab(def.name, fn, assets)
end

local function book_placeholder_spell_fn()
	local inst = CreateEntity()

    if not TheWorld.ismastersim then
        --Not meant for client!
        inst:DoTaskInTime(0, inst.Remove)

        return inst
    end

    inst.entity:AddTransform()

    --[[Non-networked entity]]
    inst.entity:SetCanSleep(false)
    inst.entity:Hide()

    inst:AddTag("CLASSIFIED")

	inst.persists = false

	return inst
end

local books = { Prefab("book_placeholder_spell", book_placeholder_spell_fn) }
for i, v in ipairs(book_defs) do
    table.insert(books, MakeBook(v))
end
book_defs = nil
return unpack(books)
