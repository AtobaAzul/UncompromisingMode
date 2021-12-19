local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

local function onothertimerdone(inst, data)
	if data.name == "rage" then
		if TheWorld.state.issummer then
			inst:DoTaskInTime(14, function(inst)
				inst:PushEvent("firefallstart")
			end)
			--[[inst:DoTaskInTime(17, function(inst)
				inst:PushEvent("firefall")
			end)
			inst:DoTaskInTime(21, function(inst)
				inst:PushEvent("firefall")
			end)
			inst:DoTaskInTime(25, function(inst)
				inst:PushEvent("firefall")
			end)
			inst:DoTaskInTime(29, function(inst)
				inst:PushEvent("firefall")
			end)
			inst:DoTaskInTime(30, function(inst)
				inst:PushEvent("firefallstart")
			end)]]
		end
	end
end

local function OnAttackedExplo(inst, data)
	inst.components.explosiveresist:SetResistance(0.9)
	if data.attacker:HasTag("explosive") then
		inst.AnimState:PlayAnimation("block_loop", true)
	end
end

env.AddPrefabPostInit("antlion", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	inst:ListenForEvent("timerdone", onothertimerdone)
	inst:AddComponent("firefallwarning")
	
	inst:AddComponent("explosiveresist")
	inst.components.explosiveresist:SetResistance(0.9)
	inst.components.explosiveresist.decay = true
	
    inst:ListenForEvent("attacked", OnAttackedExplo)
	
end)