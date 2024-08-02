local env = env
GLOBAL.setfenv(1, GLOBAL)

local GAP = 38
local BIGGAP = 54
local CATGAP = 87 --math.abs(-214 - 228)/(#ORDERS)
local X = -218
local Y = 170     --6

local TITLE_Y_OFFSET = 30
local ORDERS =
{
    { "might",        { -218, Y + TITLE_Y_OFFSET } },
    { "training",     { -70, Y + TITLE_Y_OFFSET } },
    { "planardamage", { 90, Y + TITLE_Y_OFFSET } },
    { "allegiance",   { 200, Y + TITLE_Y_OFFSET } },
}
local SkillTreeDefs = require("prefabs/skilltree_defs")



local skills =
{
    -- MIGHT
    wolfgang_critwork_1 = {
        title = STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_CRITWORK_1_TITLE,
        desc = STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_CRITWORK_1_DESC,
        icon = "wolfgang_critwork_1",
        pos = { X, Y },
        --pos = {1,0},
        group = "might",
        tags = { "might" },
        root = true,
        connects = {
            "wolfgang_critwork_2",
        },
    },
    wolfgang_critwork_2 = {
        title = STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_CRITWORK_2_TITLE,
        desc = STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_CRITWORK_2_DESC,
        icon = "wolfgang_critwork_2",
        pos = { X, Y - GAP },
        --pos = {1,0},
        group = "might",
        tags = { "might" },
        connects = {
            "wolfgang_critwork_3",
        },
    },
    wolfgang_critwork_3 = {
        title = STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_CRITWORK_3_TITLE,
        desc = STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_CRITWORK_3_DESC,
        icon = "wolfgang_critwork_3",
        pos = { X, Y - GAP * 2 },
        --pos = {1,0},
        group = "might",
        tags = { "might" },
        connects = {
            "wolfgang_critwork_4",
        },
    },

    wolfgang_critwork_4 = {
        title = STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_CRITWORK_4_TITLE,
        desc = STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_CRITWORK_4_DESC,
        icon = "wolfgang_critwork_3",
        pos = { X, Y - GAP * 3 },
        --pos = {1,0},
        group = "might",
        tags = { "might" },
        connects = {
            "wolfgang_critwork_expert",
        },
    },

    wolfgang_critwork_expert = {
        title = STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_CRITWORK_EXPERT_TITLE,
        desc = STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_CRITWORK_EXPERT_DESC,
        icon = "wolfgang_critwork_3",
        pos = { X, Y - GAP * 4 },
        --pos = {1,0},
        group = "might",
        tags = { "might", "might_expert" },
    },

    -- TRAINING
    -- 1

    wolfgang_normal_coach = {
        title = STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_COACH_TITLE,
        desc = STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_COACH_DESC,
        icon = "wolfgang_coach",
        pos = { X + CATGAP, Y },
        --pos = {1,0},
        group = "training",
        tags = { "training" },
        onactivate = function(inst, fromload) inst:AddTag("wolfgang_coach") end,
        ondeactivate = function(inst, fromload) inst:RemoveTag("wolfgang_coach") end,
        root = true,
    },

    wolfgang_mighty_legs = {
        title = STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_MIGHTY_LEGS_TITLE,
        desc = STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_MIGHTY_LEGS_DESC,
        icon = "wolfgang_speed",
        pos = { X + CATGAP + GAP, Y },
        group = "training",
        tags = { "training" },
        onactivate = function(inst, fromload) inst:AddTag("mighty_leap") end,
        ondeactivate = function(inst, fromload) inst:RemoveTag("mighty_leap") end,
        root = true,
        connects = {
            "wolfgang_mighty_legs_2",
        },
    },

    wolfgang_mighty_legs_2 = {
        title = STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_MIGHTY_LEGS_2_TITLE,
        desc = STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_MIGHTY_LEGS_2_DESC,
        icon = "wolfgang_speed",
        pos = { X + CATGAP + GAP, Y - GAP },
        group = "training",
        tags = { "training" },
        connects = {
            "wolfgang_mighty_legs_3",
        },
    },

    wolfgang_mighty_legs_3 = {
        title = STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_MIGHTY_LEGS_3_TITLE,
        desc = STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_MIGHTY_LEGS_3_DESC,
        icon = "wolfgang_speed",
        pos = { X + CATGAP + GAP, Y - GAP * 2 },
        group = "training",
        tags = { "training" },
        connects = {
            "wolfgang_mighty_legs_4",
        },
    },

    wolfgang_mighty_legs_4 = {
        title = STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_MIGHTY_LEGS_4_TITLE,
        desc = STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_MIGHTY_LEGS_4_DESC,
        icon = "wolfgang_speed",
        pos = { X + CATGAP + GAP, Y - GAP * 3 },
        group = "training",
        tags = { "training" },
        connects = {
            "wolfgang_mighty_legs_expert",
        },
    },

    wolfgang_mighty_legs_expert = {
        title = STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_MIGHTY_LEGS_EXPERT_TITLE,
        desc = STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_MIGHTY_LEGS_EXPERT_DESC,
        icon = "wolfgang_speed",
        pos = { X + CATGAP + GAP, Y - GAP * 4 },
        group = "training",
        tags = { "training" },
    },

    wolfgang_dumbbell_crafting = {
        title = STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_DUMBBELL_CRAFTING_TITLE,
        desc = STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_DUMBBELL_CRAFTING_DESC,
        icon = "wolfgang_dumbbell_crafting",
        pos = { X + CATGAP + GAP * 2, Y },
        --pos = {1,0},
        group = "training",
        tags = { "dumbbell_craft" },
        onactivate = function(inst, fromload) inst:AddTag("wolfgang_dumbbell_crafting") end,
        ondeactivate = function(inst, fromload) inst:RemoveTag("wolfgang_dumbbell_crafting") end,
        root = true,
        connects = {
            "wolfgang_dumbbell_throwing_1",
        },
    },


    -- 2
    wolfgang_dumbbell_throwing_1 = {
        title = STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_DUMBBELL_THROWING_1_TITLE,
        desc = STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_DUMBBELL_THROWING_1_DESC,
        icon = "wolfgang_dumbbell_throwing_1",
        pos = { X + CATGAP + GAP * 2, Y - GAP },
        --pos = {1,0},
        group = "training",
        tags = { "dumbbell_throwing" },
        connects = {
            "wolfgang_dumbbell_throwing_2",
        },
    },

    wolfgang_dumbbell_throwing_2 = {
        title = STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_DUMBBELL_THROWING_2_TITLE,
        desc = STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_DUMBBELL_THROWING_2_DESC,
        icon = "wolfgang_dumbbell_throwing_2",
        pos = { X + CATGAP + GAP * 2, Y - GAP * 2 },
        --pos = {1,0},
        group = "training",
        tags = { "dumbbell_throwing" },
    },

    wolfgang_overbuff_1 = {
        title = STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_GYM_OVERBUFF_1_TITLE,
        desc = STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_GYM_OVERBUFF_1_DESC,
        icon = "wolfgang_overbuff_1",
        pos = { X + CATGAP + GAP * 3, Y },
        --pos = {1,0},
        group = "training",
        tags = { "overbuff" },
        onactivate = function(inst, fromload)
            inst:AddTag("wolfgang_overbuff_1")
            if inst.components.mightiness:GetOverMax() < TUNING.SKILLS.WOLFGANG_OVERBUFF_1 then
                inst.components.mightiness:SetOverMax(TUNING.SKILLS.WOLFGANG_OVERBUFF_1)
            end
        end,
        root = true,
        connects = {
            "wolfgang_overbuff_2",
        },
    },

    --3
    wolfgang_overbuff_2 = {
        title = STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_GYM_OVERBUFF_2_TITLE,
        desc = STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_GYM_OVERBUFF_2_DESC,
        icon = "wolfgang_overbuff_2",
        pos = { X + CATGAP + GAP * 3, Y - GAP },
        --pos = {1,0},
        group = "training",
        tags = { "overbuff" },
        onactivate = function(inst, fromload)
            inst:AddTag("wolfgang_overbuff_2")
            if inst.components.mightiness:GetOverMax() < TUNING.SKILLS.WOLFGANG_OVERBUFF_2 then
                inst.components.mightiness:SetOverMax(TUNING.SKILLS.WOLFGANG_OVERBUFF_2)
            end
        end,
        connects = {
            "wolfgang_overbuff_3",
        },
    },

    wolfgang_overbuff_3 = {
        title = STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_GYM_OVERBUFF_3_TITLE,
        desc = STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_GYM_OVERBUFF_3_DESC,
        icon = "wolfgang_overbuff_3",
        pos = { X + CATGAP + GAP * 3, Y - GAP * 2 },
        --pos = {1,0},
        group = "training",
        tags = { "overbuff" },
        onactivate = function(inst, fromload)
            inst:AddTag("wolfgang_overbuff_3")
            if inst.components.mightiness:GetOverMax() < TUNING.SKILLS.WOLFGANG_OVERBUFF_3 then
                inst.components.mightiness:SetOverMax(TUNING.SKILLS.WOLFGANG_OVERBUFF_3)
            end
        end,
        connects = {
            "wolfgang_overbuff_4",
        },
    },

    wolfgang_overbuff_4 = {
        title = STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_GYM_OVERBUFF_4_TITLE,
        desc = STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_GYM_OVERBUFF_4_DESC,
        icon = "wolfgang_overbuff_4",
        pos = { X + CATGAP + GAP * 3, Y - GAP * 3 },
        --pos = {1,0},
        group = "training",
        tags = { "overbuff" },
        onactivate = function(inst, fromload)
            inst:AddTag("wolfgang_overbuff_4")
            if inst.components.mightiness:GetOverMax() < TUNING.SKILLS.WOLFGANG_OVERBUFF_4 then
                inst.components.mightiness:SetOverMax(TUNING.SKILLS.WOLFGANG_OVERBUFF_4)
            end
        end,
        connects = {
            "wolfgang_overbuff_5",
        },
    },

    wolfgang_overbuff_5 = {
        title = STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_GYM_OVERBUFF_5_TITLE,
        desc = STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_GYM_OVERBUFF_5_DESC,
        icon = "wolfgang_overbuff_5",
        pos = { X + CATGAP + GAP * 3, Y - GAP * 4 },
        --pos = {1,0},
        group = "training",
        tags = { "overbuff", "overbuff_expert" },
        onactivate = function(inst, fromload)
            inst:AddTag("wolfgang_overbuff_expert")
            inst:AddTag("wolfgang_overbuff_5")
            if inst.components.mightiness:GetOverMax() < TUNING.SKILLS.WOLFGANG_OVERBUFF_5 then
                inst.components.mightiness:SetOverMax(TUNING.SKILLS.WOLFGANG_OVERBUFF_5)
            end
        end,
    },



    -- SUPER
    wolfgang_mighty_strikes_1 = {
        title = STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_MIGHTY_STRIKES_1_TITLE,
        desc = STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_MIGHTY_STRIKES_1_DESC,
        icon = "wolfgang_planardamage_1",
        pos = { 90, Y },
        --pos = {1,0},
        group = "planardamage",
        tags = { "planardamage" },
        root = true,
        connects = {
            "wolfgang_mighty_strikes_2",
        },
    },

    wolfgang_mighty_strikes_2 = {
        title = STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_MIGHTY_STRIKES_2_TITLE,
        desc = STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_MIGHTY_STRIKES_2_DESC,
        icon = "wolfgang_planardamage_2",
        pos = { 90, Y - GAP },
        --pos = {1,0},
        group = "planardamage",
        tags = { "planardamage" },
        connects = {
            "wolfgang_mighty_strikes_3",
        },
    },

    wolfgang_mighty_strikes_3 = {
        title = STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_MIGHTY_STRIKES_3_TITLE,
        desc = STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_MIGHTY_STRIKES_3_DESC,
        icon = "wolfgang_planardamage_3",
        pos = { 90, Y - GAP * 2 },
        --pos = {1,0},
        group = "planardamage",
        tags = { "planardamage" },
        connects = {
            "wolfgang_mighty_strikes_4",
        },
    },

    wolfgang_mighty_strikes_4 = {
        title = STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_MIGHTY_STRIKES_4_TITLE,
        desc = STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_MIGHTY_STRIKES_4_DESC,
        icon = "wolfgang_planardamage_4",
        pos = { 90, Y - GAP * 3 },
        --pos = {1,0},
        group = "planardamage",
        tags = { "planardamage" },
        connects = {
            "wolfgang_mighty_strikes_5",
        },
    },

    wolfgang_mighty_strikes_5 = {
        title = STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_MIGHTY_STRIKES_5_TITLE,
        desc = STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_MIGHTY_STRIKES_5_DESC,
        icon = "wolfgang_planardamage_5",
        pos = { 90, Y - GAP * 4 },
        --pos = {1,0},
        group = "planardamage",
        tags = { "planardamage" },
    },

    wolfgang_allegiance_lock_1 = {
        desc = STRINGS.SKILLTREE.ALLEGIANCE_LOCK_2_DESC,
        pos = { 200 - GAP / 2, Y },
        --pos = {0,-1},
        group = "allegiance",
        tags = { "allegiance", "lock" },
        lock_open = function(prefabname, activatedskills, readonly)
            if readonly then
                return "question"
            end

            return TheGenericKV:GetKV("fuelweaver_killed") == "1"
        end,
        root = true,
        connects = {
            "wolfgang_allegiance_shadow",
        },
    },

    wolfgang_allegiance_lock_2 = {
        desc = STRINGS.SKILLTREE.ALLEGIANCE_LOCK_3_DESC,
        pos = { 200 + GAP / 2, Y },
        --pos = {0,-1},
        group = "allegiance",
        tags = { "allegiance", "lock" },
        lock_open = function(prefabname, activatedskills, readonly)
            if readonly then
                return "question"
            end

            return TheGenericKV:GetKV("celestialchampion_killed") == "1"
        end,
        root = true,
        connects = {
            "wolfgang_allegiance_lunar",
        },
    },

    wolfgang_allegiance_lock_3 = {
        desc = STRINGS.SKILLTREE.ALLEGIANCE_LOCK_4_DESC,
        pos = { 200 - GAP / 2, Y - GAP },
        --pos = {0,-1},
        group = "allegiance",
        tags = { "allegiance", "lock" },
        root = true,
        lock_open = function(prefabname, activatedskills, readonly)
            if SkillTreeDefs.FN.CountTags(prefabname, "lunar_favor", activatedskills) == 0 then
                return true
            end

            return nil -- Important to return nil and not false.
        end,
        connects = {
            "wolfgang_allegiance_shadow",
        },
    },

    wolfgang_allegiance_lock_4 = {
        desc = STRINGS.SKILLTREE.ALLEGIANCE_LOCK_5_DESC,
        pos = { 200 + GAP / 2, Y - GAP },
        --pos = {0,-1},
        group = "allegiance",
        tags = { "allegiance", "lock" },
        root = true,
        lock_open = function(prefabname, activatedskills, readonly)
            if SkillTreeDefs.FN.CountTags(prefabname, "shadow_favor", activatedskills) == 0 then
                return true
            end

            return nil -- Important to return nil and not false.
        end,
        connects = {
            "wolfgang_allegiance_lunar",
        },
    },

    wolfgang_allegiance_shadow = {
        title = STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_ALLEGIANCE_SHADOW_TITLE,
        desc = STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_ALLEGIANCE_SHADOW_DESC,
        icon = "wolfgang_allegiance_shadow_2",
        pos = { 200 - GAP / 2, Y - GAP * 2 },
        --pos = {0,-2},
        group = "allegiance",
        tags = { "allegiance", "shadow", "shadow_favor" },
        locks = { "wolfgang_allegiance_lock_1", "wolfgang_allegiance_lock_3" },
        onactivate = function(inst, fromload)
            inst:AddTag("player_shadow_aligned")
            inst:AddTag("shadow_mighty")
        end,
        ondeactivate = function(inst, fromload)
            inst:RemoveTag("player_shadow_aligned")
            inst:RemoveTag("shadow_mighty")
        end,
        connects = {
            "wolfgang_allegiance_shadow_mastery",
        },
    },

    wolfgang_allegiance_shadow_mastery = {
        title = STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_ALLEGIANCE_SHADOW_MASTERY_TITLE,
        desc = STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_ALLEGIANCE_SHADOW_MASTERY_DESC,
        icon = "wolfgang_allegiance_shadow_3",
        pos = { 200 - GAP / 2, Y - GAP * 4 },
        --pos = {0,-2},
        group = "allegiance",
        tags = { "allegiance", "shadow", "shadow_mastery" },
        onactivate = function(inst, fromload)
            inst:AddTag("shadow_strikes")
            inst.components.mightiness:BecomeState("mighty", true)
            inst.components.mightiness:BecomeState("shadow", true)
        end,
        ondeactivate = function(inst, fromload)
            inst:RemoveTag("shadow_strikes")
        end,
    },

    wolfgang_allegiance_lunar = {
        title = STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_ALLEGIANCE_LUNAR_TITLE,
        desc = STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_ALLEGIANCE_LUNAR_DESC,
        icon = "wolfgang_allegiance_lunar_2",
        pos = { 200 + GAP / 2, Y - GAP * 2 },
        --pos = {0,-2},
        group = "allegiance",
        tags = { "allegiance", "lunar", "lunar_favor" },
        locks = { "wolfgang_allegiance_lock_2", "wolfgang_allegiance_lock_4" },
        onactivate = function(inst, fromload)
            inst:AddTag("lunar_mighty")
            inst:AddTag("merm")
            inst:AddTag("mermdisguise")
            inst:AddTag("mermfluent")
            inst.components.sanity.no_moisture_penalty = true
        end,
        ondeactivate = function(inst, fromload)
            inst:RemoveTag("lunar_mighty")
            inst:RemoveTag("merm")
            inst:RemoveTag("mermdisguise")
            inst:RemoveTag("mermfluent")
            inst.components.sanity.no_moisture_penalty = false
        end,
        connects = {
            "wolfgang_allegiance_lunar_mastery",
        },
    },

    wolfgang_allegiance_lunar_mastery = {
        title = STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_ALLEGIANCE_LUNAR_MASTERY_TITLE,
        desc = STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_ALLEGIANCE_LUNAR_MASTERY_DESC,
        icon = "wolfgang_allegiance_lunar_3",
        pos = { 200 + GAP / 2, Y - GAP * 4 },
        --pos = {0,-2},
        group = "allegiance",
        tags = { "allegiance", "lunar", "lunar_mastery" },
        onactivate = function(inst, fromload)
            inst:AddTag("mighty_hunger")
            inst:AddTag("allow_action_on_impassable")
        end,
        ondeactivate = function(inst, fromload)
            inst:RemoveTag("mighty_hunger")
            inst:RemoveTag("allow_action_on_impassable")
        end,
    },
}
--[[
require("prefabs/skilltree_wolfgang")
local original = package.loaded["prefabs/skilltree_wolfgang"]
package.loaded["prefabs/skilltree_wolfgang"] = function(...)
    local BuildSkillsData = original(...)
    BuildSkillsData.SKILLS = skills
    BuildSkillsData.ORDERS = ORDERS
    return BuildSkillsData
end

local BuildSkillsData = require("prefabs/skilltree_wolfgang")
BuildSkillsData(SkillTreeDefs.FN)
]]

if SkillTreeDefs.SKILLTREE_DEFS["wolfgang"] ~= nil then --in case another mod turns it nil beforehand (disabling skill tree)
    SkillTreeDefs.SKILLTREE_DEFS["wolfgang"] = {}
    SkillTreeDefs.CreateSkillTreeFor("wolfgang", skills)
    SkillTreeDefs.SKILLTREE_ORDERS["wolfang"] = ORDERS
end
