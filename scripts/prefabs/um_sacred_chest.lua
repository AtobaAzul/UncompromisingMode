-- HEY YOU
-- Alright, let's run down the basics here. It's pretty simple!
-- If you want to start from the beginning, check the sacred_chest.lua postinit first!

-- First: This is a copy of the vanilla sacred chest. We can add recipes.
-- We can add recipes to it.

-- Second: This will also be 'scannable' for a Logbook entry for itself in the future.
-- MAKE THAT A SCRAPBOOK ENTRY LMAO this is fine this is fine this is fine


require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/ui_chest_3x2.zip"),
	Asset("ANIM", "anim/sacred_chest.zip"),
}

local prefabs =
{
	"statue_transition",
	"statue_transition_2",
}


local offering_recipe =
{
	-- VANILLA RECIPES
	-- When the ruins furniture objects are able to be studied/scanned for their permenant recipe unlock, comment these out.
	
	ruinsrelic_plate_blueprint		= { "nightmare_timepiece", "cutstone", "nightmarefuel", "petals", "berries", "carrot" },
	ruinsrelic_chipbowl_blueprint	= { "nightmare_timepiece", "cutstone", "nightmarefuel", "carrot", "berries", "petals" },
	ruinsrelic_bowl_blueprint		= { "nightmare_timepiece", "cutstone", "nightmarefuel", "rabbit", "carrot", "petals" },
	ruinsrelic_vase_blueprint		= { "nightmare_timepiece", "cutstone", "nightmarefuel", "redgem", "butterfly", "petals" },
	ruinsrelic_chair_blueprint		= { "nightmare_timepiece", "cutstone", "nightmarefuel", "purplegem", "rabbit", "petals" },
	ruinsrelic_table_blueprint		= { "nightmare_timepiece", "cutstone", "nightmarefuel", "purplegem", "crow", "rabbit" },
	
	
	-- UNCOMP RECIPES
	-- Don't add any recipe that matches a possible Metheus puzzle solution.
	-- For reference: A Walking Cane and Thulecite are present in every solution.
	
	-- Currently, recipe items must be put in the specified order, starting from the first chest slot.
	-- They must also have 6 ingredients; if you want less, the related functions must be rewritten in a way compatible with vanilla recipes.
	
	trinket_wathom1					= { "plaguemask", "nightmarefuel", "rat_tail", "red_cap", "red_cap", "red_cap" },
}

for k, _ in pairs(offering_recipe) do
	table.insert(prefabs, k)
end


-- If you want to make the recipes not dependant on order/6 ingredients, I suggest dumpstering this block of code and starting over.
-- And editing what calls it to check the slots while deciding the recipe to attempt.
local function CheckOffering(items)
	for k, recipe in pairs(offering_recipe) do
		local valid = true
		for i, item in ipairs(items) do
			if recipe[i] ~= item.prefab then
				valid = false
				break
			end
		end
		if valid then
			return k
		end
	end
	
	return nil -- If no valid recipe, this happens, spitting the items back out.
end


local MIN_LOCK_TIME = 2.5

local function UnlockChest(inst, param, doer)
	inst:DoTaskInTime(math.max(0, MIN_LOCK_TIME - (GetTime() - inst.lockstarttime)), function()
		inst.SoundEmitter:KillSound("loop")

		if param == 1 then
			inst.AnimState:PushAnimation("closed", false)
			inst.components.container.canbeopened = true
			if doer ~= nil and doer:IsValid() and doer.components.talker ~= nil then
				doer.components.talker:Say(GetString(doer, "ANNOUNCE_SACREDCHEST_NO"))
			end
		elseif param == 3 then
			inst.AnimState:PlayAnimation("open")
			inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_open")
			SpawnPrefab("statue_transition").Transform:SetPosition(inst.Transform:GetWorldPosition())
			SpawnPrefab("statue_transition_2").Transform:SetPosition(inst.Transform:GetWorldPosition())
			inst:DoTaskInTime(0.75, function()
				inst.AnimState:PlayAnimation("close")
				inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_close")
				inst.components.container.canbeopened = true

				if doer ~= nil and doer:IsValid() and doer.components.talker ~= nil then
					doer.components.talker:Say(GetString(doer, "ANNOUNCE_SACREDCHEST_YES"))
				end
				TheNet:Announce(STRINGS.UI.HUD.REPORT_RESULT_ANNOUCEMENT)
			end)
		else
			inst.AnimState:PlayAnimation("open")
			inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_open")
			inst:DoTaskInTime(.2, function()
				inst.components.container:DropEverything()
				inst:DoTaskInTime(0.2, function()
					inst.AnimState:PlayAnimation("close")
					inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_close")
					inst.components.container.canbeopened = true

					if doer ~= nil and doer:IsValid() and doer.components.talker ~= nil then
						doer.components.talker:Say(GetString(doer, "ANNOUNCE_SACREDCHEST_NO"))
					end
				end)
			end)
		end
	end)

	if param == 3 then
		inst.components.container:DestroyContents()
	end
end

local function LockChest(inst)
	inst.components.container.canbeopened = false
	inst.lockstarttime = GetTime()
	inst.AnimState:PlayAnimation("hit", true)
	inst.SoundEmitter:PlaySound("dontstarve/common/together/sacred_chest/shake_LP", "loop")
