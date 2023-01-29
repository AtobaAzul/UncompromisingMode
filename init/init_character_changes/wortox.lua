local UpvalueHacker = GLOBAL.require("tools/upvaluehacker")
-----------------------------------------------------------------
--Remove souls from insects and arachnids
--Relevant: soulless tag, wortox_soul_common.lua
-----------------------------------------------------------------
local function MakeSoulless(prefab)
    AddPrefabPostInit(prefab, function(inst)
        if inst~= nil then
            inst:AddTag("soulless")
        end
    end)
end

--print("DSTU: wortox")

local REMOVE_SOULS = 
{
    --"spider",
    "mosquito",
    "bee",
    "killerbee",
    "butterfly",
    "birchnutdrake",
	--"mole",
    --"beeguard",
	--"bat",
	--"rabbit",
	--"crow",
	--"canary",
	--"robin",
	--"robin_winter",
	--"frog",
	--"bird_mutant",
	--"smallbird",
	"moonbutterfly",
	--"puffin",
	--"bird_mutant_spitter",
	--"fruitbat",
	--"stumpling",
	--"birchling",
	--"aphid",
}
if GLOBAL.TUNING.DSTU.WORTOX == "UMNERF" then
	for k, v in pairs(REMOVE_SOULS) do
		MakeSoulless(v)
	end
end

local function UncompromisingSoulHeal(inst)
    if GLOBAL.TUNING.BOOK_FIRE_RADIUS ~= nil then
        --wicker rework doesn't have a release ID :/ had to use this as a workaround
        local healtargets = {}
        local healtargetscount = 0
        local sanitytargets = {}
        local sanitytargetscount = 0
        local x, y, z = inst.Transform:GetWorldPosition()

        for i, v in ipairs(GLOBAL.AllPlayers) do
            if not (v.components.health:IsDead() or v:HasTag("playerghost")) and v.entity:IsVisible() and v:GetDistanceSqToPoint(x, y, z) < TUNING.WORTOX_SOULHEAL_RANGE * TUNING.WORTOX_SOULHEAL_RANGE then
                -- NOTES(JBK): If the target is hurt put them on the list to do heals.
                if v.components.health:IsHurt() then
                    table.insert(healtargets, v)
                    healtargetscount = healtargetscount + 1
                end
                -- NOTES(JBK): If the target is another "soulstealer" give some sanity even when they did not drop the soul but not in overload state.
                if v._souloverloadtask == nil and v.components.sanity and v:HasTag("soulstealer") then
                    table.insert(sanitytargets, v)
                    sanitytargetscount = sanitytargetscount + 1
                end
            end
        end

        if healtargetscount > 0 then
            local amt = math.max(TUNING.WORTOX_SOULHEAL_MINIMUM_HEAL, TUNING.HEALING_MED - TUNING.WORTOX_SOULHEAL_LOSS_PER_PLAYER * (healtargetscount - 1))
            for i = 1, healtargetscount do
                local v = healtargets[i]
                v.components.debuffable:AddDebuff("healthregenbuff_vetcurse_soul", "healthregenbuff_vetcurse", {duration = (amt * 0.1)})
                if v.components.combat then -- Always show fx now that the heals do special targeting to show the player that it stops working when everyone is full.
                    local fx = GLOBAL.SpawnPrefab("wortox_soul_heal_fx")
                    fx.entity:AddFollower():FollowSymbol(v.GUID, v.components.combat.hiteffectsymbol, 0, -50, 0)
                    fx:Setup(v)
                end
            end
        end
        if sanitytargetscount > 0 then
            local amt = TUNING.SANITY_TINY * 0.5
            for i = 1, sanitytargetscount do
                local v = sanitytargets[i]
                v.components.sanity:DoDelta(amt)
            end
        end
    else
        local targets = {}
        local x, y, z = inst.Transform:GetWorldPosition()
        for i, v in ipairs(GLOBAL.AllPlayers) do
            if not (v.components.health:IsDead() or v:HasTag("playerghost")) and v.entity:IsVisible() and v:GetDistanceSqToPoint(x, y, z) < TUNING.WORTOX_SOULHEAL_RANGE * TUNING.WORTOX_SOULHEAL_RANGE then
                table.insert(targets, v)
            end
        end
        if #targets > 0 then
            local amt = TUNING.HEALING_MED - math.min(8, #targets) + 1
            for i, v in ipairs(targets) do
                --always heal, but don't stack visual fx
                v.components.debuffable:AddDebuff("healthregenbuff_vetcurse_soul", "healthregenbuff_vetcurse", {duration = (amt * 0.1)})
                if v.blocksoulhealfxtask == nil and v.components.combat then
                    v.blocksoulhealfxtask = v:DoTaskInTime(.5, EndBlockSoulHealFX)
                    local fx = GLOBAL.SpawnPrefab("wortox_soul_heal_fx")
                    fx.entity:AddFollower():FollowSymbol(v.GUID, v.components.combat.hiteffectsymbol, 0, -50, 0)
                    fx:Setup(v)
                end
            end
        end
    end
end


--If there's a better vvay of doing this, lemme knovv, I'm not sure hovv to grab the wortox_soul_common.DoHeal, it doesn't vvork if I reference it in its ovvn postinit like inst.DoHeal = NevvHeal
local function KillSoul(inst)
    inst:ListenForEvent("animover", inst.Remove)
    inst.AnimState:PlayAnimation("idle_pst")
    inst.SoundEmitter:PlaySound("dontstarve/characters/wortox/soul/spawn", nil, .5)

    UncompromisingSoulHeal(inst)
end

local function toground(inst)
    inst.persists = false
    if inst._task == nil then
        inst._task = inst:DoTaskInTime(.4 + math.random() * .7, KillSoul)
    end
    if inst.AnimState:IsCurrentAnimation("idle_loop") then
        inst.AnimState:SetTime(math.random() * inst.AnimState:GetCurrentAnimationLength())
    end
end

--beta uses 
if GLOBAL.TUNING.DSTU.WORTOX == "SHOT" then
	AddPrefabPostInit("wortox_soul", function(inst)
		UpvalueHacker.SetUpvalue(GLOBAL.Prefabs.wortox_soul.fn, toground, "toground")
	end)
end