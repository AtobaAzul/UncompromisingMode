local assets =
{
	Asset("ANIM", "anim/mastupgrade_lamp.zip"),
}

local prefabs =
{
	"collapse_small",
}

local LAMP_LIGHT_OVERRIDE = 1

local function ondeconstructstructure(inst, caster)
	local recipe = AllRecipes[inst.prefab]

	for i, v in ipairs(recipe.ingredients) do
		for n = 1, v.amount do
			inst._mast.components.lootdropper:SpawnLootPrefab(v.type)
		end
	end
end

local function mast_burnt(inst)
	if inst._mast ~= nil and inst._mast:IsValid() then
		inst.components.lootdropper:DropLoot(inst._mast:GetPosition())
		SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	end
end

local function onbuilt(inst)
	inst.AnimState:PlayAnimation("place")
	inst.SoundEmitter:PlaySound("dontstarve/common/place_structure_stone") --AKA "generic place sound" 

	inst.animqueueclear = inst:ListenForEvent("animover", function(inst)
		inst.startupdating = true

		if inst.animqueueclear ~= nil then
			inst.animqueueclear:Cancel()
		end

		inst.animqueueclear = nil
		inst.canupdatelight = true
	end)
end

local function onremove(inst) -----------------------------------------------------------------------------
	if inst._mast ~= nil and inst._mast:IsValid() then
		inst._mast._turbine = nil
	end
end

local function OnEntityReplicated(inst)
	local parent = inst.entity:GetParent()
	if parent ~= nil and parent.prefab == "mast" or parent.prefab == "mast_malbatross" then
		parent.highlightchildren = { inst }
	end
end

local function onremovelight(light)
	inst:Remove()
end

