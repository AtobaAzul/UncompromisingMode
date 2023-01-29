local prefabs =
{
    "sporecloud",
}



local function UpdateBuild(inst, playsound)
    inst._buildtask = nil
    if inst._level < 1 then
        inst.AnimState:ClearOverrideSymbol("trunk")
    else
        inst.AnimState:OverrideSymbol("trunk", "mushroomsprout_upg_build", "trunk"..tostring(inst._level))
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

local function chop_down_tree(inst, worker)
    if inst._destroy then
        inst._destroy = nil
    elseif not inst.persists then
        return
    end

    inst:RemoveComponent("hauntable")

    inst.components.workable:SetOnWorkCallback(nil)
    inst.components.workable:SetOnFinishCallback(nil)
    inst.components.workable:SetWorkable(false)


    inst.SoundEmitter:PlaySound("dontstarve/forest/treeCrumble")
    if inst._buildtask ~= nil then
        inst._buildtask:Cancel()
        UpdateBuild(inst)
    end
    inst.AnimState:PlayAnimation("fall")
    inst:RemoveEventCallback("animover", Sway)
    inst:ListenForEvent("animover", inst.Remove)


    inst:AddTag("NOCLICK")
    inst.persists = false

    if inst._link ~= nil then
        inst._link:PushEvent("unlinkhorn", inst)
        inst._link = nil
    end
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
end




local function OnLoad(inst, data)
    if inst._inittask ~= nil then
        inst._inittask:Cancel()
        inst._inittask = nil
    end


        
        Sway(inst)
        inst.AnimState:SetTime(inst.AnimState:GetCurrentAnimationLength() * math.random())
    
end

local function DoLink(inst, link)
    inst._link = link

    inst:ListenForEvent("rambranchlevel", function(link, level)
        if inst._link ~= nil then
            inst._targetlevel = level
            if POPULATING then
                inst._level = level
                if inst._buildtask ~= nil then
                    inst._buildtask:Cancel()
                end
                UpdateBuild(inst)
            end
        end
    end, link)

    local function onlinkdead(link)
        if inst._link ~= nil then
            inst._link = nil
            if inst.persists then
                inst._destroy = true
                inst.persists = false
            end
        end
    end
    inst:ListenForEvent("onremove", onlinkdead, link)
    inst:ListenForEvent("death", onlinkdead, link)

    link:PushEvent("linkhorn", inst)
end

local function OnLoadPostPass(inst)
    if inst._link == nil then
        local link = inst.components.entitytracker:GetEntity("rambranch")
        if link ~= nil then
            DoLink(inst, link)
        end
    end
end

local function OnLinkRambranch(inst, link)
    if inst._link == nil then
        inst.components.entitytracker:TrackEntity("rambranch", link)
        DoLink(inst, link)
    end
end

local function OnInit(inst)
    inst._inittask = nil
    inst.SoundEmitter:PlaySound("dontstarve/creatures/together/toad_stool/mushtree_grow")
end

local function MakeSprout(name)
    local assets =
    {
        Asset("ANIM", "anim/mushroomsprout.zip"),
        Asset("ANIM", "anim/mushroomsprout_upg_build.zip"),
    }

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
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


        --inst:AddTag("shelter")
        inst:AddTag("tree")
        inst:AddTag("mushroomsprout")

        inst.AnimState:SetBuild("mushroomsprout_upg_build")
        inst.AnimState:SetBank("mushroomsprout")
        inst.AnimState:PlayAnimation("shroom_pre")


        inst.entity:SetPristine()

        if not TheWorld.ismastersim then

            return inst
        end

        inst._level = 0
        inst._targetlevel = 0

        MakeSmallPropagator(inst)

        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.CHOP)
        inst.components.workable:SetOnWorkCallback(chop_tree)
        inst.components.workable:SetOnFinishCallback(chop_down_tree)

        inst:ListenForEvent("animover", Sway)
        inst._inittask = inst:DoTaskInTime(0, OnInit)

        inst:AddComponent("inspectable")
        inst.components.workable:SetWorkLeft(TUNING.TOADSTOOL_MUSHROOMSPROUT_CHOPS)

        inst:AddComponent("entitytracker")

        MakeHauntableWorkAndIgnite(inst)
		inst:AddComponent("sanityaura")
		inst.components.sanityaura.aura = -TUNING.SANITYAURA_MED
        inst.OnLoad = OnLoad
        inst.OnLoadPostPass = OnLoadPostPass

        inst:ListenForEvent("linkrambranch", OnLinkRambranch)

        return inst
    end

    return Prefab(name, fn, assets, prefabs)
end

return MakeSprout("nightmarehorn")
