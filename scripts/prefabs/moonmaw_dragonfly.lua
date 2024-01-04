local brain = require "brains/moonmaw_dragonflybrain"

local easing = require("easing")

-- MUSIC------------------------------------------------------------------------
local function PushMusic(inst)
    if ThePlayer == nil or inst:HasTag("nomusic") then
        inst._playingmusic = false
    elseif ThePlayer:IsNear(inst, inst._playingmusic and 40 or 20) then
        inst._playingmusic = true
        ThePlayer:PushEvent("triggeredevent", {name = "alterguardian_phase1", duration = 2})
    elseif inst._playingmusic and not ThePlayer:IsNear(inst, 50) then
        inst._playingmusic = false
    end
end

local function OnMusicDirty(inst)
    if not TheNet:IsDedicated() then
        if inst._musictask ~= nil then
            inst._musictask:Cancel()
        end
        inst._musictask = inst:DoPeriodicTask(1, PushMusic)
        PushMusic(inst)
    end
end

local function SetNoMusic(inst, val)
    if val then
        inst:AddTag("nomusic")
    else
        inst:RemoveTag("nomusic")
    end
    inst._musicdirty:push()
    OnMusicDirty(inst)
end

-- MUSIC------------------------------------------------------------------------

TUNING.DRAGONFLY_SLEEP_WHEN_SATISFIED_TIME = 240
TUNING.DRAGONFLY_VOMIT_TARGETS_FOR_SATISFIED = 40
TUNING.DRAGONFLY_ASH_EATEN_FOR_SATISFIED = 20

local BASE_TAGS = {"structure"}
local SEE_STRUCTURE_DIST = 20

local TARGET_DIST = 3

local function LeaveWorld(inst)
    -- TheWorld:PushEvent("storehasslermockdragonfly", inst)
    inst:Remove()
end

local function NearPlayerBase(inst)
    local pt = inst:GetPosition()
    local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, SEE_STRUCTURE_DIST, BASE_TAGS)
    if #ents >= 5 then
        inst.SeenBase = true
        return true
    end
end

local function CalcSanityAura(inst) return inst.components.combat.target ~= nil and TUNING.SANITYAURA_HUGE or TUNING.SANITYAURA_LARGE end

local function UpdateLavaeDamageTick(inst)
    local count = 0
    for i = 1, 8 do
        if inst.lavae[i].hidden ~= true then
            count = count + 1
        end
    end

    local damagetime = 0.5

    if count < 5 then
        damagetime = 0.05
    end

    if count < 3 then
        damagetime = 0.01
    end

    if count < 2 then
        damagetime = 0.005
    end

    if count < 1 then
        damagetime = 0.001
    end

    for i = 1, 8 do
        if inst.lavae[i].hidden ~= true then
            inst.lavae[i].damagetime = damagetime
        end
    end
end

local function RetargetFn(inst)
    if inst:GetTimeAlive() < 5 then
        return
    end
    if inst.components.sleeper and inst.components.sleeper:IsAsleep() then
        return
    end
    if inst.spit_interval and inst.last_target_spit_time and (GetTime() - inst.last_target_spit_time) > (inst.spit_interval * 1.5) and inst.last_spit_time and (GetTime() - inst.last_spit_time) > (inst.spit_interval * 1.5) then
        return FindEntity(inst, 7 * TARGET_DIST, function(guy) return inst.components.combat:CanTarget(guy) and not guy:HasTag("prey") and not guy:HasTag("smallcreature") and not guy:HasTag("antlion") and not guy:HasTag("moonglasscreature") end)
    else
        return FindEntity(inst, 4 * TARGET_DIST, function(guy) return inst.components.combat:CanTarget(guy) and not guy:HasTag("prey") and not guy:HasTag("smallcreature") and not guy:HasTag("antlion") and not guy:HasTag("moonglasscreature") end)
    end
end

local function KeepTargetFn(inst, target) return inst.components.combat:CanTarget(target) and not target:HasTag("moonglasscreature") end

