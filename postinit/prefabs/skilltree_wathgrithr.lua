local env = env
GLOBAL.setfenv(1, GLOBAL)

local POS_Y_1 =  180
local POS_Y_2 = POS_Y_1 - 38
local POS_Y_3 = POS_Y_2 - 38
local POS_Y_4 = POS_Y_3 - 38
local POS_Y_5 = POS_Y_4 - 38

local ALLEGIANCE_POS_Y_1 = POS_Y_1
local ALLEGIANCE_POS_Y_2 = 141
local ALLEGIANCE_POS_Y_3 = ALLEGIANCE_POS_Y_2 - 45
local ALLEGIANCE_POS_Y_4 = ALLEGIANCE_POS_Y_3 - 53

local ARSENAL_SHIELD_Y_2 = POS_Y_5 - 15
local ARSENAL_SHIELD_Y_1 = (POS_Y_3 + ARSENAL_SHIELD_Y_2) * .5

local ARSENAL_UPGRADES_Y_1 = (POS_Y_2 + POS_Y_3) * .5
local ARSENAL_UPGRADES_Y_2 = ARSENAL_UPGRADES_Y_1 - 38

local COMBAT_POS_Y = POS_Y_5 - 3

--------------------------------------------------------------------------------------------------

local X_GAP = 68.5

local SONGS_POS_X_1 = -218
local SONGS_POS_X_2 = SONGS_POS_X_1 + 38

local ARSENAL_POS_X_1 = SONGS_POS_X_2 + X_GAP - 2
local ARSENAL_POS_X_2 = ARSENAL_POS_X_1 + 57
local ARSENAL_POS_X_3 = ARSENAL_POS_X_2 + 40
local ARSENAL_POS_X_4 = ARSENAL_POS_X_3 + 57

local ARSENAL_POS_X_MIDDLE = (ARSENAL_POS_X_2 + ARSENAL_POS_X_3) * .5

local BEEFALO_POS_X = ARSENAL_POS_X_4 + X_GAP -2

local COMBAT_POS_X = SONGS_POS_X_1 + 22

local ALLEGIANCE_LOCK_X = 202
local ALLEGIANCE_SHADOW_X = ALLEGIANCE_LOCK_X - 24
local ALLEGIANCE_LUNAR_X  = ALLEGIANCE_LOCK_X + 23

--------------------------------------------------------------------------------------------------

local ARSENAL_TITLE_X   = ARSENAL_POS_X_MIDDLE
local BEEFALO_TITLE_X   = BEEFALO_POS_X
local SONGS_TITLE_X     = COMBAT_POS_X --(SONGS_POS_X_1 + SONGS_POS_X_2) * .5
local COMBAT_TITLE_X    = COMBAT_POS_X
local ALLEGIANCE_TILE_X = ALLEGIANCE_LOCK_X

--------------------------------------------------------------------------------------------------

local TITLE_Y = POS_Y_1 + 30
local TITLE_Y_2 = POS_Y_4 - 20

--------------------------------------------------------------------------------------------------


local POSITIONS =
{
    wathgrithr_arsenal_spear_1 =                { x = ARSENAL_POS_X_2, y = POS_Y_1 },
    wathgrithr_arsenal_spear_2 =                { x = ARSENAL_POS_X_2, y = POS_Y_2 },
    wathgrithr_arsenal_spear_3 =                { x = ARSENAL_POS_X_2, y = POS_Y_3 },
    wathgrithr_arsenal_spear_4 =                { x = ARSENAL_POS_X_1, y = ARSENAL_UPGRADES_Y_1 },
    wathgrithr_arsenal_spear_5 =                { x = ARSENAL_POS_X_1, y = ARSENAL_UPGRADES_Y_2 },

    wathgrithr_arsenal_helmet_1 =               { x = ARSENAL_POS_X_3, y = POS_Y_1 },
    wathgrithr_arsenal_helmet_2 =               { x = ARSENAL_POS_X_3, y = POS_Y_2 },
    wathgrithr_arsenal_helmet_3 =               { x = ARSENAL_POS_X_3, y = POS_Y_3 },
    wathgrithr_arsenal_helmet_4 =               { x = ARSENAL_POS_X_4, y = ARSENAL_UPGRADES_Y_1 },
    wathgrithr_arsenal_helmet_5 =               { x = ARSENAL_POS_X_4, y = ARSENAL_UPGRADES_Y_2 },

    wathgrithr_arsenal_shield_1 =               { x = ARSENAL_POS_X_MIDDLE, y = ARSENAL_SHIELD_Y_1 },
    wathgrithr_arsenal_shield_2 =               { x = ARSENAL_POS_X_2, y = ARSENAL_SHIELD_Y_2 },
    wathgrithr_arsenal_shield_3 =               { x = ARSENAL_POS_X_3, y = ARSENAL_SHIELD_Y_2 },

    wathgrithr_beefalo_1 =                      { x = BEEFALO_POS_X, y = POS_Y_1 },
    wathgrithr_beefalo_2 =                      { x = BEEFALO_POS_X, y = POS_Y_2 },
    wathgrithr_beefalo_3 =                      { x = BEEFALO_POS_X, y = POS_Y_4 }, --{ x = BEEFALO_POS_X, y = POS_Y_3 },
    wathgrithr_beefalo_saddle =                 { x = BEEFALO_POS_X, y = POS_Y_3 }, --{ x = BEEFALO_POS_X, y = POS_Y_4 },

    wathgrithr_songs_instantsong_cd_lock =      { x = SONGS_POS_X_1, y = POS_Y_1 },
    wathgrithr_songs_instantsong_cd =           { x = SONGS_POS_X_2, y = POS_Y_1 },

    wathgrithr_songs_container_lock =           { x = SONGS_POS_X_1, y = POS_Y_2 },
    wathgrithr_songs_container =                { x = SONGS_POS_X_2, y = POS_Y_2 },

    wathgrithr_songs_revivewarrior_lock =       { x = SONGS_POS_X_1, y = POS_Y_3 },
    wathgrithr_songs_revivewarrior =            { x = SONGS_POS_X_2, y = POS_Y_3 },

    wathgrithr_combat_defense =                 { x = COMBAT_POS_X, y = COMBAT_POS_Y},

    wathgrithr_allegiance_lock_1 =              { x = ALLEGIANCE_LOCK_X, y = POS_Y_1 },
    wathgrithr_allegiance_lunar =               { x = ALLEGIANCE_LUNAR_X, y = ALLEGIANCE_POS_Y_4 },
    wathgrithr_allegiance_shadow =              { x = ALLEGIANCE_SHADOW_X, y = ALLEGIANCE_POS_Y_4 },
}

