local assets =
{
}
local function SpawnGomes(inst)
for i = 1, math.random(2,3) do
for k = 1, math.random(2,3) do
local x, y, z = inst.Transform:GetWorldPosition()
x = x + math.random(-2,2)
z = z + math.random(-2,2)
if TheWorld.Map:IsPassableAtPoint(x, 0, z) then
local gnome = SpawnPrefab("trinket_4")
gnome.Transform:SetPosition(x, y, z)
gnome:AddTag("gnome")
local despawnfx = SpawnPrefab("shadow_despawn")		
despawnfx.Transform:SetPosition(x, y, z)
end
end
end
end

local function EndEncounter(inst)
local pt = inst:GetPosition()
if inst.count == 2 then
local gnomegift = SpawnPrefab("trinket_4")
gnomegift.Transform:SetPosition(pt.x, pt.y, pt.z)
else
local gnomegift = SpawnPrefab("nightmarebeak")
gnomegift.Transform:SetPosition(pt.x, pt.y, pt.z)
end	

inst:Remove()
end

local function Reposition(inst)
local structurelist = {}
local pt = inst:GetPosition()
local structures = TheSim:FindEntities(pt.x, pt.y, pt.z, 30, {"structure"})
		for i, v in ipairs(structures) do
		table.insert(structurelist, v)
		end
local chosen = structurelist[math.random(#structures)]
if #structures > 0 then
local ptnew = chosen:GetPosition()
inst.Transform:SetPosition(ptnew.x, ptnew.y, ptnew.z)
else
local ptnew = inst:GetPosition()
if math.random() > 0.5 then
ptnew.x = ptnew.x + 8
else
ptnew.x = ptnew.x - 8
end
if math.random() > 0.5 then
ptnew.z = ptnew.z + 8
else
ptnew.z = ptnew.z - 8
end
inst.Transform:SetPosition(ptnew.x, ptnew.y, ptnew.z)
end
local pt = inst:GetPosition()
local players = TheSim:FindEntities(pt.x, pt.y, pt.z, 8, {"player"})
if #players == 0 then
SpawnGomes(inst)
else
inst:DoTaskInTime(0.1,Reposition)
end
end

local function TryFearGnome(v)		
	if v.components.sanity then
		v.components.sanity:DoDelta(-1)
	end
end

local NOTAGS = { "playerghost", "INLIMBO" }
local function DamageSanity(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, 22, nil, NOTAGS, { "_health" })
	
		for i, v in ipairs(ents) do
			TryFearGnome(v)
		end
	local chance = math.random(1,3)
	inst.SoundEmitter:PlaySound("dontstarve/sanity/creature"..chance.."/attack_grunt")
	local pt = inst:GetPosition()
	local trinkets = TheSim:FindEntities(pt.x, pt.y, pt.z, 8, {"gnome"})
	if trinkets ~= nil then
	for i, v in ipairs(trinkets) do
	if math.random() > 0.8 then
	local pt = v:GetPosition()		
	local gnome = SpawnPrefab("trinket_4")	
	gnome:AddTag("gnome")
	gnome.Transform:SetPosition(pt.x, pt.y+1, pt.z)
	v:Remove() --I used the gnomes to destroy the gnomes....
	end
	end
	end
end


local function SpecialDespawn(inst)--, is_day)
local pt = inst:GetPosition()
local trinkets = TheSim:FindEntities(pt.x, pt.y, pt.z, 30, {"gnome"})
if trinkets ~= nil then
for i, v in ipairs(trinkets) do		
local pt = v:GetPosition()		
local despawnfx = SpawnPrefab("shadow_despawn")		
despawnfx.Transform:SetPosition(pt.x, pt.y, pt.z)
v:Remove()
end
end
if inst.count >= 2 then--or is_day == true then
EndEncounter(inst)
else
inst.count = inst.count + 1
Reposition(inst)
end
end

local function fn()
    	local inst = CreateEntity()

    	inst.entity:AddTransform()
    	inst.entity:AddAnimState()
        inst.entity:AddNetwork()
		inst.entity:AddSoundEmitter()
		inst.entity:AddDynamicShadow()
        inst.entity:SetPristine()
		
        if not TheWorld.ismastersim then
            return inst
        end
		inst.count = 0
		inst:DoTaskInTime(0,SpawnGomes)
		inst:DoPeriodicTask(1,DamageSanity)
		inst:AddComponent("playerprox")
		inst.components.playerprox:SetDist(6, 8) --set specific values
		inst.components.playerprox:SetOnPlayerNear(SpecialDespawn)--(inst,false))
		inst.components.playerprox:SetPlayerAliveMode(inst.components.playerprox.AliveModes.AliveOnly)
		inst:DoTaskInTime(40, function(inst)
		inst.count = 3
		SpecialDespawn(inst)
		end)--(inst,true)) --WatchWorldState wasn't playing nice
        return inst
end

return Prefab("gnome_organizer", fn, assets)