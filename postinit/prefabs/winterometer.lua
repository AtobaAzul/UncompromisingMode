--DUMBEST FUCKING NAME I'VE SEEN SO FAR

local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

function DoGlow(inst)
    if inst._glowing:value() == true then
        inst.AnimState:SetSymbolAddColour("meter", 1, 0, 0, 0)
        inst.AnimState:SetSymbolLightOverride("meter", .5)
        inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
        inst.AnimState:SetSymbolBloom("meter")
    else
        inst.AnimState:SetSymbolAddColour("meter", 0, 0, 0, 0)
        inst.AnimState:SetSymbolLightOverride("meter", 0)
        inst.AnimState:ClearSymbolBloom("meter")
        inst.AnimState:ClearBloomEffectHandle("shaders/anim.ksh")
    end
end

function DoHeatwaveGlowCheck(inst)
    if TheWorld:HasTag("heatwavestart") or TheWorld.net:HasTag("heatwavestartnet") or TheWorld.components.worldsettingstimer ~= nil and TheWorld.components.worldsettingstimer:GetTimeLeft("um_heatwave_timer") ~= nil and TheWorld.components.worldsettingstimer:GetTimeLeft("um_heatwave_timer") < 120 then
        inst._glowing:set(true)
    else
        inst._glowing:set(false)
    end
end



env.AddPrefabPostInit("winterometer", function(inst)
    inst._glowing = net_bool(inst.GUID, "thermal._glowing", "glowingdirty")
    inst._glowing:set(false)

    inst:ListenForEvent("glowingdirty", DoGlow)

    if not TheWorld.ismastersim then return end
    inst:DoPeriodicTask(1, DoHeatwaveGlowCheck, 0)
end)
