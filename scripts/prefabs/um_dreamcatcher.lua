require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/um_dreamcatcher.zip"),
	Asset("ANIM", "anim/brineish_moss.zip"),
}
local damage_time = 20*8*60

local function PunishTheCoward(inst,channeler,RNEs) --Can tune this, this is a bit complex so whether or not the first removal should 
	if not RNEs.punish then
		RNEs.punish = 0
	end
	if channeler.components.sanity then
		if channeler:HasTag("Funny_Words_Magic_Man") then
			channeler.components.sanity:DoDelta(-5)
		else
			channeler.components.sanity:DoDelta(-15)
		end
	end
	if RNEs.punish > 0 then
		channeler.components.health:DeltaPenalty(0.2)
	end
	if RNEs.punish > 1 then
		channeler.components.health:DeltaPenalty(0.4)
		RNEs.punish = RNEs.punish + 1
	end	
	if RNEs.punish > 2 then
		channeler.components.health:DeltaPenalty(0.8)
		RNEs.punish = RNEs.punish + 1
	end	
	if RNEs.punish > 3 then
		channeler.components.health:DeltaPenalty(1)
		channeler.components.health:Kill()
		--Consider spawning random RNE creatures here for the occasion?, maybe in the other cases too.....
	end
	channeler.sg:GoToState("hit_darkness")
	RNEs.punish = RNEs.punish + 1
end

local function OnStartChanneling(inst, channeler)
	local RNEs = TheWorld.components.randomnightevents or TheWorld.components.randomnighteventscaves or nil
	if RNEs then
		inst.Damage(inst)
		PunishTheCoward(inst,channeler,RNEs)
		if RNEs.punish < 3 then --Only works if you haven't been doing it forever
			RNEs.rnequeued = false
		end
		inst.calm(inst)
		inst.check(inst)
		if channeler.components.inventory then
			local nightmare = SpawnPrefab("um_coalesced_nightmare")
			channeler.components.inventory:GiveItem(nightmare,nil,inst:GetPosition())
		end
		inst.components.channelable.enabled = false
	end
end

local function OnStopChanneling(inst, aborted)

end


local function onhammered(inst)
    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
        inst.components.burnable:Extinguish()
    end
    inst.components.lootdropper:DropLoot()
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst:Remove()
end

local function onhit(inst)
	if not inst.burnt then
		--inst.AnimState:PlayAnimation("hit_"..inst.state)
		inst.AnimState:PushAnimation("idle_"..inst.stage)
	end
end

local function onbuilt(inst)
    --inst.SoundEmitter:PlaySound("dontstarve/common/together/town_portal/craft")
    --inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("idle_"..inst.stage,true)
end

local function GetStatus(inst)
    return (inst.components.channelable) and "ACTIVE"
        or nil
end

local function ShowFx(inst, state)
	local RNEs = TheWorld.components.randomnightevents or TheWorld.components.randomnighteventscaves or nil
    if inst._gatefx == nil then
        inst._gatefx = SpawnPrefab("atrium_gate_activatedfx")
        --inst._gatefx.entity:SetParent(inst.entity)
		inst._gatefx.entity:AddFollower()
		inst._gatefx.Transform:SetScale(0.5,0.5,0.5)
    end
	if RNEs.punish and RNEs.punish ~= 0 then
		inst._gatefx.Follower:FollowSymbol(inst.GUID, "dreams", 0, 250+RNEs.punish*60, 0)
		inst._gatefx.Transform:SetScale(RNEs.punish/10+0.5,RNEs.punish/10+0.5,RNEs.punish/10+0.5)
	else
		inst._gatefx.Follower:FollowSymbol(inst.GUID, "dreams", 0, 250, 0)
	end
    inst._gatefx:SetFX(state)
end

local function HideFx(inst)
    if inst._gatefx ~= nil then
        inst._gatefx:KillFX()
        inst._gatefx = nil
    end
end

