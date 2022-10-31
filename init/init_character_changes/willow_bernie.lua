local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

if env.GetModConfigData("bernie") then
	local function gobig(inst)
		--no
		--[[
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
	end]]
	end

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

	local function SetNameBig(inst)
		inst.pickname = "BERNIE!"
		if inst:GetSkinName() ~= nil then
			inst.pickname = "ASHLEY!"
		end
		inst.components.named:SetName(inst.pickname)
	end

	env.AddPrefabPostInit("bernie_active", function(inst)

		--inst:AddTag("irreplaceable")

		if not TheWorld.ismastersim then
			return
		end
		--[[
    inst.components.inspectable.getstatus = getstatus
	
	inst:AddComponent("named")
	inst:DoTaskInTime(0, SetName)
	
    inst:AddComponent("burnable")
    inst.components.burnable:SetFXLevel(1)
    inst.components.burnable:SetBurnTime(30)
    inst.components.burnable.canlight = true
    inst.components.burnable:AddBurnFX("character_fire", Vector3(0, 0, 1), "bernie_torso")
	]]
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

		--inst:AddTag("irreplaceable")

		if not TheWorld.ismastersim then
			return
		end
		--[[
    inst.components.inspectable.getstatus = getstatus

	inst:AddComponent("named")
	inst:DoTaskInTime(0, SetNameBig)
    
    inst:AddComponent("burnable")
    inst.components.burnable:SetFXLevel(3)
    inst.components.burnable.canlight = false
    inst.components.burnable:SetBurnTime(60)
    inst.components.burnable:AddBurnFX("character_fire", Vector3(0, 0, 1), "big_body")
	--inst.components.burnable:SetOnBurntFn(revertbrnt)
	inst.components.burnable:SetOnExtinguishFn(revertex)
	MakeSmallPropagator(inst)
	
    inst.OnPreLoad = OnPreLoad]]

	end)
end

env.AddPrefabPostInit("bernie_inactive", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	local _OnEquip = inst.components.equippable.onequipfn
	local _OnUnequip = inst.components.equippable.onunequipfn

	inst.components.equippable.onunequipfn = function(inst, owner)
		print("onunequipfn")
		owner:RemoveTag("notarget_shadow")
		_OnUnequip(inst,owner)
	end

	inst.components.equippable.onequipfn = function(inst, owner)
		print("onequipfn")
		owner:AddTag("notarget_shadow")
		_OnEquip(inst,owner)
	end
end)