local env = env
GLOBAL.setfenv(1, GLOBAL)

------------------------------------------------------------------

local function SpawnHealFx(inst, fx_prefab, scale)
    local x,y,z = inst.Transform:GetWorldPosition()
    local fx = SpawnPrefab(fx_prefab)
    fx.Transform:SetNoFaced()
    fx.Transform:SetPosition(x,y,z)

    scale = scale or 1
    fx.Transform:SetScale(scale, scale, scale)
end

local SPIDER_TAGS = { "spider" }
local SPIDER_IGNORE_TAGS = { "FX", "NOCLICK", "DECOR", "INLIMBO" }
local function GetOtherSpiders(inst, radius, tags)
    tags = tags or SPIDER_TAGS
    local x, y, z = inst.Transform:GetWorldPosition()
    
    local spiders = TheSim:FindEntities(x, y, z, radius, nil, SPIDER_IGNORE_TAGS, tags)
    local valid_spiders = {}

    for _, spider in ipairs(spiders) do
        if spider:IsValid() and not spider.components.health:IsDead() and not spider:HasTag("playerghost") then
            table.insert(valid_spiders, spider)
        end
    end

    return valid_spiders
end

local function DoHeal(inst)
    local scale = 1.35
    SpawnHealFx(inst, "spider_heal_ground_fx", scale)
    SpawnHealFx(inst, "spider_heal_fx", scale)

    local other_spiders = GetOtherSpiders(inst, TUNING.SPIDER_HEALING_RADIUS, {"spider", "spiderwhisperer", "spiderqueen"})
    local leader = inst.components.follower.leader

    for i, spider in ipairs(other_spiders) do
        local target = inst.components.combat.target

        -- Don't heal the spider if it's targetting us, our leader or our leader's other followers
        local targetting_us = target ~= nil and 
                             (target == inst or (leader ~= nil and 
                             (target == leader or leader.components.leader:IsFollower(target))))

        -- Don't heal the spider if we're targetting it, or our leader is targetting it or our leader's other followers
        local targetted_by_us = inst.components.combat.target == spider or (leader ~= nil and
                                (leader.components.combat:TargetIs(spider) or
                                leader.components.leader:IsTargetedByFollowers(spider)))

        if not (targetting_us or targetted_by_us) then
            local heal_amount = spider:HasTag("spiderwhisperer") and 5 or TUNING.SPIDER_HEALING_AMOUNT
            spider.components.health:DoDelta(heal_amount, false, inst.prefab)
            SpawnHealFx(spider, "spider_heal_target_fx")
        end
    end

    inst.healtime = GetTime()
end

env.AddPrefabPostInit("spider_healer", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
    inst.components.health:SetMaxHealth(200)
	
    inst.OldDoHeal = inst.DoHeal
    inst.DoHeal = DoHeal
end)