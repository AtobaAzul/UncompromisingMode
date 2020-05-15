local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
--Treeguard now has AOE - Axe
env.AddPrefabPostInit("leif_sparse", function (inst)
    if inst.components.combat ~= nil then
		local function isnottree(ent)
			if ent ~= nil and not ent:HasTag("leif") then -- fix to friendly AOE: refer for later AOE mobs -Axe
				return true
			end
		end
        inst.components.combat:SetAreaDamage(TUNING.DEERCLOPS_AOE_RANGE/2, TUNING.DEERCLOPS_AOE_SCALE, isnottree) -- you can edit these values to your liking -Axe
    end         

	if inst.components.lootdropper ~= nil then
		inst.components.lootdropper:SetLoot({"livinglog", "livinglog", "livinglog", "livinglog", "livinglog", "livinglog", "plantmeat"})
	end
                            
end)
--Treeguard now has single target root attack -Axe
env.AddPrefabPostInit("leif_sparse", function (inst)

--inst.scaleleif = nil

--local function SetLeifScale(inst, scale)
   -- inst._scale = scale ~= 1 and scale or nil

   -- inst.Transform:SetScale(scale, scale, scale)
   -- inst.Physics:SetCapsule(.5 * scale, 1)
   -- inst.DynamicShadow:SetSize(4 * scale, 1.5 * scale)

   -- inst.components.locomotor.walkspeed = 1.5 * scale

   -- inst.components.combat:SetDefaultDamage(TUNING.LEIF_DAMAGE * scale)
   -- inst.components.combat:SetRange(3 * scale)

   -- local health_percent = inst.components.health:GetPercent()
   -- inst.components.health:SetMaxHealth(TUNING.LEIF_HEALTH * scale)
    --inst.components.health:SetPercent(health_percent, true)
	--inst.scaleleif = scale
--end

env.AddComponentPostInit("wisecracker", function(self, inst)

self.inst = inst

	inst:ListenForEvent("rooting", function(inst, data)
        inst.components.talker:Say(GetString(inst, "ANNOUNCE_ROOTING"))
    end)

	
end)




inst.rootready = true
if inst.components.combat ~= nil and inst.components.combat.attackrange ~= nil then
inst.oldrange = inst.components.combat.attackrange
inst.components.combat:SetRange(3*inst.oldrange)
end

local prefabs = {
    "rootspike",
}

local SNARE_OVERLAP_MIN = 1
local SNARE_OVERLAP_MAX = 3
local SNARE_TAGS = { "_combat", "locomotor" }
local SNARE_NO_TAGS = { "flying", "ghost", "playerghost", "tallbird", "fossil", "shadow", "shadowminion", "INLIMBO", "epic", "smallcreature" }
local SNARE_MAX_TARGETS = 20

inst:AddComponent("timer")
   
local function NoSnareOverlap(x, z, r)
			return #TheSim:FindEntities(x, 0, z, r or SNARE_OVERLAP_MIN, { "rootspike", "groundspike" }) <= 0
end	

local function FindSnareTargets(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local targets = {}
    local priorityindex = 1
    local priorityindex2 = 1
    local ents = TheSim:FindEntities(x, y, z, TUNING.STALKER_SNARE_RANGE, SNARE_TAGS, SNARE_NO_TAGS)
    for i, v in ipairs(ents) do
        if not (v.components.health ~= nil and v.components.health:IsDead()) then
            if v:HasTag("player") then
            elseif v.components.combat:TargetIs(inst) then
                table.insert(targets, priorityindex2, v)
                priorityindex2 = priorityindex2 + 1
            else
                table.insert(targets, v)
            end
            if #targets >= SNARE_MAX_TARGETS then
                return targets
            end
        end
    end
    return #targets > 0 and targets or nil
end

local function SpawnSnare(inst, target)
-- find target position
    local x, y, z = target.Transform:GetWorldPosition()
    local islarge = target:HasTag("largecreature")
    local r = target:GetPhysicsRadius(0) + (islarge and 1.5 or .5)
    local num = islarge and 12 or 6
	
	
	local vars = { 1, 2, 3, 4, 5, 6, 7 }
    local used = {}
    local queued = {}
    local count = 0
    local dtheta = PI * 2 / num
    local thetaoffset = math.random() * PI * 2
    local delaytoggle = 0
    local map = TheWorld.Map
    for theta = math.random() * dtheta, PI * 2, dtheta do
        local x1 = x + r * math.cos(theta)
        local z1 = z + r * math.sin(theta)
        if map:IsPassableAtPoint(x1, 0, z1) and not map:IsPointNearHole(Vector3(x1, 0, z1)) then
            local spike = SpawnPrefab("rootspike")
            spike.Transform:SetPosition(x1, 0, z1)

            local delay = delaytoggle == 0 and 0 or .2 + delaytoggle * math.random() * .2
            delaytoggle = delaytoggle == 1 and -1 or 1

            local duration = GetRandomWithVariance(TUNING.STALKER_SNARE_TIME, TUNING.STALKER_SNARE_TIME_VARIANCE)

            local variation = table.remove(vars, math.random(#vars))
            table.insert(used, variation)
            if #used > 3 then
                table.insert(queued, table.remove(used, 1))
            end
            if #vars <= 0 then
                local swap = vars
                vars = queued
                queued = swap
            end

            spike:RestartSpike(delay, duration, variation)
            count = count + 1
        end
    end
    if count <= 0 then
        return false
    elseif target:IsValid() then
        if target.components.talker then
            target:PushEvent("rooting", { attacker = inst })
		end
    end
    return true
end



        inst.FindSnareTargets = FindSnareTargets
        inst.SpawnSnare = SpawnSnare
end)