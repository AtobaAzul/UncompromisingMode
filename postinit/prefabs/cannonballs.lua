local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

local CANNONBALL_RADIUS = TUNING.CANNONBALL_RADIUS
local CANNONBALL_DAMAGE = TUNING.CANNONBALL_DAMAGE
local CANNONBALL_PASS_THROUGH_TIME_BUFFER = TUNING.CANNONBALL_PASS_THROUGH_TIME_BUFFER
-- to prevent the cannonball from hitting the same target multiple times as it passes through
local MUST_ONE_OF_TAGS = { "_combat", "_health", "blocker" }

env.AddPrefabPostInit("cannonball_rock", function(inst)
    if not TheWorld.ismastersim then
        return
    end
    if inst.components.complexprojectile ~= nil then --you never know...
        local _OnUpdate = inst.components.complexprojectile.onupdatefn
        inst.components.complexprojectile.onupdatefn = function(inst)
            local x, y, z = inst.Transform:GetWorldPosition()

            local crabking = TheSim:FindEntities(x, 0, z, CANNONBALL_RADIUS * 1.5, { "crab" }, nil, MUST_ONE_OF_TAGS) --slightly more forgiving radius for CK
            for i, target in ipairs(crabking) do
                if target ~= nil and target ~= inst.components.complexprojectile.attacker and not target:HasTag("boatbumper") then
                    if target.components.combat and
                        GetTime() - target.components.combat.lastwasattackedtime > CANNONBALL_PASS_THROUGH_TIME_BUFFER then
                        target.components.combat:GetAttacked(inst, CANNONBALL_DAMAGE * 0.25, nil)
                    end
                end
            end
        end
        _OnUpdate(inst)
    end
end)
