local assets =
{
    Asset("ANIM", "anim/lantern.zip"),
    Asset("ANIM", "anim/swap_lantern.zip"),
    Asset("SOUND", "sound/wilson.fsb"),
    Asset("INV_IMAGE", "lantern_lit"),
}

local prefabs =
{
    "lanternlight",
}

local function DoTurnOffSound(inst, owner)
    inst._soundtask = nil
    inst.SoundEmitter:PlaySound("dontstarve/wilson/lantern_off")
end

local function PlayTurnOnSound(inst)
    if not inst.components.fueled:IsEmpty() then
		inst._soundtask = nil
		inst.SoundEmitter:PlaySound("dontstarve/wilson/lantern_on")
	end
end

local function Salted(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
    local saltedfx = SpawnPrefab("collapse_small")
    saltedfx.Transform:SetPosition(x, 2, z)
    saltedfx.Transform:SetScale(0.2, 0.2, 0.2)
	inst.SoundEmitter:PlaySound("dontstarve/creatures/together/antlion/sfx/ground_break")
	
		local ents = TheSim:FindEntities(x, y, z, 5, {"snowpile_basic"})
			if #ents > 0 then
				for i, v in ipairs(ents) do
					if v:IsValid() then
                            -- Don't net any insects when we do work
                            -- Don't net any insects when we do work
						--if self.destroyer and
						if v.components.workable ~= nil and
							v.components.workable:CanBeWorked() and
							v.components.workable.action ~= ACTIONS.NET then
							v.components.workable:Destroy(inst)
						end
					end
				end
			end
			
		local ents2 = TheSim:FindEntities(x, y, z, 5, {"snowish"})
			if #ents2 > 0 then
				for i, v2 in ipairs(ents2) do
					if v2:IsValid() and
						v2.components.health ~= nil and
						not v2.components.health:IsDead() and 
						inst.components.combat:CanTarget(v2) then
						inst.components.combat:DoAttack(v2, nil, nil, nil, 1)
					end
				end
			end
			
		if not TheWorld.state.iswinter then
			inst.components.equippable.walkspeedmult = 1
		end
end

local function turnon(inst)
    if not inst.components.fueled:IsEmpty() then
	
	if inst.salttask == nil then
		inst.salttask = inst:DoPeriodicTask(2, Salted)
	end
	
    inst.components.insulator:SetInsulation(TUNING.INSULATION_SMALL)
		
	if not inst.SoundEmitter:PlayingSound("idlesound") then
		inst.SoundEmitter:PlaySound("dontstarve/common/research_machine_gift_active_LP", "idlesound")
		inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/firesupressor_idle", "idlesound")
	end
	
        inst.components.fueled:StartConsuming()
		
		if TheWorld.state.iswinter then
			inst.components.equippable.walkspeedmult = 1.1
		else
			inst.components.equippable.walkspeedmult = 1
		end
		
		inst:AddTag("saltpack_protection")
        local owner = inst.components.inventoryitem.owner

        inst.AnimState:PlayAnimation("idle_on")

        if owner ~= nil and inst.components.equippable:IsEquipped() then
            owner.AnimState:Show("LANTERN_OVERLAY")
        end

        inst.components.machine.ison = true
        inst.components.inventoryitem:ChangeImageName((inst:GetSkinName() or "lantern").."_lit")
        inst:PushEvent("lantern_on")
    end
end

local function turnoff(inst)
	if inst.salttask ~= nil then
		inst.salttask:Cancel()
	end
	inst.salttask = nil
	
	inst:RemoveTag("saltpack_protection")
	
    inst.components.insulator:SetInsulation(0)
	
	inst.SoundEmitter:KillSound("idlesound")

    inst.components.fueled:StopConsuming()
	inst.components.equippable.walkspeedmult = 1

    DoTurnOffSound(inst)

    inst.AnimState:PlayAnimation("idle_off")

    if inst.components.equippable:IsEquipped() then
        inst.components.inventoryitem.owner.AnimState:Hide("LANTERN_OVERLAY")
    end

    inst.components.machine.ison = false
    inst.components.inventoryitem:ChangeImageName(inst:GetSkinName()) --nil if no skin
    inst:PushEvent("lantern_off")
end

local function OnRemove(inst)
    if inst._soundtask ~= nil then
        inst._soundtask:Cancel()
    end
end

local function ondropped(inst)
    turnoff(inst)
    turnon(inst)
end

local function onequip(inst, owner)
    local skin_build = inst:GetSkinBuild()
    if skin_build ~= nil then
        owner:PushEvent("equipskinneditem", inst:GetSkinName())
        owner.AnimState:OverrideItemSkinSymbol("backpack", skin_build, "backpack", inst.GUID, "swap_saltpack" )
        owner.AnimState:OverrideItemSkinSymbol("swap_body", skin_build, "swap_body", inst.GUID, "swap_saltpack" )
    else
        owner.AnimState:OverrideSymbol("backpack", "swap_saltpack", "backpack")
        owner.AnimState:OverrideSymbol("swap_body", "swap_saltpack", "swap_body")
    end

    if inst.components.fueled:IsEmpty() then
        owner.AnimState:Hide("LANTERN_OVERLAY")
    else
        owner.AnimState:Show("LANTERN_OVERLAY")
        turnon(inst)
    end
end

local function onunequip(inst, owner)
    local skin_build = inst:GetSkinBuild()
    if skin_build ~= nil then
        owner:PushEvent("unequipskinneditem", inst:GetSkinName())
    end
    owner.AnimState:ClearOverrideSymbol("swap_body")
    owner.AnimState:ClearOverrideSymbol("backpack")
	
    owner.AnimState:ClearOverrideSymbol("lantern_overlay")
    owner.AnimState:Hide("LANTERN_OVERLAY")
end

local function nofuel(inst)
    if inst.components.equippable:IsEquipped() and inst.components.inventoryitem.owner ~= nil then
        local data =
        {
            prefab = inst.prefab,
            equipslot = inst.components.equippable.equipslot,
        }
        turnoff(inst)
    else
        turnoff(inst)
    end
	if inst.salttask ~= nil then
		inst.salttask:Cancel()
	end
end

local function ontakefuel(inst)
    inst.SoundEmitter:PlaySound("dontstarve/common/fireAddFuel")
    if inst.components.equippable:IsEquipped() then
        turnon(inst)
    end
end

--------------------------------------------------------------------------

--------------------------------------------------------------------------

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("backpack1")
    inst.AnimState:SetBuild("swap_saltpack")
    inst.AnimState:PlayAnimation("anim")
	
	inst.salttask = nil

    MakeInventoryFloatable(inst, "med", 0.2, 0.65)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")

    inst.components.inventoryitem:SetOnDroppedFn(ondropped)
    inst.components.inventoryitem:SetOnPutInInventoryFn(turnoff)

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
	
	inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(TUNING.BEEGUARD_DAMAGE)
	
    inst:AddComponent("insulator")

    inst:AddComponent("fueled")

    inst:AddComponent("machine")
    inst.components.machine.turnonfn = turnon
    inst.components.machine.turnofffn = turnoff
    inst.components.machine.cooldowntime = 0

    inst.components.fueled:InitializeFuelLevel(TUNING.TORCH_FUEL * 2)
    inst.components.fueled:SetDepletedFn(nofuel)
	
    inst.components.fueled:SetTakeFuelFn(ontakefuel)
    inst.components.fueled:SetFirstPeriod(TUNING.TURNON_FUELED_CONSUMPTION * 3, TUNING.TURNON_FULL_FUELED_CONSUMPTION * 3)
    inst.components.fueled.accepting = true

    MakeHauntableLaunch(inst)

    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    inst.OnRemoveEntity = OnRemove

	return inst
	
end

return Prefab("saltpack", fn, assets, prefabs)
