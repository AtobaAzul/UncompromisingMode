local env = env
GLOBAL.setfenv(1, GLOBAL)
local BigPopupDialogScreen = require "screens/popupdialog"
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
	if data ~= nil and data.amount ~= nil and data.amount < 0 and data.cause ~= nil and inst.components.health ~= nil then
		if TUNING.DSTU.MAXTEMPDAMAGE and (data.cause == "cold" or data.cause == "hot") then
			local worldtemperature = inst.um_world_temperature ~= nil and math.abs(inst.um_world_temperature - 35) / 20 or 0
			local temp_buffer = 7 - worldtemperature
			
			if inst.um_temp_healthdelta ~= nil and inst.um_temp_healthdelta >= temp_buffer then
				if (data.cause == "hot" and not inst:HasTag("heatresistant")) or (data.cause == "cold" and not inst:HasTag("coldresistant")) then
					inst.components.health:DeltaPenalty(math.abs(data.amount / inst.components.health.maxhealth))
				end
			else
				if inst.um_temp_healthdelta == nil then
					inst.um_temp_healthdelta = 0
				end
				
				inst.um_temp_healthdelta = inst.um_temp_healthdelta + FRAMES
			end

			if inst.um_temp_healthdelta_task ~= nil then
				inst.um_temp_healthdelta_task:Cancel()
			end
				
			inst.um_temp_healthdelta_task = inst:DoPeriodicTask(1, function()
				inst.um_temp_healthdelta = inst.um_temp_healthdelta - 1
				
				if inst.um_temp_healthdelta <= 0 then
					inst.um_temp_healthdelta = 0
					
					if inst.um_temp_healthdelta_task ~= nil then
						inst.um_temp_healthdelta_task:Cancel()
					end
						
					inst.um_temp_healthdelta_task = nil
				end
			end)
		elseif TUNING.DSTU.MAXHUNGERDAMAGE and data.cause == "hunger" then
			print("starving")
			if inst.um_temp_hungerdelta ~= nil and inst.um_temp_hungerdelta >= 1 then
				inst.components.health:DeltaPenalty(math.abs(data.amount / inst.components.health.maxhealth))
				print(inst.um_temp_hungerdelta)
			else
				if inst.um_temp_hungerdelta == nil then
					inst.um_temp_hungerdelta = 0
				else
					inst.um_temp_hungerdelta = inst.um_temp_hungerdelta + .5
				end
				print(inst.um_temp_hungerdelta)
			end

			if inst.um_temp_hungerdelta_task ~= nil then
				inst.um_temp_hungerdelta_task:Cancel()
				inst.um_temp_hungerdelta_task = nil
			end
				
			inst.um_temp_hungerdelta_task = inst:DoTaskInTime(1.5, function()
				inst.um_temp_hungerdelta = inst.um_temp_hungerdelta - 1
				
				if inst.um_temp_hungerdelta <= 0 then
					inst.um_temp_hungerdelta = nil
					
					if inst.um_temp_hungerdelta_task ~= nil then
						inst.um_temp_hungerdelta_task:Cancel()
					end
						
					inst.um_temp_hungerdelta_task = nil
				end
			end)
			--inst.components.health:DeltaPenalty(0.01)
		end
	end
end

