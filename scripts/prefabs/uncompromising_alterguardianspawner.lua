local function do_boss_spawn(inst)
    local ix, _, iz = inst.Transform:GetWorldPosition()
    local boss = SpawnPrefab("alterguardian_phase1")
    boss.Transform:SetPosition(ix, 0, iz)
    boss.sg:GoToState("prespawn_idle")

    inst:Remove()
end

local function break_device(inst)

    inst:DoTaskInTime(1*FRAMES, do_boss_spawn)
    inst.SoundEmitter:PlaySound("moonstorm/creatures/boss/alterguardian1/spawn_pre")
end

local function breaksequence(inst)
    local fall_fx = SpawnPrefab("alterguardian_phase1fallfx")
    fall_fx.Transform:SetPosition(inst.Transform:GetWorldPosition())

    -- Should be timed up with the phase1fallfx anim/fx spawned above.
    inst:DoTaskInTime(9*FRAMES, break_device)
end


local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:DoTaskInTime(0, breaksequence)
	
    return inst
end

return Prefab("uncompromising_alterguardianspawner", fn)