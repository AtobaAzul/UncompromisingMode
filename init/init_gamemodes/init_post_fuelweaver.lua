------------------------------------------------------------------------------------------
--TODO: Enable entire mod only after fuelweaver dies
------------------------------------------------------------------------------------------
if GetModConfigData("gamemode") == 1 then
    local function OnMinionDeath(inst)
        inst.components.timer:StopTimer("minions_cd")
        inst.components.timer:StartTimer("minions_cd", TUNING.STALKER_MINIONS_CD)
    end

    AddPrefabPostInit("stalker", function (inst)
        if inst ~= nil and inst.components ~= nil and inst.components.workable ~= nil then
            inst:ListenForEvent("miniondeath", OnMinionDeath)
        end
    end)
    
end