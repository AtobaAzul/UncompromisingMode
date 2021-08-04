-- these should match the animation names to the workleft
local anims = {"idle_low", "idle_med", "idle_full"}

local loots = 
{
spoiled_food = 1,
rottenegg = 1,
spoiled_fish_small = 1,
spoiled_fish = 1,

pigskin = 0.5,
boneshard = 0.5,
rope = 0.5,
papyrus = 0.5,
}

local chestloots =
{
pigskin = 1,

feather_crow = 0.75,
feather_robin = 0.75,
feather_robin_winter = 0.75,
feather_canary = 0.75,
goose_feather = 0.75,

spoiled_food = 0.5,
rottenegg = 0.5,
umbrella = 0.5,

gears = 0.25,
}

local function GetChestLootTable(loottable)
	local chestloottable = {}
	for i = 1, math.random(5,8) do
		table.insert(chestloottable, weighted_random_choice(chestloots))
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
			inst.AnimState:PushAnimation(anims[inst.components.pickable.cycles_left])
		--end
	end
end

local function TryLoot(inst,picker)
	local loot = weighted_random_choice(loots)
	local pickloot = inst.components.lootdropper:SpawnLootPrefab(loot)
	picker:PushEvent("picksomething", { object = inst, loot = pickloot })
	picker.components.inventory:GiveItem(pickloot, nil, inst:GetPosition())
	on_anim_over_now(inst)
end

local function BecomeSpawner(inst)
print("becamespawner")
    inst:AddComponent("childspawner")
    inst.components.childspawner.childname = "uncompromsing_junkrat"
    inst.components.childspawner:SetRareChild("uncompromsing_junkrat", TUNING.SLURTLEHOLE_RARECHILD_CHANCE)
    inst.components.childspawner:SetMaxChildren(1)
    inst.components.childspawner:SetSpawnPeriod(10)
	inst.components.childspawner:SetRegenPeriod(48)
	inst.components.childspawner.childreninside = 1
	inst.components.childspawner:StartRegen()
	inst.components.childspawner:StartSpawning()
	inst.components.childspawner:SpawnChild()
	
end

local function onsave(inst, data)
	data.cycles_left = inst.components.pickable.cycles_left
	data.keyloot = inst.keyloot
	if inst.inhabited ~= nil then
		data.inhabited = inst.inhabited
	end
end

local function onload(inst, data)
	if data then
		if data.cycles_left then
			inst.components.pickable.cycles_left = data.cycles_left
		end
		if data.keyloot then
			inst.keyloot = data.keyloot
		end
		if data.inhabited then
			inst.inhabited = data.inhabited
			BecomeSpawner(inst)
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
	else
		if math.random() > 0.75 then
			RevealChest(inst)
		end
		inst:Remove()
	end
	if inst.components.pickable.cycles_left == 2 then
		inst.AnimState:PlayAnimation("dig_full")
	end
	if inst.components.pickable.cycles_left == 1 then
		inst.AnimState:PlayAnimation("dig_med")
	end
	if inst.components.pickable.cycles_left == 0 then
		inst.AnimState:PlayAnimation("dig_low")
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

local function Shake(inst)
	if inst.components.pickable.cycles_left == 3 then
		inst.AnimState:PlayAnimation("twitch_full")
	end
	if inst.components.pickable.cycles_left == 2 then
		inst.AnimState:PlayAnimation("twitch_med")
	end
	if inst.components.pickable.cycles_left == 1 then
		inst.AnimState:PlayAnimation("twitch_low")
	end
end

local function junkpilefn()
	local inst = CreateEntity()
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

	inst.AnimState:SetBuild("garbage_pile")
	inst.AnimState:SetBank("garbage_pile")
	inst.AnimState:PlayAnimation("idle_full")
	
	inst.entity:SetPristine()
	
	MakeObstaclePhysics(inst, 2.5, 0)
	
	
	inst:AddTag("ratjunk")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
    RemovePhysicsColliders(inst)

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
	----------------------
	inst:AddComponent("areaaware")
	----------------------
	inst.Shake = Shake
	
	inst.OnSave = onsave
	inst.OnLoad = onload
	
	inst.BecomeSpawner = BecomeSpawner
	
	return inst
end

return Prefab("ratacombs_junkpile", junkpilefn)