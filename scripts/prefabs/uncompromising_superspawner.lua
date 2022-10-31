
local umss_tables = require("umss_tables")
--Reworked tables, place them in umss_tables.lua
--may make them write themselves there now.
--reference with
--Place the next table above MEEEE^
--------------------------------------------

--for the fences...
local ROT_SIDES = 8
local function CalcRotationEnum(rot)
    return math.floor((math.floor(rot + 0.5) / 45) % ROT_SIDES)
end

local function CalcFacingAngle(rot)
    return CalcRotationEnum(rot) * 45
end

local function IsNarrow(inst)
    return CalcRotationEnum(inst.Transform:GetRotation()) % 2 == 0
end

local function SetOffset(inst, offset)
    if inst.dooranim ~= nil then
        inst.dooranim.Transform:SetPosition(offset, 0, 0)
    end
end

local function ApplyDoorOffset(inst)
    SetOffset(inst, inst.offsetdoor and 0.45 or 0)
end

local function GetAnimState(inst)
    return (inst.dooranim or inst).AnimState
end

local function SetOrientation(inst, rotation)
    --rotation = CalcFacingAngle(rotation)

    inst.Transform:SetRotation(rotation)

    if inst.anims.narrow then

        if IsNarrow(inst) then
            if not inst.bank_narrow_set then
                inst.bank_narrow_set = true
                inst.bank_wide_set = nil
                GetAnimState(inst):SetBank(inst.anims.narrow)
            end
        else
            if not inst.bank_wide_set then
                inst.bank_wide_set = true
                inst.bank_narrow_set = nil
                GetAnimState(inst):SetBank(inst.anims.wide)
            end
        end

        if inst.isdoor then
            ApplyDoorOffset(inst)
        end
    end
end

