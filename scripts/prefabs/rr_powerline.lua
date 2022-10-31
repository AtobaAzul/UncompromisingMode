local assets =
{
    Asset("ANIM", "anim/rr_powerline.zip"),
}


SetSharedLootTable( 'rr_powerline',
{
    {'log',  1.00},
    {'log',  1.00},
    {'trinket_6',  1.00},
    {'trinket_6',  1.00},
})
SetSharedLootTable( 'rr_powerline_burnt',
{
    {'charcoal',  1.00},
    {'charcoal',  1.00},
})

local function updateanim(inst)
	inst.AnimState:PlayAnimation("chop"..inst.type)
	inst.AnimState:PushAnimation("idle"..inst.type,true)
end

local function OnWork(inst, worker, workleft)
    if workleft <= 0 then
		inst:RemoveComponent("workable")
        local pt = inst:GetPosition()

        local loot_dropper = inst.components.lootdropper

        inst:SetPhysicsRadiusOverride(nil)
		if inst:HasTag("burnt") then
			inst:RemoveTag("burnt")
		end
        loot_dropper:DropLoot(pt)
		local fx = SpawnPrefab("collapse_big")
		fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
		fx:SetMaterial("wood")
		inst:Remove()
    else
        updateanim(inst)
    end
end

local DAMAGE_SCALE = 0.5
local function OnCollide(inst, data)
    local boat_physics = data.other.components.boatphysics
    if boat_physics ~= nil then
        local hit_velocity = math.floor(math.abs(boat_physics:GetVelocity() * data.hit_dot_velocity) * DAMAGE_SCALE / boat_physics.max_velocity + 0.5)
		if inst.components.workable then
			inst.components.workable:WorkedBy(data.other, hit_velocity * TUNING.SEASTACK_MINE)
		end
    end
end

local function DecideType(inst)
	if not inst.type then
		inst.type = math.random(1,3)
	end
	if not inst.flip then
		inst.flip = math.random(0,1)
	end
	if inst:HasTag("burnt") then
		inst.AnimState:PlayAnimation("burnt"..inst.type,true)
	else
		inst.AnimState:PlayAnimation("idle"..inst.type,true)
	end
	
	if inst.flip == 1 then
		inst.AnimState:SetScale(-1, 1)
	end
	inst.AnimState:SetTime(math.random() * 2)
end

local function OnBurnt(inst)
    if inst.components.burnable ~= nil then
        inst.components.burnable:Extinguish()
    end
    inst:RemoveComponent("burnable")
    MakeHauntableWork(inst)

    inst.components.lootdropper:SetChanceLootTable('rr_powerline_burnt')

    if inst.components.workable then
        inst.components.workable:SetWorkLeft(1)
    end

    inst.AnimState:PlayAnimation("burnt"..inst.type,true)
    inst:AddTag("burnt")
end

local function onsave(inst, data)
    data.type = inst.type
	data.flip = inst.flip
	if inst:HasTag("burnt") then
		data.burnt = true
	end
end

local function onload(inst, data)
	if data then
		if data.burnt then
			OnBurnt(inst)
		end
		if data.type then
			inst.type = data.type
		end
		if data.flip then
			if data.flip == 1 then
				inst.AnimState:SetScale(-1, 1)
			end
			inst.flip = data.flip
		end
	end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst.MiniMapEntity:SetIcon("seastack.png")

    inst:SetPhysicsRadiusOverride(2.35)

    MakeWaterObstaclePhysics(inst, 0.80, 2, 0.75)

    inst:AddTag("ignorewalkableplatforms")
    inst:AddTag("seastack")

    inst.AnimState:SetBank("rr_powerline")
    inst.AnimState:SetBuild("rr_powerline")

    inst.Transform:SetScale(2, 1.5, 1.5)--wide boy

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable('rr_powerline')
    inst.components.lootdropper.max_speed = 2
    inst.components.lootdropper.min_speed = 0.3
    inst.components.lootdropper.y_speed = 14
    inst.components.lootdropper.y_speed_variance = 4

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
    inst.components.workable:SetOnWorkCallback(OnWork)
    inst.components.workable.savestate = true

    inst:AddComponent("inspectable")


    MakeHauntableWork(inst)

    MakeInventoryFloatable(inst, "small", 0.3, {0.75, 1, 0.75})
    inst.components.floater.bob_percent = 0

    local land_time = (POPULATING and math.random()*5*FRAMES) or 0
    inst:DoTaskInTime(land_time, function(inst)
        inst.components.floater:OnLandedServer()
    end)

    inst:ListenForEvent("on_collide", OnCollide)

	inst:DoTaskInTime(0,DecideType)
	
	inst:AddComponent("burnable")
    MakeLargeBurnable(inst, TUNING.TREE_BURN_TIME)
    inst.components.burnable:SetFXLevel(2)
    inst.components.burnable:SetOnBurntFn(OnBurnt)	
	
    --------SaveLoad
    inst.OnSave = onsave
    inst.OnLoad = onload

    return inst
end

return Prefab("rr_powerline", fn, assets)
