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
    TheNet:SystemMessage("-------------------------")
end

--forces an RNE.
function c_rne()
    local rne = TheWorld.components.randomnightevents
    rne:ForceRNE(true)
end