local function Check(inst)
	--TheNet:Announce("checking")
	if TheWorld.state.isdusk or TheWorld.state.isnight then
		local RNEs = TheWorld.components.randomnightevents or TheWorld.components.randomnighteventscaves or nil
		if RNEs and inst.stage ~= "empty" and not inst.burnt then
			--TheNet:Announce("foundrnecomponent")
			if RNEs.rnequeued then
				inst.panic = true
				--TheNet:Announce("panicking")
				ShowFx(inst, "idle")
				inst.AnimState:PlayAnimation("channel_"..inst.stage,true)
				if not TheWorld.state.isnight then
					inst.components.channelable.enabled = true
					inst.components.channelable:SetChannelingFn(OnStartChanneling, OnStopChanneling)
					inst.components.channelable.use_channel_longaction_noloop = true
					inst.components.channelable.skip_state_channeling = true
				end
			end
		end
	else
		inst.components.channelable.enabled = false
	end
end


local function CalmIfNeeded(inst)
	if inst.panic then
		inst.panic = false
		if not inst.burnt then
			inst.AnimState:PlayAnimation("idle_"..inst.stage,true)
		end
		HideFx(inst)
		if inst.components.channelable then
			inst.components.channelable.enabled = false
		end
	end
end

local function OnGetItem(inst, giver, item)
	inst.Repair(inst)
end

local function ShouldAcceptItem(inst, item)
    return item:HasTag("magic_moss")
end

local function Damage(inst)
	if not inst.burnt then
		if inst.stage == "notmuch" then
			inst.stage = "empty"
		end
		if inst.stage == "med" then
			inst.stage = "notmuch"
		end
		if inst.stage == "full" then
			inst:AddComponent("trader")
			inst.components.trader:SetAcceptTest(ShouldAcceptItem)
			inst.components.trader.onaccept = OnGetItem	
			inst.stage = "med"
		end
		
		if inst.components.timer:TimerExists("damage") then
			inst.components.timer:StopTimer("damage")
		end
		inst.components.timer:StartTimer("damage",damage_time)
		inst.AnimState:PlayAnimation("idle_"..inst.stage,true)
		Check(inst)
		CalmIfNeeded(inst)
	end
end

local function Repair(inst)
	if not inst.burnt then
		if inst.stage == "full" then
			if inst.components.trader then
				inst:RemoveComponent("trader")
			end
		end
		if inst.stage == "med" then
			inst.stage = "full"
			if inst.components.trader then
				inst:RemoveComponent("trader")
			end
		end
		if inst.stage == "notmuch" then
			inst.stage = "med"
		end
		if inst.stage == "empty" then
			inst.stage = "notmuch"
		end
		if inst.components.timer:TimerExists("damage") then
			inst.components.timer:StopTimer("damage")
		end
		inst.components.timer:StartTimer("damage",damage_time)
		inst.AnimState:PlayAnimation("idle_"..inst.stage,true)
		Check(inst)
		CalmIfNeeded(inst)
	end
end

