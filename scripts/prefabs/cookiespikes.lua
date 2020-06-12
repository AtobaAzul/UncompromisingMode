local assets =
{
    Asset("ANIM", "anim/cookiespikes.zip"),
}

--DSV uses 4 but ignores physics radius
local MAXRANGE = 3
local NO_TAGS_NO_PLAYERS = { "bramble_resistant", "INLIMBO", "notarget", "noattack", "flight", "invisible", "player" }
local NO_TAGS = { "bramble_resistant", "INLIMBO", "notarget", "noattack", "flight", "invisible", "playerghost" }

local function OnUpdateThorns(inst)
    inst.range = inst.range + .75

    local x, y, z = inst.Transform:GetWorldPosition()
    for i, v in ipairs(TheSim:FindEntities(x, y, z, inst.range + 3, { "_combat" }, inst.canhitplayers and NO_TAGS or NO_TAGS_NO_PLAYERS)) do
        if not inst.ignore[v] and
            v:IsValid() and
            v.entity:IsVisible() and
            v.components.combat ~= nil and
            not (v.components.inventory ~= nil and
                v.components.inventory:EquipHasTag("bramble_resistant")) then
            local range = inst.range + v:GetPhysicsRadius(0)
            if v:GetDistanceSqToPoint(x, y, z) < range * range then
                if inst.owner ~= nil and not inst.owner:IsValid() then
                    inst.owner = nil
                end
                if inst.owner ~= nil then
                    if inst.owner.components.combat ~= nil and inst.owner.components.combat:CanTarget(v) then
                        inst.ignore[v] = true
                        v.components.combat:GetAttacked(v.components.follower ~= nil and v.components.follower:GetLeader() == inst.owner and inst or inst.owner, inst.damage)
                        --V2C: wisecracks make more sense for being pricked by picking
                        --v:PushEvent("thorns")
                    end
                elseif v.components.combat:CanBeAttacked() then
                    inst.ignore[v] = true
                    v.components.combat:GetAttacked(inst, inst.damage)
                    --v:PushEvent("thorns")
                end
            end
        end
    end

    if inst.range >= MAXRANGE then
        inst.components.updatelooper:RemoveOnUpdateFn(OnUpdateThorns)
    end
end

local function SetFXOwner(inst, owner)
    inst.Transform:SetPosition(owner.Transform:GetWorldPosition())
    inst.owner = owner
    inst.canhitplayers = not owner:HasTag("player") or TheNet:GetPVPEnabled()
    inst.ignore[owner] = true
end


local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        inst:AddTag("FX")
        inst:AddTag("thorny")

        inst.Transform:SetFourFaced()
		inst.Transform:SetScale(0.8, 0.8, 0.8)

        inst.AnimState:SetBank("cactus_volcano")
        inst.AnimState:SetBuild("cookiespikes")
        inst.AnimState:PlayAnimation("attack")

        inst.entity:SetPristine()
        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("updatelooper")
        inst.components.updatelooper:AddOnUpdateFn(OnUpdateThorns)

        inst:ListenForEvent("animover", inst.Remove)
        inst.persists = false
        inst.damage = 5
        inst.range = .75
        inst.ignore = {}
        inst.canhitplayers = true
        --inst.owner = nil

        inst.SetFXOwner = SetFXOwner

        return inst
end

return Prefab("cookiespikes", fn, assets)