local env = env
GLOBAL.setfenv(1, GLOBAL)


if TUNING.DSTU.PK_GUARDS then
    env.AddPrefabPostInit("pigking", function(inst)
        if not TheWorld.ismastersim then
            return
        end
        local function ErectPoleBuild(x, y, z)
            local pole = SpawnPrefab("pigking_pigtorch")
            local collapse = SpawnPrefab("collapse_big")
            pole.Transform:SetPosition(x, y, z)
            collapse.Transform:SetPosition(x, y, z)
            inst.sg:GoToState("cointoss")
        end

        inst.Rebuild = ErectPoleBuild

        inst:DoTaskInTime(0, function(inst)
            local x, y, z = inst.Transform:GetWorldPosition()
            if #TheSim:FindEntities(x, y, z, 30, { "pkpole" }) == 0 then
                ErectPoleBuild(x + 7, y, z + 7)
                ErectPoleBuild(x + 7, y, z - 7)
                ErectPoleBuild(x - 7, y, z + 7)
                ErectPoleBuild(x - 7, y, z - 7)
            end
        end)



        local function AcceptTest(inst, item, giver)
            -- Wurt can still play the mini-game though
            if giver:HasTag("merm") and item.prefab ~= "pig_token" then
                return
            end

            local is_event_item = IsSpecialEventActive(SPECIAL_EVENTS.HALLOWED_NIGHTS) and
                item.components.tradable.halloweencandyvalue and item.components.tradable.halloweencandyvalue > 0
            return item.components.tradable.goldvalue > 0 or is_event_item or item.prefab == "pig_token" or
                (item.components.edible ~= nil and item.components.edible.hungervalue > 70)
        end

        local function IsGuard(guy)
            return guy.prefab == "pigking_pigguard" and
                not (guy.components.follower ~= nil and guy.components.follower.leader ~= nil)
        end

        local function FindRecruit(inst)
            local guard = FindEntity(inst, 20, IsGuard)
            if guard ~= nil then
                return guard
            else
                return false
            end
        end

        local function SendRecruit(inst, hunger, guard, giver)
            giver:PushEvent("makefriend")
            giver.components.leader:AddFollower(guard)
            guard.components.follower.leader = giver
            guard.components.follower:AddLoyaltyTime(hunger * TUNING.PIG_LOYALTY_PER_HUNGER)
            guard.components.follower.maxfollowtime =
            giver:HasTag("polite")
                and TUNING.PIG_LOYALTY_MAXTIME + TUNING.PIG_LOYALTY_POLITENESS_MAXTIME_BONUS
                or TUNING.PIG_LOYALTY_MAXTIME
        end

        local _OnAcceptOld = inst.components.trader.onaccept
        local function OnGetItemFromPlayer(inst, giver, item)
            if item.components.edible ~= nil and item.components.edible.hungervalue > 70 and FindRecruit(inst) then
                SendRecruit(inst, item.components.edible.hungervalue, FindRecruit(inst), giver)
                inst.sg:GoToState("cointoss")
                --inst.sg:GoToState("recruit")
            else
                _OnAcceptOld(inst, giver, item)
            end
        end

        inst.components.trader:SetAcceptTest(AcceptTest)
        inst.components.trader.onaccept = OnGetItemFromPlayer
    end)
end
