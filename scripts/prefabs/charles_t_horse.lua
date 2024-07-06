local assets_nightmare = {
    Asset("ANIM", "anim/nightmare_charles_t_horse.zip"),
    Asset("ANIM", "anim/swap_charles_nightmare.zip")
}

local assets = {
    Asset("ANIM", "anim/charles_t_horse.zip"),
    Asset("ANIM", "anim/swap_charles.zip")
}

local dirs2 = {
    N = 0,
    S = 180,
    NE = 45,
    E = 90,
    SE = 135,
    NW = -45,
    W = -90,
    SW = -135
}

local dirs = {
    N = 135,
    NNE = 157.5,
    NE = 180,
    NEE = -157.5,
    E = -135,
    SEE = -112.5,
    SE = -90,
    SSE = -67.5,
    S = -45,
    SSW = -22.5,
    SW = 0,
    SWW = 22.5,
    W = 45,
    NNW = 112.5,
    NW = 90,
    NWW = 67.5
}

local function CheckAngle(inst)
    local owner = inst.components.inventoryitem.owner
    if owner ~= nil and owner:IsValid() then
        local heading = owner.Transform:GetRotation()
        local dir, closest_diff = nil, nil

        for k, v in pairs(dirs) do
            local diff = math.abs(anglediff(heading, v))
			
            if not dir or diff < closest_diff then
                dir, closest_diff = k, diff
            end
        end

        return dir
    end
end

local function CheckKeyObjectAngle(inst, target)
    local owner = inst.components.inventoryitem.owner
    if owner ~= nil and owner:IsValid() and target ~= nil then
        local x, y, z = target.Transform:GetWorldPosition()
        local heading = owner:GetAngleToPoint(x, y, z)
        local dir, closest_diff = nil, nil

        for k, v in pairs(dirs) do
            local diff = math.abs(anglediff(heading, v))
            if not dir or diff < closest_diff then
                dir, closest_diff = k, diff
            end
        end

        return dir
    else
        return nil
    end
end

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_charles_nightmare",
                                   "swap_charles_nightmare")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")

    if inst._owner ~= nil then
        inst:RemoveEventCallback("locomote", inst._onlocomote, inst._owner)
    end
    inst._owner = owner
    inst._onlocomote(inst._owner)
    inst:ListenForEvent("locomote", inst._onlocomote, owner)
end

local function onunequip(inst, owner)
    if inst._owner ~= nil then
        inst:RemoveEventCallback("locomote", inst._onlocomote, inst._owner)
        inst._owner = nil
    end

    if inst.ringalingtask ~= nil then
        inst.ringalingtask:Cancel()
        inst.ringalingtask = nil
    end

    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

