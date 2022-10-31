local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------


local soil_amenders =
{
    "soil_amender_fermented",
    "soil_amender"
}
for k, v in ipairs(soil_amenders) do
    env.AddPrefabPostInit(v, function(inst)
        inst:AddTag("NORATCHECK")
    end)
end