local function OnEntitySleep(inst)
    --[[if ((not inst:NearPlayerBase() and inst.SeenBase and not inst.components.combat:TargetIs(ThePlayer))
	--if ((not inst:NearPlayerBase() and inst.SeenBase and not inst.components.combat:TargetIs(GetPlayer()))
        or inst.components.sleeper:IsAsleep()
        or inst.KilledPlayer)
        and not NearPlayerBase(inst) then
        --Dragonfly has seen your base and been lured off! Despawn.
        --Or the dragonfly has killed you, you've been punished enough.
        --Only applies if not currently at a base
        LeaveWorld(inst)--]]
    local PlayerPosition = inst:GetNearestPlayer()

    if inst.shouldGoAway then
        LeaveWorld(inst)
    else
        --[[ elseif (not inst:NearPlayerBase() and not inst.SeenBase) and ThePlayer ~= nil
        or (inst.components.combat:TargetIs(ThePlayer) and not inst.KilledPlayer) then
        --Get back in there Dragonfly! You still have work to do.--]]

        if PlayerPosition ~= nil and not inst:NearPlayerBase() and not inst.SeenBase then
            local init_pos = inst:GetPosition()
            local player_pos = PlayerPosition:GetPosition()
            if player_pos then
                local angle = PlayerPosition:GetAngleToPoint(init_pos)
                local offset = FindWalkableOffset(player_pos, angle * DEGREES, 30, 10)
                if offset ~= nil then

                    local pos = player_pos + offset

                    if pos and distsq(player_pos, init_pos) > 1600 then
                        -- There's a crash if you teleport without the delay
                        if not inst.components.combat:TargetIs(PlayerPosition) then
                            inst.components.combat:SetTarget(nil)
                        end
                        inst:DoTaskInTime(.1, function()
                            inst.Transform:SetPosition(pos:Get())
                            if inst.components.leader ~= nil and inst.components.leader.followers ~= nil then
                                for i, v in ipairs(inst.components.leader.followers) do
                                    v.Transform:SetPosition(pos:Get())
                                end
                            end
                        end)

                    end

                else
                    local offset = FindSwimmableOffset(player_pos, angle * DEGREES, 30, 10)
                    local pos = player_pos + offset

                    if pos and distsq(player_pos, init_pos) > 1600 then
                        -- There's a crash if you teleport without the delay
                        if not inst.components.combat:TargetIs(PlayerPosition) then
                            inst.components.combat:SetTarget(nil)
                        end
                        inst:DoTaskInTime(.1, function()
                            inst.Transform:SetPosition(pos:Get())
                            if inst.components.leader ~= nil and inst.components.leader.followers ~= nil then
                                for i, v in ipairs(inst.components.leader.followers) do
                                    v.Transform:SetPosition(pos:Get())
                                end
                            end
                        end)

                    end
                end
            end
        end
    end
end

local function AfterWorking(inst, data)
    if data.target then
        local recipe = AllRecipes[data.target.prefab]
        if recipe then
            inst.structuresDestroyed = inst.structuresDestroyed + 1
            if inst:IsSated() then
                inst.components.knownlocations:ForgetLocation("targetbase")
                -- inst.AnimState:OverrideSymbol("deerclops_head", IsSpecialEventActive(SPECIAL_EVENTS.WINTERS_FEAST) and "deerclops_yule" or "deerclops_build", "deerclops_head_neutral")
            end
        end
    end
end

local function OnSave(inst, data)
    data.SeenBase = inst.SeenBase
    data.vomits = inst.num_targets_vomited
    data.KilledPlayer = inst.KilledPlayer
    data.shouldGoAway = inst.shouldGoAway
    data.spawnedLavae = inst.SpawnedLavae
    if inst.lavae ~= nil then
        data.lavae = {}
        for i = 1, 8 do
            if inst.lavae[i] ~= nil then
                data.lavae[i] = "alive"
            end
        end
    end
    data.fell = inst.fell
end

local function LoadLavae(inst)
    if inst.fell then
        inst.SpawnLavae(inst)
        inst.sg:GoToState("idle")
    end
end

local function OnLoad(inst, data)
    if data then
        inst.SeenBase = data.SeenBase
        inst.num_targets_vomited = data.vomits
        inst.KilledPlayer = data.KilledPlayer or false
        inst.shouldGoAway = data.shouldGoAway or false

        inst:DoTaskInTime(0, LoadLavae)
        if data.fell ~= nil then
            inst.fell = data.fell
        end
    end
end

local function OnSeasonChange(inst, data)
    inst.shouldGoAway = (TheWorld.state.isspring or TheWorld.state.isautumn or TheWorld.state.iswinter)
    if inst:IsAsleep() then
        OnEntitySleep(inst)
    end
end

local function OnAttacked(inst, data)
    inst:ClearBufferedAction()
    if data and data.attacker then
        if not data.attacker:HasTag("moonglasscreature") then
            inst.components.combat:SetTarget(data.attacker)
        end
    end
end

local function ShouldSleep(inst)
    if ((inst.num_targets_vomited >= TUNING.DRAGONFLY_VOMIT_TARGETS_FOR_SATISFIED) or (inst.num_ashes_eaten >= TUNING.DRAGONFLY_ASH_EATEN_FOR_SATISFIED)) and inst.arrivedatsleepdestination and not inst.sg:HasStateTag("crashed") then
        inst.num_targets_vomited = 0
        inst.num_ashes_eaten = 0
        inst.sleep_time = GetTime()
        inst.arrivedatsleepdestination = false
        inst.components.locomotor.atdestfn = nil
        return true
    end
    return false
end

local function ShouldWake(inst)
    local wake = inst.sleep_time and (GetTime() - inst.sleep_time) > TUNING.DRAGONFLY_SLEEP_WHEN_SATISFIED_TIME
    if wake == nil then
        wake = true
    end
    wake = wake or (inst.components.combat and inst.components.combat.target) or (inst.components.freezable and inst.components.freezable:IsFrozen())
    if wake then
        inst.hassleepdestination = false
    end
    return wake
end

local function OnCollide(inst, other)
    if other ~= nil and not other:HasTag("giant_tree") then
        inst:DoTaskInTime(2 * FRAMES, function()
            if other and other.components.workable and other.components.workable.workleft > 0 then
                SpawnPrefab("collapse_small").Transform:SetPosition(other:GetPosition():Get())
                if other.components.lootdropper ~= nil then
                    other.components.lootdropper:SetLoot({})
                end
                if other.components.lootdropper ~= nil then
                    other.components.lootdropper:SetLoot({})
                end
                other.components.workable:Destroy(inst)
            end
        end)
    end
end

local function OnSleep(inst)
    inst.SoundEmitter:KillSound("flying")
    inst.SoundEmitter:KillSound("vomitrumble")
    inst.SoundEmitter:KillSound("sleep")
    inst.SoundEmitter:KillSound("fireflying")
end

local function OnRemove(inst)
    TheWorld:PushEvent("mockflyremoved", inst)
    inst.SoundEmitter:KillSound("flying")
    inst.SoundEmitter:KillSound("vomitrumble")
    inst.SoundEmitter:KillSound("sleep")
    inst.SoundEmitter:KillSound("fireflying")
end

local function OnKill(inst, data)
    if inst.components.combat and data and data.victim == inst.components.combat.target then
        inst.components.combat.target = nil
        inst.last_kill_time = GetTime()
    end

    local PlayerPosition = inst:GetNearestPlayer()

    if data and PlayerPosition ~= nil then
        if data.victim == PlayerPosition then
            -- if data and data.victim == GetPlayer() then
            -- inst.KilledPlayer = true
        end
    end -- ]]
