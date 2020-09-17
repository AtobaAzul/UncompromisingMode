local assets =
{
    Asset("ANIM", "anim/antlion_sinkhole.zip")
}

local function Sparks(inst)

	local x, y, z = inst.Transform:GetWorldPosition()
	SpawnPrefab("sparks").Transform:SetPosition(x + math.random(-2,2), y + .25, z + math.random(-2,2))
end

local function Zap(inst)
	if inst.task ~= nil then
		inst.task:Cancel()
	end

	local x, y, z = inst.Transform:GetWorldPosition()
    local projectile = SpawnPrefab("lightning")
    projectile.Transform:SetPosition(x, y + 2, z)
	
	SpawnPrefab("sparks").Transform:SetPosition(x, y + .25 + math.random() * 2, z)
	SpawnPrefab("sparks").Transform:SetPosition(x, y + .25 + math.random() * 2, z)
	SpawnPrefab("sparks").Transform:SetPosition(x, y + .25 + math.random() * 2, z)
	SpawnPrefab("sparks").Transform:SetPosition(x, y + .25 + math.random() * 2, z)
	SpawnPrefab("sparks").Transform:SetPosition(x, y + .25 + math.random() * 2, z)
    local ents = TheSim:FindEntities(x, y, z, 3.5, { "_combat" }, { "INLIMBO", "shadow", "hound" })
	
	for i, v in ipairs(ents) do
		if v ~= nil and v.components.health ~= nil and not v.components.health:IsDead() then
			if v:HasTag("player") and (v.components.inventory ~= nil and not v.components.inventory:IsInsulated()) then
				v.components.health:DoDelta(-30, nil, inst.prefab, nil, inst)
				v.sg:GoToState("electrocute")

				--local shockvictim = 
				--inst:DoTaskInTime(2, shockvictim)
			else
				v.components.combat:GetAttacked(nil, -30)
			end
		end
	end
	
	inst:DoTaskInTime(0, function(inst) inst:Remove() end)
end

-------------------------------------------------------------------------------

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
	inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("sinkhole")
    inst.AnimState:SetBuild("antlion_sinkhole")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(2)

	inst.AnimState:SetMultColour(1, 1, 0, 0)

    inst.Transform:SetEightFaced()
	
	inst:AddTag("hound_lightning")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	Sparks(inst)
	
	inst.task = inst:DoPeriodicTask(0.05, Sparks)
	
	inst:DoTaskInTime(1, Zap)

    return inst
end

return Prefab("hound_lightning", fn, assets)
