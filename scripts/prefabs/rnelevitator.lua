local assets =
{
    Asset("ANIM", "anim/player_ghost_withhat.zip"),
    Asset("ANIM", "anim/ghost_build.zip"),
    Asset("SOUND", "sound/ghost.fsb"),
}

local prefabs =
{
}

local function OnIsDay(v, isday)
	if isday then
	v.components.inventoryitem.canbepickedup = true
	if v.Physics then
    v.Physics:ClearMotorVelOverride()
	end
	end
end

local function Perterbate(v)
v.Physics:SetMotorVel(0, 1+math.random(-0.5,0.5), 0)
if TheWorld.state.isnight then
v:DoTaskInTime(0.5,Perterbate(v))
end
end
local function Levitato(v)
if v.Physics ~= nil then
v.Physics:SetMotorVel(0, 4, 0)
v:DoTaskInTime(15+math.random(1,3), Perterbate(v))
end
end
local function DoLevipotato(inst)
local m,n,o = inst.Transform:GetWorldPosition()
for n = 1, math.random(3,6) do
local item = FindEntity(inst, 5, function(item) return item.components.inventoryitem ~= nil end)
Levitato(item)
item.components.inventoryitem.canbepickedup = false
item:WatchWorldState("isday", OnIsDay)	
end
end
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.SoundEmitter:PlaySound("dontstarve/ghost/ghost_howl_LP", "howl")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	DoLevipotato(inst)
	--inst:Remove()
    return inst
end

return Prefab("rnelevitator", fn, assets, prefabs)
