local bosses = {
    "minotaur",
    "stalker_atrium",
    "bearger",
    "mutatedbearger",
    "beequeen",
    "alterguardian",
    "deerclops",
    "mutateddeerclops",
    "dragonfly",
    "eyeofterror",
    "twinofterror",
    "sharkboi",
    "lordfruitfly",
    "malbatross",
    "moose",
    "daywalker",
    --"warg" WARG IS NOT A BOSS.
    "mutatedwarg",
    "spiderqueen",
    "toadstool",
    "toadstool_dark",
    "klaus",
    "antlion",
    "crabking",
    "hoodedwidow",
    "moonmaw_dragonfly",
    "mothergoose",
    "mock_dragonfly"
}


for k, v in pairs(bosses) do
    if v == "alterguardian" then
        AddPrefabPostInit("alterguardian_phase1", function(inst)
            if not GLOBAL.TheWorld.ismastersim then
                return
            end

            if inst.components.health ~= nil then
                inst.components.health:SetMaxHealth(inst.components.health.maxhealth * GetModConfigData(v .. "_health"))
            end
        end)

        AddPrefabPostInit("alterguardian_phase2", function(inst)
            if not GLOBAL.TheWorld.ismastersim then
                return
            end

            if inst.components.health ~= nil then
                inst.components.health:SetMaxHealth(inst.components.health.maxhealth * GetModConfigData(v .. "_health"))
            end
        end)

        AddPrefabPostInit("alterguardian_phase3", function(inst)
            if not GLOBAL.TheWorld.ismastersim then
                return
            end

            if inst.components.health ~= nil then
                inst.components.health:SetMaxHealth(inst.components.health.maxhealth * GetModConfigData(v .. "_health"))
            end
        end)
    elseif v == "twinofterror" then
        AddPrefabPostInit("twinofterror1", function(inst)
            if not GLOBAL.TheWorld.ismastersim then
                return
            end

            if inst.components.health ~= nil then
                inst.components.health:SetMaxHealth(inst.components.health.maxhealth * GetModConfigData(v .. "_health"))
            end
        end)

        AddPrefabPostInit("twinofterror2", function(inst)
            if not GLOBAL.TheWorld.ismastersim then
                return
            end

            if inst.components.health ~= nil then
                inst.components.health:SetMaxHealth(inst.components.health.maxhealth * GetModConfigData(v .. "_health"))
            end
        end)
    elseif v == "leif" then
        AddPrefabPostInit("leif", function(inst)
            if not GLOBAL.TheWorld.ismastersim then
                return
            end

            if inst.components.health ~= nil then
                inst.components.health:SetMaxHealth(inst.components.health.maxhealth * GetModConfigData(v .. "_health"))
            end
        end)

        AddPrefabPostInit("leif_sparse", function(inst)
            if not GLOBAL.TheWorld.ismastersim then
                return
            end

            if inst.components.health ~= nil then
                inst.components.health:SetMaxHealth(inst.components.health.maxhealth * GetModConfigData(v .. "_health"))
            end
        end)
    else
        AddPrefabPostInit(v, function(inst)
            if not GLOBAL.TheWorld.ismastersim then
                return
            end

            if inst.components.health ~= nil then
                inst.components.health:SetMaxHealth(inst.components.health.maxhealth * GetModConfigData(v .. "_health"))
            end
        end)
    end
end

AddPrefabPostInitAny(function(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end
    if not table.contains(bosses, inst.prefab) then
        if inst.components.health ~= nil and inst:HasTag("epic") then
            inst.components.health:SetMaxHealth(inst.components.health.maxhealth * GetModConfigData("boss_health"))
        end
    end
end)


TUNING.STALKER_ATRIUM_PHASE2_HEALTH = TUNING.STALKER_ATRIUM_PHASE2_HEALTH * GetModConfigData("stalker_atrium_health")
TUNING.SHADOW_ROOK.HEALTH = { (1000 * GetModConfigData("shadowpieces_health")), (4000 * GetModConfigData("shadowpieces_health")), (10000 * GetModConfigData("shadowpieces_health")) }
TUNING.SHADOW_KNIGHT.HEALTH = { (900 * GetModConfigData("shadowpieces_health")), (2700 * GetModConfigData("shadowpieces_health")), (8100 * GetModConfigData("shadowpieces_health")) }
TUNING.SHADOW_BISHOP.HEALTH = { (800 * GetModConfigData("shadowpieces_health")), (2500 * GetModConfigData("shadowpieces_health")), (7500 * GetModConfigData("shadowpieces_health")) }
