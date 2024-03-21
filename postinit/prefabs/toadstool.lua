local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
SetSharedLootTable('toadystool',
{
    {"froglegs",      1.00},
    {"meat",          1.00},
    {"meat",          1.00},
    {"meat",          1.00},
    {"meat",          0.50},
    {"meat",          0.25},

    {"shroom_skin",   1.00},
    {"shroom_skin",   1.00},
    {"shroom_skin",   1.00},
    {"chesspiece_toadstool_sketch", 1.00},

    {"red_cap",       1.00},
    {"red_cap",       0.33},
    {"red_cap",       0.33},

    {"blue_cap",      1.00},
    {"blue_cap",      0.33},
    {"blue_cap",      0.33},

    {"green_cap",     1.00},
    {"green_cap",     0.33},
    {"green_cap",     0.33},
})

SetSharedLootTable('toadystool_dark',
{
    {"froglegs",      1.00},
    {"meat",          1.00},
    {"meat",          1.00},
    {"meat",          1.00},
    {"meat",          0.50},
    {"meat",          0.25},

    {"shroom_skin",   1.00},
    {"shroom_skin",   1.00},
    {"shroom_skin",   1.00},
    {"shroom_skin",   1.00},
    {"shroom_skin",   1.00},
    {"chesspiece_toadstool_sketch", 1.00},

    {"red_cap",       1.00},
    {"red_cap",       0.33},
    {"red_cap",       0.33},

    {"blue_cap",      1.00},
    {"blue_cap",      0.33},
    {"blue_cap",      0.33},

    {"green_cap",     1.00},
    {"green_cap",     0.33},
    {"green_cap",     0.33},

    {"mushroom_light2_blueprint", 1.00},
    {"sleepbomb_blueprint", 1.00},
})

local PHASE2_HEALTH = .7
local PHASE3_HEALTH = .4
local PHASE4_HEALTH = .2

local function SetPhaseLevel(inst, phase)
    inst.phase = phase
    inst.pound_rnd = phase > 3 and inst.dark
    phase = math.min(3, phase)
    inst.sporebomb_targets = TUNING.TOADSTOOL_SPOREBOMB_TARGETS_PHASE[phase]
    inst.sporebomb_cd = TUNING.TOADSTOOL_SPOREBOMB_CD_PHASE[phase]
    inst.mushroombomb_count = TUNING.TOADSTOOL_MUSHROOMBOMB_COUNT_PHASE[phase]
    if phase > 2 then
        inst.components.timer:ResumeTimer("pound_cd")
    else
        inst.components.timer:StopTimer("pound_cd")
        inst.components.timer:StartTimer("pound_cd", TUNING.TOADSTOOL_ABILITY_INTRO_CD, true)
    end
end

local function DropShroomSkin(inst)
    --local player--[[, rangesq]] = inst:GetNearestPlayer()
    --LaunchAt(SpawnPrefab("shroom_skin"), inst, player, 1, 4, 2)
end

local function EnterPhase2Trigger(inst)
    if inst.phase < 2 then
        SetPhaseLevel(inst, 2)
        if inst.components.health:GetPercent() > PHASE3_HEALTH then
            DropShroomSkin(inst)
        end
        inst:PushEvent("roar")
    end
end

local function EnterPhase3Trigger(inst)
    if inst.phase < 3 then
        SetPhaseLevel(inst, 3)
        if not inst.components.health:IsDead() then
            DropShroomSkin(inst)
        end
        inst:PushEvent("roar")
    end
end

local function EnterPhase3TriggerDark(inst)
    if inst.phase < 3 then
        SetPhaseLevel(inst, 3)
        if inst.components.health:GetPercent() > PHASE4_HEALTH then
            DropShroomSkin(inst)
        end
        inst:PushEvent("roar")
    end
end

local function EnterPhase4TriggerDark(inst)
    if inst.phase < 4 then
        SetPhaseLevel(inst, 4)
        if not inst.components.health:IsDead() then
            DropShroomSkin(inst)
        end
        inst:PushEvent("roar")
    end
end


env.AddPrefabPostInit("toadstool", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
    inst.components.healthtrigger:AddTrigger(PHASE2_HEALTH, EnterPhase2Trigger)
    inst.components.healthtrigger:AddTrigger(PHASE3_HEALTH, EnterPhase3Trigger)
	
	--if inst.components.health ~= nil then
		--inst.components.health:SetMaxHealth(TUNING.DSTU.TOADSTOOL_HEALTH)
	--end
	
	if inst.components.lootdropper ~= nil then
		inst.components.lootdropper:SetChanceLootTable("toadystool")
	end
	
end)

env.AddPrefabPostInit("toadstool_dark", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	
    inst.components.healthtrigger:AddTrigger(PHASE2_HEALTH, EnterPhase2Trigger)
    inst.components.healthtrigger:AddTrigger(PHASE3_HEALTH, EnterPhase3TriggerDark)
    inst.components.healthtrigger:AddTrigger(PHASE4_HEALTH, EnterPhase4TriggerDark)
	
	if inst.components.lootdropper ~= nil then
		inst.components.lootdropper:SetChanceLootTable("toadystool_dark")
	end
	
end)

local function DropShroomSkin(inst)
    local player--[[, rangesq]] = inst:GetNearestPlayer()
    LaunchAt(SpawnPrefab("shroom_skin"), inst, player, 1, 4, 2)
end