local assets =
{
    Asset("ANIM", "anim/armor_sanity.zip"),
}

local SLEEPREPEL_MUST_TAGS = { "_combat" }
local SLEEPREPEL_CANT_TAGS = { "player", "companion", "shadow", "playerghost", "INLIMBO", "toadstool", "notarget" }

local function OnBlocked(owner)
    owner.SoundEmitter:PlaySound("dontstarve/wilson/hit_nightarmour")
	
	if owner ~= nil then
		local x, y, z = owner.Transform:GetWorldPosition()

		local ents = TheSim:FindEntities(x, y, z, 4, SLEEPREPEL_MUST_TAGS, SLEEPREPEL_CANT_TAGS)

		for i, v in ipairs(ents) do

			if v.components.locomotor ~= nil and not v:HasTag("stageusher") and (v.sg ~= nil and not v.sg:HasStateTag("noshove") or v.sg == nil) then
				for i = 1, 50 do
					v:DoTaskInTime((i - 1) / 50, function(v)
						if v ~= nil and owner ~= nil then
							local x, y, z = owner.Transform:GetWorldPosition()
							local tx, ty, tz = v.Transform:GetWorldPosition()

							if tx ~= nil then
								local rad = math.rad(owner:GetAngleToPoint(tx, ty, tz))
								local velx = math.cos(rad) --* 4.5
								local velz = -math.sin(rad) --* 4.5

								local giantreduction = v:HasTag("epic") and 1.5 or v:HasTag("smallcreature") and 0.8 or 1
								local cursemultiplier = v:HasDebuff("wixiecurse_debuff") and 1.5 or 1

								local dx, dy, dz = tx + (((2 / (i + 3)) * velx) / giantreduction) * cursemultiplier, ty, tz + (((2 / (i + 3)) * velz) / giantreduction) * cursemultiplier
								local ground = TheWorld.Map:IsPassableAtPoint(dx, dy, dz)
								local boat = TheWorld.Map:GetPlatformAtPoint(dx, dz)
								local ocean_collision = TheWorld.Map:IsOceanAtPoint(dx, dy, dz)

								if not (v.sg ~= nil and (v.sg:HasStateTag("swimming") or v.sg:HasStateTag("invisible"))) then
									if v ~= nil and dx ~= nil and (ground or boat or ocean_collision and v.components.locomotor:CanPathfindOnWater() or v.components.tiletracker ~= nil and not v:HasTag("whale")) then
										v.Transform:SetPosition(dx, dy, dz)
									end
								end
							end
						end
					end)
				end
			end
		end
	end
end

local function onequip(inst, owner)
	inst:AddTag("pact_bound")
	owner.AnimState:OverrideSymbol("swap_body", "armor_sanity", "swap_body")

    inst:ListenForEvent("blocked", OnBlocked, owner)
end

local function onunequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")
	
	local fx = SpawnPrefab("um_shadow_attune_fx")
	fx.Transform:SetPosition(owner.Transform:GetWorldPosition())
	fx.AnimState:PlayAnimation("attune_out")
	fx.SoundEmitter:PlaySound("dontstarve/sanity/creature2/die")
					
    inst:RemoveEventCallback("blocked", OnBlocked, owner)
	
	inst:DoTaskInTime(0, inst.Remove)
	--inst:Remove()
end

local function OnTakeDamage(inst, damage_amount)
    local owner = inst.components.inventoryitem.owner
    if owner then
        local sanity = owner.components.sanity
        if sanity then
            local unsaneness = damage_amount * TUNING.ARMOR_SANITY_DMG_AS_SANITY
			
			if owner:HasTag("Funny_Words_Magic_Man") then
				unsaneness = unsaneness * .8
			end
			
            sanity:DoDelta(-unsaneness, false)
        end
    end
end

local function CheckIfUnequipped(inst)
	if not inst.components.equippable:IsEquipped() then
		inst:Remove()
	end
end

local function CalcDapperness(inst, owner)
	if owner:HasTag("Funny_Words_Magic_Man") then
		return TUNING.CRAZINESS_SMALL * .8 -- This ends up being about -5/min + 3.3/min from the hat itself, willing to cut it more for this one
	else
		return TUNING.CRAZINESS_SMALL
	end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("armor_sanity")
    inst.AnimState:SetBuild("armor_sanity")
    inst.AnimState:PlayAnimation("anim")
    --inst.AnimState:SetMultColour(1, 1, 1, 0.6)

    inst:AddTag("sanity")
    inst:AddTag("shadow_item")

	--shadowlevel (from shadowlevel component) added to pristine state for optimization
	inst:AddTag("shadowlevel")

    inst.scrapbook_specialinfo = "ARMORSANITY"

    inst.foleysound = "dontstarve/movement/foley/nightarmour"

    local swap_data = {bank = "armor_sanity", anim = "anim"}
    MakeInventoryFloatable(inst, "small", 0.2, 0.80, nil, nil, swap_data)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem:ChangeImageName("armor_sanity")

    inst:AddComponent("armor")
    inst.components.armor:InitCondition(TUNING.ARMOR_SANITY, TUNING.ARMOR_SANITY_ABSORPTION)
    inst.components.armor.ontakedamage = OnTakeDamage

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
    inst.components.equippable.dapperness = TUNING.CRAZINESS_SMALL
	inst.components.equippable.dapperfn = CalcDapperness
    inst.components.equippable.is_magic_dapperness = true

    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

	inst:AddComponent("shadowlevel")
	inst.components.shadowlevel:SetDefaultLevel(TUNING.ARMOR_SANITY_SHADOW_LEVEL)
	
	inst:DoTaskInTime(0, CheckIfUnequipped)

    MakeHauntableLaunch(inst)

    return inst
end

local function attunefx()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.AnimState:SetBank("attune_fx")
	inst.AnimState:SetBuild("attune_fx")
	inst.AnimState:PlayAnimation("attune_in")
    inst.AnimState:SetMultColour(0, 0, 0, .6)
	inst.AnimState:UsePointFiltering(true)
	
	inst:AddTag("fx")

	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:ListenForEvent("animover", inst.Remove)
	inst.persists = false

    return inst
end

return Prefab("pact_armor_sanity", fn, assets),
		Prefab( "um_shadow_attune_fx", attunefx, assets, prefabs)