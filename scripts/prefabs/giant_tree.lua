require "prefabutil"
local CANOPY_SHADOW_DATA = require("prefabs/canopyshadows")

-----------------Nabbed canopy code
local LEAF_FALL_FX_OFFSET_MIN = 3.5
local LEAF_FALL_FX_OFFSET_VARIANCE = 2

local MIN = TUNING.SHADE_CANOPY_RANGE_SMALL
local MAX = MIN + TUNING.WATERTREE_PILLAR_CANOPY_BUFFER

local DROP_ITEMS_DIST_MIN = 6
local DROP_ITEMS_DIST_VARIANCE = 10

local NUM_DROP_SMALL_ITEMS_MIN = 20
local NUM_DROP_SMALL_ITEMS_MAX = 35

local NUM_DROP_SMALL_ITEMS_MIN_RAM = 10
local NUM_DROP_SMALL_ITEMS_MAX_RAM = 14

local NUM_DROP_SMALL_ITEMS_MIN_LIGHTNING = 3
local NUM_DROP_SMALL_ITEMS_MAX_LIGHTNING = 5

local DROPPED_ITEMS_SPAWN_HEIGHT = 10
local function OnFar(inst)
    if inst.players then
        local x, y, z = inst.Transform:GetWorldPosition()
        local testset = {}
        for player,i in pairs(inst.players)do
            testset[player] = true        
        end

        for i,player in ipairs(FindPlayersInRangeSq(x, y, z, MAX*MAX))do
            if testset[player] then
                testset[player] = false
            end
        end

        for player,i in pairs(testset)do
            if i == true then
                if player.canopytrees then
                   player.canopytrees = player.canopytrees - 1
                   if player.canopytrees == 0 then
                       player:PushEvent("onchangecanopyzone", false)
                   end
                end
                inst.players[player] = nil
            end
        end
    end
end

local function OnNear(inst,player)
    if not inst.players then
        inst.players = {}
    end

    inst.players[player] = true

    if not player.canopytrees then
        player.canopytrees = 0
    end
    player.canopytrees = player.canopytrees + 1
    if player.canopytrees == 1 then
        player:PushEvent("onchangecanopyzone", true)
    end
end

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

