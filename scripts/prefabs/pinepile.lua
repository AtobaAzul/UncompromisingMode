local assets =
{
	Asset( "ANIM", "anim/pinepile.zip"),
}

local function onpickup(inst, picker)
    local x, y, z = inst.Transform:GetWorldPosition()
	SpawnPrefab("pine_needles_chop").Transform:SetPosition(x, y + math.random() * 2, z)
    local item = nil
    for i, v in ipairs(inst.loot) do
        item = SpawnPrefab(v)
        item.Transform:SetPosition(x, y, z)
        if item.components.inventoryitem ~= nil and item.components.inventoryitem.ondropfn ~= nil then
            item.components.inventoryitem.ondropfn(item)
        end
        if inst.lootaggro[i] and item.components.combat ~= nil and picker ~= nil then
            if not (item:HasTag("spider") and (picker:HasTag("spiderwhisperer") or picker:HasTag("spiderdisguise") or (picker:HasTag("monster") and not picker:HasTag("player")))) then
                item.components.combat:SuggestTarget(picker)
            end
        end
    end

    --SpawnPrefab("tumbleweedbreakfx").Transform:SetPosition(x, y, z)
    inst:Remove()
    return true --This makes the inventoryitem component not actually give the tumbleweed to the player
end
local CHESS_LOOT =
{
    "chesspiece_pawn_sketch",
    "chesspiece_muse_sketch",
    "chesspiece_formal_sketch",
    "trinket_15", --bishop
    "trinket_16", --bishop
    "trinket_28", --rook
    "trinket_29", --rook
    "trinket_30", --knight
    "trinket_31", --knight
}
local function MakeLoot(inst)
    local possible_loot =
    {
        {chance = 40,   item = "twigs"},
        {chance = 30,    item = "log"},
        {chance = 0.5,  item = "trinket_6"},
        {chance = 0.5,  item = "trinket_4"},
        {chance = 1,    item = "trinket_3"},
        {chance = 1,    item = "trinket_8"},
    }

    local chessunlocks = TheWorld.components.chessunlocks
    if chessunlocks ~= nil then
        for i, v in ipairs(CHESS_LOOT) do
            if not chessunlocks:IsLocked(v) then
                table.insert(possible_loot, { chance = .1, item = v })
            end
        end
    end

    local totalchance = 0
    for m, n in ipairs(possible_loot) do
        totalchance = totalchance + n.chance
    end

    inst.loot = {}
    inst.lootaggro = {}
    local next_loot = nil
    local next_aggro = nil
    local next_chance = nil
    local num_loots = 2
    while num_loots > 0 do
        next_chance = math.random()*totalchance
        next_loot = nil
        next_aggro = nil
        for m, n in ipairs(possible_loot) do
            next_chance = next_chance - n.chance
            if next_chance <= 0 then
                next_loot = n.item
                if n.aggro then next_aggro = true end
                break
            end
        end
        if next_loot ~= nil then
            table.insert(inst.loot, next_loot)
            if next_aggro then 
                table.insert(inst.lootaggro, true)
            else
                table.insert(inst.lootaggro, false)
            end
            num_loots = num_loots - 1
        end
    end
end

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddNetwork()
	
    inst.AnimState:SetBuild("pinepile")
    inst.AnimState:SetBank("pinepile")
    inst.AnimState:PlayAnimation("idle", true)
    inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
	
    inst:AddComponent("pickable")
    inst.components.pickable.picksound = "dontstarve/wilson/harvest_sticks"
    inst.components.pickable.onpickedfn = onpickup
    inst.components.pickable.canbepicked = true
    MakeLoot(inst)	
    return inst
end

return Prefab("pinepile", fn, assets)