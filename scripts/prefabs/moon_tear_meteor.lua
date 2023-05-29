require "regrowthutil"

local assets =
{
    Asset("ANIM", "anim/meteor.zip"),
    Asset("ANIM", "anim/warning_shadow.zip"),
    Asset("ANIM", "anim/meteor_shadow.zip"),
}

local prefabs =
{
    "meteorwarning",
    "burntground",
    "splash_ocean",
    "ground_chunks_breaking",
    "rock_moon",
	"rock_moon_shell",
    "rocks",
    "flint",
    "moonrocknugget",
    "rock_flintless",
    "rock_flintless_med",
    "rock_flintless_low",
    "rock1",
}

local assets =
{
    Asset("ANIM", "anim/meteor.zip"),
    Asset("ANIM", "anim/warning_shadow.zip"),
    Asset("ANIM", "anim/meteor_shadow.zip"),
}

local prefabs =
{
    "meteorwarning",
    "burntground",
    "splash_ocean",
    "ground_chunks_breaking",
    "rock_moon",
	"rock_moon_shell",
    "rocks",
    "flint",
    "moonrocknugget",
    "rock_flintless",
    "rock_flintless_med",
    "rock_flintless_low",
    "rock1",
}

local SMASHABLE_TAGS = { "player" }
local NON_SMASHABLE_TAGS = { "INLIMBO", "playerghost", "meteor_protection" }

local DENSITY = 0.1 -- the approximate density of rock prefabs in the rocky biomes
local FIVERADIUS = CalculateFiveRadius(DENSITY)
local EXCLUDE_RADIUS = 3

local function onexplode(inst)
    inst.SoundEmitter:PlaySound("dontstarve/common/meteor_impact")

    if inst.warnshadow ~= nil then
        inst.warnshadow:Remove()
        inst.warnshadow = nil
    end

    local shakeduration = .7 * inst.size
    local shakespeed = .02 * inst.size
    local shakescale = .5 * inst.size
    local shakemaxdist = 40 * inst.size
    ShakeAllCameras(CAMERASHAKE.FULL, shakeduration, shakespeed, shakescale, inst, shakemaxdist)

    local x, y, z = inst.Transform:GetWorldPosition()

    if not inst:IsOnValidGround() then
        local splash = SpawnPrefab("splash_ocean")
        if splash ~= nil then
            splash.Transform:SetPosition(x, y, z)
        end
    else
        local scorch = SpawnPrefab("burntground")
        if scorch ~= nil then
            scorch.Transform:SetPosition(x, y, z)
            local scale = inst.size * 1.3
            scorch.Transform:SetScale(scale, scale, scale)
        end
		
		local gemcheck = math.random()
		
		local moontear = SpawnPrefab("moon_tear")
        moontear.Transform:SetPosition(x, y, z)
		
        local launched = {}
        local ents = TheSim:FindEntities(x, y, z, inst.size * TUNING.METEOR_RADIUS, nil, NON_SMASHABLE_TAGS, SMASHABLE_TAGS)
        for i, v in ipairs(ents) do
            --V2C: things "could" go invalid if something earlier in the list
            --     removes something later in the list.
            --     another problem is containers, occupiables, traps, etc.
            --     inconsistent behaviour with what happens to their contents
            --     also, make sure stuff in backpacks won't just get removed
            --     also, don't dig up spawners
            if v:IsValid() and not v:IsInLimbo() then
                if v.components.combat ~= nil then
                    v.components.combat:GetAttacked(inst, inst.size * TUNING.METEOR_DAMAGE / 2, nil)
                end
            end
        end
    end
end

local function dostrike(inst)
    inst.striketask = nil
    inst.AnimState:PlayAnimation("crash")
    inst:DoTaskInTime(0.33, onexplode)
    inst:ListenForEvent("animover", inst.Remove)
    -- animover isn't triggered when the entity is asleep, so just in case
    inst:DoTaskInTime(3, inst.Remove)
end

local warntime = 2
local sizes = 
{ 
    large = .7,
}

local function SetPeripheral(inst, peripheral)
    inst.peripheral = peripheral
end

local function SetSize(inst, sz, mod)
    if inst.autosizetask ~= nil then
        inst.autosizetask:Cancel()
        inst.autosizetask = nil
    end
    if inst.striketask ~= nil then
        return
    end

    inst.size = sizes["large"]
    inst.warnshadow = SpawnPrefab("meteorwarning")

    if mod == nil then
        mod = 1
    end

    inst.Transform:SetScale(inst.size, inst.size, inst.size)
    inst.warnshadow.Transform:SetScale(inst.size * 1.2, inst.size * 1.2, inst.size * 1.2)

    -- Now that we've been set to the appropriate size, go for the gusto
    inst.striketask = inst:DoTaskInTime(warntime, dostrike)

    inst.warnshadow.entity:SetParent(inst.entity)
    inst.warnshadow.startfn(inst.warnshadow, warntime, .33, 1)
end

local function AutoSize(inst)
    inst.autosizetask = nil
    local rand = math.random()
    inst:SetSize(rand <= .33 and "large" or (rand <= .67 and "medium" or "small"))
end

local function fn() 
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
    
    inst.Transform:SetTwoFaced()

    inst.AnimState:SetBank("meteor")
    inst.AnimState:SetBuild("meteor")

    inst:AddTag("NOCLICK")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.Transform:SetRotation(math.random(360))
    inst.SetSize = SetSize
    inst.SetPeripheral = SetPeripheral
    inst.striketask = nil

    -- For spawning these things in ways other than from meteor showers (failsafe set a size after delay)
    inst.autosizetask = inst:DoTaskInTime(0, AutoSize)

    inst.persists = false

    return inst
end

return Prefab("moon_tear_meteor", fn, assets, prefabs)