local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

local function launchitem(item, angle)
    local speed = math.random() * 4 + 2
    angle = (angle + math.random() * 60 - 30) * DEGREES
    item.Physics:SetVel(speed * math.cos(angle), math.random() * 2 + 8, speed * math.sin(angle))
end

local function ontradeforgold(inst, item, giver)
    --AwardPlayerAchievement("pigking_trader", giver)

    local x, y, z = inst.Transform:GetWorldPosition()
    y = 4.5

    local angle
    if giver ~= nil and giver:IsValid() then
        angle = 180 - giver:GetAngleToPoint(x, 0, z)
    else
        local down = TheCamera:GetDownVec()
        angle = math.atan2(down.z, down.x) / DEGREES
        giver = nil
    end

    for k = 1, 1 do
        local nug = SpawnPrefab("goldnugget")
        nug.Transform:SetPosition(x, y, z)
        launchitem(nug, angle)
		local meat = SpawnPrefab("goldnugget")
        meat.Transform:SetPosition(x, y, z)
        launchitem(meat, angle)
    end

    if item.components.tradable.tradefor ~= nil then
        for _, v in pairs(item.components.tradable.tradefor) do
            local item = SpawnPrefab(v)
            if item ~= nil then
                item.Transform:SetPosition(x, y, z)
                launchitem(item, angle)
            end
        end
    end

end

local function OnGetItemFromPlayer(inst, giver, item)
    local is_event_item = IsSpecialEventActive(SPECIAL_EVENTS.HALLOWED_NIGHTS) and item.components.tradable.halloweencandyvalue and item.components.tradable.halloweencandyvalue > 0

    if item.prefab == "oceanfish_" then
    inst.AnimState:PlayAnimation("use")
	inst.SoundEmitter:PlaySound("hookline/common/tackle_station/use")
        inst:DoTaskInTime(inst.AnimState:GetCurrentAnimationLength(), ontradeforgold, item, giver)
    end
end

local function OnRefuseItem(inst, giver, item)
    --inst.sg:GoToState("unimpressed")
end

local function AbleToAcceptTest(inst, item, giver)
--[[
	if not IsSpecialEventActive(SPECIAL_EVENTS.YOTP) and item.prefab == "pig_token" then
		return true -- todo: remove this once post-yotp gameplay is done
	end

	if item.prefab == "pig_token" then
		local success, reason = CanStartMinigame(inst, giver)
		if not success then
			OnRefuseItem(inst, giver, item)
		end
		return success, reason
	end
	--]]
	return true
end

local function AcceptTest(inst, item, giver)
--[[
	if not IsSpecialEventActive(SPECIAL_EVENTS.YOTP) and item.prefab == "pig_token" then
		return -- todo: remove this once post-yotp gameplay is done
	end

    -- TODO: do we want Wurt to trade?
    if giver:HasTag("merm") then
        return
    end

    local is_event_item = IsSpecialEventActive(SPECIAL_EVENTS.HALLOWED_NIGHTS) and item.components.tradable.halloweencandyvalue and item.components.tradable.halloweencandyvalue > 0
    --]]
	return item.prefab == inst:HasTag("oceanfish_")
end

env.AddPrefabPostInit("tacklestation", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	inst:AddComponent("trader")

    inst.components.trader:SetAbleToAcceptTest(AbleToAcceptTest)
    inst.components.trader:SetAcceptTest(AcceptTest)
    inst.components.trader.onaccept = OnGetItemFromPlayer
    inst.components.trader.onrefuse = OnRefuseItem
	
end)