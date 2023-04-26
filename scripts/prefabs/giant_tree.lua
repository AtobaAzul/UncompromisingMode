require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/giant_tree1.zip"),
	Asset("ANIM", "anim/giant_tree1_damaged.zip"),
	Asset("ANIM", "anim/giant_tree2_damaged.zip"),
	Asset("ANIM", "anim/giant_tree2.zip"),
	Asset("ANIM", "anim/giant_tree1_sick.zip"),
	Asset("ANIM", "anim/giant_tree2_sick.zip"),
}
local CANOPY_SHADOW_DATA = require("prefabs/canopyshadows")

-----------------------------Canopy and Lightning Handling
local DROP_ITEMS_DIST_MIN = 6
local DROP_ITEMS_DIST_VARIANCE = 10

local NUM_DROP_SMALL_ITEMS_MIN_LIGHTNING = 3
local NUM_DROP_SMALL_ITEMS_MAX_LIGHTNING = 5

local DROPPED_ITEMS_SPAWN_HEIGHT = 10

local function removecanopyshadow(inst)
    if inst.canopy_data ~= nil then
        for _, shadetile_key in ipairs(inst.canopy_data.shadetile_keys) do
            if TheWorld.shadetiles[shadetile_key] ~= nil then
                TheWorld.shadetiles[shadetile_key] = TheWorld.shadetiles[shadetile_key] - 1

                if TheWorld.shadetiles[shadetile_key] <= 0 then
                    if TheWorld.shadetile_key_to_leaf_canopy_id[shadetile_key] ~= nil then
                        DespawnLeafCanopy(TheWorld.shadetile_key_to_leaf_canopy_id[shadetile_key])
                        TheWorld.shadetile_key_to_leaf_canopy_id[shadetile_key] = nil
                    end
                end
            end
        end

        for _, ray in ipairs(inst.canopy_data.lightrays) do
            ray:Remove()
        end
    end
end

local lightningprods =
{
    "twigs",
    "cutgrass",
    "oceantree_leaf_fx_fall",
    "oceantree_leaf_fx_fall",
    "oceantree_leaf_fx_fall",
    "oceantree_leaf_fx_fall",    
    "oceantree_leaf_fx_fall",
    "oceantree_leaf_fx_fall",      
}

local function removecanopy(inst)
    --print("REMOVING CANOPU")
    if inst.roots then
        inst.roots:Remove()
    end
    if inst._ripples then
        inst._ripples:Remove()
    end

    if inst.players ~= nil then
        for k, v in pairs(inst.players) do
            if k:IsValid() then
                if k.canopytrees ~= nil then
                    k.canopytrees = k.canopytrees - 1
                    if k.canopytrees <= 0 then
                        k:PushEvent("onchangecanopyzone", false)
                    end
                end
            end
        end
    end
    inst._hascanopy:set(false)    
end

local function DropLightningItems(inst, items)
    local x, _, z = inst.Transform:GetWorldPosition()
    local num_items = #items

    for i, item_prefab in ipairs(items) do
        local dist = DROP_ITEMS_DIST_MIN + DROP_ITEMS_DIST_VARIANCE * math.random()
        local theta = 2 * PI * math.random()

        inst:DoTaskInTime(i * 5 * FRAMES, function(inst2)
            local item = SpawnPrefab(item_prefab)
            item.Transform:SetPosition(x + dist * math.cos(theta), 20, z + dist * math.sin(theta))

            if i == num_items then
                inst._lightning_drop_task:Cancel()
                inst._lightning_drop_task = nil
            end 
        end)
    end
end