--------------------------------------------------------------------------------------------------

local WATHGRITHR_SKILL_STRINGS = STRINGS.SKILLTREE.WATHGRITHR

--------------------------------------------------------------------------------------------------


local function CreateAddTagFn(tag)
    return function(inst) inst:AddTag(tag) end
end

local function CreateRemoveTagFn(tag)
    return function(inst) inst:RemoveTag(tag) end
end

local function UpdateInspirationBadge(inst)

    local userid = TheNet:GetUserID()

    --[[if inst:HasTag("player_shadow_aligned") == true and inst:HasTag("beefaloinspiration") == false then
        SendModRPCToClient(GetClientModRPC("InspirationBadgeRPC", "HideBadge"),userid)
    else
        SendModRPCToClient(GetClientModRPC("InspirationBadgeRPC", "ShowBadge"),userid)
    end]]

end

local SkillTreeDefs = require("prefabs/skilltree_defs")

--------------------------------------------------------------------------------------------------


local ONACTIVATE_FNS = {
    CombatDefense = function(inst)
        if inst.components.planardefense ~= nil then
            inst.components.planardefense:AddBonus(inst, TUNING.SKILLS.WATHGRITHR.BONUS_PLANAR_DEF, "wathgrithr_combat_defense")
        end
    end,

    Beefalo = function(inst)
        if inst.components.rider ~= nil and inst.components.rider:IsRiding() then
            inst._riding_music:push()
        end
    end,

    BeefaloInspiration = function(inst)
        inst:AddTag("beefaloinspiration")
        UpdateInspirationBadge(inst)
    end,

    AllegianceShadow = function(inst)
        inst:AddTag("player_shadow_aligned")
        --inst:AddTag("battlesongshadowalignedmaker")

        --[[
        if inst.components.damagetyperesist ~= nil then
            inst.components.damagetyperesist:AddResist("shadow_aligned", inst, TUNING.SKILLS.WATHGRITHR.ALLEGIANCE_SHADOW_RESIST, "allegiance_shadow")
        end

        if inst.components.damagetypebonus ~= nil then
            inst.components.damagetypebonus:AddBonus("lunar_aligned", inst, TUNING.SKILLS.WATHGRITHR.ALLEGIANCE_VS_LUNAR_BONUS, "allegiance_shadow")
        end
        ]]

        if inst.components.singinginspiration ~= nil then
            inst.components.singinginspiration.gainratemultipliers:SetModifier(inst, TUNING.DSTU.WATHGRITHR_SHADOW_INSPIRATION_GAIN_MULT, "allegiance_shadow")
            inst.components.singinginspiration.buffertimemultipliers:SetModifier(inst, TUNING.DSTU.WATHGRITHR_SHADOW_INSPIRATION_BUFFER_MULT, "allegiance_shadow")
            inst.components.singinginspiration.drainratemultipliers:SetModifier(inst, TUNING.DSTU.WATHGRITHR_SHADOW_INSPIRATION_DRAIN_MULT, "allegiance_shadow")
        end

        if inst.components.battleborn ~= nil then
			inst.components.battleborn:SetClampMin(0.33 * TUNING.DSTU.WATHGRITHR_SHADOW_BATTLEBORN_CLAMP_MULT)
			inst.components.battleborn:SetClampMax(2 * TUNING.DSTU.WATHGRITHR_SHADOW_BATTLEBORN_CLAMP_MULT)
            inst.components.battleborn:SetBattlebornBonus(0.25 * TUNING.DSTU.WATHGRITHR_SHADOW_BATTLEBORN_BONUS_MULT)
		end

        if inst.components.hunger ~= nil then
            inst.components.hunger:SetRate(TUNING.WILSON_HUNGER_RATE * TUNING.DSTU.WATHGRITHR_SHADOW_HUNGER_MULT)
        end

        if inst.components.hunger ~= nil then
            inst.components.health:SetMaxHealth(TUNING.WATHGRITHR_HEALTH * TUNING.DSTU.WATHGRITHR_MAXHEALTH_MULT)
        end

        UpdateInspirationBadge(inst)
    end,

    AllegianceLunar = function(inst)
        inst:AddTag("player_lunar_aligned")
        inst:AddTag("lunar_improved_songs")
        --inst:AddTag("battlesonglunaralignedmaker")

        --[[
        if inst.components.damagetyperesist ~= nil then
            inst.components.damagetyperesist:AddResist("lunar_aligned", inst, TUNING.SKILLS.WATHGRITHR.ALLEGIANCE_LUNAR_RESIST, "allegiance_lunar")
        end

        if inst.components.damagetypebonus ~= nil then
            inst.components.damagetypebonus:AddBonus("shadow_aligned", inst, TUNING.SKILLS.WATHGRITHR.ALLEGIANCE_VS_SHADOW_BONUS, "allegiance_lunar")
        end
        ]]

        if inst.components.singinginspiration ~= nil then
            inst.components.singinginspiration.gainratemultipliers:SetModifier(inst, TUNING.DSTU.WATHGRITHR_LUNAR_INSPIRATION_GAIN_MULT, "allegiance_lunar")
            inst.components.singinginspiration.buffertimemultipliers:SetModifier(inst, TUNING.DSTU.WATHGRITHR_LUNAR_INSPIRATION_BUFFER_MULT, "allegiance_lunar")
            inst.components.singinginspiration.drainratemultipliers:SetModifier(inst, TUNING.DSTU.WATHGRITHR_LUNAR_INSPIRATION_DRAIN_MULT, "allegiance_lunar")
        end

        if inst.components.battleborn ~= nil then
			--inst.components.battleborn:SetClampMin(0.33 * TUNING.WATHGRITHR_LUNAR_BATTLEBORN_MULT)
			--inst.components.battleborn:SetClampMax(2 * TUNING.WATHGRITHR_LUNAR_BATTLEBORN_MULT)
            --inst.components.battleborn:SetBattlebornBonus(0.25 * TUNING.WATHGRITHR_LUNAR_BATTLEBORN_MULT)
            --inst.components.battleborn:SetBattlebornBonus(0.25 * TUNING.WATHGRITHR_LUNAR_BATTLEBORN_MULT)

            inst.components.battleborn:SetHealthEnabled(false)
            inst.components.battleborn:SetSanityEnabled(false)
		end

    end,
}

