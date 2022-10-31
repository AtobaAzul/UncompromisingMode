local env = env
GLOBAL.setfenv(1, GLOBAL)

local pieces = 
{ 
    "shadow_knight",
    "shadow_rook",
    "shadow_bishop"
}

for k, v in ipairs(pieces) do
    env.AddPrefabPostInit(v, function(inst)
        RemovePhysicsColliders(inst)
        inst.Physics:ClearCollisionMask()
        inst.Physics:CollidesWith(COLLISION.GROUND)
    end)
end