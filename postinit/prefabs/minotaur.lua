local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
local function Bonk(inst)
	inst.sg:GoToState("wake")
end

local function ClearRecentlyCharged(inst, other)
    inst.recentlycharged[other] = nil
end

local function onothercollide(inst, other)
    if not other:IsValid() or inst.recentlycharged[other] then
        return
    elseif other:HasTag("smashable") and other.components.health ~= nil then
        --other.Physics:SetCollides(false)
        other.components.health:Kill()
    elseif other.components.workable ~= nil
        and other.components.workable:CanBeWorked()
        and other.components.workable.action ~= ACTIONS.NET then
        SpawnPrefab("collapse_small").Transform:SetPosition(other.Transform:GetWorldPosition())
        other.components.workable:Destroy(inst)
        if other:IsValid() and other.components.workable ~= nil and other.components.workable:CanBeWorked() then
            inst.recentlycharged[other] = true
            inst:DoTaskInTime(3, ClearRecentlyCharged, other)
        end
		
		if other:HasTag("guardianbonk") then
			inst.sg:GoToState("sleep")
			inst:DoTaskInTime(10, Bonk, inst)
		end
		
    elseif other.components.health ~= nil and not other.components.health:IsDead() then
        inst.recentlycharged[other] = true
        inst:DoTaskInTime(3, ClearRecentlyCharged, other)
        SpawnPrefab("collapse_small").Transform:SetPosition(other.Transform:GetWorldPosition())
        inst.SoundEmitter:PlaySound("dontstarve/creatures/rook/explo")
        inst.components.combat:DoAttack(other)
    end
end

local function oncollide(inst, other)
    if not (other ~= nil and other:IsValid() and inst:IsValid())
        or inst.recentlycharged[other]
        or other:HasTag("player")
        or Vector3(inst.Physics:GetVelocity()):LengthSq() < 42 then
        return
    end
    ShakeAllCameras(CAMERASHAKE.SIDE, .5, .05, .1, inst, 40)
    inst:DoTaskInTime(2 * FRAMES, onothercollide, other)
end

env.AddPrefabPostInit("minotaur", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
    inst.Physics:SetCollisionCallback(oncollide)

end)
