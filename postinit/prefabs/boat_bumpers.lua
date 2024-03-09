local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

local bumpers = {
    "shell",
    "kelp",
    "yotd"
}
local BUMPER_DEPLOY_IGNORE_TAGS = { "NOBLOCK", "player", "FX", "INLIMBO", "DECOR", "walkableplatform", "structure"}

for k,v in ipairs("boat_bumper_"..bumpers.."_kit") do
    env.AddPrefabPostInit(v, function(inst)
        inst._custom_candeploy_fn = function(inst, pt, mouseover, deployer, rot)
            local boat = mouseover ~= nil and mouseover:HasTag("boat") and mouseover or nil
            if boat == nil then
                boat = TheWorld.Map:GetPlatformAtPoint(pt.x,pt.z)
        
                -- If we're not standing on a boat, try to get the closest boat position via FindEntities()
                if boat == nil or not boat:HasTag("boat") then
                    local BOAT_MUST_TAGS = { "boat" }
                    local boats = TheSim:FindEntities(pt.x, 0, pt.z, TUNING.BOAT.RADIUS, BOAT_MUST_TAGS)
                    if #boats <= 0 then
                        return false
                    end
                    boat = GetClosest(inst, boats)
                end
            end
        
            -- Check the outside rim to see if no objects are there
            local boatpos = boat:GetPosition()
            local radius = boat.components.boatringdata and boat.components.boatringdata:GetRadius() + 0.25 or 0 --  Need to look a little outside of the boat edge here
            local boatsegments = boat.components.boatringdata and boat.components.boatringdata:GetNumSegments()
            local boatangle = boat.Transform:GetRotation()
        
            local snap_point = GetCircleEdgeSnapTransform(boatsegments, radius, boatpos, pt, boatangle)
            return TheWorld.Map:IsDeployPointClear(snap_point, nil, inst.replica.inventoryitem:DeploySpacingRadius(), nil, nil, nil, BUMPER_DEPLOY_IGNORE_TAGS)
        end
    end)
end