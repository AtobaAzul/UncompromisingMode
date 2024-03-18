local env = env
GLOBAL.setfenv(1, GLOBAL)

--this ended up being a player postinit lmfao
env.AddPlayerPostInit(function(inst)
    if not TheWorld.ismastersim then
        return
    end

    inst:ListenForEvent("itemget", function(inst, data)
        if data.item.prefab == "compass" then
            data.item.components.fueled:StartConsuming()

            inst:AddTag("compassbearer")

            if inst.components.maprevealable ~= nil then
                inst.components.maprevealable:AddRevealSource(data.item, "compassbearer")
            end
        end
    end)

    inst:ListenForEvent("itemlose", function(inst, data)
        if data.prev_item.prefab == "compass" and not inst.components.inventory:HasItemWithTag("compass", 1) then
            inst:RemoveTag("compassbearer")

            if inst.components.maprevealable ~= nil then
                inst.components.maprevealable:RemoveRevealSource(inst)
            end

            data.prev_item.components.fueled:StopConsuming()
        end
    end)
end)