local function NewDay(inst)
    -- inst.final_code_ready = false
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("nightmare_charles_t_horse")
    inst.AnimState:SetBuild("nightmare_charles_t_horse")
    inst.AnimState:PlayAnimation("idle")

    -- weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")
    inst:AddTag("irreplaceable")
    inst:AddTag("puzzle_charles")
    inst:AddTag("donotautopick")
    
    -- inst.foleysound = "dontstarve/creatures/together/deer/bell"

    local swap_data = {
        sym_build = "swap_charles_nightmare",
        bank = "nightmare_charles_t_horse"
    }
    MakeInventoryFloatable(inst, "med", 0.05, {0.85, 0.45, 0.85}, true, 1,
                           swap_data)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then return inst end

    inst.code = 0
    inst.code2 = 0
    inst.ringaling = true
    inst.final_code_ready = false

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.CANE_DAMAGE)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname =
        "images/inventoryimages/charles_t_horse.xml"

    inst:AddComponent("equippable")

    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    MakeHauntableLaunch(inst)

    inst._onlocomote = function(owner)
        if owner.components.locomotor ~= nil and
            owner.components.locomotor.wantstomoveforward then
            if inst.ringalingtask == nil then
                inst.ringalingtask = inst:DoPeriodicTask(.8, function(inst)
                    local point = CheckAngle(inst)
                    local wardrobe = TheSim:FindFirstEntityWithTag("wixie_wardrobe")

                    local beequeen = TheSim:FindFirstEntityWithTag("custom_beequeenhive_tag")
                    local widowspawner = TheSim:FindFirstEntityWithTag("widowweb")
                    local oasis = TheSim:FindFirstEntityWithTag("custom_oasis_tag")

                    inst.beequeen = CheckKeyObjectAngle(inst, beequeen)
                    inst.widowspawner = CheckKeyObjectAngle(inst, widowspawner)
                    inst.oasis = CheckKeyObjectAngle(inst, oasis)

                    local owner = inst.components.inventoryitem.owner
                    local distsq = 4000

                    if owner ~= nil and owner:IsValid() and wardrobe ~= nil and
                        wardrobe:IsValid() then
                        distsq = owner:GetDistanceSqToInst(wardrobe)
                    end

                    if distsq ~= nil and
                        (inst.code == 0 and distsq < 80 or inst.code > 0 and
                            distsq < 4000) then

                        if inst.beequeen ~= nil and point == inst.beequeen and
                            inst.code <= 4 then
                            inst.code = inst.code + 1
                        elseif inst.widowspawner ~= nil and point ==
                            inst.widowspawner and inst.code == 13 then
                            inst.SoundEmitter:PlaySound("dontstarve/creatures/knight_nightmare/voice")
                            inst.code = 0

                            local papyrus = SpawnPrefab("wixie_piano_card")
                            papyrus.Transform:SetPosition(
                                owner.Transform:GetWorldPosition())
                            papyrus.name = "Milites et Equi"
                            Launch2(papyrus, owner, 2, 0, 1, .5)
                        elseif inst.widowspawner ~= nil and point ==
                            inst.widowspawner and inst.code > 6 and inst.code <=
                            12 then
                            inst.code = inst.code + 1
                        elseif inst.oasis ~= nil and point == inst.oasis and
                            inst.code > 4 and inst.code <= 6 then
                            inst.code = inst.code + 1
                        else
                            inst.code = 0
                        end
                    else
                        inst.code = 0
                    end

                    local wixie_clock = TheSim:FindFirstEntityWithTag("wixie_clock")

                    if wixie_clock ~= nil and inst.final_code_ready and distsq ~=
                        nil and
                        (inst.code2 == 0 and distsq < 80 or inst.code2 > 0 and
                            distsq < 4000) then
                        if point == "N" and
                            (inst.code2 == 0 or inst.code2 == 4 or inst.code2 ==
                                8) then
                            inst.code2 = inst.code2 + 1
                        elseif point == "E" and
                            (inst.code2 == 1 or inst.code2 == 7) then
                            inst.code2 = inst.code2 + 1
                        elseif point == "S" and
                            (inst.code2 == 2 or inst.code2 == 3 or inst.code2 ==
                                6) then
                            inst.code2 = inst.code2 + 1
                        elseif point == "W" and inst.code2 == 5 then
                            inst.code2 = inst.code2 + 1
                        elseif point == "W" and inst.code2 == 9 then
                            wixie_clock.final_code_ready = true
                            inst.SoundEmitter:PlaySound(
                                "dontstarve/creatures/knight_nightmare/death")
                            SpawnPrefab("statue_transition").Transform:SetPosition(
                                owner:GetPosition():Get())
                            SpawnPrefab("statue_transition_2").Transform:SetPosition(
                                owner:GetPosition():Get())
                            inst.code2 = 0

                            TheNet:SystemMessage("The path is set...")
                        else
                            inst.code2 = 0
                        end
                    else
                        inst.code2 = 0
                    end

                    if distsq < 80 or inst.code > 0 or inst.code2 > 0 then
                        inst.SoundEmitter:PlaySound("dontstarve/creatures/together/deer/bell")
                    elseif distsq >= 4000 then
                        if wardrobe ~= nil and owner ~= nil then
                            local tool = owner.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
                            owner.components.inventory:Unequip(EQUIPSLOTS.HANDS, true)
                            owner.components.inventory:DropItem(tool)

                            Launch2(inst, wardrobe, 2, 0, 1, .5)
                        end
                    end
                end)
            end
        else
            if inst.ringalingtask ~= nil then
                inst.ringalingtask:Cancel()
                inst.ringalingtask = nil
            end
        end
    end

    -- inst:WatchWorldState("isday", NewDay)

    return inst