local function UncompromisingSpawnGOOOOO(inst, data)
    local x, y, z = inst.Transform:GetWorldPosition()

    if inst.tile_centered then
        local tile_x, tile_y, tile_z = TheWorld.Map:GetTileCenterPoint(x, 0, z)
        inst.Transform:SetPosition(tile_x, tile_y, tile_z)
        x, y, z = inst.Transform:GetWorldPosition()
    end

    local rotx = 1
    local rotz = 1

    if inst.rotatable then -- This rotates the vvhole 
        if math.random() > 0.5 then rotx = -1 end
        if math.random() > 0.5 then rotz = -1 end
    end
    -- TheNet:Announce("code ran") --For Troubleshooting
    for i, v in ipairs(data) do
        -- TheNet:Announce(i) --For Troubleshooting
        -- TheNet:Announce("Prefab: "..v.prefab) --For Troubleshooting
        if v.prefab ~= "umdc_tileflag" and v.prefab ~= "seeds" --[[hecking birds man]]then
            local prefab = SpawnPrefab(v.prefab)
            -- TheNet:Announce("spawninwater_prefab: ")
            -- TheNet:Announce(tostring(inst.spawninwater_prefab))
			if prefab then
            -- for area handlers, so they can find all things created by a especific SS.
				if inst.tags then
					for k, v in ipairs(inst.tags) do
						prefab:AddTag("dynlayout_" .. v)
					end
					prefab.dynlayout_tags = inst.tags
				end

				if inst.spawninwater_prefab then
					prefab.Transform:SetPosition(x + v.x * rotx, (v.y and v.y + y) or 0, z + v.z * rotz)
				else
					if not TheWorld.Map:IsOceanTileAtPoint(x + v.x * rotx, (v.y and v.y + y) or 0, z + v.z * rotz) then
						-- TheNet:Announce("not ocean tile, setting pos!")
						prefab.Transform:SetPosition(x + v.x * rotx, (v.y and v.y + y) or 0, z + v.z * rotz)
					else
						-- TheNet:Announce("ocean tile! removing!")
						prefab:Remove()
					end
				end

				if v.diseased then
					-- If vve ever add back acid rain I guess vve could have this, vvhatever
				end
				if v.barren and prefab.components.pickable then
					prefab.components.pickable:MakeBarren()
				end
				if v.withered and prefab.components.witherable then
					prefab.components.witherable:ForceWither()
				end
				if v.ocean then
					if not TheWorld.Map:IsOceanTileAtPoint(x + v.x * rotx, (v.y and v.y + y) or 0, z + v.z * rotz) then
						prefab:Remove()
					end
				end
				if v.health and prefab.components.health then
					prefab.components.health:SetPercent(v.health)
				end
				if v.contents and prefab.components.container then
					print(v.contents) -- just testing!
				end
				if v.burnt and prefab.components.burnable then
					prefab.components.burnable.onburnt(prefab)
				end
				if v.uses and prefab.components.finiteuses then
					prefab.components.finiteuses:SetUses(v.uses)
				end
				if v.fuel and prefab.components.fueled then
					prefab.components.fueled:SetPercent(v.fuel)
				end
				if v.scenario then
					if prefab.components.scenariorunner == nil then
						prefab:AddComponent("scenariorunner")
					end
					prefab.components.scenariorunner:SetScript(v.scenario)
				end
				if v.rotation and (prefab.prefab == "fence" or prefab.prefab == "fence_gate") then
					SetOrientation(prefab, (v.rotation*rotx)*rotz)
				elseif v.rotation and v.rotation ~= 0 then
					prefab.Transform:SetRotation((v.rotation*rotx)*rotz)
				end
			end
            if v.tile and v.tile ~= TheWorld.Map:GetTileAtPoint(x + v.x * rotx, (v.y and v.y + y) or 0, z + v.z * rotz) then
                local tile_x, tile_z = TheWorld.Map:GetTileCoordsAtPoint(x + v.x * rotx, (v.y and v.y + y) or 0, z + v.z * rotz)
                -- :Announce("spawninwater_tile:")
                -- TheNet:Announce(tostring(inst.spawninwater_tile))
                if inst.spawninwater_tile then
                    -- TheNet:Announce("spawninwater true!")
                    -- print(v.tile)
                    -- TheWorld.Map:SetTile(tile_x, tile_z, v.tile)
                else
                    if TheWorld.Map:IsOceanTileAtPoint(x + v.x * rotx, (v.y and v.y + y) or 0, z + v.z * rotz) then
                        -- TheNet:Announce("water at point!")
                    else
                        -- TheNet:Announce("not water!")
                        if v.tile == 257 then
                            TheWorld.components.dockmanager:CreateDockAtPoint(tile_x, (v.y and v.y + y) or 0, tile_z, v.tile)
                        else
                            TheWorld.Map:SetTile(tile_x, tile_z, v.tile)
                        end
                    end
                end
            end
        end
    end
end

--name and table are required. Others are optional.
--name,table [,rotate,tile_centered, spawninwater_tile, spawninwater_prefab, tags, spawnfn]
local function superspawner(data)
    local function makefn()
		local inst = CreateEntity()
		inst.entity:AddTransform()
		inst.entity:AddNetwork()
		inst.entity:SetPristine()

		if not TheWorld.ismastersim then
			return inst
		end

		inst.tags = data.tags
		inst.spawnTable = data.table
		inst.rotatable = data.rotate == nil and false or data.rotate
		inst.tile_centered = data.tile_centered == nil and false or data.tile_centered
		inst.spawninwater_tile = data.spawninwater_tile == nil and true or data.spawninwater_tile
		inst.spawninwater_prefab = data.spawninwater_prefab == nil and true or data.spawninwater_prefab
        inst.SpawnFn = data.spawnfn

		--TheNet:Announce("INIT") --For Troubleshooting
		inst:DoTaskInTime(0,
			function(inst)
				--TheNet:Announce("Code Ran") --For Troubleshooting
				UncompromisingSpawnGOOOOO(inst,inst.spawnTable)
                if data.spawnfn == nil then--would except the spawn fn to remove the thing 
				    inst:Remove()
                else
                    if inst.SpawnFn ~= nil then
                        inst.SpawnFn(inst)
                    end
                end
			end)
		return inst
	end
    if data.name ~= nil and data.table ~= nil then--camel case won't work but at least we can write with it in here.
        return Prefab("umss_"..string.lower(data.name), makefn)
    else
        print("!!! UMSS FAILED TO GENERATE !!!\nname: "..data.name.." table: "..tostring(data.table))
    end
