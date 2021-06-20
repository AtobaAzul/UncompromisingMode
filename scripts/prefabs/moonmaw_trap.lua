
SetSharedLootTable("moonglass_trap",
{
    {"moonglass",   1.00},
    {"moonglass",   1.00},
    {"moonglass",   0.50},
})

local function set_guardian(inst, guardian)
    inst._guardian = guardian
end

local LANDEDAOE_CANT_TAGS = {
    "brightmare", "FX", "ghost", "INLIMBO", "NOCLICK", "playerghost", "moonglasscreature"
}
local LANDEDAOE_ONEOF_TAGS = { "_combat", "CHOP_workable", "DIG_workable", "HAMMER_workable", "MINE_workable" }
local function do_landed(inst)
    -- Start with a nice simple camera shake... Should be mild, since we're dropping a bunch of these.
    ShakeAllCameras(CAMERASHAKE.VERTICAL, .5, 0.1, 0.1, inst, 35)

    -- Now do the complicated damage & destruction AOE.
    local attacker = (inst._guardian ~= nil and inst._guardian:IsValid() and inst._guardian)
            or inst
    local attacker_combat = attacker.components.combat
    local old_damage = nil

    if attacker_combat ~= nil then
        old_damage = attacker_combat.defaultdamage
        attacker_combat.ignorehitrange = true
        attacker_combat:SetDefaultDamage(TUNING.ALTERGUARDIAN_PHASE3_TRAP_LANDEDDAMAGE)
    end

    local x, y, z = inst.Transform:GetWorldPosition()
    local potential_targets = TheSim:FindEntities(
        x, y, z, 3, nil, LANDEDAOE_CANT_TAGS, LANDEDAOE_ONEOF_TAGS
    )
    for _, target in ipairs(potential_targets) do
        if target ~= inst and target:IsValid() then
            local has_health = target.components.health ~= nil

            if has_health and target:HasTag("smashable") then
                target.components.health:Kill()
            elseif target.components.workable ~= nil
                    and target.components.workable:CanBeWorked() 
                    and target.components.workable.action ~= ACTIONS.NET then
                local tx, ty, tz = target.Transform:GetWorldPosition()
                if not target:HasTag("moonglass") then
                    local collapse_fx = SpawnPrefab("collapse_small")
                    collapse_fx.Transform:SetPosition(tx, ty, tz)
                end

                target.components.workable:Destroy(inst)
            elseif has_health and not target.components.health:IsDead() then
                if attacker_combat ~= nil then
                    attacker_combat:DoAttack(target)
                elseif target.components.combat ~= nil then
                    target.components.combat:GetAttacked(attacker, TUNING.ALTERGUARDIAN_PHASE3_TRAP_LANDEDDAMAGE)
                end
            end
        end
    end

    if attacker_combat ~= nil then
        attacker_combat.ignorehitrange = false
        attacker_combat:SetDefaultDamage(old_damage)
    end
end

local function spawn_trap(inst)
    local ix, iy, iz = inst.Transform:GetWorldPosition()

    local trap = SpawnPrefab("moonstorm_glass_ground_fx")
    trap.Transform:SetPosition(ix, iy, iz)

    --[[if inst._guardian ~= nil and inst._guardian:IsValid() then
        inst._guardian:TrackTrap(trap)
    end]]

    inst:Remove()
end

local function projectile_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddLight()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.Light:SetIntensity(0.7)
    inst.Light:SetRadius(1.5)
    inst.Light:SetFalloff(0.85)
    inst.Light:SetColour(0.05, 0.05, 1)

    inst.AnimState:SetBank("alterguardian_meteor")
    inst.AnimState:SetBuild("alterguardian_meteor")
    --inst.AnimState:PlayAnimation("meteor_pre")

    inst.SoundEmitter:PlaySound("moonstorm/creatures/boss/alterguardian3/atk_traps")

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end
	inst.Light:Enable(false)
	inst:Hide()
	local random = math.random(1,5)
	inst:DoTaskInTime(random,function(inst) 
		inst:Show()
		inst.Light:Enable(true)
		inst.AnimState:PlayAnimation("meteor_pre") 
		inst:DoTaskInTime(32*FRAMES, do_landed)
		inst:ListenForEvent("animover", spawn_trap)
	end)
	inst.SetGuardian = set_guardian
    inst.persists = false

    return inst
end

local PULSE_MUST_TAGS = { "_health" }
local PULSE_CANT_TAGS =
{
    "brightmare",
    "DECOR",
    "epic",
    "FX",
    "ghost",
    "INLIMBO",
    "noauradamage",
    "playerghost",
}
local function do_groggy_pulse(inst)
    local ix, iy, iz = inst.Transform:GetWorldPosition()
    local nearby_targets = TheSim:FindEntities(
        ix, iy, iz, TUNING.ALTERGUARDIAN_PHASE3_TRAP_AOERANGE,
        PULSE_MUST_TAGS, PULSE_CANT_TAGS
    )

    for _, target in ipairs(nearby_targets) do
        if target.entity:IsVisible()
                and not target.components.health:IsDead() 
                and target.sg ~= nil then
            -- Smash some sleepiness onto anything with grogginess or sleeper components.
            -- Specifically, to hit combat targets, like players, pigs, merms, etc.
            if target.components.grogginess ~= nil and not target.sg:HasStateTag("knockout") then
                target.components.grogginess:AddGrogginess(TUNING.ALTERGUARDIAN_PHASE3_TRAP_GROGGINESS, TUNING.ALTERGUARDIAN_PHASE3_TRAP_KNOCKOUTTIME)
                if target.components.grogginess.knockoutduration == 0 then
                    target:PushEvent("attacked", {attacker = inst, damage = 0})
                end
            elseif target.components.sleeper ~= nil and not target.sg:HasStateTag("sleeping") then
                target.components.sleeper:AddSleepiness(TUNING.ALTERGUARDIAN_PHASE3_TRAP_GROGGINESS, TUNING.ALTERGUARDIAN_PHASE3_TRAP_KNOCKOUTTIME)
                if not target.components.sleeper:IsAsleep() then
                    target:PushEvent("attacked", {attacker = inst, damage = 0})
                end
            end
        end
    end
