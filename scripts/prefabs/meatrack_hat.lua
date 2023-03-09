local assets=
{
	--[[Asset("ANIM", "anim/hat_gasmask.zip"),
	Asset("ATLAS", "images/inventoryimages/gasmask.xml"),
	Asset("IMAGE", "images/inventoryimages/gasmask.tex"),]]
}

local function onequip(inst, owner)
	if inst.meat ~= nil then
		owner.AnimState:OverrideSymbol("swap_hat", "meatrack_hat_swap_"..inst.meat, "swap_hat")
	else
		owner.AnimState:OverrideSymbol("swap_hat", "meatrack_hat_swap", "swap_hat")	
	end
	
	--inst.components.dryer:Resume()
	
	owner.AnimState:Show("HAT")
	owner.AnimState:Hide("HAIR_HAT")
	owner.AnimState:Show("HAIR_NOHAT")
	owner.AnimState:Show("HAIR")
	owner.AnimState:Show("HAIRFRONT")

    if inst._owner ~= nil then
        inst:RemoveEventCallback("locomote", inst._onlocomote, inst._owner)
    end
	
    inst._owner = owner
    inst:ListenForEvent("locomote", inst._onlocomote, owner)
		
end
 
local function onunequip(inst, owner)
	--inst.components.dryer:Pause()
	
    owner.AnimState:ClearOverrideSymbol("swap_hat")
	owner.AnimState:ClearOverrideSymbol("face")
    owner.AnimState:Hide("HAT")

    if inst._owner ~= nil then
        inst:RemoveEventCallback("locomote", inst._onlocomote, inst._owner)
        inst._owner = nil
    end
end

local function onstartdrying(inst, ingredient, buildfile)

	inst.meat = ingredient
	inst.SoundEmitter:PlaySound("dontstarve/common/together/put_meat_rack")
	
	if resolvefilepath("images/inventoryimages/meatrack_hat_"..inst.meat..".xml") ~= nil then
		local owner = inst.components.inventoryitem.owner
		inst.AnimState:SetBank("meatrack_hat_swap")
		inst.AnimState:SetBuild("meatrack_hat_swap_"..inst.meat)
		inst.AnimState:PlayAnimation("BUILD_PLAYER")  
		
		inst.components.inventoryitem.atlasname = "images/inventoryimages/meatrack_hat_"..inst.meat..".xml"
		inst.components.inventoryitem:ChangeImageName("meatrack_hat_"..inst.meat)
		
		if owner ~= nil and inst.components.equippable:IsEquipped() then
			owner.AnimState:OverrideSymbol("swap_hat", "meatrack_hat_swap_"..inst.meat, "swap_hat")
		else
			--inst.components.dryer:Pause()
		end
	else
		local owner = inst.components.inventoryitem.owner
		inst.AnimState:SetBank("meatrack_hat_swap")
		inst.AnimState:SetBuild("meatrack_hat_swap_default")
		inst.AnimState:PlayAnimation("BUILD_PLAYER")  
		
		inst.components.inventoryitem:ChangeImageName("meatrack_hat_default")
		inst.components.inventoryitem.atlasname = "images/inventoryimages/meatrack_hat_default.xml"
		
		if owner ~= nil and inst.components.equippable:IsEquipped() then
			owner.AnimState:OverrideSymbol("swap_hat", "meatrack_hat_swap_default", "swap_hat")
		else
			--inst.components.dryer:Pause()
		end
	end
end

local function onharvested(inst)
end

local function DropMeat(inst)
	inst.meat = nil

	local owner = inst.components.inventoryitem.owner
	if owner ~= nil then
		if inst.components.equippable:IsEquipped() then
			owner.AnimState:OverrideSymbol("swap_hat", "meatrack_hat_swap", "swap_hat")
		end
		inst.components.dryer:Harvest(owner)
	else
		inst.components.dryer:DropItem()
	end
	
	inst.components.inventoryitem:ChangeImageName("meatrack_hat")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/meatrack_hat.xml"
	
    inst.AnimState:SetBank("meatrack_hat_swap")
    inst.AnimState:SetBuild("meatrack_hat_swap")
    inst.AnimState:PlayAnimation("BUILD_PLAYER")
	
	inst.components.finiteuses:Use(1)
