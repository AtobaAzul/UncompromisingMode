-- these should match the animation names to the workleft
local anims = {"low", "med", "full"}

local loots =
{
"spoiled_food",
"pigskin",
"rottenegg",
}

local chestloots =
{
"spoiled_food",
"pigskin",
"rottenegg",
}

local function GetChestLootTable(loottable)
	local chestloottable = {}
	for i = 1, math.random(5,8) do
		table.insert(chestloottable, loottable[math.random(#loottable)])
	end
	--print(chestloottable)
	return chestloottable
end

local function RevealChest(inst)
	local x,y,z = inst.Transform:GetWorldPosition()
	local chest = SpawnPrefab("treasurechest")
	chest.Transform:SetPosition(x,y,z)
	for i, v in ipairs(GetChestLootTable(chestloots)) do
		local pickloot = inst.components.lootdropper:SpawnLootPrefab(v)
		chest.components.container:GiveItem(pickloot, i, nil, nil, true)
	end
end

local function GetLoot(loottable)
	return loottable[math.random(#loottable)]
end

local function on_anim_over(inst)
	if inst.components.pickable ~= nil and inst.components.pickable.cycles_left ~= 0 then
		--if inst.keyloot == false then
			inst.AnimState:PushAnimation(anims[inst.components.pickable.cycles_left])
		--end
	end
end

local function on_anim_over_now(inst)
--print(inst.components.pickable.cycles_left)
	if inst.components.pickable ~= nil and inst.components.pickable.cycles_left ~= 0 then
		--if inst.keyloot == false then
			inst.AnimState:PlayAnimation(anims[inst.components.pickable.cycles_left])
		--end
	end
end

local function TryLoot(inst,picker)
	local loot = GetLoot(loots)
	local pickloot = inst.components.lootdropper:SpawnLootPrefab(loot)
	picker:PushEvent("picksomething", { object = inst, loot = pickloot })
	picker.components.inventory:GiveItem(pickloot, nil, inst:GetPosition())
	on_anim_over_now(inst)
end

local function onsave(inst, data)
	data.cycles_left = inst.components.pickable.cycles_left
	data.keyloot = inst.keyloot
end

local function onload(inst, data)
	if data then
		if data.cycles_left then
		inst.components.pickable.cycles_left = data.cycles_left
		end
		if data.keyloot then
		inst.keyloot = data.keyloot
		end
	end
end

local function TrySanityLoss(picker)
	if picker.components.sanity ~= nil then
		picker.components.sanity:DoDelta(-1)
	end
end

local function onpickedfn(inst, picker)
	TrySanityLoss(picker)
	TryLoot(inst,picker)
	if inst.components.pickable.cycles_left > 0 then
		if inst.Transform:GetWorldPosition() ~= nil then
			SpawnPrefab("splash_snow_fx").Transform:SetPosition(inst.Transform:GetWorldPosition())
		end
	else
		if inst.Transform:GetWorldPosition() ~= nil then
			SpawnPrefab("splash_snow_fx").Transform:SetPosition(inst.Transform:GetWorldPosition())
		end
		if math.random() > 0.75 then
			RevealChest(inst)
		end
		inst:Remove()
	end
end

local function makefullfn(inst)
    if inst.components.pickable.cycles_left <= 0 then
        inst.components.workable:SetWorkLeft(1)
    end
end

local function makebarrenfn(inst)
    inst:Remove()
end

local function InitializeKeyloot(inst)
	if inst.keyloot == nil then
		inst.keyloot = false
	end
end	

local function junkpilefn(Sim)
	local inst = CreateEntity()
	inst.OnSave = onsave
	inst.OnLoad = onload
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	local sound = inst.entity:AddSoundEmitter()
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

	anim:SetBuild("snow_dune")
	anim:SetBank("snow_dune")
	anim:PlayAnimation("full")
	
	inst.entity:SetPristine()
	
	MakeObstaclePhysics(inst, 2.5, 0)
	
	inst.Transform:SetScale(1.5, 1.5, 1.5)
	
	inst:AddTag("ratjunk")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
    RemovePhysicsColliders(inst)
	

	--inst:AddComponent("unevenground")
    --inst.components.unevenground.radius = 2
	
	----------------------
	inst:AddComponent("inspectable")
	----------------------

	--full, med, low
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("pickable")
    inst.components.pickable.picksound = "dontstarve/wilson/harvest_berries"

    inst.components.pickable.onpickedfn = onpickedfn
    inst.components.pickable.makebarrenfn = makebarrenfn
    inst.components.pickable.makefullfn = makefullfn
    inst.components.pickable.max_cycles = 3
    inst.components.pickable.cycles_left = 3
    inst.components.pickable.transplanted = true
	inst.components.pickable:SetUp(nil,0)
	
	inst:ListenForEvent("animover", on_anim_over)
	
	inst:DoTaskInTime(0, InitializeKeyloot)
	return inst
end

return Prefab( "ratacombs_junkpile", junkpilefn)