end

local function finish_pulse(inst)
    -- Play our ground fx object's post anim, and then queue up a hide for when that finishes.
    if inst._pulse_fx ~= nil and inst._pulse_fx:IsValid() then
        inst._pulse_fx.AnimState:PlayAnimation("meteorground_pst")
        local pulse_pst_len = inst._pulse_fx.AnimState:GetCurrentAnimationLength()
        inst._pulse_fx:DoTaskInTime(pulse_pst_len, inst._pulse_fx.Hide)
    end

    -- Stop doing our pulse testing, and queue up our next charge.
    inst.components.timer:StopTimer("pulse")
    inst.components.timer:StartTimer("start_charge", 4.5)
end

local NUM_PULSE_LOOPS = 3
local function start_pulse(inst)
    -- Lazily instantiate our pulse fx; if it exists, we use Show/Hide on it.
    if inst._pulse_fx == nil or not inst._pulse_fx:IsValid() then
        inst._pulse_fx = SpawnPrefab("alterguardian_phase3trapgroundfx")
        inst._pulse_fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    else
        inst._pulse_fx:Show()
    end

    inst._pulse_fx.AnimState:PlayAnimation("meteorground_pre")
    local pulse_pre_len = inst._pulse_fx.AnimState:GetCurrentAnimationLength()

    inst._pulse_fx.AnimState:PushAnimation("meteorground_loop", true)
    local pulse_loop_len = inst._pulse_fx.AnimState:GetCurrentAnimationLength()

    -- Do the first pulse ~2/3rds through the pre anim (since it's large enough to have to sell hitting).
    -- Future pulses are then lined up via the timer callback.
    inst.components.timer:StartTimer("pulse", pulse_pre_len * 0.66)

    -- After NUM_PULSE_LOOPS, shut down all of the stuff.
    inst.components.timer:StartTimer("finish_pulse", pulse_pre_len + (pulse_loop_len * NUM_PULSE_LOOPS))
end

local function start_charge(inst)
    inst.AnimState:PlayAnimation("meteor_charge")
    inst.AnimState:PushAnimation("meteor_idle", true)

    inst.components.timer:StartTimer("start_pulse", inst.AnimState:GetCurrentAnimationLength())
end

local PULSE_TICK_TIME = 24*FRAMES
local function on_trap_timer(inst, data)
    if data.name == "start_charge" then
        start_charge(inst)
    elseif data.name == "start_pulse" then
        start_pulse(inst)
    elseif data.name == "pulse" then
        do_groggy_pulse(inst)

        -- The pulse is functionally a periodic task; we just stop the timer in finish_pulse
        inst.components.timer:StartTimer("pulse", PULSE_TICK_TIME)
    elseif data.name == "finish_pulse" then
        finish_pulse(inst)
    end
end

local function on_trap_removed(inst)
    if inst._pulse_fx ~= nil and inst._pulse_fx:IsValid() then
        inst._pulse_fx:Remove()
        inst._pulse_fx = nil
    end
end

local function on_trap_mining_finished(inst, worker)
    local pt = inst:GetPosition()

    SpawnPrefab("rock_break_fx").Transform:SetPosition(pt:Get())

    --inst.components.lootdropper:DropLoot(pt)

    inst:Remove()
end

local function trap_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddLight()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.Light:SetIntensity(0.7)
    inst.Light:SetRadius(1.5)
    inst.Light:SetFalloff(0.85)
    inst.Light:SetColour(0.05, 0.05, 1)

    inst:AddTag("moonglass")

    inst.AnimState:SetBank("alterguardian_meteor")
    inst.AnimState:SetBuild("alterguardian_meteor")
    inst.AnimState:PlayAnimation("meteor_idle", true)

    --MakeObstaclePhysics(inst, 1) --A new prefab.... All for this

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.MINE)
    inst.components.workable:SetWorkLeft(7)
    inst.components.workable:SetOnFinishCallback(on_trap_mining_finished)
    inst.components.workable.savestate = true
	inst:DoTaskInTime(0.5,on_trap_mining_finished)
    --inst:AddComponent("lootdropper")
    --inst.components.lootdropper:SetChanceLootTable("moonglass_trap")

    inst:AddComponent("timer")

    inst:ListenForEvent("timerdone", on_trap_timer)
    inst:ListenForEvent("onremove", on_trap_removed)

    inst.components.timer:StartTimer("start_charge", 3.5)

    return inst
end
return Prefab("moonmaw_trapprojectile", projectile_fn),
        Prefab("moonmaw_trap", trap_fn)
