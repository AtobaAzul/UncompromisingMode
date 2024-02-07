local env = env
GLOBAL.setfenv(1, GLOBAL)
if env.GetModConfigData("willow") then
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
            local ents = TheSim:FindEntities(x, y, z, 4, nil, { "INLIMBO", "player", "abigail", "companion" })

            for i, v in ipairs(ents) do
                if v ~= inst and v:IsValid() and not v:IsInLimbo() then
                    --Recheck valid after work
                    if v:IsValid() and not v:IsInLimbo() then
                        if v.components.fueled == nil and
                            v.components.burnable ~= nil and
                            not v.components.burnable:IsBurning() and
                            not v:HasTag("burnt") then
                            v.components.burnable:Ignite(nil, true)
                        end

                        if v.components.combat ~= nil and not (v.components.health ~= nil and v.components.health:IsDead()) then
                            local dmg = 40
                            if v.components.explosiveresist ~= nil then
                                dmg = dmg * (1 - v.components.explosiveresist:GetResistance())
                                v.components.explosiveresist:OnExplosiveDamage(dmg, inst)
                            end
                            if v:HasTag("shadow_aligned") then
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
            OnIgniteFn(inst)
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

        --[[inst.proptask = nil

	if inst.components.burnable ~= nil then
		MakeSmallPropagator(inst)
		inst.components.burnable:SetBurnTime(TUNING.WORMWOOD_BURN_TIME * 2)
		inst.components.burnable:SetOnIgniteFn(OnIgniteFn)
		inst.components.burnable:SetOnBurntFn(OnBurnt)
	end]]
        --inst:ListenForEvent("attacked", onattacked)
        --inst:ListenForEvent("ms_respawnedfromghost", OnRespawnedFromGhost2)
        --inst:ListenForEvent("moisturedelta", OnMoistureDelta)
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
                        v.components.burnable:Ignite(nil, true)
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

    --for some reason this file is being loaded despite the config being off *and a check actually existing*
    -- SO I'll just leave this explicit check here too!
    env.AddPrefabPostInit("lighter", function(inst)
        if not TheWorld.ismastersim then
            return
        end

        inst:AddTag("lighter")

        if inst.components.equippable ~= nil then
            local _SetOnEquip = inst.components.equippable.onequipfn

            inst.components.equippable.onequipfn = function(inst, owner)
                if _SetOnEquip ~= nil then
                    _SetOnEquip(inst, owner)
                end

                if owner:HasTag("pyromaniac") and inst.components.fueled ~= nil then
                    inst.components.fueled:StopConsuming()
                end
            end
        end

        if inst.components.cooker ~= nil then
            local _SetOnCook = inst.components.cooker.oncookfn

            inst.components.cooker.oncookfn = function(inst, product, chef)
                if not chef:HasTag("pyromaniac") then
                    if _SetOnCook ~= nil then
                        _SetOnCook(inst, product, chef)
                    end
                end
            end
        end
        local _testforattunedskill = inst.testforattunedskill

        inst.testforattunedskill = function(inst, owner)
            _testforattunedskill(inst, owner)
            if owner.components.skilltreeupdater:IsActivated("willow_attuned_lighter") and inst.components.channelcastable ~= nil then
                local _onstartchannelingfn                          = inst.components.channelcastable.onstartchannelingfn
                local _onstopchannelingfn                           = inst.components.channelcastable.onstopchannelingfn

                inst.components.channelcastable.onstopchannelingfn  = function(inst, user)
                    _onstopchannelingfn(inst, user)
                    if inst.smog_task then
                        inst.smog_task:Cancel()
                    end
                    inst.smog_task = nil
                end

                inst.components.channelcastable.onstartchannelingfn = function(inst, user)
                    _onstartchannelingfn(inst, user)
                    local lighter = user.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)

                    inst.smog_task = inst:DoPeriodicTask(0.3, function(inst)
                        local x, y, z = inst.Transform:GetWorldPosition()
                        local smog = TheSim:FindEntities(x, y, z, 8, { "smog" })
                        for k, v in pairs(smog) do
                            v:Remove()
                        end
                    end)
                end
            end
        end
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

    --if TUNING.DSTU.WILLOW_INSULATION then
        --env.AddPrefabPostInit("willow", function(inst)
            --if not TheWorld.ismastersim then
                --return
            --end
            --inst.components.temperature.inherentinsulation = -TUNING.INSULATION_MED
            --inst.components.temperature.inherentsummerinsulation = TUNING.INSULATION_MED
        --end)
    --end
end
