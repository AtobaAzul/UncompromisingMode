local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------


env.AddPrefabPostInit("slurtle_shellpieces", function(inst)
    if inst.components.stackable ~= nil then
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM
    end
end)