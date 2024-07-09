function WixieShove(inst, target, speed, billiard, distancemod, bonus_ammo_reduction, applyslow)
	if target ~= nil and 
	inst ~= nil and not 
	target:HasTag("wixieshoved") and not 
	target:HasTag("shadow") and not 
	target:HasTag("shadowcreature") and not 
	target:HasTag("shadowminion") and not 
	target:HasTag("stalkerminion") and not 
	target:HasTag("shadowchesspiece") and not 
	target:HasTag("eyeplant") and not
	target:HasTag("bowlingpin") and 
	target.components and 
	target.components.locomotor then
		SpawnPrefab("round_puff_fx_sm").Transform:SetPosition(target.Transform:GetWorldPosition())
								
		target:AddTag("wixieshoved")
		target:PushEvent("wixieshoved")
								
		if target:HasDebuff("wixiecurse_debuff") then
			target:PushEvent("wixiebite")
		end
		
		local x, y, z = inst.Transform:GetWorldPosition()
								
		for i = 1, 50 do
			inst:DoTaskInTime((i - 1) / 50, function(inst)
				local tx, ty, tz = target.Transform:GetWorldPosition()
					
				if tx ~= nil then
					local EXCLUDE_TAGS = { "player", "playerghost", "ghost", "shadow", "shadowminion", "noauradamage", "INLIMBO", "notarget", "noattack", "invisible", "wixieshoved" }
						
					if i == 1 and applyslow then
						print("ADD SPEED")
						target.components.locomotor:SetExternalSpeedMultiplier(target, "wixieshoved", .01)
					end
					
					if billiard then
						if i > 1 then
							local ents = TheSim:FindEntities(tx, ty, tz, 1.5 + target:GetPhysicsRadius(0), { "_combat" }, EXCLUDE_TAGS)
															
							for iv, v in ipairs(ents) do
								if v ~= target and v.components.locomotor then
									if not target:HasTag("epic") and target:HasDebuff("wixiecurse_stinkdebuff") and not v:HasDebuff("wixiecurse_stinkdebuff") then
										if v.components.combat then
											v.components.combat:DropTarget()
										end
									end
									
									v:PushEvent("wixieshoved")
									
									local giantdamagereduction = target:HasTag("epic") and 2 or target:HasTag("smallcreature") and 0.5 or 1
																	
									if v.components.combat ~= nil and v.components.freezable == nil or not (v.components.freezable ~= nil and v.components.freezable:IsFrozen()) then
										v.components.combat:GetAttacked(nil, 10 * giantdamagereduction)
										v.components.combat:SuggestTarget(inst)
									end
																	
									SpawnPrefab("round_puff_fx_sm").Transform:SetPosition(v.Transform:GetWorldPosition())
																
									v:AddTag("wixieshoved")
																	
									for iv = 1, 50 do
										inst:DoTaskInTime((iv - 1) / 50, function(inst)
											if v ~= nil and v.Transform:GetWorldPosition() and target ~= nil and tx ~= nil then
												if v == 1 and applyslow then
													v.components.locomotor:SetExternalSpeedMultiplier(target, "wixieshoved", .01)
												end

												local px, py, pz = v.Transform:GetWorldPosition()
												local rad_collision = -math.rad(v:GetAngleToPoint(tx, ty, tz))
												local velx_collision = math.cos(rad_collision) --* 4.5
												local velz_collision = -math.sin(rad_collision) --* 4.5
																				
												local targetreduction = target:HasTag("epic") and 1 or target:HasTag("smallcreature") and 3 or 2
												local vreduction = v:HasTag("epic") and 3 or v:HasTag("smallcreature") and 1 or 2
												local finalreduction = targetreduction + vreduction
												local vdebuffmultiplier = inst:HasTag("wixie_shove_3") and 1.15 or 
																			inst:HasTag("wixie_shove_2") and 1.1 or
																			inst:HasTag("wixie_shove_1") and 1.05 or
																			1

												local vdistancemultiplier = distancemod ~= nil and 1 + (distancemod / 10) or 1
																				
												local basepower = 10 / i or 10
												if px ~= nil then
													local vx, vy, vz = px + ((((5 / (iv + 1)) * velx_collision) / finalreduction) * vdebuffmultiplier) / vdistancemultiplier, py, pz + ((((5 / (iv + 1)) * velz_collision) / finalreduction) * vdebuffmultiplier) / vdistancemultiplier

													local ground_collision = TheWorld.Map:IsPassableAtPoint(vx, vy, vz)
													local boat_collision = TheWorld.Map:GetPlatformAtPoint(vx, vz)
													local ocean_collision = TheWorld.Map:IsOceanAtPoint(vx, vy, vz)
													local on_water = nil
																					
													if TUNING.DSTU.ISLAND_ADVENTURES then
														on_water = IsOnWater(vx, vy, vz)
													end
																					
													if not (v.sg ~= nil and (v.sg:HasStateTag("swimming") or v.sg:HasStateTag("invisible"))) then	
														if v ~= nil and v.components.locomotor ~= nil and vx ~= nil and (ground_collision or boat_collision or ocean_collision and v.components.locomotor:CanPathfindOnWater() or v.components.tiletracker ~= nil and not v:HasTag("whale")) then
															if not v:HasTag("aquatic") and not on_water or v:HasTag("aquatic") and on_water then
																v.Transform:SetPosition(vx, vy, vz)
															end
														end
													end
												end
											end
																			
											if iv >= 50 then
												v:RemoveTag("wixieshoved")
												
												if applyslow then
													v.components.locomotor:RemoveExternalSpeedMultiplier(v, "wixieshoved")
												end
											end
										end)
									end
								end
							end
						end
					end
													
					local scale = 0.5 - (i / 40)
					if scale > 0 then
						if not target:HasTag("flying") and target.sg ~= nil and not target.sg:HasStateTag("flight") and not target:HasTag("aquatic") then
							local dirtpuff = SpawnPrefab("dirt_puff")
							dirtpuff.Transform:SetPosition(target.Transform:GetWorldPosition())
							dirtpuff.Transform:SetScale(scale, scale, scale)
						end
					end
													
					local rad = math.rad(inst:GetAngleToPoint(tx, ty, tz))
					local velx = math.cos(rad) --* 4.5
					local velz = -math.sin(rad) --* 4.5
													
					local giantreduction = bonus_ammo_reduction and (target:HasTag("epic") and 8 or target:HasTag("smallcreature") and 2 or 3) or
											target:HasTag("epic") and 1.5 or target:HasTag("smallcreature") and 0.8 or 1
					local debuffmultiplier = inst:HasTag("wixie_shove_3") and 1.30 or 
												inst:HasTag("wixie_shove_2") and 1.20 or
												inst:HasTag("wixie_shove_1") and 1.10 or
												1
					local distancemultiplier = distancemod ~= nil and 1 + (distancemod / 10) or 1										
					local dx, dy, dz = tx + ((((3 / (i + 2)) * velx) / giantreduction) * debuffmultiplier) / distancemultiplier, ty, tz + ((((3 / (i + 2)) * velz) / giantreduction) * debuffmultiplier) / distancemultiplier
					local ground_target = TheWorld.Map:IsPassableAtPoint(dx, dy, dz)
					local boat_target = TheWorld.Map:GetPlatformAtPoint(dx, dz)
					local ocean_target = TheWorld.Map:IsOceanAtPoint(dx, dy, dz)
					local on_water_target = nil
																										
					if TUNING.DSTU.ISLAND_ADVENTURES then
						on_water_target = IsOnWater(dx, dy, dz)
					end
																				
					if not (target.sg ~= nil and (target.sg:HasStateTag("swimming") or target.sg:HasStateTag("invisible"))) then		
						if target ~= nil and target.components.locomotor ~= nil and dx ~= nil and (ground_target or boat_target or ocean_target and target.components.locomotor:CanPathfindOnWater() or target.components.tiletracker ~= nil and not target:HasTag("whale")) then
							if not target:HasTag("aquatic") and not on_water_target or target:HasTag("aquatic") and on_water_target then
								target.Transform:SetPosition(dx, dy, dz)
							end
						end
					end
				end
											
				if i >= 50 then
					target:RemoveTag("wixieshoved")
													
					if target.components.locomotor ~= nil and applyslow then
						print("REMOVE SPEED")
						target.components.locomotor:RemoveExternalSpeedMultiplier(target, "wixieshoved")
					end
				end
			end)
		end
	end
end