local function OnLightningStrike(inst)
    if inst._lightning_drop_task ~= nil then
        return
    end

    local num_small_items = math.random(NUM_DROP_SMALL_ITEMS_MIN_LIGHTNING, NUM_DROP_SMALL_ITEMS_MAX_LIGHTNING)
    local items_to_drop = {}

    for i = 1, num_small_items do
        table.insert(items_to_drop, lightningprods[math.random(1, #lightningprods)])
    end

    inst._lightning_drop_task = inst:DoTaskInTime(20*FRAMES, DropLightningItems, items_to_drop)
end
-----------------------------



-----------------------------Chop Loot Tables
local choploots = 
{
	oceantree_leaf_fx_fall = 4,
	twigs = 1,
	log = 0.5,
	frog = 0.05,
	spider = 0.005,
}

local felloots =
{
	log = 2,
	oceantree_leaf_fx_fall = 1,
	bird_egg = 0.5,
	feather = 0.5,
	spider = 0.01,
	frog = 0.05,
	giant_tree_birdnest = 0.025,
}
local infestedloots = 
{
	twigs = 1,
	aphid = 1,
	oceantree_leaf_fx_fall = 0.5,
	log = 0.5,
}
-----------------------------

----------------------------- Debris Handling
local QUAKEDEBRIS_CANT_TAGS = { "quakedebris" }
local QUAKEDEBRIS_ONEOF_TAGS = { "INLIMBO" }
local SMASHABLE_TAGS = { "smashable", "_combat" }
local NON_SMASHABLE_TAGS = { "INLIMBO", "playerghost", "irreplaceable" }
local function _GroundDetectionUpdate(debris, override_density)
    local x, y, z = debris.Transform:GetWorldPosition()
    if y <= .2 then
		if debris.prefab == "giant_tree_birdnest" then
			debris.AnimState:PlayAnimation("land_"..debris.egg)
			debris.AnimState:PushAnimation("idle_"..debris.egg)
			if not TheWorld.Map:IsVisualGroundAtPoint(x,y,z) then
				SpawnPrefab("splash").Transform:SetPosition(x,y,z)
				debris:Remove()
			end
		end
        if not debris:IsOnValidGround() then
            debris:PushEvent("detachchild")
            debris:Remove()
        else
            local softbounce = false
            if debris:HasTag("heavy") then
                local ents = TheSim:FindEntities(x, 0, z, 2, nil, HEAVY_NON_SMASHABLE_TAGS, HEAVY_SMASHABLE_TAGS)
                for i, v in ipairs(ents) do
                    if v ~= debris and v:IsValid() and not v:IsInLimbo() then
                        softbounce = true
                        if v.components.combat ~= nil then
                            v.components.combat:GetAttacked(debris, 30, nil)
                        elseif v.components.inventoryitem ~= nil then
                            if v.components.mine ~= nil then
                                v.components.mine:Deactivate()
                            end
                            Launch(v, debris, TUNING.LAUNCH_SPEED_SMALL/10)
                        end
                    end
                end
            else
                local ents = TheSim:FindEntities(x, 0, z, 2, nil, NON_SMASHABLE_TAGS, SMASHABLE_TAGS)
                for i, v in ipairs(ents) do
                    if v ~= debris and v:IsValid() and not v:IsInLimbo() then
                        softbounce = true
                        if v.components.combat ~= nil and not (v:HasTag("epic") or v:HasTag("wall")) then
                            v.components.combat:GetAttacked(debris, 20, nil)
                        end
                    end
                end
            end
            debris.Physics:SetDamping(.9)
            if softbounce then
                local speed = 3.2 + math.random()
                local angle = math.random() * 2 * PI
                debris.Physics:SetMotorVel(0, 0, 0)
                debris.Physics:SetVel(speed * math.cos(angle),speed * 2.3,speed * math.sin(angle))
            end
            debris.shadow:Remove()
            debris.shadow = nil
            debris.updatetask:Cancel()
            debris.updatetask = nil
            local density = override_density or DENSITYRADIUS
            if density <= 0 or
                debris.prefab == "mole" or
                debris.prefab == "rabbit" or
                not (math.random() < .75 or
                    #TheSim:FindEntities(x, 0, y, density, nil, QUAKEDEBRIS_CANT_TAGS, QUAKEDEBRIS_ONEOF_TAGS) > 1
                ) then
                --keep it
                
                debris.entity:SetCanSleep(true)
				if debris.components.inventoryitem then
					debris.components.inventoryitem.canbepickedup = true
				end
                debris:PushEvent("stopfalling")
				elseif debris.components.inventoryitem then
				debris.components.inventoryitem.canbepickedup = true
            end
        end
    elseif debris:GetTimeAlive() < 3 then
        if y < 2 then
            debris.Physics:SetMotorVel(0, 0, 0)
        end
        local scaleFactor = Lerp(.5, 1.5, y / 35)
		debris.shadow.Transform:SetScale(scaleFactor, scaleFactor, scaleFactor)
		if debris.components.inventoryitem ~= nil then
			debris.components.inventoryitem.canbepickedup = true
		end
    elseif debris:IsInLimbo() then
        --failsafe, but maybe we got trapped or picked up somehow, so keep it
        
        debris.entity:SetCanSleep(true)
        debris.shadow:Remove()
        debris.shadow = nil
        debris.updatetask:Cancel()
        debris.updatetask = nil
        if debris._restorepickup then
            debris._restorepickup = nil
            if debris.components.inventoryitem ~= nil then
                debris.components.inventoryitem.canbepickedup = true
            end
        end
        debris:PushEvent("stopfalling")
		if debris.components.inventoryitem ~= nil then
			debris.components.inventoryitem.canbepickedup = true
		end
    end
end

local function GetDebris(loottable)
	local loot = weighted_random_choice(loottable)
	if loot == "feather" then
		if math.random() > 0.5 then
		loot = "feather_crow"
		else
			if math.random() > 0.25 then
				if not TheWorld.state.iswinter then
				loot = "feather_robin"
				else
				loot = "feather_robin_winter"
				end
			else
			loot = "feather_canary"
			end
		end
	end
	if loot == "frog" and not TheWorld.state.isspring then
		loot = GetDebris(loottable)
	end
	return loot
end


local function SpawnDebris(inst,chopper,loottable)
	local x,y,z = inst.Transform:GetWorldPosition()
	
	local radius = math.random(3,5)
	local angle = math.random(0,2*PI)
	x = x + radius*math.sin(angle)
	z = z + radius*math.cos(angle)

	local prefab = GetDebris(loottable)
    if prefab ~= nil and prefab ~= "oceantree_leaf_fx_fall" and prefab ~= "frog" then
        local debris = SpawnPrefab(prefab)
        if debris ~= nil then
            debris.entity:SetCanSleep(false)
            
			debris:AddTag("quakedebris")
            if debris.components.inventoryitem ~= nil and debris.components.inventoryitem.canbepickedup then
                debris.components.inventoryitem.canbepickedup = false
                debris._restorepickup = true
            end
            if math.random() < .5 then
                debris.Transform:SetRotation(180)
            end
			if debris.prefab == "giant_tree_birdnest" then
				debris.egg = math.random(1,3)
				debris.AnimState:PlayAnimation("falling"..debris.egg)
			end
			if not (debris:HasTag("spider") or debris:HasTag("aphid")) then
				debris.Physics:Teleport(x, 35, z)
				debris.shadow = SpawnPrefab("warningshadow")
				debris.shadow:ListenForEvent("onremove", function(debris) debris.shadow:Remove() end, debris)
				debris.shadow.Transform:SetPosition(x, 0, z)
				local scaleFactor = Lerp(.5, 1.5, 1)
				debris.shadow.Transform:SetScale(scaleFactor, scaleFactor, scaleFactor)
				debris.updatetask = debris:DoPeriodicTask(FRAMES, _GroundDetectionUpdate, nil, 5)																			
			else
				if TheWorld.Map:IsVisualGroundAtPoint(x,y,z) then
					if debris:HasTag("spider") then
						debris.Physics:Teleport(x, y, z)
						debris.sg:GoToState("dropper_enter")
						if debris.components.combat ~= nil and not chopper:HasTag("spiderwhisperer") then
							debris.components.combat:SuggestTarget(chopper)
						end
					end
					if debris:HasTag("aphid") then
						debris.Physics:Teleport(x, y, z)
						if debris.components.combat ~= nil and not chopper:HasTag("spiderwhisperer") then
							debris.components.combat:SuggestTarget(chopper)
						end
						debris.sg:GoToState("enter_loop")
					end
				else
					debris:Remove()
				end
			end
		end
	end
	
	if prefab == "frog" then
		local debris = SpawnPrefab(prefab)
		debris.Physics:Teleport(x, 35, z)
		debris.sg:GoToState("fall")
    end
	
	if prefab == "oceantree_leaf_fx_fall" then
	    local dist = DROP_ITEMS_DIST_MIN + DROP_ITEMS_DIST_VARIANCE * math.random()
        local theta = 2 * PI * math.random()
        inst:DoTaskInTime(5 * FRAMES, function(inst2)
            local item = SpawnPrefab("oceantree_leaf_fx_fall")
            item.Transform:SetPosition(x + dist * math.cos(theta), 20, z + dist * math.sin(theta))
		end)
	end
end
-----------------------------


-----------------------------Infest Handlers
local function InfestMe(inst)
	inst:AddTag("infestedtree")
    inst:AddComponent("childspawner")
    inst.components.childspawner.childname = "aphid"
    inst.components.childspawner:SetRegenPeriod(TUNING.SPIDERDEN_REGEN_TIME)
    inst.components.childspawner:SetSpawnPeriod(TUNING.SPIDERDEN_RELEASE_TIME)
    inst.components.childspawner.allowboats = true
	inst.infested = true
	inst:PickBuild(inst)
end

local function UnInfestMe(inst)
	inst:RemoveTag("infestedtree")
	inst:RemoveComponent("childspawner")
	inst.infested = false
	inst:PickBuild(inst)
end

local function InfestedInit(inst)
	if inst.infested and inst.infested then
		inst:AddTag("infestedtree")
		inst:AddComponent("childspawner")
		inst.components.childspawner.childname = "aphid"
		inst.components.childspawner:SetRegenPeriod(TUNING.SPIDERDEN_REGEN_TIME)
		inst.components.childspawner:SetSpawnPeriod(TUNING.SPIDERDEN_RELEASE_TIME)
		inst.components.childspawner.allowboats = true
	else
		inst.infested = false
	end
end
-----------------------------

-----------------------------Workable handling
local function on_chop(inst, chopper, remaining_chops)
    if not (chopper ~= nil and chopper:HasTag("playerghost")) then
        inst.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_tree")
    end
	local phase = 0
	if not (chopper:HasTag("epic") or chopper:HasTag("antlion_sinkhole")) then
		local oldchops = inst.previouschops or 24
		inst.previouschops = remaining_chops
		if (oldchops+inst.partchops-remaining_chops) >= 1 then
			local queuedchops = (oldchops+inst.partchops-remaining_chops)
			for k = 1, (oldchops+inst.partchops-remaining_chops) do
				if inst:HasTag("infestedtree") then
					SpawnDebris(inst,chopper,infestedloots)
				else
					SpawnDebris(inst,chopper,choploots)
					if (oldchops+inst.partchops-remaining_chops)-k < 1 and (oldchops+inst.partchops-remaining_chops)-k > 0  then
						inst.partchops = (oldchops+inst.partchops-remaining_chops)-k
					else
						inst.partchops = 0
					end
				end
			end
		elseif (oldchops - remaining_chops) < 1 then
			inst.partchops = (oldchops-remaining_chops)--This accounts for characters like wes and our winona doing partial works
		end
		
		if remaining_chops >= 15 and remaining_chops < 20 then
			phase = 1
		end
		if remaining_chops >= 10 and remaining_chops < 15 then
			phase = 1
		end
		if remaining_chops >= 5 and remaining_chops < 10 then
			phase = 2
		end	
		if remaining_chops > 0 and remaining_chops < 5 then
			phase = 3
		end		
		if remaining_chops == 0 or remaining_chops < 0 then
			phase = 4
		end			
		--TheNet:Announce("I told new anim")
		--inst.AnimState:PlayAnimation("damaged-"..phase,true)	
	end
end

local function BringTheForestDown(inst,chopper)--!
	for i = 1, math.random(2,3) do
		SpawnDebris(inst,chopper,felloots)
		inst:DoTaskInTime(math.random(1,2),SpawnDebris(inst,chopper,felloots))
		inst:DoTaskInTime(math.random(4,5),SpawnDebris(inst,chopper,felloots))
	end
end

local function on_chopped_down(inst, chopper)
	if chopper:HasTag("epic") or chopper:HasTag("antlion_sinkhole") then
		inst:AddComponent("workable")
		inst.components.workable:SetWorkAction(ACTIONS.CHOP)
		inst.components.workable:SetWorkLeft(inst.previouschops)
		inst.components.workable:SetOnWorkCallback(on_chop)
		inst.components.workable:SetOnFinishCallback(on_chopped_down)
		inst.AnimState:PlayAnimation("idle")
	else
		inst.previouschops = 0
		inst.chopped = true
		inst.SoundEmitter:PlaySound("dontstarve/forest/appear_wood")
		inst.SoundEmitter:PlaySound("dontstarve/forest/treeCrumble",nil,.4)
		inst:RemoveComponent("workable")
		BringTheForestDown(inst,chopper)--!
		if inst:HasTag("infestedtree") then
			UnInfestMe(inst)
			inst:RemoveComponent("workable")
		end
		inst.AnimState:SetBuild("giant_tree"..inst.bankType.."_damaged")
		inst.AnimState:PlayAnimation("idle")
		inst.components.timer:StartTimer("regrow", 3840)
		if inst.mossy then
			inst.HideAllMoss(inst,true)
		else
			inst.HideAllMoss(inst)
		end
		if inst.components.timer:TimerExists("remoss") then
			inst.components.timer:StopTimer("remoss")
		end
		inst.components.timer:StartTimer("remoss", 4800) --10 days to regrow moss
	end
end
-----------------------------


-----------------------------Spawner Handling
local function StartSpawning(inst)
    if inst.components.childspawner then
        inst.components.childspawner:StartSpawning()
    end
end

local function StopSpawning(inst)
    if inst.components.childspawner ~= nil then
        inst.components.childspawner:StopSpawning()
    end
end

local function OnIsNight(inst, isnight)
    if isnight then
        StopSpawning(inst)
    else
        StartSpawning(inst)
    end
end

local function SpawnerInit(inst)
    inst:WatchWorldState("isnight", OnIsNight)
    OnIsNight(inst, TheWorld.state.isnight)
end
-----------------------------


----------------------------- Animation Handling


local mosses = {
	"mossa",
	"mossb",
	"mossc",
	"mossd",
	"mosse",
	"mossf",
	"mossg",
	"mossh",
	"mossi",
}

local function HideAllMoss(inst,poof) --Depricated
	--TheNet:Announce("inst.mossy is false")
	for i,moss in ipairs(mosses) do
		if poof and poof then
			local pine = SpawnPrefab("pine_needles_chop")
			pine.entity:AddFollower()
			pine.Follower:FollowSymbol(inst.GUID, moss, 0, 0, 0)
		end	
		inst.AnimState:HideSymbol(moss)
	end
end

local function ShowAllMoss(inst,poof)
	--TheNet:Announce("inst.mossy is true")
	inst.mossy = true
	for i,moss in ipairs(mosses) do
		if poof and poof then
			local pine = SpawnPrefab("pine_needles_chop")
			pine.entity:AddFollower()
			pine.Follower:FollowSymbol(inst.GUID, moss, 0, 0, 0)
		end		
		inst.AnimState:ShowSymbol(moss)
	end
end

local function PickType(inst)
	inst.bankType = math.random(1,2) --RN only have 2 type
	if math.random() > 0.6 then
		inst.reverse = true
	end
	inst.stretchx = math.random(-0.1,0.1)
	inst.stretchy = math.random(-0.1,0.1)
	if math.random() > 0.9 then
		ShowAllMoss(inst,false)
	else
		inst.components.timer:StartTimer("remoss", 3000+math.random(1000,4000))
		HideAllMoss(inst,false)
	end
end

local function AnimNext(inst)
	if inst.components.workable and inst.components.workable:CanBeWorked() then
		inst.AnimState:PlayAnimation("idle")
	else
		inst.AnimState:SetBuild("giant_tree"..inst.bankType.."_damaged")
		inst.AnimState:PlayAnimation("idle")
	end
end

local function PickBuild(inst)
	local bank
	if inst.bankType then
		bank = "giant_tree"..inst.bankType
		if inst.components.workable then
			bank = "giant_tree"..inst.bankType
		else
			bank = "giant_tree"..inst.bankType.."_damaged"
		end
		if inst.infested then
			bank = bank.."_sick"
		end
		inst.AnimState:SetBank("giant_tree")
		inst.AnimState:SetBuild(bank)
		inst.AnimState:PlayAnimation("idle")
		local mult = 1
		if inst.reverse then
			mult = -1
		end
		inst.AnimState:SetScale(mult*(1 + inst.stretchx), 1+inst.stretchy)
		
		AnimNext(inst)
	else
		PickType(inst)
		PickBuild(inst)
	end
end
-----------------------------

-----------------------------Regrowth Timer Handler
local function Regrow(inst, data)
	if data.name == "regrow" then
		inst.chopped = false
		inst:AddComponent("workable")
		inst.components.workable:SetWorkAction(ACTIONS.CHOP)
		inst.components.workable:SetWorkLeft(25)
		inst.components.workable:SetOnWorkCallback(on_chop)
		inst.components.workable:SetOnFinishCallback(on_chopped_down)
		inst.AnimState:PlayAnimation("idle")
		PickBuild(inst)
	end
	if data.name == "infest" then
		InfestMe(inst)
	end
	if data.name == "remoss" then
		ShowAllMoss(inst,true)
	end
end
-----------------------------

---------------------------------- Saving and loading 
local function onsave(inst, data)
	data.previouschops = inst.previouschops
	data.chopped = inst.chopped
	data.bankType = inst.bankType
	data.infested = inst.infested
	data.stretchx = inst.stretchx
	data.stretchy = inst.stretchy
	if inst.reverse then
		data.reverse = inst.reverse
	end
	data.mossy = inst.mossy
end

local function onload(inst,data)
	if data then
		inst.previouschops = data.previouschops
		if data.chopped then
			inst:RemoveComponent("workable")
		end
		if data.bankType then
			inst.bankType = data.bankType
		end
		if data.infested then
			inst.infested = data.infested
		end
		if data.reverse then
			inst.reverse = true
		end
		if data.stretchx then
			inst.stretchx = data.stretchx
		end
		if data.stretchy then
			inst.stretchy = data.stretchy
		end
		if data.mossy then
			inst.mossy = data.mossy
			ShowAllMoss(inst)
		else
			HideAllMoss(inst)
		end
	else
		inst.previouschops = 25
	end
end
----------------------------------

----------------------------------
--Glorious Tree Main Function GTMF
----------------------------------

local function giant_treefn()
    local inst = CreateEntity()
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
	inst.entity:AddSoundEmitter()
	inst.entity:AddMiniMapEntity()
	inst.entity:AddDynamicShadow()
	
	inst.MiniMapEntity:SetIcon("giant_tree.tex")
    inst.MiniMapEntity:SetPriority(-1)
    MakeObstaclePhysics(inst, 2.35)
	

	inst:AddTag("tree")
	inst:AddTag("giant_tree")
	inst:AddTag("shadecanopysmall")
	inst:AddTag("antlion_sinkhole_blocker")
	
    if not TheNet:IsDedicated() then
        inst:AddComponent("distancefade")
        inst.components.distancefade:Setup(15,25)
    end
    
    inst._hascanopy = net_bool(inst.GUID, "oceantree_pillar._hascanopy", "hascanopydirty")
    inst._hascanopy:set(true)    
    inst:DoTaskInTime(0, function()    
        inst.canopy_data = CANOPY_SHADOW_DATA.spawnshadow(inst, math.floor(TUNING.SHADE_CANOPY_RANGE_SMALL/4), true)
    end)

    inst:ListenForEvent("hascanopydirty", function()
        if not inst._hascanopy:value() then 
			removecanopyshadow(inst) 
        end
    end)
		
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then        
        return inst
    end
	inst:DoTaskInTime(0,PickBuild)
	----------------------------------	
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.CHOP)
	inst.components.workable:SetWorkLeft(25)
	inst.components.workable:SetOnWorkCallback(on_chop)
	inst.components.workable:SetOnFinishCallback(on_chopped_down)
	----------------------------------
	inst:AddComponent("timer")
	inst:ListenForEvent("timerdone", Regrow)
	----------------------------------
	inst:AddComponent("inspectable")
	inst.previouschops = nil
		
	inst.partchops = 0
	inst.OnSave = onsave
	inst.OnLoad = onload
	inst:AddComponent("lightningblocker")
	inst.components.lightningblocker:SetBlockRange(TUNING.SHADE_CANOPY_RANGE_SMALL)
	inst.components.lightningblocker:SetOnLightningStrike(OnLightningStrike)
	
	inst:DoTaskInTime(0, SpawnerInit)
	inst:DoTaskInTime(0, InfestedInit)
	
	inst.PickBuild = PickBuild
	inst.HideAllMoss = HideAllMoss
	inst:DoTaskInTime(math.random(0,0.1),function(inst) --Keep giant trees spaced out
		if FindEntity(inst,2^2,nil,{"giant_tree"}) then
			inst:Remove()
		end
	end)
	
	--[[inst:DoTaskInTime(1,function(inst) 
		if inst.mossy then
			if inst.mossy then
				TheNet:Announce("inst.mossy is true")
			else
				TheNet:Announce("inst.mossy is false")
			end
		else
			TheNet:Announce("inst.mossy is nil")
		end
	end)]]
	inst:ListenForEvent("animover",AnimNext)
	return inst
end

local function MakeInfestedTree_gen(inst)
	local x,y,z = inst.Transform:GetWorldPosition()
	local infested_tree = SpawnPrefab("giant_tree")
	infested_tree.Transform:SetPosition(x,y,z)
	infested_tree.infested = true
end

local function infestedfn()
    local inst = CreateEntity()
	inst.entity:AddTransform()
    inst.entity:AddNetwork()
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then        
        return inst
    end
	
	inst:DoTaskInTime(0,MakeInfestedTree_gen)
	return inst
end

return Prefab("giant_tree", giant_treefn, assets),
	Prefab("giant_tree_infested", infestedfn, assets)