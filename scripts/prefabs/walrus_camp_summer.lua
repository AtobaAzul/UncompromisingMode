local assets =
{
    Asset("ANIM", "anim/walrus_house.zip"),
    Asset("ANIM", "anim/walrus_house_summer.zip"),
    Asset("ANIM", "anim/igloo_track.zip"),
    Asset("SOUND", "sound/pig.fsb"), -- light on/off sounds
    Asset("MINIMAP_IMAGE", "igloo"),
}

local prefabs =
{
    "walrus",
    "little_walrus",
    "firehound",
}

local NUM_HOUNDS = 2
local AGGRO_SPAWN_PARTY_RADIUS = 10

local function GetSpawnPoint(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local rad = 2
    local angle = math.random() * 2 * PI
	
    return x + rad * math.cos(angle), y, z - rad * math.sin(angle)
end

local function GetStatus(inst)
    if not inst.data.occupied then
        return "EMPTY"
    end
end

local function UpdateLight(inst, on)
    if on then
        inst.Light:Enable(true)
        inst.AnimState:PlayAnimation("lit", true)
        if not inst.data.lighton then
            inst.SoundEmitter:PlaySound("dontstarve/pig/pighut_lighton")
            inst.data.lighton = true
        end
    else
        inst.Light:Enable(false)
        inst.AnimState:PlayAnimation("idle", true)
        if inst.data.lighton then
            inst.SoundEmitter:PlaySound("dontstarve/pig/pighut_lightoff")
            inst.data.lighton = false
        end
    end
end

local function SetOccupied(inst, occupied)
    inst.data.occupied = occupied

    if occupied then

        inst.AnimState:SetBank("walrus_house")
        inst.AnimState:SetBuild("walrus_house_summer")

        UpdateLight(inst, not TheWorld.state.isday)

        inst.AnimState:SetOrientation(ANIM_ORIENTATION.Default)
        inst.AnimState:SetLayer(LAYER_WORLD)
        inst.AnimState:SetSortOrder(0)
		inst.AnimState:SetMultColour(1, 1, 1, 1)

        MakeObstaclePhysics(inst, 3)
    else
        UpdateLight(inst, false)

        inst.AnimState:SetBank("igloo_track")
        inst.AnimState:SetBuild("igloo_track")
		
		if TheWorld.state.iswinter then
			inst.AnimState:PlayAnimation("idleno")
		else
			inst.AnimState:PlayAnimation("idle")
		end
		
        inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
        inst.AnimState:SetLayer(LAYER_BACKGROUND)
        inst.AnimState:SetSortOrder(4)
		inst.AnimState:SetMultColour(1, 1, 1, 0)
 
        inst.Physics:ClearCollisionMask()
        inst.Physics:CollidesWith(COLLISION.WORLD)
    end
end

local function UpdateCampOccupied(inst)
    if inst.data.occupied then
        if not TheWorld.state.issummer then
            for k,v in pairs(inst.data.children) do
                if k:IsValid() and not k:IsAsleep() then
                    -- don't go away while there are children alive in the world
                    return
                end
            end
            for k,v in pairs(inst.data.children) do
                k:Remove()
            end
            inst.data.children = {}
            SetOccupied(inst, false)
        end
    elseif TheWorld.state.issummer then
        SetOccupied(inst, true)
    end
end

local function RemoveMember(inst, member)
    inst.data.children[member] = nil

    if inst:IsAsleep() then
        UpdateCampOccupied(inst)
    end
end

local function OnMemberKilled(inst, member, data)

    if not inst.data.regentime then
        inst.data.regentime = {}
    end

    inst.data.regentime[member.prefab] = GetTime() + TUNING.WALRUS_REGEN_PERIOD

    RemoveMember(inst, member)
end

local OnMemberNewTarget -- forward declaration
local DespaenedFromHaunt

local function TrackMember(inst, member)
    inst.data.children[member] = true
    inst:ListenForEvent("death", function(...) OnMemberKilled(inst, ...) end, member)
    inst:ListenForEvent("newcombattarget", function(...) OnMemberNewTarget(inst, ...) end, member)
    inst:ListenForEvent("despawnedfromhaunt", function(member, data) DespawnedFromHaunt(inst,member,data) end, member)

    if not member.components.homeseeker then
        member:AddComponent("homeseeker")
    end
    member.components.homeseeker:SetHome(inst)
end

DespawnedFromHaunt = function(inst, oldchild, data)
    local newchild = data.newPrefab
    
    inst.data.children[oldchild] = nil
    TrackMember(inst, newchild)

    if inst:IsAsleep() then
        UpdateCampOccupied(inst)
    end
end

local function SpawnMember(inst, prefab)
    local member = SpawnPrefab(prefab)

    TrackMember(inst, member)

    return member
end

local function GetMember(inst, prefab)
    for k,v in pairs(inst.data.children) do
        if k.prefab == prefab then
            return k
        end
    end
end

local function GetMembers(inst, prefab)
    local members = {}
    for k,v in pairs(inst.data.children) do
        if k.prefab == prefab then
            table.insert(members, k)
        end
    end
    return members
end

local function CanSpawn(inst, prefab)
    local regentime = inst.data.regentime and inst.data.regentime[prefab]
    if regentime then
        local time = GetTime()
        local result = time > regentime
		
        return result
    else
        return true
    end
end

local function OnWentHome(inst, data)
    RemoveMember(inst, data.doer)
    UpdateLight(inst, inst.data.occupied)
end

local function SpawnHuntingParty(inst, target, houndsonly)
    -- defer setting the transforms to prevent all kinds of events happening
    -- during set-up of the party
    local transformsToSet = {}
    local leader = GetMember(inst, "walrus")
    if not houndsonly and not leader and CanSpawn(inst, "walrus") then
        leader = SpawnMember(inst, "walrus")
        local x,y,z = GetSpawnPoint(inst)
        transformsToSet[#transformsToSet + 1] = {inst = leader, x=x, y=y,z=z }
    end

    local companion = GetMember(inst, "little_walrus")
    if not houndsonly and not companion and CanSpawn(inst, "little_walrus") then
        companion = SpawnMember(inst, "little_walrus")
        local x,y,z = GetSpawnPoint(inst)
        transformsToSet[#transformsToSet + 1] = {inst = companion, x=x, y=y,z=z }
    end

    if companion and leader then
        companion.components.follower:SetLeader(leader)
    end

    local existing_hounds = GetMembers(inst, "firehound")
    for i = 1,NUM_HOUNDS do

        local hound = existing_hounds[i]
        if not hound and CanSpawn(inst, "firehound") then
            hound = SpawnMember(inst, "firehound")
            hound:AddTag("pet_hound")
            local x,y,z = GetSpawnPoint(inst)
			
            transformsToSet[#transformsToSet + 1] = {inst = hound, x=x, y=y,z=z }
            hound.sg:GoToState("idle")
        end

        if companion and hound then
            if not hound.components.follower then
                hound:AddComponent("follower")
            end
            hound.components.follower:SetLeader(companion)
        end
    end

    if target then
        if companion then
            companion.components.combat:SuggestTarget(target)
        end
        if leader then
            leader.components.combat:SuggestTarget(target)
        end
    end

    for i,v in ipairs(transformsToSet) do
        v.inst.Transform:SetPosition(v.x, v.y, v.z)
    end
end

local function CheckSpawnHuntingParty(inst, target, houndsonly)
    if inst.data.occupied and TheWorld.state.issummer then
        SpawnHuntingParty(inst, target, houndsonly)
        UpdateLight(inst, houndsonly) -- keep light on if hounds only, otherwise off
    end
end

-- assign value to forward declared local above
OnMemberNewTarget = function (inst, member, data)
    if member:IsNear(inst, AGGRO_SPAWN_PARTY_RADIUS) then
        CheckSpawnHuntingParty(inst, data.target, false)
    end
end

local function OnEntitySleep(inst)
    if not POPULATING then
        UpdateCampOccupied(inst)
        CheckSpawnHuntingParty(inst, nil, not TheWorld.state.isday)
    end
end

local function OnEntityWake(inst)
end

local function OnStartDay(inst)
    CheckSpawnHuntingParty(inst, nil, false)
end

local function OnIsSummer(inst)
    if inst:IsAsleep() then
        UpdateCampOccupied(inst)
        CheckSpawnHuntingParty(inst, nil, not TheWorld.state.isday)
    end
end

local function OnSave(inst, data)

    data.children = {}

    for k,v in pairs(inst.data.children) do
        table.insert(data.children, k.GUID)
    end

    if #data.children < 1 then
        data.children = nil
    end

    data.occupied = inst.data.occupied

    if inst.data.regentime then
        local time = GetTime()
        data.regentimeremaining = {}
        for k,v in pairs(inst.data.regentime) do
            local remaining = v - time
            if remaining > 0 then
                data.regentimeremaining[k] = remaining
            end
        end
    end

    return data.children

end

local function OnLoad(inst, data)
    if data then
    -- children loaded by OnLoadPostPass

        if data.occupied ~= nil then
            SetOccupied(inst, data.occupied)
        end

        inst.data.regentime = {}
        if data.regentimeremaining then
            local time = GetTime()
            for k,v in pairs(data.regentimeremaining) do
                inst.data.regentime[k] = time + v
            end
        end
    end
end

local function OnLoadPostPass(inst, newents, data)

    if data and data.children and #data.children > 0 then
        for k,v in pairs(data.children) do
            local child = newents[v]
            if child then
                child = child.entity
				
                TrackMember(inst, child)
            end
        end

    end
end

local function create()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddSoundEmitter()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, 3)

    inst.AnimState:SetBank("walrus_house")
    inst.AnimState:SetBuild("walrus_house_summer")

    inst.MiniMapEntity:SetIcon("igloo.png")

    inst.Light:SetFalloff(1)
    inst.Light:SetIntensity(.5)
    inst.Light:SetRadius(2)
    inst.Light:SetColour(180/255, 195/255, 50/255)

    --inst:AddTag("tent")
    inst:AddTag("antlion_sinkhole_blocker")
    inst:AddTag("summercamp")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.data = { children = {} }

    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = GetStatus

    inst:WatchWorldState("startday", OnStartDay)

    inst:ListenForEvent("onwenthome", OnWentHome)

    inst.data.lighton = not TheWorld.state.isday
    inst.Light:Enable(inst.data.lighton)

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad
    inst.OnLoadPostPass = OnLoadPostPass

    inst.OnEntitySleep = OnEntitySleep
    inst.OnEntityWake = OnEntityWake

    SetOccupied(inst, TheWorld.state.issummer)

    inst:WatchWorldState("issummer", OnIsSummer)
	
    return inst
end

return Prefab("walrus_camp_summer", create, assets, prefabs)
