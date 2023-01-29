--for emptying the area around.
local function ClearSeastacks(inst)
	local x,y,z = inst.Transform:GetWorldPosition()
	local things = TheSim:FindEntities(x,y,z, 80, nil, {"sirenpoint", "umss_utw_inactivebiome", "umss_utw_activebiome"}, {"seastack"})
	for k, v in ipairs(things) do
		v:Remove()
	end
end

--for when an active biome spawns
local function ClearInactiveBiome(inst)
	local x,y,z = inst.Transform:GetWorldPosition()
	local inactive_biome = TheSim:FindEntities(x,y,z, 80, {"umss_utw_inactivebiome"})
	for k, v in ipairs(inactive_biome) do
		v:Remove()
	end
end

--for clearing an active biome
local function ClearActiveBiome(inst)
	local x,y,z = inst.Transform:GetWorldPosition()
	local inactive_biome = TheSim:FindEntities(x,y,z, 80, {"umss_utw_activebiome"})
	for k, v in ipairs(inactive_biome) do
		v:Remove()
	end
end

local function SpawnSiren(inst)
	ClearInactiveBiome(inst)--for replacing
	ClearActiveBiome(inst)
	--TheNet:Announce("spawn siren")
	local x,y,z = inst.Transform:GetWorldPosition()

	local biome = SpawnPrefab("umss_general")

	if inst.sirenpoint == "ocean_speaker" then
		biome.DefineTable(biome, "activebiome_test_rr")
		biome.Transform:SetPosition(x,y,z)
		biome:AddTag("NOCLICK")
		biome.AnimState:SetMultColour(0,0,0,0)
		biome:DoTaskInTime(1, biome.Remove)
	elseif inst.sirenpoint == "siren_bird_nest" then
		biome.DefineTable(biome, "activebiome_cbts_bb")
		biome.Transform:SetPosition(x,y,z)
		biome:AddTag("NOCLICK")
		biome.AnimState:SetMultColour(0,0,0,0)
		biome:DoTaskInTime(1, biome.Remove)
	elseif inst.sirenpoint == "siren_throne" then
		biome.DefineTable(biome, "activebiome_cbts_ss")
		biome.Transform:SetPosition(x,y,z)
		biome:AddTag("NOCLICK")
		biome.AnimState:SetMultColour(0,0,0,0)
		biome:DoTaskInTime(1, biome.Remove)	
	end
end

local function SpawnInactive(inst)
	print("spawned inactive:",inst.spawned_inactive)
	if not inst.spawned_inactive then --just for beta, while we don't nessesarily need biomes to reroll.
		ClearActiveBiome(inst)--for replacing
		ClearInactiveBiome(inst)
		--TheNet:Announce("spawn innactive")
		local biome = SpawnPrefab("umss_general")
		biome.DefineTable(biome, "inactivebiome_cbts_1")
		biome.Transform:SetPosition(inst.Transform:GetWorldPosition())
		biome:AddTag("NOCLICK")
		biome.AnimState:SetMultColour(0,0,0,0)
		biome:DoTaskInTime(1, biome.Remove)
		inst.spawned_inactive = true
	end
end

local function OnSave(inst, data)
	if data ~= nil then
		data.spawned_siren = inst.spawned_siren
		data.spawned_inactive = inst.spawned_inactive
	end
end

local function OnLoad(inst, data)
	if data ~= nil then
		if data.spawned_siren ~= nil then
			inst.spawned_siren = data.spawned_siren
		end
		if data.spawned_inactive ~= nil then
			inst.spawned_inactive = data.spawned_inactive
		end
	end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()

	inst:AddTag("areahandler")
	inst:AddTag("CLASSIFIED")
	inst:AddTag("ignorewalkableplatforms")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst.OnSave = OnSave
	inst.OnLoad = OnLoad

	inst.sirenpoint = nil

	inst:ListenForEvent("generate_inactive", SpawnInactive)
	inst:ListenForEvent("generate_main", SpawnSiren)
	--inst:ListenForEvent("clear", Clear)

	--inst:DoTaskInTime(0,ClearSeastacks)
	inst:DoTaskInTime(1,function(inst)
		if TheWorld.components.um_areahandler ~= nil and not table.contains(TheWorld.components.um_areahandler.handlers, inst) then
			table.insert(TheWorld.components.um_areahandler.handlers, inst)
		end
	end)
    return inst
end

return Prefab("um_areahandler", fn)
