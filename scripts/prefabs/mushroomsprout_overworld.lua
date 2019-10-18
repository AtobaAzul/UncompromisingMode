local assets =
    {
        Asset("ANIM", "anim/mushroomsprout.zip"),
    }

local prefabs =
{
    "sporecloud",
	"disease_puff",
}

local FADE_FRAMES = 10
local FADE_INTENSITY = .8
local FADE_RADIUS = 1
local FADE_FALLOFF = .5

STRINGS.MUSHROOMSPROUT_OVERWORLD = "Mushroom Sprout"
STRINGS.NAMES.MUSHROOMSPROUT_OVERWORLD = "Mushroom Sprout"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MUSHROOMSPROUT_OVERWORLD = "That thing's poisoning the world!"

local function OnUpdateFade(inst)
    local k
    if inst._fade:value() <= FADE_FRAMES then
        inst._fade:set_local(math.min(inst._fade:value() + 1, FADE_FRAMES))
        k = inst._fade:value() / FADE_FRAMES
    else
        inst._fade:set_local(math.min(inst._fade:value() + 1, FADE_FRAMES * 2 + 1))
        k = (FADE_FRAMES * 2 + 1 - inst._fade:value()) / FADE_FRAMES
    end

    inst.Light:SetIntensity(FADE_INTENSITY * k)
    inst.Light:SetRadius(FADE_RADIUS * k)
    inst.Light:SetFalloff(1 - (1 - FADE_FALLOFF) * k)

    if TheWorld.ismastersim then
        inst.Light:Enable(inst._fade:value() > 0 and inst._fade:value() <= FADE_FRAMES * 2)
    end

    if inst._fade:value() == FADE_FRAMES or inst._fade:value() > FADE_FRAMES * 2 then
        inst._fadetask:Cancel()
        inst._fadetask = nil
    end
end

local function OnFadeDirty(inst)
    if inst._fadetask == nil then
        inst._fadetask = inst:DoPeriodicTask(FRAMES, OnUpdateFade)
    end
    OnUpdateFade(inst)
end

local function FadeOut(inst)
    inst._fade:set(FADE_FRAMES + 1)
    if inst._fadetask == nil then
        inst._fadetask = inst:DoPeriodicTask(FRAMES, OnUpdateFade)
    end
end

local function UpdateBuild(inst, playsound)
    inst._buildtask = nil
    if inst._level < 1 then
        inst.AnimState:ClearOverrideSymbol("trunk")
    else
        inst.AnimState:OverrideSymbol("trunk", inst.prefab.."_upg_build", "trunk"..tostring(inst._level))
    end
    if playsound then
        inst.SoundEmitter:PlaySound("dontstarve/creatures/together/toad_stool/mushtree_hit")
    end
end

local function Sway(inst)
    if inst._destroy then
        inst.components.workable:Destroy(inst)
    elseif inst._level ~= inst._targetlevel then
        inst.AnimState:PlayAnimation("transform")
        inst._level = inst._targetlevel
        if inst._buildtask == nil then
            inst._buildtask = inst:DoTaskInTime(15 * FRAMES, UpdateBuild, true)
        end
    else
        if inst._buildtask ~= nil then
            inst._buildtask:Cancel()
            UpdateBuild(inst)
        end
        inst.AnimState:PlayAnimation("sway"..math.random(3).."_loop")
    end
end

local function OnBurnt(inst)
    if not inst.persists then
        return
    end

    inst:RemoveComponent("burnable")
    inst:RemoveComponent("propagator")
    inst:RemoveComponent("hauntable")

    inst.components.workable:SetOnWorkCallback(nil)
    inst.components.workable:SetOnFinishCallback(nil)
    inst.components.workable:SetWorkable(false)

    RemovePhysicsColliders(inst)

    SpawnPrefab("sporecloud_toad").Transform:SetPosition(inst.Transform:GetWorldPosition())

    if inst._buildtask ~= nil then
        inst._buildtask:Cancel()
        UpdateBuild(inst)
    end
    inst.AnimState:PlayAnimation("burnt_chop")
    inst:RemoveEventCallback("animover", Sway)
    inst:ListenForEvent("animover", inst.Remove)

    FadeOut(inst)
    inst:AddTag("NOCLICK")
    inst.persists = false

    