local advertisements = {
	"Scrimbles is fucking epic?\nPress Ok to agree!",
	"Wilson enlargement pills?\nPress Ok to order today!",
	"Only True Gamers play Uncompromising Mode featuring Wixie the Delinquent?\nPress Ok to continue being a gamer today!",
	"Only True Gamers play Uncompromising Mode featuring Wathom the Abomination?\nPress Ok to continue being a gamer today!",
	"Only True Gamers play Uncompromising Mode featuring Winky the Vile Vermin?\nPress Ok to continue being a gamer today!",
	"Congratulations! You've collected enough Red Star Rings\nto uncover the secret location of this area's rival rush!",
	"For only 5 dollars a month, you can feed a starving Winky?\nPress Ok to donate today!",
	"There are Hot single Shadow Moms in YOUR area!?\nPress Ok to die today!",
	"There's no 'I' in 'peetza'?\nPress Ok to wake up",
	"Hi!!!! Hello!!!!!!!!!!!",
	"WX-78 ate 3000 gears in one day?\nPress Ok to find out how!",
	"e",
	"https://www.youtube.com/watch?v=BQ0h6dewnrQ",
	"I hate sand, it's rough and course.\nPress Ok to get everywhere.",
	"Don't Starve is an Uncompromising Wilderness Survival Game Full of Science and Magic?\nPress Ok to Uncompromise Today!",
	"Invisible Inc is Klei Entertainment's best game?\nPress Ok to Purchase Now!",
	"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\nPress Ok to AAAAAAAAA todAy!",
	"i love you",
	"You can get 5% off of Uncomp Brand Energy Drinks with the promo code:\nUncompGamer",
	"Lamp Oil?\nRope?\nBombs!?\nYou wannem?",
}

local function ToggleAdvertisee(inst)
	local player = inst.Advertisee:value()
	if player == ThePlayer then
		local function start_curse(inst)
			TheFrontEnd:PopScreen()
		end

		local title = "Did You Know?"
		local randnum = math.random(#advertisements)
			
		local bodytext = "Oops! Something Broke! Press Ok to break today!"
		for i, v in pairs(advertisements) do
			if i == randnum then
				bodytext = v
			end
		end

		local yes_box = { text = "Ok", cb = start_curse }
		local spacing = 200

		local bpds = BigPopupDialogScreen(title, bodytext, { yes_box })
		bpds.title:SetPosition(0, 90, 0)
		bpds.text:SetPosition(0, -15, 0)

		TheFrontEnd:PushScreen(bpds)
	end
end

local function RegisterNetListeners(inst)
	inst:ListenForEvent("SetAdvertiseedirty", ToggleAdvertisee)
end

env.AddPlayerPostInit(function(inst)

	inst.Advertisee = net_entity(inst.GUID, "SetAdvertisee.plyr", "SetAdvertiseedirty")
	
	inst:DoTaskInTime(0, RegisterNetListeners)

    if inst.components.areaaware then
    inst.components.areaaware:StartWatchingTile(WORLD_TILES.UM_FLOODWATER)
    end

	if not TheWorld.ismastersim then
		return inst
    end
	
	inst.components.locomotor:SetFasterOnGroundTile(WORLD_TILES.SCALE, true)

	if TUNING.DSTU.ADVERTISEMENTS then
		inst:DoPeriodicTask(10, function()
			inst.Advertisee:set_local(inst)
			inst.Advertisee:set(inst)
		end)
	end
	
	if TUNING.DSTU.SHRINK then
		inst:DoPeriodicTask(.5, function()
			if inst.components.locomotor ~= nil then
				print("walkspeed = "..inst.components.locomotor:GetWalkSpeed())
				print("runspeed = "..inst.components.locomotor:GetRunSpeed())
			end
		
			if inst.components.hunger ~= nil
			and inst.components.sanity ~= nil
			and inst.components.health ~= nil then
				local hunger_percent = (inst.components.hunger:GetPercent() / 2) + 0.5
				local health_percent = (inst.components.health:GetPercent() / 2) + 0.5
				local sanity_percent = inst.components.sanity:GetPercent()
			
				local percent_median = (hunger_percent + health_percent) / 2
			
				inst.Transform:SetScale(hunger_percent or 1, health_percent or 1, percent_median or 1)
				
				
				
				if sanity_percent <= 0.2 then
					inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
				else
					inst.AnimState:SetOrientation(ANIM_ORIENTATION.BillBoard)
				end
			end
		end)
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
	
	if TUNING.DSTU.MAXTEMPDAMAGE or TUNING.DSTU.MAXHUNGERDAMAGE then
		inst:ListenForEvent("temperaturetick", function(src, temperature)
				inst.um_world_temperature = temperature
			end, TheWorld)
		
		inst:ListenForEvent("healthdelta", CheckAndApplyTempDamage)
	end
	
	--Client after this
	--inst:AddTag("um_darkwood")
	--CreateMousePositioning(inst)
end)
