require("stategraphs/commonstates")

local function ElectricalAttack(inst)
	local target = inst.components.combat.target ~= nil and inst.components.combat.target or nil
	if target ~= nil then
		local target_index = {}
		local found_targets = {}
		local ix, iy, iz = inst.Transform:GetWorldPosition()
		local targetfocus = target
		
		for i = 1,3 do
			local delay = i / 5
		
			local px, py, pz = targetfocus.Transform:GetWorldPosition()
			inst:DoTaskInTime(FRAMES * i * 1 + delay, function()
				if targetfocus ~= nil then
					--local px, py, pz = targetfocus.Transform:GetWorldPosition()
					local rad = math.rad(inst:GetAngleToPoint(px, py, pz))
					local velx = math.cos(rad) * 4.5
					local velz = -math.sin(rad) * 4.5
				
					local dx, dy, dz = ix + (i * velx), 0, iz + (i * velz)
					
					local lightning = SpawnPrefab("hound_lightning")
					lightning.Transform:SetPosition(dx, dy, dz)
					lightning.NoTags = { "INLIMBO", "shadow", "structure", "wall", "lightninggoat" }
				end
			end)
		end
	end
end

local function SparkingFX(inst)
    local x, y, z = inst.Transform:GetWorldPosition()

    local x1 = x + math.random(-3, 3)
    local z1 = z + math.random(-3, 3)

    SpawnPrefab("sparks").Transform:SetPosition(x1, 0 + 0.25 * math.random(), z1)
end

local function update_hit_recovery_delay(inst)
	inst._last_hitreact_time = GetTime()
end

local function onattackedfn(inst, data)
    if inst.components.health and not inst.components.health:IsDead()
    and (not inst.sg:HasStateTag("busy") or inst.sg:HasStateTag("frozen")) then
        if inst.components.combat and data and data.attacker then 
			inst.components.combat:SuggestTarget(data.target) 
			
		end
		
		if data and not (data.weapon ~= nil and (data.weapon.components.projectile or data.weapon.components.complexprojectile)) or data == nil then
			inst.sg:GoToState("hit")
		end
    end
end

local events =
{
    CommonHandlers.OnLocomote(false,true),
    CommonHandlers.OnSleep(),
    CommonHandlers.OnFreeze(),
    CommonHandlers.OnAttack(),
    CommonHandlers.OnDeath(),
    EventHandler("attacked", onattackedfn),
}

