local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

env.AddPlayerPostInit(function(inst)
    if TUNING.DSTU.VETCURSE == "always" then
        if inst ~= nil and inst.components.health ~= nil and not inst:HasTag("playerghost") then
            if not inst:HasTag("vetcurse") then
                inst.components.debuffable:AddDebuff("buff_vetcurse", "buff_vetcurse")
                inst:PushEvent("foodbuffattached", { buff = "ANNOUNCE_ATTACH_BUFF_VETCURSE", 1 })
            end
        end
    elseif TUNING.DSTU.VETCURSE == "off" and inst:HasTag("vetcurse") then
        if inst ~= nil and inst.components.debuffable ~= nil then
            inst.components.debuffable:RemoveDebuff("buff_vetcurse")
        end --help I can't get this stupid thing to work!!
    end
    --[[local function amulet_resurrect(inst)
        for k, v in pairs(inst.components.inventory.equipslots) do
            if v.prefab == "amulet" then
                inst:DoTaskInTime(115/60, function(inst)
                    inst:PushEvent("respawnfromghost", { source = v })
                    v:DoTaskInTime(115/60, v.Remove)
                end)
            end
        end
    end

    inst:ListenForEvent("death", amulet_resurrect) ]]   
end)