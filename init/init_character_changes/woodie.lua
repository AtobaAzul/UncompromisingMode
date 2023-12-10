-----------------------------------------------------------------
-- Change woodie idol recipe to require presthatilator
-----------------------------------------------------------------
local config_skilltrees = GetModConfigData("woodie_skilltree")

--[[
Recipe("wereitem_goose", {Ingredient("monstermeat", 3), Ingredient("seeds", 3)}, RECIPETABS.MAGIC, TECH.MAGIC_TWO, nil, nil, nil, nil, "werehuman")
Recipe("wereitem_beaver", {Ingredient("monstermeat", 3), Ingredient("log", 2)}, RECIPETABS.MAGIC, TECH.MAGIC_TWO, nil, nil, nil, nil, "werehuman")
Recipe("wereitem_moose", {Ingredient("monstermeat", 3), Ingredient("cutgrass", 2)}, RECIPETABS.MAGIC, TECH.MAGIC_TWO, nil, nil, nil, nil, "werehuman")
--]]
-----------------------------------------------------------------
-- If goose is over water, increase wetness
-----------------------------------------------------------------
--TODO: increase wetness properly, and make sure he gets freezing damage

--local WEREMODE_NAMES =
--{
--"beaver",
--}

--local WEREMODES = { NONE = 0 }
--for i, v in ipairs(WEREMODE_NAMES) do
--WEREMODES[string.upper(v)] = i
--end

--local function IsWereMode(mode)
--return WEREMODE_NAMES[mode] ~= nil
--end

--local function onworked(inst, data)
--if not inst.components.wereeater and data.target ~= nil and data.target.components.workable ~= nil then
--if IsWereMode(inst.weremode:value()) then
--inst.components.wereness:DoDelta(-3, true)
--elseif data.target.components.workable.action ~= nil and data.target.components.workable.action == GLOBAL.ACTIONS.CHOP then
--inst.components.wereness:DoDelta(1.5, true)
--end
--end
--end

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

--local function MooseResistance(inst)
--inst:DoTaskInTime(1, function(inst)
--if not inst:HasTag("beaver") and not inst:HasTag("weregoose") and inst.components.health ~= nil then
--if inst.components.skilltreeupdater:IsActivated("woodie_curse_epic_moose") then
--inst.components.health:SetAbsorptionAmount(.8)
--elseif inst.components.skilltreeupdater:IsActivated("woodie_curse_moose_3") then
--inst.components.health:SetAbsorptionAmount(.825)
--elseif inst.components.skilltreeupdater:IsActivated("woodie_curse_moose_2") then
--inst.components.health:SetAbsorptionAmount(.85)
--elseif inst.components.skilltreeupdater:IsActivated("woodie_curse_moose_1") then
--inst.components.health:SetAbsorptionAmount(.875)
--end
--end
--end)
--end
AddPrefabPostInit("woodie", function(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end
    if TUNING.DSTU.WOODIE_WET_GOOSE then
        inst:DoTaskInTime(GLOBAL.TUNING.WEREGOOSE_RUN_DRAIN_TIME_DURATION, OnGooseOverWater)
    end
    if config_skilltrees then
        inst:DoPeriodicTask(TUNING.ORANGEAMULET_ICD, pickup_UM_Beaver) --, nil, inst)
    end
    --inst:ListenForEvent("working", onworked)
    --inst:ListenForEvent("transform_wereplayer", MooseResistance)

    --local _RecalculateWereformSpeed = inst.RecalculateWereformSpeed

    --local function MooseResistance(inst)
    --if not inst:HasTag("beaver") and not inst:HasTag("weregoose") and inst.components.health ~= nil then
    --if inst.components.skilltreeupdater:IsActivated("woodie_curse_epic_moose") then
    --inst.components.health:SetAbsorptionAmount(.8)
    --elseif inst.components.skilltreeupdater:IsActivated("woodie_curse_moose_3") then
    --inst.components.health:SetAbsorptionAmount(.825)
    --elseif inst.components.skilltreeupdater:IsActivated("woodie_curse_moose_2") then
    --inst.components.health:SetAbsorptionAmount(.85)
    --elseif inst.components.skilltreeupdater:IsActivated("woodie_curse_moose_1") then
    --inst.components.health:SetAbsorptionAmount(.875)
    --end
    --end
    --end

    --local function ReroutingFunction(inst)
    --_RecalculateWereformSpeed(inst)
    --MooseResistance(inst)
    --end

    --inst.RecalculateWereformSpeed = ReroutingFunction
end)
