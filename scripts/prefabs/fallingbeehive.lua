local prefabs =
{
    "bee",
    "killerbee",
    "honey",
    "honeycomb",
}

local assets =
{
    Asset("ANIM", "anim/beehive.zip"),
    Asset("SOUND", "sound/bee.fsb"),
}

local function OnKilled(inst)
    inst.AnimState:PlayAnimation("cocoon_dead", true)
    RemovePhysicsColliders(inst)

    inst.SoundEmitter:KillSound("loop")

    inst.SoundEmitter:PlaySound("dontstarve/bee/beehive_destroy")
    inst.components.lootdropper:DropLoot(inst:GetPosition())
end



local HAUNTTARGET_MUST_TAGS = { "_combat" }
local HAUNTTARGET_CANT_TAGS = { "insect", "playerghost", "INLIMBO" }
local HAUNTTARGET_ONEOF_TAGS = { "character", "animal", "monster" }
local function OnHaunt(inst)

    local target = FindEntity(
        inst,
        25,
        function(guy)
            return inst.components.combat:CanTarget(guy)
        end,
        HAUNTTARGET_MUST_TAGS, --See entityreplica.lua (re: "_combat" tag)
        HAUNTTARGET_CANT_TAGS,
        HAUNTTARGET_ONEOF_TAGS
    )

    if target ~= nil then
        OnHit(inst, target)
        return true
    end
    return false
end



local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, .5)

    inst.MiniMapEntity:SetIcon("beehive.png")

    inst.AnimState:SetBank("beehive")
    inst.AnimState:SetBuild("beehive")
    inst.AnimState:PlayAnimation("cocoon_small", true)

	-- by werebeaver
    inst:AddTag("hive")


    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    -------------------
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(99999)

    -------------------



    ---------------------
    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot({ "honey", "honey", "honey", "honeycomb" })
    ---------------------

    ---------------------

    ---------------------
    ---------------------

    inst:ListenForEvent("death", OnKilled)

    ---------------------
    MakeSnowCovered(inst)

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_SMALL)
    inst.components.hauntable:SetOnHauntFn(OnHaunt)

    ---------------------
	inst:AddComponent("inventoryitem")
    inst.components.inventoryitem:SetSinks(true)

    return inst
end

return Prefab("fallingbeehive", fn, assets, prefabs)
