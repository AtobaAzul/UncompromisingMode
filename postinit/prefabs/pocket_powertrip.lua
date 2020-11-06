local env = env
GLOBAL.setfenv(1, GLOBAL)

local function onequipsummer(inst, owner)
    owner.AnimState:OverrideSymbol("swap_body", "armor_trunkvest_summer", "swap_body")
    inst.components.fueled:StartConsuming()
    inst.components.container:Open(owner)
end
local function onequipwinter(inst, owner)
    owner.AnimState:OverrideSymbol("swap_body", "armor_trunkvest_winter", "swap_body")
    inst.components.fueled:StartConsuming()
    inst.components.container:Open(owner)
end

local function onequipreflect(inst, owner)
    owner.AnimState:OverrideSymbol("swap_body", "torso_reflective", "swap_body")
    inst.components.fueled:StartConsuming()
	inst.components.container:Open(owner)
end

local function onunequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")
    inst.components.fueled:StopConsuming()
    inst.components.container:Close(owner)
end

local function ExplodeInventory(inst)
if inst.components.container ~= nil then
inst.components.container:DropEverything()
end
inst:Remove()
end

local function Folded(inst)
	if inst.components.container ~= nil then
		inst:DoTaskInTime(0, function(inst) 
			local owner = inst.components.inventoryitem.owner
			
			if not inst.components.equippable:IsEquipped() and owner ~= nil then
				if #inst.components.container:FindItems( function(item) return item.components.inventoryitem ~= nil end ) > 0 then
					owner.SoundEmitter:PlaySound("dontstarve/common/tool_slip")
				end
				inst.components.container:DropEverything() 
			end
		end)
	end
end

env.AddPrefabPostInit("trunkvest_summer", function(inst)
	if not TheWorld.ismastersim then
		inst.OnEntityReplicated = function(inst) 
			inst.replica.container:WidgetSetup("spicepack") 
		end
        return inst
    end
	
    inst:AddComponent("container")
    inst.components.container:WidgetSetup("spicepack")
	
	--inst.components.inventoryitem.cangoincontainer = false
	if inst.components.equippable ~= nil then
		inst.components.equippable:SetOnEquip(onequipsummer)
		inst.components.equippable:SetOnUnequip(onunequip)
	end
	
	if inst.components.waterproofer ~= nil then
		inst.components.waterproofer:SetEffectiveness(0.3)
	end
	
	if inst.components.insulator ~= nil then
		inst.components.insulator:SetInsulation(120)
	end
	
	if inst.components.inventoryitem ~= nil then
		inst.components.inventoryitem:SetOnPutInInventoryFn(Folded)
	end
	
	if inst.components.fueled ~= nil then
		inst.components.fueled:SetDepletedFn(ExplodeInventory)
	end
	
	inst:ListenForEvent("itemget", Folded)
--return inst
end)

env.AddPrefabPostInit("trunkvest_winter", function(inst)
	if not TheWorld.ismastersim then
		inst.OnEntityReplicated = function(inst) 
			inst.replica.container:WidgetSetup("puffvest") 
		end
        return inst
    end
    inst:AddComponent("container")
    inst.components.container:WidgetSetup("puffvest")
	
	--inst.components.inventoryitem.cangoincontainer = false
	if inst.components.equippable ~= nil then
		inst.components.equippable:SetOnEquip(onequipwinter)
		inst.components.equippable:SetOnUnequip(onunequip)
	end
	
	if inst.components.inventoryitem ~= nil then
		inst.components.inventoryitem:SetOnPutInInventoryFn(Folded)
	end
	
	if inst.components.fueled ~= nil then
		inst.components.fueled:SetDepletedFn(ExplodeInventory)
	end
	
	inst:ListenForEvent("itemget", Folded)
--return inst
end)
env.AddPrefabPostInit("reflectivevest", function(inst)
	if not TheWorld.ismastersim then
		inst.OnEntityReplicated = function(inst) 
			inst.replica.container:WidgetSetup("puffvest") 
		end
        return inst
    end
    inst:AddComponent("container")
    inst.components.container:WidgetSetup("puffvest")
	
	--inst.components.inventoryitem.cangoincontainer = false
	if inst.components.equippable ~= nil then
		inst.components.equippable:SetOnEquip(onequipreflect)
		inst.components.equippable:SetOnUnequip(onunequip)
	end
	
    if inst.components.inventoryitem ~= nil then
		inst.components.inventoryitem:SetOnPutInInventoryFn(Folded)
	end
	
	if inst.components.fueled ~= nil then
		inst.components.fueled:SetDepletedFn(ExplodeInventory)
	end
	inst:ListenForEvent("itemget", Folded)
--return inst
end)