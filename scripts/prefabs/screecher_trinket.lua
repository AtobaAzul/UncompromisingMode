local assets =
{
    Asset("ANIM", "anim/twigs.zip"),
    Asset("SOUND", "sound/common.fsb"),
}
local puff_fx = {"halloween_firepuff_1", "halloween_firepuff_2", "halloween_firepuff_3", }

local function FuelTaken(inst, taker)
    if taker ~= nil and taker.SoundEmitter ~= nil then
		SpawnPrefab("firesplash_fx").Transform:SetPosition(taker.Transform:GetWorldPosition())
        taker.SoundEmitter:PlaySound("UCSounds/screecher/screecher")

		local x, y, z = taker.Transform:GetWorldPosition()
		local ents = TheSim:FindEntities(x, y, z, 4)

		for i, v in ipairs(ents) do
			if v ~= inst and v:IsValid() and not v:IsInLimbo() then
				if v:IsValid() and not v:IsInLimbo() then
					if v.components.fueled == nil and
						v.components.burnable ~= nil and
						not v.components.burnable:IsBurning() and
						not v:HasTag("burnt") then
						v.components.burnable:Ignite()
					end
				end
			end
		end
    end
end

local function onignite(inst)
    inst.SoundEmitter:PlaySound("UCSounds/screecher/screecher")
	SpawnPrefab("firesplash_fx").Transform:SetPosition(inst.Transform:GetWorldPosition())
	
	local x, y, z = inst.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x, y, z, 4)

	for i, v in ipairs(ents) do
		if v ~= inst and v:IsValid() and not v:IsInLimbo() then
			if v:IsValid() and not v:IsInLimbo() then
				if v.components.fueled == nil and
					v.components.burnable ~= nil and
					not v.components.burnable:IsBurning() and
					not v:HasTag("burnt") then
					v.components.burnable:Ignite()
				end
			end
		end
	end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("twigs")
    inst.AnimState:SetBuild("screecher_trinket")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/screecher_trinket.xml"
	
    inst:AddComponent("tradable")
    -----------------
    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL
    inst.components.fuel:SetOnTakenFn(FuelTaken)

    ---------------------
    MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
    MakeSmallPropagator(inst)
    MakeHauntableLaunchAndIgnite(inst)
	
    inst:ListenForEvent("onignite", onignite)

    return inst
end

return Prefab("screecher_trinket", fn, assets, prefabs)
