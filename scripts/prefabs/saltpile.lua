local function OnSave(inst, data)
    if inst.rotation ~= nil then data.rotation = inst.rotation end
    if inst.scalex ~= nil then data.scalex = inst.scalex end
    if inst.scalez ~= nil then data.scalez = inst.scalez end
    if inst.type ~= nil then inst.type = data.type end
end

local function OnLoad(inst, data)
    if data.rotation ~= nil then
        inst.rotation = data.rotation
        inst.Transform:SetRotation(inst.rotation)
    end
    if data.scalex ~= nil and data.scalez ~= nil then
        inst.scalex = data.scalex
        inst.scalez = data.scalez
        inst.Transform:SetScale(inst.scalex, 1, inst.scalez)
    end
    if data.type ~= nil then
        inst.type = data.type
        inst.AnimState:PlayAnimation(inst.type)
    end
end

local function OnPicked(inst) inst:Remove() end

local function OnIsRaining(inst)
	if not TheWorld.state.iswinter then
		inst:DoTaskInTime(math.random(), inst.Remove)
	end
end

local function TrySaltingFarms(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	local size = TILE_SCALE

	for i = x-size, x+size do
		for j = z-size, z+size do
			if TheWorld.Map:GetTileAtPoint(i, 0, j) == WORLD_TILES.FARMING_SOIL then
				TheWorld.components.farming_manager:AddSoilMoistureAtPoint(i, y, j, -100)
				local plants = TheSim:FindEntities(x,y,z, size, {"farm_plant"})
				if #plants > 0 then
					for k,v in ipairs(plants) do
						if v.components.farmplantstress ~= nil then
							v.components.farmplantstress:SetStressed("happiness", true, inst)
						end
						if v.components.farmplanttendable ~= nil then
							v.components.farmplanttendable:SetTendable(v.components.growable:GetCurrentStageData().tendable)
						end
					end
				end
				inst:Remove()
			end
		end
	end
end

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(3)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetBank("saltpile")
    inst.AnimState:SetBuild("saltpile")

    -- inst:AddTag("CLASSIFIED")
    inst:AddTag("snowpileblocker")
    inst:AddTag("NOBLOCK")
    inst:AddTag("NOCLICK")
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then return inst end

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_SUPERSLOW/2)

    inst.type = 1

    inst.AnimState:PlayAnimation(inst.type)
    inst.rotation = math.random(-180, 180)
    inst.scalex = 1--GetRandomWithVariance(0.9, 1.1)
    inst.scalez = 1--GetRandomWithVariance(0.9, 1.1)
    inst.Transform:SetRotation(inst.rotation)
    inst.Transform:SetScale(inst.scalex, 1, inst.scalez)

	inst:DoPeriodicTask(10, TrySaltingFarms, 0)

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    inst:WatchWorldState("israining", OnIsRaining)

    return inst
end

return Prefab("saltpile", fn)
