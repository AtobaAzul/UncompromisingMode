GLOBAL.SetSharedLootTable('seastack_um',
    {
        { 'rocks',        1.00 },
        { 'rocks',        1.00 },
        { 'rocks',        1.00 },
        { 'nitre',        1.00 },
        { 'flint',        1.00 },
        { 'nitre',        0.25 },
        { 'flint',        0.60 },
        { 'bluegem',      0.05 },
        --{ 'fossil_piece', 0.10 },
        { 'goldnugget',   0.25 },
    })


AddPrefabPostInit("seastack", function(inst)
    if not GLOBAL.TheWorld.ismastersim then return end

    if inst.components.lootdropper ~= nil then
        inst.components.lootdropper:SetChanceLootTable('seastack_um')
    end
end)
