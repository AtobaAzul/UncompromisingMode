local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddPrefabPostInit("spiderden", function(inst)
    inst:SetPhysicsRadiusOverride(0)
    MakeObstaclePhysics(inst, inst.physicsradiusoverride)

--return inst
end)