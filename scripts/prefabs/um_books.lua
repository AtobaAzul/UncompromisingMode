local assets =
{
    Asset("ANIM", "anim/um_books.zip"),
    Asset("ATLAS", "images/inventoryimages/book_rain_um.xml"),
    Asset("IMAGE", "images/inventoryimages/book_rain_um.tex"),
}

local book_defs


book_defs = {
    {
        name = "book_rain_um",
        uses = TUNING.BOOK_USES_LARGE,
        read_sanity = -TUNING.SANITY_LARGE,
        peruse_sanity = TUNING.SANITY_LARGE,
        fx = "fx_book_rain",
        fn = function(inst, reader)
            if TheWorld.state.precipitation ~= "none" then
                TheWorld:PushEvent("ms_forceprecipitation", false)
            else
                TheWorld:PushEvent("ms_forceprecipitation", true)
            end

            local x, y, z = reader.Transform:GetWorldPosition()
            local size = TILE_SCALE

            for i = x - size, x + size do
                for j = z - size, z + size do
                    if TheWorld.Map:GetTileAtPoint(i, 0, j) ==
                        WORLD_TILES.FARMING_SOIL then
                        TheWorld.components.farming_manager:AddSoilMoistureAtPoint(i, y, j, 100)
                    end
                end
            end

            return true
        end,
        perusefn = function(inst, reader)
            if reader.peruse_rain then
                reader.peruse_rain(reader)
            end
            reader.components.talker:Say(GetString(reader, "ANNOUNCE_READ_BOOK", "BOOK_RAIN"))
            return true
        end
    }
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
        inst.AnimState:PlayAnimation(--[[def.name]] "book_rain")

        MakeInventoryFloatable(inst, "med", nil, 0.75)

        inst:AddTag("book")
        inst:AddTag("bookcabinet_item")
        inst:AddTag("donotautopick")
        
        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        -----------------------------------

        inst.def = def

        inst:AddComponent("inspectable")
        inst:AddComponent("book")
        inst.components.book:SetOnRead(def.fn)
        inst.components.book:SetOnPeruse(def.perusefn)
        inst.components.book:SetReadSanity(def.read_sanity)
        inst.components.book:SetPeruseSanity(def.peruse_sanity)
        inst.components.book:SetFx(def.fx)

        inst:AddComponent("inventoryitem")

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

        --inst:SetPrefabNameOverride("book_rain")

        return inst
    end

    return Prefab(def.name, fn, assets, prefabs)
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
