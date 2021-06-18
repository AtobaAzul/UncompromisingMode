require("worldsettingsutil")


local function AreaAttack(inst)
        local x, y, z = inst.Transform:GetWorldPosition()
        local ents = TheSim:FindEntities(x, y, z, 3)
        for i, v in ipairs(ents) do
            if v ~= inst and v:IsValid() and not v:IsInLimbo() and not v:HasTag("moonglass") then
                if v.components.workable ~= nil and v.components.workable:CanBeWorked() then
                    v.components.workable:WorkedBy(inst, 3)
                end
                --Recheck valid after work
                if v:IsValid() and not v:IsInLimbo() then
                    if v.components.combat ~= nil and not (v.components.health ~= nil and v.components.health:IsDead()) and not v:HasTag("moonglasscreature") then
                        local dmg = 50
                        v.components.combat:GetAttacked(inst, dmg, nil)
                    end
                end
            end
        end
end

local function explode(inst)
    inst.AnimState:PlayAnimation("crack")
    inst:ListenForEvent("animover", function()

        inst.AnimState:SetBloomEffectHandle("")
        inst.defused = true
        inst.components.named:SetName(STRINGS.NAMES.MOONSTORM_GLASS_DEFUSED)
		AreaAttack(inst)


        SpawnPrefab("moonstorm_glass_ground_fx").Transform:SetPosition(inst.Transform:GetWorldPosition())
        SpawnPrefab("moonstorm_glass_fx").Transform:SetPosition(inst.Transform:GetWorldPosition())

        inst.SoundEmitter:PlaySound("moonstorm/common/moonstorm/glass_break")
        inst:Remove()
    end)
end


local function on_save(inst, data)
    data.defused = inst.defused or nil
end

local function on_load(inst, data)    
    if data and data.defused then
        inst.components.timer:StopTimer("defusetime")
        explode(inst)
    end
end

local function ontimedone(inst,data)
    if data.name == "defusetime" then
        explode(inst)
    end
end

local function getstatus(inst)
    if not inst.defused then
        return "INFUSED"
    end
end

local function spawnin(inst,time)
inst:Hide()
inst:DoTaskInTime(time,function(inst)
	AreaAttack(inst)
	inst:Show()
    inst.AnimState:PlayAnimation("spawn")
    inst.AnimState:PushAnimation("idle1",true)
	
	inst.components.timer:StartTimer("defusetime", 0.14)
end)
end

local function spawnlong(inst,time)
	AreaAttack(inst)
	inst:Show()
    inst.AnimState:PlayAnimation("spawn")
    inst.AnimState:PushAnimation("idle1",true)
	
	inst.components.timer:StartTimer("defusetime", time)
end

local function fn(pondtype)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddLight()    
    inst.entity:AddNetwork()

    inst.AnimState:SetBuild("moonglass_charged_tile")
    inst.AnimState:SetBank("moonglass_charged")
    inst.AnimState:PlayAnimation("idle1", true)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(3)

    inst.Light:SetColour(111/255, 111/255, 227/255)
    inst.Light:SetIntensity(0.5)
    inst.Light:SetFalloff(0.5)
    inst.Light:SetRadius(2)
    inst.Light:Enable(true)

    inst:AddTag("moonglass")

    --inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")

    inst.MiniMapEntity:SetIcon("pond.png")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("named")

	inst.SoundEmitter:PlaySound("moonstorm/creatures/boss/alterguardian3/atk_traps")
		
    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = getstatus

    local TIME = 1.5

    inst:AddComponent("timer")
    --inst.components.timer:StartTimer("defusetime", TIME)
    inst:ListenForEvent("timerdone", ontimedone)

    inst:AddComponent("updatelooper")
    inst.components.updatelooper:AddOnUpdateFn(function()
        local time = inst.components.timer:GetTimeLeft("defusetime")
        if time then
            if time/TIME > 0.1 and time/TIME < 0.3 then
                if not inst.AnimState:IsCurrentAnimation("idle2_loop") then
                    inst.AnimState:PlayAnimation("idle2_loop",true)
                end            
            elseif time/TIME < 0.5 then
                if not inst.AnimState:IsCurrentAnimation("idle1_loop") then
                    inst.AnimState:PlayAnimation("idle1_loop",true)
                end
            elseif time/TIME < 0.9 then
                if not inst.AnimState:IsCurrentAnimation("idle1") then
                    inst.AnimState:PlayAnimation("idle1",true)   
                end
            end
        end
    end)


    inst.OnSave = on_save
    inst.OnLoad = on_load
    inst.spawnin = spawnin
	inst.spawnlong = spawnlong
	inst:DoTaskInTime(0.1, function(inst) if inst.caster == nil then inst:Remove() end end)
    return inst
end

return Prefab("moonmaw_glass", fn)