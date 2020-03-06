local assets_firemeteorwarning =
{
    Asset("ANIM", "anim/meteor_shadow.zip"),
}

local prefabs_firemeteorwarning =
{
    "meteorwarning",
}
	
local assets =
{
    Asset("ANIM", "anim/lavaarena_firestaff_meteor.zip"),
}

local assets_splash =
{
    Asset("ANIM", "anim/lavaarena_fire_fx.zip"),
}

local prefabs =
{
    "firemeteor_splash",
}

local prefabs_splash =
{
    "firemeteor_splashbase",
    "firemeteor_splashhit",
}

local function GetExcludeTags(inst)
		return {"INLIMBO", "notarget", "playerghost"}
end

------------------------

local function AlphaToFade(alpha)
    return math.floor(alpha * 63 + .5)
end

local function FadeToAlpha(fade)
    return fade / 63
end

local function CalculatePeriod(time, starttint, endtint)
    return time / math.max(1, AlphaToFade(endtint) - AlphaToFade(starttint))
end

local DEFAULT_START = .33
local DEFAULT_END = 1
local DEFAULT_DURATION = 1
local DEFAULT_PERIOD = CalculatePeriod(DEFAULT_DURATION, DEFAULT_START, DEFAULT_END)

local function PushAlpha(inst)
    local alpha = FadeToAlpha(inst._fade:value())
    inst.AnimState:OverrideMultColour(alpha, alpha, alpha, alpha)
end

local function UpdateFade(inst)
    if inst._fade:value() < inst._fadeend:value() then
        inst._fade:set_local(inst._fade:value() + 1)
        PushAlpha(inst)
    end
    if inst._fade:value() >= inst._fadeend:value() and inst._task ~= nil then
        inst._task:Cancel()
        inst._task = nil
    end
end

local function OnFadeDirty(inst)
    PushAlpha(inst)
    if inst._task ~= nil then
        inst._task:Cancel()
    end
    inst._task = inst:DoPeriodicTask(inst._period:value(), UpdateFade)
end

local function startshadow(inst, time, starttint, endtint)
    if time ~= DEFAULT_DURATION or starttint ~= DEFAULT_START or endtint ~= DEFAULT_END then
        inst._fade:set(AlphaToFade(starttint))
        inst._fadeend:set(AlphaToFade(endtint))
        inst._period:set(CalculatePeriod(time, starttint, endtint))
        OnFadeDirty(inst)
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("warning_shadow")
    inst.AnimState:SetBuild("meteor_shadow")
    inst.AnimState:PlayAnimation("idle", true)
    inst.AnimState:SetFinalOffset(-1)

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")

    inst._fade = net_smallbyte(inst.GUID, "meteorwarning._fade", "fadedirty")
    inst._fadeend = net_smallbyte(inst.GUID, "meteorwarning._fadeend", "fadedirty")
    inst._period = net_float(inst.GUID, "meteorwarning._period", "fadedirty")
    inst._fade:set(AlphaToFade(DEFAULT_START))
    inst._fadeend:set(AlphaToFade(DEFAULT_END))
    inst._period:set(DEFAULT_PERIOD)
    inst._task = nil
    OnFadeDirty(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        inst:ListenForEvent("fadedirty", OnFadeDirty)

        return inst
    end
	
	inst:DoTaskInTime(1, function(inst)
	SpawnPrefab("firemeteor").Transform:SetPosition(inst:GetPosition():Get())
		inst:DoTaskInTime(0.4, function(inst)
		inst:Remove()
		end)
	end)

	
    inst.SoundEmitter:PlaySound("dontstarve/common/meteor_spawn")

    inst.startfn = startshadow

    inst.persists = false

    return inst
end

local function firemeteorfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("lavaarena_firestaff_meteor")
    inst.AnimState:SetBuild("lavaarena_firestaff_meteor")
    inst.AnimState:PlayAnimation("crash")
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")
    inst:AddTag("notarget")

    inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
    inst:ListenForEvent("animover", function(inst)
		inst:DoTaskInTime(FRAMES*3, function(inst)
			SpawnPrefab("firemeteor_splash").Transform:SetPosition(inst:GetPosition():Get())
			SpawnPrefab("firedrop").Transform:SetPosition(inst:GetPosition():Get())
			ShakeAllCameras(CAMERASHAKE.FULL, .7, .02, .5, inst, 40)
			
			
			local x, y, z = inst:GetPosition():Get()
			
			local ents = TheSim:FindEntities(x, y, z, TUNING.METEOR_RADIUS, nil) --, NON_SMASHABLE_TAGS, SMASHABLE_TAGS
			for i, v in ipairs(ents) do
					SpawnPrefab("firemeteor_splashhit")
					if v.components.combat ~= nil then
					v.components.combat:GetAttacked(inst, TUNING.METEOR_DAMAGE * 2, nil)
					end
			end
			inst:Remove()
		end)
	end)

    return inst
end

local function splashfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("lavaarena_fire_fx")
    inst.AnimState:SetBuild("lavaarena_fire_fx")
    inst.AnimState:PlayAnimation("firestaff_ult")
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:SetFinalOffset(1)

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.persists = false
	inst.SoundEmitter:PlaySound("dontstarve/impacts/lava_arena/meteor_strike")
	inst:DoTaskInTime(0, function(inst)
	local base = SpawnPrefab("firemeteor_splashbase")
	base.Transform:SetPosition(inst:GetPosition():Get())
	end)
	
	inst:ListenForEvent("animover", inst.Remove)
	

    return inst
end

local function splashbasefn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
	

    inst.AnimState:SetBank("lavaarena_fire_fx")
    inst.AnimState:SetBuild("lavaarena_fire_fx")
    inst.AnimState:PlayAnimation("firestaff_ult_projection")
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(3)

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
    inst.persists = false
	
	inst:ListenForEvent("animover", inst.Remove)

    return inst
end

local function splashhitfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("lavaarena_fire_fx")
    inst.AnimState:SetBuild("lavaarena_fire_fx")
    inst.AnimState:PlayAnimation("firestaff_ult_hit")
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:SetFinalOffset(1)
    inst.AnimState:SetScale(.5, .5)

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.persists = false
    inst:ListenForEvent("animover", inst.Remove)

    return inst
end

return Prefab("firemeteorwarning", fn, assets_firemeteorwarning, prefabs_firemeteorwarning),
	Prefab("firemeteor", firemeteorfn, assets, prefabs),
    Prefab("firemeteor_splash", splashfn, assets_splash, prefabs_splash),
    Prefab("firemeteor_splashbase", splashbasefn, assets_splash),
    Prefab("firemeteor_splashhit", splashhitfn, assets_splash)
