local function Bishrun(brain)
	kite = 	GLOBAL.WhileNode( function() return brain.inst.components.combat.target and brain.inst.components.combat:InCooldown() end, "Dodge",
                    GLOBAL.RunAway(brain.inst, function() return brain.inst.components.combat.target end, 5, 8) )
	table.insert(brain.bt.root.children, 1, kite)
end
AddBrainPostInit("bishopbrain", Bishrun)