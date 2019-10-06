
-----------------------------------------------------------------
-- Remove pathing collision exploit by making objects noclip
-----------------------------------------------------------------
--[[
fossil_stalker
lava_pond
homesign
arrowsign_post
statueharp
statue_marble
gravestone
sculpture_???
]]--

AddPrefabPostInit("fossil_stalker", function(inst)
    if inst~= nil and inst.Physics ~= nil then
        GLOBAL.RemovePhysicsColliders(inst)
    end
end)

AddPrefabPostInit("lava_pond", function(inst)
    if inst~= nil and inst.Physics ~= nil then
        GLOBAL.RemovePhysicsColliders(inst)
    end
end)

AddPrefabPostInit("homesign", function(inst)
    if inst~= nil and inst.Physics ~= nil then
        GLOBAL.RemovePhysicsColliders(inst)
    end
end)

AddPrefabPostInit("statueharp", function(inst)
    if inst~= nil and inst.Physics ~= nil then
        GLOBAL.RemovePhysicsColliders(inst)
    end
end)

AddPrefabPostInit("statue_marble", function(inst)
    if inst~= nil and inst.Physics ~= nil then
        GLOBAL.RemovePhysicsColliders(inst)
    end
end)

AddPrefabPostInit("gravestone", function(inst)
    if inst~= nil and inst.Physics ~= nil then
        GLOBAL.RemovePhysicsColliders(inst)
    end
end)

