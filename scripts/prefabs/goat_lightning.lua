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

local function ArtificialLocomote(inst, destination, speed) --Locomotor is basically running a similar code anyhow, this bypasses any physics interactions preventing
	if destination and speed then --our locomote from working... Inconsistencies in when the entity is supposed to walk forward led to this.
		speed = speed * FRAMES
		local hypoten = math.sqrt(inst:GetDistanceSqToPoint(destination))
		local x, y, z = inst.Transform:GetWorldPosition()
		local x_final, y_final, z_final
		local speedmult = inst.components.locomotor ~= nil and inst.components.locomotor:GetSpeedMultiplier() or 1
		x_final = ((destination.x - x) / hypoten) * (speed * speedmult) + x
		z_final = ((destination.z - z) / hypoten) * (speed * speedmult) + z

		inst.Transform:SetPosition(x_final, y, z_final)
	end
end

local function DoDamageStuff(inst)
	local x,y,z = inst.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x,y,z,2,{"_combat"},{"INLIMBO","lightninggoat"})
	for i, v in ipairs(ents) do
		if v ~= nil and v.components.health ~= nil and not v.components.health:IsDead() and v.components.combat ~= nil then
			if v:HasTag("player") and (v.components.inventory ~= nil and not v.components.inventory:IsInsulated()) then
				if not v:HasTag("electricdamageimmune") then
					v.components.health:DoDelta(-25, nil, inst.prefab, nil, inst)
					v.sg:GoToState("electrocute")
				else
					if not v:HasTag("automaton") then
						v.components.combat:GetAttacked(inst, 10)
					else
						if v.components.playerlightningtarget ~= nil then
							v.components.playerlightningtarget:DoStrike()
						end
					end
				end
			elseif v.components.combat ~= nil then
				v.components.combat:GetAttacked(inst, 3)
			end
		end
	end		
end

local function ShockStream(inst)
	if inst.destination then
		local shocker = SpawnPrefab("electricchargedfx")
		shocker.Transform:SetPosition(inst.Transform:GetWorldPosition())
		DoDamageStuff(inst)
	end
end
-------------------------------------------------------------------------------

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	inst:AddTag("goat_lightning")
	inst:AddTag("sharp")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.NoTags = { "INLIMBO", "shadow", "structure", "wall" }
	
	Sparks(inst)
	
	inst.task = inst:DoPeriodicTask(0.05, ShockStream)
	
    --inst.SoundEmitter:PlaySound("dontstarve/rain/thunder_far")
	
	--inst:DoTaskInTime(1, Zap)
	inst.movetask = inst:DoPeriodicTask(FRAMES,function(inst)
		if inst.destination then
			if inst:GetDistanceSqToPoint(inst.destination) < 0.01 then
				inst.movetask:Cancel()
				inst.movetask = nil
				SpawnPrefab("hound_lightning").Transform:SetPosition(inst.Transform:GetWorldPosition())
				inst:Remove()
			else
				ArtificialLocomote(inst, inst.destination, 15)
			end
		else
			inst:Remove()
		end
	end)
    return inst
end

return Prefab("goat_lightning", fn, assets)