local ONDEACTIVATE_FNS = {
    ArsenalSpear = function(inst)
        local item = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)

        if item ~= nil and item:HasTag("battlespear") then
            item:RemoveSkillsChanges(inst)
        end
    end,

    ArsenalHelm = function (inst)
        local item = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)

        if item ~= nil and item:HasTag("battlehelm") then
            item:RemoveSkillsChanges(inst)
        end
    end,

    CombatDefense = function(inst)
        if inst.components.planardefense ~= nil then
            inst.components.planardefense:RemoveBonus(inst, "wathgrithr_combat_defense")
        end
    end,

    AllegianceShadow = function(inst)
        inst:RemoveTag("player_shadow_aligned")
        --inst:RemoveTag("battlesongshadowalignedmaker")

        --[[
        if inst.components.damagetyperesist ~= nil then
            inst.components.damagetyperesist:RemoveResist("shadow_aligned", inst, "allegiance_shadow")
        end

        if inst.components.damagetypebonus ~= nil then
            inst.components.damagetypebonus:RemoveBonus("lunar_aligned", inst, "allegiance_shadow")
        end
        ]]

        if inst.components.singinginspiration ~= nil then
            inst.components.singinginspiration.gainratemultipliers:RemoveModifier(inst, "allegiance_shadow")
            inst.components.singinginspiration.buffertimemultipliers:RemoveModifier(inst, "allegiance_shadow")
            inst.components.singinginspiration.drainratemultipliers:RemoveModifier(inst, "allegiance_shadow")
        end

        if inst.components.battleborn ~= nil then
			inst.components.battleborn:SetClampMin(0.33 * TUNING.DSTU.WATHGRITHR_BASE_BATTLEBORN_CLAMP_MULT)
			inst.components.battleborn:SetClampMax(2 * TUNING.DSTU.WATHGRITHR_BASE_BATTLEBORN_CLAMP_MULT)
            inst.components.battleborn:SetBattlebornBonus(0.25 * TUNING.DSTU.WATHGRITHR_BASE_BATTLEBORN_BONUS_MULT)
		end

        if inst.components.hunger ~= nil then
            inst.components.hunger:SetRate(TUNING.WILSON_HUNGER_RATE)
        end

        if inst.components.hunger ~= nil then
            inst.components.health:SetMaxHealth(TUNING.WATHGRITHR_HEALTH)
        end

        UpdateInspirationBadge()

    end,

    AllegianceLunar = function(inst)
        inst:RemoveTag("player_lunar_aligned")
        inst:RemoveTag("lunar_improved_songs")
        --inst:RemoveTag("battlesonglunaralignedmaker")

        --[[
        if inst.components.damagetyperesist ~= nil then
            inst.components.damagetyperesist:RemoveResist("lunar_aligned", inst, "allegiance_lunar")
        end

        if inst.components.damagetypebonus ~= nil then
            inst.components.damagetypebonus:RemoveBonus("shadow_aligned", inst, "allegiance_lunar")
        end
        ]]

        if inst.components.singinginspiration ~= nil then
            inst.components.singinginspiration.gainratemultipliers:RemoveModifier(inst, "allegiance_lunar")
            inst.components.singinginspiration.buffertimemultipliers:RemoveModifier(inst, "allegiance_lunar")
            inst.components.singinginspiration.drainratemultipliers:RemoveModifier(inst, "allegiance_lunar")
        end

        if inst.components.battleborn ~= nil then
			--inst.components.battleborn:SetClampMin(0.33 * TUNING.DSTU.WATHGRITHR_BASE_BATTLEBORN_CLAMP_MULT)
			--inst.components.battleborn:SetClampMax(2 * TUNING.DSTU.WATHGRITHR_BASE_BATTLEBORN_CLAMP_MULT)
            --inst.components.battleborn:SetBattlebornBonus(0.25 * TUNING.DSTU.WATHGRITHR_BASE_BATTLEBORN_BONUS_MULT)

            inst.components.battleborn:SetHealthEnabled(true)
            inst.components.battleborn:SetSanityEnabled(true)
        end
    end,
}

