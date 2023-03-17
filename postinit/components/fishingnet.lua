local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddComponentPostInit("fishingnet", function(self)
	local _OldCastNet = self.CastNet
	
	function self:CastNet(pos_x, pos_z, doer)
		if self.inst:HasTag("uncompromising_fishingnetvisualizer") then
			local visualizer = SpawnPrefab("uncompromising_fishingnetvisualizer")
			visualizer.components.fishingnetvisualizer:BeginCast(doer, pos_x, pos_z)
			visualizer.item = self.inst
			self.visualizer = visualizer

			return true
		else
			return _OldCastNet(self, pos_x, pos_z, doer)
		end
	end
end)

env.AddComponentPostInit("fishingnetvisualizer", function(self)
	local _OldBeginOpening = self.BeginOpening
	local _OldDropItem = self.DropItem
	local SHOAL_MUST_TAGS = { "oceanshoalspawner" }
	
	function self:BeginOpening()
		_OldBeginOpening(self)
	
		if self.inst:HasTag("uncompromising_fishingnetvisualizer") then
			print("extra netty")
			if self.inst.item ~= nil then
				self.inst.item.netweight = 1
			end
		
			local my_x, my_y, my_z = self.inst.Transform:GetWorldPosition()
			local fishies = TheSim:FindEntities(my_x,my_y,my_z, self.collect_radius, {"oceanfishable"})
			for k, v in pairs(fishies) do
				local fishdef = v.fish_def ~= nil and v.fish_def.prefab ~= nil and v.fish_def.prefab or nil
				local fish = fishdef ~= nil and SpawnPrefab(fishdef.."_inv") or nil
				
				if fish == nil then
					fish = fishdef ~= nil and SpawnPrefab(fishdef.."_land") or nil
				end
					
				--how the FUCK does a 
				if fish == nil then
					return
				elseif fish ~= nil and k < 3 then
					--local fish = SpawnPrefab(fishtype)
					if self.inst.item ~= nil and v.components.weighable ~= nil then
						local minweight = v.components.weighable.min_weight
					
						if minweight < 100 then
							self.inst.item.netweight = self.inst.item.netweight + 2
						elseif minweight >= 100 and minweight < 200 then
							self.inst.item.netweight = self.inst.item.netweight + 3
						elseif minweight >= 200 then
							self.inst.item.netweight = self.inst.item.netweight + 4
						end
					end
					
					v:Remove()
					fish.Transform:SetPosition(my_x, my_y, my_z)
					fish.components.weighable:SetWeight(fish.components.weighable.min_weight)

					if fish:IsValid() then
						fish:RemoveFromScene()
					end
					
					table.insert(self.captured_entities, fish)
					self.captured_entities_collect_distance[fish] = 0
					
					-- An ocean shoal nearby? Send an event to notify listners
                    local shoals = TheSim:FindEntities(my_x, my_y, my_z, 16, SHOAL_MUST_TAGS)
                    if shoals ~= nil then
                        local shoal = shoals[1]
                        TheWorld:PushEvent("ms_shoalfishhooked", shoal)
                    end
				end
			end
			
			
		end
		
		--return _OldBeginOpening(self)
	end
	
	function self:DropItem(item, last_dir_x, last_dir_z, idx)
		if self.inst:HasTag("uncompromising_fishingnetvisualizer") then
			print("droppy drop")
			local thrower_x, thrower_y, thrower_z = self.thrower.Transform:GetWorldPosition()

			local time_between_drops = 0.25
			local initial_delay = 0.15
			item:DoTaskInTime(idx * time_between_drops + initial_delay, function(inst)

				item:ReturnToScene()
				item:PushEvent("on_release_from_net")

				local drop_vec_x = TheCamera:GetRightVec().x
				local drop_vec_z = TheCamera:GetRightVec().z

				local camera_up_vec_x, camera_up_vec_z = -TheCamera:GetDownVec().x, -TheCamera:GetDownVec().z

				if VecUtil_Dot(last_dir_x, last_dir_z, drop_vec_x, drop_vec_z) < 0 then
					drop_vec_x = -drop_vec_x
					drop_vec_z = -drop_vec_z
				end

				local up_offset_dist = 0.1

				local drop_offset = GetRandomWithVariance(1, 0.2)
				local pt_x = drop_vec_x * drop_offset + thrower_x + camera_up_vec_x * up_offset_dist
				local pt_z = drop_vec_z * drop_offset + thrower_z + camera_up_vec_z * up_offset_dist

				local physics = item.Physics
				
				if not TheWorld.Map:IsOceanAtPoint(pt_x, 0, pt_z) then
					if physics ~= nil then
						local drop_height = GetRandomWithVariance(0.65, 0.2)
						local pt_y = drop_height + thrower_y
						item.Transform:SetPosition(pt_x, pt_y, pt_z)
						physics:SetVel(0, -0.25, 0)
					else
						item.Transform:SetPosition(pt_x, 0, pt_z)
					end
				else
					if physics ~= nil then
						local drop_height = GetRandomWithVariance(0.65, 0.2)
						local pt_y = drop_height + thrower_y
						item.Transform:SetPosition(thrower_x, pt_y, thrower_z)
						physics:SetVel(0, -0.25, 0)
					else
						item.Transform:SetPosition(thrower_x, 0, thrower_z)
					end
				end
				
				if item:HasTag("stunnedbybomb") then
					item.sg:GoToState("stunned", false)
				end
			end)
		else 
			return _OldDropItem(self, item, last_dir_x, last_dir_z, idx)
		end
	end
end)