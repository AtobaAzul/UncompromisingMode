local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
TUNING.DSTU.NORATCHECK =--defining it here for simplicity's sake.
{
    "powcake",
	"powcake_spice_chili",
	"powcake_spice_garlic",
	"powcake_spice_salt",
	"powcake_spice_sugar",
    "moonstorm_spark",
    "charcoal",
    "heatrock",
    "soil_amender_fermented",
    "soil_amender",
    "lantern",
}

for k, v in ipairs(TUNING.DSTU.NORATCHECK) do
    env.AddPrefabPost(v, function(inst)
		if inst ~= nil then
			inst:AddTag("NORATCHECK")
		end

    end)
end
