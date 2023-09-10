require("stategraphs/commonstates")

local actionhandlers =
{
    ActionHandler(ACTIONS.GOHOME, "action"),
}


    local SLEEPREPEL_MUST_TAGS = { "_combat" }
    local SLEEPREPEL_CANT_TAGS = { "player", "companion", "shadow", "playerghost", "INLIMBO", "wixieshoved", "invisible",
        "hiding", "NOTARGET", "flight", "toadstool" }

local function Check_ChargingButItsBowling(inst,v) --I'll steal it, and noone will ever know. (Credit to Scrimbles for Shove)
	if inst ~= nil then
	SpawnPrefab("round_puff_fx_sm").Transform:SetPosition(v.Transform:GetWorldPosition())

	if v.components.combat ~= nil then
		v.components.combat:GetAttacked(inst, 0)
	end

	if v.components.locomotor ~= nil and not v:HasTag("stageusher") then
		for i = 1, 50 do
			v:DoTaskInTime((i - 1) / 50, function(v)
				if v ~= nil and inst ~= nil then
					local x, y, z = inst.Transform:GetWorldPosition()
					local tx, ty, tz = v.Transform:GetWorldPosition()

					local rad = math.rad(inst:GetAngleToPoint(tx, ty, tz))
					local velx = math.cos(rad)  --* 4.5
					local velz = -math.sin(rad) --* 4.5

					local giantreduction = v:HasTag("epic") and 1.5 or v:HasTag("smallcreature") and 0.8 or 1
					local cursemultiplier = v:HasDebuff("wixiecurse_debuff") and 1.75 or 1.25
					local shovevalue = inst:HasTag("troublemaker") and 3 or 2

					local dx, dy, dz =
						tx + (((shovevalue / (i + 3)) * velx) / giantreduction) * cursemultiplier, ty,
						tz + (((shovevalue / (i + 3)) * velz) / giantreduction) * cursemultiplier
					local ground = TheWorld.Map:IsPassableAtPoint(dx, dy, dz)
					local boat = TheWorld.Map:GetPlatformAtPoint(dx, dz)
					local ocean_collision = TheWorld.Map:IsOceanAtPoint(dx, dy, dz)
					local on_water = nil

					if TUNING.DSTU.ISLAND_ADVENTURES then
						on_water = IsOnWater(dx, dy, dz)
					end

					if not (v.sg ~= nil and (v.sg:HasStateTag("swimming") or v.sg:HasStateTag("invisible"))) then
						if v ~= nil and dx ~= nil and (ground or boat or ocean_collision and v.components.locomotor:CanPathfindOnWater() or v.components.tiletracker ~= nil and not v:HasTag("whale")) then
							if not v:HasTag("aquatic") and not on_water or v:HasTag("aquatic") and on_water then
								--[[if ocean_collision and v.components.amphibiouscreature and not v.components.amphibiouscreature.in_water then
									v.components.amphibiouscreature:OnEnterOcean()
								end]]
								v.Transform:SetPosition(dx, dy, dz)
							end
						end
					end


				end
			end)
		end
	end
end
end
	
	
local function canteleport(inst)
    return not (inst.sg:HasStateTag("attack") or inst.sg:HasStateTag("hit")
        or inst.sg:HasStateTag("teleporting") or inst.sg:HasStateTag("noattack")
        or inst.components.health:IsDead())
end

local function PinCharacter(player)
	player.components.locomotor:Stop()
	player:ClearBufferedAction()
	player.components.inventory:Hide()
	player:PushEvent("ms_closepopups")
	if player.components.playercontroller ~= nil then
		player.components.playercontroller:EnableMapControls(false)
		player.components.playercontroller:Enable(false)
	end
	--player.AnimState:PlayAnimation("distress_loop", true)
end

local function ToggleOnPhysics(inst)
    inst.sg.statemem.isphysicstoggle = nil
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.WORLD)
    inst.Physics:CollidesWith(COLLISION.OBSTACLES)
    inst.Physics:CollidesWith(COLLISION.SMALLOBSTACLES)
    inst.Physics:CollidesWith(COLLISION.CHARACTERS)
    inst.Physics:CollidesWith(COLLISION.GIANTS)
