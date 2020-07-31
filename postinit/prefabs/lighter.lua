local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
local function onequip(inst, owner)
    inst.components.burnable:Ignite()

    local skin_build = inst:GetSkinBuild()
    if skin_build ~= nil then
        owner:PushEvent("equipskinneditem", inst:GetSkinName())
        owner.AnimState:OverrideItemSkinSymbol("swap_object", skin_build, "swap_lighter", inst.GUID, "swap_lighter")
    else
        owner.AnimState:OverrideSymbol("swap_object", "swap_lighter", "swap_lighter")
    end

    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")

    owner.SoundEmitter:PlaySound("dontstarve/wilson/lighter_on")


    if inst.fires == nil then
        inst.fires = {}

        for i, fx_prefab in ipairs(inst:GetSkinName() == nil and { "lighterfire" } or SKIN_FX_PREFAB[inst:GetSkinName()] or {}) do
            local fx = SpawnPrefab(fx_prefab)
            fx.entity:SetParent(owner.entity)
            fx.entity:AddFollower()
            fx.Follower:FollowSymbol(owner.GUID, "swap_object", fx.fx_offset_x, fx.fx_offset_y, 0)
            fx:AttachLightTo(owner)

            table.insert(inst.fires, fx)
        end
    end

	if owner:HasTag("pyromaniac") then
		inst.components.fueled:StopConsuming()
	end


    --[[if inst.fire == nil then
        inst.fire = SpawnPrefab("lighterfire")
        --inst.fire.Transform:SetScale(.125, .125, .125)
        inst.fire.entity:AddFollower()
        inst.fire.Follower:FollowSymbol(owner.GUID, "swap_object", 56, -40, 0)
    end]]
end

env.AddPrefabPostInit("lighter", function(inst)
	if not TheWorld.ismastersim then
		return 
	end
	
	if inst.components.equippable ~= nil then
		inst.components.equippable:SetOnEquip(onequip)
	end
	
end)