local function ChangeToBurnt(inst)
	inst.burnt = true
	HideFx(inst)
	if inst.components.channelable then
		inst.components.channelable.enabled = false
	end	
	inst.AnimState:PlayAnimation("idle_burnt")
	if inst.components.burnable then
		inst:RemoveComponent("burnable")
	end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst.MiniMapEntity:SetIcon("townportal.png")

    MakeObstaclePhysics(inst, .1)

    inst.AnimState:SetBank("um_dreamcatcher")
    inst.AnimState:SetBuild("um_dreamcatcher")
    --inst.AnimState:PlayAnimation("idle_full", true)

    inst:AddTag("structure")
	inst:AddTag("um_dreamcatcher")
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    -----------------------
    MakeHauntableWork(inst)

    -------------------------
    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)

    inst:AddComponent("channelable")
    --inst.components.channelable:SetChannelingFn(OnStartChanneling, OnStopChanneling)


    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = GetStatus

    -----------------------------
    inst:ListenForEvent("onbuilt", onbuilt)
	inst:WatchWorldState("isdusk", function() inst:DoTaskInTime(2, Check) end) -- Dusk has happened, check rnes after a moment
	inst:WatchWorldState("isday", function() inst:DoTaskInTime(0, CalmIfNeeded) end) -- Daytime, if I'm panicking I need to stop
	inst:WatchWorldState("isnight", function() inst:DoTaskInTime(0, function(inst)
				inst.components.channelable.enabled = false --Nighttime, all bets are off, can't remove RNE now
		end)
	end)
	
	inst:AddComponent("timer")
	inst:DoTaskInTime(0,function(inst)
		local RNEs = TheWorld.components.randomnightevents or TheWorld.components.randomnighteventscaves or nil --Need to insert into table so that we can reference it via a dropped coalesced nightmare.
		table.insert(RNEs.dreamcatchers,inst)
		
		if not inst.stage then
			inst.stage = "full"
		end
		if not inst.burnt == true then
			inst.AnimState:PlayAnimation("idle_"..inst.stage,true)
		end
		Check(inst)
		if not inst.components.timer:TimerExists("damage") then
			inst.components.timer:StartTimer("damage", damage_time)
		end
	end)
	
	inst.OnSave = function(inst,data)
		data.stage = inst.stage
		if inst.burnt or (inst.components.burnable and inst.components.burnable:IsBurning()) then
			data.burnt = true
		end
	end
	inst.OnLoad = function(inst,data)
		if data.stage then
			inst.stage = data.stage
		end
		if inst.stage ~= "full" then
			inst:AddComponent("trader")
			inst.components.trader:SetAcceptTest(ShouldAcceptItem)
			inst.components.trader.onaccept = OnGetItem
		end
		if data.burnt then
			inst:AddTag("burnt")
			ChangeToBurnt(inst)
		end
	end
	
	inst.check = Check
	inst.calm = CalmIfNeeded
	inst.Damage = Damage
	inst.Repair = Repair
	
	inst:ListenForEvent("timerdone", Damage)
	MakeLargeBurnable(inst, nil, nil, true)
	MakeLargePropagator(inst)
	inst.components.burnable:SetOnBurntFn(ChangeToBurnt)
	
    return inst
end


local function fnmoss(inst)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("brineish_moss")
    inst.AnimState:SetBuild("brineish_moss")
    inst.AnimState:PlayAnimation("idle")


    MakeInventoryFloatable(inst, "med", 0.05, 0.6)
	inst:AddTag("magic_moss")
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end


    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.SMALL_FUEL

    MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
	
    MakeHauntableLaunchAndIgnite(inst)

    inst:AddComponent("inspectable")
	inst:AddComponent("tradable")
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/um_brineishmoss.xml"

    return inst
end

local function fnnightmare(inst)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("nightmarefuel")
    inst.AnimState:SetBuild("nightmarefuel")
    inst.AnimState:PlayAnimation("idle_loop",true)


    MakeInventoryFloatable(inst, "med", 0.05, 0.6)
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end


    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
	
	inst:ListenForEvent("ondropped",function(inst) 
		inst:DoTaskInTime(math.random(4,6), function(inst)
			if inst.components.inventoryitem and not inst.components.inventoryitem:IsHeld() then
				SpawnPrefab("shadow_despawn").Transform:SetPosition(inst.Transform:GetWorldPosition())
				local RNEs = TheWorld.components.randomnightevents or TheWorld.components.randomnighteventscaves or nil
				if RNEs then
					RNEs.rnequeued = true
					if RNEs.dreamcatchers then
						for i,v in ipairs(RNEs.dreamcatchers) do
							if v then
								v.check(v) -- Hey uh..... I just added the RNE back so.... you'd probably want to start panicking
							end
						end			
					end				
				end
				inst:Remove()
			end
		end)
	end)

    return inst
end

return Prefab("um_dreamcatcher", fn, assets),
	Prefab("um_brineishmoss",fnmoss),
	Prefab("um_coalesced_nightmare",fnnightmare)
    --MakePlacer("um_dreamcatcher_placer", "um_dreamcatcher", "um_dreamcatcher", "idle_place")
