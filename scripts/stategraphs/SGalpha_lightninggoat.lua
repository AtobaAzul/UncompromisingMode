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

local events =
{
    CommonHandlers.OnLocomote(false,true),
    CommonHandlers.OnSleep(),
    CommonHandlers.OnFreeze(),
    CommonHandlers.OnAttack(),
    CommonHandlers.OnAttacked(),
    CommonHandlers.OnDeath(),
    -- EventHandler("attacked", function(inst)
    --     if inst.components.health and not inst.components.health:IsDead() and not inst.sg:HasStateTag("busy") then
    --         inst.sg:GoToState("hit")
    --     end
    -- end),
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
}

CommonStates.AddCombatStates(states,
{
    attacktimeline =
    {
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
    deathtimeline =
    {
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
})
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