--------------------------------------------------------------------------------------------------


local ORDERS =
{
    {"songs",      { SONGS_TITLE_X,      TITLE_Y }},
    {"beefalo",    { BEEFALO_TITLE_X,    TITLE_Y   }},
    {"arsenal",    { ARSENAL_TITLE_X,    TITLE_Y   }},
    {"combat",     { COMBAT_TITLE_X,     TITLE_Y_2 }},
    {"allegiance", { ALLEGIANCE_TILE_X , TITLE_Y   }},
}

--------------------------------------------------------------------------------------------------


local skills =
{
    -- Inspiration gain rate will increase a little when attacking using Battle Spears.
    wathgrithr_arsenal_spear_1 = {
        group = "arsenal",
        tags = { "spear", "spearcondition" },

        root = true,
        connects = { "wathgrithr_arsenal_spear_2" },

        onactivate   = ONACTIVATE_FNS.ArsenalSpear,
        ondeactivate = ONDEACTIVATE_FNS.ArsenalSpear,
    },

    -- Inspiration gain rate will increase a fair amount when attacking using Battle Spears.
    wathgrithr_arsenal_spear_2 = {
        group = "arsenal",
        tags = { "spear", "spearcondition" },

        --connects = { "wathgrithr_arsenal_spear_3" },

        onactivate   = ONACTIVATE_FNS.ArsenalSpear,
        ondeactivate = ONDEACTIVATE_FNS.ArsenalSpear,
    },

    -- Learn to craft the Lightning Spear.
    wathgrithr_arsenal_spear_3 = {
        group = "arsenal",
        tags = { "spear" },
        
        root = true,
        connects = {
            "wathgrithr_arsenal_spear_4",
            "wathgrithr_arsenal_spear_5",

            --"wathgrithr_arsenal_shield_1",
        },

        onactivate   = CreateAddTagFn("spearwathgrithrlightningmaker"),
        ondeactivate = CreateRemoveTagFn("spearwathgrithrlightningmaker"),
    },

    -- The Lightning Spear can now perform a special attack.\nThis attack repairs Charged Lightning Spears if it hits a target.
    wathgrithr_arsenal_spear_4 = {
        group = "arsenal",
        tags = { "spear" },

        onactivate   = ONACTIVATE_FNS.ArsenalSpear,
        ondeactivate = ONDEACTIVATE_FNS.ArsenalSpear,
    },

    -- Upgrade the Lightning Spear using Restrained Static to deal +20 Planar Damage.
    wathgrithr_arsenal_spear_5 = {
        group = "arsenal",
        tags = { "spear" },

        onactivate   = CreateAddTagFn(UPGRADETYPES.SPEAR_LIGHTNING.."_upgradeuser"),
        ondeactivate = CreateRemoveTagFn(UPGRADETYPES.SPEAR_LIGHTNING.."_upgradeuser"),
    },

    --------------------------------------------------------------------------

    -- Battle Helms will be a little more durable when worn by Wigfrid.
    wathgrithr_arsenal_helmet_1 = {
        group = "arsenal",
        tags = { "helmet", "helmetcondition" },

        root = true,
        connects = { "wathgrithr_arsenal_helmet_2" },

        onactivate = ONACTIVATE_FNS.ArsenalHelm,
        ondeactivate = ONDEACTIVATE_FNS.ArsenalHelm,
    },

    -- Battle Helms will be a fair amount more durable when worn by Wigfrid.
    wathgrithr_arsenal_helmet_2 = {
        group = "arsenal",
        tags = { "helmet", "helmetcondition" },

        --connects = { "wathgrithr_arsenal_helmet_3" },

        onactivate = ONACTIVATE_FNS.ArsenalHelm,
        ondeactivate = ONDEACTIVATE_FNS.ArsenalHelm,
    },

    -- Learn to craft the Commander's Helm: a helm that protects against knockback attacks.
    wathgrithr_arsenal_helmet_3 = {
        group = "arsenal",
        tags = { "helmet" },

        root = true,
        connects = {
            "wathgrithr_arsenal_helmet_4",
            "wathgrithr_arsenal_helmet_5",

            --"wathgrithr_arsenal_shield_1",
        },

        onactivate   = CreateAddTagFn("wathgrithrimprovedhatmaker"),
        ondeactivate = CreateRemoveTagFn("wathgrithrimprovedhatmaker"),
    },

    -- The Commander's Helm now has protection against planar damage.
    wathgrithr_arsenal_helmet_4 = {
        group = "arsenal",
        tags = { "helmet" },

        onactivate = ONACTIVATE_FNS.ArsenalHelm,
        ondeactivate = ONDEACTIVATE_FNS.ArsenalHelm,
    },

    -- Wigfrid's natural healing ability will repair her Commander's Helm when she continues to fight at maximum health.
    wathgrithr_arsenal_helmet_5 = {
        group = "arsenal",
        tags = { "helmet" },

        onactivate = ONACTIVATE_FNS.ArsenalHelm,
        ondeactivate = ONDEACTIVATE_FNS.ArsenalHelm,
    },

    --------------------------------------------------------------------------

    -- Learn to craft the Battle Rönd. This shield can be used to attack, block attacks, and provide extra protection while equipped.
    wathgrithr_arsenal_shield_1 = {
        group = "arsenal",
        tags = { "shield"},
        root = true,

        connects = {
            "wathgrithr_arsenal_shield_2",
            "wathgrithr_arsenal_shield_3",
        },

        onactivate   = CreateAddTagFn("wathgrithrshieldmaker"),
        ondeactivate = CreateRemoveTagFn("wathgrithrshieldmaker"),
    },

    -- The duration of the Battle Rönd's ability to block attacks will be increased.
    wathgrithr_arsenal_shield_2 = {
        group = "arsenal",
        tags = { "shield", "parryefficiency"},
    },

    -- After blocking an attack with the Battle Rönd, your next attack within 5 seconds will deal +10 damage.
    wathgrithr_arsenal_shield_3 = {
        group = "arsenal",
        tags = { "shield", "parryefficiency"},
    },

    --------------------------------------------------------------------------

    -- Beefalos will be domesticated 15% faster.
    wathgrithr_beefalo_1 = {
        group = "beefalo",
        tags = { "beefalodomestication", "beefalobucktime" },

        root = true,
        connects = { "wathgrithr_beefalo_2" },

        onactivate = ONACTIVATE_FNS.Beefalo,
    },

    -- Beefalos will allow you to ride them for 30% longer.
    wathgrithr_beefalo_2 = {
        group = "beefalo",
        tags = { "beefaloinspiration" },

        connects = { "wathgrithr_beefalo_saddle" },

        onactivate = ONACTIVATE_FNS.BeefaloInspiration,
    },
    -- Learn to craft a new Beefalo Saddle that protects your beefalo.
    wathgrithr_beefalo_saddle = {
        group = "beefalo",
        tags = { "saddle" },

        onactivate   = CreateAddTagFn("saddlewathgrithrmaker"),
        ondeactivate = CreateRemoveTagFn("saddlewathgrithrmaker"),

        connects = { "wathgrithr_beefalo_3" },
    },

        -- Riding a beefalo will make your inspiration slowly rise until it reaches the halfway mark.
        wathgrithr_beefalo_3 = {
            group = "beefalo",
            tags = { "wathgrithr_beefalo_damage" },
        },

    --------------------------------------------------------------------------

    --[[
    -- Sing quote battle songs 10 times to unlock.
    wathgrithr_songs_instantsong_cd_lock = {
        group = "songs",

        root = true,
        connects = { "wathgrithr_songs_instantsong_cd" },

        lock_open = CreateAccomplishmentCountLockFn("wathgrithr_instantsong_uses", TUNING.SKILLS.WATHGRITHR.INSTANTSONG_CD_UNLOCK_COUNT),
    },
    ]]

    wathgrithr_songs_instantsong_cd_lock = {
        group = "songs",

        root = true,
        connects = { "wathgrithr_songs_instantsong_cd" },

        lock_open = function(prefabname, activatedskills, readonly)
            return  SkillTreeDefs.FN.CountTags(prefabname, "shadow_favor", activatedskills) == 0
        end,
    },

    -- Quote battle songs now no longer consume Inspiration, and instead have a cooldown.
    wathgrithr_songs_instantsong_cd = {
        group = "songs",
    },

    --[[
    -- Have 6 different battle songs in your inventory.
    wathgrithr_songs_container_lock = {
        group = "songs",

        root = true,
        connects = { "wathgrithr_songs_container" },

        lock_open = CreateAccomplishmentLockFn("wathgrithr_container_unlocked"),
    },
    ]]

    wathgrithr_songs_container_lock = {
        group = "songs",

        root = true,
        connects = { "wathgrithr_songs_container" },

        lock_open = function(prefabname, activatedskills, readonly)
            return  SkillTreeDefs.FN.CountTags(prefabname, "shadow_favor", activatedskills) == 0
        end,
    },

    -- Quote battle songs now no longer consume Inspiration, and instead have a cooldown.
    wathgrithr_songs_container = {
        group = "songs",
        --root = true,

        onactivate   = CreateAddTagFn("battlesongcontainermaker"),
        ondeactivate = CreateRemoveTagFn("battlesongcontainermaker"),
    },

    --[[
    -- Play a Beefalo Horn to unlock.
    wathgrithr_songs_revivewarrior_lock = {
        group = "songs",

        root = true,
        connects = { "wathgrithr_songs_revivewarrior" },

        lock_open = CreateAccomplishmentLockFn("wathgrithr_horn_played"),
    },
    ]]

    wathgrithr_songs_revivewarrior_lock = {
        group = "songs",

        root = true,
        connects = { "wathgrithr_songs_revivewarrior" },

        lock_open = function(prefabname, activatedskills, readonly)
            return  SkillTreeDefs.FN.CountTags(prefabname, "shadow_favor", activatedskills) == 0
        end,
    },

    -- Learn to craft the Warrior's Reprise: Bring your allies back to life so they can fight for Valhalla.
    wathgrithr_songs_revivewarrior = {
        group = "songs",

        onactivate   = CreateAddTagFn("battlesonginstantrevivemaker"),
        ondeactivate = CreateRemoveTagFn("battlesonginstantrevivemaker"),
    },

    --------------------------------------------------------------------------

    -- Receive a divine blessing that will provide you with +10 Planar Defense.
    wathgrithr_combat_defense = {
        group = "combat",
        root = true,

        onactivate = ONACTIVATE_FNS.CombatDefense,
        ondeactivate = ONDEACTIVATE_FNS.CombatDefense,
    },

    --------------------------------------------------------------------------

    wathgrithr_allegiance_lock_1 = {
        group = "allegiance",

        root = true,
        
        lock_open = function(prefabname, activatedskills, readonly)
            return SkillTreeDefs.FN.CountSkills(prefabname, activatedskills) == 0 or 
            SkillTreeDefs.FN.CountTags(prefabname, "lunar_favor", activatedskills) > 0 or 
            SkillTreeDefs.FN.CountTags(prefabname, "shadow_favor", activatedskills) > 0
        end,
    },

    wathgrithr_allegiance_shadow_lock_1 = SkillTreeDefs.FN.MakeFuelWeaverLock({ pos = {ALLEGIANCE_SHADOW_X, ALLEGIANCE_POS_Y_2} }),
    wathgrithr_allegiance_shadow_lock_2 = SkillTreeDefs.FN.MakeNoLunarLock({ pos = {ALLEGIANCE_SHADOW_X, ALLEGIANCE_POS_Y_3} }),
    wathgrithr_allegiance_lunar_lock_1  = SkillTreeDefs.FN.MakeCelestialChampionLock({ pos = {ALLEGIANCE_LUNAR_X, ALLEGIANCE_POS_Y_2} }), 
    wathgrithr_allegiance_lunar_lock_2  = SkillTreeDefs.FN.MakeNoShadowLock({ pos = {ALLEGIANCE_LUNAR_X, ALLEGIANCE_POS_Y_3} }),



    -- Learn to craft the Dark Lament: Allies will take less damage from shadow aligned enemies and will give bonus damage to lunar aligned enemies.
    wathgrithr_allegiance_shadow = {
        group = "allegiance",
        tags = { "shadow", "shadow_favor" },

        locks = { "wathgrithr_allegiance_lock_1", "wathgrithr_allegiance_shadow_lock_1", "wathgrithr_allegiance_shadow_lock_2" },

        onactivate = ONACTIVATE_FNS.AllegianceShadow,
        ondeactivate = ONDEACTIVATE_FNS.AllegianceShadow,
    },

    -- Learn to craft the Enlightened Lullaby: Allies will take less damage from lunar aligned enemies and will give bonus damage to shadow aligned enemies.
    wathgrithr_allegiance_lunar = {
        group = "allegiance",
        tags = { "lunar", "lunar_favor" },

        locks = { "wathgrithr_allegiance_lock_1", "wathgrithr_allegiance_lunar_lock_1", "wathgrithr_allegiance_lunar_lock_2" },

        onactivate = ONACTIVATE_FNS.AllegianceLunar,
        ondeactivate = ONDEACTIVATE_FNS.AllegianceLunar,
    },
}

