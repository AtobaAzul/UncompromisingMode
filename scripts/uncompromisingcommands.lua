--toggle snowstorm
function c_snowstorm()
    if TheWorld:HasTag("snowstormstart") == false and TheWorld.state.iswinter then
        TheWorld:AddTag("snowstormstart")
        if TheWorld.net ~= nil then
            TheWorld.net:AddTag("snowstormstartnet")
        end
        print("starting snowstorm...")
    elseif TheWorld:HasTag("snowstormstart") then
        TheWorld:RemoveTag("snowstormstart")
        if TheWorld.net ~= nil then
            TheWorld.net:RemoveTag("snowstormstartnet")
        end
        print("stopping snowstorm...")
    end
end

--toggles vetcurse
function c_vetcurse()
    local player = ConsoleCommandPlayer()
    if player ~= nil and player.components.health ~= nil and not player:HasTag("playerghost") then
        if not player:HasTag("vetcurse") then
            player.components.debuffable:AddDebuff("buff_vetcurse", "buff_vetcurse")
            player:PushEvent("foodbuffattached", {buff = "ANNOUNCE_ATTACH_BUFF_VETCURSE", 1})
            print("added vetcurse")
        elseif player:HasTag("vetcurse") then
            player.components.debuffable:RemoveDebuff("buff_vetcurse")
            print("removed vetcurse")
        end
    end
end

--gives all current vet curse items
function c_vetcurseitems()
    c_give("cursed_antler")
    c_give("beargerclaw")
    c_give("slobberlobber")
    c_give("feather_frock")
    c_give("gore_horn_hat")
    c_give("klaus_amulet")
    c_give("crabclaw")
    c_give("um_beegun")
    if KnownModIndex:IsModEnabled("workshop-1289779251") then
        c_give("um_beegun_cherry")
    end

end

--lists current rat score shenenigans.
function c_ratcheck()
    local inst = TheSim:FindFirstEntityWithTag("rat_sniffer")
    inst:PushEvent("rat_sniffer")
    TheNet:SystemMessage("-------------------------")
    TheNet:SystemMessage("Itemscore = "..inst.itemscore)
    TheNet:SystemMessage("Foodscore = "..inst.foodscore)
    TheNet:SystemMessage("Burrowbonus = "..inst.burrowbonus)
    TheNet:SystemMessage("Ratscore = "..inst.ratscore)
    if inst.ratscore > 240 then
        inst.ratscore = 240
    end
    TheNet:SystemMessage("True Ratscore = "..inst.ratscore)
    TheNet:SystemMessage("Timer = "..TheWorld.components.ratcheck:GetRatTimer().."s")
    TheNet:SystemMessage("-------------------------")
end

--forces an RNE.
function c_rne()
    local rne = TheWorld.components.randomnightevents
    rne:ForceRNE(true)
end

--spawns a sunken chest at mouse pos
--@royal: whether to spawn royal chest
--examples:
--c_spawnsunkenchest() spawns a vanilla treasure
--c_spawnsunkenchest(true) spawns a royal chest
--c_spawnsunkenchest(false) spawns a um normal chest
function c_spawnsunkenchest(royal)
    local pos = ConsoleWorldPosition()

    if royal ~= true and royal ~= false then
        local messagebottletreasures = require("messagebottletreasures")
        print("spawning normal sunken chest at X:"..pos.x.." Z:"..pos.z)
        local treasure = messagebottletreasures.GenerateTreasure(pos)
        treasure.Transform:SetPosition(pos.x, pos.y, pos.z)
    elseif royal then
        local messagebottletreasures_um = require("messagebottletreasures_um")
        print("spawning royal sunken chest at X:"..pos.x.." Z:".. pos.z)
        local treasure = messagebottletreasures_um.GenerateTreasure(pos, "sunkenchest_royal_random")
        treasure.Transform:SetPosition(pos.x, pos.y, pos.z)
    elseif not royal then
        local messagebottletreasures_um = require("messagebottletreasures_um")
        print("spawning UM normal sunken chest at X:"..pos.x.." Z:"..pos.z)
        local treasure = messagebottletreasures_um.GenerateTreasure(pos, "sunkenchest")
        treasure.Transform:SetPosition(pos.x, pos.y, pos.z)
    else
        print("failed to spawn sunken chest")
    end
end

--sets a tile by ID
--defaults to barren if unspecified.
function c_settile(tile)
    if tile == nil then
        tile = 4
    end
    local pos = ConsoleWorldPosition()
    local tile_x, tile_z = TheWorld.Map:GetTileCoordsAtPoint(pos.x, 0,pos.z)

    if tile ~= WORLD_TILES.MONKEY_DOCK then
        TheWorld.Map:SetTile(tile_x,tile_z, tile)
    else
        TheWorld.components.dockmanager:CreateDockAtPoint(pos.x, 0, pos.z, WORLD_TILES.MONKEY_DOCK)--so it properly creates the undertile.
    end

    print("setting tile "..tile.." at "..tile_x..", "..tile_z)
end

--cheap little shortcut to respawn ocean biomes...
function c_regenerateoceanbiomes()
    local um_areahandler = TheWorld.components.um_areahandler
    if um_areahandler ~= nil then
        --[[if TheWorld.state.isspring then
            um_areahandler:FullGenerate()
        else
            um_areahandler:GenerateInactiveBiomes()
        end]]
        um_areahandler:FullGenerate()
        print("Regenerated UM ocean biomes.")
    else
        print("Failed to regenerate UM ocean biomes. - um_areahandler is nil!")
    end
end

--quick umss spawn command shortcut
--umss is string!
function c_umss(umss)
    if type(umss) ~= "string" then
        print("Failed to spawn! Defined value must be a string.")
        return
    end

    local pos = ConsoleWorldPosition()
    local setpiece = SpawnPrefab("umss_general")
    setpiece.DefineTable(setpiece, umss)
    setpiece.Transform:SetPosition(pos.x, 0, pos.z)
    setpiece:AddTag("NOCLICK")
    setpiece.AnimState:SetMultColour(0,0,0,0)
    setpiece:DoTaskInTime(1, setpiece.Remove)

    print("Spawning umss setpiece "..umss.." at "..tostring(pos.x)..","..tostring(pos.z)..".")
end

function c_setadrenaline(p)
    local player = ConsoleCommandPlayer()
    if player ~= nil and player.components.adrenaline ~= nil then
        player.components.adrenaline:SetPercent(p)
    end
end