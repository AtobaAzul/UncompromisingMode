local umss_tables = require("umss_tables")
-- Reworked tables, place them in umss_tables.lua
-- may make them write themselves there now.
-- reference with

-- for the fences...
local ROT_SIDES = 8
local function CalcRotationEnum(rot) return math.floor((math.floor(rot + 0.5) / 45) % ROT_SIDES) end

local function CalcFacingAngle(rot) return CalcRotationEnum(rot) * 45 end

local function IsNarrow(inst) return CalcRotationEnum(inst.Transform:GetRotation()) % 2 == 0 end

local function SetOffset(inst, offset)
    if inst.dooranim ~= nil then
        inst.dooranim.Transform:SetPosition(offset, 0, 0)
    end
end

local function ApplyDoorOffset(inst) SetOffset(inst, inst.offsetdoor and 0.45 or 0) end

local function GetAnimState(inst) return (inst.dooranim or inst).AnimState end

local function SetOrientation(inst, rotation)
    -- rotation = CalcFacingAngle(rotation)

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
    -- attempted fix for worldgen/load crash, maybe it's
    if x == nil or y == nil or z == nil then -- Full check, who knows what might be nil.
        return
    end
    if inst.tile_centered then
        local tile_x, tile_y, tile_z = TheWorld.Map:GetTileCenterPoint(x, 0, z)
        inst.Transform:SetPosition(tile_x, tile_y, tile_z)
        x, y, z = inst.Transform:GetWorldPosition()
    end

    local rotx = 1
    local rotz = 1

    if inst.rotatable then -- This rotates the whole
        if math.random() > 0.5 then
            rotx = -1
        end
        if math.random() > 0.5 then
            rotz = -1
        end
    end
    -- TheNet:Announce("code ran") --For Troubleshooting
    for i, v in ipairs(data) do
        if x + v.x * rotx == nil or z + v.z * rotz == nil then
            return
        end
        -- TheNet:Announce(i) --For Troubleshooting
        -- TheNet:Announce("Prefab: "..v.prefab) --For Troubleshooting
        if v.prefab ~= "umdc_tileflag" and v.prefab ~= "seeds" --[[hecking birds man]] then
            local prefab = SpawnPrefab(v.prefab)

            if prefab then
                -- for area handlers, so they can find all things created by a especific SS.
                if inst.umss_tags then
                    for k, v in ipairs(inst.umss_tags) do
                        prefab:AddTag("umss_" .. v)
                    end
                    prefab.umss_tags = inst.umss_tags
                end

                if inst.spawninwater_prefabs then
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
                    -- If we ever add back acid rain I guess we could have this, whatever
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
                    SetOrientation(prefab, (v.rotation * rotx) * rotz)
                elseif v.rotation and v.rotation ~= 0 then
                    prefab.Transform:SetRotation((v.rotation * rotx) * rotz)
                end
            end
        else
            if v.tile and v.tile ~= TheWorld.Map:GetTileAtPoint(x + v.x * rotx, (v.y and v.y + y) or 0, z + v.z * rotz) then
                local tile_x, tile_z = TheWorld.Map:GetTileCoordsAtPoint(x + v.x * rotx, (v.y and v.y + y) or 0, z + v.z * rotz)
                -- :Announce("spawninwater_tile:")
                -- TheNet:Announce(tostring(inst.spawninwater_tile))
                if inst.spawninwater_tiles then
                    -- TheNet:Announce("spawninwater true!")
                    -- print(v.tile)
                    TheWorld.Map:SetTile(tile_x, tile_z, v.tile)
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
    inst:Remove()
end

local function findTable(stringTable) -- We randomly weighted a table string name, now find it in umss_tables
    for i, v in pairs(umss_tables) do
        if v.name == stringTable then
            return v
        end
    end
end

local function DefineTable(inst, data)
    -- inst.tags = data.tags
    local funtable = findTable(data)
    if funtable then
        inst.spawnTable = funtable.content
        inst.rotatable = funtable.rotate == nil and false or funtable.rotate
        inst.tile_centered = funtable.tile_centered == nil and false or funtable.tile_centered
        inst.spawninwater_tiles = funtable.spawninwater_tiles == nil and false or funtable.spawninwater_tiles
        inst.spawninwater_prefabs = funtable.spawninwater_prefabs == nil and false or funtable.spawninwater_prefabs
        inst.SpawnFn = funtable.spawnfn
        inst.umss_tags = funtable.tags
    end
end

local function onload(inst, data)
    if data and data.table then
        inst.DefineTable(inst, data.table, true, true)
    end
end

local function ReplaceMyself(inst) -- You failed to find a table, so replacing myself so you can write again
    SpawnPrefab("umss_general").Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst:DoTaskInTime(1, function(inst) inst:Remove() end)
end

local function ShoTable(inst)
    for i, v in pairs(umss_tables) do
        TheNet:Announce(v.name)
    end
    -- ReplaceMyself(inst)
end

local function TryForce(inst)
    if not inst.lock then
        inst.lock = true
        local text = inst.components.writeable.text
        inst.DefineTable(inst, text, true, true)
        if not inst.spawnTable then
            if text == "GiveTable" then
                ShoTable(inst)
            else
                TheNet:Announce("Does not matching an existing UMSS, enter GiveTable to see a full list")
                ReplaceMyself(inst)
            end
        else
            inst:DoTaskInTime(0, function(inst) inst:DoTaskInTime(1, UncompromisingSpawnGOOOOO(inst, inst.spawnTable)) end) -- Need to give time for the UI to close, and for some reason the first dotaskintime doesn't work
        end
    end
end

local function makefn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("sign_home")
    inst.AnimState:SetBuild("sign_home")
    inst.AnimState:PlayAnimation("idle")
    inst:AddTag("_writeable")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.DefineTable = DefineTable
    inst:AddTag("_writeable")

    inst:AddComponent("inspectable")
    inst:AddComponent("writeable")
    inst.components.writeable:SetOnWritingEndedFn(TryForce)
    inst.OnLoad = onload
    inst.persists = false
    inst:DoTaskInTime(0.2, function(inst)
        -- TheNet:Announce("Code Ran") --For Troubleshooting
        if inst.spawnTable then
            UncompromisingSpawnGOOOOO(inst, inst.spawnTable)
        end
        --[[if data and data.spawnfn then--would except the spawn fn to remove the thing
                if inst.SpawnFn ~= nil then
                    inst.SpawnFn(inst)
                end
            else
				inst:Remove()
            end]]
    end)
    return inst
end

-- Version 1.4
--[[
    @name(str) - The name of prefab that will spawn the captured tiles/prefabs. Has the "umss_" prefix in-game. REQUIRED
    @table(table) - The result of devcapture, this has all the data of things to be spawned. Defined on scripts/umss_tables.lua (call it with umss_tables.your_table_nane) REQUIRED
    @rotate(bool) - Whether the setpiece will rotate when spawning.
    @tile_centered(bool) - Whether the spawner will center itself on a tile before spawning things. Useful/Required for setpieces using tiles.
    @spawninwater_prefab(bool) - Whether the spawned prefabs will spawn in water. (For the oposite, prefabs captured on water already do not spawn on land.)
    @spawninwater_tile(bool) - Similar to spawninwater_prefab, but for tiles instead.
    @tags(table) - Tags to be applied to spawned prefabs, useful for removing/finding prefabs spawned by the setpiece.
    @spawnfn(fn) - Function, runs any function defined here on spawn, DISABLES SELF-REMOVING - ADD REMOVAL ON THE FUNCTION ITSELF.
]]
return Prefab("umss_general", makefn)
