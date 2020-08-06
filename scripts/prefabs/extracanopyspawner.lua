local assets =
{
Asset("ANIM", "anim/giant_tree.zip"),
}

--Shadow Spawning Function, for now
local function SpawnTreeShadows(inst)
local x, y, z = inst.Transform:GetWorldPosition()
x = x - 22
z = z - 22
for i = 1, 5 do
for k = 1, 5 do
local shadow = SpawnPrefab("hoodedcanopy")
shadow.Transform:SetPosition(x, y, z)
x = x + 11
end
x = x - 55
z = z + 11
end
inst:Remove()
end
local function makefn()
    	local inst = CreateEntity()

    	inst.entity:AddTransform()
    	inst.entity:AddAnimState()
        inst.entity:AddNetwork()
		inst.entity:AddSoundEmitter()
		inst.entity:AddMiniMapEntity()
		inst.entity:AddDynamicShadow()
        inst.entity:SetPristine()
		
        if not TheWorld.ismastersim then
            return inst
        end
		inst:DoTaskInTime(0,SpawnTreeShadows)
        return inst
end

return Prefab("extracanopyspawner", makefn, assets)

