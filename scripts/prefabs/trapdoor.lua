local prefabs =
{
    "killerbee", --replace with wasp
}

local assets =
{
    Asset("ANIM", "anim/wasphive.zip"),
    Asset("SOUND", "sound/bee.fsb"), --replace with wasp
}



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
    if inst.components.childspawner ~= nil and not target:HasTag("monster") then
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


local function FindNewHole(inst)
local x, y, z = inst.Transform:GetWorldPosition()
            local range = 30
            local ents = TheSim:FindEntities(x, y, z, range, nil, { "trapdoor" })
            if #ents > 0 then
                for i, v in ipairs(ents) do
					local randomtest = math.random()
					if  randomtest >= 0.5 then
						if v.components.childspawner ~= nil and v.components.childspawner.regening == false then
						inst.components.childspawner:StopRegen()
						inst.components.childspawner:SetMaxChildren(0)
						v.components.childspawner:StartRegen()
						v.components.childspawner:SetMaxChildren(1)
						return
						end
					end
                end
            end
end
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()


    

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
    inst.components.childspawner:SetEmergencyRadius(TUNING.WASPHIVE_EMERGENCY_RADIUS/2)
	inst.components.childspawner:SetSpawnedFn(OpenMound)
	inst.components.childspawner:SetGoHomeFn(CloseMound)
	inst.components.childspawner:SetRegenPeriod(100,2)
	inst.components.childspawner:SetOnChildKilledFn(FindNewHole)
	local startrandomtest = math.random()
	inst.components.childspawner:StopRegen()
	if startrandomtest >= 0.9 then
	inst.components.childspawner:SetMaxChildren(1)
	inst.components.childspawner:StartRegen()
	end
    -------------------------
    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot({ nil})
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
