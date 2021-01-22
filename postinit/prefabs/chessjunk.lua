local env = env
GLOBAL.setfenv(1, GLOBAL)
local function OnHammeredBight(inst, worker)
    inst.components.lootdropper:DropLoot()
    if math.random() <= .1 then --Grabbing the old version won't do, we're outright replacing what happens if math.random() <= 0.1
        local pos = inst:GetPosition()
        TheWorld:PushEvent("ms_sendlightningstrike", pos)
		--SpawnAmalgam
		local amalgam = SpawnPrefab("bight")
		amalgam.Transform:SetPosition(pos.x,pos.y,pos.z)
		if amalgam.components.combat ~= nil and not worker:HasTag("chess") then
		amalgam.components.combat:SuggestTarget(worker)
		end
		inst:Remove()		
		--
    else
        local fx = SpawnPrefab("collapse_small")
        fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
        fx:SetMaterial("metal")
    end
    inst:Remove()
end
local function OnHammeredKnook(inst, worker)
    inst.components.lootdropper:DropLoot()
    if math.random() <= .1 then --Grabbing the old version won't do, we're outright replacing what happens if math.random() <= 0.1
        local pos = inst:GetPosition()
        TheWorld:PushEvent("ms_sendlightningstrike", pos)
		--SpawnAmalgam
		local amalgam = SpawnPrefab("knook")
		amalgam.Transform:SetPosition(pos.x,pos.y,pos.z)
		if amalgam.components.combat ~= nil and not worker:HasTag("chess") then
		amalgam.components.combat:SuggestTarget(worker)
		end
		inst:Remove()		
		--
    else
        local fx = SpawnPrefab("collapse_small")
        fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
        fx:SetMaterial("metal")
    end
    inst:Remove()
end
local function OnHammeredRoship(inst, worker)
    inst.components.lootdropper:DropLoot()
    if math.random() <= .1 then --Grabbing the old version won't do, we're outright replacing what happens if math.random() <= 0.1
        local pos = inst:GetPosition()
        TheWorld:PushEvent("ms_sendlightningstrike", pos)
		--SpawnAmalgam
		local amalgam = SpawnPrefab("roship")
		amalgam.Transform:SetPosition(pos.x,pos.y,pos.z)
		if amalgam.components.combat ~= nil and not worker:HasTag("chess") then
		amalgam.components.combat:SuggestTarget(worker)
		end
		inst:Remove()		
		--
    else
        local fx = SpawnPrefab("collapse_small")
        fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
        fx:SetMaterial("metal")
    end
    inst:Remove()
end
env.AddPrefabPostInit("chessjunk1", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	

    inst.components.workable:SetOnFinishCallback(OnHammeredBight)
end)
env.AddPrefabPostInit("chessjunk2", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	

    inst.components.workable:SetOnFinishCallback(OnHammeredKnook)
end)

env.AddPrefabPostInit("chessjunk3", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	

    inst.components.workable:SetOnFinishCallback(OnHammeredRoship)
end)