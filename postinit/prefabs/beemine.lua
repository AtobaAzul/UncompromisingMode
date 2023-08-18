local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

local function StopRattleTask(inst)
    if inst.rattletask ~= nil then
        inst.rattletask:Cancel()
        inst.rattletask = nil
    end
end

local function StopRattling(inst)
    inst.rattling = false
    inst.nextrattletime = nil
    StopRattleTask(inst)
end

local TARGET_CANT_TAGS = { "insect", "playerghost" }
local TARGET_ONEOF_TAGS = { "character", "animal", "monster" }
local function SpawnBees(inst, target)
    inst.SoundEmitter:PlaySound("dontstarve/bee/beemine_explo")
    if target == nil or not target:IsValid() then
        target = FindEntity(inst, 25, nil, nil, TARGET_CANT_TAGS, TARGET_ONEOF_TAGS)
    end
    if target ~= nil then
        for i = 1, TUNING.BEEMINE_BEES do
            local bee = SpawnPrefab("bulletbee")
            if bee ~= nil then
                local x, y, z = inst.Transform:GetWorldPosition()
                local dist = math.random()
                local angle = math.random() * 2 * PI
                bee.Physics:Teleport(x + dist * math.cos(angle), y, z + dist * math.sin(angle))
                if bee.components.combat ~= nil then
                    bee.components.combat:SetTarget(target)
                end
				
				bee.persists = false
            end
        end
        target:PushEvent("coveredinbees")
    end
	
	inst.spawntask = nil
end

local function OnExplode(inst)
    StopRattling(inst)
    if inst.spawntask ~= nil then -- We've already been told to explode
        return
    end
	if inst.components.workable:GetWorkLeft() <= 0 then
		inst.AnimState:PlayAnimation("explode")
	else
		inst.AnimState:PlayAnimation("explode_reset")
		inst.AnimState:PushAnimation("inactive")
	end
    inst.SoundEmitter:PlaySound("dontstarve/bee/beemine_launch")
    inst.spawntask = inst:DoTaskInTime(9 * FRAMES, SpawnBees, inst.components.mine:GetTarget())
	
    if inst.components.finiteuses then
        inst.components.finiteuses:Use(1)
    end
end

local function onfinished_normal(inst)
    inst:RemoveComponent("inventoryitem")
    inst:RemoveComponent("mine")
    inst.persists = false
    inst.Physics:SetActive(false)
    inst:DoTaskInTime(1, inst.Remove)
end

env.AddPrefabPostInit("beemine", function(inst)
	if not TheWorld.ismastersim then
		return
	end

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(TUNING.TRAP_TEETH_USES / 2)
    inst.components.finiteuses:SetUses(TUNING.TRAP_TEETH_USES / 2)
    inst.components.finiteuses:SetOnFinished(onfinished_normal)
		
	if inst.components.mine ~= nil then
        inst.components.mine:SetOnExplodeFn(OnExplode)
		inst:DoTaskInTime(1, function()
			if inst.components.inventoryitem ~= nil and not inst.components.inventoryitem:IsHeld() then
				inst.components.mine:Reset()
			end
		end)
	end
end)