local small_ram_products =
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
    print("REMOVING CANOPU")
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
        table.insert(items_to_drop, small_ram_products[math.random(1, #small_ram_products)])
    end

    inst._lightning_drop_task = inst:DoTaskInTime(20*FRAMES, DropLightningItems, items_to_drop)
end
--------------------------

local function InitializePathFinding(inst)
	--print("I'm initializing pathfinding")
    local x, _, z = inst.Transform:GetWorldPosition()
	TheWorld.Pathfinder:AddWall(x, 0, z)
	for i = 0.25,10,0.25 do
		for j = 0.25,10,0.25 do
			TheWorld.Pathfinder:AddWall(x - i, 0, z - j)
			TheWorld.Pathfinder:AddWall(x - i, 0, z + j)
			TheWorld.Pathfinder:AddWall(x + i, 0, z - j)
			TheWorld.Pathfinder:AddWall(x + i, 0, z + j)
		end
    end
end


local assets =
{
Asset("ANIM", "anim/giant_tree.zip"),
Asset("ANIM", "anim/giant_tree_infested.zip"),
}
local choploot =
{
	--"fallingbeehive",
    "log",
	"log",
    "log",
	"log",
    "twigs",
	"twigs",
	"twigs",
    "twigs",
	"twigs",
	"twigs",
    "log",
	"log",
    "log",
	"log",
    "twigs",
	"twigs",
	"twigs",
    "twigs",
	"twigs",
	"twigs",
	"bird_egg",
	"feather",
	"spider",
	"oceantree_leaf_fx_fall",
	"oceantree_leaf_fx_fall",
	"oceantree_leaf_fx_fall",
	"oceantree_leaf_fx_fall",
	"oceantree_leaf_fx_fall",
	"oceantree_leaf_fx_fall",
	"oceantree_leaf_fx_fall",
	"oceantree_leaf_fx_fall",
	"oceantree_leaf_fx_fall",
	"oceantree_leaf_fx_fall",
	"oceantree_leaf_fx_fall",
	"oceantree_leaf_fx_fall",
	"oceantree_leaf_fx_fall",
	"oceantree_leaf_fx_fall",
	"oceantree_leaf_fx_fall",
	"oceantree_leaf_fx_fall",
	"oceantree_leaf_fx_fall",
	"oceantree_leaf_fx_fall",
}

local infestedloot =
{
	--"fallingbeehive",
    "log",
    "twigs",
    "log",
    "twigs",
	"twigs",
	"twigs",
    "twigs",
	"aphid",
	"aphid",
	"aphid",
	"aphid",
	"aphid",
	"oceantree_leaf_fx_fall",
	"oceantree_leaf_fx_fall",
	"oceantree_leaf_fx_fall",
}
--Code From quaker
local function _BreakDebris(debris)
    local x, y, z = debris.Transform:GetWorldPosition()
    SpawnPrefab("ground_chunks_breaking").Transform:SetPosition(x, 0, z)
    debris:Remove()
end 

local QUAKEDEBRIS_CANT_TAGS = { "quakedebris" }
local QUAKEDEBRIS_ONEOF_TAGS = { "INLIMBO" }
local SMASHABLE_TAGS = { "smashable", "_combat" }
local NON_SMASHABLE_TAGS = { "INLIMBO", "playerghost", "irreplaceable" }
local function _GroundDetectionUpdate(debris, override_density)
    local x, y, z = debris.Transform:GetWorldPosition()
    if y <= .2 then
		if debris:HasTag("hive") then
			if debris.components.health ~= nil then
			debris.components.health:Kill()
			--return -- We have to stop hive here
			end
		end
        if not debris:IsOnValidGround() then
            debris:PushEvent("detachchild")
            debris:Remove()
        else
            --PlayFallingSound(debris)

            -- break stuff we land on
            -- NOTE: re-check validity as we iterate, since we're invalidating stuff as we go
            local softbounce = false
            if debris:HasTag("heavy") then
                local ents = TheSim:FindEntities(x, 0, z, 2, nil, HEAVY_NON_SMASHABLE_TAGS, HEAVY_SMASHABLE_TAGS)
                for i, v in ipairs(ents) do
                    if v ~= debris and v:IsValid() and not v:IsInLimbo() then
                        softbounce = true
                        --NOTE: "smashable" excluded for now
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
                        --NOTE: "smashable" excluded for now
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
                debris.Physics:SetVel(
                    speed * math.cos(angle),
                    speed * 2.3,
                    speed * math.sin(angle)
                )
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
                    --NOTE: There will always be at least one found within DENSITYRADIUS, ourself!
                    #TheSim:FindEntities(x, 0, y, density, nil, QUAKEDEBRIS_CANT_TAGS, QUAKEDEBRIS_ONEOF_TAGS) > 1
                ) then
                --keep it
                debris.persists = true
                debris.entity:SetCanSleep(true)
				debris.components.inventoryitem.canbepickedup = true
                debris:PushEvent("stopfalling")
            elseif debris:GetTimeAlive() < 1.5 then
                --should be our first bounce
                --debris:DoTaskInTime(softbounce and .4 or .6, _BreakDebris)
            else
                --we missed detecting our first bounce, so break immediately this time
                --_BreakDebris(debris)
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
        debris.persists = true
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
local loot = loottable[math.random(#loottable)]
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
return loot
end

local function SpawnDebris(inst,chopper,loottable)
	local x,y,z = inst.Transform:GetWorldPosition()
	if math.random() < 0.5 then
		if math.random() < 0.5 then
		x = x + math.random(2,5)
		else
		x = x - math.random(2,5)
		end
		z = z + math.random(-5,5)
	else
		if math.random() < 0.5 then
		z = z + math.random(2,5)
		else
		z = z - math.random(2,5)
		end
		x = x + math.random(-5,5)
	end
	local prefab = GetDebris(loottable)
    if prefab ~= nil and prefab ~= "oceantree_leaf_fx_fall" then
        local debris = SpawnPrefab(prefab)
        if debris ~= nil then
            debris.entity:SetCanSleep(false)
            debris.persists = false
			debris:AddTag("quakedebris")
			

            if debris.components.inventoryitem ~= nil and debris.components.inventoryitem.canbepickedup then
                debris.components.inventoryitem.canbepickedup = false
                debris._restorepickup = true
            end
            if math.random() < .5 then
                debris.Transform:SetRotation(180)
            end
			if not (debris:HasTag("spider") or debris:HasTag("aphid")) then
            debris.Physics:Teleport(x, 35, z)
            debris.shadow = SpawnPrefab("warningshadow")
            debris.shadow:ListenForEvent("onremove", function(debris) debris.shadow:Remove() end, debris)
            debris.shadow.Transform:SetPosition(x, 0, z)
			local scaleFactor = Lerp(.5, 1.5, 1)
			debris.shadow.Transform:SetScale(scaleFactor, scaleFactor, scaleFactor)

			debris.updatetask = debris:DoPeriodicTask(FRAMES, _GroundDetectionUpdate, nil, 5)
																						-- ^This Value is from quaker
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
					end
				else
					debris:Remove()
				end
			end
		end																				
       
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
--Code From Quaker^

--Workable Stuff
local function on_chop(inst, chopper, remaining_chops)
    if not (chopper ~= nil and chopper:HasTag("playerghost")) then
        inst.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_tree")
    end
	local phase = 0
	if not (chopper:HasTag("epic") or chopper:HasTag("antlion_sinkhole")) then
	local oldchops = inst.previouschops or 24
	inst.previouschops = remaining_chops
	print(oldchops)
	print(inst.previouschops)
	if (oldchops+inst.partchops-remaining_chops) >= 1 then

	local queuedchops = (oldchops+inst.partchops-remaining_chops)
	print(queuedchops)
	for k = 1, (oldchops+inst.partchops-remaining_chops) do
	if inst:HasTag("infestedtree") then
	SpawnDebris(inst,chopper,infestedloot)
	else
	print('spawndebris')
	SpawnDebris(inst,chopper,choploot)
	if (oldchops+inst.partchops-remaining_chops)-k < 1 and (oldchops+inst.partchops-remaining_chops)-k > 0  then
	inst.partchops = (oldchops+inst.partchops-remaining_chops)-k
	else
	inst.partchops = 0
	end
	print(inst.partchops)
	print('-------')
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
	--inst.AnimState:PlayAnimation("chopdamaged-"..phase)
	inst.AnimState:PlayAnimation("damaged-"..phase,true)
	end
	
end

local function BringTheForestDown(inst,chopper)--!
for i = 1, (3 + math.random(4,7)) do
SpawnDebris(inst,chopper,felloot)
inst:DoTaskInTime(math.random(1,2),SpawnDebris(inst,chopper,felloot))
inst:DoTaskInTime(math.random(4,5),SpawnDebris(inst,chopper,felloot))
end
end

local function on_chopped_down(inst, chopper)
	if chopper:HasTag("epic") or chopper:HasTag("antlion_sinkhole") then
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.CHOP)
	inst.components.workable:SetWorkLeft(inst.previouschops)
	inst.components.workable:SetOnWorkCallback(on_chop)
	inst.components.workable:SetOnFinishCallback(on_chopped_down)
	inst.AnimState:PlayAnimation("damaged-0")
	else
	inst.previouschops = 0
	inst.chopped = true
    inst.SoundEmitter:PlaySound("dontstarve/forest/appear_wood")
    inst.SoundEmitter:PlaySound("dontstarve/forest/treeCrumble",nil,.4)
	inst:RemoveComponent("workable")
	inst.AnimState:PlayAnimation("damaged-4")
	--BringTheForestDown(inst,chopper)--!
	if inst:HasTag("infestedtree") then
	local newtree = SpawnPrefab("giant_tree")
	newtree:AddTag("midgame")
	newtree.Transform:SetPosition(inst.Transform:GetWorldPosition())
	newtree:RemoveComponent("workable")
	newtree.AnimState:PlayAnimation("damaged-4")
	newtree.components.timer:StartTimer("regrow", 3840)
	inst:Remove()
	end
	inst.components.timer:StartTimer("regrow", 3840)
	end
end
--Workable Stuff^

local function Regrow(inst, data)

	if data.name == "regrow" then
	inst.chopped = false
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.CHOP)
	inst.components.workable:SetWorkLeft(25)
	inst.components.workable:SetOnWorkCallback(on_chop)
	inst.components.workable:SetOnFinishCallback(on_chopped_down)
	inst.AnimState:PlayAnimation("damaged-0")
	end
	if data.name == "infest" then
	local newtree = SpawnPrefab("giant_tree_infested")
	newtree:AddTag("midgame")
	newtree.Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst:Remove()
	end

end

local function onsave(inst, data)
data.previouschops = inst.previouschops
data.chopped = inst.chopped
end

local function onload(inst,data)
if data then
inst.previouschops = data.previouschops
if data.chopped == true then
inst:RemoveComponent("workable")
end
else
inst.previouschops = 25
end


if inst.components.workable ~= nil and inst.components.workable:CanBeWorked() then
inst.AnimState:PlayAnimation("damaged-0")
else
inst.AnimState:PlayAnimation("damaged-4")
end
end


--Shadow Spawning Function, for now
local function SpawnTreeShadows(inst)

if not inst:HasTag("midgame") then
local x, y, z = inst.Transform:GetWorldPosition()
x = x - 22
z = z - 22
for i = 1, 5 do
for k = 1, 5 do
local shadow = SpawnPrefab("hoodedcanopy")
shadow.Transform:SetPosition(x, y, z)
x = x + 11 + math.random(-0.75,0.75)
end
x = x - 55
z = z + 11 + math.random(-0.75,0.75)
end
end
end
--Shadow Spawning function^

local function Deletus(inst)
	local x, y, z = inst.Transform:GetWorldPosition()

	local tree = TheSim:FindEntities(x, y, z, 8, { "giant_tree" })
	
		for i, v in ipairs(tree) do
			if v ~= inst and v:IsValid() and not v:IsInLimbo() then
				v:Remove()
			end
		end
end



local function makefn()
    	local inst = CreateEntity()

    	inst.entity:AddTransform()
    	inst.entity:AddAnimState()
        inst.entity:AddNetwork()
		inst.entity:AddSoundEmitter()
		inst.entity:AddMiniMapEntity()
		inst.entity:AddDynamicShadow()
		inst:AddTag("tree")
		inst:AddTag("giant_tree")
		inst.MiniMapEntity:SetIcon("giant_tree.tex")
        inst.MiniMapEntity:SetPriority(-1)
		
        MakeObstaclePhysics(inst, 2.35)

        inst.AnimState:SetBank("giant_tree")
        inst.AnimState:SetBuild("giant_tree")
        inst.AnimState:PlayAnimation("damaged-0", true)



		-----------------------
        inst:DoTaskInTime(0, InitializePathFinding)
		-----------------------
	inst:AddTag("shadecanopysmall")
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
	
		inst:AddTag("shadecanopysmall")
		
		inst:AddComponent("workable")
		inst.components.workable:SetWorkAction(ACTIONS.CHOP)
		inst.components.workable:SetWorkLeft(25)

		inst.components.workable:SetOnWorkCallback(on_chop)
		inst.components.workable:SetOnFinishCallback(on_chopped_down)
		inst:AddComponent("timer")
		inst:ListenForEvent("timerdone", Regrow)
		inst:AddComponent("inspectable")
		inst.previouschops = nil
		--inst:DoPeriodicTask(5,Regrow)
		inst:DoTaskInTime(0,Deletus)
		inst:DoTaskInTime(0,SpawnTreeShadows)
		inst.partchops = 0
		inst.OnSave = onsave
		inst.OnLoad = onload
		
		
	    inst:AddComponent("lightningblocker")
		inst.components.lightningblocker:SetBlockRange(TUNING.SHADE_CANOPY_RANGE_SMALL)
		inst.components.lightningblocker:SetOnLightningStrike(OnLightningStrike)	
	return inst
end

local function StartSpawning(inst)
    if inst.components.childspawner ~= nil and
        not (inst.components.freezable ~= nil and
            inst.components.freezable:IsFrozen()) and
        not TheWorld.state.isnight then
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

local function OnInit(inst)
    inst:WatchWorldState("isnight", OnIsNight)
    OnIsNight(inst, TheWorld.state.isnight)
end

local function makeinfested()
    	local inst = CreateEntity()

    	inst.entity:AddTransform()
    	inst.entity:AddAnimState()
        inst.entity:AddNetwork()
		inst.entity:AddSoundEmitter()
		inst.entity:AddMiniMapEntity()
		inst.entity:AddDynamicShadow()
		
		inst:AddTag("tree")
		inst:AddTag("giant_tree")
		inst.MiniMapEntity:SetIcon("giant_tree.tex")
        inst.MiniMapEntity:SetPriority(-1)
		
		inst:AddTag("infestedtree")
        MakeObstaclePhysics(inst, 2.35)

        inst.AnimState:SetBank("giant_tree_infested")
        inst.AnimState:SetBuild("giant_tree_infested")
        inst.AnimState:PlayAnimation("damaged-0", true)

		-----------------------	
        inst:DoTaskInTime(0, InitializePathFinding)
		-----------------------
		inst:AddTag("shadecanopysmall")
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
	
		inst:AddTag("shadecanopysmall")
		
        inst:DoTaskInTime(0, OnInit)		
		inst:AddComponent("workable")
		inst.components.workable:SetWorkAction(ACTIONS.CHOP)
		inst.components.workable:SetWorkLeft(25)
		
        inst:AddComponent("childspawner")
        inst.components.childspawner.childname = "aphid"
        inst.components.childspawner:SetRegenPeriod(TUNING.SPIDERDEN_REGEN_TIME)
        inst.components.childspawner:SetSpawnPeriod(TUNING.SPIDERDEN_RELEASE_TIME)
		
        inst.components.childspawner.allowboats = true
		inst.components.workable:SetOnWorkCallback(on_chop)
		inst.components.workable:SetOnFinishCallback(on_chopped_down)
		inst:AddComponent("timer")
		inst:ListenForEvent("timerdone", Regrow)
		inst:AddComponent("inspectable")
		inst.previouschops = nil
		inst.partchops = 0
		--inst:DoPeriodicTask(5,Regrow)
		inst:DoTaskInTime(0,Deletus)
		inst:DoTaskInTime(0,SpawnTreeShadows)
		inst.OnSave = onsave
		inst.OnLoad = onload
		
		inst:AddComponent("lightningblocker")
		inst.components.lightningblocker:SetBlockRange(TUNING.SHADE_CANOPY_RANGE_SMALL)
		inst.components.lightningblocker:SetOnLightningStrike(OnLightningStrike)
	
    return inst
end

return Prefab("giant_tree", makefn, assets),
	Prefab("giant_tree_infested", makeinfested, assets)

