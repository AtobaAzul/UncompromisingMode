local assets =
{
    Asset("ANIM", "anim/book_maxwell.zip"),

    Asset("SOUND", "sound/together.fsb"),
}

local function canread(inst, reader)
	return (inst.components.sanity:GetMaxWithPenalty() >= TUNING.DSTU.OLD_SHADOWWAXWELL_SANITY_COST) and
		(inst.components.health.currenthealth > TUNING.DSTU.SHADOWWAXWELL_HEALTH_COST)
end

local function onread(inst, reader)
	if not reader:HasTag("codexmantrareader") then
		return false
	end

	--Check sanity
	if not canread(reader) then
		if reader.components.talker then
			if reader.components.sanity:GetMaxWithPenalty() < TUNING.DSTU.OLD_SHADOWWAXWELL_SANITY_COST then
				reader.components.talker:Say(GetString(reader.prefab, "ANNOUNCE_NOSANITY"))
			elseif reader.components.health.currenthealth <= TUNING.DSTU.SHADOWWAXWELL_HEALTH_COST then
				reader.components.talker:Say(GetString(reader.prefab, "ANNOUNCE_NOHEALTH"))
			end
			return true
		end
	end

		--Check reagent
	if not reader.components.inventory:Has("nightmarefuel", TUNING.DSTU.SHADOWWAXWELL_FUEL_COST) then
		if reader.components.talker then
			reader.components.talker:Say(GetString(reader.prefab, "ANNOUNCE_NOFUEL"))
			return true
		end
	end


	local readx, ready, readz = reader.Transform:GetWorldPosition()
	local shadowmax = reader.components.petleash:SpawnPetAt(readx, ready, readz, "real_shadowwaxwell")

	if shadowmax ~= nil then
		reader.components.inventory:ConsumeByName("nightmarefuel", TUNING.DSTU.SHADOWWAXWELL_FUEL_COST)
		shadowmax:DoTaskInTime(0, function(shadowmax) shadowmax.sg:GoToState("jumpout") end)
		reader.components.health:DoDelta(-TUNING.DSTU.SHADOWWAXWELL_HEALTH_COST)
		reader.components.sanity:RecalculatePenalty()
		inst.SoundEmitter:PlaySound("dontstarve/maxwell/shadowmax_appear")
	end

	return true
end

local function tryplaysound(inst, id, sound)
    inst._soundtasks[id] = nil
    if inst.AnimState:IsCurrentAnimation("proximity_pst") then
        inst.SoundEmitter:PlaySound(sound)
    end
end

local function trykillsound(inst, id, sound)
    inst._soundtasks[id] = nil
    if inst.AnimState:IsCurrentAnimation("proximity_pst") then
        inst.SoundEmitter:KillSound(sound)
    end
end

local function queueplaysound(inst, delay, id, sound)
    if inst._soundtasks[id] ~= nil then
        inst._soundtasks[id]:Cancel()
    end
    inst._soundtasks[id] = inst:DoTaskInTime(delay, tryplaysound, id, sound)
end

local function queuekillsound(inst, delay, id, sound)
    if inst._soundtasks[id] ~= nil then
        inst._soundtasks[id]:Cancel()
    end
    inst._soundtasks[id] = inst:DoTaskInTime(delay, trykillsound, id, sound)
end

local function tryqueueclosingsounds(inst, onanimover)
    inst._soundtasks.animover = nil
    if inst.AnimState:IsCurrentAnimation("proximity_pst") then
        inst:RemoveEventCallback("animover", onanimover)
        --Delay one less frame, since this task is delayed one frame already
        queueplaysound(inst, 4 * FRAMES, "close", "dontstarve/common/together/book_maxwell/close")
        queuekillsound(inst, 5 * FRAMES, "killidle", "idlesound")
        queueplaysound(inst, 14 * FRAMES, "drop", "dontstarve/common/together/book_maxwell/drop")
    end
end

local function onanimover(inst)
    if inst._soundtasks.animover ~= nil then
        inst._soundtasks.animover:Cancel()
    end
    inst._soundtasks.animover = inst:DoTaskInTime(FRAMES, tryqueueclosingsounds, onanimover)
end

local function stopclosingsounds(inst)
    inst:RemoveEventCallback("animover", onanimover)
    if next(inst._soundtasks) ~= nil then
        for k, v in pairs(inst._soundtasks) do
            v:Cancel()
        end
        inst._soundtasks = {}
    end
