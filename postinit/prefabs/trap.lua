local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

env.AddPrefabPostInit("trap", function(inst) 
	if not TheWorld.ismastersim then
		return
	end
	
	inst.entity:SetCanSleep(false)
end)

local rabbitsounds =
{
    scream = "dontstarve/rabbit/scream",
    hurt = "dontstarve/rabbit/scream_short",
}

local wintersounds =
{
    scream = "dontstarve/rabbit/winterscream",
    hurt = "dontstarve/rabbit/winterscream_short",
}

local function IsWinterRabbit(inst)
    return inst.sounds == wintersounds
end

local function BecomeRabbit(inst)
    if inst.components.health:IsDead() then
        return
    end
    inst.AnimState:SetBuild("rabbit_build")
    inst.sounds = rabbitsounds
    if inst.components.hauntable ~= nil then
        inst.components.hauntable.haunted = false
    end
end

local function BecomeWinterRabbit(inst)
    if inst.components.health:IsDead() then
        return
    end
    inst.AnimState:SetBuild("rabbit_winter_build")
    inst.sounds = wintersounds
    if inst.components.hauntable ~= nil then
        inst.components.hauntable.haunted = false
    end
end

local function OnIsWinter(inst, iswinter)
    if inst.task ~= nil then
        inst.task:Cancel()
        inst.task = nil
    end
    if iswinter then
        if not IsWinterRabbit(inst) then
            inst.task = inst:DoTaskInTime(math.random() * .5, BecomeWinterRabbit)
        end
    elseif IsWinterRabbit(inst) then
        inst.task = inst:DoTaskInTime(math.random() * .5, BecomeRabbit)
    end
end

local function OnWake(inst)
    inst:WatchWorldState("iswinter", OnIsWinter)
    if inst.task ~= nil then
        inst.task:Cancel()
        inst.task = nil
    end
    if TheWorld.state.iswinter then
        if not IsWinterRabbit(inst) then
            BecomeWinterRabbit(inst)
        end
    elseif IsWinterRabbit(inst) then
        BecomeRabbit(inst)
    end
end

local function OnSleep(inst)
    inst:StopWatchingWorldState("iswinter", OnIsWinter)
    if inst.task ~= nil then
        inst.task:Cancel()
        inst.task = nil
    end
end

local function Wakey(inst)
	OnWake(inst)
end

local function Sleepy(inst)
	OnSleep(inst)
end

env.AddPrefabPostInit("rabbit", function(inst) 
	if not TheWorld.ismastersim then
		return
	end
	
	inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(60,62)
    inst.components.playerprox:SetOnPlayerNear(Wakey)
    inst.components.playerprox:SetOnPlayerFar(Sleepy)
	
end)

env.AddPrefabPostInit("rabbithole", function(inst) 
	if not TheWorld.ismastersim then
		return
	end
	
	inst.entity:SetCanSleep(false)
end)

