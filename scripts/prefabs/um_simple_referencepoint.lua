local function fn()
    local inst = CreateEntity()
	
	inst.entity:AddTransform()
    inst.entity:AddNetwork()
	MakeInventoryPhysics(inst, 1, 1.5)
	inst.entity:SetPristine()	
	
    if not TheWorld.ismastersim then
        return inst
    end
	inst:DoTaskInTime(3,function(inst) 
		if not inst.dontdelete then
			inst:Remove() 
		end
	end)
	inst.persists = false
    return inst
end
local function fndummy()
    local inst = CreateEntity()
	
	inst.entity:AddTransform()
    inst.entity:AddNetwork()
	inst.entity:AddAnimState()
	inst.Transform:SetFourFaced()
	inst.AnimState:SetBank("wilson")
	MakeCharacterPhysics(inst, 75, .5)
	inst.AnimState:Hide("ARM_carry")
	inst.AnimState:Hide("HAT")
	inst.AnimState:Hide("HAIR_HAT")
	inst.AnimState:Show("HAIR_NOHAT")
	inst.AnimState:Show("HAIR")
	inst.AnimState:Show("HEAD")
	inst.AnimState:Hide("HEAD_HAT")

	inst.AnimState:OverrideSymbol("fx_wipe", "wilson_fx", "fx_wipe")
	inst.AnimState:OverrideSymbol("fx_liquid", "wilson_fx", "fx_liquid")
	inst.AnimState:OverrideSymbol("shadow_hands", "shadow_hands", "shadow_hands")
	inst.AnimState:OverrideSymbol("snap_fx", "player_actions_fishing_ocean_new", "snap_fx")

	--Additional effects symbols for hit_darkness animation
	inst.AnimState:AddOverrideBuild("player_hit_darkness")
	inst.AnimState:AddOverrideBuild("player_receive_gift")
	inst.AnimState:AddOverrideBuild("player_actions_uniqueitem")
	inst.AnimState:AddOverrideBuild("player_wrap_bundle")
	inst.AnimState:AddOverrideBuild("player_lunge")
	inst.AnimState:AddOverrideBuild("player_attack_leap")
	inst.AnimState:AddOverrideBuild("player_superjump")
	inst.AnimState:AddOverrideBuild("player_multithrust")
	inst.AnimState:AddOverrideBuild("player_parryblock")
	inst.AnimState:AddOverrideBuild("player_emote_extra")
	inst.AnimState:AddOverrideBuild("player_boat_plank")
	inst.AnimState:AddOverrideBuild("player_boat_net")
	inst.AnimState:AddOverrideBuild("player_boat_sink")
	inst.AnimState:AddOverrideBuild("player_oar")

	inst.AnimState:AddOverrideBuild("player_actions_fishing_ocean_new")
	inst.AnimState:AddOverrideBuild("player_actions_farming")
	inst.AnimState:AddOverrideBuild("player_actions_cowbell")    
	inst.entity:SetPristine()	
	
    if not TheWorld.ismastersim then
        return inst
    end
	inst:AddComponent("skinner")
	inst.components.skinner:SetupNonPlayerData()

	inst.AnimState:SetBuild("wilson")
	inst.AnimState:PlayAnimation("distress_loop", true)
    return inst
end
return Prefab("um_simple_referencepoint", fn),
Prefab("um_simple_dummyplayer",fndummy)


