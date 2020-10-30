local env = env
GLOBAL.setfenv(1, GLOBAL)

-----------------------------------------------------------------
-- Koala health buffed
-----------------------------------------------------------------


env.AddPrefabPostInit("koalefant_summer", function(inst)
if inst ~= nil and inst.components.health ~= nil then
    inst.components.health:SetMaxHealth(2000)
end
end)

env.AddPrefabPostInit("koalefant_winter", function(inst)
if inst ~= nil and inst.components.health ~= nil then
    inst.components.health:SetMaxHealth(2000)
end
end)