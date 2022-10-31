local assets =
{
    Asset("ANIM", "anim/winona_powercell.zip"),
}

local function discharge(inst)
    local cell = (inst.components.stackable and inst.components.stackable:Get(1)) or inst
    cell:Remove()
end

local function OnBurnt(inst)
    --DO NOT BURN BATTERIES.
    local x, y, z = inst.Transform:GetWorldPosition()

	SpawnPrefab("electric_explosion").Transform:SetPosition(x,0,z)
	SpawnPrefab("bishop_charge_hit").Transform:SetPosition(inst.Transform:GetWorldPosition())

	local ents = TheSim:FindEntities(x, 0, z, 5, {"_health"}, { "shadow", "INLIMBO", "chess" })

	if #ents > 0 then
		for i, v in ipairs(ents) do
			if v.components.health ~= nil and not v.components.health:IsDead() then
				if not (v.components.inventory ~= nil and v.components.inventory:IsInsulated()) then
					if v.sg ~= nil then
						v.sg:GoToState("electrocute")
					end
					v.components.health:DoDelta(-30*inst.components.stackable:StackSize(), nil, inst.prefab, nil, inst) --From the onhit stuff...
				else
					v.components.health:DoDelta(-15*inst.components.stackable:StackSize(), nil, inst.prefab, nil, inst)
				end
			else
				if not inst:HasTag("electricdamageimmune") and v.components.health ~= nil then
					v.components.health:DoDelta(-30*inst.components.stackable:StackSize(), nil, inst.prefab, nil, inst) --From the onhit stuff...
				end
			end
		end
    end
    inst:Remove()
end

--hacky workaround but the best way I could do it
--without having to mess with actions.
local function ondeploy(inst, pt, deployer)
    local cell = (inst.components.stackable and inst.components.stackable:Get(1)) or inst

    if deployer:HasTag("batteryuser") then
        deployer.components.batteryuser:ChargeFrom(cell)
    else
        deployer.components.inventory:GiveItem(cell)
        return false
    end
end

local function OnEaten(inst, eater)
    if not eater.components.inventory:IsInsulated() then
        print("no inssulation wx")
        eater.sg:GoToState("electrocute")
        eater.components.health:DoDelta(-TUNING.HEALING_SMALL, false, "lightning")
        eater.components.sanity:DoDelta(-TUNING.SANITY_SMALL)
        if eater.components.talker ~= nil then
            eater:DoTaskInTime(1, eater.components.talker:Say(GetString(eater, "ANNOUNCE_CHARGE_SUCCESS_ELECTROCUTED")))
        end
    else
        print("insulated wx")
        if eater.components.talker ~= nil then
            eater:DoTaskInTime(1, eater.components.talker:Say(GetString(eater, "ANNOUNCE_CHARGE_SUCCESS_INSULATED")))
        end
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()


    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("winona_powercell")
    inst.AnimState:SetBuild("winona_powercell")
    inst.AnimState:PlayAnimation("idle")


    inst.entity:SetPristine()

    inst:AddTag("battery")
    inst:AddTag("powercell")
    inst:AddTag("toolbox_item")

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM

    inst:AddComponent("inspectable")

    MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)
    MakeHauntableLaunchAndIgnite(inst)
    inst.components.burnable:SetOnBurntFn(OnBurnt)

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/powercell.xml"
    inst.components.inventoryitem.sinks = true --throw batteries in the ocean wOOOOOOOO

    --inst:AddComponent("battery")
    --inst.components.battery.onused = discharge

    inst:AddComponent("edible")
    inst.components.edible.foodtype = FOODTYPE.GEARS
    inst.components.edible.healthvalue = 0
    inst.components.edible.hungervalue = 0
    inst.components.edible.sanityvalue = -TUNING.SANITY_SMALL
    inst.components.edible.oneaten = OnEaten

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.MED_LARGE_FUEL*1.25
    inst.components.fuel.fueltype = FUELTYPE.BATTERYPOWER

    return inst
end

return Prefab("powercell", fn, assets)