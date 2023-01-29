local assets =
{
    Asset("ANIM", "anim/scorpion_eggs.zip"),
}

local function Attacked(inst,data)
	if inst.components.health and not inst.components.health:IsDead() then
		inst.AnimState:PlayAnimation("hit")
		inst.AnimState:PushAnimation("idle")
	end
end

local function Death(inst)
	inst.AnimState:PlayAnimation("death")
end

local function scorpion_eggsfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    --inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, 1)

    inst.AnimState:SetBank("scorpion_eggs")
    inst.AnimState:SetBuild("scorpion_eggs")
    inst.AnimState:PlayAnimation("idle")

    --inst.MiniMapEntity:SetIcon("rock.png")
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("lootdropper")
	
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(500)
	inst:AddComponent("combat")
	inst.components.combat.onhitfn = Attacked
    inst:AddComponent("inspectable")
	
	inst:ListenForEvent("death",Death)
	
    MakeHauntableWork(inst)

    return inst
end


return Prefab("um_scorpioneggs", scorpion_eggsfn, assets)
