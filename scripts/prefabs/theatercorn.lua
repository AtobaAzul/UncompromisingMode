local function oneatenfn(inst, eater)
	if eater.components.debuffable ~= nil and eater.components.debuffable:IsEnabled() and
                not (eater.components.health ~= nil and eater.components.health:IsDead()) and
                not eater:HasTag("playerghost") then
				
                local x,y,z = eater.Transform:GetWorldPosition()
				local combatents = TheSim:FindEntities(x,y,z,20,{"_combat"})
				local count = 0
					for i,v in ipairs(combatents) do
						if v.components.combat ~= nil and v.components.combat.target ~= nil then
							count = count + 1
						end
						if v:HasTag("epic") then
							count = count + 5
						end
					end
				if count > 0 and count <= 5 then
					eater.tempamusetier = 1
				end
				if count > 5 and count <= 10 then
					eater.tempamusetier = 2
				end
				if count > 10 and count<= 15 then
					eater.tempamusetier = 3
				end	
				if count > 15 then
					eater.tempamusetier = 4
				end						
				eater.components.debuffable:AddDebuff("buff_amusementcorn", "buff_amusementcorn")
				eater:DoTaskInTime(1,function(eater) if eater.tempamusetier ~= nil then eater.tempamusetier = nil end end)
	end
end
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("theatercorn")
    inst.AnimState:SetBuild("theatercorn")
    inst.AnimState:PlayAnimation("ground")

    MakeInventoryFloatable(inst)

	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("stackable")

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/theatercorn.xml"
    inst:AddComponent("edible")
    inst.components.edible.healthvalue = 20
    inst.components.edible.hungervalue = 37.5
    inst.components.edible.sanityvalue = 0
    inst.components.edible.foodtype = FOODTYPE.VEGGIE

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime((10*TUNING.PERISH_TWO_DAY))
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    MakeHauntableLaunchAndPerish(inst)
	inst.components.edible:SetOnEatenFn(oneatenfn)
	inst:AddTag("preparedfood")
    return inst
end

return Prefab("theatercorn", fn)