end

local function stop_burning(inst)
    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
        inst.components.burnable:Extinguish()
    end
end

local function chop_down_tree(inst, worker)


	if inst.components.childspawner ~= nil then
        inst.components.childspawner:ReleaseAllChildren(worker, "toad")
    end


    if inst._destroy then
        inst._destroy = nil
    elseif not inst.persists then
        return
    end

    inst:RemoveComponent("hauntable")

    inst.components.workable:SetOnWorkCallback(nil)
    inst.components.workable:SetOnFinishCallback(nil)
    inst.components.workable:SetWorkable(false)

    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
        inst:DoTaskInTime(28 * FRAMES, stop_burning)
    end

    inst.SoundEmitter:PlaySound("dontstarve/forest/treeCrumble")
    if inst._buildtask ~= nil then
        inst._buildtask:Cancel()
        UpdateBuild(inst)
    end
    inst.AnimState:PlayAnimation("fall")
    inst:RemoveEventCallback("animover", Sway)
    inst:ListenForEvent("animover", inst.Remove)

    FadeOut(inst)
    inst:AddTag("NOCLICK")
    inst.persists = false

	SpawnPrefab("sporecloud_toad").Transform:SetPosition(inst.Transform:GetWorldPosition())
	



    
end



local function WakeUpLeif(ent)
    ent.components.sleeper:WakeUp()
end



local function chop_tree(inst, chopper)

	


    if chopper == nil or not chopper:HasTag("playerghost") then
        inst.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_tree")
    end
    inst.SoundEmitter:PlaySound("dontstarve/creatures/together/toad_stool/mushtree_hit")
    if inst._buildtask ~= nil then
        inst._buildtask:Cancel()
        UpdateBuild(inst)
    end
    inst.AnimState:PlayAnimation("chop")


	local x, y, z = inst.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x, y, z, TUNING.LEIF_REAWAKEN_RADIUS, { "toad" })
        for i, v in ipairs(ents) do
            if v.components.sleeper ~= nil and v.components.sleeper:IsAsleep() then
                v:DoTaskInTime(math.random(), WakeUpLeif)
            end
            v.components.combat:SuggestTarget(chopper)
        end


end

local function inspect_tree(inst)
    return inst.components.burnable ~= nil
        and inst.components.burnable:IsBurning()
        and "BURNING"
        or nil
end

local function OnSave(inst, data)
    data.burnt = inst.components.burnable ~= nil and inst.components.burnable:IsBurning() or nil
end

local function OnLoad(inst, data)
    if inst._inittask ~= nil then
        inst._inittask:Cancel()
        inst._inittask = nil
    end

    if data ~= nil and data.burnt then
        OnBurnt(inst)
    else
        inst._fade:set(FADE_FRAMES)
        OnFadeDirty(inst)
        Sway(inst)
        inst.AnimState:SetTime(inst.AnimState:GetCurrentAnimationLength() * math.random())
    end
end


local function OnLoadPostPass(inst)
    
end


local function OnInit(inst)
    inst._inittask = nil
    inst.SoundEmitter:PlaySound("dontstarve/creatures/together/toad_stool/mushtree_grow")
	inst.components.timer:StartTimer("acidrainer", 10)

	inst.components.childspawner:StartSpawning()
end


local function SpawnDiseasePuff(inst)
    SpawnPrefab("disease_puff").Transform:SetPosition(inst.Transform:GetWorldPosition())
end


local function ontimerdone(inst, data)
	if data.name == "acidrainer" and TheWorld.state.isautumn and not TheWorld.state.israining then
        TheWorld:PushEvent("ms_forceprecipitation", true)
        inst.components.timer:StartTimer("acidrainer", 10)
    else
        inst.components.timer:StartTimer("acidrainer", 10)
    end
