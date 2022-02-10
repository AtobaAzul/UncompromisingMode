local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddStategraphPostInit("SGbeequeen", function(inst) --For some reason it's called "SGbeequeen" instead of just... beequeen, funky
local function TrySpawnBigLeak(inst)
	local x,y,z = inst.Transform:GetWorldPosition()
    local boat = inst:GetCurrentPlatform()
    if boat then
        local leak = SpawnPrefab("boat_leak")
        leak.Transform:SetPosition(x, y, z)
        leak.components.boatleak.isdynamic = true
        leak.components.boatleak:SetBoat(boat)
        leak.components.boatleak:SetState(4, true)

        table.insert(boat.components.hullhealth.leak_indicators_dynamic, leak)
    end

end

local events=
	{        
	}

local states = {
    State{
        name = "stomp",
        tags = { "busy", "nosleep", "nofreeze", "noattack" },

        onenter = function(inst)
			--inst.brain:Stop()
            --StopFlapping(inst)
            inst.Transform:SetNoFaced()
            inst.components.locomotor:StopMoving()
            inst.components.health:SetInvincible(true)
            inst.AnimState:PlayAnimation("stomp_pre")
			inst.AnimState:PushAnimation("stomp",false)
            inst.SoundEmitter:PlaySound("dontstarve/creatures/together/bee_queen/enter")
            inst.sg.mem.wantstoscreech = true
			inst.components.locomotor:WalkForward()
        end,

        timeline =
        {
            --[[TimeEvent(4 * FRAMES, ShakeIfClose),
            TimeEvent(31 * FRAMES, DoScreech),
            TimeEvent(32 * FRAMES, DoScreechAlert),
            TimeEvent(35 * FRAMES, StartFlapping),]]
            CommonHandlers.OnNoSleepTimeEvent(38 * FRAMES, function(inst)
				local function isvalid(ent)
					local tags = { "INLIMBO", "epic", "notarget", "invisible", "noattack", "flight", "playerghost", "shadow", "shadowchesspiece", "shadowcreature","bee"}
					for i,v in ipairs(tags) do
						if ent:HasTag(v) then
							return false
						end
					end
					return true
				end
				inst.components.combat:SetAreaDamage(3.5,1.25,isvalid)
				inst.components.combat:DoAttack()
                inst.components.combat:SetAreaDamage(0,0,isvalid)
				inst.components.groundpounder:GroundPound()
				TrySpawnBigLeak(inst)
            end),
        },

        events =
        {
            CommonHandlers.OnNoSleepAnimOver("screech"),
        },

        onexit = function(inst)
            --RestoreFlapping(inst)
            inst.Transform:SetSixFaced()
            inst.components.health:SetInvincible(false)
        end,
    },
}

for k, v in pairs(events) do
    assert(v:is_a(EventHandler), "Non-event added in mod events table!")
    inst.events[v.name] = v
end

for k, v in pairs(states) do
    assert(v:is_a(State), "Non-state added in mod state table!")
    inst.states[v.name] = v
end

end)

