local assets =
{
    Asset("ANIM", "anim/book_maxwell.zip"),

    Asset("SOUND", "sound/together.fsb"),
}

local function canread(inst, reader)
	return (inst.components.sanity:GetMaxWithPenalty() >= TUNING.DSTU.OLD_SHADOWWAXWELL_SANITY_COST) and
		(inst.components.health.currenthealth > TUNING.DSTU.SHADOWWAXWELL_HEALTH_COST)
end

local function onread(inst, reader)
	if not reader:HasTag("codexumbrareader") then
		return false
	end

	--Check sanity
	if not canread(reader) then
		if reader.components.talker then
			if reader.components.sanity:GetMaxWithPenalty() < TUNING.DSTU.OLD_SHADOWWAXWELL_SANITY_COST then
				reader.components.talker:Say(GetString(reader.prefab, "ANNOUNCE_NOSANITY"))
			elseif reader.components.health.currenthealth <= TUNING.DSTU.SHADOWWAXWELL_HEALTH_COST then
				reader.components.talker:Say(GetString(reader.prefab, "ANNOUNCE_NOHEALTH"))
			end
			return true
		end
	end

		--Check reagent
	if not reader.components.inventory:Has("nightmarefuel", TUNING.DSTU.SHADOWWAXWELL_FUEL_COST) then
		if reader.components.talker then
			reader.components.talker:Say(GetString(reader.prefab, "ANNOUNCE_NOFUEL"))
			return true
		end
	end


	local readx, ready, readz = reader.Transform:GetWorldPosition()
	local shadowmax = reader.components.petleash:SpawnPetAt(readx, ready, readz, "old_shadowwaxwell_1")

	if shadowmax ~= nil then
		reader.components.inventory:ConsumeByName("nightmarefuel", TUNING.DSTU.SHADOWWAXWELL_FUEL_COST)
		shadowmax:DoTaskInTime(0, function(shadowmax) shadowmax.sg:GoToState("jumpout") end)
		reader.components.health:DoDelta(-TUNING.DSTU.SHADOWWAXWELL_HEALTH_COST)
		reader.components.sanity:RecalculatePenalty()
		inst.SoundEmitter:PlaySound("dontstarve/maxwell/shadowmax_appear")
	end

	return true
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("book_maxwell")
    inst.AnimState:SetBuild("book_maxwell")
    inst.AnimState:PlayAnimation("idle")

	inst:AddTag("book")
    inst:AddTag("shadowmagic")

    MakeInventoryFloatable(inst, "med", nil, 0.75)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst.swap_build = "book_maxwell"

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/codex_mantra.xml"

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.MED_FUEL

	inst:AddComponent("book")
	inst.components.book.onread = onread

	MakeSmallBurnable(inst, TUNING.MED_BURNTIME)
	MakeSmallPropagator(inst)
	MakeHauntableLaunch(inst)
	
    return inst
end

return Prefab("codex_mantra", fn, assets)