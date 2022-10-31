--why didn't I just do a postinit on the pirate_spawner component?
--well I don't feel like copying every local today.

local function hitbycannonorseedshell(boat, data)
    print(data.cause)
    if data.cause == "cannonball" or data.cause == "trident" or data.cause == "waterplant_bomb" then
        if boat.components.boatcrew then
            boat.components.boatcrew.fqlee = true
            for k, v in pairs(boat.components.boatcrew.members) do
                k:DoTaskInTime(math.random()* 0.3 + 0.2 , function()  if k and not k.components.health:IsDead() then k:PushEvent("victory",{say=STRINGS["MONKEY_TALK_RETREAT"][math.random(1,#STRINGS["MONKEY_TALK_RETREAT"])]} ) end  end)             
            end
        end
    end
end

local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

env.AddPrefabPostInit("boat_pirate", function(inst)
    if not TheWorld.ismastersim then
        return
    end
    inst:ListenForEvent("spawnnewboatleak", hitbycannonorseedshell)
end)