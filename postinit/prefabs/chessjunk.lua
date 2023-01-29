local env = env
GLOBAL.setfenv(1, GLOBAL)
local function SpawnBight(inst,worker)
    local pos = inst:GetPosition()
    TheWorld:PushEvent("ms_sendlightningstrike", pos)
	--SpawnAmalgam
	local amalgam = SpawnPrefab("bight")
	amalgam.Transform:SetPosition(pos.x,pos.y,pos.z)
	if amalgam.components.combat ~= nil and worker ~= nil and not worker:HasTag("chess") then
		amalgam.components.combat:SuggestTarget(worker)
	end
	inst:Remove()
end

local function OnHammeredBight(inst, worker)
    inst.components.lootdropper:DropLoot()
    if math.random() <= .1 then --Grabbing the old version won't do, we're outright replacing what happens if math.random() <= 0.1
		SpawnBight(inst,worker)		
    else
        local fx = SpawnPrefab("collapse_small")
        fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
        fx:SetMaterial("metal")
    end
    inst:Remove()
end

local function SpawnKnook(inst,worker)
    local pos = inst:GetPosition()
    TheWorld:PushEvent("ms_sendlightningstrike", pos)
	--SpawnAmalgam
	local amalgam = SpawnPrefab("knook")
	amalgam.Transform:SetPosition(pos.x,pos.y,pos.z)
	if amalgam.components.combat ~= nil and worker ~= nil and not worker:HasTag("chess") then
		amalgam.components.combat:SuggestTarget(worker)
	end
	inst:Remove()	
end

local function OnHammeredKnook(inst, worker)
    inst.components.lootdropper:DropLoot()
    if math.random() <= .1 then --Grabbing the old version won't do, we're outright replacing what happens if math.random() <= 0.1
		SpawnKnook(inst,worker)
    else
        local fx = SpawnPrefab("collapse_small")
        fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
        fx:SetMaterial("metal")
    end
    inst:Remove()
end

local function SpawnRoship(inst,worker)
    local pos = inst:GetPosition()
    TheWorld:PushEvent("ms_sendlightningstrike", pos)
	--SpawnAmalgam
	local amalgam = SpawnPrefab("roship")
	amalgam.Transform:SetPosition(pos.x,pos.y,pos.z)
	if amalgam.components.combat ~= nil and worker ~= nil and not worker:HasTag("chess") then
		amalgam.components.combat:SuggestTarget(worker)
	end
	inst:Remove()	
end

local function OnHammeredRoship(inst, worker)
    inst.components.lootdropper:DropLoot()
    if math.random() <= .1 then --Grabbing the old version won't do, we're outright replacing what happens if math.random() <= 0.1
		SpawnRoship(inst,worker)
    else
        local fx = SpawnPrefab("collapse_small")
        fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
        fx:SetMaterial("metal")
    end
    inst:Remove()
end
----------------------------------

----------------------------------
env.AddPrefabPostInit("chessjunk1", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	inst.SpawnClockwork = SpawnBight
    inst.components.workable:SetOnFinishCallback(OnHammeredBight)
end)

env.AddPrefabPostInit("chessjunk2", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	inst.SpawnClockwork = SpawnKnook
    inst.components.workable:SetOnFinishCallback(OnHammeredKnook)
end)

env.AddPrefabPostInit("chessjunk3", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	inst.SpawnClockwork = SpawnRoship
    inst.components.workable:SetOnFinishCallback(OnHammeredRoship)
end)