local UpvalueHacker = GLOBAL.require("tools/upvaluehacker")

AddPrefabPostInitAny(function(inst)
	if not GLOBAL.TheWorld.ismastersim then
		return inst
	end
	--if inst.components.health ~= nil and inst:HasTag("insect") and inst.components.health ~= nil and not inst.components.health:IsDead() and inst.components.health.maxhealth <= 100 then
	if inst:HasTag("butterfly") or inst:HasTag("bird") then
		inst:AddTag("soulless")
	end
end)
	
--local function MakeSoulless(prefab)
    --AddPrefabPostInit(prefab, function(inst)
        --if inst ~= nil then
            --inst:AddTag("soulless")
        --end
    --end)
--end

--local REMOVE_SOULS =
--{
	--"birchnutdrake",
	--"stumpling",
	--"birchling",
--}

--if GLOBAL.TUNING.DSTU.WORTOX == "UMNERF" then
    --for k, v in pairs(REMOVE_SOULS) do
        --MakeSoulless(v)
    --end
--end

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
            local amt = GLOBAL.TUNING.DSTU.WORTOX == "SHOT" and
                math.max(TUNING.WORTOX_SOULHEAL_MINIMUM_HEAL,
                    TUNING.HEALING_MED - TUNING.WORTOX_SOULHEAL_LOSS_PER_PLAYER * (healtargetscount - 1)) or
                math.max(TUNING.WORTOX_SOULHEAL_MINIMUM_HEAL,
                    10 - TUNING.WORTOX_SOULHEAL_LOSS_PER_PLAYER * (healtargetscount - 1))

            for i = 1, healtargetscount do
                local v = healtargets[i]
                v.components.debuffable:AddDebuff("healthregenbuff_vetcurse_soul", "healthregenbuff_vetcurse",
                    { duration = (amt * 0.1) })
                if v.components.combat then -- Always show fx now that the heals do special targeting to show the player that it stops working when everyone is full.
                    local fx = GLOBAL.SpawnPrefab("wortox_soul_heal_fx")
                    fx.entity:AddFollower():FollowSymbol(v.GUID, v.components.combat.hiteffectsymbol, 0, -50, 0)
                    fx:Setup(v)
                end
            end
        end

        --if TUNING.DSTU.WORTOX ~= "APOLLO" then
            --if sanitytargetscount > 0 then
                --local amt = TUNING.SANITY_TINY * 0.5
                --for i = 1, sanitytargetscount do
                    --local v = sanitytargets[i]
                    --v.components.sanity:DoDelta(amt)
                --end
            --end
        --end
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
                v.components.debuffable:AddDebuff("healthregenbuff_vetcurse_soul", "healthregenbuff_vetcurse",
                    { duration = (amt * 0.1) })
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


--If there's a better way of doing this, lemme know, I'm not sure how to grab the wortox_soul_common.DoHeal, it doesn't work if I reference it in its own postinit like inst.DoHeal = NewHeal
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
--if GLOBAL.TUNING.DSTU.WORTOX == "SHOT" or GLOBAL.TUNING.DSTU.WORTOX == "APOLLO" then
    AddPrefabPostInit("wortox_soul", function(inst)
        UpvalueHacker.SetUpvalue(GLOBAL.Prefabs.wortox_soul.fn, toground, "toground")
    end)
--end

AddPrefabPostInit("wortox", function(inst)
	if not GLOBAL.TheWorld.ismastersim then
		return
	end
	
	if inst.components.foodaffinity ~= nil then
		inst.components.foodaffinity:AddPrefabAffinity("devilsfruitcake", 1.24)
	end
	
	--if GLOBAL.TUNING.DSTU.WORTOX == "APOLLO" then
        if inst.components.souleater ~= nil then
            local oneatsoulfn_ = inst.components.souleater.oneatsoulfn

            inst.components.souleater.oneatsoulfn = function(inst, soul)
                oneatsoulfn_(inst, soul)
                inst.components.sanity:DoDelta(-TUNING.SANITY_TINY)
            end
        end
	--end
end)
