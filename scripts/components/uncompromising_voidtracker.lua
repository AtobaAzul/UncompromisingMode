
return Class(function(self, inst)
	self.inst = inst
	
	local function Consume(inst)
	
		if ((inst.sg ~= nil) and not (inst.sg.currentstate.name == "teleportato_teleport" or inst.sg.currentstate.name == "death") and TUNING.DSTU.HUNGRY_VOID) then
			inst.sg:GoToState("teleportato_teleport")
		inst:DoTaskInTime(84*FRAMES,function(inst)
			local tentapillars = {}
			for k, v in pairs(Ents) do 
				if v.prefab == "tentacle_pillar" then
					table.insert(tentapillars, v)
				end
			end
			local random_tentapillar = tentapillars[math.random(#tentapillars)]
			if random_tentapillar ~= nil then
				local x, y, z = random_tentapillar.Transform:GetWorldPosition()
				inst.Transform:SetPosition(x+1,y,z+1)
				inst:PushEvent("death")
				inst:RemoveTag("VoidDoomed")
				inst:DoTaskInTime(0,function(inst) inst.AnimState:PlayAnimation("death2_idle") end) -- play this animation instead
			end
	
		end)
	end
	end
	
	local function CheckLand(inst) --"VoidDoomed" tag prevents cheesing
		if TheWorld:HasTag("cave") then
			local x,y,z = inst.Transform:GetWorldPosition()
				if (x ~= nil and y ~= nil and z ~= nil and not TheWorld.Map:IsVisualGroundAtPoint(x,y,z) and inst.components.health ~= nil) or 
				(inst:HasTag("VoidDoomed") and not ((inst.sg ~= nil) and (inst.sg.currentstate.name == "teleportato_teleport" or inst.sg.currentstate.name == "death"))) then
					inst:AddTag("VoidDoomed")
					Consume(inst)
				end
		end
	end
	
	
	inst:DoPeriodicTask(1,CheckLand)
	end)