end


    local function fn(inst)
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddLight()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()
		

        --DO THE PHYSICS STUFF MANUALLY SO THAT WE CAN SHUT OFF THE BOSS COLLISION.
        --don't yell at me plz...
        --MakeObstaclePhysics(inst, .25, 2)
        ----------------------------------------------------
        inst:AddTag("blocker")
        inst.entity:AddPhysics()
        inst.Physics:SetMass(0) 
        inst.Physics:SetCollisionGroup(COLLISION.OBSTACLES)
        inst.Physics:ClearCollisionMask()
        inst.Physics:CollidesWith(COLLISION.ITEMS)
        inst.Physics:CollidesWith(COLLISION.CHARACTERS)
        --inst.Physics:CollidesWith(COLLISION.GIANTS)
        inst.Physics:SetCapsule(.25, 2)
        ----------------------------------------------------
		inst:AddComponent("diseaseable")
		inst:AddTag("diseased") 
		inst.components.diseaseable:RestartNearbySpread()
		inst:DoTaskInTime(23 * FRAMES, SpawnDiseasePuff)
		
		inst:AddComponent("childspawner")
    inst.components.childspawner.childname = "toad"
    inst.components.childspawner:SetRegenPeriod(30)
    inst.components.childspawner:SetSpawnPeriod(30)
    inst.components.childspawner:SetMaxChildren(1)
    inst.components.childspawner:StartRegen()
	
    inst.components.childspawner.emergencychildname = "toad"
    inst.components.childspawner.emergencychildrenperplayer = 1
    inst.components.childspawner:SetMaxEmergencyChildren(1)

	local minimap = inst.entity:AddMiniMapEntity()
	inst.MiniMapEntity:SetIcon("toadstool_cap.png")


        inst.Light:SetFalloff(FADE_FALLOFF)
        inst.Light:SetIntensity(FADE_INTENSITY)
        inst.Light:SetRadius(FADE_RADIUS)
        inst.Light:SetColour(180 / 255, 60 / 255, 255 / 255)
        inst.Light:Enable(false)
        inst.Light:EnableClientModulation(true)

        --inst:AddTag("shelter")
        inst:AddTag("tree")
        inst:AddTag("mushroomsprout")
        inst:AddTag("cavedweller")
	inst:AddTag("antlion_sinkhole")
    	inst:AddTag("antlion_sinkhole_blocker")

        inst.AnimState:SetBuild("mushroomsprout_dark_upg_build")
        inst.AnimState:SetBank("mushroomsprout")
        inst.AnimState:PlayAnimation("shroom_pre")
        inst.AnimState:SetLightOverride(.3)

        inst._fade = net_smallbyte(inst.GUID, "mushroomsprout._fade", "fadedirty")

        inst._fadetask = inst:DoPeriodicTask(FRAMES, OnUpdateFade)

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            inst:ListenForEvent("fadedirty", OnFadeDirty)

            return inst
        end

	inst:AddComponent("timer")
	inst:ListenForEvent("timerdone", ontimerdone)

        inst._level = 0
        inst._targetlevel = 0

        MakeSmallPropagator(inst)
        MakeMediumBurnable(inst, TUNING.TREE_BURN_TIME)
        inst.components.burnable:SetOnBurntFn(OnBurnt)

        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.CHOP)
        inst.components.workable:SetOnWorkCallback(chop_tree)
        inst.components.workable:SetOnFinishCallback(chop_down_tree)

        inst:ListenForEvent("animover", Sway)
        inst._inittask = inst:DoTaskInTime(0, OnInit)

        inst:AddComponent("inspectable")
        inst.components.inspectable.getstatus = inspect_tree

            inst.components.workable:SetWorkLeft(TUNING.TOADSTOOL_DARK_MUSHROOMSPROUT_CHOPS)
        

        inst:AddComponent("entitytracker")

        MakeHauntableWorkAndIgnite(inst)

        inst.OnSave = OnSave
        inst.OnLoad = OnLoad
        inst.OnLoadPostPass = OnLoadPostPass


        return inst
    

end

return Prefab("mushroomsprout_overworld", fn, assets, prefabs)