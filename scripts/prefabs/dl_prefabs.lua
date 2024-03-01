require "prefabutil"
require "json"

local io = require("io")
local output_file = TUNING.DSTU.MODROOT .. "scripts/capture_output.json"
local NO_CAPTURE_TAGS = {
	"NOCAPTURE",
	"player",
	"bird",
	"NOCLICK",
	"CLASSIFIED",
	"FX",
	"INLIMBO",
	"smalloceancreature",
	"DECOR",
}

local function CheckAndGetValidEntities(inst, reset)
	for k, v in pairs(Ents) do --iterates over all entitites to clear the highlighting on existing things.
		if v.AnimState ~= nil and v:IsValid() and v:HasTag("DL_VALID") then
			v.AnimState:SetAddColour(0, 0, 0, 0)
		end
	end

	if reset == true then
		return
	end

	inst.range = 0

	local itemsinside = inst.components.container:GetAllItems() --get all items inside

	for i, v in ipairs(itemsinside) do                       --iterate over all of them...
		if v.prefab == "log" then                            --if it's a log, increase range by 1 of each in the stack.
			inst.range = inst.range + v.components.stackable:StackSize()
		end
		if v.prefab == "boards" then --if it's a log, increase it by 4.
			inst.range = inst.range + (v.components.stackable:StackSize() * TILE_SCALE)
		end
		v:AddTag("NOCAPTURE") --add the "NOCAPTURE" tag just to be safe.
	end

	local x, y, z = inst.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x, y, z, inst.range, nil, NO_CAPTURE_TAGS) --find all entities around

	for k, v in pairs(ents) do
		if v.AnimState ~= nil and v ~= inst then
			v.AnimState:SetAddColour(0, 1, 0, 0)
			v:AddTag("DL_VALID")
		end
	end

	return ents
end


local function onopen(inst)
	if not inst:HasTag("burnt") then
		inst.AnimState:PlayAnimation("open")
		inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_open")
	end

	CheckAndGetValidEntities(inst)
end

local function onclose(inst)
	if not inst:HasTag("burnt") then
		inst.AnimState:PlayAnimation("close")
		inst.AnimState:PushAnimation("closed", false)
		inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_close")
	end

	CheckAndGetValidEntities(inst)
end

local function onhammered(inst, worker)
	inst:Remove()
end

local function onhit(inst, worker)
	inst:Remove()
end

local function onbuilt(inst)
	inst.AnimState:PlayAnimation("place")
	inst.AnimState:PushAnimation("closed", false)
	inst.SoundEmitter:PlaySound("dontstarve/common/chest_craft")
end

local function OnStopChanneling(inst)
	inst.channeler = nil
end

