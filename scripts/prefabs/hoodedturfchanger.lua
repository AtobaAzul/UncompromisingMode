local function TryTileChange(x,z)
if TheWorld.Map:IsAboveGroundAtPoint(x, 0, z) then
print("donee")
TheWorld.Map:SetTile(x, z, GROUND.FOREST)
end
end

local function Initialize(inst)
local x,y,z = inst.Transform:GetWorldPosition()
TryTileChange(x,z)
local xi, zi = 0,0
	for i = 1,math.random(1,3) do
		if math.random() > 0.5 then
			xi = x + i
		else
			xi = x - i
		end
		for j = 1,math.random(1,3) do
			if math.random() > 0.5 then
				zi = z + j
			else
				zi = z - j
			end
		end
		TryTileChange(xi,zi)
	end
	if not TheWorld:HasTag("boutaswap") then
		TheWorld:AddTag("boutaswap")
		inst:DoTaskInTime(0,function(inst) 
			TheWorld.Map:Finalize(0)
			inst:Remove() 
		end) 
	else
		inst:Remove()
	end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:DoTaskInTime(0,Initialize)
    return inst
end

return Prefab("hoodedturfchanger", fn)
