local assets =
{
	Asset("ANIM", "anim/diviningrod_maxwell.zip"),
}

local function OnUnlock(inst)
	inst.AnimState:PlayAnimation("activate_loop", true)
	inst.components.trader:Disable()
	if TheWorld.components.ratacombs_junk_manager ~= nil then
		TheWorld.components.ratacombs_junk_manager:UnLockFirstArea()
	end
end

local function OnLock(inst)
    inst.AnimState:PlayAnimation("idle_empty")
	inst.components.trader:Enable()
end

local function OnSave(inst,data)
	data.unlocked = inst.unlocked
end

local function OnLoad(inst,data)
	if data ~= nil and data.unlocked ~= nil then
		if data.unlocked then
			inst.unlocked = true
			inst:DoTaskInTime(1,OnUnlock)	
		else
			inst.unlocked = false
			OnLock(inst)
		end
	else
		inst.unlocked = false
		OnLock(inst)
	end
end

local function ShouldAcceptItem(inst, item)
	if item:HasTag("ratacombskey") then
        return true
	else
		return false
    end
end

local function OnGetItemFromPlayer(inst,giver,item)
	inst.unlocked = true
	OnUnlock(inst)
end

local function fn()
	local inst = CreateEntity()
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()
    MakeInventoryPhysics(inst)
    
    inst.AnimState:SetBank("diviningrod")
    inst.AnimState:SetBuild("diviningrod_maxwell")
    inst.AnimState:PlayAnimation("idle_empty")
  
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	
    inst:AddComponent("inspectable")

    inst:AddTag("ratacombslock")

    inst:AddComponent("lock")
    inst.components.lock.locktype = "ratacombs1"
    inst.components.lock:SetOnUnlockedFn(OnUnlock)
    inst.components.lock:SetOnLockedFn(OnLock)
	
	inst:AddTag("trader")
    inst:AddComponent("trader")
    inst.components.trader:SetAcceptTest(ShouldAcceptItem)
    inst.components.trader.onaccept = OnGetItemFromPlayer
	
    --inst.components.trader.onrefuse = OnRefuseItem
	inst.components.trader.deleteitemonaccept = true
	
	inst.OnLoad = OnLoad
	inst.OnSave = OnSave
    return inst
end

return Prefab( "ratacombslock", fn,assets) 
