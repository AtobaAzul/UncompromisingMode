local UM_Ripplespawner = Class(function(self, inst)
    self.inst = inst
    self.range = 3
end)

function UM_Ripplespawner:spawnripple(inst)
	if inst ~= nil then
		local x, y, z = inst.Transform:GetWorldPosition()
		
		local _map = TheWorld.Map
		local current_tile = _map:GetTileAtPoint(x, y, z)

		if current_tile == WORLD_TILES.UM_FLOODWATER then
			if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
				inst.components.burnable:Extinguish()
			elseif inst.sg and inst.sg:HasStateTag("moving") then
				local splash = SpawnPrefab("weregoose_splash")
				
				splash.Transform:SetPosition(x,y,z)
				
				if not inst:HasTag("largecreature") then
					if inst:HasTag("isinventoryitem") then
						splash.Transform:SetScale(0.65,0.65,0.65)
					else    
						splash.Transform:SetScale(0.75,0.75,0.75)
					end
				end
				
				if inst.components.moisture ~= nil then
					local waterproofness = inst.components.inventory and math.min(inst.components.inventory:GetWaterproofness(),1) or 0
					inst.components.moisture:DoDelta(1 * (1 - waterproofness), true)
				end
			end    
			
			local x,y,z = inst.Transform:GetWorldPosition()
			local ripple = SpawnPrefab("weregoose_ripple1")
			
			if math.random() > 0.5 then
				ripple = SpawnPrefab("weregoose_ripple2")
			end
			
			ripple.Transform:SetPosition(x,y,z)
			
			if not inst:HasTag("largecreature") then
				if inst:HasTag("isinventoryitem") then
					ripple.Transform:SetScale(0.85,0.85,0.85)
				end
			else
				ripple.Transform:SetScale(1.2,1.2,1.2)
			end
			
			if ripple.AnimState ~= nil then
				ripple.AnimState:SetOceanBlendParams(.2)
			end
			
			if inst.components.moisture ~= nil then
				inst:AddTag("um_waterfall_moisture_override")
					
				if inst:IsValid() and self.inst ~= nil and self.inst:IsValid() and inst:GetDistanceSqToInst(self.inst) <= 6 then
					inst:AddTag("um_waterfall_bonus")
					local headsplash = SpawnPrefab("splash")
					headsplash.entity:SetParent(inst.entity)
					headsplash.entity:AddFollower():FollowSymbol(inst.GUID, "swap_hat", 0, -2, 0)
				else
					inst:RemoveTag("um_waterfall_bonus")
				end
					
				if inst.um_waterfall_task ~= nil then
					inst.um_waterfall_task:Cancel()
					inst.um_waterfall_task = nil
				end
					
				inst.um_waterfall_task = inst:DoTaskInTime(.4, function(inst)
					inst:RemoveTag("um_waterfall_moisture_override")
					inst:RemoveTag("um_waterfall_bonus")
					
					if inst.um_waterfall_task ~= nil then
						inst.um_waterfall_task:Cancel()
						inst.um_waterfall_task = nil
					end
				end)
			end
		end
	end
	
	inst.um_rippletask = nil 
end

function UM_Ripplespawner:OnEntitySleep()
	self.inst:StopUpdatingComponent(self)
end

function UM_Ripplespawner:OnEntityWake()
	self.inst:StartUpdatingComponent(self)
end

function UM_Ripplespawner:OnUpdate(dt)
    local x,y,z = self.inst.Transform:GetWorldPosition()
    local ents = {}
    
    if self.range > 0 then
        ents = TheSim:FindEntities(x,y,z, self.range, nil,{"flying","INLIMBO", "shadowcreature"}, {"monster","animal","character","isinventoryitem","tree","structure", "_burnable"})
    end

    local templist = {}

    for i, ent in ipairs(ents) do
        templist[ent.GUID] = ent
    end

    for GUID, ent in pairs(templist)do
		if ent.um_rippletask == nil then
			ent.um_rippletask = ent:DoTaskInTime(ent.components.locomotor ~= nil and (1.8 / ent.components.locomotor:GetRunSpeed()) or .3,
				function(ent) 
				self:spawnripple(ent) end)
		end
    end
end

function UM_Ripplespawner:SetRange(newrange)
    self.range = newrange
end

return UM_Ripplespawner
