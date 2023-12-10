local env = env
GLOBAL.setfenv(1, GLOBAL)

local function MakeWaterSource(inst)
    inst:AddTag("watersource")
    inst:AddComponent("watersource")
    --inst:RemoveComponent("trader")
end

local function CalcTransitionAnimName()
    if TheWorld.state.moonphase == "full" then
        return "wax_to_full"
    elseif TheWorld.state.moonphase == "new" then
        return "wane_to_new"
    end

    return (TheWorld.state.iswaxingmoon and "wax" or "wane") .. "_to_" .. TheWorld.state.moonphase
end

local function ItemTradeTest(inst, item, giver)
    if not (inst.hastear ~= nil and inst.hastear) and item.prefab == "moon_tear" then
        inst.hastear = true
        --	MakeWaterSource(inst)
        item:Remove()
        SpawnPrefab("halloween_moonpuff").Transform:SetPosition(inst.Transform:GetWorldPosition())

        inst.AnimState:SetBuild("moondialtear_build")
        inst.AnimState:SetBank("moondialtear")
        return true
    elseif (inst.hastear ~= nil and inst.hastear) and not item:HasTag("fillable") and (item.components.halloweenmoonmutable ~= nil) and TheWorld.state.moonphase == "full" and not inst.cd then
        SpawnPrefab("halloween_moonpuff").Transform:SetPosition(inst.Transform:GetWorldPosition())
        if item.components.stackable ~= nil then
            item = item.components.stackable:Get()
        end
        item.components.halloweenmoonmutable:Mutate() -- Moon Mutate using vanilla function...for now.
        inst.cd = true
        inst.AnimState:PlayAnimation("idle_new")
        inst:DoTaskInTime(30, function(inst)
            inst.cd = false
            inst.AnimState:PlayAnimation(CalcTransitionAnimName())
            inst.AnimState:PushAnimation("idle_" .. TheWorld.state.moonphase)
        end)
        return true
    else
        return false
    end
end

local function OnAccept(inst)
    --	inst:RemoveComponent("tradable")
end

local function OnTimerDone(inst, data)
    inst.AnimState:PlayAnimation("idle_full")
end

env.AddPrefabPostInit("moondial", function(inst)
    inst:AddTag("alltrader")

    if not TheWorld.ismastersim then
        return
    end

    inst:AddComponent("timer")
    inst:ListenForEvent("timerdone", OnTimerDone)

    local _OnSave = inst.OnSave
    local _OnLoad = inst.OnLoad
    local function OnSave(inst, data)
        if inst.hastear ~= nil then
            data.hastear = inst.hastear
            data.cd = inst.cd
        end

        return _OnSave(inst, data)
    end

    local function OnLoad(inst, data)
        if data ~= nil then
            if data.hastear ~= nil and data.hastear then
                inst.hastear = true
                inst.AnimState:SetBuild("moondialtear_build")
                inst.AnimState:SetBank("moondialtear")
            end
            if data.cd ~= nil then
                inst.cd = data.cd
                if data.cd then
                    inst.AnimState:PlayAnimation("idle_new")

                    inst:DoTaskInTime(30, function(inst)
                        inst.cd = false
                        inst.AnimState:PlayAnimation(CalcTransitionAnimName())
                        inst.AnimState:PushAnimation("idle_" .. TheWorld.state.moonphase)
                    end)
                end
            end
        end

        return _OnLoad(inst, data)
    end

    inst:AddComponent("trader")
    inst.components.trader:SetAbleToAcceptTest(ItemTradeTest)
    inst.components.trader.onaccept = OnAccept
    inst.components.trader.deleteitemonaccept = false

    MakeWaterSource(inst)

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad
end)
