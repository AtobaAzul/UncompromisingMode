local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddPrefabPostInit("shieldofterror", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	if inst.components.armor ~= nil then
		inst.components.armor:InitCondition(2*TUNING.SHIELDOFTERROR_ARMOR, TUNING.SHIELDOFTERROR_ABSORPTION)
	end
	
	if inst.components.eater ~= nil then
		local _Oldoneatfn = inst.components.eater.oneatfn
		
		inst.components.eater.oneatfn = function(inst, food)
			if food.prefab == "spoiled_food" or food:HasTag("spoiled_fish") then
				local health = food.components.edible:GetHealth(inst) * inst.components.eater.healthabsorption
				local hunger = food.components.edible:GetHunger(inst) * inst.components.eater.hungerabsorption
				inst.components.armor:Repair(health + hunger)
				
				if not inst.inlimbo then
					inst.AnimState:PlayAnimation("eat")
					inst.AnimState:PushAnimation("idle", true)

					inst.SoundEmitter:PlaySound("dontstarve/common/teleportworm/sick_cough")
				else
					inst.SoundEmitter:PlaySound("dontstarve/common/teleportworm/sick_cough")
				end
			elseif _Oldoneatfn ~= nil then
			   _Oldoneatfn(inst, food)
			end

		end
	end
end)

env.AddPrefabPostInit("eyemaskhat", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	if inst.components.eater ~= nil then
		local _Oldoneatfn = inst.components.eater.oneatfn
		
		inst.components.eater.oneatfn = function(inst, food)
			if food.prefab == "spoiled_food" or food:HasTag("spoiled_fish") then
				local health = food.components.edible:GetHealth(inst) * inst.components.eater.healthabsorption
				local hunger = food.components.edible:GetHunger(inst) * inst.components.eater.hungerabsorption
				inst.components.armor:Repair(health + hunger)
				
				if not inst.inlimbo then
					inst.AnimState:PlayAnimation("eat")
					inst.AnimState:PushAnimation("anim", true)

					inst.SoundEmitter:PlaySound("dontstarve/common/teleportworm/sick_cough")
				else
					inst.SoundEmitter:PlaySound("dontstarve/common/teleportworm/sick_cough")
				end
			elseif _Oldoneatfn ~= nil then
			   _Oldoneatfn(inst, food)
			end

		end
	end
end)