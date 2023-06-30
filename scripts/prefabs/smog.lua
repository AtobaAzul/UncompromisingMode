local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddPhysics()

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")
    inst:AddTag("smog")
    inst.AnimState:SetBuild("marshmist")
    inst.AnimState:SetBank("marshmist")
    inst.AnimState:PlayAnimation("idle", true)

    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_WORLD)
    inst.AnimState:SetSortOrder(1)
    inst.AnimState:SetScale(4, 4, 4)
    inst.AnimState:SetMultColour(0.05, 0.05, 0.05, 0.0)

    inst.mult = 0
    inst.fadeintask = inst:DoPeriodicTask(0.125, function(inst)
        inst.AnimState:SetMultColour(0.05, 0.05, 0.05, inst.mult)
        inst.mult = inst.mult + 0.0125
        if inst.mult >= 0.4 then
            inst.mult = 0.4
            inst.fadeintask:Cancel()
            inst.fadeintask = nil
        end
    end)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then return inst end

    inst:DoTaskInTime(0, function(inst)
        local x, y, z = inst.Transform:GetWorldPosition()
        if #TheSim:FindEntities(x, y, z, 4, { "smog" }) > 1 then
            inst:Remove()
        end
    end)

    inst:DoTaskInTime(math.random(60, 120), function(inst)
        inst:DoPeriodicTask(0.125, function(inst)
            inst.AnimState:SetMultColour(0.05, 0.05, 0.05, inst.mult)
            inst.mult = inst.mult - 0.025
            if inst.mult <= 0 then
                inst:Remove()
            end
        end)
    end)

    inst:AddComponent("locomotor")
    inst.components.locomotor:SetTriggersCreep(false)

    if TheWorld.components.worldwind ~= nil then
        inst:DoPeriodicTask(FRAMES, function(inst)
            if TheWorld.components.worldwind ~= nil then
                local x, y, z = inst.Transform:GetWorldPosition()
                local ang = TheWorld.components.worldwind:GetWindAngle()
                local rad = math.rad(ang)
                inst.Transform:SetRotation(TheWorld.components.worldwind:GetWindAngle())
                local velx = math.cos(rad)  --* 4.5
                local velz = -math.sin(rad) --* 4.5

                local dx, dy, dz = x + (((FRAMES) * velx)), 0,
                    z + (((FRAMES) * velz))
                inst.Transform:SetPosition(dx, dy, dz)
            end
        end)
    end

    inst:DoPeriodicTask(5 + math.random(5), function(inst)
        local x, y, z = inst.Transform:GetWorldPosition()
        local players = TheSim:FindEntities(x, y, z, 12, nil, { "playerghost" }, { "player", "insect" })
        for k, v in ipairs(players) do
            if v.components.health ~= nil and v.prefab ~= "willow" and not v:HasTag("has_gasmask") and inst.mult >= 0.4 and math.random() > 0.5 then
                if v.components.oldager ~= nil then
                    v.components.health:DoDelta(-1)
                else
                    v.components.health:DeltaPenalty(0.0125)
                end

                if v.components.talker ~= nil then
                    v.components.talker:Say(GetString(v, "GAS_DAMAGE"))
                end

                if v:HasTag("insect") then
                    v.components.health:DoDelta(-1)
                    if v.components.hauntable ~= nil and v.components.hauntable.panicable then
                        v.components.hauntable:Panic(5 + math.random(5))
                    end
                end
            end
        end
    end)

    --inst:AddComponent("areaaware")

    return inst
end

return Prefab("smog", fn)
