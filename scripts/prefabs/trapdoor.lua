local prefabs =
{
    "killerbee", --replace with wasp
}

local assets =
{
    Asset("ANIM", "anim/wasphive.zip"),
    Asset("SOUND", "sound/bee.fsb"), --replace with wasp
}

local function OnIgnite(inst)
    if inst.components.childspawner ~= nil then
        inst.components.childspawner:ReleaseAllChildren(nil, "spider_trapdoor")
    end
    inst.SoundEmitter:KillSound("loop")
    DefaultBurnFn(inst)
end

local function OnKilled(inst)
    inst:RemoveComponent("childspawner")
    inst.AnimState:PlayAnimation("cocoon_dead", true)
    RemovePhysicsColliders(inst)

    inst.SoundEmitter:KillSound("loop")

    inst.SoundEmitter:PlaySound("dontstarve/bee/beehive_destroy") --replace with wasp
    inst.components.lootdropper:DropLoot(inst:GetPosition()) --any loot drops?
end

local function onnear(inst, target)
    --hive pop open? Maybe rustle to indicate danger?
    --more and more come out the closer you get to the nest?
    if inst.components.childspawner ~= nil then
        inst.components.childspawner:ReleaseAllChildren(target, "spider_trapdoor")
    end
end

local function onhitbyplayer(inst, attacker, damage)
    if inst.components.childspawner ~= nil then
        inst.components.childspawner:ReleaseAllChildren(attacker, "spider_trapdoor")
    end
    if not inst.components.health:IsDead() then
        inst.SoundEmitter:PlaySound("dontstarve/bee/beehive_hit")
        inst.AnimState:PlayAnimation("cocoon_small_hit")
        inst.AnimState:PushAnimation("cocoon_small", true)
    end
end

local function OnEntityWake(inst)
    inst.SoundEmitter:PlaySound("dontstarve/bee/killerbee_hive_LP", "loop")
end

local function OnEntitySleep(inst)
    inst.SoundEmitter:KillSound("loop")
end

local function OnHaunt(inst)
    if inst.components.childspawner == nil or
        not inst.components.childspawner:CanSpawn() or
        math.random() > TUNING.HAUNT_CHANCE_HALF then
        return false
    end

    local target = FindEntity(
        inst,
        25,
        function(guy)
            return inst.components.combat:CanTarget(guy)
        end,
        { "_combat" }, --See entityreplica.lua (re: "_combat" tag)
        { "insect", "playerghost", "INLIMBO" },
        { "character", "animal", "monster" }
    )

    if target ~= nil then
        onhitbyplayer(inst, target)
        return true
    end
    return false
end

local function OpenMound(inst)
inst.AnimState:PlayAnimation("idle_flipped")
inst.AnimState:PushAnimation("flip_close")
inst.AnimState:PushAnimation("idle")
end

local function CloseMound(inst)
inst.AnimState:PlayAnimation("idle_flipped")
inst.AnimState:PushAnimation("flip_close")
inst.AnimState:PushAnimation("idle")
end

local function _OnUpdate(inst)
local x, y, z = inst.Transform:GetWorldPosition()
            local range = 30
            local ents = TheSim:FindEntities(x, y, z, range, nil, { "trapdoor" })
            if #ents > 0 then
                for i, v in ipairs(ents) do
                    if v.components.childspawner ~= nil and (v.components.childspawner.childreninside > 0 or v.components.childspawner.numchildrenoutside >0) then
						inst.components.childspawner:StopRegen()
						return
					end
                end
            end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()


    inst.MiniMapEntity:SetIcon("wasphive.png") --replace with wasp version if there is one.

    inst.AnimState:SetBank("trapdoor")
    inst.AnimState:SetBuild("trapdoor")
    inst.AnimState:PlayAnimation("idle", true)

    inst:AddTag("structure")
    inst:AddTag("hive")
    inst:AddTag("WORM_DANGER")
	inst:AddTag("trapdoor")

    MakeSnowCoveredPristine(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    -------------------------
    --inst:AddComponent("health")
    --inst.components.health:SetMaxHealth(250) --increase health?
    -------------------------
    inst:AddComponent("childspawner")
    --Set spawner to wasp. Change tuning values to wasp values.
    inst.components.childspawner.childspawner = "spider_trapdoor"
    inst.components.childspawner:SetMaxChildren(0)
    inst.components.childspawner.emergencychildname = "spider_trapdoor"
    inst.components.childspawner.emergencychildrenperplayer = 1
    inst.components.childspawner:SetMaxEmergencyChildren(TUNING.WASPHIVE_EMERGENCY_WASPS)
    inst.components.childspawner:SetEmergencyRadius(TUNING.WASPHIVE_EMERGENCY_RADIUS/2)
	inst.components.childspawner:SetSpawnedFn(OpenMound)
	inst.components.childspawner:SetGoHomeFn(CloseMound)
	inst.components.childspawner:SetRegenPeriod(100,50)
	inst.components.childspawner:NumChildren(0)
	inst:DoPeriodicTask(10, _OnUpdate, nil)
	
    -------------------------
    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot({ nil})
    -------------------------
    MakeLargeBurnable(inst)
    inst.components.burnable:SetOnIgniteFn(OnIgnite)
    -------------------------
    inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(10, 13) --set specific values
    inst.components.playerprox:SetOnPlayerNear(onnear)
    inst.components.playerprox:SetPlayerAliveMode(inst.components.playerprox.AliveModes.AliveOnly)
    -------------------------
    inst:AddComponent("combat")
    --wasp hive should trigger on proximity, release wasps.
    inst.components.combat:SetOnHit(onhitbyplayer)
    inst:ListenForEvent("death", OnKilled)
    -------------------------
    MakeMediumPropagator(inst)
    MakeSnowCovered(inst)
    -------------------------
    inst:AddComponent("inspectable")
    inst.OnEntitySleep = OnEntitySleep
    inst.OnEntityWake = OnEntityWake

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_MEDIUM)
    inst.components.hauntable:SetOnHauntFn(OnHaunt)

    return inst
end

return Prefab("trapdoor", fn, assets, prefabs)
