local assets =
{
    Asset("ANIM", "anim/honey_trail.zip"),
}

local HONEYTRAILSLOWDOWN_MUST_TAGS = { "locomotor" }
local HONEYTRAILSLOWDOWN_CANT_TAGS = { "player", "playerghost", "INLIMBO" }

local function OnIsFadingDirty(inst)
    if inst._isfading:value() then
        inst.task:Cancel()
    end
end

local function OnStartFade(inst)
    inst.AnimState:PlayAnimation(inst.trailname.."_pst")
    inst._isfading:set(true)
    inst.task:Cancel()
end

local function OnAnimOver(inst)
    if inst.AnimState:IsCurrentAnimation(inst.trailname.."_pre") then
        inst.AnimState:PlayAnimation(inst.trailname)
        inst:DoTaskInTime(inst.duration, OnStartFade)
    elseif inst.AnimState:IsCurrentAnimation(inst.trailname.."_pst") then
        inst:Remove()
    end
end

local function OnInit(inst, scale)
    local x, y, z = inst.Transform:GetWorldPosition()
    if scale == nil then
        scale = inst.Transform:GetScale()
    end
    inst.task:Cancel()
end

local function SetVariation(inst, rand, scale, duration)
    if inst.trailname == nil then
        inst.Transform:SetScale(scale, scale, scale)

        inst.trailname = "trail"..tostring(rand)
        inst.duration = duration
        inst.SoundEmitter:PlaySound("dontstarve/creatures/together/bee_queen/honey_drip")
        inst.AnimState:PlayAnimation(inst.trailname.."_pre")
        inst:ListenForEvent("animover", OnAnimOver)

        OnInit(inst, scale)
    end
end

local function TrySlowdown(inst, target)
	local debuffkey = inst.prefab
	if target._tarammo_speedmulttask ~= nil then
		target._tarammo_speedmulttask:Cancel()
	end
	
	target._tarammo_speedmulttask = target:DoTaskInTime(0.25, function(i) i.components.locomotor:RemoveExternalSpeedMultiplier(i, debuffkey) i._tarammo_speedmulttask = nil end)

	target.components.locomotor:SetExternalSpeedMultiplier(target, debuffkey, 0.44)
end

local function DoAreaSlow(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x, y, z, 2, HONEYTRAILSLOWDOWN_MUST_TAGS, HONEYTRAILSLOWDOWN_CANT_TAGS)
	for i, v in ipairs(ents) do
		if v.honeyslowtask ~= nil and v:HasTag("flying") or not v:HasTag("flying") then
			if v.components ~= nil and v.components.locomotor ~= nil then
				TrySlowdown(inst, v)
			end
		end
	end
end

local OBSIDIAN_AURA_EXCLUDE_TAGS = { "player", "playerghost", "companion", "ghost", "shadow", "shadowminion", "noauradamage", "INLIMBO", "notarget", "noattack", "flight", "flying", "dragonfly", "lavae", "invisible" }

local function DefaultBurnFn(inst)

    local x, y, z = inst.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x, y, z, 5, nil, OBSIDIAN_AURA_EXCLUDE_TAGS)
	for i, v in ipairs(ents) do
		if inst.components.propagator ~= nil and v.components.combat ~= nil and v.components.health ~= nil then
			v.components.health:DoDelta(-4)
			SpawnPrefab("halloween_firepuff_1").Transform:SetPosition(v.Transform:GetWorldPosition())
		end
	end

	inst.persists = false
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst:AddTag("NOCLICK")

    inst.AnimState:SetBank("honey_trail")
    inst.AnimState:SetBuild("honey_trail")
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(3)
	inst.AnimState:SetMultColour(0, 0, 0, 1)

    inst._isfading = net_bool(inst.GUID, "honey_trail._isfading", "isfadingdirty")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        inst:ListenForEvent("isfadingdirty", OnIsFadingDirty)
        inst.task = inst:DoPeriodicTask(0, OnInit)

        return inst
    end
    inst:AddTag("tartrail")
    inst.SetVariation = SetVariation

    inst:AddComponent("burnable")
    inst.components.burnable.canlight = true

    MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
    MakeSmallPropagator(inst)
	
    inst.components.burnable:SetOnIgniteFn(DefaultBurnFn)


    inst.persists = false
	inst:DoTaskInTime(0, DoAreaSlow)
	inst:DoPeriodicTask(0.2, DoAreaSlow)
	
    inst.task = inst:DoTaskInTime(0, inst.Remove)

    return inst
end

return Prefab("wixietar_trail", fn, assets)
