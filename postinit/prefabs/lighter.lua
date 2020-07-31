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

local function gobig(inst)

	if inst.components.burnable:IsBurning() then
		local skin_name = nil
		if inst:GetSkinName() ~= nil then
			skin_name = string.gsub(inst:GetSkinName(), "_active", "_big")
		end
		
		local big = SpawnPrefab("bernie_big", skin_name, inst.skin_id, nil)
		if big ~= nil then
			--Rescale health %
			big.components.health:SetPercent(inst.components.health:GetPercent())
			big.Transform:SetPosition(inst.Transform:GetWorldPosition())
			big.Transform:SetRotation(inst.Transform:GetRotation())
			big.components.burnable:Ignite()
			inst:Remove()
			return big
		end
	end
end

env.AddPrefabPostInit("bernie_active", function(inst)

	if not TheWorld.ismastersim then
		return
	end
	
    inst:AddComponent("burnable")
    inst.components.burnable:SetFXLevel(1)
    inst.components.burnable:SetBurnTime(30)
    inst.components.burnable.canlight = true
    inst.components.burnable:AddBurnFX("character_fire", Vector3(0, 0, 1), "bernie_torso")
	
	inst.GoBig = gobig

end)

local function goinactive(inst)
    local skin_name = nil
    if inst:GetSkinName() ~= nil then
        skin_name = string.gsub(inst:GetSkinName(), "_big", "")
    end
    local inactive = SpawnPrefab("bernie_inactive", skin_name, inst.skin_id, nil)
    if inactive ~= nil then
        --Transform health % into fuel.
        inactive.components.fueled:SetPercent(inst.components.health:GetPercent())
        inactive.Transform:SetPosition(inst.Transform:GetWorldPosition())
        inactive.Transform:SetRotation(inst.Transform:GetRotation())
        inactive.components.timer:StartTimer("transform_cd", TUNING.BERNIE_BIG_COOLDOWN)
        inst:Remove()
        return inactive
    end
end
	
local function revertbrnt(inst)
    inst.sg:GoToState("deactivate")
end

local function revertex(inst)
	if not inst.components.health:IsDead() then
		inst.sg:GoToState("deactivate")
	end
end

local function OnPreLoad(inst)
	inst.components.burnable:Ignite()
end

env.AddPrefabPostInit("bernie_big", function(inst)

	if not TheWorld.ismastersim then
		return
	end

    
    inst:AddComponent("burnable")
    inst.components.burnable:SetFXLevel(3)
    inst.components.burnable.canlight = false
    inst.components.burnable:SetBurnTime(30)
    inst.components.burnable:AddBurnFX("character_fire", Vector3(0, 0, 1), "big_body")
	--inst.components.burnable:SetOnBurntFn(revertbrnt)
	inst.components.burnable:SetOnExtinguishFn(revertex)
	MakeSmallPropagator(inst)
	
    inst.OnPreLoad = OnPreLoad

end)