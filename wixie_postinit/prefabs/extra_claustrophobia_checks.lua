local ANTI_CLAUSTROPHOBIA = {
    "ruins_table", "ruins_chair", "ruins_vase", "ruins_plate", "ruins_bowl",
    "ruins_rubble_chair", "ruins_rubble_table", "ruins_rubble_vase",
    "ruins_chipbowl", "pumpkin_lantern", "watermelon_lantern"
}

for k, v in pairs(ANTI_CLAUSTROPHOBIA) do
    AddPrefabPostInit(v, function(inst) inst:AddTag("noclaustrophobia") end)
end
