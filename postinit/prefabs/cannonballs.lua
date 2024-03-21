local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
local CANNONBALL_RADIUS = TUNING.CANNONBALL_RADIUS
local CANNONBALL_DAMAGE = TUNING.CANNONBALL_DAMAGE
local CANNONBALL_SPLASH_RADIUS = TUNING.CANNONBALL_SPLASH_RADIUS
local CANNONBALL_PASS_THROUGH_TIME_BUFFER = TUNING.CANNONBALL_PASS_THROUGH_TIME_BUFFER -- to prevent the cannonball from hitting the same target multiple times as it passes through

local AREAATTACK_EXCLUDETAGS = { "INLIMBO", "notarget", "noattack", "flight", "invisible", "playerghost" }

-- to prevent the cannonball from hitting the same target multiple times as it passes through
local MUST_ONE_OF_TAGS = { "_combat", "_health", "blocker" }

env.AddPrefabPostInit("cannonball_rock", function(inst)
    if not TheWorld.ismastersim then
        return
    end
    if inst.components.complexprojectile ~= nil then -- you never know...
        -- local _OnUpdate = inst.components.complexprojectile.onupdatefn
        -- overriding so I can fix klei's stupid bug.

        inst.components.complexprojectile.onupdatefn = function(inst)
            local boat = inst.components.complexprojectile.attacker:GetCurrentPlatform()
            -- Look to hit targets while the cannonball is flying through the air
            local x, y, z = inst.Transform:GetWorldPosition()
            local targets = TheSim:FindEntities(x, 0, z, CANNONBALL_RADIUS, nil, nil, MUST_ONE_OF_TAGS) -- Set y to zero to look for objects on the ground
            for i, target in ipairs(targets) do
                -- Ignore hitting bumpers while flying through the air
                local tar_boat = target:GetCurrentPlatform()
                if target ~= nil and target ~= inst.components.complexprojectile.attacker and not target:HasTag("boatbumper") and (boat ~= tar_boat or boat == nil ) then
                    -- Remove and do splash damage if it hits a wall
                    if target:HasTag("wall") and target.components.health then
                        if not target.components.health:IsDead() then
                            inst.components.combat:DoAreaAttack(inst, CANNONBALL_SPLASH_RADIUS, nil, nil, nil, AREAATTACK_EXCLUDETAGS)
                            SpawnPrefab("cannonball_used").Transform:SetPosition(inst.Transform:GetWorldPosition())
                            inst:Remove()
                            return
                        end
                        -- Chop/knock down workable objects
                    elseif target.components.workable then
                        target.components.workable:Destroy(inst)
                    end

                    -- Do damage to entities with health - THIS IS THE FIX. SInce cannons dealt damage first, they'd kill walls, which would then fail the check in line 30.
                    if target.components.combat and GetTime() - target.components.combat.lastwasattackedtime > CANNONBALL_PASS_THROUGH_TIME_BUFFER then
                        target.components.combat:GetAttacked(inst, CANNONBALL_DAMAGE, nil)
                        if inst.components.complexprojectile.attacker ~= nil and inst.components.complexprojectile.attacker.components.combat ~= nil then
                            target.components.combat:SuggestTarget(inst.components.complexprojectile.attacker)
                        end
                    end
                end
            end

            local crabking = TheSim:FindEntities(x, 0, z, CANNONBALL_RADIUS * 1.5, { "crab" }, nil, MUST_ONE_OF_TAGS) -- slightly more forgiving radius for CK
            for i, target in ipairs(crabking) do
                if target ~= nil and target ~= inst.components.complexprojectile.attacker and not target:HasTag("boatbumper") then
                    if target.components.combat and GetTime() - target.components.combat.lastwasattackedtime > CANNONBALL_PASS_THROUGH_TIME_BUFFER then
                        target.components.combat:GetAttacked(inst, CANNONBALL_DAMAGE * 0.25, nil)
                    end
                end
            end
        end
    end
end)
