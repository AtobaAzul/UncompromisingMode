local env = env
GLOBAL.setfenv(1, GLOBAL)

require "prefabutil"
local easing = require("easing")
-----------------------------------------------------------------
local function LaunchProjectile2(inst, targetpos)
    local x, y, z = inst.Transform:GetWorldPosition()

    local projectile = SpawnPrefab("snowball")
    projectile.Transform:SetPosition(x, y, z)

    --V2C: scale the launch speed based on distance
    --     because 15 does not reach our max range.
    local dx = targetpos.x - x
    local dz = targetpos.z - z
    local rangesq = dx * dx + dz * dz
    local maxrange = TUNING.FIRE_DETECTOR_RANGE
    local speed = easing.linear(rangesq, 15, 3, maxrange * maxrange)
    projectile.components.complexprojectile:SetHorizontalSpeed(speed)
    projectile.components.complexprojectile:SetGravity(-25)
    projectile.components.complexprojectile:Launch(targetpos, inst, inst)
	
	if inst.components.fueled ~= nil then
		inst.components.fueled:DoDelta(-35)
	end
end

env.AddPrefabPostInit("firesuppressor", function (inst)
    if not TheWorld.ismastersim then
		return
	end
	
    inst.components.fueled:InitializeFuelLevel(TUNING.FIRESUPPRESSOR_MAX_FUEL_TIME * 1.2)

	inst.LaunchProjectile = LaunchProjectile2

end)