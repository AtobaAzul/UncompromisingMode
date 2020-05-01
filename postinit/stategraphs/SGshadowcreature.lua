local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddStategraphPostInit("shadowcreature", function(inst)

local events=
{
	EventHandler("attacked", function(inst)
        if not (inst.sg:HasStateTag("attack") or inst.sg:HasStateTag("hit") or inst.sg:HasStateTag("noattack") or inst.components.health:IsDead()) then
            inst.sg:GoToState("hit")
        end
    end),

    EventHandler("doattack", function(inst, data)
        if not (inst.sg:HasStateTag("busy") or inst.components.health:IsDead()) then
            inst.sg:GoToState("attack", data.target)
        end
    end),
    
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

local states = {

	State{
        name = "hit",
        tags = { "busy", "hit" },

        onenter = function(inst)
			
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("disappear")
        end,
		
		timeline =
        {   
            TimeEvent(FRAMES, function(inst)
                if inst:HasTag("crawlinghorror") then
                    inst:LaunchProjectile()
				end
            end),
            TimeEvent(2*FRAMES, function(inst)
                if inst:HasTag("crawlinghorror") then
                    inst:LaunchProjectile()
				end
            end),
            TimeEvent(4*FRAMES, function(inst)
                if inst:HasTag("crawlinghorror") then
                    inst:LaunchProjectile()
				end
            end),
			TimeEvent(6*FRAMES, function(inst)
                if inst:HasTag("crawlinghorror") then
                    inst:LaunchProjectile()
				end
            end),
			TimeEvent(8*FRAMES, function(inst)
                if inst:HasTag("crawlinghorror") then
                    inst:LaunchProjectile()
				end
            end),
        },

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
        name = "attack",
        tags = { "attack", "busy" },

        onenter = function(inst, target)
            inst.sg.statemem.target = target
			inst.Physics:Stop()
			if inst:HasTag("terrorbeak") then 
				inst:DoTaskInTime(6*FRAMES, function(inst) 
					inst.components.locomotor:WalkForward()
				end)
			end
			
			
            inst.components.combat:StartAttack()
            inst.AnimState:PlayAnimation("atk_pre")
            inst.AnimState:PushAnimation("atk", false)
            PlayExtendedSound(inst, "attack_grunt")
        end,

        timeline =
        {
            TimeEvent(14*FRAMES, function(inst) PlayExtendedSound(inst, "attack") 
				
			end),
            TimeEvent(16*FRAMES, function(inst) inst.components.combat:DoAttack(inst.sg.statemem.target) 
			
			end),
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
    }
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

