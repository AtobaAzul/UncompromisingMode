local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
SetSharedLootTable( 'pillar_ruins',
{
    {'rocks',	1.00},
    {'rocks',	1.00},
    {'rocks',	1.00},
    {'rocks',	1.00},
    {'thulecite',	1.00},
    {'thulecite',	1.00},
    {'thulecite',	0.50},
    {'thulecite_pieces',	1.00},
    {'thulecite_pieces',	1.00},
    {'thulecite_pieces',	1.00},
    {'thulecite_pieces',	1.00},
    {'thulecite_pieces',	0.50},
    {'thulecite_pieces',	0.50},
})

local function onhammered(inst, worker)
    inst.components.lootdropper:DropLoot(inst:GetPosition())
    local fx = SpawnPrefab("collapse_big")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("rock")
    inst:Remove()
end

env.AddPrefabPostInit("pillar_ruins", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(20)
    inst.components.workable:SetOnFinishCallback(onhammered)
	
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetChanceLootTable('pillar_ruins')

end)
