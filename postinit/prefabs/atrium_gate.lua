local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

local ATRIUM_ARENA_SIZE = 14.55

local function IsObjectInAtriumArena(inst, obj)
    if obj == nil or not obj:IsValid() then
        return false
    end
    local obj_x, _, obj_z = obj.Transform:GetWorldPosition()
    local inst_x, _, inst_z = inst.Transform:GetWorldPosition()
    return math.abs(obj_x - inst_x) < ATRIUM_ARENA_SIZE
        and math.abs(obj_z - inst_z) < ATRIUM_ARENA_SIZE
end

env.AddPrefabPostInit("atrium_gate",function(inst)

    if not TheWorld.ismastersim then
        return inst
    end
	
    inst.IsObjectInAtriumArena = IsObjectInAtriumArena
end)