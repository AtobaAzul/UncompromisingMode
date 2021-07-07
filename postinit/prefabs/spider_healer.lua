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

local function DoHeal(inst)
    local scale = 1.35
    SpawnHealFx(inst, "spider_heal_ground_fx", scale)
    SpawnHealFx(inst, "spider_heal_fx", scale)

    local other_spiders = GetOtherSpiders(inst, TUNING.SPIDER_HEALING_RADIUS, {"spider", "spiderwhisperer", "spiderqueen"})
    for i, spider in ipairs(other_spiders) do

        local heal_amount = spider:HasTag("spiderwhisperer") and 5 or TUNING.SPIDER_HEALING_AMOUNT
        spider.components.health:DoDelta(heal_amount, false, inst.prefab)
        SpawnHealFx(spider, "spider_heal_target_fx")
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