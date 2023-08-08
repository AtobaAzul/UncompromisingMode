local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

local function ReticuleUpdatePositionFn(inst, pos, reticule, ease, smoothing, dt)
	inst.um_mouseposition_x = pos.x
	inst.um_mouseposition_z = pos.z
	--inst.berry.Transform:SetPosition(pos.x,0,pos.x)
end

local function CreateMousePositioning(inst)
	inst:DoTaskInTime(0,function(inst) inst:AddComponent("reticule")
		inst.components.reticule.updatepositionfn = ReticuleUpdatePositionFn
		inst.components.reticule.ease = true
		inst.components.reticule.mouseenabled = true
		inst.components.reticule:CreateReticule()
	end)
end

local function CheckAndApplyTempDamage(inst, data)
	if data ~= nil and data.amount ~= nil and data.amount < 0 and data.cause ~= nil and (data.cause == "cold" or data.cause == "hot")
	and inst.um_temp_healthdelta_task == nil then
		if inst.um_temp_healthdelta_task_buffer == nil then
			inst.um_temp_healthdelta_task_buffer = inst:DoTaskInTime(5, function()
				inst.um_temp_healthdelta_buffer = true
			end)
		end
		
		if inst.um_temp_healthdelta_buffer then
			inst.um_temp_healthdelta_task = inst:DoTaskInTime(1, function()
				if inst.um_temp_healthdelta_task ~= nil then
					inst.um_temp_healthdelta_task:Cancel()
				end
				
				inst.um_temp_healthdelta_task = nil
			end)
			
			if inst.um_temp_healthdelta_buffer_reset ~= nil then
				inst.um_temp_healthdelta_buffer_reset:Cancel()
			end
			inst.um_temp_healthdelta_buffer_reset = nil
			
			inst.um_temp_healthdelta_buffer_reset = inst:DoTaskInTime(10, function()
				if inst.um_temp_healthdelta_buffer_reset ~= nil then
					inst.um_temp_healthdelta_buffer_reset:Cancel()
				end

				if inst.um_temp_healthdelta_task_buffer ~= nil then
					inst.um_temp_healthdelta_task_buffer:Cancel()
				end
					
				inst.um_temp_healthdelta_task_buffer = nil
				inst.um_temp_healthdelta_buffer_reset = nil
				inst.um_temp_healthdelta_buffer = nil
			end)
			
			if inst.components.temperature ~= nil then
				if data.cause == "cold" then
					local coldrate = inst.components.temperature.hurtrate and (inst.components.temperature.hurtrate - .25) or 1
					
					if coldrate < 0 then
						coldrate = 0
					end
					
					inst.components.health:DeltaPenalty(0.01 * coldrate)
				elseif data.cause == "hot" then
					local heatrate = inst.components.temperature.overheathurtrate and (inst.components.temperature.overheathurtrate - .25) or 1
					
					if heatrate < 0 then
						heatrate = 0
					end
					
					inst.components.health:DeltaPenalty(0.01 * heatrate)
				end
				
			end
		end
	end
end

env.AddPlayerPostInit(function(inst)
	if not TheWorld.ismastersim then
		return inst
    end
	
    if TUNING.DSTU.VETCURSE == "always" then
        if inst ~= nil and inst.components.health ~= nil and
            not inst:HasTag("playerghost") then
            if not inst:HasTag("vetcurse") then
                inst.components.debuffable:AddDebuff("buff_vetcurse",
                                                     "buff_vetcurse")
                inst:PushEvent("foodbuffattached",
                               {buff = "ANNOUNCE_ATTACH_BUFF_VETCURSE", 1})
            end
        end
    elseif TUNING.DSTU.VETCURSE == "off" and inst:HasTag("vetcurse") then
        if inst ~= nil and inst.components.debuffable ~= nil then
            inst.components.debuffable:RemoveDebuff("buff_vetcurse")
        end -- help I can't get this stupid thing to work!!
    end

    inst:AddTag("SLUDGE_CORK_upgradeuser")

    -- instead of just winky, why the hell not make it *all* followers?!
    local _OnDespawn = inst.OnDespawn
    inst.um_all_followers = {}
    -- adding um_ prefix just in case...

    inst.OnDespawn = function(inst, migrationdata, ...)
        for k, v in pairs(inst.components.leader.followers) do
            if ((k:HasTag("spider") and not TUNING.DSTU.TREATS_FOR_WEBBER) or
                k:HasTag("pig") or k:HasTag("merm") or k:HasTag("raidrat") or
                k:HasTag("winky_rat") or k.prefab == "eyeofterror_mini_ally") or
                k.prefab == "smallbird" or k.prefab == "teenbird" or k.prefab ==
                "lightflier" then -- exluding things that can't/shouldn't/already do
                local savedata = k:GetSaveRecord()
                table.insert(inst.um_all_followers, savedata)
                -- remove followers
                k:AddTag("notarget")
                k:AddTag("NOCLICK")
                k.persists = false
                if k.components.health then
                    k.components.health:SetInvincible(true)
                end
				k:DoTaskInTime(math.random()*0.2, function(k)
					local fx = SpawnPrefab("spawn_fx_small")
					fx.Transform:SetPosition(k.Transform:GetWorldPosition())
					if not k.components.colourtweener then
						k:AddComponent("colourtweener")
					end
					k.components.colourtweener:StartTween({ 0, 0, 0, 1 }, 13 * FRAMES, k.Remove)
				end)
            end
        end
		
		return _OnDespawn(inst, migrationdata, ...)
    end

    local _OnSave = inst.OnSave

    inst.OnSave = function(inst, data, ...)
        data.um_all_followers = inst.um_all_followers
		
        if _OnSave ~= nil then 
			return _OnSave(inst, data, ...)
		end
    end

    local _OnLoad = inst.OnLoad

    inst.OnLoad = function(inst, data, ...)
        if data and data.um_all_followers then
            for k, v in pairs(data.um_all_followers) do
                inst:DoTaskInTime(0.2 * math.random(), function(inst)
                    local follower = SpawnSaveRecord(v)
                    inst.components.leader:AddFollower(follower)
                    follower:DoTaskInTime(0, function(follower)
                        if inst:IsValid() and not follower:IsNear(inst, 8) then
                            follower.Transform:SetPosition(
                                inst.Transform:GetWorldPosition())
                            follower.sg:GoToState("idle")
                        end
                    end)
                    local fx = SpawnPrefab("spawn_fx_small")
                    fx.Transform:SetPosition(
                        follower.Transform:GetWorldPosition())
                end)
            end
        end
		
        if _OnLoad ~= nil then 
			return _OnLoad(inst, data, ...) 
		end
    end
	
	inst:ListenForEvent("healthdelta", CheckAndApplyTempDamage)
	
	--Client after this
	--inst:AddTag("um_darkwood")
	--CreateMousePositioning(inst)
end)