end

local function fuelme(inst)
    if inst.components.fueled:GetPercent() < 1 then
        if inst.pausedfuel then inst.components.fueled:DoDelta(5) end
        if inst.components.fueled:GetPercent() >= 1 then
            if inst.fuelmetask ~= nil then
                inst.fuelmetask:Cancel()
                inst.fuelmetask = nil
            end
        end
    else
        if inst.fuelmetask ~= nil then
            inst.fuelmetask:Cancel()
            inst.fuelmetask = nil
        end
    end
end

local function unpausefueled(inst)
    inst.pausedfuel = true
    if inst.fuelmetask == nil then
        inst.fuelmetask = inst:DoPeriodicTask(0.5, fuelme)
    end
end

local function checkiffull(inst)
    if inst.components.fueled:GetPercent() >= 1 then inst.pausedfuel = false end
end

local function stoprunning(inst) inst.pausedfuel = true end

local function onequip_real(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_charles", "swap_charles")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")

    if inst._owner ~= nil then
        inst:RemoveEventCallback("locomote", inst._onlocomote, inst._owner)
    end

    if owner:HasTag("troublemaker") then
        owner.components.talker:Say(GetString(owner, "EQUIP_CHARLES"))
    end

    inst._owner = owner
    inst:ListenForEvent("locomote", inst._onlocomote, owner)
end

local function onunequip_real(inst, owner)
    if inst._owner ~= nil then
        inst:RemoveEventCallback("locomote", inst._onlocomote, inst._owner)
        inst._owner = nil
    end

    if inst.ringalingtask ~= nil then
        inst.ringalingtask:Cancel()
        inst.ringalingtask = nil
    end

    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

local function ReticuleTargetFn(inst)
    return Vector3(inst.entity:LocalToWorldSpace(6.5, 0, 0))
end

local function ReticuleMouseTargetFn(inst, mousepos)
    if mousepos ~= nil then
        local x, y, z = inst.Transform:GetWorldPosition()
        local dx = mousepos.x - x
        local dz = mousepos.z - z
        local l = dx * dx + dz * dz
        if l <= 0 then return inst.components.reticule.targetpos end
        l = 6.5 / math.sqrt(l)
        return Vector3(x + dx * l, 0, z + dz * l)
    end
end

local function ReticuleUpdatePositionFn(inst, pos, reticule, ease, smoothing, dt)
    local x, y, z = inst.Transform:GetWorldPosition()
    reticule.Transform:SetPosition(x, 0, z)
    local rot = -math.atan2(pos.z - z, pos.x - x) / DEGREES
    if ease and dt ~= nil then
        local rot0 = reticule.Transform:GetRotation()
        local drot = rot - rot0
        rot = Lerp(
                  (drot > 180 and rot0 + 360) or (drot < -180 and rot0 - 360) or
                      rot0, rot, dt * smoothing)
    end
    reticule.Transform:SetRotation(rot)
end

local function castspell(inst, target, pos)
    for i, v in pairs(inst._owner.components.inventory.itemslots) do
        if v ~= nil and v:HasTag("charles_t_horse") then
            v.components.fueled:DoDelta(-20)

            if v.fuelmetask ~= nil then
                v.fuelmetask:Cancel()
                v.fuelmetask = nil
            end

            if v.unpausefuel_task ~= nil then
                v.unpausefuel_task:Cancel()
                v.unpausefuel_task = nil
            end

            v.unpausefuel_task = v:DoTaskInTime(2, unpausefueled)
        end
    end

    inst.components.fueled:DoDelta(-20)

    if inst.fuelmetask ~= nil then
        inst.fuelmetask:Cancel()
        inst.fuelmetask = nil
    end

    if inst.unpausefuel_task ~= nil then
        inst.unpausefuel_task:Cancel()
        inst.unpausefuel_task = nil
    end

    inst.unpausefuel_task = inst:DoTaskInTime(2, unpausefueled)