end

local function AttachPin(inst,pinned)
	if pinned:HasTag("character") then
		pinned:DoTaskInTime(0.2,PinCharacter)

		inst.pinstandin = SpawnPrefab("um_simple_dummyplayer") --Can't make the Player itself follow the symbol, sadly, trying to upin actually seperates the client from the server in a way.... Ask me (Axe) for more details
		inst.pinstandin.components.skinner:CopySkinsFromPlayer(pinned)
		inst.pinstandin.entity:AddFollower()
		inst.pinstandin.Transform:SetPosition(inst.Transform:GetWorldPosition())
		inst.pinstandin.Follower:FollowSymbol(inst.GUID, "pinpoint", 0, 0, 0)

		--pinned.entity:AddFollower()
		--pinned.Follower:FollowSymbol(inst.GUID, "pinpoint", 0, 0, 0)
		inst.pinstandin.AnimState:PlayAnimation("distress_loop",true)
		pinned:Hide()
		inst.pintask = inst:DoPeriodicTask(FRAMES,function(inst) 
			if inst.pinman then
				inst.pinman.Transform:SetPosition(inst.Transform:GetWorldPosition()) 
			else
				inst.pintask:Cancel()
				inst.pintask = nil
			end
		end)
	end
end

local function UnPinCharacter(inst,pinned)

	if inst.pinstandin then
		inst.pinstandin.Follower:StopFollowing()
		inst:RemoveChild(inst.pinstandin)
		inst.pinstandin:Remove()
		inst.pinstandin = nil
	end
	--pinned.Follower:StopFollowing()
	--pinned.gluepoint = SpawnPrefab("um_simple_referencepoint")
	--pinned.gluepoint.dontdelete = true
	--pinned.gluepoint.Transform:SetPosition(inst.Transform:GetWorldPosition())
	--pinned.gluepoint.entity:SetParent(pinned.entity)
	--pinned.Follower:FollowSymbol(pinned.gluepoint.GUID,"", 0, 0, 0)
	pinned:Show()
	
	pinned.Transform:SetPosition(inst.Transform:GetWorldPosition())
	--pinned:DoPeriodicTask(FRAMES,function(pinned) pinned.Traonsform:SetPosition(pinned.Transform:GetWorldPosition()) end)
	if pinned.components.playercontroller ~= nil then
		pinned.components.playercontroller:ResetRemoteController()
		ToggleOnPhysics(pinned)
		pinned.components.locomotor:OnEntityWake()
		SerializeUserSession(pinned)
		pinned.components.playercontroller:EnableMapControls(true)
		pinned.components.playercontroller:Enable(true)
	end
	inst.pinman = nil
end

local function ChargerCheck(inst)
	local x,y,z = inst.Transform:GetWorldPosition()	
	local ents = TheSim:FindEntities(x,y,z,2,{"_combat"},{"structure","charger_knocked"})
	if ents then
		for i,v in ipairs(ents) do
			if not v:HasTag("charger_knocked") and not (inst.pinman and v == inst.pinman) and v.components.health and not v.components.health:IsDead() then
				v.components.combat:GetAttacked(inst, 40) --Need Planar Compat!
				if v:HasTag("character") and not inst.pinman then
					inst.pinman = v
					AttachPin(inst,inst.pinman)
				else
					if v:HasTag("character") or v.prefab == "pigman" then --Add things that can be knockedback in here
						local ref = SpawnPrefab("um_simple_referencepoint")
						ref.Transform:SetPosition(inst.Transform:GetWorldPosition())
						v:PushEvent("knockback", {knocker = ref, radius = 10, strengthmult = 10})
					else
						Check_ChargingButItsBowling(inst,v)
					end
				end
				v:AddTag("charger_knocked")
				v:DoTaskInTime(2,function(v) v:RemoveTag("charger_knocked") end)
			end
		end
	end
