------------------------------------------------------------------------------------------
-- Add deciduous poison birchnut root attack to Totally Normal Trees when chopped
-- Prefabs: deciduous_root, livingtree
------------------------------------------------------------------------------------------

-- Changed color from white to dark brown
Assets = {
    Asset("ANIM", "anim/tree_leaf_spike_lt.zip")
}

AddPrefabPostInit("livingtree", function (inst)

    local function distsq(v1, v2, v3, v4)

        if v4 and v3 and v2 and v1 then
            local dx = v1-v3
            local dy = v2-v4
            return dx*dx + dy*dy
        end
    end

    --Copied from DeciduousTreeUpdater:OnUpdate in deciduoustreeupdater.lua
    local function spawn_root_attack(inst,chopper)
        if chopper ~= nil then
            local targdist = GLOBAL.TUNING.DECID_MONSTER_TARGET_DIST
            local x, y, z = chopper.Transform:GetWorldPosition()
            local mx, my, mz = inst.Transform:GetWorldPosition()
            local mdistsq = distsq(x, z, mx, mz)
            local targdistsq = targdist * targdist
            local rootpos = GLOBAL.Vector3(mx, 0, mz)
            local angle = inst:GetAngleToPoint(rootpos) * GLOBAL.DEGREES
            if mdistsq > targdistsq then
                rootpos.x = x + GLOBAL.math.cos(angle) * targdist
                rootpos.z = z - GLOBAL.math.sin(angle) * targdist
            end

            root.AnimState:SetBuild("tree_leaf_spike_lt")
            root.AnimState:SetBank("tree_leaf_spike_lt")
            root.Transform:SetPosition(x + 1.75 * math.cos(angle), 0, z - 1.75 * math.sin(angle))
            root:PushEvent("givetarget", { target = chopper, targetpos = rootpos, targetangle = angle, owner = inst })                      
        end
    end

    -- Override onworked
    local function onworked(inst, chopper, workleft)
        if not (chopper ~= nil and chopper:HasTag("playerghost")) then
            inst.SoundEmitter:PlaySound(
                chopper ~= nil and chopper:HasTag("beaver") and
                "dontstarve/characters/woodie/beaver_chop_tree" or
                "dontstarve/wilson/use_axe_tree"
            )

            -- Spawn deciduous_root
            spawn_root_attack(inst,chopper)
        end
        inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/livingtree_hit")
        inst.AnimState:PlayAnimation("chop")
        inst.AnimState:PushAnimation("idle", true)
    end

    -- Change the onworked callback to the above
    inst.components.workable:SetOnWorkCallback(onworked)

end)            