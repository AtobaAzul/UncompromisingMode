local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

TUNING.BERNIE_HEALTH = 1200

TUNING.BERNIE_BIG_HEALTH = 2400
--[[
TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT.WILLOW = {"lighter", "berniebox"}

TUNING.STARTING_ITEM_IMAGE_OVERRIDE["berniebox"] =
	{
		atlas = "images/inventoryimages/berniebox.xml",
		image = "berniebox.tex",
	}
	
Recipe("bernie_inactive", {Ingredient("berniebox", 1, "images/inventoryimages/berniebox.xml")}, RECIPETABS.SURVIVAL,  TECH.NONE, nil, nil, nil, nil, "pyromaniac")
AllRecipes["bernie_inactive"].sortkey = AllRecipes["healingsalve"].sortkey - .1
]]
local function createlight(inst)

    local caster = inst.components.inventoryitem.owner

    inst.SoundEmitter:KillSound("hiss")
	SpawnPrefab("firesplash_fx").Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst.SoundEmitter:PlaySound("dontstarve/common/blackpowder_explo")
	
	local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, 4, nil, { "INLIMBO", "player", "abigail" })

    for i, v in ipairs(ents) do
        if v ~= inst and v:IsValid() and not v:IsInLimbo() then
           
            --Recheck valid after work
            if v:IsValid() and not v:IsInLimbo() then
                if v.components.fueled == nil and
                    v.components.burnable ~= nil and
                    not v.components.burnable:IsBurning() and
                    not v:HasTag("burnt") then
                    v.components.burnable:Ignite()
                end
				
				if v.components.combat ~= nil and not (v.components.health ~= nil and v.components.health:IsDead()) then
                    local dmg = 40
                    if v.components.explosiveresist ~= nil then
                        dmg = dmg * (1 - v.components.explosiveresist:GetResistance())
                        v.components.explosiveresist:OnExplosiveDamage(dmg, inst)
                    end
					if v:HasTag("shadow") or v:HasTag("shadowchesspiece") then
						dmg = dmg * 3
					end
                    v.components.combat:GetAttacked(inst, dmg, nil)
                end
            end
        end
    end
	
	if caster ~= nil then
		SpawnPrefab("willowfire").Transform:SetPosition(caster.Transform:GetWorldPosition())
	end
	
	local reduce = inst.components.fueled:GetPercent() - 0.1001
	inst.components.fueled:SetPercent(reduce)
	
end

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
		if inst.components.spellcaster == nil then
			inst:AddComponent("spellcaster")
			inst.components.spellcaster:SetSpellFn(createlight)
			inst.components.spellcaster.canusefrominventory = true
		end
		inst.components.fueled:StopConsuming()
	else
		inst:RemoveComponent("spellcaster")
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
	
	inst:AddTag("lighter")
	
	if inst.components.equippable ~= nil then
		inst.components.equippable:SetOnEquip(onequip)
	end
	
	inst:AddComponent("spellcaster")
    inst.components.spellcaster:SetSpellFn(createlight)
    inst.components.spellcaster.canusefrominventory = true
	
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

local function getstatus(inst)
    local skin_name = nil
	
    if inst:GetSkinName() ~= nil then
        --skin_name = inst:GetSkinName()
		--return skin_name
		--print(skin_name)
		return inst.components.fueled ~= nil and inst.components.fueled:IsEmpty() and "ASHLEY_BROKEN" or "ASHLEY"
	end
	
    return inst.components.fueled ~= nil and inst.components.fueled:IsEmpty() and "BROKEN" or nil
end

local function SetName(inst)
	inst.pickname = "Bernie"
	if inst:GetSkinName() ~= nil then
		inst.pickname = "Ashley"
	end
	inst.components.named:SetName(inst.pickname)
end

local function SetNameBig(inst)
	inst.pickname = "BERNIE!"
	if inst:GetSkinName() ~= nil then
		inst.pickname = "ASHLEY!"
	end
	inst.components.named:SetName(inst.pickname)
end

env.AddPrefabPostInit("bernie_active", function(inst)
	
	inst:AddTag("irreplaceable")

	if not TheWorld.ismastersim then
		return
	end
	--[[
    inst.components.inspectable.getstatus = getstatus
	
	inst:AddComponent("named")
	inst:DoTaskInTime(0, SetName)
	]]
    inst:AddComponent("burnable")
    inst.components.burnable:SetFXLevel(1)
    inst.components.burnable:SetBurnTime(30)
    inst.components.burnable.canlight = true
    inst.components.burnable:AddBurnFX("character_fire", Vector3(0, 0, 1), "bernie_torso")
	
	inst.GoBig = gobig

end)
	
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
	
	inst:AddTag("irreplaceable")

	if not TheWorld.ismastersim then
		return
	end
	--[[
    inst.components.inspectable.getstatus = getstatus

	inst:AddComponent("named")
	inst:DoTaskInTime(0, SetNameBig)
    ]]
    inst:AddComponent("burnable")
    inst.components.burnable:SetFXLevel(3)
    inst.components.burnable.canlight = false
    inst.components.burnable:SetBurnTime(60)
    inst.components.burnable:AddBurnFX("character_fire", Vector3(0, 0, 1), "big_body")
	--inst.components.burnable:SetOnBurntFn(revertbrnt)
	inst.components.burnable:SetOnExtinguishFn(revertex)
	MakeSmallPropagator(inst)
	
    inst.OnPreLoad = OnPreLoad

end)

local function canceldecaying(inst)
	inst._decaytask = nil
end

env.AddPrefabPostInit("bernie_inactive", function(inst)

	if not TheWorld.ismastersim then
		return
	end
	--[[
    inst:AddComponent("floater")
    inst.components.floater:SetSize("small")
	
    inst.components.inspectable.getstatus = getstatus

	inst:AddComponent("named")
	inst:DoTaskInTime(0, SetName)
	
	if inst.components.inventoryitem ~= nil then
		inst.components.inventoryitem:SetSinks(false)
	end
	]]
	inst:ListenForEvent("onfueldsectionchanged", canceldecaying)
    inst:ListenForEvent("ondropped", canceldecaying)

end)