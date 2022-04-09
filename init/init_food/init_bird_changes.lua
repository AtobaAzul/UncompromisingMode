local env = env
GLOBAL.setfenv(1, GLOBAL)



local CAGE_STATES =
{
    DEAD = "_death",
    SKELETON = "_skeleton",
    EMPTY = "_empty",
    FULL = "_bird",
    SICK = "_sick",
}

local function SetCageState(inst, state)
    inst.CAGE_STATE = state
end

local function StopAnimationTask(inst)
    if inst.AnimationTask then
        inst.AnimationTask:Cancel()
        inst.AnimationTask = nil
    end
end

local function PushStateAnim(inst, anim, loop)
    inst.AnimState:PushAnimation(anim..inst.CAGE_STATE, loop)
end

local function OnBirdStarve(inst, bird)
	StopAnimationTask(inst)
    SetCageState(inst, CAGE_STATES.DEAD)

    inst.AnimState:PlayAnimation("death")
    PushStateAnim(inst, "idle", false)

    --Put loot on "shelf"
    local loot = SpawnPrefab("smallmeat")
    inst.components.inventory:GiveItem(loot)
    inst.components.shelf:PutItemOnShelf(loot)
    inst:RemoveComponent("sleeper")
	
    inst.components.trader:Disable()
end

local function PushStateAnim(inst, anim, loop)
    inst.AnimState:PushAnimation(anim..inst.CAGE_STATE, loop)
end

local function GetBird(inst)
    return (inst.components.occupiable and inst.components.occupiable:GetOccupant()) or nil
end

local function OnExplodeFn(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
    SpawnPrefab("explode_small").Transform:SetPosition(x, 2, z)
    SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
end

local function DigestFood(inst, food)
    if food.components.edible.foodtype == FOODTYPE.MEAT then
        --If the food is meat:
            --Spawn an egg.
        if inst.components.occupiable and inst.components.occupiable:GetOccupant() and inst.components.occupiable:GetOccupant():HasTag("bird_mutant") then
            inst.components.lootdropper:SpawnLootPrefab("rottenegg")
        else
			if food.components.edible.secondaryfoodtype ~= nil and food.components.edible.secondaryfoodtype == FOODTYPE.MONSTER and TUNING.DSTU.MONSTER_EGGS > 0 then
				inst.components.lootdropper:SpawnLootPrefab("um_monsteregg")
			else
				inst.components.lootdropper:SpawnLootPrefab("bird_egg")
			end
        end
    else
        if inst.components.occupiable and inst.components.occupiable:GetOccupant() and inst.components.occupiable:GetOccupant():HasTag("bird_mutant") then
            inst.components.lootdropper:SpawnLootPrefab("spoiled_food")

        else
            local seed_name = string.lower(food.prefab .. "_seeds")
            if Prefabs[seed_name] ~= nil then
    			inst.components.lootdropper:SpawnLootPrefab(seed_name)
            else
                --Otherwise...
                    --Spawn a poop 1/3 times.
                if math.random() < 0.33 then
                    local loot = inst.components.lootdropper:SpawnLootPrefab("guano")
                    loot.Transform:SetScale(.33, .33, .33)
                end
            end
        end
    end

    --Refill bird stomach.
    local bird = GetBird(inst)
    if bird and bird:IsValid() and bird.components.perishable then
        bird.components.perishable:SetPercent(1)
    end
end

local function Ricexplosion(inst, item)
	inst:AddComponent("explosive")
	inst.components.explosive:SetOnExplodeFn(OnExplodeFn)
	inst.components.explosive.explosiverange = 1
	inst.components.explosive.explosivedamage = 0
	inst.components.explosive:OnBurnt()
end

local function OnGetItem(inst, giver, item)
    if item.prefab == "rice" or item.prefab == "rice_cooked" then
        inst.AnimState:PlayAnimation("peck")
        inst.AnimState:PushAnimation("peck")
        inst.AnimState:PushAnimation("idle")
        inst.AnimState:PushAnimation("flap")
        inst.AnimState:PushAnimation("flap")
		
        inst:DoTaskInTime(3, Ricexplosion, item)
    end
	
    if inst.components.sleeper and inst.components.sleeper:IsAsleep() then
        inst.components.sleeper:WakeUp()
    end

     if item.components.edible ~= nil and
        (   item.components.edible.foodtype == FOODTYPE.MEAT
            or item.prefab == "seeds"
            or string.match(item.prefab, "_seeds")
            or Prefabs[string.lower(item.prefab .. "_seeds")] ~= nil
        ) then
        --If the item is edible...
        --Play some animations (peck, peck, peck, hop, idle)
        inst.AnimState:PlayAnimation("peck")
        inst.AnimState:PushAnimation("peck")
        inst.AnimState:PushAnimation("peck")
        inst.AnimState:PushAnimation("hop")
        PushStateAnim(inst, "idle", true)
        --Digest Food in 60 frames.
        inst:DoTaskInTime(60 * FRAMES, DigestFood, item)
    end
end

local invalid_foods =
{
    "bird_egg",
    "bird_egg_cooked",
    "rottenegg",
    "um_monsteregg",
    "um_monsteregg_cooked",
    -- "monstermeat",
    -- "cookedmonstermeat",
    -- "monstermeat_dried",
}

local function ShouldAcceptItem(inst, item)
    local seed_name = string.lower(item.prefab .. "_seeds")

    local can_accept = item.components.edible
        and (Prefabs[seed_name] 
        or item.prefab == "seeds"
        or string.match(item.prefab, "_seeds")
        or item.components.edible.foodtype == FOODTYPE.MEAT)
		or item.prefab == "rice" or item.prefab == "rice_cooked"
    if table.contains(invalid_foods, item.prefab) then
        can_accept = false
    end

    return can_accept
end

function ThankYouToshInit(inst)
	if inst and inst.components.trader then
    inst.components.trader:SetAcceptTest(ShouldAcceptItem)
	inst.components.trader.onaccept = OnGetItem
	end
end

env.AddPrefabPostInit("birdcage", ThankYouToshInit)
--[[env.AddPrefabPostInit("birdcage", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	local _ShouldAcceptItem = inst.components.trader.test

	inst.components.trader.test = function(inst, item)
		if _ShouldAcceptItem ~= nil then
		print("fuck")
			_ShouldAcceptItem(inst, item)
		end
		
		print(_ShouldAcceptItem)
		
		if item.prefab == "rice" or item.prefab == "rice_cooked" then  
			local can_accept = true
			return can_accept
		end
	end
end)]]
