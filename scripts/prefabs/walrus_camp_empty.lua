local function ontimerdone(inst, data)
    if data.name == "CallMoose" then
        --If this happens then the nesting location was asleep for the entire waiting period.
        --Put down a moose and pre-lay an egg.
        TheWorld.components.walrusspawner:DoHardSpawn(inst)
		inst.camped = true
		inst:Hide()
    end
end

local function spawncamp(inst)
    --print(string.format("mooseIncoming = %s", tostring(inst.mooseIncoming)))
    if inst.mooseIncoming then
        TheWorld.components.walrusspawner:DoSoftSpawn(inst)
		inst.camped = true
		inst:Hide()
    end
end

local function nest_onsave(inst, data)
    data.mooseIncoming = inst.mooseIncoming
	data.camped = inst.camped
end

local function nest_onload(inst, data)
    if data ~= nil and data.mooseIncoming ~= nil then
        inst.mooseIncoming = data.mooseIncoming
    end
	if TheWorld.state.iswinter and data.camped == true then
	inst.camped = true
	inst:Hide()
	else
	inst:Show()
	end
end

local function OnIsWinter(inst)
if inst.camped == true then
inst:Hide()
end
end
local function OnIsSpring(inst)
inst:Show()
end

local function nesting_ground_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
    inst.entity:AddMiniMapEntity()
	
    inst.AnimState:SetBank("igloo_track")
    inst.AnimState:SetBuild("igloo_track")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(3)
    inst:AddTag("antlion_sinkhole_blocker")
    inst.MiniMapEntity:SetIcon("igloo.png")
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("timer")
    inst:ListenForEvent("timerdone", ontimerdone)

    inst:AddComponent("playerprox")
	inst.Transform:SetRotation(math.random()*360)
    inst.components.playerprox:SetDist(15, 20)
    inst.components.playerprox:SetOnPlayerNear(spawncamp)
	inst:AddComponent("inspectable")
	inst:AddTag("wal_camp_pos")
    inst.OnSave = nest_onsave
    inst.OnLoad = nest_onload
	inst.camped = false
    inst:WatchWorldState("iswinter", OnIsWinter)
    inst:WatchWorldState("isspring", OnIsSpring)
    return inst
end

return Prefab("walrus_camp_empty", nesting_ground_fn)