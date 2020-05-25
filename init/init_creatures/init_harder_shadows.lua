------------------------------------------------------------------------
-- Changes and additions to nightmare creature mechanics
------------------------------------------------------------------------
--[[
-----------------------------------------------------------------
-- Fuelweaver mind control screen overlay effect at 0 sanity
-----------------------------------------------------------------
-- Relevant: mindcontrolover.lua, mindcontroller.lua, stalker.lua, STALKER_ATRIUM, MindControlOver (playerhud.lua), AddDebuff("mindcontroller", "mindcontroller")
local function EnableInsanityOverlay(player)
    player:PushEvent("insanitylevel", 1)
    --todo: implement effect
end

local function DisableInsanityOverlay(player)
    --todo: remove effect
end

AddPlayerPostInit(function(inst)

	if not GLOBAL.TheWorld.ismastersim then
        return inst
    end
		
	if GLOBAL.TheWorld.ismastersim then
		inst:AddComponent("moreshadows")
	end
	
end)--]]

-------------------------------------------------- Prefabs
--[[
PrefabFiles = { 
    "creepingfear",
    "dreadeye",
    "uncompromising_shadow_projectile_fx",
}
--]]
-------------------------------------------------- Strings

STRINGS = GLOBAL.STRINGS

STRINGS.NAMES.CREEPINGFEAR  = "Creeping Fear"
STRINGS.NAMES.DREADEYE  = "Dread Eye"

-------------------------------------------------- Turnings
--[[
TUNING = GLOBAL.TUNING

TUNING.DSTU = {

    HARDER_SHADOWS = GetModConfigData("harder_shadows"),
    MAX_DISTANCE_TO_SHADOWS = 1225, -- 35^2

    CREEPINGFEAR_SPEED = 4.8,
    CREEPINGFEAR_HEALTH = 1600,
    CREEPINGFEAR_DAMAGE = 60,
    CREEPINGFEAR_ATTACK_PERIOD = 2.3,
    CREEPINGFEAR_RANGE_1 = 3.0,
    CREEPINGFEAR_RANGE_2 = 4.2,
    CREEPINGFEAR_SPAWN_THRESH = 0, -- 10%

    DREADEYE_SPEED = 7,
    DREADEYE_HEALTH = 350,
    DREADEYE_DAMAGE = 35,
    DREADEYE_ATTACK_PERIOD = 2,
    DREADEYE_RANGE_1 = 1.8,
    DREADEYE_RANGE_2 = 1.8,
    DREADEYE_SPAWN_THRESH = 0.20, -- 20%
}

TUNING.SANITY_BECOME_INSANE_THRESH = 40/200 -- 20%
TUNING.SANITY_BECOME_SANE_THRESH  = 45/200 -- 22.5%--]]

-------------------------------------------------- Components

local function replace_shadowcreaturespawner(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end
    --inst:RemoveComponent("shadowcreaturespawner") -- It won't work, I disbled the original component with an if-else instead
    inst:AddComponent("uncompromising_shadowcreaturespawner")
end

if GLOBAL.STRINGS.NAMES.MIGRATION_PORTAL then
    AddPrefabPostInit("forest", replace_shadowcreaturespawner)
    AddPrefabPostInit("cave", replace_shadowcreaturespawner)
else
    AddPrefabPostInit("world", replace_shadowcreaturespawner)
end

-------------------------------------------------- PrefabPostInit

local function crawlinghorror_postinit(inst)
    inst:AddComponent("uncompromising_shadowfollower")
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(GLOBAL.COLLISION.GROUND)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end
    inst.components.lootdropper:SetLoot({ "nightmarefuel" })
    inst.components.lootdropper:SetChanceLootTable(nil)
    inst.sanityreward = TUNING.SANITY_SMALL
end

local function terrorbeak_postinit(inst)
    inst:AddComponent("uncompromising_shadowfollower")
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(GLOBAL.COLLISION.GROUND)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end
    inst.components.lootdropper:SetLoot({ "nightmarefuel" })
    inst.components.lootdropper:SetChanceLootTable(nil)
    inst.sanityreward = TUNING.SANITY_LARGE * 0.8
end

local function daytime(inst)
    if GLOBAL.TheWorld:HasTag("forest") then
		inst:DoTaskInTime(math.random(), function()
			inst.components.lootdropper:SetLoot({})
			inst.components.lootdropper:SetChanceLootTable(nil)
			inst.components.health:Kill()
		end)
    end
end

local function crawlingnightmare_postinit(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end
    inst.components.lootdropper:SetLoot({ "nightmarefuel" })
    inst.components.lootdropper:SetChanceLootTable(nil)
	
	inst:WatchWorldState("isday", daytime)
end

local function nightmarebeak_postinit(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end
    inst.components.lootdropper:SetLoot({ "nightmarefuel" })
    inst.components.lootdropper:SetChanceLootTable(nil)
	
	inst:WatchWorldState("isday", daytime)
end
AddPrefabPostInit("crawlinghorror", crawlinghorror_postinit)
AddPrefabPostInit("terrorbeak", terrorbeak_postinit)
AddPrefabPostInit("crawlingnightmare", crawlingnightmare_postinit)
AddPrefabPostInit("nightmarebeak", nightmarebeak_postinit)



-------------------------------------------------- StategraphState

local state_teleport_disapper = GLOBAL.State{ name = "teleport_disapper",
    tags = { "busy", "noattack" },

    onenter = function(inst)
        inst.Physics:Stop()
        inst.AnimState:PlayAnimation("disappear")
    end,

    events =
    {
        GLOBAL.EventHandler("animover", function(inst) inst.sg:GoToState("appear") end),
    },
},

AddStategraphState("SGshadowcreature", state_teleport_disapper)
AddStategraphState("shadowcreature", state_teleport_disapper)