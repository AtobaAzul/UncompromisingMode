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
	"nothinglol",
	"nothinglol",
	"nothinglol",
	"nothinglol",
	"nothinglol",
	"nothinglol",
	"nothinglol",
	"nothinglol",
	"nothinglol",
	"nothinglol",
	"nothinglol",
	"nothinglol",
	"nothinglol",
	"nothinglol",
	"nothinglol",
	"nothinglol",
	"nothinglol",
	"nothinglol",
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
	"nothinglol",
	"nothinglol",
	"nothinglol",
}
--Code From quaker
local function _BreakDebris(debris)
    local x, y, z = debris.Transform:GetWorldPosition()
    SpawnPrefab("ground_chunks_breaking").Transform:SetPosition(x, 0, z)
    debris:Remove()
end 

local QUAKEDEBRIS_CANT_TAGS = { "quakedebris" }
local QUAKEDEBRIS_ONEOF_TAGS = { "INLIMBO" }
local SMASHABLE_TAGS = { "smashable", "quakedebris", "_combat" }
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
                        if v:HasTag("quakedebris") then
                            local vx, vy, vz = v.Transform:GetWorldPosition()
                            SpawnPrefab("ground_chunks_breaking").Transform:SetPosition(vx, 0, vz)
                            v:Remove()
                        elseif v.components.workable ~= nil then
                            if v.sg == nil or not v.sg:HasStateTag("busy") then
                                local work_action = v.components.workable:GetWorkAction()
                                --V2C: nil action for NPC_workable (e.g. campfires)
                                if (    (work_action == nil and v:HasTag("NPC_workable")) or
                                        (work_action ~= nil and HEAVY_WORK_ACTIONS[work_action.id]) ) and
                                    (work_action ~= ACTIONS.DIG
                                    or (v.components.spawner == nil and
                                        v.components.childspawner == nil)) then
                                    v.components.workable:Destroy(debris)
                                end
                            end
                        elseif v.components.combat ~= nil then
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
                        if v:HasTag("quakedebris") then
                            local vx, vy, vz = v.Transform:GetWorldPosition()
                            SpawnPrefab("ground_chunks_breaking").Transform:SetPosition(vx, 0, vz)
                            v:Remove()
                        elseif v.components.combat ~= nil and not (v:HasTag("epic") or v:HasTag("wall")) then
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
    elseif debris.prefab == "mole" or debris.prefab == "rabbit" then
        --failsafe
        debris:PushEvent("detachchild")
        debris:Remove()
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
    if prefab ~= nil or "nothinglol" then
        local debris = SpawnPrefab(prefab)
        if debris ~= nil then
            debris.entity:SetCanSleep(false)
            debris.persists = false
			

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
end
--Code From Quaker^


--Workable Stuff
local function on_chop(inst, chopper, remaining_chops)
    if not (chopper ~= nil and chopper:HasTag("playerghost")) then
        inst.SoundEmitter:PlaySound("turnoftides/common/together/driftwood/chop")
    end
	local phase = 0
	if not (chopper:HasTag("epic") or chopper:HasTag("antlion_sinkhole")) then
	local oldchops = inst.previouschops or 24
	inst.previouschops = remaining_chops
	for k = 1, (oldchops-remaining_chops) do
	if inst:HasTag("infestedtree") then
	SpawnDebris(inst,chopper,infestedloot)
	else
	SpawnDebris(inst,chopper,choploot)	
	end
	end
	if remaining_chops > 15 and remaining_chops < 20 then
    phase = 1
    end
    if remaining_chops > 10 and remaining_chops < 15 then
    phase = 1
    end
    if remaining_chops > 5 and remaining_chops < 10 then
    phase = 2
    end	
    if remaining_chops > 0 and remaining_chops < 5 then
    phase = 3
    end		
    if remaining_chops == 0 or remaining_chops < 0 then
    phase = 4
    end			
	--inst.AnimState:PlayAnimation("chopdamaged-"..phase)
	inst.AnimState:PushAnimation("damaged-"..phase,true)
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

local function Regrow(inst)
	inst.chopped = false
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.CHOP)
	inst.components.workable:SetWorkLeft(25)
	inst.components.workable:SetOnWorkCallback(on_chop)
	inst.components.workable:SetOnFinishCallback(on_chopped_down)
	inst.AnimState:PlayAnimation("damaged-0")
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
x = x + 11
end
x = x - 55
z = z + 11
end
end
end
--Shadow Spawning function^

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

        inst.entity:SetPristine()
		
        if not TheWorld.ismastersim then
            return inst
        end
		
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
		inst:DoTaskInTime(0,SpawnTreeShadows)
		inst.OnSave = onsave
		inst.OnLoad = onload
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

        inst.entity:SetPristine()
		
        if not TheWorld.ismastersim then
            return inst
        end
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
		--inst:DoPeriodicTask(5,Regrow)
		inst:DoTaskInTime(0,SpawnTreeShadows)
		inst.OnSave = onsave
		inst.OnLoad = onload
        return inst
end
return Prefab("giant_tree", makefn, assets),
Prefab("giant_tree_infested", makeinfested, assets)

