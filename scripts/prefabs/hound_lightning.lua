local assets =
{
    Asset("ANIM", "anim/antlion_sinkhole.zip")
}

local function Sparks(inst)

	local x, y, z = inst.Transform:GetWorldPosition()
	
	local x1 = x + math.random(-2, 2)
	local z1 = z + math.random(-2, 2)
	
	if math.random() >= 0.6 then
		SpawnPrefab("electricchargedfx").Transform:SetPosition(x1, 0, z1)
	end
	
    SpawnPrefab("sparks").Transform:SetPosition(x1, 0 + 0.25 * math.random(), z1)

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
    local ents = TheSim:FindEntities(x, y, z, 3.5, { "_health" }, inst.NoTags)
	
	for i, v in ipairs(ents) do
		if v ~= nil and v.components.health ~= nil and not v.components.health:IsDead() and v.components.combat ~= nil then
			if v:HasTag("player") and (v.components.inventory ~= nil and not v.components.inventory:IsInsulated()) then
				if not v:HasTag("electricdamageimmune") then
					v.components.health:DoDelta(-25, nil, inst.prefab, nil, inst)
					v.sg:GoToState("electrocute")
				else
					if not v:HasTag("automaton") then
						v.components.combat:GetAttacked(inst, -10)
					else
						v.OnLesserCharge(v)
					end
				end
			elseif v.components.combat ~= nil then
				v.components.combat:GetAttacked(inst, -25)
			end
		end
	end
	
	inst:DoTaskInTime(0, function(inst) inst:Remove() end)
end

-------------------------------------------------------------------------------

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	inst:AddTag("hound_lightning")
	inst:AddTag("sharp")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.NoTags = { "INLIMBO", "shadow" }
	
	Sparks(inst)
	
	inst.task = inst:DoPeriodicTask(0.05, Sparks)
	
    inst.SoundEmitter:PlaySound("dontstarve/rain/thunder_far")
	
	inst:DoTaskInTime(1, Zap)

    return inst
end

return Prefab("hound_lightning", fn, assets)