end


--Version 1.3
--[[
    Create your spawners by filling out the spawners table!
    @name(str) - The name of prefab that will spawn the captured tiles/prefabs. Has the "umss_" prefix in-game. REQUIRED
    @table(table) - The result of devcapture, this has all the data of things to be spawned. Defined on scripts/umss_tables.lua (call it with umss_tables.your_table_nane) REQUIRED
    @rotate(bool) - Whether the setpiece will rotate when spawning.
    @tile_centered(bool) - Whether the spawner will center itself on a tile before spawning things. Useful/Required for setpieces using tiles.
    @spawninwater_prefab(bool) - Whether the spawned prefabs will spawn in water. (For the oposite, prefabs captured on water already do not spawn on land.)
    @spawninwater_tile(bool) - Similar to spawninwater_prefab, but for tiles instead.
    @tags(table) - Tags to be applied to spawned prefabs, useful for removing/finding prefabs spawned by the setpiece.
    @spawnfn(fn) - Function, runs any function defined here on spawn, DISABLES SELF-REMOVING - ADD REMOVAL ON THE FUNCTION ITSELF.
]]

local spawner_data = {
    --{name = "name", table = umss_tables.table, rotate = true/false, tile_centered = true/false, spawninwater_tile = true/false, spawninwater_prefab = true/false, tags = {"tag1", "tag2"}, spawnfn = function}
    {name = "test1", table = umss_tables.testTable3, rotate = true, tile_centered = true},
    {name = "test2", table = umss_tables.testTable2, rotate = true},
    --don't ask what happened to test3
    {name = "test3", table = umss_tables.testTable4, rotate = true, tile_centered = true},

    {name = "demoTable", table = umss_tables.demoTable, rotate = true},

    {name = "scorpionOutskirts1", table = umss_tables.scorpionOutskirts1, rotate = true, tile_centered = true, spawninwater_prefab = false, spawninwater_tile = false},
    {name = "scorpionOutskirts2", table = umss_tables.scorpionOutskirts2, rotate = true, tile_centered = true, spawninwater_prefab = false, spawninwater_tile = false},
    {name = "scorpionOutskirts3", table = umss_tables.scorpionOutskirts3, rotate = true, tile_centered = true, spawninwater_prefab = false, spawninwater_tile = false},
    {name = "scorpionOutskirts4", table = umss_tables.scorpionOutskirts4, rotate = true, tile_centered = true, spawninwater_prefab = false, spawninwater_tile = false},
    {name = "scorpionCenter4", table = umss_tables.scorpionCenter1, rotate = true, tile_centered = true, spawninwater_prefab = false, spawninwater_tile = false},

    {name = "basefrag_rattyStorage", table = umss_tables.baseFrag_rattyStorage, rotate = true, spawninwater_prefab = false, spawninwater_tile = false},
    {name = "basefrag_rattySmellyKitchen", table = umss_tables.baseFrag_smellyKitchen, rotate = true, spawninwater_prefab = false, spawninwater_tile = false},

    {name = "moonOil", table = umss_tables.moonOil, rotate = true, spawninwater_prefab = false},
    {name = "failedFisherman", table = umss_tables.failedFisherman},
    {name = "tridentTrap", table = umss_tables.tridentTrap},
    {name = "impactfulDiscovery", table = umss_tables.impactfulDiscovery, rotate = true, spawninwater_prefab = false, spawninwater_tile = false},
    {name = "sunkenboat", table = umss_tables.sunkenboat, rotate = true},

    {name = "inactiveBiome_test", table = umss_tables.inactivebiome_test, rotate = true, tile_centered = true, tags = {"utw_inactivebiome"}},
    {name = "activeBiome_test_rr", table = umss_tables.activebiome_test_rr, rotate = true, tile_centered = true, tags = {"utw_activebiome"}},
    {name = "activeBiome_test_ss", table = umss_tables.activebiome_test_ss, rotate = true, tile_centered = true, tags = {"utw_activebiome"}},
    {name = "activeBiome_test_bb", table = umss_tables.activebiome_test_bb, rotate = true, tile_centered = true, tags = {"utw_activebiome"}},

    {name = "activeBiome_cbts_ss", table = umss_tables.activebiome_cbts_ss, rotate = true, tile_centered = true, tags = {"utw_activebiome"}},
    {name = "activeBiome_cbts_bb", table = umss_tables.activebiome_cbts_bb, rotate = true, tile_centered = true, tags = {"utw_activebiome"}},
    {name = "inactiveBiome_cbts_1", table = umss_tables.inactivebiome_cbts_1, rotate = true, tile_centered = true, tags = {"utw_inactivebiome"}},
    {name = "inactiveBiome_cbts_2", table = umss_tables.inactivebiome_cbts_2, rotate = true, tile_centered = true, tags = {"utw_inactivebiome"}},
    {name = "inactiveBiome_cbts_3", table = umss_tables.inactivebiome_cbts_3, rotate = true, tile_centered = true, tags = {"utw_inactivebiome"}},

    {name = "megabaseRuins_intersection", table = umss_tables.megabaseruins_intersection, rotate = true, spawninwater_prefab = false, spawninwater_tile = false},
    {name = "megabaseRuins_centerpiece", table = umss_tables.megabaseruins_centerpiece, rotate = true, spawninwater_prefab = false, spawninwater_tile = false},
    {name = "megabaseRuins_road", table = umss_tables.megabaseruins_road, rotate = true, spawninwater_prefab = false, spawninwater_tile = false},
	
    {name = "ancientwalrusTable", table = umss_tables.ancientwalrusTable, rotate = true, tile_centered = true, spawninwater_prefab = false, spawninwater_tile = false},
    {name = "fooltrap1Table", table = umss_tables.fooltrap1Table, rotate = true, tile_centered = true, spawninwater_prefab = false, spawninwater_tile = false},
    {name = "sussyTable", table = umss_tables.sussyTable, rotate = true, tile_centered = true, spawninwater_prefab = false, spawninwater_tile = false},
    {name = "badfarmerTable", table = umss_tables.badfarmerTable, rotate = true, tile_centered = true, spawninwater_prefab = false, spawninwater_tile = false},
    {name = "shyTable", table = umss_tables.shyTable, rotate = true, tile_centered = true, spawninwater_prefab = false, spawninwater_tile = false},
    {name = "moxTable", table = umss_tables.moxTable, rotate = true, tile_centered = true, spawninwater_prefab = false, spawninwater_tile = false},
    {name = "walterifgoodTable", table = umss_tables.walterifgoodTable, rotate = true, tile_centered = true, spawninwater_prefab = false, spawninwater_tile = false},
    {name = "swamplake", table = umss_tables.swamplake, rotate = true, tile_centered = true, spawninwater_prefab = false, spawninwater_tile = false},
    {name = "singlefather", table = umss_tables.singlefather, rotate = true, tile_centered = true, spawninwater_prefab = false, spawninwater_tile = false},
	{name = "sos", table = umss_tables.sos, rotate = true, tile_centered = true, spawninwater_prefab = false, spawninwater_tile = false},		
	{name = "wixie_puzzle", table = umss_tables.wixie_puzzle, rotate = true, tile_centered = true, spawninwater_prefab = false, spawninwater_tile = false},
    
}

local spawner_prefabs = {}

for i, v in ipairs(spawner_data) do
    local spawner = superspawner(v)
    table.insert(spawner_prefabs, spawner)
end

return unpack(spawner_prefabs)