local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
--[[local function CheckForSummerSpawn(inst)
    local anim = inst.AnimState

	if TheWorld.state.issummer then
        anim:PlayAnimation("idleno")
	else
        anim:PlayAnimation("idle")
	end
	
    local x, y, z = inst.Transform:GetWorldPosition()
	if #TheSim:FindEntities(x, y, z, 2, nil, nil, { "summercamp" }) < 1 then
		SpawnPrefab("walrus_camp_summer").Transform:SetPosition(x, y, z)
	end
end

local function seasonalalpha(inst)
    local anim = inst.AnimState

	if TheWorld.state.issummer then
        anim:PlayAnimation("idleno")
	else
        anim:PlayAnimation("idle")
	end
end
]]
local function RemoveSelf(inst)
local x,y,z = inst.Transform:GetWorldPosition()
if #TheSim:FindEntities(x,y,z,3,{"wal_camp_pos"}) == 0 then
local camp = SpawnPrefab("walrus_camp_empty")
camp.Transform:SetPosition(x,y,z)
end
inst:Remove()
end
local function OnIsSpring(inst)
inst:AddComponent("playerprox")

inst.components.playerprox:SetDist(15, 20)
inst.components.playerprox:SetOnPlayerNear(RemoveSelf)
end
env.AddPrefabPostInit("walrus_camp", function (inst)
    if not TheWorld.ismastersim then
		return
	end
	
	--[[inst:DoTaskInTime(0, function(inst) CheckForSummerSpawn(inst) end)
	
    inst:WatchWorldState("issummer", seasonalalpha)]]
	inst:WatchWorldState("isspring", OnIsSpring)
end)