local function Capture(inst, channeler)
	local x, y, z = inst.Transform:GetWorldPosition()
	local ents = CheckAndGetValidEntities(inst)
	local saved_ents = {}
	local num = tostring(math.random(1000))
	local text = (inst.components.writeable.text == nil and "returnedTable" .. num) or
		string.gsub(inst.components.writeable.text, " ", "_")
	local file = io.open(output_file, "r+")
	if saved_ents[text] == nil then
		saved_ents[text] = {}
	end


	saved_ents[text].has_tiles                 = false
	saved_ents[text].spawn_in_water            = false
	saved_ents[text].only_spawn_in_water       = false
	saved_ents[text].smooth_rotate             = false
	saved_ents[text].no_rotation               = false
	saved_ents[text].use_angle_away_from_spawn = false
	saved_ents[text].angle_offset              = 0
	saved_ents[text].prevent_overlap           = true
	saved_ents[text].reversible                = false
	saved_ents[text].group                     = nil
	saved_ents[text].worldborder_buffer        = 0
	saved_ents[text].autotrigger_spawners      = true
	saved_ents[text].no_spawners_in_water      = false
	saved_ents[text].no_prefab_overlap         = false

	for k, v in ipairs(ents) do
		if v ~= inst then
			local vx, vy, vz = v.Transform:GetWorldPosition()
			local px, py, pz = vx - x, vy - y, vz - z



			local thedata = { relative_x = px, relative_y = py, relative_z = pz, v:GetSaveRecord(), options = v.layout }

			if v.prefab == "dl_tileflag" then
				thedata.tile = TheWorld.Map:GetTileAtPoint(vx, vy, vz)
				saved_ents[text].has_tiles = true
				saved_ents[text].spawn_in_water = true
			end

			table.insert(saved_ents[text], thedata)
		end
	end

	--I would explain this to you if I remembered what it did.
	if file then
		local file_str = file:read("*a")
		local data
		local file_data = {}

		if file_str == "" then
			file_data[text] = saved_ents[text]
		else
			file_data = json.decode(file_str)
		end

		file:close()
		file_data[text] = saved_ents[text]

		local str = json.encode(file_data)

		file = io.open(output_file, "w")
		--while, yes, the IDE is telling me I need to add a nil check here, there really isn't a way for the file we *just* opened to be nil, consdering we checked for that previously.
		data = file:write(str)
		file:close()
		TheNet:Announce("Successfully captured!")
		CheckAndGetValidEntities(inst, true) --reset range indication
		return data
	else
		TheNet:Announce("Failed to write: file invalid! Or something.")
	end
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	inst:AddTag("structure")
	inst:AddTag("chest")

	inst.AnimState:SetBank("chest")
	inst.AnimState:SetBuild("treasure_chest")
	inst.AnimState:PlayAnimation("closed")

	inst:AddTag("_writeable")
	inst:AddTag("capturer")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddTag("_writeable")

	inst:AddComponent("inspectable")
	inst:AddComponent("writeable")
	inst:AddComponent("lootdropper")

	inst:AddComponent("container")
	inst.components.container:WidgetSetup("dl_recorder")
	inst.components.container.onopenfn = onopen
	inst.components.container.onclosefn = onclose
	inst.components.container.skipclosesnd = true
	inst.components.container.skipopensnd = true

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetWorkLeft(2)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)

	inst:ListenForEvent("onbuilt", onbuilt)

	inst:AddComponent("channelable")
	inst.components.channelable:SetChannelingFn(Capture, OnStopChanneling)
	inst.components.channelable.use_channel_longaction_noloop = true
	inst.components.channelable.skip_state_channeling = true

	inst:DoTaskInTime(0, function(inst)
		local x, y, z = inst.Transform:GetWorldPosition()
		local tile_x, tile_y, tile_z = TheWorld.Map:GetTileCenterPoint(x, 0, z)
		inst.Transform:SetPosition(tile_x, tile_y, tile_z)
	end)

	inst:ListenForEvent("itemlose", CheckAndGetValidEntities)
	inst:ListenForEvent("itemget", CheckAndGetValidEntities)
	inst:ListenForEvent("onremoved", CheckAndGetValidEntities)

	return inst
end

local function OnDropped(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	local tile_x, tile_y, tile_z = TheWorld.Map:GetTileCenterPoint(x, 0, z)
	if tile_x ~= nil and tile_y ~= nil and tile_z ~= nil then
		inst.Transform:SetPosition(tile_x, tile_y, tile_z)
	end
end

local function TileFlag(inst)
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	inst.AnimState:SetBank("gridplacer")
	inst.AnimState:SetBuild("gridplacer")
	inst.AnimState:PlayAnimation("anim")
	inst.AnimState:SetLightOverride(1)
	inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)

	inst.AnimState:SetMultColour(math.random(5, 10) / 10, math.random(5, 10) / 10, 0, 1)

	inst:AddTag("DYNLAYOUT_FLAG")

	-- MakeInventoryPhysics(inst)

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem:SetOnDroppedFn(OnDropped)

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = 60

	inst:DoTaskInTime(0, OnDropped)
	inst.OnEntityWake = OnDropped

	return inst
end

