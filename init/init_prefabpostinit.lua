
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

--TODO: Make lava give more damage when on top
--TODO: Make ponds passable as well, and they make you wet really fast

AddPrefabPostInit("endtable", function(inst)
    if inst~= nil and inst.Physics ~= nil then
        GLOBAL.RemovePhysicsColliders(inst)
    end
end)

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

AddPrefabPostInit("arrowsign_post", function(inst)
    if inst~= nil and inst.Physics ~= nil then
        GLOBAL.RemovePhysicsColliders(inst)
    end
end)

-----------------------------------------------------------------
-- Tooth traps burn (they are literally logs with teeth)
-----------------------------------------------------------------
AddPrefabPostInit("trap_teeth", function(inst)
    if inst~=nil then
        GLOBAL.MakeSmallBurnable(inst)
        GLOBAL.MakeSmallPropagator(inst)
    end
end)