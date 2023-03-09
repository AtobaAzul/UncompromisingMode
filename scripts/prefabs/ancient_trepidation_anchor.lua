require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/pitcher.zip"),

    Asset("ANIM", "anim/bee_box_hermitcrab.zip"),
    Asset("MINIMAP_IMAGE", "beebox_hermitcrab"),
}

local function OnKilled(inst)
    inst.components.timer:StartTimer("regen_trep", TUNING.DRAGONFLY_RESPAWN_TIME/4)
end

local function GenerateNewTrep(inst)
    inst.components.childspawner:AddChildrenInside(1)
end

local function ontimerdone(inst, data)
    if data.name == "regen_trep" then
        GenerateNewTrep(inst)
    end
end

local function AddToList(inst)
	if TheWorld.trepspawners ~= nil then
		table.insert(TheWorld.trepspawners, inst)
	end
end

local function Initialize(inst)
	local pt = inst:GetPosition()
	if #TheSim:FindEntities(pt.x,pt.y,pt.z,0,{"trepidationspawner"}) > 1 then
		inst:Remove()
	end
	
	inst:DoTaskInTime(1, AddToList)
end

local function OnNightmarePhaseChanged(inst, phase)
	if phase == "calm" then
		inst.components.childspawner:StopSpawning()
	end
end

local function CheckIfSpawning(inst, phase)
	if inst.components.childspawner.spawning then
		SpawnPrefab("shadow_despawn").Transform:SetPosition(inst.Transform:GetWorldPosition())
	end
end

local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()

		inst:AddTag("trepidationspawner")
		inst:AddTag("NOBLOCK")

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        ---------------------  

        -------------------
		inst:AddComponent("timer")
        inst:AddComponent("childspawner")
        inst.components.childspawner.childname = "ancient_trepidation"
		
		if TUNING.DSTU.TREPIDATIONS then
			inst:WatchWorldState("nightmarephase", OnNightmarePhaseChanged)
			OnNightmarePhaseChanged(inst, TheWorld.state.nightmarephase, true)
		end
		
		inst.components.childspawner:SetMaxChildren(1)
		inst.components.childspawner:SetSpawnPeriod(1)
		--inst.components.childspawner.onchildkilledfn = OnKilled
		inst.components.childspawner:StopSpawning()
		inst.components.childspawner:StopRegen()	
		inst:DoTaskInTime(math.random(0.1,0.2),Initialize)
		
		--inst:DoPeriodicTask(1, CheckIfSpawning)
		
        return inst
end

return Prefab("ancient_trepidation_anchor", fn)