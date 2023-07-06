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




env.AddPlayerPostInit(function(inst)
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
                k:DoTaskInTime(math.random() * 0.2, function(k)
                    local fx = SpawnPrefab("spawn_fx_small")
                    fx.Transform:SetPosition(k.Transform:GetWorldPosition())
                    k:RemoveFromScene()
                end)
            end
        end
        _OnDespawn(inst, migrationdata, ...)
    end

    local _OnSave = inst.OnSave

    inst.OnSave = function(inst, data)
        data.um_all_followers = inst.um_all_followers
		
        if _OnSave ~= nil then 
			return _OnSave(inst, data)
		end
    end

    local _OnLoad = inst.OnLoad

    inst.OnLoad = function(inst, data)
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
                data.um_all_followers = {} -- empty the table to prevent duping.
            end
        end
		
        if _OnLoad ~= nil then 
			return _OnLoad(inst, data) 
		end
    end
	
	--Client after this
	if TheWorld.ismastersim then
        return inst
    end
	
	--CreateMousePositioning(inst)
end)
