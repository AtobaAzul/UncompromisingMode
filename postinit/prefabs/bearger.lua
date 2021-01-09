local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
local easing = require("easing")

local function RockThrowTimer(inst, data)
    if data.name == "RockThrow" then
        inst.rockthrow = true
    end
end

local function LaunchProjectile(inst, targetpos)
    local x, y, z = inst.Transform:GetWorldPosition()
	
    inst.rockthrow = false

    local projectile = SpawnPrefab("bearger_boulder")
    projectile.Transform:SetPosition(x, y, z)
	
    --local shadow = SpawnPrefab("meteorwarning")
    --shadow.Transform:SetPosition(targetpos.x, 0, targetpos.z)
	
    --V2C: scale the launch speed based on distance
    --     because 15 does not reach our max range.
    local dx = targetpos.x - x
    local dz = targetpos.z - z
    local rangesq = dx / 3 + dz / 3
    local maxrange = TUNING.FIRE_DETECTOR_RANGE
    local speed = easing.linear(rangesq, 15, 3, maxrange * maxrange)
    projectile.components.complexprojectile:SetHorizontalSpeed(speed)
    projectile.components.complexprojectile:SetGravity(-35)
    projectile.components.complexprojectile:Launch(targetpos, inst, inst)
end

env.AddPrefabPostInit("bearger", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	if inst.components.groundpounder then
		inst.components.groundpounder.sinkhole = true
	end
	
    inst:ListenForEvent("timerdone", RockThrowTimer)
	
	inst.rockthrow = true
	
    inst.LaunchProjectile = LaunchProjectile
end)