end

local function ToGround(inst)
	if inst.meat ~= nil then
		if "images/inventoryimages/meatrack_hat_"..inst.meat..".xml" ~= nil then
			inst.components.inventoryitem.atlasname = "images/inventoryimages/meatrack_hat_"..inst.meat..".xml"
			inst.components.inventoryitem:ChangeImageName("meatrack_hat_"..inst.meat)
		else
			inst.components.inventoryitem:ChangeImageName("meatrack_hat_default")
			inst.components.inventoryitem.atlasname = "images/inventoryimages/meatrack_hat_default.xml"
		end
	else
		inst.components.inventoryitem:ChangeImageName("meatrack_hat")
		inst.components.inventoryitem.atlasname = "images/inventoryimages/meatrack_hat.xml"
	end
end

local function ToInventory(inst)
	if inst.meat ~= nil then
		if "images/inventoryimages/meatrack_hat_"..inst.meat..".xml" ~= nil then
			inst.components.inventoryitem.atlasname = "images/inventoryimages/meatrack_hat_"..inst.meat..".xml"
			inst.components.inventoryitem:ChangeImageName("meatrack_hat_"..inst.meat)
		else
			inst.components.inventoryitem:ChangeImageName("meatrack_hat_default")
			inst.components.inventoryitem.atlasname = "images/inventoryimages/meatrack_hat_default.xml"
		end
	else
		inst.components.inventoryitem:ChangeImageName("meatrack_hat")
		inst.components.inventoryitem.atlasname = "images/inventoryimages/meatrack_hat.xml"
	end
end

local function getstatus(inst)
    if inst.components.dryer ~= nil then
		local pst = inst.components.dryer.foodtype == FOODTYPE.MEAT and "" or "_NOTMEAT"
        return (inst.components.dryer:IsDone() and "DONE"..pst)
            or (inst.components.dryer:IsDrying() and
                (TheWorld.state.israining and "DRYINGINRAIN"..pst or "DRYING"..pst))
            or nil
    end
end

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    MakeInventoryPhysics(inst)
	
    inst.AnimState:SetBank("meatrack_hat_swap")
    inst.AnimState:SetBuild("meatrack_hat_swap")
    inst.AnimState:PlayAnimation("BUILD_PLAYER")  

	inst:AddTag("hats")
	
    inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.meat = nil

	inst:AddComponent("inspectable")
	inst.components.inspectable.getstatus = getstatus
	
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/meatrack_hat.xml"

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip )
	
    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetOnFinished(inst.Remove)
    inst.components.finiteuses:SetMaxUses(5)
    inst.components.finiteuses:SetUses(5)
	
    inst:AddComponent("lootdropper")
	
	inst:AddComponent("dryer")
	inst.components.dryer:SetStartDryingFn(onstartdrying)
	inst.components.dryer:SetOnHarvestFn(onharvested)
	inst.components.dryer:SetDoneDryingFn(DropMeat)
	
	inst:AddComponent("tradable")
	
    inst._onlocomote = function(owner)
		inst.components.dryer:Pause()

		local value = 0.1

		if owner ~= nil then
			if owner.components.rider ~= nil and owner.components.rider:IsRiding() then
				value = value + 0.05
			end

			 if owner:HasTag("pinetreepioneer") then
				value = value + 0.05
			end
		end

		if TheWorld.state.israining then
			value = value / 4
		end
			
		if inst.components.dryer.remainingtime ~= nil and inst.components.dryer.remainingtime > 1 then
			inst.components.dryer.remainingtime = inst.components.dryer.remainingtime - value
		end
			
		inst.components.dryer:Resume()
    end
	
	inst:ListenForEvent("ondropped", ToGround)
	inst:ListenForEvent("onputininventory", ToInventory)
	
    
	MakeHauntableLaunch(inst)
    return inst
end
 
return Prefab("meatrack_hat", fn, assets)