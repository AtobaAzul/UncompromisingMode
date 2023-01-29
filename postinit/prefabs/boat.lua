local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

env.AddPrefabPostInit("boat", function(inst)
if not TheWorld.ismastersim then
    return
end
    if inst.components.boatphysics ~= nil then
        inst.components.boatphysics:SetCanSteeringRotate(true)
    end
end)