local function UpdateLight(inst)
	if inst._mast ~= nil and inst.canupdatelight ~= nil then
		local velocity = 0
		local sandstorm = 0

		local x, y, z = inst._mast.Transform:GetWorldPosition()

		local boat = TheWorld.Map:GetPlatformAtPoint(x, z)

		if boat ~= nil and boat:HasTag("boat") and boat.components ~= nil and boat.components.boatphysics ~= nil then
			velocity = boat.components.boatphysics:GetVelocity()
		end

		if TheWorld.components.sandstorms then
			sandstorm = (TheWorld.components.sandstorms ~= nil and TheWorld.components.sandstorms:IsSandstormActive()) and
				TheWorld.Map:FindVisualNodeAtPoint(x, y, z, "sandstorm") and 2 or 0
		end

		local snowstorm = ((TheWorld.net ~= nil and TheWorld.net:HasTag("snowstormstartnet")) or TheWorld:HasTag("snowstormstart")) and 2 or 0

		local tornado = inst:HasTag("under_the_weather") and 2 or 0

		local finalnums = velocity + sandstorm + snowstorm + tornado

		if finalnums >= 1.5 then
			if inst.powerlevel > 1000 then

				if not inst.AnimState:IsCurrentAnimation("spin_fast") then
					inst.AnimState:PlayAnimation("spin_fast", true)
				end

				inst.SoundEmitter:PlaySound("UCSounds/um_windturbine/fast_spin", "twirl")
				inst.powerlevel = 1000
			elseif inst.powerlevel < 400 then

				if not inst.AnimState:IsCurrentAnimation("spin_slow") then
					inst.AnimState:PlayAnimation("spin_slow", true)
				end

				inst.SoundEmitter:PlaySound("UCSounds/um_windturbine/slow_spin", "twirl")
				inst.powerlevel = inst.powerlevel + finalnums
			elseif inst.powerlevel > 400 and finalnums >= 3 then

				if not inst.AnimState:IsCurrentAnimation("spin_med") then
					inst.AnimState:PlayAnimation("spin_med", true)
				end

				inst.SoundEmitter:PlaySound("UCSounds/um_windturbine/med_spin", "twirl")
				inst.powerlevel = inst.powerlevel + finalnums
			end
		elseif inst.powerlevel > 0 then
			if not inst.AnimState:IsCurrentAnimation("idle") then
				inst.SoundEmitter:KillSound("twirl")
				inst.AnimState:PlayAnimation("idle")
			end

			inst.powerlevel = inst.powerlevel - 3.5
		elseif inst.powerlevel < 0 then
			inst.powerlevel = 0
		end

		if inst.powerlevel < 0 then
			inst.lightlevel = 0
		else
			inst.lightlevel = inst.powerlevel / 800
		end

		if inst.lightlevel < 0 then
			inst.lightlevel = 0
		elseif inst.lightlevel > 1 then
			inst.lightlevel = 1
		end

		local lerpval = Lerp(.6, .9, inst.lightlevel)
		
		if lerpval > .7 then
			lerpval = .7
		end

		if inst.lightlevel > 0 then

			inst._mast.Light:SetColour(180 / 255, 195 / 255, 150 / 255)
			inst._mast.Light:Enable(true)
			inst._mast.Light:SetIntensity(lerpval)
			inst._mast.Light:SetRadius(inst.lightlevel * 9)
			inst._mast.Light:SetFalloff(.9)

			if inst._light == nil then
				inst._light = SpawnPrefab("mastupgrade_windturbine_light")
				inst._light.entity:SetParent(inst.entity)
				inst.entity:AddFollower()
				inst._light.AnimState:SetMultColour(1, 1, 1, inst.lightlevel / 2)
			else
				inst._light.AnimState:SetMultColour(1, 1, 1, inst.lightlevel / 2)
			end
		else

			inst._mast.Light:SetColour(180 / 255, 195 / 255, 150 / 255)
			inst._mast.Light:SetIntensity(lerpval)
			inst._mast.Light:SetRadius(inst.lightlevel * 7)
			inst._mast.Light:SetFalloff(.9)

			if inst._light ~= nil then
				inst._light:Remove()
				inst._light = nil
			end
		end

		if inst.animqueueclear == nil then
			inst.AnimState:SetDeltaTimeMultiplier(finalnums)
		end
	end
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	inst.AnimState:SetBank("mastupgrade_windturbine")
	inst.AnimState:SetBuild("mastupgrade_windturbine")
	inst.AnimState:PlayAnimation("idle")

	inst:AddTag("NOCLICK")
	inst:AddTag("DECOR")
	inst:AddTag("um_windturbine")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		inst.OnEntityReplicated = OnEntityReplicated
		return inst
	end

	inst.lightlevel = 0
	inst.powerlevel = 0
	inst.lightlevel = 0
	inst.maxlevel = 0
	inst._light = nil

	inst.animqueueclear = nil
	inst.canupdatelight = nil

	inst.persists = false

	inst:AddComponent("updatelooper")
	inst.components.updatelooper:AddOnUpdateFn(UpdateLight)

	inst._mast = nil

	inst:AddComponent("lootdropper")

	inst:ListenForEvent("onbuilt", onbuilt)
	inst:ListenForEvent("onremove", onremove)

	inst:ListenForEvent("mast_burnt", mast_burnt)

	inst:ListenForEvent("ondeconstructstructure", ondeconstructstructure)

	return inst
end

local function itemfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("mastupgrade_windturbine")
	inst.AnimState:SetBuild("mastupgrade_windturbine")
	inst.AnimState:PlayAnimation("item")

	MakeInventoryFloatable(inst, "med", nil, 0.68)

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("tradable")

	inst:AddComponent("inspectable")

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/mastupgrade_windturbine_item.xml"
	inst.components.inventoryitem:SetSinks(false)

	inst:AddComponent("upgrader")
	inst.components.upgrader.upgradetype = UPGRADETYPES.MAST
	inst.components.upgrader.upgradevalue = 1337

	MakeHauntableLaunchAndSmash(inst)

	return inst
end

local function lightfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	inst.AnimState:SetBank("mastupgrade_windturbine")
	inst.AnimState:SetBuild("mastupgrade_windturbine")
	inst.AnimState:PlayAnimation("light")

	inst:AddTag("FX")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst.persists = false

	return inst
end

return Prefab("mastupgrade_windturbine_item", itemfn, assets, prefabs),
	Prefab("mastupgrade_windturbine", fn, assets),
	Prefab("mastupgrade_windturbine_light", lightfn, assets)
