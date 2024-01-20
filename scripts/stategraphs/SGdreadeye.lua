require("stategraphs/commonstates")

local actionhandlers =
{
    ActionHandler(ACTIONS.GOHOME, "action"),
}

local events =
{
    EventHandler("attacked", function(inst)
        if not (inst.sg:HasStateTag("attack") or inst.sg:HasStateTag("hit") or inst.sg:HasStateTag("noattack") or inst.components.health:IsDead()) then
            inst.sg:GoToState("hit")
        end
    end),
    EventHandler("death", function(inst) inst.sg:GoToState("death") end),
    EventHandler("doattack", function(inst, data)
        if not (inst.sg:HasStateTag("busy") or inst.components.health:IsDead()) then
            inst.sg:GoToState("attack_teleport_pre", data.target)
        end
    end),
	
    EventHandler("locomote", function(inst) 
	
		local target = inst.components.combat:HasTarget() and inst.components.combat.target or 
								inst.mytarget ~= nil and inst.mytarget or
								inst.disguisetarget ~= nil and inst.disguisetarget or
								inst.spawnedforplayer ~= nil and inst.spawnedforplayer or
								nil
		if target and target:IsValid() and inst:IsValid() and not inst:IsNear(target, inst.components.combat.attackrange - 1) then
			if not (inst.sg:HasStateTag("busy") or inst.components.health:IsDead()) then
				inst.sg:GoToState("teleport_to", target)
			end
		end
	end),
	
    --CommonHandlers.OnLocomote(false, true),
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

local function SpikeAoE(inst)
    local target = inst.components.combat.target
    local target_index = {}
    local found_targets = {}
    local ix, iy, iz = inst.Transform:GetWorldPosition()
    local spike_num = 4
    local ring_num = 6
    local rad = math.random(0, 2*math.pi)
    inst.SoundEmitter:PlaySound("dontstarve/common/shadowTentacleAttack_1")
    inst.SoundEmitter:PlaySound("dontstarve/common/shadowTentacleAttack_2")

    local fx1 = SpawnPrefab("uncompromising_shadow_projectile1_fx")
    fx1.Transform:SetPosition(ix, iy, iz)
    inst:DoTaskInTime(1.2, function()
        inst.SoundEmitter:PlaySound("dontstarve/sanity/creature2/attack")
        local ents = TheSim:FindEntities(ix, iy, iz, 1.2, nil, { "FX", "NOCLICK", "INLIMBO", "shadowdominant" })
        for k,v in ipairs(ents) do
            if not target_index[v] and v ~= inst and inst.components.combat:IsValidTarget(v) and v.components.combat and ((v.components.sanity and v.components.sanity:IsInsane()) or v == target) then
                target_index[v] = true
                v.components.combat:GetAttacked(inst, TUNING.DSTU.DREADEYE_DAMAGE * 0.8)
            end
        end
    end)

    for i = 2,ring_num do -- ring
        inst:DoTaskInTime(FRAMES * i * 3, function()
            for j = 1,spike_num do -- spike
                local rad2 = rad + (math.pi * 2 * (j / spike_num))
                local velx = math.cos(rad2)
                local velz = -math.sin(rad2)
                local dx, dy, dz = ix + (i * velx), 0, iz + (i * velz)
                local fx1 = SpawnPrefab("uncompromising_shadow_projectile1_fx")
                fx1.Transform:SetPosition(dx, dy, dz)
                inst:DoTaskInTime(1.2, function()
                    inst.SoundEmitter:PlaySound("dontstarve/sanity/creature2/attack")
                    local ents = TheSim:FindEntities(dx, dy, dz, 1.2, nil, { "FX", "NOCLICK", "INLIMBO" })
                    for k,v in ipairs(ents) do
                        if not target_index[v] and v ~= inst and inst.components.combat:IsValidTarget(v) and v.components.combat and ((v.components.sanity and v.components.sanity:IsInsane()) or v == target) then
                            target_index[v] = true
                            v.components.combat:GetAttacked(inst, TUNING.DSTU.DREADEYE_DAMAGE * 0.8)
                        end
                    end
                end)
            end
            rad = rad + ((2*math.pi)/12)
        end)
    end
end

local states =
{
    State{
        name = "idle_busy",
        tags = { "idle"--[[, "canrotate"]] },

        onenter = function(inst)
            if inst.wantstodespawn then
                local t = GetTime()
                if t > inst.components.combat:GetLastAttackedTime() + 5 then
                    local target = inst.components.combat.target
                    if target == nil or
                        target.components.combat == nil or
                        not target.components.combat:IsRecentTarget(inst) or
                        target.components.combat.laststartattacktime ~= nil and t > target.components.combat.laststartattacktime + 5 then
                        inst.sg:GoToState("disappear")
                        return
                    end
                end
            end

            inst.components.locomotor:StopMoving()
			inst.AnimState:PlayAnimation("idle_loop")
        end,

        events =
        {
            EventHandler("animover", function(inst) 
				inst.sg:GoToState("idle")
			end)
        },
    },
	
    State{
        name = "idle",
        tags = { "idle"--[[, "canrotate"]] },

        onenter = function(inst)
            if inst.wantstodespawn then
                local t = GetTime()
                if t > inst.components.combat:GetLastAttackedTime() + 5 then
                    local target = inst.components.combat.target
                    if target == nil or
                        target.components.combat == nil or
                        not target.components.combat:IsRecentTarget(inst) or
                        target.components.combat.laststartattacktime ~= nil and t > target.components.combat.laststartattacktime + 5 then
                        inst.sg:GoToState("disappear")
                        return
                    end
                end
            end

            inst.components.locomotor:StopMoving()
            --if not inst.AnimState:IsCurrentAnimation("idle_loop") then
                inst.AnimState:PlayAnimation("idle_loop", true)
          --  end
        end,
    },

    State{
        name = "disguise_pre",
        tags = { "disguise", "busy", "disguised", "noattack" }, -- , "busy" 

        onenter = function(inst)
            PlayExtendedSound(inst, "death")
            inst.AnimState:PlayAnimation("disappear")
            inst.Physics:Stop()
            inst.persists = false
			
			inst:AddTag("dreadeyefading")
			--inst.components.transparentonsanity_dreadeye.forcedtarget_alpha = 0
        end,

        events =
        {
            EventHandler("animover", function(inst) 
			
				local max_tries = 20
				for k = 1, max_tries do
					local x, y, z = inst.Transform:GetWorldPosition()
					
					if x ~= nil then
						local x1, y1, z1 = nil, nil, nil
						
						if inst.disguisetarget ~= nil then
							local x1, y1, z1 = inst.disguisetarget.Transform:GetWorldPosition()
							
							if x1 ~= nil then
								x = x1
								y = y1
								z = z1
							end
						end
						
						local offset = 25
						x = x + math.random(2 * offset) - offset
						z = z + math.random(2 * offset) - offset
						local playercheck = TheSim:FindEntities(x, y, z, 10, {"player", "antlion_sinkhole_blocker"})
						if not TheWorld.Map:GetPlatformAtPoint(x, z) and (TheWorld.Map:IsOceanAtPoint(x, y, z) or TheWorld.Map:IsPassableAtPoint(x, y, z)) and (playercheck == nil or #playercheck == 0) then
							inst.Physics:Teleport(x, y, z)
							break
						end
					end
				end
			
				inst.sg:GoToState("disguise")
			end)
        },
    },

    State{
        name = "disguise",
        tags = { "invisible", "disguise", "busy", "disguised", "noattack" }, -- , "busy" 

        onenter = function(inst)
			inst.components.health:SetInvincible(true)
			
			inst.disguisetarget = nil
		
            inst.AnimState:PlayAnimation("idonotexist")
            inst.components.locomotor:StopMoving()
            inst.Physics:Stop()
			inst:Disguise()
			
			inst:AddTag("notarget")
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("disguise") end)
        },

        onexit = function(inst)
			inst:RemoveTag("notarget")
			inst.isdisguised = false
			inst.components.health:SetInvincible(false)
        end,
    },

    State{
        name = "disguise_teleport",
        tags = { "busy" },

        onenter = function(inst)
            inst.Physics:Stop()
            PlayExtendedSound(inst, "appear")
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle_busy") end)
        },
    },

    State{
        name = "disguise_attack",
        tags = { "attack", "disguise", "busy" }, -- , "busy" 

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("taunt")
            PlayExtendedSound(inst, "taunt")
			
			inst:RemoveTag("dreadeyefading")
			--inst.components.transparentonsanity_dreadeye.forcedtarget_alpha = nil
        end,
		
        events =
        {
            EventHandler("animover", function(inst)
				inst.sg:GoToState("teleport_to")
            end),
        },
    },

	State{
        name = "attack_teleport_pre",
        tags = { "attack", "busy" },

        onenter = function(inst, target)
            PlayExtendedSound(inst, "death")
            inst.sg.statemem.target = target
            inst.Physics:Stop()
            inst.components.combat:StartAttack()
            inst.AnimState:PlayAnimation("taunt")
            inst.AnimState:PushAnimation("disappear", false)
			
			--inst.components.transparentonsanity_dreadeye.forcedtarget_alpha = 0
        end,

        timeline =
        {
            TimeEvent(19 * FRAMES, function(inst)
				inst:AddTag("dreadeyefading")
                inst.sg:AddStateTag("noattack")
                inst.components.health:SetInvincible(true)
            end),
        },

        events =
        {
            EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg.statemem.attack = true
                    inst.sg:GoToState("attack_teleport", inst.sg.statemem.target)
                end
            end),
        },

        onexit = function(inst)
            if not inst.sg.statemem.attack then
                inst.components.health:SetInvincible(false)
            end
        end,
    },
	
	State{
        name = "attack_teleport",
        tags = { "attack", "busy", "noattack" },

        onenter = function(inst, target)
            inst.components.health:SetInvincible(true)
            if target ~= nil and target:IsValid() then
                inst.sg.statemem.target = target
                inst.Physics:Teleport(target.Transform:GetWorldPosition())
            end
			
            inst.AnimState:PlayAnimation("atk_pre")
            inst.AnimState:PushAnimation("atk", false)
			
			inst:RemoveTag("dreadeyefading")
			--inst.components.transparentonsanity_dreadeye.forcedtarget_alpha = nil
        end,

        timeline =
        {
            TimeEvent(14*FRAMES, function(inst) PlayExtendedSound(inst, "attack") end),
            TimeEvent(16 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("noattack")
                inst.components.health:SetInvincible(false)
				
				local x, y, z = inst.Transform:GetWorldPosition()
				local attackents = TheSim:FindEntities(x, y, z, 2.5, "player", "playerghost")
				
				for i, v in pairs(attackents) do
					if v.components.health ~= nil and not v.components.health:IsDead() 
					and v.components.combat ~= nil 
					and (inst.components.sanity ~= nil and inst.components.sanity:IsInsane() 
					or inst.components.combat.target ~= nil and inst.components.combat.target == v) then
						v.components.combat:GetAttacked(inst, 40, nil)
					end
				end
			end),
        },

        events =
        {
            EventHandler("animqueueover", function(inst)
                if math.random() < 0.333 then
                    --inst.components.combat:SetTarget(nil)
                    inst.components.combat:DropTarget()
                    inst.sg:GoToState("taunt")
                else
                    inst.sg:GoToState("idle_busy")
                end
            end),
        },

        onexit = function(inst)
            inst.components.health:SetInvincible(false)
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
            --[[inst.atkcount = inst.atkcount - 1
            if inst.atkcount <= 0 then
                inst.sg:GoToState("taunt")
                inst:DoTaskInTime(0.25, function() SpikeAoE(inst) end)
                inst.atkcount = 3
            end ]]
            PlayExtendedSound(inst, "attack_grunt")
        end,

        timeline =
        {
            TimeEvent(14*FRAMES, function(inst) PlayExtendedSound(inst, "attack") end),
            TimeEvent(16*FRAMES, function(inst) inst.components.combat:DoAttack(inst.sg.statemem.target) end),
            --inst.Physics:SetMotorVel(0, 0, 0)
            --TimeEvent(4*FRAMES, function(inst) inst.Physics:SetMotorVel(6, 0, 0) end), --9
        },

        events =
        {
            EventHandler("animqueueover", function(inst)
                if math.random() < 0.333 then
                    inst.components.combat:SetTarget(nil)
                    inst.sg:GoToState("taunt")
                else
                    inst.sg:GoToState("idle_busy")
                end
            end),
        },
    },

    State{
        name = "hit",
        tags = { "busy", "hit" }, -- , "fading" 

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("disappear")
			
			inst:AddTag("dreadeyefading")
			--inst.components.transparentonsanity_dreadeye.forcedtarget_alpha = 0
        end,

        events =
        {
            EventHandler("animover", function(inst)
				local target = inst.components.combat:HasTarget() and inst.components.combat.target or 
								inst.disguisetarget ~= nil and inst.disguisetarget or
								inst.mytarget ~= nil and inst.mytarget or
								inst.spawnedforplayer ~= nil and inst.spawnedforplayer or
								nil
				if target ~= nil and target:IsValid() then
					local max_tries = 8
					for k = 1, max_tries do
						local x, y, z = target.Transform:GetWorldPosition()
						
						if x ~= nil then
							local offset = 15
							x = x + math.random(2 * offset) - offset
							z = z + math.random(2 * offset) - offset
							
							local playercheck = TheSim:FindEntities(x, y, z, 5, {"player", "antlion_sinkhole_blocker"})
						
							if not TheWorld.Map:GetPlatformAtPoint(x, z) and (TheWorld.Map:IsOceanAtPoint(x, y, z) or TheWorld.Map:IsPassableAtPoint(x, y, z)) and (playercheck == nil or #playercheck == 0) then
								inst.Physics:Teleport(x, y, z)
								break
							end
						end
					end
				else
					local max_tries = 8
						
					if x ~= nil then
						for k = 1, max_tries do
							local x, y, z = inst.Transform:GetWorldPosition()
							local offset = 15
							x = x + math.random(2 * offset) - offset
							z = z + math.random(2 * offset) - offset
							
							local playercheck = TheSim:FindEntities(x, y, z, 5, {"player", "antlion_sinkhole_blocker"})
							
							if not TheWorld.Map:GetPlatformAtPoint(x, z) and (TheWorld.Map:IsOceanAtPoint(x, y, z) or TheWorld.Map:IsPassableAtPoint(x, y, z)) and (playercheck == nil or #playercheck == 0) then
								inst.Physics:Teleport(x, y, z)
								break
							end
						end
					end
				end
				
				inst.Transform:SetRotation(math.random(360))

				if math.random() <= 0.33 then
					inst.sg:GoToState("disguise")
				else
					inst.sg:GoToState("appear")
				end
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
            EventHandler("animover", function(inst) inst.sg:GoToState("idle_busy") end),
        },
    },

    State{
        name = "appear",
        tags = { "busy", "moving" },

        onenter = function(inst)
            inst.AnimState:PlayAnimation("appear")
            inst.Physics:Stop()
            PlayExtendedSound(inst, "appear")
			
			inst:RemoveTag("dreadeyefading")
			--inst.components.transparentonsanity_dreadeye.forcedtarget_alpha = nil
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle_busy") end)
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
			
			inst:AddTag("dreadeyefading")
			--inst.components.transparentonsanity_dreadeye.forcedtarget_alpha = 0
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
            inst.persists = false
			
			
			inst:AddTag("dreadeyefading")
			--inst.components.transparentonsanity_dreadeye.forcedtarget_alpha = 0
        end,

        events =
        {
            EventHandler("animover", OnAnimOverRemoveAfterSounds),
        },
    },

    State{
        name = "teleport_disapper",
        tags = { "busy", "noattack" },

        onenter = function(inst)
            PlayExtendedSound(inst, "death")
            inst.AnimState:PlayAnimation("disappear")
            inst.Physics:Stop()
            inst.persists = false
			
			inst:AddTag("dreadeyefading")
			
			if inst.disguiseprefab ~= nil then
				local px, py, pz = inst.disguiseprefab.Transform:GetWorldPosition()
				
				if px ~= nil then
					SpawnPrefab("mini_dreadeye_fx").Transform:SetPosition(px, py, pz)
				end
				--inst.SoundEmitter:PlaySound("dontstarve/maxwell/disappear")
				inst.disguiseprefab:Remove()
				inst.disguiseprefab = nil
			end
		
			--inst.components.transparentonsanity_dreadeye.forcedtarget_alpha = 0
        end,

        events =
        {
            EventHandler("animover", OnAnimOverRemoveAfterSounds),
        },
    
        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("appear") end),
        },
    },

    State{ 
        name = "teleport_to",
        tags = { "busy", "moving" },
    
        onenter = function(inst)
			
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("disappear")
			
			if inst.disguiseprefab ~= nil then
				local px, py, pz = inst.disguiseprefab.Transform:GetWorldPosition()
				
				if px ~= nil then
					SpawnPrefab("mini_dreadeye_fx").Transform:SetPosition(px, py, pz)
				end
				--inst.SoundEmitter:PlaySound("dontstarve/maxwell/disappear")
				inst.disguiseprefab:Remove()
				inst.disguiseprefab = nil
			end
			
			inst:AddTag("dreadeyefading")
			--inst.components.transparentonsanity_dreadeye.forcedtarget_alpha = 0
        end,
    
        events =
        {
            EventHandler("animover", function(inst)
				local target = inst.components.combat:HasTarget() and inst.components.combat.target or 
								inst.disguisetarget ~= nil and inst.disguisetarget or
								inst.mytarget ~= nil and inst.mytarget or
								inst.spawnedforplayer ~= nil and inst.spawnedforplayer or
								nil
				if target ~= nil and target:IsValid() then
					local max_tries = 8
					for k = 1, max_tries do
						local x, y, z = target.Transform:GetWorldPosition()
						
						if x ~= nil then
							local offset = 13
							x = x + math.random(2 * offset) - offset
							z = z + math.random(2 * offset) - offset
							
							local playercheck = TheSim:FindEntities(x, y, z, 5, {"player", "antlion_sinkhole_blocker"})
						
							if not TheWorld.Map:GetPlatformAtPoint(x, z) and (TheWorld.Map:IsOceanAtPoint(x, y, z) or TheWorld.Map:IsPassableAtPoint(x, y, z)) and (playercheck == nil or #playercheck == 0) then
								inst.Physics:Teleport(x, y, z)
								break
							end
						end
					end
				else
					local max_tries = 8
					for k = 1, max_tries do
						local x, y, z = inst.Transform:GetWorldPosition()
						
						if x ~= nil then
							local offset = 15
							x = x + math.random(2 * offset) - offset
							z = z + math.random(2 * offset) - offset
							
							local playercheck = TheSim:FindEntities(x, y, z, 5, {"player", "antlion_sinkhole_blocker"})
							
							if not TheWorld.Map:GetPlatformAtPoint(x, z) and (TheWorld.Map:IsOceanAtPoint(x, y, z) or TheWorld.Map:IsPassableAtPoint(x, y, z)) and (playercheck == nil or #playercheck == 0) then
								inst.Physics:Teleport(x, y, z)
								break
							end
						end
					end
				end
				
				inst.Transform:SetRotation(math.random(360))
		
				inst.sg:GoToState("appear")
			end),
        },
    },

    State{
        name = "action",
        onenter = function(inst, playanim)
            inst.Physics:Stop()
            inst:PerformBufferedAction()
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle_busy") end),
        },
    },
}
CommonStates.AddWalkStates(states)

return StateGraph("dreadeye", states, events, "appear", actionhandlers)