-- If goose is over water, increase wetness
AddPrefabPostInit("woodie", function (inst)
    
    local function OnGooseRunningOver(inst, CalculateWerenessDrainRate)

        --Find if goose is running
        if inst._gooserunninglevel > 1 then
            inst._gooserunninglevel = inst._gooserunninglevel - 1
            inst._gooserunning = inst:DoTaskInTime(TUNING.WEREGOOSE_RUN_DRAIN_TIME_DURATION, OnGooseRunningOver, CalculateWerenessDrainRate)
        else
            inst._gooserunning = nil
            inst._gooserunninglevel = nil
        end
        
        --If on water, get wet
        if inst.components.drownable ~= nil and inst.components.drownable:IsOverWater() and IsWereMode("goose") then
            inst.components.moisture:DoDelta(GLOBAL.TUNING.DSTU.GOOSE_WATER_WETNESS_RATE, true)
        end

        inst.components.wereness:SetDrainRate(CalculateWerenessDrainRate(inst, WEREMODES.GOOSE, TheWorld.state.isfullmoon))
    end
end)