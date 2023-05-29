local assets =
{
    Asset("ANIM", "anim/stagehand.zip"),
    Asset("SOUND", "sound/sfx.fsb"),
}

local prefabs =
{
    "campfirefire",
    "endtable_blueprint",
}

local brain = require("brains/um_shamblerbrain")

local function LinkToPlayer(inst, player)
    inst._playerlink = player
    inst.components.follower:SetLeader(player)

    inst:ListenForEvent("onremove", inst._onlostplayerlink, player)
end

local function OnPlayerLinkDespawn(inst, forcedrop)
	inst.sg:GoToState("dissipate")
end

local function KeepTargetFn(inst, target)
    if target ~= nil and target:IsValid()
	and target.maxwell_vetcurse and not target.components.health:IsDead() then
        return true
    end

	inst.sg:GoToState("dissipate")

    return false
end

local function AuraTest(inst, target)
    return target.maxwell_vetcurse and inst.components.follower.leader == target or false
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeGhostPhysics(inst, .5, .5)

    inst.AnimState:SetBank("ghost")
    inst.AnimState:SetBuild("ghost_build")
    inst.AnimState:PlayAnimation("idle", true)

    inst:AddTag("notraptrigger")
    inst:AddTag("fx")
    inst:AddTag("noauradamage")

    inst.SoundEmitter:PlaySound("dontstarve/ghost/ghost_howl_LP", "howl")
	
    if not TheNet:IsDedicated() then
		-- this is purely view related
		inst:AddComponent("um_shambler_transparency")
		inst.components.um_shambler_transparency.tag = "shambler_target"
		inst.components.um_shambler_transparency:ForceUpdate()
	end

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("follower")
    inst.components.follower:KeepLeaderOnAttacked()
    inst.components.follower.keepdeadleader = true
    inst.components.follower.keepleaderduringminigame = true
	
    inst:AddComponent("combat")
    inst.components.combat.defaultdamage = 9999999
    inst.components.combat.playerdamagepercent = TUNING.GHOST_DMG_PLAYER_PERCENT
    inst.components.combat:SetKeepTargetFunction(KeepTargetFn)

    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor.walkspeed = 2
	inst.components.locomotor.walkspeed = 15

    inst:AddComponent("aura")
    inst.components.aura.radius = 3
    inst.components.aura.tickperiod = 0.5
    inst.components.aura.auratestfn = AuraTest
	
    inst.LinkToPlayer = LinkToPlayer
	inst.OnPlayerLinkDespawn = OnPlayerLinkDespawn
	inst._onlostplayerlink = function(player) inst._playerlink = nil end
	
    inst:SetStateGraph("SGum_shambler")
    inst:SetBrain(brain)
	
    inst.persists = false

    return inst
end

return Prefab("um_shambler", fn, assets, prefabs)
