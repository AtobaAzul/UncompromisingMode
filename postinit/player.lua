local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

env.AddPlayerPostInit(function(inst)
    
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