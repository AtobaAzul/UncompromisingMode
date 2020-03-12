local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
SetSharedLootTable( 'pillar_ruins',
{
    {'rocks',	1.00},
    {'rocks',	1.00},
    {'rocks',	1.00},
    {'rocks',	1.00},
    {'thulecite',	1.00},
    {'thulecite',	1.00},
    {'thulecite',	0.50},
    {'thulecite_pieces',	1.00},
    {'thulecite_pieces',	1.00},
    {'thulecite_pieces',	1.00},
    {'thulecite_pieces',	1.00},
    {'thulecite_pieces',	0.50},
    {'thulecite_pieces',	0.50},
})

local function GetDebrisFn()
    return "cavein_boulder", 0
end

local function setPillarDestroyed(inst)
	if inst.pillarDestroyed == true then
		inst.AnimState:SetBuild("pillar_ruins_damaged")
		RemovePhysicsColliders(inst)
	else
		inst.AnimState:SetBuild("pillar_ruins_damaged")
		RemovePhysicsColliders(inst)
	end
end

local function onhammered(inst, worker)
    inst.components.lootdropper:DropLoot(inst:GetPosition())
    local fx = SpawnPrefab("collapse_big")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("rock")
	local x, y, z = inst.Transform:GetWorldPosition()
    SpawnPrefab("cavein_debris").Transform:SetPosition(x + math.random(-1, 1), 0, z + math.random(-1, 1))
    SpawnPrefab("cavein_debris").Transform:SetPosition(x + math.random(-1, 1), 0, z + math.random(-1, 1))
    
    --[[local ents = TheSim:FindEntities(x, y, z, inst.components.aura.radius, nil, NOTAGS, { "player" })
    for i, v in ipairs(ents) do
        TryColdness(v)
    end--]]
	TheWorld:PushEvent("ms_miniquake", {
        rad = 4,
        minrad = 1.5,
        num = 10,
        duration = 3.5,
        pos = inst:GetPosition(),
        target = inst,
        debrisfn = GetDebrisFn,
    })
	SpawnPrefab("cavein_debris").Transform:SetPosition(x + math.random(-1, 1), 0, z + math.random(-1, 1))
    SpawnPrefab("cavein_debris").Transform:SetPosition(x + math.random(-1, 1), 0, z + math.random(-1, 1))
	
	inst.pillarDestroyed = true
	
	setPillarDestroyed(inst)
    --inst:Remove()
end

local function onsave(inst, data)
	data.pillarDestroyed = inst.pillarDestroyed
end

local function onload(inst, data)
    if data ~= nil and data.pillarDestroyed ~= nil then
		data.pillarDestroyed = inst.pillarDestroyed
		
		setPillarDestroyed(inst)
	end
end

env.AddPrefabPostInit("pillar_ruins", function(inst)

    inst.entity:AddDynamicShadow()
	inst.DynamicShadow:SetSize(7, 7)

	if not TheWorld.ismastersim then
		return
	end
	
	inst:AddTag("guardianbonk")

	inst:AddComponent("workable")
    --inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(20)
    inst.components.workable:SetOnFinishCallback(onhammered)
	
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetChanceLootTable('pillar_ruins')
	
	inst:ListenForEvent("resetruins", function(inst) inst.pillarDestroyed = false setPillarDestroyed(inst) end)
	
    inst.OnSave = onsave
    inst.OnLoad = onload

end)
