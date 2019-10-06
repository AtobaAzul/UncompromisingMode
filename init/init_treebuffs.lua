-------------------------------------------------------------------------------------------------------------------------------------
-- Add root attack to Totally Normal Trees when chopped (similar to deciduous poison birchnut root)
-- Prefabs: deciduous_root, livingtree
-- Art: tree_leaf_spike, tree_leaf_spike_lt
-------------------------------------------------------------------------------------------------------------------------------------

--Copied from DeciduousTreeUpdater:OnUpdate in deciduoustreeupdater.lua
local function spawn_root_attack(inst,chopper)
    if chopper ~= nil then
        local root = GLOBAL.SpawnPrefab("deciduous_root")
        local x, y, z = chopper.Transform:GetWorldPosition()
        local mx, my, mz = inst.Transform:GetWorldPosition()
        local mdistsq = inst:GetDistanceSqToInst(chopper)
        local possition_variance_x = (GLOBAL.math.random() - 0.5) * TUNING.DECID_MONSTER_ROOT_ATTACK_RADIUS
        local possition_variance_z = (GLOBAL.math.random() - 0.5) * TUNING.DECID_MONSTER_ROOT_ATTACK_RADIUS
        local rootpos = GLOBAL.Vector3(mx + possition_variance_x, 0, mz + possition_variance_z)
        local angle = inst:GetAngleToPoint(rootpos) * GLOBAL.DEGREES

        --TODO: Make spawn faster, to make the attack harder

        root.AnimState:SetBuild("tree_leaf_spike_lt")
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

local function livingtree_postinit(inst)
    -- Change the onworked callback to the above
    if inst~=nil and inst.components~=nil and inst.components.workable~=nil then
        inst.components.workable:SetOnWorkCallback(onworked)
    end
end

AddPrefabPostInit("livingtree", livingtree_postinit)