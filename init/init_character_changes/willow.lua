local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
local function propegation(inst)
	if inst.components.burnable and not inst.components.burnable:IsBurning() then
		MakeSmallPropagator(inst)
	else
		inst:DoTaskInTime(5, propegation)
	end 
end

local function OnIgniteFn(inst)

	if inst.components.sanity:IsInsane() then
	
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
	
	end
	--propegation(inst)

end

local function OnBurnt(inst)
	--will this stop her from losing her burning effect?
	inst:DoTaskInTime(1, function(inst) 
		if inst.components.health and not inst.components.health:IsDead() then 
			inst.components.burnable:Extinguish()
			MakeSmallPropagator(inst)
			inst.components.burnable:SetBurnTime(TUNING.WORMWOOD_BURN_TIME * 2)
			inst.components.burnable:SetOnIgniteFn(OnIgniteFn)
			inst.components.burnable:SetOnBurntFn(OnBurnt)
		end 
	end)


	if inst.components.burnable ~= nil then 
		inst.components.burnable:Extinguish()	
	end
end

local function OnRespawnedFromGhost2(inst)
	inst:DoTaskInTime(1, function(inst) 
		if inst.components.health and not inst.components.health:IsDead() then
			inst.components.burnable:Extinguish()
			MakeSmallPropagator(inst) 
			inst.components.burnable:SetBurnTime(TUNING.WORMWOOD_BURN_TIME * 2)
			inst.components.burnable:SetOnIgniteFn(OnIgniteFn)
			inst.components.burnable:SetOnBurntFn(OnBurnt)
		end 
	end)
end

local function onattacked(inst, data)
    if data.attacker ~= nil and inst.components.health ~= nil and not inst.components.health:IsDead() and inst.components.sanity ~= nil and not inst.components.sanity:IsSane() and (data.attacker:HasTag("shadow") or data.attacker:HasTag("shadowchesspiece") or data.attacker:HasTag("stalker")) then
        inst.components.burnable:Ignite(true, inst)
	end
end

local function OnMoistureDelta(inst)
	--Overriding the OnBurnt function to prevent propegator from sometimes removing, hopefully.
	inst:DoTaskInTime(1, function(inst) 
		if inst.components.health and not inst.components.health:IsDead() and inst.components.moisture and inst.components.moisture:GetMoisturePercent() >= 0.4 then
			if inst.components.propegator ~= nil then
				inst.components.propagator.acceptsheat = false
			end
		elseif inst.components.health and not inst.components.health:IsDead() then
			if inst.components.propegator ~= nil then
				inst.components.propagator.acceptsheat = true
			end
		end 
	end)
end

env.AddPrefabPostInit("willow", function(inst)
	if not TheWorld.ismastersim then
		return
	end

	inst.proptask = nil
	
	--if inst.components.burnable ~= nil then
		--propegation(inst)
		MakeSmallPropagator(inst)
		inst.components.burnable:SetBurnTime(TUNING.WORMWOOD_BURN_TIME * 2)
		inst.components.burnable:SetOnIgniteFn(OnIgniteFn)
		inst.components.burnable:SetOnBurntFn(OnBurnt)
	--end
	
    inst:ListenForEvent("attacked", onattacked)
    inst:ListenForEvent("ms_respawnedfromghost", OnRespawnedFromGhost2)
    inst:ListenForEvent("moisturedelta", OnMoistureDelta)
	
end)


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
	caster.components.talker:Say(GetString(caster.prefab, "ANNOUNCE_UNCOMP_LIGHTFIRE"))  
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

local function getstatus(inst)
    local skin_name = nil
	
    if inst:GetSkinName() ~= nil then
        --skin_name = inst:GetSkinName()
		--return skin_name
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

local function canceldecaying(inst)
	inst._decaytask = nil
end

local function gobig(inst)
	--no
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
	
	inst:ListenForEvent("onfueldsectionchanged", canceldecaying)
    inst:ListenForEvent("ondropped", canceldecaying)
	]]
end)


env.AddPrefabPostInit("bernie_active", function(inst)

	if not TheWorld.ismastersim then
		return
	end
	
	--inst.GoBig = gobig

end)