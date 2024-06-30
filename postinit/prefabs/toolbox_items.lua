local env = env
GLOBAL.setfenv(1, GLOBAL)

local toolbox_items = {
    "sewing_tape",
    "winona_machineparts_1",
    "winona_machineparts_2",
    "winona_recipescanner",
    "winona_telebrella",
    "inspectacleshat",
    "roseglasseshat",
    "winona_remote",
    "wagpunk_bits",
    "wagpunkbits_kit",
    "transistor",
    "nitre",
    "alterguardianhatshard",
    "purebrilliance",
    "sewing_tape"
}


for k, item in pairs(toolbox_items) do
    env.AddPrefabPostInit(item, function(inst)
        inst:AddTag("toolbox_item")
    end)
end