end

local loot = {"meat", "meat", "meat", "meat", "meat", "meat", "meat", "meat", "glass_scales", "moonglass_geode", "moonglass_geode", "moonglass_geode"}

local function OnDead(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, 50, {"player"})
    for i, v in ipairs(ents) do
        if v.components.sanity ~= nil then
            v.components.sanity:EnableLunacy(false, "moonmaw")
            if v.moonmaw ~= nil then
                v.moonmaw = nil
            end
            if v.moonmawcheck ~= nil then
                v.moonmawcheck = nil
            end
        end
    end
    TheWorld:PushEvent("mockflykilled", inst)
end

local function CheckTarget(inst) inst:DoTaskInTime(10, CheckTarget) end

local function OnRemove(inst) TheWorld:PushEvent("mockflyremoved", inst) end

local function SpawnLavae(inst)
    if not inst.SpawnedLavae then
        local x, y, z = inst.Transform:GetWorldPosition()
        local LIMIT = 4
        inst.lavae = {}
        for i = 1, 8 do
            inst.lavae[i] = SpawnPrefab("moonmaw_lavae_ring")
            inst.lavae[i].WINDSTAFF_CASTER = inst
            inst.lavae[i].components.linearcircler:SetCircleTarget(inst)
            inst.lavae[i].components.linearcircler:Start()
            inst.lavae[i].components.linearcircler.randAng = i * 0.125
            inst.lavae[i].components.linearcircler.clockwise = false
            inst.lavae[i].components.linearcircler.distance_limit = LIMIT
            inst.lavae[i].components.linearcircler.setspeed = 0.2
            inst.lavae[i].hidden = false
            inst.lavae[i].AnimState:PlayAnimation("hover")
            -- inst.lavae[i].AnimState:PushAnimation("hover",true)
        end
        inst.SpawnedLavae = true
    end
