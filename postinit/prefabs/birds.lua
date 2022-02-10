local prefabs =
{
	"crow",
}
local function MapCheck(x,y,z)
    if GLOBAL.TheWorld.Map:IsVisualGroundAtPoint(x, y, z) then
		local node = GLOBAL.TheWorld.Map:FindNodeAtPoint(x, y, z)
		return node ~= nil and node.tags ~= nil and table.contains(node.tags, "hoodedcanopy")
	end
	return false
end
local function UMBirdSwap(inst) --Fix is a slightly different version of ADM's fix to bird spawning on the cherry island, credits to ADM.
	local cage = inst.components.occupier ~= nil and inst.components.occupier:GetOwner()
	if cage == nil and
		not inst.components.inventoryitem:IsHeld() and
		inst.sg.currentstate.name == "glide" then
		local x, y, z = inst.Transform:GetWorldPosition()
		if MapCheck(x,y,z) then
		if math.random() > 0.5 then
			local birb = GLOBAL.SpawnPrefab("woodpecker")
			birb.Transform:SetPosition(x, y, z)
			birb.sg:HasStateTag("glide")
			inst:Remove()
		else
			local birb = (GLOBAL.TheWorld.state.iswinter and GLOBAL.SpawnPrefab("robin_winter")) or GLOBAL.SpawnPrefab("robin")
			birb.Transform:SetPosition(x, y, z)
			birb.sg:HasStateTag("glide")
			inst:Remove()		
		end
		end
	end
end

for k, v in pairs(prefabs) do
	AddPrefabPostInit(v, function(inst)
		inst:DoTaskInTime(0, UMBirdSwap)
	end)
end