local states=
{
    State{
        name = "idle",
        tags = { "idle", "canrotate" },

        onenter = function(inst, playanim)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("idle_loop", true)
            inst.sg:SetTimeout(math.random()*2+2)
            if inst.charged then
                inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/lightninggoat/jacobshorn")
            end
            inst.jacobsladdersfxtask = inst:DoPeriodicTask(44*FRAMES, function(inst)
                if inst.charged then
                    inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/lightninggoat/jacobshorn")
                end
            end)
        end,

        ontimeout = function(inst)
			if inst.getting_angry then
				inst.sg:GoToState("getting_pissed")
			else
				inst.sg:GoToState("bleet")
			end
        end,

        onexit= function(inst)
            if inst.jacobsladdersfxtask then
                inst.jacobsladdersfxtask:Cancel()
                inst.jacobsladdersfxtask = nil
            end
        end,

        timeline =
        {
            TimeEvent(GetRandomWithVariance(8,3)*FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/lightninggoat/chew")
            end),
            TimeEvent(GetRandomWithVariance(33,3)*FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/lightninggoat/chew")
            end),
        },
    },
	
	State{
        name = "hit",
        tags = { "hit", "busy" },

        onenter = function(inst)
            if inst.components.locomotor ~= nil then
                inst.components.locomotor:StopMoving()
            end

            inst.AnimState:PlayAnimation("hit")

            if inst.SoundEmitter ~= nil and inst.sounds ~= nil and inst.sounds.hit ~= nil then
                inst.SoundEmitter:PlaySound(inst.sounds.hit)
            end
        end,

        events =
        {
            EventHandler("animover", function(inst) 
				if inst.AnimState:AnimDone() then
					--if math.random() > 0.5 then
						inst.sg:GoToState("stomp_attack_start")
					--else
					--	inst.sg:GoToState("idle")
					--end
				end			
			end),
        },
    },
	
	State{
        name = "attack",
        tags = { "attack", "busy" },

        onenter = function(inst, target)
            if inst.components.locomotor ~= nil then
                inst.components.locomotor:StopMoving()
            end
            inst.AnimState:PlayAnimation("atk")
            inst.components.combat:StartAttack()

            inst.sg.statemem.target = target
        end,

        timeline = {
			TimeEvent(1*FRAMES, function(inst)
				inst.count = math.random(4,6)
				--TheNet:Announce("Enteringgoatmove")
				--inst.AnimState:Show("fx")
				--inst.sg:GoToState("electricalattack")
				if inst.charged then
					inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/lightninggoat/jacobshorn")
				end
			end),
			
			TimeEvent(9*FRAMES, function(inst)
				inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/lightninggoat/headbutt")
			end),
			
			TimeEvent(12*FRAMES, function(inst)
				if inst.charged then
					inst.components.combat:DoAttack(inst.sg.statemem.target, nil, nil, "electric")
				else
					inst.components.combat:DoAttack(inst.sg.statemem.target)
				end			
			end),
			
			TimeEvent(15*FRAMES, function(inst) inst.sg:RemoveStateTag("attack") end),
		},

        events =
        {
            EventHandler("animover", function(inst)
				if inst.AnimState:AnimDone() then
					inst.sg:GoToState("idle")
				end
			end),
        },
    },
	
	State{
        name = "death",
        tags = { "busy" },

        onenter = function(inst)
            if inst.components.locomotor ~= nil then
                inst.components.locomotor:StopMoving()
            end
            inst.AnimState:PlayAnimation("death")
            RemovePhysicsColliders(inst)
            inst.components.lootdropper:DropLoot(inst:GetPosition())
        end,

        timeline = {
			TimeEvent(0*FRAMES, function(inst)
				inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/lightninggoat/death")
			end),
			TimeEvent(3*FRAMES, function(inst)
				if inst.charged then
					inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/lightninggoat/jacobshorn")
				end
			end),
			TimeEvent(34*FRAMES, function(inst)
				inst.Light:Enable(false)
				inst.AnimState:ClearBloomEffectHandle()
			end),
		},
    },
	
    State{
        name = "walk_start",
        tags = { "moving", "canrotate" },

        onenter = function(inst)
            inst.AnimState:PlayAnimation("walk_pre")
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("walk") end),
        },
    },

    State{
        name = "walk",
        tags = { "moving", "canrotate" },

        onenter = function(inst)
            inst.components.locomotor:WalkForward()
            inst.AnimState:PlayAnimation("walk")
            inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/lightninggoat/jump")
            if inst.charged then
                inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/lightninggoat/jacobshorn")
            end
        end,

        timeline =
        {
            TimeEvent(2*FRAMES, function(inst)
                inst.components.locomotor:RunForward()
            end),
            TimeEvent(14*FRAMES, function(inst)
                inst.components.locomotor:WalkForward()
            end),
        },

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("walk") end),
        },
    },

    State{
        name = "walk_stop",
        tags = { "canrotate" },

        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("walk_pst", false)
        end,

        events =
        {
            EventHandler("animover", function(inst)
				--if inst.getting_angry then
					--inst.sg:GoToState("getting_pissed")
				--else
					inst.sg:GoToState("idle")
				--end
			end),
        },
    },

    State{
        name = "getting_pissed",
        tags = { "taunt" },

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("taunt_pre")
            inst.AnimState:PushAnimation("taunt")
            inst.AnimState:PushAnimation("taunt_pst", false)
			
			if inst.pissed_count < 2 then
				inst.pissed_count = inst.pissed_count + 1
			end
        end,

        timeline =
        {
            TimeEvent(5*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/lightninggoat/taunt") end),
            TimeEvent(17*FRAMES, function(inst) if inst.charged then inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/lightninggoat/jacobshorn") end end),
            TimeEvent(27*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/lightninggoat/hoof") end),
            TimeEvent(44*FRAMES, function(inst) if inst.charged then inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/lightninggoat/jacobshorn") end end),
            TimeEvent(53*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/lightninggoat/hoof") end),
            TimeEvent(71*FRAMES, function(inst) if inst.charged then inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/lightninggoat/jacobshorn") end end),
            TimeEvent(79*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/lightninggoat/hoof") end),
        },

        events =
        {
            EventHandler("animqueueover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State{
        name = "taunt",
        tags = { "busy" },

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("taunt_pre")
            inst.AnimState:PushAnimation("taunt")
            inst.AnimState:PushAnimation("taunt_pst", false)
        end,

        timeline =
        {
            TimeEvent(5*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/lightninggoat/taunt") end),
            TimeEvent(17*FRAMES, function(inst) if inst.charged then inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/lightninggoat/jacobshorn") end end),
            TimeEvent(27*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/lightninggoat/hoof") end),
            TimeEvent(44*FRAMES, function(inst) if inst.charged then inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/lightninggoat/jacobshorn") end end),
            TimeEvent(53*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/lightninggoat/hoof") end),
            TimeEvent(71*FRAMES, function(inst) if inst.charged then inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/lightninggoat/jacobshorn") end end),
            TimeEvent(79*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/lightninggoat/hoof") end),
        },

        events =
        {
            EventHandler("animover", function(inst)
				if inst.getting_angry then
					inst.sg:GoToState("getting_pissed")
				else
					inst.sg:GoToState("idle")
				end
			end),
        },
    },

    State{
        name = "bleet",
        tags = { "idle" },

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("bleet")
        end,

        timeline =
        {
            TimeEvent(1*FRAMES, function(inst)
                if inst.charged then
                    inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/lightninggoat/jacobshorn")
                end
            end),
            TimeEvent(10*FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/lightninggoat/bleet")
            end)
        },

        events =
        {
            EventHandler("animover", function(inst)
				if inst.getting_angry then
					inst.sg:GoToState("getting_pissed")
				else
					inst.sg:GoToState("idle")
				end
			end),
        },
    },

    State{
        name = "discharge",
        tags = { "busy" },

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("trans")
            inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/lightninggoat/shocked_electric")
        end,

        timeline =
        {
            TimeEvent(18*FRAMES, function(inst)
                inst.AnimState:Hide("fx")
                inst.AnimState:SetBuild("lightning_goat_build")
            end),
        },

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State{
        name = "shocked",
        tags = { "busy" },

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("shock")
            inst.AnimState:PushAnimation("shock_pst", false)
            inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/lightninggoat/shocked_electric")
            inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/lightninggoat/shocked_bleet")
            inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/lightninggoat/jacobshorn")
        end,

        timeline =
        {
            TimeEvent(10*FRAMES, function(inst)
                inst:PerformBufferedAction()
            end)
        },

        events =
        {
            EventHandler("animqueueover", function(inst) inst.sg:GoToState("idle") end),
        },
    },
	
    State{
        name = "electricalattack",
        tags = { "busy","attack" },

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("lightcharge_atk_loop")
            inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/lightninggoat/shocked_electric")
        end,

        events =
        {
            EventHandler("animover", function(inst)
				if inst.count > 0 then
					inst.LightningAttack(inst)
					inst.count = inst.count - 1
					inst.sg:GoToState("electricalattack")
				else
					TheNet:Announce("FinishedGoatmove")
					inst.recharging_electric = true
					inst.Recharge(inst)
					inst.AnimState:Hide("fx")
					inst.sg:GoToState("idle")
				end
			end),
        },
    },
	
    State{
        name = "stomp_attack_start",
        tags = { "busy", "attack" },

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("stompy")
			inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/lightninggoat/taunt")
			
			for i = 1, 10 do
				inst:DoTaskInTime(i / 8, SparkingFX)
			end
        end,

        timeline =
        {
            TimeEvent(12*FRAMES, function(inst)
				inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/lightninggoat/headbutt")
			end),
			
            TimeEvent(18*FRAMES, function(inst)
				inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/land")
			end),
			
            TimeEvent(19*FRAMES, function(inst)
				local dodamageRadius = 5.5
				inst.components.groundpounder.destructionRings = 1
				inst.components.groundpounder.platformPushingRings = 1
				inst.components.groundpounder.numRings = 1
				
				local ringfx = SpawnPrefab("firering_fx")
				ringfx.Transform:SetPosition(inst.Transform:GetWorldPosition())
				ringfx.Transform:SetScale(0.8, 0.8, 0.8)
				
				inst.components.groundpounder.destructionRings = 1
				inst.components.groundpounder.platformPushingRings = 1
				inst.components.groundpounder.numRings = 1
				inst.components.groundpounder:GroundPound()
				
				local x, y, z = inst.Transform:GetWorldPosition()
				local ents = TheSim:FindEntities(x, y, z, dodamageRadius, { "_combat" }, { "playerghost", "lightninggoat", "ghost", "prey", "bird", "shadowcreature" })
				
				for i, ent in ipairs(ents) do
					if ent.components.health ~= nil and not ent.components.health:IsDead() then
						local insulated = (ent:HasTag("electricdamageimmune") or
							(ent.components.inventory ~= nil and ent.components.inventory:IsInsulated()))
							
						local mult = ent:HasTag("player") and not insulated
							and TUNING.ELECTRIC_DAMAGE_MULT + TUNING.ELECTRIC_WET_DAMAGE_MULT * (ent.components.moisture ~= nil and ent.components.moisture:GetMoisturePercent() or (ent:GetIsWet() and 1 or 0))
							or 1
							
						ent.components.combat:GetAttacked(inst, (TUNING.LIGHTNING_GOAT_DAMAGE * 1.5) * mult, nil, "electric")
							
						if ent:HasTag("player") and ent.sg ~= nil and not ent.sg:HasStateTag("nointerrupt") and not insulated and not
							(ent.components.health ~= nil and not ent.components.health:IsDead()) then
							ent.sg:GoToState("electrocute")
						end
					end
				end
				
				inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/lightninggoat/shocked_electric")
			end)
        },
		
        events =
        {
            EventHandler("animover", function(inst)
				inst.sg:GoToState("stomp_attack_loop")
			end),
        },
    },
	
    State{
        name = "stomp_attack_loop",
        tags = { "busy", "attack" },

        onenter = function(inst)
			if inst.stomp_count == nil then
				inst.stomp_count = 1
			else
				inst.stomp_count = inst.stomp_count + 1
			end
				
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("stompy_loop")
            inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/lightninggoat/shocked_electric")
        end,

        timeline =
        {
            TimeEvent(4*FRAMES, function(inst)
				local dodamageRadius = 5.5 + inst.stomp_count
				
				local ringfx = SpawnPrefab("firering_fx")
				ringfx.Transform:SetPosition(inst.Transform:GetWorldPosition())
				ringfx.Transform:SetScale(0.8 + (inst.stomp_count / 9), 0.8 + (inst.stomp_count / 9), 0.8 + (inst.stomp_count / 9))
					
				inst.components.groundpounder.destructionRings = 1 + inst.stomp_count
				inst.components.groundpounder.platformPushingRings = 1 + inst.stomp_count
				inst.components.groundpounder.numRings = 1 + inst.stomp_count
				inst.components.groundpounder:GroundPound()
				
				local x, y, z = inst.Transform:GetWorldPosition()
				local ents = TheSim:FindEntities(x, y, z, dodamageRadius, { "_combat" }, { "playerghost", "lightninggoat", "ghost", "prey", "bird", "shadowcreature" })
				
				for i, ent in ipairs(ents) do
					if ent.components.health ~= nil and not ent.components.health:IsDead() then
						local insulated = (ent:HasTag("electricdamageimmune") or
							(ent.components.inventory ~= nil and ent.components.inventory:IsInsulated()))
							
						local mult = ent:HasTag("player") and not insulated
							and TUNING.ELECTRIC_DAMAGE_MULT + TUNING.ELECTRIC_WET_DAMAGE_MULT * (ent.components.moisture ~= nil and ent.components.moisture:GetMoisturePercent() or (ent:GetIsWet() and 1 or 0))
							or 1
							
						ent.components.combat:GetAttacked(inst, (TUNING.LIGHTNING_GOAT_DAMAGE * 1.5) * mult, nil, "electric")
							
						if ent:HasTag("player") and ent.sg ~= nil and not ent.sg:HasStateTag("nointerrupt") and not insulated and not
							(ent.components.health ~= nil and not ent.components.health:IsDead()) then
							ent.sg:GoToState("electrocute")
						end
					end
				end
			end)
		},

        events =
        {
            EventHandler("animover", function(inst)
				if inst.stomp_count == 2 then
					inst.sg:GoToState("stomp_attack_stop")
				else
					inst.sg:GoToState("stomp_attack_loop")
				end
			end),
        },
    },
	
    State{
        name = "stomp_attack_stop",
        tags = { "busy", "attack" },

        onenter = function(inst)
			inst.stomp_count = 0
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("stompy_pst")
        end,

        events =
        {
            EventHandler("animover", function(inst)
				inst.sg:GoToState("idle")
			end),
        },
    },
}
CommonStates.AddFrozenStates(states)
CommonStates.AddSleepStates(states,
{
    startsleeptimeline =
    {
        TimeEvent(9*FRAMES, function(inst)
            if inst.charged then
                inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/lightninggoat/jacobshorn")
            end
        end),
    },
    sleeptimeline =
    {
        TimeEvent(41*FRAMES, function(inst)
            inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/lightninggoat/sleep")
        end),
    },
})

return StateGraph("alpha_lightninggoat", states, events, "idle")
