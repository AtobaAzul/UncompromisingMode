local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
local function ResetLavae(inst)
    --Despawn all lavae
    local lavae = inst.components.rampingspawner.spawns
    for k, v in pairs(lavae) do
        k.components.combat:SetTarget(nil)
        k.components.locomotor:Clear()
        k.reset = true
    end
end

local function Reset(inst)
    ResetLavae(inst)
    --Fly off
    inst.reset = true

    --No longer start the respawn task here - was possible to duplicate this if the exiting failed.
end


local function BossCheck(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, 50, { "epic" }, { "dragonfly" } )
	
	if #ents > 0 or TheWorld.state.issummer then
		Reset(inst)
	end

end

local function onnear(inst)
	if inst.task == nil then
		inst.task = inst:DoPeriodicTask(10, BossCheck)
	end
end

local function onfar(inst)
	inst.task = nil
end

env.AddPrefabPostInit("dragonfly", function (inst)
    if not TheWorld.ismastersim then
		return
	end
	
	inst:AddTag("insect")
	
	inst.task = nil

    inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(50, 51) --set specific values
    inst.components.playerprox:SetOnPlayerNear(onnear)
    inst.components.playerprox:SetOnPlayerFar(onfar)
	
	inst:AddComponent("vetcurselootdropper")
	inst.components.vetcurselootdropper.loot = "slobberlobber"
	
	inst.components.damagetracker.damage_threshold_fn = nil
	inst.components.lootdropper:AddChanceLoot("dragon_scales",    1.00)
	inst.components.lootdropper:AddChanceLoot("dragon_scales",    1.00)
end)