local function SpawnLayout(inst, extradata)
	if inst.layout ~= nil then
		local layout = weighted_random_choice(inst.layout)
		if layout ~= "End" then
			inst.components.writeable.text = layout
		else
			inst:Remove()
			return
		end
	end

	if inst.components.writeable.text == "" or inst.components.writeable.text == nil then
		return
	end

	local file_path = inst.file_path_override ~= nil and inst.file_path_override or extradata ~= nil and extradata.file_path_override ~= nil and extradata.file_path_override or output_file
	local file = io.open(file_path, "r+")
	local x, y, z = inst.Transform:GetWorldPosition()

	if x == nil or y == nil or z == nil then
		--spawner probably got removed at this point.
		return
	end

	if file then
		local file_string = file:read("*a")
		file:close()
		local data = json.decode(file_string)

		if data[inst.components.writeable.text] == nil or type(data[inst.components.writeable.text]) ~= "table" then
			TheNet:Announce("Invalid data!")
			return
		end

		local has_tiles = data[inst.components.writeable.text].has_tiles
		local spawn_in_water = data[inst.components.writeable.text].spawn_in_water
		local only_spawn_in_water = data[inst.components.writeable.text].only_spawn_in_water
		local smooth_rorate = data[inst.components.writeable.text].smooth_rotate
		local no_rotation = data[inst.components.writeable.text].no_rotation
		local use_angle_away_from_spawn = data[inst.components.writeable.text].use_angle_away_from_spawn
		local angle_offset = data[inst.components.writeable.text].angle_offset
		local prevent_overlap = data[inst.components.writeable.text].prevent_overlap
		local reversible = data[inst.components.writeable.text].reversible
		local group = data[inst.components.writeable.text].group
		local worldborder_buffer = data[inst.components.writeable.text].worldborder_buffer
		local autotrigger_spawners = data[inst.components.writeable.text].autotrigger_spawners
		local no_spawners_in_water = data[inst.components.writeable.text].no_spawners_in_water
		local no_prefab_overlap = data[inst.components.writeable.text].no_prefab_overlap

		local angles, angle
		if group ~= nil and reversible then
			if TheWorld.dl_setpieces == nil then
				TheWorld.dl_setpieces = {}
			end
			if TheWorld.dl_setpieces[group] == nil then
				TheWorld.dl_setpieces[group] = {}
			end
			if TheWorld.dl_setpieces[group].tiles == nil then
				TheWorld.dl_setpieces[group].tiles = {}
			end
			if TheWorld.dl_setpieces[group].prefabs == nil then
				TheWorld.dl_setpieces[group].prefabs = {}
			end
		end

		if TheWorld.dl_tasks == nil then
			TheWorld.dl_tasks = {}
			TheWorld.dl_tasks[group] = {}
		end

		local world_size = TheWorld.Map:GetWorldSize() * 4
		local max_x = world_size / 2
		local max_z = world_size / 2

		if has_tiles then
			angles = { 0, 90, 180, 270, 360 }
		else
			angles = { 0, 45, 90, 135, 180, 215, 270, 315, 360 }
		end

		if no_rotation then
			angle = 0
		elseif smooth_rorate then
			angle = math.rad(math.random(360))
		else
			angle = math.rad(angles[math.random(#angles)])
		end


		angle = type(extradata.angle_override) == "number" and extradata.angle_override or angle

		for k, v in pairs(data[inst.components.writeable.text]) do
			if type(v) == "table" and v.relative_x ~= nil then
				local px = math.cos(angle) * (v.relative_x) - math.sin(angle) * (v.relative_z) +
					x --huge thanks to KorenWaffles for helping with math. because MAN I suck at it.
				local pz = math.sin(angle) * (v.relative_x) + math.cos(angle) * (v.relative_z) + z

				if math.abs(px) >= max_x - worldborder_buffer or math.abs(pz) >= max_z - worldborder_buffer then
					print("too close to world border!!!!!")
					break
				end

				if reversible then
					local nearbyents = TheSim:FindEntities(px, v.relative_y + y, pz, 4, nil,
						{ "noreplaceremove", "CLASSIFIED", "INLIMBO", "irreplaceable", "player", "playerghost", "character", "multiplayer_portal",
							"companion", "abigail", "pollen" })
					if group ~= nil then
						for k, v in pairs(nearbyents) do
							local data = v:GetSaveRecord()
							table.insert(TheWorld.dl_setpieces[group].prefabs, data)
							v:Remove()
						end
					end
				end

				if v.tile ~= nil then
					local tile_x, tile_z = TheWorld.Map:GetTileCoordsAtPoint(px, v.relative_y + y, pz)
					if tile_x == nil or tile_z == nil then
						TheNet:Announce("AAAAAAAAAAAAAAAAAAAAAAAAAAAA")
						break
					end

					if not spawn_in_water and TheWorld.Map:IsPassableAtPoint(px, v.relative_y + y, pz) or spawn_in_water then
						if v.tile == WORLD_TILES.MONKEY_DOCK then
							TheWorld.components.dockmanager:CreateDockAtPoint(px, v.relative_y + y, pz, WORLD_TILES.MONKEY_DOCK)
						else
							TheWorld.Map:SetTile(tile_x, tile_z, v.tile, { group = group, reversible = reversible })
						end
					end
				else
					local ent = SpawnSaveRecord(v["1"])
					if ent == nil then
						return
					end

					ent.group = group
					ent.Transform:SetPosition(px, v.relative_y + y, pz)

					ent:AddTag("noreplaceremove")
					if reversible then
						ent.group = group
					end
					if ent.prefab == "dl_spawner" then
						if no_spawners_in_water and TheWorld.Map:IsPassableAtPoint(px, v.relative_y + y, pz) or not no_spawners_in_water then
							ent.layout = v.options

							if FindEntity(ent, 8, nil, { "DYNLAYOUT_BLOCKER" }) ~= nil then
								ent:Remove()
							end

							if autotrigger_spawners then
								print("what?")
								TheWorld:DoTaskInTime(math.random(), function()
									print("huh???")
									SpawnLayout(ent, { angle_override = (use_angle_away_from_spawn and math.atan2(px - x, z - pz) - math.rad(angle_offset)) or nil, file_path_override = extradata.file_path_override })
								end)
							else
								ent.wait_for_spawning = true
								ent.group = group
								ent.AnimState:SetMultColour(0, 0, 0, 0)
								ent:AddTag("NOCLICK")
								ent:AddTag("NOBLOCK")
								ent.angle_away = (use_angle_away_from_spawn and math.atan2(px - x, z - pz) - math.rad(angle_offset)) or nil
								ent:ListenForEvent("spawn_dl_" .. group, SpawnLayout)
							end
						else
							ent:Remove()
						end
					end
				end
			end
		end
	end

	inst:DoTaskInTime(0, inst.Remove)
end

local function OnSave_spawner(inst, data)
	if data ~= nil and inst.wait_for_spawning then
		data.wait_for_spawning = inst.wait_for_spawning
		data.group = inst.group
		data.angle_away = inst.angle_away
		data.layout = inst.layout
	end
	return data
end

local function OnLoad_spawner(inst, data)
	if data ~= nil then
		inst.wait_for_spawning = data.wait_for_spawning
		inst.group = data.group
		inst.angle_away = data.angle_away
		inst.layout = data.layout
		if data.wait_for_spawning then
			inst.AnimState:SetMultColour(0, 0, 0, 0)
			inst:AddTag("NOCLICK")
			inst:AddTag("NOBLOCK")
			inst:ListenForEvent("spawn_dl_" .. inst.group, SpawnLayout)
		end
	end

	return inst
end


local function spawnerfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	inst:AddTag("structure")
	inst:AddTag("chest")
	inst:AddTag("_writeable")
	inst:AddTag("noreplaceremove")
	inst:AddTag("dl_spawner")
	inst.AnimState:SetBank("chest")
	inst.AnimState:SetBuild("treasure_chest")
	inst.AnimState:PlayAnimation("closed")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst.OnSave = OnSave_spawner
	inst.OnLoad = OnLoad_spawner

	inst.SpawnLayout = SpawnLayout

	inst:AddComponent("inspectable")
	inst:AddComponent("writeable")
	inst:AddComponent("lootdropper")

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetWorkLeft(2)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)

	inst:ListenForEvent("onbuilt", onbuilt)

	inst:AddComponent("channelable")
	inst.components.channelable:SetChannelingFn(SpawnLayout, OnStopChanneling)
	inst.components.channelable.use_channel_longaction_noloop = true
	inst.components.channelable.skip_state_channeling = true

	inst:DoTaskInTime(0, function(inst)
		local x, y, z = inst.Transform:GetWorldPosition()
		local tile_x, tile_y, tile_z = TheWorld.Map:GetTileCenterPoint(x, 0, z)
		if tile_x ~= nil and tile_y ~= nil and tile_z ~= nil then
			inst.Transform:SetPosition(tile_x, 0, tile_z)
		else
			TheNet:Announce("PANIC! Spawning out of bounds?!")
			inst:Remove()
		end
	end)

	return inst
end
local function Blocker(inst)
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddNetwork()


	inst:AddTag("DYNLAYOUT_BLOCKER")
	inst:AddTag("noreplaceremove")


	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:DoTaskInTime(0, function(inst)
		local x, y, z = inst.Transform:GetWorldPosition()
		local tile_x, tile_y, tile_z = TheWorld.Map:GetTileCenterPoint(x, 0, z)
		inst.Transform:SetPosition(tile_x, 0, tile_z)
	end)

	return inst
end

return Prefab("dl_recorder", fn), Prefab("dl_tileflag", TileFlag), Prefab("dl_spawner", spawnerfn),
	Prefab("dl_blocker", Blocker)
