local TARGET_IGNORE_TAGS = {"INLIMBO", "moonglasscreature", "player" --[[, "companion", "abigail"]] }

local function destroystuff(inst)

    if inst.WINDSTAFF_CASTER == nil then inst:Remove() end
    if inst.destroy and inst.hidden ~= true then
        local x, y, z = inst.Transform:GetWorldPosition()

        local ents = TheSim:FindEntities(x, y, z, 2, nil, TARGET_IGNORE_TAGS, {"_health"})
        for i, v in ipairs(ents) do
            if v ~= inst.WINDSTAFF_CASTER and v:IsValid() then
                if v.components.health ~= nil and not v.components.health:IsDead() and v.components.combat ~= nil and v.components.combat:CanBeAttacked() then
                    local damage = 5
                    v.components.combat:GetAttacked(inst, damage, nil, "glass")
                    v.SoundEmitter:PlaySound("turnoftides/common/together/moon_glass/mine", nil, 0.5)
                    if v:HasTag("player") and not (v.components.rider ~= nil and v.components.rider:IsRiding()) then
                        if v.moonmaw_lavae_stun == nil then v.moonmaw_lavae_stun = 0 end
                        v.moonmaw_lavae_stun = v.moonmaw_lavae_stun + 1
                    end
                end
            end
        end
    end
end

local function Reposition(inst)
    if inst.WINDSTAFF_CASTER ~= nil then
        local x, y, z = inst.WINDSTAFF_CASTER.Transform:GetWorldPosition()
        if x ~= nil and y ~= nil and z ~= nil then
            inst.Transform:SetPosition(x, y, z)
        else
            inst:Remove()
        end
    end
end

local function CheckDist(inst)
    if inst.WINDSTAFF_CASTER ~= nil then
        if inst:GetDistanceSqToInst(inst.WINDSTAFF_CASTER) > 15 then
            local x, y, z = inst.WINDSTAFF_CASTER.Transform:GetWorldPosition()
            if x ~= nil and y ~= nil and z ~= nil then
                inst.Transform:SetPosition(x, y, z)
            else
                inst:Remove()
            end
        end
    else
        inst:Remove()
    end
end

local function Speen(inst)
    inst.destroy = true
    inst.components.linearcircler.setspeed = 2
    if inst.components.timer:TimerExists("speen") then
        inst.components.timer:StopTimer("speen")
        inst.components.timer:StartTimer("speen", 2)
    else
        inst.components.timer:StartTimer("speen", 2)
    end
end

local function SlowDown(inst)
    inst.destroy = false
    inst.components.linearcircler.setspeed = 0.2
end

local function PlayBreakSound(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/slurtle/shatter", nil, 0.5) end

local function SummonShard(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local fx = SpawnPrefab("moonstorm_glass_ground_fx")
    if x ~= nil and y ~= nil and z ~= nil then fx.Transform:SetPosition(x, y, z) end
    fx.Transform:SetScale(0.5, 0.5, 0.5)
end

local function BreakShard(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    if x ~= nil and y ~= nil and z ~= nil then SpawnPrefab("mining_moonglass_fx").Transform:SetPosition(x, y, z) end
end

local function fn_glassshards()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
    inst.entity:AddLight()
    inst.entity:AddDynamicShadow()
    local light = inst.entity:AddLight()
    inst.Light:Enable(false)
    inst.Light:SetRadius(2)
    inst.Light:SetFalloff(0.5)
    inst.Light:SetIntensity(.75)
    inst.Light:SetColour(121 / 255, 235 / 255, 12 / 255)

    inst.AnimState:SetFinalOffset(0.5)
    inst.AnimState:SetBank("armor_glassmail_shards")
    inst.AnimState:SetBuild("armor_glassmail_shards")

    inst.Transform:SetFourFaced()

    MakeInventoryPhysics(inst)
    RemovePhysicsColliders(inst)

    inst:AddTag("NOBLOCK")
    inst:AddTag("NOCLICK")
    inst:AddTag("moonglass")
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then return inst end

    local anim = math.random(0, 4)
    inst.AnimState:PlayAnimation(anim, true)
    inst:AddComponent("linearcircler")

    inst.WINDSTAFF_CASTER = nil
    inst:AddComponent("inspectable")
    inst:AddTag("moonglasscreature")

    inst.Destroy = false

    inst:DoTaskInTime(1, function(inst)
        inst:DoPeriodicTask(.2, destroystuff)
        inst:DoPeriodicTask(10, CheckDist)
    end)
    inst.damagetime = 0.1
    inst:DoTaskInTime(inst.damagetime, Reposition)

    inst:AddComponent("timer")
    inst:ListenForEvent("timerdone", SlowDown)
    inst.Speen = Speen
    inst.PlayBreakSound = PlayBreakSound
    inst.BreakShard = BreakShard
    inst.SummonShard = SummonShard
    return inst
end

return Prefab("armor_glassmail_shards", fn_glassshards)
