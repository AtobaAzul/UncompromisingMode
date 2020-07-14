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
--[[
local function OnBirdStarve(inst, bird)
    if inst.AnimationTask then
        inst.AnimationTask:Cancel()
        inst.AnimationTask = nil
    end
    inst.CAGE_STATE = "_death"

    inst.AnimState:PlayAnimation("death")
    inst.AnimState:PushAnimation("idle"..inst.CAGE_STATE, false)
    --PushStateAnim(inst, "idle", false)

    --Put loot on "shelf"
    local loot = SpawnPrefab("smallmeat")
    inst.components.inventory:GiveItem(loot)
    inst.components.shelf:PutItemOnShelf(loot)

    --remove sleep tests, it's already dead
    inst.components.sleeper:SetSleepTest(nil)
    inst.components.sleeper:SetWakeTest(nil)
end--]]

local function PushStateAnim(inst, anim, loop)
    inst.AnimState:PushAnimation(anim..inst.CAGE_STATE, loop)
end

local function GetBird(inst)
    return (inst.components.occupiable and inst.components.occupiable:GetOccupant()) or nil
end

local function GetHunger(bird)
    return (bird and bird.components.perishable and bird.components.perishable:GetPercent()) or 1
end

local function DigestFood(inst, food)
    if food.components.edible.foodtype == FOODTYPE.MEAT then
        if food.prefab == "bird_egg_cooked" then
			local loot = inst.components.lootdropper:SpawnLootPrefab("guano")
            loot.Transform:SetScale(.33, .33, .33)
        else
            inst.components.lootdropper:SpawnLootPrefab("bird_egg")
        end
    else
        local seed_name = string.lower(food.prefab .. "_seeds")
        if Prefabs[seed_name] ~= nil then
            local num_seeds = math.random(2)
            for k = 1, num_seeds do
                inst.components.lootdropper:SpawnLootPrefab(seed_name)
            end
            if math.random() < 0.5 then
                inst.components.lootdropper:SpawnLootPrefab("seeds")
            end
        else
            if math.random() < 0.33 then
                local loot = inst.components.lootdropper:SpawnLootPrefab("guano")
                loot.Transform:SetScale(.33, .33, .33)
            end
        end
    end
	local bird = GetBird(inst)
    if bird and bird:IsValid() and bird.components.perishable then
        bird.components.perishable:SetPercent(1)
    end
end

local function OnGetItem(inst, giver, item)
	local dead = false
	local bird = GetBird(inst)
	if bird then
		if item.components.edible.foodtype == FOODTYPE.MEAT then
				if  item.components.edible:GetHealth(inst) < 0 then --monster meat is currently the only negative health meat item
					if bird.monsterbelly ~= nil and bird.monsterbelly ~= 0 then 
						bird.monsterbelly = bird.monsterbelly + 1
						if item.components.edible:GetSanity(inst) > -7 then --test to see if an item is actually monsterjerky
						bird.monsterbelly = bird.monsterbelly - 0.51 --
						end
					else
						bird.monsterbelly = 1
					end
				else
					if bird.monsterbelly ~= nil and bird.monsterbelly > 0 then
						--If bird is fed meat, she reduces her monsterbelly
						bird.monsterbelly = bird.monsterbelly - 1
					end
				end

				if bird.monsterbelly ~= nil and bird.monsterbelly >= 4 then
					-- After 4 monster meat, bird dies
					inst.components.lootdropper:SpawnLootPrefab("bird_egg")
					OnBirdStarve(inst, bird)
					dead = true
				end
			end 
	end
    if inst.components.sleeper and inst.components.sleeper:IsAsleep() then
        inst.components.sleeper:WakeUp()
    end

    if item.components.edible ~= nil and dead == false and
        (   item.components.edible.foodtype == FOODTYPE.MEAT
            or item.prefab == "seeds"
            or Prefabs[string.lower(item.prefab .. "_seeds")] ~= nil
        ) then
        inst.AnimState:PlayAnimation("peck")
        inst.AnimState:PushAnimation("peck")
        inst.AnimState:PushAnimation("peck")
        inst.AnimState:PushAnimation("hop")
        PushStateAnim(inst, "idle", true)
        inst:DoTaskInTime(60 * FRAMES, DigestFood, item)
    end
end

local function GetStatus(inst)
    if inst.CAGE_STATE == CAGE_STATES.EMPTY then
        return "GENERIC"
    elseif inst.CAGE_STATE == CAGE_STATES.FULL then
        local bird = GetBird(inst)
        local hunger = GetHunger(bird)
        if inst.components.sleeper and inst.components.sleeper:IsAsleep() then
            return "SLEEPING"
        elseif hunger < 0.33 then
            return "STARVING"
        elseif hunger < 0.66 then
            return "HUNGRY"
        else
            return "OCCUPIED"
        end

    elseif inst.CAGE_STATE == CAGE_STATES.DEAD or inst.CAGE_STATE == CAGE_STATES.SICK then
        return "DEAD"
    elseif inst.CAGE_STATE == CAGE_STATES.SKELETON then
        return "SKELETON"
    end
end

local function OnOccupied(inst, bird)
    SetCageState(inst, CAGE_STATES.FULL)
	
    --Add the sleeper component & initialize
    inst:AddComponent("sleeper")
    inst.components.sleeper:SetSleepTest(ShouldSleep)
    inst.components.sleeper:SetWakeTest(ShouldWake)

    --Enable the trader component
    inst.components.trader:Enable()

    --Set up the bird symbol, play an animation.
    SetBirdType(inst, bird.prefab)

    inst.chirpsound = bird.sounds and bird.sounds.chirp
    inst.AnimState:PlayAnimation("flap")
    inst.SoundEmitter:PlaySound("dontstarve/birds/wingflap_cage")
    PushStateAnim(inst, "idle", true)
	if bird.monsterbelly ~= nil and bird.monsterbelly >= 4 then
	OnBirdStarve(inst, bird)
	end
    --Start the idling task
    StartAnimationTask(inst)
end

local function TryToRepairBelly(inst)
local bird = GetBird(inst)
if bird ~= nil and bird.monsterbelly ~= nil and bird.monsterbelly > 0 then
bird.monsterbelly = bird.monsterbelly-0.5
end
end

function ThankYouToshInit(inst)
	if inst and inst.components.trader then
	inst.components.trader.onaccept = OnGetItem
	end
	if inst then
	inst:WatchWorldState("isday", function() inst:DoTaskInTime(5, TryToRepairBelly) end)
	end
	if inst and inst.components.inspectable then
    inst.components.inspectable.getstatus = GetStatus
	end
end

env.AddPrefabPostInit("birdcage", ThankYouToshInit)