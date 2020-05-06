local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
local function grow_anim_over(inst)
    -- Spawn a bush where the seed grew, and remove the seed prefab.
    local seedx, seedy, seedz = inst.Transform:GetWorldPosition()
    inst.SoundEmitter:PlaySound("dontstarve/forest/treeGrow")
    inst:Remove()

    local bush = SpawnPrefab("rock_avocado_bush")
    bush.Transform:SetPosition(seedx, seedy, seedz)
    bush.components.pickable:MakeBarren()
end

local function on_grow_timer_done(inst, data)
    if data.name ~= "grow" then
        return
    end

    inst:ListenForEvent("animover", grow_anim_over)
    inst.AnimState:PlayAnimation("seed_growth")
end

env.AddPrefabPostInit("rock_avocado_fruit_sprout_sapling", function(inst)
	if not TheWorld.ismastersim then
		return
	end

    inst:ListenForEvent("timerdone", on_grow_timer_done)
end)