local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddStategraphPostInit("bearger", function(inst)

local function ShakeIfClose_Footstep(inst)
    ShakeAllCameras(CAMERASHAKE.FULL, .35, .02, 1, inst, 40)
end

local function DoFootstep(inst)
	if inst:IsStandState("quad") then
		inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/bearger/step_soft")
	else
		inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/bearger/step_stomp")
		ShakeIfClose_Footstep(inst)
	end
end

local _OldAttackEvent = inst.events["doattack"].fn --Event handler to force the leap if we haven't done the leap for long enough (brainside leap still independent
inst.events["doattack"].fn = function(inst, data)
	if inst.rockthrow and not inst.components.health:IsDead() then
		inst.sg:GoToState("pre_shoot", data.target)
	else
		_OldAttackEvent(inst, data)
	end
end

local states = {

	State{
		name = "pre_shoot",
		tags = {"busy", "canrotate"},

		onenter = function(inst, target)
			inst.Physics:Stop()
			--inst.AnimState:SetBuild("bearger_build_old")
			inst.AnimState:PlayAnimation("taunt")
			if target ~= nil then
				inst:FacePoint(target.Transform:GetWorldPosition())
			end
		end,

		timeline=
		{
			TimeEvent(8*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/bearger/taunt") end),
			TimeEvent(9*FRAMES, function(inst) DoFootstep(inst) end),
			TimeEvent(33*FRAMES, function(inst) DoFootstep(inst) end),
		},

		events=
		{
			EventHandler("animover", function(inst) inst:ClearBufferedAction() inst.sg:GoToState("shoot") end),
		},
		onexit = function(inst)
			--inst.AnimState:SetBuild("bearger_build")
		end,
	},
	
    State{
        name = "shoot",
        tags = { "attack", "canrotate", "busy" },

        onenter = function(inst)
			inst.AnimState:SetBuild("bearger_build_old")
            local target = inst.components.combat.target ~= nil and inst.components.combat.target or nil
			
			if target ~= nil and target.Transform ~= nil then
				inst:ForceFacePoint(target.Transform:GetWorldPosition())
			end
			
            inst.Physics:Stop()

            inst.AnimState:PlayAnimation("t")

        end,

        timeline =
        {   
            TimeEvent(7*FRAMES, function(inst) 
				local target = inst.components.combat.target ~= nil and inst.components.combat.target or nil
			
				if target ~= nil and target.Transform ~= nil then
					inst:ForceFacePoint(target.Transform:GetWorldPosition())
				end
				
				inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/bearger/taunt", "taunt") 
			end),
            TimeEvent(25*FRAMES, function(inst)
				if inst.components.combat ~= nil and inst.components.combat.target ~= nil then
				local target = inst.components.combat.target ~= nil and inst.components.combat.target or nil
			
					if target ~= nil and target.Transform ~= nil then
						inst:ForceFacePoint(target.Transform:GetWorldPosition())
					end
					
					local launchx, launchy, launchz = target.Transform:GetWorldPosition()
					
					inst.LaunchProjectile(inst, target, launchx, launchy, launchz)
					
					local x, y, z = inst.Transform:GetWorldPosition()

					SpawnPrefab("groundpound_fx").Transform:SetPosition(x, 0, z)
					local sandpuff = SpawnPrefab("sand_puff")
					sandpuff.Transform:SetPosition(x, 0, z)
					sandpuff.Transform:SetScale(2,2,2)
					
					inst.components.timer:StopTimer("RockThrow")
					inst.components.timer:StartTimer("RockThrow", TUNING.BEARGER_NORMAL_GROUNDPOUND_COOLDOWN * 1.4)
                
				end
            end),
        },

        events =
        {
			EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
		onexit = function(inst)
			inst.AnimState:SetBuild("bearger_build")
		end,
	},
}

for k, v in pairs(states) do
    assert(v:is_a(State), "Non-state added in mod state table!")
    inst.states[v.name] = v
end

end)

