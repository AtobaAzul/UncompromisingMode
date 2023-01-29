local function onregenfn(inst)
    inst.AnimState:PlayAnimation("grow")
    inst.AnimState:PushAnimation("idle", true)
end

local function makeemptyfn(inst)

        inst.AnimState:PlayAnimation("picked")
		inst.AnimState:PushAnimation("empty")
end

local function makebarrenfn(inst, wasempty)
    if not POPULATING and
        (   inst.components.witherable ~= nil and
            inst.components.witherable:IsWithered()
        ) then
        inst.AnimState:PlayAnimation(wasempty and "empty" or "empty")
        inst.AnimState:PushAnimation("empty", false)
    else
        inst.AnimState:PlayAnimation("empty")
    end
end

local function onpickedfn(inst, picker)
    inst.SoundEmitter:PlaySound("dontstarve/wilson/pickup_reeds")
    inst.AnimState:PlayAnimation("picked")
	if picker.components.inventory ~= nil then
	if math.random() < 0.2 then
		if math.random() < 0.5 then
		picker.components.inventory:GiveItem(SpawnPrefab("cutgrass"), nil, inst:GetPosition())
		else
		picker.components.inventory:GiveItem(SpawnPrefab("twigs"), nil, inst:GetPosition())
		end
	end
	end
    inst.AnimState:PushAnimation("empty", false)
 
end
local function dig_up(inst, worker)
	inst.components.lootdropper:SpawnLootPrefab("greenfoliage")
	
	if math.random() > 0.5 then
		inst.components.lootdropper:SpawnLootPrefab("cutgrass")
	else
		inst.components.lootdropper:SpawnLootPrefab("twigs")
	end
	
    inst:Remove()
end
local function onnear(inst)
	if inst.components.pickable ~= nil and inst.recentlypassed ~= nil then
		if inst.recentlypassed == false and not inst.components.pickable:IsBarren() and not TheWorld.state.iswinter then
			if math.random() > 0.95 then
			local aphid = SpawnPrefab("aphid")
			aphid:AddTag("fromthebush")
			aphid.Transform:SetPosition(inst.Transform:GetWorldPosition())
			end
			inst.recentlypassed = true
			inst.components.timer:StartTimer("passedby", 3000)
		end
	end
end
local function onothertimerdone(inst, data)
	if data.name == "passedby" then
	inst.recentlypassed = false
	end
end
local function grass(name, stage)
    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()


        inst.AnimState:SetBank("largefern")
        inst.AnimState:SetBuild("largefern")
        inst.AnimState:PlayAnimation("idle", true)

        inst:AddTag("plant")
        inst:AddTag("renewable")
		inst:AddTag("walrus_trap_spot")
        --witherable (from witherable component) added to pristine state for optimization

		--MakeObstaclePhysics(inst, 2, 0)
		--inst.Transform:SetScale(2,1.5,2)
        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end
		--RemovePhysicsColliders(inst)
        inst.AnimState:SetTime(math.random() * 2)
        local color = 0.75 + math.random() * 0.25
        inst.AnimState:SetMultColour(color, color, color, 1)

        inst:AddComponent("pickable")
        inst.components.pickable.picksound = "dontstarve/wilson/pickup_reeds"

        inst.components.pickable:SetUp("greenfoliage", TUNING.GRASS_REGROW_TIME,2)
        inst.components.pickable.onregenfn = onregenfn
        inst.components.pickable.onpickedfn = onpickedfn
        inst.components.pickable.makeemptyfn = makeemptyfn
        inst.components.pickable.makebarrenfn = makebarrenfn
        inst.components.pickable.max_cycles = 20
        inst.components.pickable.cycles_left = 20
		
		inst:AddComponent("lootdropper")

		inst:AddComponent("timer")
		inst:ListenForEvent("timerdone", onothertimerdone)
        if stage == 1 then
            inst.components.pickable:MakeBarren()
        end

        inst:AddComponent("inspectable")
		inst:AddComponent("workable")
		inst.components.workable:SetWorkAction(ACTIONS.DIG)
		inst.components.workable:SetOnFinishCallback(dig_up)
		inst.components.workable:SetWorkLeft(1)
		
        ---------------------
		inst:AddComponent("playerprox")
		inst.components.playerprox:SetDist(6, 8) --set specific values
		inst.components.playerprox:SetOnPlayerNear(onnear)
		inst.components.playerprox:SetPlayerAliveMode(inst.components.playerprox.AliveModes.AliveOnly)
		
        MakeMediumBurnable(inst)
        MakeSmallPropagator(inst)
        MakeNoGrowInWinter(inst)
        MakeHauntableIgnite(inst)
		inst.recentlypassed = false
        ---------------------


        return inst
    end

    return Prefab(name, fn)
end


return grass("hooded_fern", 0),
    grass("depleted_hooded_fern", 1)