end

local function can_cast_fn(inst)
    -- YES, STOP SAYING "I CAN'T DO THAT" WHEN CASTING ON TARGETS FFS
    return true
end

local function realfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("charles_t_horse")
    inst.AnimState:SetBuild("charles_t_horse")
    inst.AnimState:PlayAnimation("idle")

    -- weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")
    inst:AddTag("charles_t_horse")

    -- inst.foleysound = "dontstarve/creatures/together/deer/bell"

    local swap_data = {sym_build = "swap_charles", bank = "charles_t_horse"}
    MakeInventoryFloatable(inst, "med", 0.05, {0.85, 0.45, 0.85}, true, 1,
                           swap_data)

    inst.spelltype = "CHARLES_CHARGE"

    inst:AddComponent("reticule")
    inst.components.reticule.reticuleprefab = "reticuleline2"
    inst.components.reticule.pingprefab = "reticulelongping"
    -- inst.components.reticule.reticuleprefab = "reticuleline2"
    -- inst.components.reticule.pingprefab = "reticulelineping"
    inst.components.reticule.targetfn = ReticuleTargetFn
    inst.components.reticule.mousetargetfn = ReticuleMouseTargetFn
    inst.components.reticule.updatepositionfn = ReticuleUpdatePositionFn
    inst.components.reticule.validcolour = {1, 1, 1, 1}
    inst.components.reticule.invalidcolour = {.5, 0, 0, 1}
    inst.components.reticule.ease = true
    inst.components.reticule.mouseenabled = true
    inst.components.reticule.ispassableatallpoints = true

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then return inst end

    inst.fuelmetask = nil
    inst.pausedfuel = true

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.CANE_DAMAGE)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname =
        "images/inventoryimages/the_real_charles_t_horse.xml"

    inst:AddComponent("equippable")

    inst.components.equippable:SetOnEquip(onequip_real)
    inst.components.equippable:SetOnUnequip(onunequip_real)
    inst.components.equippable.walkspeedmult = inst.multiplier

    MakeHauntableLaunch(inst)

    inst:AddComponent("fueled")
    inst.components.fueled:InitializeFuelLevel(100)
    inst.components.fueled.accepting = false
    inst.components.fueled:SetDepletedFn(stoprunning)
    inst.components.fueled:SetUpdateFn(checkiffull)

    inst:AddComponent("spellcaster")
    inst.components.spellcaster:SetSpellFn(castspell)
    inst.components.spellcaster:SetCanCastFn(can_cast_fn)
    inst.components.spellcaster.canuseontargets = true
    inst.components.spellcaster.canuseondead = true
    inst.components.spellcaster.canuseonpoint = true
    inst.components.spellcaster.canuseonpoint_water = true
    inst.components.spellcaster.canusefrominventory = false

    inst.fuelmetask = inst:DoPeriodicTask(0.5, fuelme)

    inst._onlocomote = function(owner)
        if owner.components.locomotor.wantstomoveforward then
            if inst.ringalingtask == nil then
                inst.ringalingtask = inst:DoPeriodicTask(.5, function(inst)

                    inst.SoundEmitter:PlaySound(
                        "dontstarve/creatures/together/deer/bell")
                end)
            end
        else
            if inst.ringalingtask ~= nil then
                inst.ringalingtask:Cancel()
                inst.ringalingtask = nil
            end
        end
    end

    return inst
end

return Prefab("charles_t_horse", fn, assets_nightmare),
       Prefab("the_real_charles_t_horse", realfn, assets)
