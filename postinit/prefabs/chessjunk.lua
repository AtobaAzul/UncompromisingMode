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
		if amalgam.components.combat ~= nil then
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