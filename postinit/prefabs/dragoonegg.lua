local env = env
GLOBAL.setfenv(1, GLOBAL)

local function DoSmogsplosion(inst)
    if not TheWorld.ismastersim then return end

    local _DestroyPoints = inst.components.groundpounder.DestroyPoints

    inst.components.groundpounder.DestroyPoints = function(self, points, breakobjects, dodamage)
        for k, v in pairs(points) do
            self.inst:DoTaskInTime(math.random(), function()
                local smog = SpawnPrefab("smog")
                smog.Transform:SetPosition(v.x, v.y, v.z)
            end)
        end

        _DestroyPoints(self, points, breakobjects, dodamage)
    end
end


env.AddPrefabPostInit("dragoonegg_falling", DoSmogsplosion)
env.AddPrefabPostInit("firerain", DoSmogsplosion)
