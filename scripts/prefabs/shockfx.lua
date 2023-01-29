local assets =
{
    Asset("ANIM", "anim/bramblefx.zip"),
}

--DSV uses 4 but ignores physics radius
local MAXRANGE = 3
local NO_TAGS_NO_PLAYERS = { "bramble_resistant", "INLIMBO", "notarget", "noattack", "flight", "invisible", "player" }
local NO_TAGS = { "bramble_resistant", "INLIMBO", "notarget", "noattack", "flight", "invisible", "playerghost" }

local function OnUpdateThorns(inst)
    inst.range = inst.range + .75
    local x, y, z = inst.Transform:GetWorldPosition()
	SpawnPrefab("sparks").Transform:SetPosition(x-1+math.random() * 2, y + .25 + math.random() * 2, z) --how does one make a "do 15" times in lua?
	SpawnPrefab("sparks").Transform:SetPosition(x-1+math.random() * 2, y + .25 + math.random() * 2, z)
	SpawnPrefab("sparks").Transform:SetPosition(x-1+math.random() * 2, y + .25 + math.random() * 2, z)
	SpawnPrefab("sparks").Transform:SetPosition(x-1+math.random() * 2, y + .25 + math.random() * 2, z)
	SpawnPrefab("sparks").Transform:SetPosition(x-1+math.random() * 2, y + .25 + math.random() * 2, z)
	SpawnPrefab("sparks").Transform:SetPosition(x-1+math.random() * 2, y + .25 + math.random() * 2, z)
	SpawnPrefab("sparks").Transform:SetPosition(x-1+math.random() * 2, y + .25 + math.random() * 2, z)
	SpawnPrefab("sparks").Transform:SetPosition(x-1+math.random() * 2, y + .25 + math.random() * 2, z)
	SpawnPrefab("sparks").Transform:SetPosition(x-1+math.random() * 2, y + .25 + math.random() * 2, z)
	SpawnPrefab("sparks").Transform:SetPosition(x-1+math.random() * 2, y + .25 + math.random() * 2, z)
    for i, v in ipairs(TheSim:FindEntities(x, y, z, inst.range + 3, { "_combat" }, inst.canhitplayers and NO_TAGS or NO_TAGS_NO_PLAYERS)) do
        if not inst.ignore[v] and
            v:IsValid() and
            v.entity:IsVisible() and
            v.components.combat ~= nil and
            not (v.components.inventory ~= nil and
                v.components.inventory:EquipHasTag("bramble_resistant")) then
            local range = inst.range + v:GetPhysicsRadius(0)
            if v:GetDistanceSqToPoint(x, y, z) < range * range and not v:HasTag("electricdamageimmune") then
                if inst.owner ~= nil and not inst.owner:IsValid() then
                    inst.owner = nil
                end
                if inst.owner ~= nil then
                    if inst.owner.components.combat ~= nil and inst.owner.components.combat:CanTarget(v) then
                        inst.ignore[v] = true
						if not v.components.debuffable then
						v:AddComponent("debuffable")
						end
						v.components.debuffable:AddDebuff("shockstundebuff", "shockstundebuff")
                        --v.components.combat:GetAttacked(v.components.follower ~= nil and v.components.follower:GetLeader() == inst.owner and inst or inst.owner, inst.damage)
                        --V2C: wisecracks make more sense for being pricked by picking
                        --v:PushEvent("thorns")
                    end
                elseif v.components.combat:CanBeAttacked() then
                    inst.ignore[v] = true
						if not v.components.debuffable then
						v:AddComponent("debuffable")
						end		
						v.components.debuffable:AddDebuff("shockstundebuff", "shockstundebuff")						
                    --v.components.combat:GetAttacked(inst, inst.damage)
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

local function MakeFX(name, anim, damage)
    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        inst:AddTag("FX")
        --inst:AddTag("thorny")
        --if name == "bramblefx_trap" then
        --    inst:AddTag("trapdamage")
        --end

        inst.Transform:SetFourFaced()

        inst.AnimState:SetBank("electricchargedfx")
        inst.AnimState:SetBuild("electricchargedfx")
        inst.AnimState:PlayAnimation(anim)

        inst:SetPrefabNameOverride("shockfx")

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("updatelooper")
        inst.components.updatelooper:AddOnUpdateFn(OnUpdateThorns)

        inst:ListenForEvent("animover", inst.Remove)
        inst.persists = false
        inst.damage = TUNING[damage]
        inst.range = .75
        inst.ignore = {}
        inst.canhitplayers = true
        --inst.owner = nil

        inst.SetFXOwner = SetFXOwner

        return inst
    end

    return Prefab(name, fn, assets)
end

return MakeFX("shockotherfx", "idle", "ARMORBRAMBLE_DMG"--[[TUNING.ARMORBRAMBLE_DMG]])
