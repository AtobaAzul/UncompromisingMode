local prefabs =
{
    "killerbee", --replace with wasp
}

local assets =
{
}

SetSharedLootTable( 'trapdoor',
{
    {'rocks',       1.00},
    {'rocks',       1.00},
    {'rocks',       1.00},
})



local function onnear(inst, target)
    if inst.components.childspawner ~= nil and not target:HasTag("monster") then
        inst.components.childspawner:ReleaseAllChildren(target, "spider_trapdoor")
    end
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
        --onhitbyplayer(inst, target)
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

local function amempty(inst)
return inst.components.childspawner ~= nil and inst.components.childspawner.maxchildren == 0 and not inst:HasTag("obvious")
end

local function OldFindNewHole(inst)
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

local function unempty(inst)
	if inst.components.childspawner ~= nil then
		inst.components.childspawner:SetMaxChildren(1)
	end
end

local function FindNewHole(inst)
local target = FindEntity(inst, 3*TUNING.LEIF_MAXSPAWNDIST, amempty, { "trapdoor" })
	if target ~= nil then
		if inst.components.childspawner ~= nil then
				target:DoTaskInTime(480 + math.random() * 3, unempty)      --<-- This is where the regen time is actually located, since it swaps nests
				inst.components.childspawner:StopRegen()
				inst.components.childspawner:SetMaxChildren(0)
				inst:AddTag("obvious")
				inst:DoTaskInTime(90000, inst:RemoveTag("obvious"))
		end
	end
end

local function workcallback(inst, worker, workleft)
    if workleft <= 0 then
        local pos = inst:GetPosition()
        SpawnPrefab("rock_break_fx").Transform:SetPosition(pos:Get())
        inst.components.lootdropper:DropLoot(pos)
        inst:Remove()
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    --inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()


    

    inst.AnimState:SetBank("trapdoor")
    inst.AnimState:SetBuild("trapdoor")
    inst.AnimState:PlayAnimation("idle", true)

    inst:AddTag("structure")
    inst:AddTag("hive")
    inst:AddTag("WORM_DANGER")
	inst:AddTag("trapdoor")
	--inst:AddTag("CLASSIFIED")
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
	inst.components.childspawner:SetRegenPeriod(20,2)
	inst.components.childspawner:SetOnChildKilledFn(FindNewHole)
	local startrandomtest = math.random()
	inst.components.childspawner:StopRegen()
	if startrandomtest >= 0.85 then
	inst.components.childspawner:SetMaxChildren(1)
	inst.components.childspawner:StartRegen()
	end
    -------------------------
    -------------------------
    inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(10, 13) --set specific values
    inst.components.playerprox:SetOnPlayerNear(onnear)
    inst.components.playerprox:SetPlayerAliveMode(inst.components.playerprox.AliveModes.AliveOnly)
    -------------------------
    --inst:AddComponent("combat")
    --wasp hive should trigger on proximity, release wasps.
    --inst.components.combat:SetOnHit(onhitbyplayer)
    --inst:ListenForEvent("death", OnKilled)
    -------------------------
    MakeMediumPropagator(inst)
    MakeSnowCovered(inst)
    -------------------------
    inst:AddComponent("inspectable")

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_MEDIUM)
    inst.components.hauntable:SetOnHauntFn(OnHaunt)
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetChanceLootTable('trapdoor')
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.MINE)
    inst.components.workable:SetWorkLeft(TUNING.ROCKS_MINE)

    inst.components.workable:SetOnWorkCallback(workcallback)
	
    return inst
end

return Prefab("trapdoor", fn, assets, prefabs)