for name, data in pairs(skills) do
    local uppercase_name = string.upper(name)

    data.tags = data.tags or {}

    local pos = POSITIONS[name]

    data.pos = pos ~= nil and { pos.x, pos.y } or data.pos

    if not table.contains(data.tags, data.group) then
        table.insert(data.tags, data.group)
    end

    data.desc = data.desc or WATHGRITHR_SKILL_STRINGS[uppercase_name.."_DESC"]

    -- If it's not a lock.
    if not data.lock_open then
        data.title = data.title or WATHGRITHR_SKILL_STRINGS[uppercase_name.."_TITLE"]
        data.icon = data.icon or name

    elseif not table.contains(data.tags, "lock") then
        table.insert(data.tags, "lock")
    end
end

SkillTreeDefs.SKILLTREE_DEFS["wathgrithr"] = {}
SkillTreeDefs.CreateSkillTreeFor("wathgrithr", skills)
SkillTreeDefs.SKILLTREE_ORDERS["wathgrithr"] = ORDERS

----------------------------------------------------------------------------------------------------------------------------------------------------
--
-- STRINGS
--
----------------------------------------------------------------------------------------------------------------------------------------------------


	--------------------------------------------------------------------------
	-- SONGS
	--------------------------------------------------------------------------

	STRINGS.SKILLTREE.WATHGRITHR.WATHGRITHR_SONGS_REVIVEWARRIOR_LOCK_DESC = "Have no shadow affinity."
	SkillTreeDefs.SKILLTREE_DEFS["wathgrithr"].wathgrithr_songs_revivewarrior_lock.desc = STRINGS.SKILLTREE.WATHGRITHR.WATHGRITHR_SONGS_REVIVEWARRIOR_LOCK_DESC
	STRINGS.SKILLTREE.WATHGRITHR.WATHGRITHR_SONGS_CONTAINER_LOCK_DESC = "Have no shadow affinity."
    SkillTreeDefs.SKILLTREE_DEFS["wathgrithr"].wathgrithr_songs_container_lock.desc = STRINGS.SKILLTREE.WATHGRITHR.WATHGRITHR_SONGS_CONTAINER_LOCK_DESC
	STRINGS.SKILLTREE.WATHGRITHR.WATHGRITHR_SONGS_INSTANTSONG_CD_LOCK_DESC = "Have no shadow affinity."
    SkillTreeDefs.SKILLTREE_DEFS["wathgrithr"].wathgrithr_songs_instantsong_cd_lock.desc = STRINGS.SKILLTREE.WATHGRITHR.WATHGRITHR_SONGS_INSTANTSONG_CD_LOCK_DESC


	--------------------------------------------------------------------------
	-- ARSENAL
	--------------------------------------------------------------------------

    -- SPEAR

	STRINGS.SKILLTREE.WATHGRITHR.WATHGRITHR_ARSENAL_SPEAR_1_TITLE = "Sturdy Spear I"
	SkillTreeDefs.SKILLTREE_DEFS["wathgrithr"].wathgrithr_arsenal_spear_1.title = STRINGS.SKILLTREE.WATHGRITHR.WATHGRITHR_ARSENAL_SPEAR_1_TITLE
	STRINGS.SKILLTREE.WATHGRITHR.WATHGRITHR_ARSENAL_SPEAR_1_DESC = "Combat Spears are 10% more durable when used by Wigfrid."
	SkillTreeDefs.SKILLTREE_DEFS["wathgrithr"].wathgrithr_arsenal_spear_1.desc = STRINGS.SKILLTREE.WATHGRITHR.WATHGRITHR_ARSENAL_SPEAR_1_DESC

	STRINGS.SKILLTREE.WATHGRITHR.WATHGRITHR_ARSENAL_SPEAR_2_TITLE = "Sturdy Spear II"
	SkillTreeDefs.SKILLTREE_DEFS["wathgrithr"].wathgrithr_arsenal_spear_2.title = STRINGS.SKILLTREE.WATHGRITHR.WATHGRITHR_ARSENAL_SPEAR_2_TITLE
	STRINGS.SKILLTREE.WATHGRITHR.WATHGRITHR_ARSENAL_SPEAR_2_DESC = "Combat Spears are 20% more durable when used by Wigfrid."
	SkillTreeDefs.SKILLTREE_DEFS["wathgrithr"].wathgrithr_arsenal_spear_2.desc = STRINGS.SKILLTREE.WATHGRITHR.WATHGRITHR_ARSENAL_SPEAR_2_DESC

    -- ELDIN SPEAR

    STRINGS.SKILLTREE.WATHGRITHR.WATHGRITHR_ARSENAL_SPEAR_3_DESC = "Learn to craft the Elding Spear: an electrical weapon that does more damage to wet targets.\nIt can be recharged like other Uncomp. electrical weapons."
	SkillTreeDefs.SKILLTREE_DEFS["wathgrithr"].wathgrithr_arsenal_spear_3.desc = STRINGS.SKILLTREE.WATHGRITHR.WATHGRITHR_ARSENAL_SPEAR_3_DESC

	STRINGS.SKILLTREE.WATHGRITHR.WATHGRITHR_ARSENAL_SPEAR_4_DESC = "The Elding Spear can perform a special attack.\nThis attack will consume additional durability per mob hit up to a limit."
    SkillTreeDefs.SKILLTREE_DEFS["wathgrithr"].wathgrithr_arsenal_spear_4.desc = STRINGS.SKILLTREE.WATHGRITHR.WATHGRITHR_ARSENAL_SPEAR_4_DESC

    STRINGS.SKILLTREE.WATHGRITHR.WATHGRITHR_ARSENAL_SPEAR_5_DESC = "Upgrade the Elding Spear using Restrained Static to deal +20 Planar Damage."
    SkillTreeDefs.SKILLTREE_DEFS["wathgrithr"].wathgrithr_arsenal_spear_5.desc = STRINGS.SKILLTREE.WATHGRITHR.WATHGRITHR_ARSENAL_SPEAR_5_DESC

    -- HELMET

	STRINGS.SKILLTREE.WATHGRITHR.WATHGRITHR_ARSENAL_HELMET_1_DESC = "Battle Helms are 10% more durable when worn by Wigfrid."
	SkillTreeDefs.SKILLTREE_DEFS["wathgrithr"].wathgrithr_arsenal_helmet_1.desc = STRINGS.SKILLTREE.WATHGRITHR.WATHGRITHR_ARSENAL_HELMET_1_DESC
	STRINGS.SKILLTREE.WATHGRITHR.WATHGRITHR_ARSENAL_HELMET_2_DESC = "Battle Helms are 20% more durable when worn by Wigfrid."
	SkillTreeDefs.SKILLTREE_DEFS["wathgrithr"].wathgrithr_arsenal_helmet_2.desc = STRINGS.SKILLTREE.WATHGRITHR.WATHGRITHR_ARSENAL_HELMET_2_DESC

	STRINGS.SKILLTREE.WATHGRITHR.WATHGRITHR_ARSENAL_HELMET_5_DESC = "Fighting will repair the Commander's Helm no matter your health.\n This effect ignores your lifeasteal multipliers."
	SkillTreeDefs.SKILLTREE_DEFS["wathgrithr"].wathgrithr_arsenal_helmet_5.desc = STRINGS.SKILLTREE.WATHGRITHR.WATHGRITHR_ARSENAL_HELMET_5_DESC

    -- SHIELD

	STRINGS.SKILLTREE.WATHGRITHR.WATHGRITHR_ARSENAL_SHIELD_1_DESC = "Learn to craft the Battle Rönd.\n Blocking attacks will consume durability by 60% of the damage taken."
	SkillTreeDefs.SKILLTREE_DEFS["wathgrithr"].wathgrithr_arsenal_shield_1.desc = STRINGS.SKILLTREE.WATHGRITHR.WATHGRITHR_ARSENAL_SHIELD_1_DESC
	STRINGS.SKILLTREE.WATHGRITHR.WATHGRITHR_ARSENAL_SHIELD_2_DESC = "Block duration increased.\n Lose 20% less durability on block."
	SkillTreeDefs.SKILLTREE_DEFS["wathgrithr"].wathgrithr_arsenal_shield_2.desc = STRINGS.SKILLTREE.WATHGRITHR.WATHGRITHR_ARSENAL_SHIELD_2_DESC
	STRINGS.SKILLTREE.WATHGRITHR.WATHGRITHR_ARSENAL_SHIELD_3_DESC = "Blocking increases damage on the next attack.\n Lose 20% less durability on block"
	SkillTreeDefs.SKILLTREE_DEFS["wathgrithr"].wathgrithr_arsenal_shield_3.desc = STRINGS.SKILLTREE.WATHGRITHR.WATHGRITHR_ARSENAL_SHIELD_3_DESC

    --------------------------------------------------------------------------
	-- BEEFALO
	--------------------------------------------------------------------------

	STRINGS.SKILLTREE.WATHGRITHR.WATHGRITHR_BEEFALO_1_DESC = "Beefalos will be domesticated 15% faster and ridden 30% longer."
	SkillTreeDefs.SKILLTREE_DEFS["wathgrithr"].wathgrithr_beefalo_1.desc = STRINGS.SKILLTREE.WATHGRITHR.WATHGRITHR_BEEFALO_1_DESC
	STRINGS.SKILLTREE.WATHGRITHR.WATHGRITHR_BEEFALO_2_DESC = "Riding a beefalo will make your inspiration slowly rise until it reaches the halfway mark."
	SkillTreeDefs.SKILLTREE_DEFS["wathgrithr"].wathgrithr_beefalo_2.desc = STRINGS.SKILLTREE.WATHGRITHR.WATHGRITHR_BEEFALO_2_DESC
	STRINGS.SKILLTREE.WATHGRITHR.WATHGRITHR_BEEFALO_3_DESC = "Wigfrid's damage multiplier applies to beefalos."
	SkillTreeDefs.SKILLTREE_DEFS["wathgrithr"].wathgrithr_beefalo_3.desc = STRINGS.SKILLTREE.WATHGRITHR.WATHGRITHR_BEEFALO_3_DESC

	--------------------------------------------------------------------------
	-- AFFINITY
	--------------------------------------------------------------------------

	STRINGS.SKILLTREE.WATHGRITHR.WATHGRITHR_ALLEGIANCE_LOCK_1_DESC = "Have no skills learned to unlock.\n Affinity can only be chosen as the first pick."
	SkillTreeDefs.SKILLTREE_DEFS["wathgrithr"].wathgrithr_allegiance_lock_1.desc = STRINGS.SKILLTREE.WATHGRITHR.WATHGRITHR_ALLEGIANCE_LOCK_1_DESC

	STRINGS.SKILLTREE.WATHGRITHR.WATHGRITHR_ALLEGIANCE_SHADOW_TITLE = "Shadow Huntress"
	SkillTreeDefs.SKILLTREE_DEFS["wathgrithr"].wathgrithr_allegiance_shadow.title = STRINGS.SKILLTREE.WATHGRITHR.WATHGRITHR_ALLEGIANCE_SHADOW_TITLE

	STRINGS.SKILLTREE.WATHGRITHR.WATHGRITHR_ALLEGIANCE_SHADOW_DESC = "Life and sanity steal are greatly increased. Max health increased by 50.\n Hunger rate increased by 20%.\n Inspiration is no longer gained through normal means."
	SkillTreeDefs.SKILLTREE_DEFS["wathgrithr"].wathgrithr_allegiance_shadow.desc = STRINGS.SKILLTREE.WATHGRITHR.WATHGRITHR_ALLEGIANCE_SHADOW_DESC

	--STRINGS.SKILLTREE.WATHGRITHR.WATHGRITHR_ALLEGIANCELUNAR_TITLE = "Lunar Melodist"
	STRINGS.SKILLTREE.WATHGRITHR.WATHGRITHR_ALLEGIANCE_LUNAR_DESC = "Gain stronger buffs from your own songs.\n Inspiration raises faster and depletes slower.\n Life and sanity steal are removed."
	SkillTreeDefs.SKILLTREE_DEFS["wathgrithr"].wathgrithr_allegiance_lunar.desc = STRINGS.SKILLTREE.WATHGRITHR.WATHGRITHR_ALLEGIANCE_LUNAR_DESC

