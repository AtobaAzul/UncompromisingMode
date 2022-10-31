local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------


--Not sure how I'd do this without replacing the function, I need to add a cause to the "spawnnewboatleak" event.

local PLANT_TAGS = {"tendable_farmplant"}
local MUST_HAVE_SPELL_TAGS = nil
local CANT_HAVE_SPELL_TAGS = {"INLIMBO", "outofreach", "DECOR"}
local MUST_HAVE_ONE_OF_SPELL_TAGS = nil
local FX_RADIUS = TUNING.TRIDENT.SPELL.RADIUS * 0.65
local COST_PER_EXPLOSION = TUNING.TRIDENT.USES / TUNING.TRIDENT.SPELL.USE_COUNT

local function create_water_explosion(inst, target, position)
    local owner = inst.components.inventoryitem:GetGrandOwner()
    if owner == nil then
        return
    end

    local px, py, pz = position:Get()

    -- Do gameplay effects.
    local affected_entities = TheSim:FindEntities(px, py, pz, TUNING.TRIDENT.SPELL.RADIUS, MUST_HAVE_SPELL_TAGS, CANT_HAVE_SPELL_TAGS, MUST_HAVE_ONE_OF_SPELL_TAGS)
    for _, v in ipairs(affected_entities) do
        if v:IsOnOcean(false) then
            inst:DoWaterExplosionEffect(v, owner, position)
        end
    end

    -- Spawn visual fx.
    local angle = GetRandomWithVariance(-45, 20)
    for _ = 1, 4 do
        angle = angle + 90
        local offset_x = FX_RADIUS * math.cos(angle * DEGREES)
        local offset_z = FX_RADIUS * math.sin(angle * DEGREES)
        local ox = px + offset_x
        local oz = pz - offset_z

        if TheWorld.Map:IsOceanTileAtPoint(ox, py, oz) and not TheWorld.Map:IsVisualGroundAtPoint(ox, py, oz) then
            local platform_at_point = TheWorld.Map:GetPlatformAtPoint(ox, oz)
            if platform_at_point ~= nil then
                -- Spawn a boat leak slightly further in to help avoid being on the edge of the boat and sliding off.
                local bx, by, bz = platform_at_point.Transform:GetWorldPosition()
                if bx == ox and bz == oz then
                    platform_at_point:PushEvent("spawnnewboatleak", {pt = Vector3(ox, py, oz), leak_size = "med_leak", playsoundfx = true, cause = "trident"})
                else
                    local p_to_ox, p_to_oz = VecUtil_Normalize(bx - ox, bz - oz)
                    local ox_mod, oz_mod = ox + (0.5 * p_to_ox), oz + (0.5 * p_to_oz)
                    platform_at_point:PushEvent("spawnnewboatleak", {pt = Vector3(ox_mod, py, oz_mod), leak_size = "med_leak", playsoundfx = true, cause = "trident"})
                end

                local boatphysics = platform_at_point.components.boatphysics
                if boatphysics ~= nil then
                    boatphysics:ApplyForce(offset_x, -offset_z, 1)
                end
            else
                local fx = SpawnPrefab("crab_king_waterspout")
                fx.Transform:SetPosition(ox, py, oz)
            end
        end
    end

	local x, y, z = owner.Transform:GetWorldPosition()
    for _, v in pairs(TheSim:FindEntities(x, y, z, TUNING.TRIDENT_FARM_PLANT_INTERACT_RANGE, PLANT_TAGS)) do
		if v.components.farmplanttendable ~= nil then
			v.components.farmplanttendable:TendTo(owner)
		end
	end

    inst.components.finiteuses:Use(COST_PER_EXPLOSION)
end


env.AddPrefabPostInit("trident", function(inst)
	if not TheWorld.ismastersim then
		return
	end

    if inst.components.spellcaster ~= nil then
        inst.components.spellcaster:SetSpellFn(create_water_explosion)
    end
end)