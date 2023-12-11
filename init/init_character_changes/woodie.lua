local config_skilltrees = GetModConfigData("woodie_skilltree")

local function OnGooseOverWater(inst)
    if inst.weremode:value() == 3 then
        if inst ~= nil and inst.components.drownable ~= nil and inst.components.drownable:IsOverWater() and inst.components.moisture ~= nil then
            inst.components.moisture:DoDelta(GLOBAL.TUNING.DSTU.GOOSE_WATER_WETNESS_RATE, true)
        end
    end
    inst:DoTaskInTime(GLOBAL.TUNING.WEREGOOSE_RUN_DRAIN_TIME_DURATION, OnGooseOverWater)
end

local function pickup_UM_Beaver(inst)
    if inst:HasTag("beaver") and inst.components.skilltreeupdater:IsActivated("woodie_curse_epic_beaver") and inst.components.health ~= nil then
        local x, y, z = inst.Transform:GetWorldPosition()
        local ents =
            TheSim:FindEntities(x, y, z, 1.2 * TUNING.ORANGEAMULET_RANGE, nil, ORANGE_PICKUP_CANT_TAGS, ORANGE_PICKUP_MUST_TAGS)
        for i, v in ipairs(ents) do
            if v.components.inventoryitem ~= nil and v.components.inventoryitem.canbepickedup and v.components.inventoryitem.cangoincontainer and not v.components.inventoryitem:IsHeld() and inst.components.inventory:CanAcceptCount(v, 1) > 0 and not v.components.equippable then
                if inst.components.minigame_participator ~= nil then
                    local minigame = inst.components.minigame_participator:GetMinigame()
                    if minigame ~= nil then
                        minigame:PushEvent("pickupcheat", { cheater = inst, item = v })
                    end
                end
                GLOBAL.SpawnPrefab("dirt_puff").Transform:SetPosition(v.Transform:GetWorldPosition())
                local v_pos = v:GetPosition()
                if v.components.stackable ~= nil then
                    v = v.components.stackable:Get()
                end
                if v.components.trap ~= nil and v.components.trap:IsSprung() then
                    v.components.trap:Harvest(inst)
                else
                    inst.components.inventory:GiveItem(v, nil, v_pos)
                end
                return
            end
        end
    end
end

local function WoodieMaxHealth(inst)
    --inst:DoTaskInTime(1, function(inst)
	local percent = inst.components.health:GetPercent()
	if inst:HasTag("beaver") or inst:HasTag("weregoose") or inst:HasTag("weremoose") then
		if inst.components.health.maxhealth ~= 150 then
			inst.components.health:SetMaxHealth(150)
			inst.components.health:SetPercent(percent)
		end
	elseif inst.components.skilltreeupdater:IsActivated("woodie_curse_epic_moose") then
		if inst.components.health.maxhealth ~= 50 then		
			inst.components.health:SetMaxHealth(50)
			inst.components.health:SetPercent(percent)
		end
	elseif inst.components.skilltreeupdater:IsActivated("woodie_curse_moose_3") then
		if inst.components.health.maxhealth ~= 75 then		
			inst.components.health:SetMaxHealth(75)
			inst.components.health:SetPercent(percent)
		end
	elseif inst.components.skilltreeupdater:IsActivated("woodie_curse_moose_2") then
		if inst.components.health.maxhealth ~= 100 then		
			inst.components.health:SetMaxHealth(100)
			inst.components.health:SetPercent(percent)
		end	
	elseif inst.components.skilltreeupdater:IsActivated("woodie_curse_moose_1") then
		if inst.components.health.maxhealth ~= 125 then		
			inst.components.health:SetMaxHealth(125)
			inst.components.health:SetPercent(percent)	
		end
	elseif inst.components.health.maxhealth ~= 150 then
		inst.components.health:SetMaxHealth(150)
		inst.components.health:SetPercent(percent)
	end		
	--end)
end

AddPrefabPostInit("woodie", function(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end
    if TUNING.DSTU.WOODIE_WET_GOOSE then
        inst:DoTaskInTime(GLOBAL.TUNING.WEREGOOSE_RUN_DRAIN_TIME_DURATION, OnGooseOverWater)
    end
    if config_skilltrees then
        inst:DoPeriodicTask(TUNING.ORANGEAMULET_ICD, pickup_UM_Beaver) --, nil, inst)
		inst:DoPeriodicTask(0, WoodieMaxHealth)
    end
end)
