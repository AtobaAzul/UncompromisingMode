local assets =
{
    Asset("ANIM", "anim/charlie_fountain.zip"),      
}

local prefabs =
{
    --[["waterdrop",
    "lifeplant",--]]
}

local function OnActivate(inst)
    print("ACTIVATED THE PUGALISK FOUNTAIN")

    inst.AnimState:PlayAnimation("flow_pst")
    inst.AnimState:PushAnimation("off", true)
    inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/boss/pugalisk/resurrection")
    inst.SoundEmitter:KillSound("burble")
    inst.components.activatable.inactive = false
    inst.dry = true

    local drop = SpawnPrefab("waterdrop")
    drop.fountain = inst
    GetPlayer().components.inventory:GiveItem(drop, nil,  Vector3(TheSim:GetScreenPos(inst.Transform:GetWorldPosition()) ) )

    local ent = TheSim:FindFirstEntityWithTag("pugalisk_trap_door")
    if ent then
        ent.activate(ent,inst)
    end    
end
--[[
local function makeactive(inst)
    inst.AnimState:PlayAnimation("off", true)
    inst.components.activatable.inactive = false
end

local function makeused(inst)
    inst.AnimState:PlayAnimation("flow_loop", true)
end
]]
local function reset(inst)
    print("RESET THE PUGALISK FOUNTAIN")
    inst.dry = nil
    inst.components.activatable.inactive = true
    inst.AnimState:PlayAnimation("flow_pre")
    inst.AnimState:PushAnimation("flow_loop", true) 
    inst.SoundEmitter:KillSound("burble")
    inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/boss/pugalisk/fountain_LP", "burble")
    if inst.resettask then
        inst.resettask:Cancel()
        inst.resettask = nil
    end
    if inst.resettaskinfo then
        inst.resettaskinfo = nil
    end
end

local function deactivate(inst)    
    if not inst.resettask then
        inst.resettask, inst.resettaskinfo = inst:ResumeTask(TUNING.TOTAL_DAY_TIME,function() reset(inst) end)
    end
end

local function onsave(inst,data)
    if inst.dry then
        data.dry = true
    end
    if inst.resettaskinfo then
        data.resettask = inst:TimeRemainingInTask(inst.resettaskinfo)
    end
end

local function onload(inst, data)
    if data then
        if data.resettask then
            if inst.resettask then inst.resettask:Cancel() inst.resettask = nil end
            inst.resettaskinfo = nil
            inst.resettask, inst.resettaskinfo = inst:ResumeTask(data.resettask, function() reset(inst) end)
        end  
        if data.dry then        
            inst.AnimState:PlayAnimation("off", true)
            inst.dry = true
            inst.components.activatable.inactive = false
        end         
    end
end

local function fn(Sim)
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
	
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()

    anim:SetBuild("charlie_fountain")    
    anim:SetBank("fountain")
    anim:PlayAnimation("flow_loop", true)
    --inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/boss/pugalisk/fountain_LP", "burble")
    inst:AddTag("pugalisk_fountain")

    inst:AddTag("pugalisk_avoids")
    
    MakeObstaclePhysics(inst, 2)

    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("pig_ruins_well.png")

    --[[inst:AddComponent("activatable")
    inst.components.activatable.OnActivate = OnActivate
    inst.components.activatable.inactive = true--]]
    inst:AddComponent("inspectable")
    inst.components.inspectable:RecordViews()

    --inst.deactivate = deactivate

    inst.OnSave = onsave 
    inst.OnLoad = onload
--[[
    inst:DoTaskInTime(0,function()
            local drop = nil
            local plant = nil
            for k,v in pairs(Ents) do                
                if v:HasTag("lifeplant") then
                    plant = true                                    
                end
                if v:HasTag("waterdrop") then
                    drop = true
                end
                if plant and drop then
                    break
                end
            end
            if not plant and not drop and inst.dry then               
                deactivate(inst)
            end
        end)--]]

    return inst
end

return Prefab("charlie_fountain", fn, assets, prefabs)


