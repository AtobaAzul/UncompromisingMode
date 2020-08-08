local function ClearTrees(inst)
local x,y,z = inst.Transform:GetWorldPosition()
local tree = TheSim:FindEntities(x,y,z,12, {"tree"},{"canopy"})
for i, v in ipairs(tree) do
v:Remove()
end
inst:Remove()
end
local function SpawnWidowWeb(inst)
local x,y,z = inst.Transform:GetWorldPosition()
local web = SpawnPrefab("widowweb")
web.Transform:SetPosition(x, y, z)
end
local function SpawnCacoons(inst)
for i = 1, 3 do
local x,y,z = inst.Transform:GetWorldPosition()
x=x+math.random(-7,7)
z=z+math.random(-7,7)
local cacoon = SpawnPrefab("webbedcreature")
cacoon.Transform:SetPosition(x, y, z)
end
end
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

	--inst:AddTag("CLASSIFIED")
		
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	--inst:AddTag("CLASSIFIED")
	
	inst:DoTaskInTime(0, SpawnWidowWeb)
	inst:DoTaskInTime(0, SpawnCacoons)
	inst:DoTaskInTime(0.1, ClearTrees)
    return inst
end

return Prefab("widowwebspawner", fn)
