
local function SpawnMist(inst)
local x, y, z = inst.Transform:GetWorldPosition()
x = x - 44
z = z - 44
for i = 1, 5 do
for k = 1, 5 do
local shadow = SpawnPrefab("ratgas")
local x1,z1
x1 = x+math.random(-5,5)
z1 = z+math.random(-5,5)
shadow.Transform:SetPosition(x1, y, z1)
x = x + 22 + math.random(-0.75,0.75)
end
x = x - 110
z = z + 22 + math.random(-0.75,0.75)
end
inst:Remove()
end

local function fnspawner()
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
		inst:DoTaskInTime(0,SpawnMist)
        return inst
end


local function fnmist()
	local inst = CreateEntity()
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddNetwork()
	
	inst:AddTag("FX")
	inst:AddTag("NOCLICK")
	inst:AddTag("marshmist")
    inst.AnimState:SetBuild("marshmist")
    inst.AnimState:SetBank("marshmist")
    inst.AnimState:PlayAnimation("idle", true)
	
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(LAYER_WORLD)
    inst.AnimState:SetSortOrder(1)
	inst.AnimState:SetScale(10, 8, 5)
	inst:AddComponent("areaaware")
	inst:DoTaskInTime(0.1,function(inst)
		if not inst.components.areaaware:CurrentlyInTag("rattygas") then
			inst:Remove()
		end
	end)
	inst.AnimState:SetMultColour(0, 0, 0, 0.15)

    return inst
end

return Prefab("ratgas", fnmist),
Prefab("ratgas_spawner", fnspawner)
