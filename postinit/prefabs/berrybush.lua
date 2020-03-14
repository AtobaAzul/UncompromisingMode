local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
local function SpawnDiseasePuff(inst)
    SpawnPrefab("disease_puff").Transform:SetPosition(inst.Transform:GetWorldPosition())
end

local function dig_up_common(inst, worker, numberries)
    if inst.components.pickable ~= nil and inst.components.lootdropper ~= nil then
        local withered = inst.components.witherable ~= nil and inst.components.witherable:IsWithered()
        local diseased = inst.components.diseaseable ~= nil and inst.components.diseaseable:IsDiseased()

        if diseased then
            SpawnDiseasePuff(inst)
        elseif inst.components.diseaseable ~= nil and inst.components.diseaseable:IsBecomingDiseased() then
            SpawnDiseasePuff(inst)
            if worker ~= nil then
                worker:PushEvent("digdiseasing")
            end
        end

        if withered or inst.components.pickable:IsBarren() then
            inst.components.lootdropper:SpawnLootPrefab("twigs")
            inst.components.lootdropper:SpawnLootPrefab("twigs")
        else
            if inst.components.pickable:CanBePicked() then
                local pt = inst:GetPosition()
                pt.y = pt.y + (inst.components.pickable.dropheight or 0)
                for i = 1, numberries do
                    inst.components.lootdropper:SpawnLootPrefab(inst.components.pickable.product, pt)
                end
            end
            if diseased then
                inst.components.lootdropper:SpawnLootPrefab("twigs")
                inst.components.lootdropper:SpawnLootPrefab("twigs")
            elseif math.random() <= 0.1 then
                inst.components.lootdropper:SpawnLootPrefab("bushcrab")
			else
                inst.components.lootdropper:SpawnLootPrefab("dug_"..inst.prefab)
            end
        end
    end
    inst:Remove()
end

local function dig_up_normal(inst, worker)
    dig_up_common(inst, worker, 1)
end

env.AddPrefabPostInit("berrybush", function(inst)

	if not TheWorld.ismastersim then
		return
	end

	if inst.components.workable ~= nil then
        inst.components.workable:SetOnFinishCallback(dig_up_normal)
    end

end)