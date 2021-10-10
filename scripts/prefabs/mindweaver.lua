require "stategraphs/SGmindweaver"

--local brain = require "brains/swilsonbrain"
local assets =
{

}
local prefabs =
{

}

local function ShootProjectile(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x, y, z, 5, {"player"})
	
	for i, v in ipairs(ents) do
		v:Hide()
		v:DoTaskInTime(5, function(inst) inst:PushEvent("death") end)
		v:DoTaskInTime(7, function(inst) inst:Show() end)
	end
end

local function fn(Sim)
	local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
    inst.entity:AddLightWatcher()

	--inst.Transform:SetFourFaced()
	inst:AddTag("monster")
    inst:AddTag("hostile")   
    inst:AddTag("swilson") 
	inst:AddTag("nightmarecreature")
	inst:AddTag("shadow")
	inst:AddTag("notraptrigger")

    inst.AnimState:SetBank("mindweaver")
    inst.AnimState:SetBuild("mindweaver")
    inst.AnimState:PlayAnimation("appear")
	inst.Transform:SetScale(1.9, 1.9, 1.9)

	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
        return inst
    end
	
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(300)
	
    inst:SetStateGraph("SGmindweaver")
    --inst:SetBrain(brain)
	
    inst.LaunchProjectile = ShootProjectile

    return inst
end

return Prefab( "mindweaver", fn, assets, prefabs)