end

local function SpawnShards(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local LIMIT = 5
    inst.shards = {}
    for i = 1, 8 do
        inst.shards[i] = SpawnPrefab("moonmaw_glassshards_ring")
        inst.shards[i].WINDSTAFF_CASTER = inst
        inst.shards[i].components.linearcircler:SetCircleTarget(inst)
        inst.shards[i].components.linearcircler:Start()
        inst.shards[i].components.linearcircler.randAng = i * 0.125
        inst.shards[i].components.linearcircler.clockwise = false
        inst.shards[i].components.linearcircler.distance_limit = LIMIT
        inst.shards[i].components.linearcircler.setspeed = 0.2
        inst.shards[i].hidden = false
        inst.shards[i].destroy = true
        inst.shards[i].timetill = i * 0.25 + 2.5
    end
end

--[[local function ShardsSpawnAttack(inst)
if inst.components.combat ~= nil and inst.components.combat.target ~= nil then
	local target = inst.components.combat.target
	for i = 1,8 do
		local x,y,z = inst.shards[i].Transform:GetWorldPosition()
		local shardattack = SpawnPrefab("moonmaw_glassshards")
		shardattack.Transform:SetPosition(x,y,z)
		shardattack.anim = inst.shards[i].anim
		shardattack.components.projectile:Throw(inst, target, inst)
		inst.shards[i]:Remove()
	end
end
end]]

local function NoLavae(inst)
    if inst.lavae == nil then
        return true
    end
    for i = 1, 8 do
        if inst.lavae[i].hidden ~= true then
            return false
        end
    end
    return true
end

local function EjectLavae(inst, choice, severed)
    local lavae = SpawnPrefab("moonmaw_lavae")
    local x, y, z = inst.lavae[choice].Transform:GetWorldPosition()
    if x == nil then
        x, y, z = inst.Transform:GetWorldPosition() -- Fallback
    end
    lavae.Transform:SetPosition(x, y, z)
    inst.lavae[choice]:Hide()
    inst.lavae[choice].hidden = true
    lavae.number = choice
    if inst.components.combat ~= nil and inst.components.combat.target ~= nil then
        lavae.components.combat:SuggestTarget(inst.components.combat.target)
    end
    if severed ~= nil and severed then
        lavae.severed = true
    end
    inst.components.leader:AddFollower(lavae)
    UpdateLavaeDamageTick(inst)
end

local function TryEjectLavae(inst, severed)
    if inst.components.health ~= nil and not inst.components.health:IsDead() and NoLavae(inst) == false and inst.components.leader:CountFollowers() == 0 then
        if inst.components.health:GetPercent() > 0.5 then
            local choice = math.random(1, 8)
            if inst.lavae[choice].hidden ~= true then
                EjectLavae(inst, choice, severed)
            else
                TryEjectLavae(inst, severed)
            end
        else
            local choice = math.random(1, 8)
            local choice2 = math.random(1, 8)
            if inst.lavae[choice].hidden ~= true and inst.lavae[choice2].hidden ~= true and choice ~= choice2 then
                EjectLavae(inst, choice, severed)
                EjectLavae(inst, choice2)
            else
                TryEjectLavae(inst, severed)
            end
        end
    end
end

local function PerEjectCheck(inst)
    if inst.components.combat ~= nil and inst.components.combat.target ~= nil and (inst.components.health ~= nil and not inst.components.health:IsDead()) then
        TryEjectLavae(inst, false)
    end
end

local function CheckTimer(inst, data)
    if inst.components.health ~= nil and not inst.components.health:IsDead() then
        if data.name == "summoncrystals" then
            if NoLavae(inst) then
                if inst.sg:HasStateTag("shards") then
                    inst.components.timer:StartTimer("summoncrystals", 5)
                else
                    inst.sg:GoToState("summoncrystals")
                    inst.components.timer:StartTimer("summoncrystals", 30 + math.random(0, 15))
                end
                inst.sg:GoToState("summoncrystals")
            else
                -- inst.sg:GoToState("summoncrystals")
                inst.components.timer:StartTimer("summoncrystals", 60)
            end
        end
        if data.name == "glassshards" then
            if NoLavae(inst) then
                if inst.sg:HasStateTag("crystals") then
                    inst.components.timer:StartTimer("glassshards", 5)
                else
                    inst.sg:GoToState("shards_pre")
                    inst.components.timer:StartTimer("glassshards", 30 + math.random(0, 15))
                end
            else
                inst.components.timer:StartTimer("glassshards", 15)
            end
        end
    end
end

local function RedoLavae(inst)
    if inst.lavae ~= nil then
        for i = 1, 8 do
            if inst.lavae[i].hidden ~= true then
                EjectLavae(inst, i, true)
            end
        end
    end
    inst.components.timer:StopTimer("summoncrystals")
    inst.components.timer:StartTimer("summoncrystals", 30 + math.random(0, 15))
    inst.redolavae = true
    inst.SpawnedLavae = false
    inst.sg:GoToState("summoncrystals")
end

local function MoonMawCheck(player)
    local moonmaw = FindEntity(player, 40, function(guy) return guy:HasTag("moonmaw") end)

    if moonmaw == nil then
        player.components.sanity:EnableLunacy(false, "moonmaw")
        player.moonmaw = nil
        player.moonmawcheck = nil
    end
end

local function OnNear(inst, player)
    if player.components.sanity ~= nil and player.components.sanity.mode == SANITY_MODE_INSANITY then
        player.components.sanity:EnableLunacy(true, "moonmaw")
        player.moonmaw = inst
        player:DoPeriodicTask(3, MoonMawCheck)
    end
end

local function CheckPlayers(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local players = TheSim:FindEntities(x, y, z, 35, {"player"}, {"playerghost"})
    for i, v in ipairs(players) do
        OnNear(inst, v)
    end
end

local function fn(Sim)
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local sound = inst.entity:AddSoundEmitter()
    local shadow = inst.entity:AddDynamicShadow()
    shadow:SetSize(6, 3.5)
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    inst.DynamicShadow:SetSize(6, 3.5)

    inst.Transform:SetSixFaced()

    inst.Transform:SetScale(1.3, 1.3, 1.3)

    MakeCharacterPhysics(inst, 500, 2.5)

    inst.Physics:SetCollisionCallback(OnCollide)

    inst.OnEntitySleep = OnSleep
    inst.OnRemoveEntity = OnRemove

    inst.AnimState:SetBank("moonmaw_dragonfly")
    inst.AnimState:SetBuild("moonmaw_dragonfly")
    -- anim:PlayAnimation("idle", true)

    inst:AddTag("epic")
    inst:AddTag("mech")
    inst:AddTag("monster")
    inst:AddTag("hostile")
    inst:AddTag("mock_dragonfly")
    inst:AddTag("moonmaw")
    inst:AddTag("scarytoprey")
    inst:AddTag("largecreature")
    inst:AddTag("moonglasscreature")
    inst:AddTag("noepicmusic")

    inst._musicdirty = net_event(inst.GUID, "alterguardian_phase1._musicdirty", "musicdirty")
    inst._playingmusic = false
    OnMusicDirty(inst)

    inst:AddTag("lunar_aligned")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        inst:ListenForEvent("musicdirty", OnMusicDirty)
        return inst
    end

    inst.SetNoMusic = SetNoMusic

    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aurafn = CalcSanityAura

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(8000 * TUNING.DSTU.MOONFLY_HEALTH)
    inst.components.health.destroytime = 5
    inst.components.health.fire_damage_scale = 0

    inst:AddComponent("drownable")

    inst:AddComponent("healthtrigger")
    inst.components.healthtrigger:AddTrigger(0.5, RedoLavae)

    local function isnottree(ent)
        if ent ~= nil and not ent:HasTag("moonglasscreature") then -- fix to friendly AOE: refer for later AOE mobs -Axe
            return true
        end
    end

    inst:AddComponent("groundpounder")
    inst.components.groundpounder.numRings = 2
    inst.components.groundpounder.groundpoundfx = "moonstorm_glass_ground_fx"
    inst.components.groundpounder.groundpounddamagemult = .5
    inst.components.groundpounder.groundpoundringfx = "moonstorm_glass_ground_fx"
    inst.components.groundpounder.noTags = {"FX", "NOCLICK", "DECOR", "INLIMBO", "moonglasscreature"}

    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(100)
    inst.components.combat.playerdamagepercent = .5
    inst.components.combat:SetRange(4)
    inst.components.combat:SetAreaDamage(6, 0.8, isnottree)
    inst.components.combat.hiteffectsymbol = "dragonfly_body"
    inst.components.combat:SetAttackPeriod(TUNING.DRAGONFLY_ATTACK_PERIOD)
    inst.components.combat:SetRetargetFunction(3, RetargetFn)
    inst.components.combat:SetKeepTargetFunction(KeepTargetFn)
    inst.components.combat.battlecryenabled = false
    inst.components.combat:SetHurtSound("UCSounds/moonmaw/hurt")

    inst:AddComponent("explosiveresist")

    inst.KilledPlayer = false
    inst.fell = false
    inst:ListenForEvent("killed", OnKill)

    local light = inst.entity:AddLight()
    inst.Light:Enable(true)
    inst.Light:SetRadius(2)
    inst.Light:SetFalloff(0.9)
    inst.Light:SetIntensity(2)
    inst.Light:SetColour(121 / 255, 235 / 255, 12 / 255)

    inst:AddComponent("sleeper")
    inst.components.sleeper:SetResistance(4)
    inst.components.sleeper:SetSleepTest(ShouldSleep)
    inst.components.sleeper:SetWakeTest(ShouldWake)
    inst.playsleepsound = false
    inst.shouldGoAway = false

    inst:AddComponent("timer")

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot(loot)

    inst:AddComponent("inspectable")
    inst.components.inspectable:RecordViews()

    inst:AddComponent("knownlocations")
    inst:AddComponent("inventory")

    inst:ListenForEvent("seasontick", function() OnSeasonChange(inst) end, TheWorld)
    inst:ListenForEvent("attacked", OnAttacked)
    inst:ListenForEvent("entitysleep", OnEntitySleep)

    -- inst:AddComponent("vetcurselootdropper")
    -- inst.components.vetcurselootdropper.loot = "slobberlobber" Add a vetcurse drop later

    inst:DoTaskInTime(10, CheckTarget)

    inst.SeenBase = false
    inst.NearPlayerBase = NearPlayerBase
    inst.last_spit_time = nil
    inst.last_target_spit_time = nil
    inst.spit_interval = math.random(20, 30)
    inst.num_targets_vomited = 0
    inst.num_ashes_eaten = 0

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = 6
    inst.components.locomotor.runspeed = 8

    inst:SetStateGraph("SGmoonmaw_dragonfly")
    inst:SetBrain(brain)

    inst:ListenForEvent("onremove", OnRemove)
    inst:ListenForEvent("death", OnDead)
    inst:AddComponent("leader")

    inst:AddComponent("explosiveresist")
    inst.components.explosiveresist:SetResistance(0.8)
    inst.components.explosiveresist.decay = true

    inst:AddComponent("timer")
    inst:ListenForEvent("timerdone", CheckTimer)
    inst.components.timer:StartTimer("summoncrystals", 25)
    inst.components.timer:StartTimer("glassshards", 90)

    inst.SpawnLavae = SpawnLavae
    inst.SpawnShards = SpawnShards
    -- inst.ShardsSpawnAttack = ShardsSpawnAttack

    inst.sg:GoToState("skyfall")
    inst.TryEjectLavae = TryEjectLavae

    --
    inst:DoPeriodicTask(3, CheckPlayers)
    inst:DoPeriodicTask(10, PerEjectCheck)
    return inst
end

return Prefab("moonmaw_dragonfly", fn)
