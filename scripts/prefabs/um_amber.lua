require "prefabutil" -- for the MakePlacer function

local assets =
{
    Asset("ANIM", "anim/um_amber.zip"),
    Asset("INV_IMAGE", "um_amber"),
}

local amberloot = { --Temp?????
	log = 0.2,
	boneshard = 0.3,
	fossil_piece = 0.01,
	mosquito = 0.01,
	petal = 0.2,
	houndstooth = 0.09,
	stinger = 0.09,
	rock = 0.1,
}

local function on_mine(inst, miner, workleft, workdone)
    local num_fruits_worked = math.clamp(math.ceil(workdone / TUNING.ROCK_FRUIT_MINES), 1, TUNING.ROCK_FRUIT_LOOT.MAX_SPAWNS)
    num_fruits_worked = math.min(num_fruits_worked, inst.components.stackable:StackSize())

    if inst.components.stackable:StackSize() > num_fruits_worked then
        inst.AnimState:PlayAnimation("mined")
        inst.AnimState:PushAnimation("idle", false)

        if num_fruits_worked == TUNING.ROCK_FRUIT_LOOT.MAX_SPAWNS then
            -- If we got hit hard, also launch the remaining fruit stack.
            LaunchAt(inst, inst, miner, TUNING.ROCK_FRUIT_LOOT.SPEED, TUNING.ROCK_FRUIT_LOOT.HEIGHT, nil, TUNING.ROCK_FRUIT_LOOT.ANGLE)
        end
    end

    for _ = 1, num_fruits_worked do
		for i = 1,math.random(1,3) do 
			local loot = SpawnPrefab(weighted_random_choice(amberloot))
			LaunchAt(loot, inst, miner, TUNING.ROCK_FRUIT_LOOT.SPEED, TUNING.ROCK_FRUIT_LOOT.HEIGHT, nil, TUNING.ROCK_FRUIT_LOOT.ANGLE)
		end
    end

    -- Finally, remove the actual stack items we just consumed
    local top_stack_item = inst.components.stackable:Get(num_fruits_worked)
    top_stack_item:Remove()
end

local function stack_size_changed(inst, data)
    if data ~= nil and data.stacksize ~= nil and inst.components.workable ~= nil then
        inst.components.workable:SetWorkLeft(data.stacksize * TUNING.ROCK_FRUIT_MINES)
    end
end

local function amber_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("rock_avo_fruit_master")
    inst.AnimState:SetBuild("rock_avocado_fruit_build")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("molebait")

    MakeInventoryPhysics(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem:SetSinks(true)

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("tradable")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.MINE)
    inst.components.workable:SetWorkLeft(TUNING.ROCK_FRUIT_MINES * inst.components.stackable.stacksize)
    --inst.components.workable:SetOnFinishCallback(on_mine)
    inst.components.workable:SetOnWorkCallback(on_mine)


    inst:AddComponent("bait")

    -- The amount of work needs to be updated whenever the size of the stack changes
    inst:ListenForEvent("stacksizechange", stack_size_changed)

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("um_amber", amber_fn)
