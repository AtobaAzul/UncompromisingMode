local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddPrefabPostInit("marblebean", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	
	local function CanPlantAtPoint(x, y, z)
    local tile = TheWorld.Map:GetTileAtPoint(x, y, z)
    return 
        tile ~= GROUND.IMPASSABLE and
        tile ~= GROUND.INVALID 
	end
	
	local function can_plantmarble(inst, pt, mouseover, deployer)
	
	return CanPlantAtPoint(pt:Get())
    and TheWorld.Map:IsDeployPointClear(pt, inst, inst.replica.inventoryitem ~= nil and inst.replica.inventoryitem:DeploySpacingRadius() or DEPLOYSPACING_RADIUS[DEPLOYSPACING.DEFAULT])
	end
	
inst._custom_candeploy_fn = can_plantmarble	
inst.components.deployable:SetDeployMode(DEPLOYMODE.CUSTOM)
end)