end

local function ArtificialLocomote(inst, destination, speed) --Locomotor is basically running a similar code anyhow, this bypasses any physics interactions preventing
	if destination and speed then --our locomote from working... Inconsistencies in when the entity is supposed to walk forward led to this.
		speed = speed * FRAMES
		local hypoten = math.sqrt(inst:GetDistanceSqToPoint(destination))
		local x, y, z = inst.Transform:GetWorldPosition()
		local x_final, y_final, z_final
		local speedmult = inst.components.locomotor ~= nil and inst.components.locomotor:GetSpeedMultiplier() or 1
		x_final = ((destination.x - x) / hypoten) * (speed * speedmult) + x
		z_final = ((destination.z - z) / hypoten) * (speed * speedmult) + z

		inst.Transform:SetPosition(x_final, y, z_final)
	end
end

local function FindFarLandingPoint(inst, destination) --This makes the geese aim for a point behind the player instead of where the player is at.
	if destination then --If it aimed directly at the player, it'll do something similar to the bugged version.
		inst.chargePoint = destination
		local hypoten = math.sqrt(inst:GetDistanceSqToPoint(destination))
		local x, y, z = inst.Transform:GetWorldPosition()
		local x_far, z_far
		x_far = ((destination.x - x) / hypoten) * 20 + x --20 is arbitrary, another number could be used if desired, if it is low enough it may make m/goose undershoot the player too.
		z_far = ((destination.z - z) / hypoten) * 20 + z
		inst.chargePoint.x = x_far
		inst.chargePoint.z = z_far
	end
end

local events =
{
    EventHandler("attacked", function(inst)
        if not (inst.sg:HasStateTag("attack") or inst.sg:HasStateTag("hit") or inst.sg:HasStateTag("noattack") or inst.components.health:IsDead()) then
            inst.sg:GoToState("hit")
        end
    end),
    EventHandler("death", function(inst) inst.sg:GoToState("death") end),
    EventHandler("doattack", function(inst, data)
        if not (inst.sg:HasStateTag("busy") or inst.components.health:IsDead() or inst.sg:HasStateTag("pummel")) then
			if inst.prefab == "gripping_charger" then
				inst.sg:GoToState("charge",data.target)
			else
				inst.sg:GoToState("attack", data.target)
			end
        end
    end),

    CommonHandlers.OnLocomote(false, true),
}

local function FinishExtendedSound(inst, soundid)
    inst.SoundEmitter:KillSound("sound_"..tostring(soundid))
    inst.sg.mem.soundcache[soundid] = nil
    if inst.sg.statemem.readytoremove and next(inst.sg.mem.soundcache) == nil then
        inst:Remove()
    end
end

local function PlayExtendedSound(inst, soundname)
    if inst.sg.mem.soundcache == nil then
        inst.sg.mem.soundcache = {}
        inst.sg.mem.soundid = 0
    else
        inst.sg.mem.soundid = inst.sg.mem.soundid + 1
    end
    inst.sg.mem.soundcache[inst.sg.mem.soundid] = true
    inst.SoundEmitter:PlaySound(inst.sounds[soundname], "sound_"..tostring(inst.sg.mem.soundid))
    inst:DoTaskInTime(5, FinishExtendedSound, inst.sg.mem.soundid)
end

local function OnAnimOverRemoveAfterSounds(inst)
    if inst.sg.mem.soundcache == nil or next(inst.sg.mem.soundcache) == nil then
        inst:Remove()
    else
        inst:Hide()
        inst.sg.statemem.readytoremove = true
    end
end

