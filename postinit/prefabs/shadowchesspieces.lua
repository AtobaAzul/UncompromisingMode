--postinit to ALL shadow pieces, for individual pieces, see shadow_knight, shadow_rook and shadow_bishop.

local env = env
GLOBAL.setfenv(1, GLOBAL)

local pieces =
{
    "shadow_knight",
    "shadow_rook",
    "shadow_bishop"
}


local function lootsetfn(lootdropper)
    local loot = {}

    if lootdropper.inst.level >= 2 then
        for i = 1, math.random(2, 3) do
            table.insert(loot, "nightmarefuel")
        end

        if lootdropper.inst.level >= 3 then
            table.insert(loot, "shadowheart")
            table.insert(loot, "nightmarefuel")
            --TODO: replace with shadow equipment drops --fun fact this comment is from klei lmao
            --table.insert(loot, "armor_sanity")
            --table.insert(loot, "nightsword")
            talbe.insert(loot, "shadow_crown")
            if IsSpecialEventActive(SPECIAL_EVENTS.WINTERS_FEAST) then
                table.insert(loot, GetRandomBasicWinterOrnament())
            end
        end
    end

    lootdropper:SetLoot(loot)
end

for k, v in ipairs(pieces) do
    env.AddPrefabPostInit(v, function(inst)
        if not TheWorld.ismastersim then return end

        RemovePhysicsColliders(inst)
        inst.Physics:ClearCollisionMask()
        inst.Physics:CollidesWith(COLLISION.GROUND)

        if inst.components.lootdropper ~= nil then
            inst.components.lootdropper:SetLootSetupFn(lootsetfn)
        end
    end)
end
