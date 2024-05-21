local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
local FULLY_REPAIRED_WORKLEFT = 3

local levels =
{
    { amount=6, grow="mushroom_4", idle="mushroom_4_idle", hit="hit_mushroom_4" },  -- this can only be reached by starting with spores
    { amount=4, grow="mushroom_3", idle="mushroom_3_idle", hit="hit_mushroom_3" },  -- max for starting with mushrooms
    { amount=2, grow="mushroom_2", idle="mushroom_2_idle", hit="hit_mushroom_2" },
    { amount=1, grow="mushroom_1", idle="mushroom_1_idle", hit="hit_mushroom_1" },
    { amount=0, idle="idle", hit="hit_idle" },
}

local function setlevel(inst, level, dotransition)
    if not inst:HasTag("burnt") then
        if inst.anims == nil then
            inst.anims = {}
        end
        if inst.anims.idle == level.idle then
            dotransition = false
        end

        inst.anims.idle = level.idle
        inst.anims.hit = level.hit

        if inst.remainingharvests == 0 then
            inst.anims.idle = "expired"
            inst.components.trader:Enable()
            inst.components.harvestable:SetGrowTime(nil)
            inst.components.workable:SetWorkLeft(1)
        elseif TheWorld.state.issnowcovered then
            inst.components.trader:Disable()
        elseif inst.components.harvestable:CanBeHarvested() then
            inst.components.trader:Disable()
        else
            inst.components.trader:Enable()
            inst.components.harvestable:SetGrowTime(nil)
        end

        if dotransition then
            inst.AnimState:PlayAnimation(level.grow)
            inst.AnimState:PushAnimation(inst.anims.idle, false)
            inst.SoundEmitter:PlaySound(level ~= levels[1] and "dontstarve/common/together/mushroomfarm/grow" or "dontstarve/common/together/mushroomfarm/spore_grow")
        else
            inst.AnimState:PlayAnimation(inst.anims.idle)
        end

    end
end

local function updatelevel(inst, dotransition)
    if not inst:HasTag("burnt") then
        if TheWorld.state.issnowcovered then
            if inst.components.harvestable:CanBeHarvested() then
                for i= 1,inst.components.harvestable.produce do
                    inst.components.lootdropper:SpawnLootPrefab("spoiled_food")
                end

                inst.components.harvestable.produce = 0
                inst.components.harvestable:StopGrowing()
                inst.remainingharvests = inst.remainingharvests - 1
            end
        end

        for k, v in pairs(levels) do
            if inst.components.harvestable.produce >= v.amount then
                setlevel(inst, v, dotransition)
                break
            end
        end
    end
end

local function acceptcompost(inst, item, giver)
    if item == nil then
        return false
    elseif inst.remainingharvests == 0 then
        if item.prefab == "livinglog" or item.prefab == "compostwrap" then
            return true
        elseif item.prefab == "compost" then	
			inst.remainingharvests = 2
			inst.components.workable:SetWorkLeft(FULLY_REPAIRED_WORKLEFT)
			updatelevel(inst)
			return true
		end
        return false, "MUSHROOMFARM_NEEDSLOG"
    elseif not (item:HasTag("mushroom") or item:HasTag("spore")) then
        return false, "MUSHROOMFARM_NEEDSSHROOM"
    elseif item:HasTag("moonmushroom") then
        local grower_skilltreeupdater = giver.components.skilltreeupdater
        if grower_skilltreeupdater and grower_skilltreeupdater:IsActivated("wormwood_moon_cap_eating") then
            return true
        else
            return false, "MUSHROOMFARM_NOMOONALLOWED"
        end
    else
        return true
    end
end

env.AddPrefabPostInit("mushroom_farm", function(inst)
	if not TheWorld.ismastersim then
		return
	end
    inst.components.trader:SetAbleToAcceptTest(acceptcompost)
end)
