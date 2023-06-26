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
			if not v:HasTag("electricdamageimmune") then
				--v.components.combat:GetAttacked(inst, 20, nil, "electric")

				local mult = not (v:HasTag("electricdamageimmune") or
					(v.components.inventory ~= nil and v.components.inventory:IsInsulated()))
					and TUNING.ELECTRIC_DAMAGE_MULT + TUNING.ELECTRIC_WET_DAMAGE_MULT * (v.components.moisture ~= nil and v.components.moisture:GetMoisturePercent() or (v:GetIsWet() and 1 or 0))
					or 1
					
				local damage = -20 * mult
						
				v.components.health:DoDelta(damage, nil, inst.prefab, nil, inst)
					
				if v.sg ~= nil and not v.sg:HasStateTag("nointerrupt") then
					v.sg:GoToState("electrocute")
				end
			else
				if v.components.playerlightningtarget ~= nil then
					v.components.playerlightningtarget:DoStrike()
				end

				if v.sg ~= nil and not v.sg:HasStateTag("nointerrupt") then
					v.sg:GoToState("hit")
				end
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

	inst.NoTags = { "INLIMBO", "shadow", "structure", "wall" }

	Sparks(inst)

	inst.task = inst:DoPeriodicTask(0.05, Sparks)

	inst.SoundEmitter:PlaySound("dontstarve/rain/thunder_far")
	inst:DoTaskInTime(0, function() --modern problems require modern solutions
		-- need this or else when something sets inst.Delay the task will already have started with 1.
		inst:DoTaskInTime(inst.Delay ~= nil and inst.Delay or 1, Zap)
	end)
	return inst
end

return Prefab("hound_lightning", fn, assets)