local states =
{
    State{
        name = "idle",
        tags = { "idle", "canrotate" },

        onenter = function(inst)
            if inst.wantstodespawn then
                local t = GetTime()
                if t > inst.components.combat:GetLastAttackedTime() + 5 then
                    local target = inst.components.combat.target
                    if target == nil or
                        target.components.combat == nil or
                        not target.components.combat:IsRecentTarget(inst) or
                        t > (target.components.combat.laststartattacktime or 0) + 5 then
                        inst.sg:GoToState("disappear")
                        return
                    end
                end
            end

            inst.components.locomotor:StopMoving()
            if not inst.AnimState:IsCurrentAnimation("idle_loop") then
                inst.AnimState:PlayAnimation("idle_loop", true)
            end
        end,
    },

    State{
        name = "attack",
        tags = { "attack", "busy" },

        onenter = function(inst, target)
            inst.sg.statemem.target = target
            inst.Physics:Stop()
            inst.components.combat:StartAttack()
            inst.AnimState:PlayAnimation("atk_pre")
            inst.AnimState:PushAnimation("atk", false)
            PlayExtendedSound(inst, "attack_grunt")
        end,

        timeline =
        {
            TimeEvent(14*FRAMES, function(inst) PlayExtendedSound(inst, "attack") end),
            TimeEvent(16*FRAMES, function(inst) inst.components.combat:DoAttack(inst.sg.statemem.target) end),
        },

        events =
        {
            EventHandler("animqueueover", function(inst)
                if math.random() < .333 then
                    inst.components.combat:SetTarget(nil)
                    inst.sg:GoToState("taunt")
                else
                    inst.sg:GoToState("idle")
                end
            end),
        },
    },

   State{
        name = "charge",
        tags = { "attack", "busy" },

        onenter = function(inst, target)
            inst.sg.statemem.target = target
            inst.Physics:Stop()
            inst.components.combat:StartAttack()
            --inst.AnimState:PlayAnimation("atk_pre")
            inst.AnimState:PlayAnimation("charge_loop", true)
            PlayExtendedSound(inst, "attack_grunt")
			FindFarLandingPoint(inst, inst.components.combat.target:GetPosition())
        end,

        timeline =
        {
            TimeEvent(14*FRAMES, function(inst) PlayExtendedSound(inst, "attack") end),
            --TimeEvent(16*FRAMES, function(inst) inst.components.combat:DoAttack(inst.sg.statemem.target) end),
        },
		onupdate = function(inst)
			ChargerCheck(inst)
			if inst.chargePoint and inst:GetDistanceSqToPoint(inst.chargePoint) > 2^2 then	
				ArtificialLocomote(inst, inst.chargePoint, 15)
			else
				if inst.pinman then
					inst.sg:GoToState("pummel_loop")
				else
					inst.sg:GoToState("idle")
				end
			end
		end,
        --[[events =
        {
            EventHandler("animqueueover", function(inst)
                if math.random() < .333 then
                    inst.components.combat:SetTarget(nil)
                    inst.sg:GoToState("taunt")
                else
                    inst.sg:GoToState("idle")
                end
            end),
        },]]
    },
	
   State{
        name = "pummel_loop",
        tags = { "attack", "busy","pummel" },

        onenter = function(inst)
            inst.Physics:Stop()
            --inst.AnimState:PlayAnimation("atk_pre")
            inst.AnimState:PlayAnimation("grabbed_loop", false)
			for i = 1,math.random(1,2) do
				inst.AnimState:PushAnimation("grabbed_loop", false)
			end
			if inst.pinman and inst.pinman:HasTag("character") then
				inst.pinstandin.AnimState:PlayAnimation("distress_loop",true)
			end
            --PlayExtendedSound(inst, "attack_grunt")
        end,

        timeline =
        {
            TimeEvent(14*FRAMES, function(inst) PlayExtendedSound(inst, "attack") end),
            --TimeEvent(16*FRAMES, function(inst) inst.components.combat:DoAttack(inst.sg.statemem.target) end),
        },
		onupdate = function(inst)
			--[[if not inst.pinman then
				inst.sg:GoToState("idle")
			end]]
		end,
        events =
		{
            EventHandler("animqueueover", function(inst)
				if inst.pinman then
					inst.sg:GoToState("pummel_smash")
				else
					inst.sg:GoToState("idle")
				end
            end),
        },
    },
   State{
        name = "pummel_smash",
        tags = { "attack", "busy","pummel" },

        onenter = function(inst)
            inst.Physics:Stop()
            --inst.AnimState:PlayAnimation("atk_pre")
            inst.AnimState:PlayAnimation("grabbed_smash", false)
			if inst.pinman and inst.pinman:HasTag("character") then
				inst.pinstandin.AnimState:PlayAnimation("distress_loop",true)
			end
        end,

        timeline =
        {
            TimeEvent(14*FRAMES, function(inst) PlayExtendedSound(inst, "attack") end),
            TimeEvent(23*FRAMES, function(inst)
				if inst.pinman and inst.pinman.components.combat and inst.pinman.components.health then
					local pinned = inst.pinman
					pinned.components.combat:GetAttacked(inst,40)
					if pinned.components.health:IsDead() then
						if pinned:HasTag("character") then
							UnPinCharacter(inst,pinned)
						end
					else	
						if inst.pinman:HasTag("character") then
							inst.pinstandin:DoTaskInTime(0,function(player) player.AnimState:PlayAnimation("buck_pst")
								player:DoTaskInTime(0.5,function(player) player.AnimState:PlayAnimation("distress_loop",true) end)
							end)
							
						end
					end
				end
			end),
        },
		onupdate = function(inst)
			if not inst.pinman then
				inst.sg:GoToState("idle")
			end
		end,
        events =
		{
            EventHandler("animqueueover", function(inst)
				if inst.pinman and inst.pinman.components.health and not inst.pinman.components.health:IsDead() then
					inst.sg:GoToState("pummel_loop")
				else
					inst.sg:GoToState("idle")
				end
            end),
        },
    },	
    State{
        name = "hit",
        tags = { "busy", "hit" },

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("disappear")
        end,

        events =
        {
            EventHandler("animover", function(inst)
                local max_tries = 4
                for k = 1, max_tries do
                    local x, y, z = inst.Transform:GetWorldPosition()
                    local offset = 10
                    x = x + math.random(2 * offset) - offset
                    z = z + math.random(2 * offset) - offset
                    if TheWorld.Map:IsPassableAtPoint(x, y, z) then
                        inst.Physics:Teleport(x, y, z)
                        break
                    end
                end

                inst.sg:GoToState("appear")
            end),
        },
    },

    State{
        name = "taunt",
        tags = { "busy" },

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("taunt")
            PlayExtendedSound(inst, "taunt")
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State{
        name = "appear",
        tags = { "busy" },

        onenter = function(inst)
            inst.AnimState:PlayAnimation("appear")
            inst.Physics:Stop()
            PlayExtendedSound(inst, "appear")
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end)
        },
    },

    State{
        name = "death",
        tags = { "busy" },

        onenter = function(inst)
            PlayExtendedSound(inst, "death")
            inst.AnimState:PlayAnimation("disappear")
            inst.Physics:Stop()
            RemovePhysicsColliders(inst)
            inst.components.lootdropper:DropLoot(inst:GetPosition())
            inst:AddTag("NOCLICK")
            inst.persists = false
        end,

        events =
        {
            EventHandler("animover", OnAnimOverRemoveAfterSounds),
        },

        onexit = function(inst)
            inst:RemoveTag("NOCLICK")
        end
    },

    State{
        name = "disappear",
        tags = { "busy", "noattack" },

        onenter = function(inst)
            PlayExtendedSound(inst, "death")
            inst.AnimState:PlayAnimation("disappear")
            inst.Physics:Stop()
            inst:AddTag("NOCLICK")
            inst.persists = false
        end,

        events =
        {
            EventHandler("animover", OnAnimOverRemoveAfterSounds),
        },

        onexit = function(inst)
            inst:RemoveTag("NOCLICK")
        end,
    },

    State{
        name = "action",
        onenter = function(inst, playanim)
            inst.Physics:Stop()
            inst:PerformBufferedAction()
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },
}
CommonStates.AddWalkStates(states)

return StateGraph("night_terror_charger", states, events, "idle", actionhandlers)