end

local function startclosingsounds(inst)
    stopclosingsounds(inst)
    inst:ListenForEvent("animover", onanimover)
    onanimover(inst)
end

local function onturnon(inst)
    if inst._activetask == nil then
        stopclosingsounds(inst)
        if inst.AnimState:IsCurrentAnimation("proximity_loop") then
            --In case other animations were still in queue
            inst.AnimState:PlayAnimation("proximity_loop", true)
        else
            inst.AnimState:PlayAnimation("proximity_pre")
            inst.AnimState:PushAnimation("proximity_loop", true)
        end
        if not inst.SoundEmitter:PlayingSound("idlesound") then
            inst.SoundEmitter:PlaySound("dontstarve/common/together/book_maxwell/active_LP", "idlesound")
        end
    end
end

local function onturnoff(inst)
    if inst._activetask == nil and not inst.components.inventoryitem:IsHeld() then
        inst.AnimState:PushAnimation("proximity_pst")
        inst.AnimState:PushAnimation("idle", false)
        startclosingsounds(inst)
    end
end

local function doneact(inst)
    inst._activetask = nil
    if inst.components.prototyper.on then
        inst.AnimState:PlayAnimation("proximity_loop", true)
        if not inst.SoundEmitter:PlayingSound("idlesound") then
            inst.SoundEmitter:PlaySound("dontstarve/common/together/book_maxwell/active_LP", "idlesound")
        end
    else
        inst.AnimState:PushAnimation("proximity_pst")
        inst.AnimState:PushAnimation("idle", false)
        startclosingsounds(inst)
    end
end

local function showfx(inst, show)
    if inst.AnimState:IsCurrentAnimation("use") then
        if show then
            inst.AnimState:Show("FX")
        else
            inst.AnimState:Hide("FX")
        end
    end
end

local function onuse(inst, hasfx)
    stopclosingsounds(inst)
    inst.AnimState:PlayAnimation("use")
    inst:DoTaskInTime(0, showfx, hasfx)
    inst.SoundEmitter:PlaySound("dontstarve/common/together/book_maxwell/use")
    if inst._activetask ~= nil then
        inst._activetask:Cancel()
    end
    inst._activetask = inst:DoTaskInTime(inst.AnimState:GetCurrentAnimationLength(), doneact)
end

local function onactivate(inst)
    onuse(inst, true)
end

local function onputininventory(inst)
    if inst._activetask ~= nil then
        inst._activetask:Cancel()
        inst._activetask = nil
    end
    stopclosingsounds(inst)
    inst.AnimState:PlayAnimation("idle")
    inst.SoundEmitter:KillSound("idlesound")
end

local function ondropped(inst)
    if inst.components.prototyper.on then
        onturnon(inst)
    end
end

local function OnHaunt(inst, haunter)
    if inst.components.prototyper.on then
        onuse(inst, false)
    else
        Launch(inst, haunter, TUNING.LAUNCH_SPEED_SMALL)
    end
    inst.components.hauntable.hauntvalue = TUNING.HAUNT_TINY
    return true
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("book_maxwell")
    inst.AnimState:SetBuild("book_maxwell")
    inst.AnimState:PlayAnimation("idle")

	inst:AddTag("book")
    inst:AddTag("shadowmagic")
    inst:AddTag("donotautopick")
    --prototyper (from prototyper component) added to pristine state for optimization
    inst:AddTag("prototyper")

    MakeInventoryFloatable(inst, "med", nil, 0.75)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst._activetask = nil
    inst._soundtasks = {}

	inst.swap_build = "book_maxwell"

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/codex_mantra.xml"

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.MED_FUEL

	inst:AddComponent("book")
	inst.components.book.onread = onread

    inst:AddComponent("prototyper")
    inst.components.prototyper.onturnon = onturnon
    inst.components.prototyper.onturnoff = onturnoff
    inst.components.prototyper.onactivate = onactivate
    inst.components.prototyper.trees = TUNING.PROTOTYPER_TREES.PRESTIHATITATOR
	
    inst:ListenForEvent("ondropped", ondropped)

	MakeSmallBurnable(inst, TUNING.MED_BURNTIME)
	MakeSmallPropagator(inst)
	MakeHauntableLaunch(inst)
	
    return inst
end

return Prefab("codex_mantra", fn, assets)