end

local function onopen(inst)
	inst.AnimState:PlayAnimation("open")
	inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_open")
end

local function DoNetworkOffering(inst, doer)
	if (not TheNet:IsOnlineMode()) or
		(not inst.components.container:IsFull()) or
		doer == nil or
		not doer:IsValid() then
		inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_close")
		return
	end

	LockChest(inst)

	local x, y, z = inst.Transform:GetWorldPosition()
	local players = FindPlayersInRange(x, y, z, 40)
	if #players <= 1 then
		UnlockChest(inst, 2, doer)
		return
	end

	local items = {}
	local counts = {}
	for i, k in ipairs(inst.components.container.slots) do
		if k ~= nil then
			table.insert(items, k.prefab)
			table.insert(counts, k.components.stackable ~= nil and k.components.stackable:StackSize() or 1)
		end
	end

	local userids = {}
	for i,p in ipairs(players) do
		if p ~= doer and p.userid then
			table.insert(userids, p.userid)
		end
	end

	ReportAction(doer.userid, items, counts, userids, function(param) if inst:IsValid() then UnlockChest(inst, param, doer) end end)
end

local function DoLocalOffering(inst, doer)
	if inst.components.container:IsFull() then -- If attempting recipes with less than 6 ingredients, comment this out.
		local rewarditem = CheckOffering(inst.components.container.slots)
		if rewarditem then
			LockChest(inst)
			inst.components.container:DestroyContents()
			inst.components.container:GiveItem(SpawnPrefab(rewarditem))
			inst.components.timer:StartTimer("localoffering", MIN_LOCK_TIME)
			return true
		end
	
		return false
	end -- If attempting recipes with less than 6 ingredients, comment this out.
end

local function OnLocalOffering(inst)
	inst.AnimState:PlayAnimation("open")
	inst.SoundEmitter:KillSound("loop")
	inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_open")
	inst.components.timer:StartTimer("localoffering_pst", 0.2)
end

local function OnLocalOfferingPst(inst)
	inst.components.container:DropEverything()
	inst:DoTaskInTime(0.2, function()
		inst.AnimState:PlayAnimation("close")
		inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_close")
		inst.components.container.canbeopened = true
	end)
end

local function onclose(inst, doer)
	inst.AnimState:PlayAnimation("close")

	if not DoLocalOffering(inst, doer) then
		DoNetworkOffering(inst, doer)
	end
end

local function OnTimerDone(inst, data)
	if data ~= nil then
		if data.name == "localoffering" then
			OnLocalOffering(inst)
		elseif data.name == "localoffering_pst" then
			OnLocalOfferingPst(inst)
		end

	end
end

local function getstatus(inst)
	return (inst.components.container.canbeopened == false and "LOCKED") or
			nil
end

local function OnLoadPostPass(inst)
	if inst.components.timer:TimerExists("localoffering") then
		LockChest(inst)
	elseif inst.components.timer:TimerExists("localoffering_pst") then
		LockChest(inst)
		inst.components.timer:StopTimer("localoffering_pst")
		OnLocalOffering(inst)
	end
end


local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddMiniMapEntity()
	inst.entity:AddNetwork()
	
	inst:SetPrefabNameOverride("sacred_chest")

	inst.MiniMapEntity:SetIcon("sacred_chest.png")
	
	inst.AnimState:SetBank("sacred_chest")
	inst.AnimState:SetBuild("sacred_chest")
	inst.AnimState:PlayAnimation("closed")
	
	-- This block of code determines whether the upgraded chest is visible/interactable.
	-- When the config is off, we hide it.
	if not TUNING.DSTU.THE_COOLER_SACRED_CHEST then
		inst:Hide()
		inst.AnimState:SetMultColour(0,0,0,0)
		inst:AddTag("NOCLICK")
		inst:AddTag("NOBLOCK")
	else
		inst:Show()
		inst.AnimState:SetMultColour(1,1,1,1)
		inst:RemoveTag("NOCLICK")
		inst:RemoveTag("NOBLOCK")
	end
	
	inst:AddTag("chest")
	inst:AddTag("irreplaceable")
	inst:AddTag("um_sacred_chest")
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		inst.OnEntityReplicated = function(inst) 
			if inst.replica.container ~= nil then
				inst.replica.container:WidgetSetup("um_sacred_chest")
			end
		end
		return inst
	end
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.getstatus = getstatus

	inst:AddComponent("container")
	inst.components.container:WidgetSetup("um_sacred_chest")
	inst.components.container.onopenfn = onopen
	inst.components.container.onclosefn = onclose
	inst.components.container.skipclosesnd = true
	inst.components.container.skipopensnd = true

	inst:AddComponent("hauntable")
	inst.components.hauntable.cooldown = TUNING.HAUNT_COOLDOWN_SMALL

	inst:AddComponent("timer")
	inst:ListenForEvent("timerdone", OnTimerDone)

	inst.OnLoadPostPass = OnLoadPostPass

	return inst
end

return Prefab("um_sacred_chest", fn, assets, prefabs)
