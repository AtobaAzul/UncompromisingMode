local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
env.AddStategraphState("deerclops",
	State{
        name = "fall",
        tags = {"busy"},
        onenter = function(inst, data)
			inst.Physics:SetDamping(0)
            inst.Physics:SetMotorVel(0,-20+math.random()*10,0)
            inst.AnimState:PlayAnimation("falling_loop", true)
        end,
        
        onupdate = function(inst)
            local pt = Point(inst.Transform:GetWorldPosition())
            if pt.y < 2 then
				inst.Physics:SetMotorVel(0,0,0)
				inst.AnimState:PlayAnimation("fallattack", true)

				inst.components.groundpounder:GroundPound()

				SpawnPrefab("antlion_sinkhole").Transform:SetPosition(pt.x, 0, pt.z)

                pt.y = 0
                inst.Physics:Stop()
				inst.Physics:SetDamping(5)
                inst.Physics:Teleport(pt.x,pt.y,pt.z)
	            inst.DynamicShadow:Enable(true)
            end
        end,
		timeline =
        {
            TimeEvent(60*FRAMES, function(inst) inst.sg:GoToState("idle") end),
			
           
        },
    }
)