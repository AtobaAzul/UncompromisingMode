local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

env.AddPrefabPostInitAny(function(inst)
    if inst.components.fueled ~= nil and inst.components.fueled.secondaryfueltype == nil and (inst.components.fueled.fueltype == FUELTYPE.BURNABLE or inst.components.fueled.fueltype == FUELTYPE.CAVE) then
        inst.components.fueled.secondaryfueltype = FUELTYPE.SLUDGE
    end
end)