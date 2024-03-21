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
    local chargeables = TheSim:FindEntities(x,y,z, 3.5, {"_inventoryitem",}, inst.NoTags)

    for k,item in pairs(chargeables) do
        print(k, item)
        if item ~= nil and item.components.fueled ~= nil and item.components.fueled.fueltype == FUELTYPE.BATTERYPOWER then
            item.components.fueled:DoDelta(TUNING.SMALL_FUEL)
            item.components.fueled.ontakefuelfn(item, TUNING.SMALL_FUEL)
            if item.components.fueled:GetPercent() > 1 then
                item.components.fueled:SetPercent(1)
            end    
        end
    end

	for i, v in ipairs(ents) do
		if v ~= nil and v.components.health ~= nil and not v.components.health:IsDead() and v.components.combat ~= nil then
			if not v:HasTag("electricdamageimmune") then
				--v.components.combat:GetAttacked(inst, 20, nil, "electric")
				local insulated = (v:HasTag("electricdamageimmune") or
					(v.components.inventory ~= nil and v.components.inventory:IsInsulated()))

				local mult = not insulated
					and TUNING.ELECTRIC_DAMAGE_MULT + TUNING.ELECTRIC_WET_DAMAGE_MULT * (v.components.moisture ~= nil and v.components.moisture:GetMoisturePercent() or (v:GetIsWet() and 1 or 0))
					or 1
					
				local damage = -10 * mult
				
				if v.sg ~= nil and not v.sg:HasStateTag("nointerrupt") and not insulated and v:HasTag("player") and not v:HasTag("playerghost") and v.components.health ~= nil and not v.components.health:IsDead() then
					v.sg:GoToState("electrocute")
				end
						
				v.components.health:DoDelta(damage, nil, inst.prefab, nil, inst)
					
			else
				if v.components.playerlightningtarget ~= nil then
					v.components.playerlightningtarget:DoStrike()
				end

				--if v.sg ~= nil and not v.sg:HasStateTag("nointerrupt") and v.components.health ~= nil and not v.components.health:IsDead() then
					--v.sg:GoToState("hit")
				--end
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
    inst:AddTag("ignorewalkableplatforms")
    
	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst.NoTags = { "INLIMBO", "shadow", "structure", "wall" }

	inst.task = inst:DoPeriodicTask(0.05, Sparks)

	inst:DoTaskInTime(0, function() --modern problems require modern solutions
		-- need this or else when something sets inst.Delay the task will already have started with 1.
		inst.SoundEmitter:PlaySound("dontstarve/rain/thunder_far")
		Sparks(inst)
		inst:DoTaskInTime(inst.Delay ~= nil and inst.Delay or 1, Zap)
	end)
	return inst
end

return Prefab("hound_lightning", fn, assets)
