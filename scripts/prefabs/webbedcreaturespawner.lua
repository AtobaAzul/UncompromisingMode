local assets =
{
}

local function SpawnWebbedCreature(inst)
local pt = inst:GetPosition()
local ded = SpawnPrefab("webbedcreature")
ded.Transform:SetPosition(pt.x, pt.y, pt.z)
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
		inst:AddComponent("timer")
		inst.components.timer:StartTimer("regrowcreature",3840*1.5)
		inst:ListenForEvent("timerdone", SpawnWebbedCreature)
        return inst
end

return Prefab("webbedcreaturespawner", makefn, assets)

