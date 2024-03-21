local env = env
GLOBAL.setfenv(1, GLOBAL)
local easing = require("easing")

env.AddStategraphPostInit("eyeofterror", function(inst)

local _OldAttackEvent = inst.events["charge"].fn
	inst.events["charge"].fn = function(inst)
        if not inst.components.health:IsDead()
                and not inst.components.freezable:IsFrozen()
                and not inst.components.sleeper:IsAsleep()
                and not inst.sg:HasStateTag("busy") then
			if inst.prefab == "eyeofterror" then
				if math.random() > .5 then
					inst.sg:GoToState("charge_pre", inst.components.combat.target)
				else
					inst.sg:GoToState("shoot_pre", inst.components.combat.target)
				end
			else
				local x, y, z = inst.Transform:GetWorldPosition()
				local twin = TheSim:FindEntities(x, y, z, 50, "eyeofterror")
				
				if twin ~= nil and #twin < 2 then
					if math.random() > .5 then
						inst.sg:GoToState("charge_pre", inst.components.combat.target)
					else
						inst.sg:GoToState("shoot_pre", inst.components.combat.target)
					end
				else
					if inst.canshoot ~= nil and inst.canshoot then
						if inst.prefab == "twinofterror1" then
							for i, v in ipairs(twin) do
								if v.prefab == "twinofterror2" then
									v.canshoot = false
								end
							end
						elseif inst.prefab == "twinofterror2" then
							for i, v in ipairs(twin) do
								if v.prefab == "twinofterror1" then
									v.canshoot = false
								end
							end
						end
						
						inst.canshoot = false
									
						inst.sg:GoToState("shoot_pre", inst.components.combat.target)
					else
						if inst.prefab == "twinofterror1" then
							for i, v in ipairs(twin) do
								if v.prefab == "twinofterror2" then
									v.canshoot = true
								end
							end
						elseif inst.prefab == "twinofterror2" then
							for i, v in ipairs(twin) do
								if v.prefab == "twinofterror1" then
									v.canshoot = true
								end
							end
						end
						
						inst.canshoot = true
						
						inst.sg:GoToState("charge_pre", inst.components.combat.target)
					end
				end
			end
        end
    end
	
local function ShootEye(inst, target)
	local x, y, z = inst.Transform:GetWorldPosition()
	
	local finaltarget = target or inst.components.combat.target
	
	if finaltarget ~= nil then
		local targetpos = finaltarget:GetPosition()
		
		local projectile = SpawnPrefab("eyeofterror_minieye_projectile")
		projectile.Transform:SetPosition(x, y, z)
		projectile.components.linearprojectile:SetHorizontalSpeed(20)
		projectile.components.linearprojectile:Launch(targetpos, inst, inst)
	end
end
	
local function SpawnLaser(inst)
    local numsteps = 20
    local x, y, z = inst.Transform:GetWorldPosition()
    local angle = (inst.Transform:GetRotation() + 90) * DEGREES
    local step = .75
    local offset = 2 - step --should still hit players right up against us
    local ground = TheWorld.Map
    local targets, skiptoss = {}, {}
    local i = -1
    local noground = false
    local fx, dist, delay, x1, z1
    while i < numsteps do
        i = i + 1
        dist = i * step + offset
        delay = math.max(0, i - 1.2)
        x1 = x + dist * math.sin(angle)
        z1 = z + dist * math.cos(angle)
        if not ground:IsPassableAtPoint(x1, 0, z1) then
            if i <= 0 then
                return
            end
            noground = true
        end
        fx = SpawnPrefab(i > 1 and "eyeofterror_laser" or "eyeofterror_laserempty")
        fx.caster = inst
        fx.Transform:SetPosition(x1, 0, z1)
        fx:Trigger(delay * FRAMES, targets, skiptoss)
        if i == 0 then
            ShakeAllCameras(CAMERASHAKE.FULL, .7, .02, .6, fx, 30)
        end
        --if noground then
        --    break
        --end
        --TODO: Change the fx on land
    end

    if i < numsteps then
        dist = (i + .5) * step + offset
        x1 = x + dist * math.sin(angle)
        z1 = z + dist * math.cos(angle)
    end
    fx = SpawnPrefab("eyeofterror_laser")
    fx.Transform:SetPosition(x1, 0, z1)
    fx:Trigger((delay + 1) * FRAMES, targets, skiptoss)

    fx = SpawnPrefab("eyeofterror_laser")
    fx.Transform:SetPosition(x1, 0, z1)
    fx:Trigger((delay + 2) * FRAMES, targets, skiptoss)
end

local function ShootProjectile(inst, target)
	local finaltarget = target or inst.components.combat.target
	
	if finaltarget ~= nil then
		local x, y, z = inst.Transform:GetWorldPosition()
		local projectile = SpawnPrefab("eyeofterror_fireball")
		projectile.Transform:SetPosition(x, y, z)
		local a, b, c = finaltarget.Transform:GetWorldPosition()
		local targetpos = finaltarget:GetPosition()
		targetpos.x = targetpos.x + math.random(-1,1)
		targetpos.z = targetpos.z + math.random(-1,1)
		local dx = (a ~= nil and a or targetpos.x) - x
		local dz = (c ~= nil and c or targetpos.z) - z
		local rangesq = dx * dx + dz * dz
		local maxrange = 20
		local bigNum = 15
		local speed = easing.linear(rangesq, bigNum, 3, maxrange * maxrange * 2)
		projectile:AddTag("canthit")
		
		projectile.components.complexprojectile:SetLaunchOffset(Vector3(3, 2.5, 0))
		--projectile.components.wateryprotection.addwetness = TUNING.WATERBALLOON_ADD_WETNESS/2
		projectile.components.complexprojectile:SetHorizontalSpeed(speed+math.random(4,9))
		projectile.components.complexprojectile:SetGravity(-45)
		projectile.components.complexprojectile:Launch(targetpos, inst, inst)
	end
end

local function get_rng_cooldown(cooldown)
    return GetRandomWithVariance(cooldown, cooldown/3)
end

local states = {

    State {
        name = "shoot_pre",
        tags = {"busy", "canrotate", "charge"},

        onenter = function(inst, target)
            inst.Physics:Stop()

            local cooldown = (inst.sg.mem.transformed and inst._cooldowns.mouthcharge)
                or inst._cooldowns.charge
            inst.components.timer:StartTimer("charge_cd", get_rng_cooldown(cooldown))
			
            inst.sg.statemem.target = target

            inst.AnimState:PlayAnimation("charge_pre")

            -- All users of this SG share this sound.
            inst.SoundEmitter:PlaySound("terraria1/eyeofterror/charge_pre_sfx")
            inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/charge")
			
			local x, y, z = inst.Transform:GetWorldPosition()
			local chargepulse = SpawnPrefab("eyeofterror_chargepulse")
			chargepulse.Transform:SetPosition(x, 0, z)
			
			if inst.prefab == "twinofterror1" then
				chargepulse.AnimState:SetMultColour(1, 0.3, 0.3, 1)
				chargepulse.Light:SetColour(76.5/255, 255/255, 76.5/255)
			elseif inst.prefab == "twinofterror2" then
				chargepulse.AnimState:SetMultColour(0.3, 1, 0.3, 1)
				chargepulse.Light:SetColour(30/255, 255/255, 30/255)
			end
			
        end,

        onupdate = function(inst)
            local target = inst.sg.statemem.target
            if target and target:IsValid() then
                inst:ForceFacePoint(target.Transform:GetWorldPosition())
            end
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.sg.mem.transformed then
					if inst.prefab == "eyeofterror" then
						inst.sg.mem.mouthcharge_count = 2
					else
						inst.sg.mem.mouthcharge_count = math.random(3, 5)
					end
					
                    inst.sg:GoToState("mouthshoot_loop", inst.sg.statemem.target)
                else
                    inst.sg:GoToState("shoot_loop", inst.sg.statemem.target)
                end
            end),
        },
    },
	
	
    State {
        name = "shoot_loop",
        tags = {"busy", "canrotate", "charge"},

        onenter = function(inst, target)
            inst.components.locomotor:Stop()
            inst.components.locomotor:EnableGroundSpeedMultiplier(false)

            inst.AnimState:PlayAnimation("charge_loop")--, true)
            inst.SoundEmitter:PlaySound(inst._soundpath .. "charge_eye")
			
            --inst.Physics:SetMotorVelOverride(inst._chargedata.eyechargespeed, 0, 0)

            --inst.sg:SetTimeout(inst._chargedata.eyechargetimeout)
            inst.sg.statemem.target = target
        end,
		
		timeline =
        {
			TimeEvent(0, function(inst) 
				if inst.prefab == "twinofterror1" then
					inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/laser")
					SpawnLaser(inst)
				elseif inst.prefab == "twinofterror2" then
					ShootProjectile(inst, inst.sg.statemem.target)
				end
			end),
			TimeEvent(3*FRAMES, function(inst)
				if inst.prefab == "twinofterror2" then
					ShootProjectile(inst, inst.sg.statemem.target)
				end
			end),
			TimeEvent(6*FRAMES, function(inst)
				if inst.prefab == "eyeofterror" then
					ShootEye(inst, inst.sg.statemem.target)
					inst.SoundEmitter:PlaySound(inst._soundpath .. "charge_eye")
				elseif inst.prefab == "twinofterror2" then
					ShootProjectile(inst, inst.sg.statemem.target)
				end
			end),
			TimeEvent(9*FRAMES, function(inst)
				if inst.prefab == "twinofterror2" then
					ShootProjectile(inst, inst.sg.statemem.target)
				end
			end),
        },
		
        onupdate = function(inst)
            local target = inst.sg.statemem.target
            if target and target:IsValid() then
                inst:ForceFacePoint(target.Transform:GetWorldPosition())
            end
        end,

        events =
        {
            EventHandler("animover", function(inst)
				inst.sg:GoToState("shoot_pst")
            end),
        },
    },

    State {
        name = "mouthshoot_loop",
        tags = {"busy", "canrotate", "charge"},

        onenter = function(inst, target)

            inst.SoundEmitter:PlaySound(inst._soundpath .. "charge")

            inst.AnimState:PlayAnimation("charge_loop")

            if target == nil or not target:IsValid() then
                inst.components.combat:TryRetarget()
                target = inst.components.combat.target
            end

            inst.sg.statemem.target = target
        end,
		
		timeline =
        {
			TimeEvent(0, function(inst)
				if inst.prefab == "twinofterror1" then
					inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/laser")
					SpawnLaser(inst)
				elseif inst.prefab == "twinofterror2" then
					ShootProjectile(inst, inst.sg.statemem.target)
				end
			end),
			TimeEvent(3*FRAMES, function(inst)
				if inst.prefab == "twinofterror2" then
					ShootProjectile(inst, inst.sg.statemem.target)
				end
			end),
			TimeEvent(6*FRAMES, function(inst)
				if inst.prefab == "eyeofterror" then
					inst.SoundEmitter:PlaySound(inst._soundpath .. "charge")
					ShootEye(inst, inst.sg.statemem.target)
				elseif inst.prefab == "twinofterror2" then
					ShootProjectile(inst, inst.sg.statemem.target)
				end
			end),
			TimeEvent(9*FRAMES, function(inst)
				if inst.prefab == "twinofterror2" then
					ShootProjectile(inst, inst.sg.statemem.target)
				end
			end),
        },
		
        onupdate = function(inst)
            local target = inst.sg.statemem.target
            if target and target:IsValid() then
                inst:ForceFacePoint(target.Transform:GetWorldPosition())
            end
        end,

        events =
        {
            EventHandler("animover", function(inst)
            inst.sg.mem.mouthcharge_count = (inst.sg.mem.mouthcharge_count == nil and 0)
                or inst.sg.mem.mouthcharge_count - 1
				
				
                if inst.sg.mem.mouthcharge_count ~= nil and inst.sg.mem.mouthcharge_count > 0 then
					inst.sg:GoToState("mouthshoot_loop")
				else
					inst.sg:GoToState("shoot_pst")
				end
            end),
        },
    },

    State {
        name = "shoot_pst",
        tags = {"busy", "canrotate", "charge"},

        onenter = function(inst, target)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("charge_pst")

            -- All users of this SG share this sound.
            inst.SoundEmitter:PlaySound("terraria1/eyeofterror/charge_pst_sfx")

            inst.sg.statemem.target = target
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if math.random() < inst._chargedata.tauntchance then
                    -- Try a target switch after finishing a charge move
                    inst.components.combat:DropTarget()

                    inst.sg:GoToState("taunt")
                else
                    inst.sg:GoToState("idle")
                end
            end),
        },
    },
	
    State {
        name = "shoot_attack",
        tags = {"busy", "canrotate", "charge"},

        onenter = function(inst, target)
            inst.Physics:Stop()
			
            inst.sg.statemem.target = target

            inst.AnimState:PlayAnimation("shoot")

            -- All users of this SG share this sound.
            inst.SoundEmitter:PlaySound("terraria1/eyeofterror/charge_pre_sfx")
            inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/charge")
        end,

        onupdate = function(inst)
            local target = inst.sg.statemem.target
            if target and target:IsValid() then
                inst:ForceFacePoint(target.Transform:GetWorldPosition())
            end
        end,

        timeline =
        {
            TimeEvent(11 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/laser")
                SpawnLaser(inst)
            end),
        },

        events =
        {
            EventHandler("animover", function(inst)
				inst.sg:GoToState("idle", inst.sg.statemem.target)
            end),
        },
    },
}
--[[
for k, v in pairs(events) do
    assert(v:is_a(EventHandler), "Non-event added in mod events table!")
    inst.events[v.name] = v
end]]

for k, v in pairs(states) do
    assert(v:is_a(State), "Non-state added in mod state table!")
    inst.states[v.name] = v
end

end)