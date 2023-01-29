local assets =
{
	Asset("ANIM", "anim/skin_collector.zip"),
	Asset("ANIM", "anim/tiddlestranger.zip"),
}

local prefabs =
{
	"spider",
	"hound",
	"rabbit",
	"stalker_bulb",
}

local GREETINGLINES = STRINGS.TIDDLESTRANGER_RNE_GREETING

local DEFAULTLINES = STRINGS.TIDDLESTRANGER_RNE_DEFAULT

local ADVICELINES = STRINGS.TIDDLESTRANGER_RNE_ADVICE

local ENDINGLINES = STRINGS.TIDDLESTRANGER_RNE_ENDSPEECH

local BANTERLINES = STRINGS.TIDDLESTRANGER_RNE_BANTER

local SCENARIOLINES = STRINGS.TIDDLESTRANGER_RNE_SCENARIO
local SCENARIOENDLINES = STRINGS.TIDDLESTRANGER_RNE_SCENARIO_END	

local FAREWELLLINES = STRINGS.TIDDLESTRANGER_RNE_FAREWELL
local IGNOREDLINES = STRINGS.TIDDLESTRANGER_RNE_IGNORED

-- His special lines for specific situations. All comments from the scenarios apply here
-- If you want him to run a special command while he's talking, you can add one in the fn bit there. Eg setting inst.wantstoleave to true so he leaves immediately after speaking.
-- Fn is structured identically to reqfn
-- 0.3 chance is 30%, just FYI
-- Also notice that lines at the top of the list will take priority
local advices =
{
    {
	line = "BUSY", --This is the line for if the player is in combat
	hasending = false,
	chance = 1,
	fn = function(inst)
	   inst.wantstoleave = true --He should want to leave after finishing his speech
	end,
        reqfn = function(inst, player, line)
            return line == nil and player.components.combat ~= nil and player.components.combat.target ~= nil
        end,
    },

    {
	line = "CUREFOUND",
	hasending = true,
	chance = 0.3,
        reqfn = function(inst, player, line)
            return line == nil and player.foundcure ~= nil and player.foundcure
        end,
    },

    {
	line = "REVIVER",
	hasending = false,
	chance = 0.3,
        reqfn = function(inst, player, line)
            return line == nil and player.hasRevivedPlayer	
        end,
    },

    {
	line = "MURDERER",
	hasending = false,
	chance = 0.3,
        reqfn = function(inst, player, line)
            return line == nil and player.hasKilledPlayer	
        end,
    },

    {
	line = "MEDICINE",
	hasending = true,
	chance = 0.3,
        reqfn = function(inst, player, line)
            return line == nil and player:HasTag("TiddleVirus")
        end,
    },

    {
	line = "HARBINGERS",
	hasending = true,
	chance = 0.3,
        reqfn = function(inst, player, line)
            return line == nil and player.components.tiddlespawner ~= nil and player.components.tiddlespawner.spawn_task ~= nil and GetTaskRemaining(player.components.tiddlespawner.spawn_task) < TUNING.TOTAL_DAY_TIME*20
        end,
    },
}

------------------------------------------------[[ EPIC MODDERS ONLY ]]------------------------------------------------



-------------------------------------- SCENARIOS --------------------------------------

local function FinishScenario(inst, player, text, string, exit)
    if text then
       	if string ~= nil then
       	    inst.components.npc_talker:Say(string)
	else
			inst.components.npc_talker:Say(FAREWELLLINES[math.random(#FAREWELLLINES)])
	end
	inst:DoTalk(3, player)
    end

    if exit then
    	inst.wantstoleave = true
    end
end

local function launchitem(item, angle)
    local speed = math.random() * 4 + 2
    angle = (angle + math.random() * 60 - 30) * DEGREES
    item.Physics:SetVel(speed * math.cos(angle), math.random() * 2 + 8, speed * math.sin(angle))
end

-- He snaps his fingers, he snaps your neck
local function PerformScenario(inst, player)
    inst.AnimState:PlayAnimation("snap")
    inst:DoTaskInTime(20 * FRAMES, function() 
		inst.SoundEmitter:PlaySound("dangerous_sea/creatures/wavey_jones/attack")
		
		local x, y, z = inst.Transform:GetWorldPosition()
		
		local players = TheSim:FindEntities(x, y, z, 15, { "player" }, { "playerghost" })
		
		for i, v in ipairs(players) do
			local gift = SpawnPrefab("rne_goodiebag")
		
			local angle
			if v ~= nil and v:IsValid() then
				angle = 180 - v:GetAngleToPoint(x, 0, z)
				gift.Transform:SetPosition(x, 3, z)
				
                launchitem(gift, angle)
			else
				gift.Transform:SetPosition(x, y, z)
			end
		end
	end)
    inst.AnimState:PushAnimation("idle", true)

	inst:DoTaskInTime(5, function() inst:FinishScenario(player, true, nil, true) end)

end


-------------------------------------- THE 'STATEGRAPH' --------------------------------------

--Tell him when to play animations and make sounds
--Make sure he isn't busy to do so.


local function IsBusy(inst)
    return inst.AnimState:IsCurrentAnimation("appear") or inst.AnimState:IsCurrentAnimation("disappear")
end

local function IsDancing(inst)
 return inst.AnimState:IsCurrentAnimation("dance2")
end

--It sounds a bit weird when he stops talking mid-note, so play a low note to hide it
--Delay it by a frame to avoid audio popping
--Also don't kill sounds if he's still TRYING to talk

local function KillTalkSound(inst)
    inst:RemoveEventCallback("animover", KillTalkSound)
	if inst.components.npc_talker:haslines() then
	    return
	end
	inst:DoTaskInTime(0, function()
	    inst.SoundEmitter:PlaySound("dontstarve/characters/tiddle_stranger/talk_end")
	end)
    inst.SoundEmitter:KillSound("talk")
end

-- Wait for him to finish animating before killing the sound.
-- In the odd chance he isn't playing a talking anim, kill the sound immediately
-- This will make more sense below

local function stoptalking(inst)
	inst:DoTaskInTime(0, function()
	if inst.SoundEmitter:PlayingSound("talk") and (inst.AnimState:IsCurrentAnimation("dial_loop") or inst.AnimState:IsCurrentAnimation("dialog_pre")) then
	    inst:ListenForEvent("animover", KillTalkSound)
	else
	    inst.SoundEmitter:KillSound("talk")
	end
	end)
	if not inst.components.npc_talker:haslines() or inst.AnimState:IsCurrentAnimation("idle") or IsDancing(inst) then
	    inst.AnimState:PushAnimation("dialog_pst")
	    inst.AnimState:PushAnimation("idle", true)
	end
	if inst.wantstoleave and not inst.components.npc_talker:haslines() then
	    inst:Despawn()
	end
end

--Play talking animation, skip pre if already in the loop, play the sound if it isn't playing already, yada yada

local function ontalk(inst, script)
	if IsBusy(inst) then
	    return
	end
        if not inst.SoundEmitter:PlayingSound("talk") then
	    inst.SoundEmitter:PlaySound("dontstarve/characters/tiddle_stranger/talk_LP", "talk")
	end
	if IsDancing(inst) then
	    return
	end
	if not inst.AnimState:IsCurrentAnimation("dial_loop") then
	    inst.AnimState:PlayAnimation("dialog_pre")
	end
    inst.AnimState:PushAnimation("dial_loop", true)
end

local function DoDance(inst)
    if not IsBusy(inst) then
        inst.AnimState:PlayAnimation("dance2", true)
    end
end

-------------------------------------- THE 'BRAIN' --------------------------------------


--His brain is just a bunch of 'threads.' This is his talking thread.
--He has a queue of lines he wants to say, so he should keep thinking about talking until he runs out of things to say.
--The queue will be empty while he's saying his last line, so an extra check to make sure he's still talking is needed in case more lines are added to the queue
--Before he goes braindead, check if he wants to do a scenario.

local function DoTalkQueue(inst, delay, player)
    inst:StartThread(function()
        while inst.components.npc_talker:haslines() or inst.components.talker.widget ~= nil or inst.AnimState:IsCurrentAnimation("dial_loop") do
    	    local t = GetTime()
	    if t > inst.textdelay or delay == 0 then
		inst.textdelay = t + delay
            	inst.components.npc_talker:donextline()
	    end
            Yield()
        end
	if --[[inst.scenario ~= nil and]] player ~= nil and not inst.components.npc_talker:haslines() and not inst.wantstoleave then
	    PerformScenario(inst, player)
	end
    end)
end

local function Despawn(inst)
    if inst.SoundEmitter:PlayingSound("talk") then  -- Just in case his sound is still playing
	inst.SoundEmitter:KillSound("talk")
    end
    inst.DynamicShadow:Enable(false)
    if inst.components.talker.widget ~= nil then
	inst.SoundEmitter:PlaySound("dontstarve/characters/tiddle_stranger/talk_end")
    end
    SpawnPrefab("shadow_teleport_in").Transform:SetPosition(inst:GetPosition():Get())
    inst.SoundEmitter:PlaySound("dontstarve/creatures/krampus/bag_jumpinto")
    inst.AnimState:PlayAnimation("disappear")
    inst:ListenForEvent("animover", function() inst:Remove() end)
end

local function OnFar(inst)
    if inst.banter_task ~= nil then
       	inst.banter_task:Cancel()
	inst.banter_task = nil
    end
	if not IsBusy(inst) and inst.scenario == nil then
   		Despawn(inst)
    		inst.components.npc_talker:resetqueue()
    		inst.components.talker:ShutUp()
		inst.components.npc_talker:Say(IGNOREDLINES[math.random(#IGNOREDLINES)])
		DoTalkQueue(inst, 0)
	end
end

local function GetLines(inst, player)
    local hasending = true
    local line = nil
    if inst.scenario ~= nil then
	    	line = SCENARIOLINES[inst.scenario.name]
		hasending = false
    else
	for k, v in pairs(advices) do
    	   if v.reqfn(inst, player, line) and math.random() < v.chance then
		line = ADVICELINES[v.line]
		hasending = v.hasending
		if v.fn ~= nil then v.fn(inst, player) end
	   end
	end
    end
    if line == nil then
        line = DEFAULTLINES[math.random(#DEFAULTLINES)]
    end
    inst.components.npc_talker:Say(line)
    if hasending then
	inst.components.npc_talker:Say(ENDINGLINES[math.random(#ENDINGLINES)])
    end
end


local function StartSpeech(inst, player)
    if not IsBusy(inst) then
	if not (inst.scenario ~= nil and inst.scenario.skipgreeting) then
	    inst.components.npc_talker:Say(GREETINGLINES[math.random(#GREETINGLINES)])
	end
	GetLines(inst, player)
	DoTalkQueue(inst, 3, player)
    end

    inst:StartThread(function()
        while player ~= nil and player:IsValid() do
	    inst:FacePoint(player.Transform:GetWorldPosition())
	    if player.sg ~= nil and player.sg:HasStateTag("dancing") and not inst.scenario ~= nil then
		DoDance(inst)
	    end
            Yield()
        end
    end)
end

local function GetScenario(inst, player)
local scene = {}
    for k, v in pairs(scenarios) do
	if v.reqfn == nil or v.reqfn(inst, player) then
	    table.insert(scene, v)
	end
    end
    if #scene > 0 then
	inst.scenario = scene[math.random(#scene)]
    end
end

local function Spawn(inst)
    inst.AnimState:PlayAnimation("appear")
    inst.AnimState:PushAnimation("idle", true)
    SpawnPrefab("shadow_teleport_out").Transform:SetPosition(inst:GetPosition():Get())
    inst.SoundEmitter:PlaySound("dontstarve/creatures/krampus/bag_jumpinto")

    inst:DoTaskInTime(1.5, function()
        local player = inst:GetNearestPlayer()
		if player ~= nil then
			StartSpeech(inst, player)
		else
			Despawn(inst)	
		end
    end)
end

    local function fn(inst)
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddDynamicShadow()
        inst.entity:AddNetwork()

	inst.textdelay = GetTime()
	inst.wantstoleave = false

        MakeCharacterPhysics(inst, 0, 0)
        RemovePhysicsColliders(inst)
        inst.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
    inst.Physics:CollidesWith(COLLISION.GROUND)

        inst.DynamicShadow:SetSize(2.5, 1.5)
	inst.Transform:SetTwoFaced()
    inst.AnimState:SetBank("skin_collector")
    inst.AnimState:SetBuild("tiddlestranger")

    inst:AddTag("tiddlestranger")

    inst:AddComponent("talker")
    inst.components.talker:MakeChatter()
    inst.components.talker.lineduration = TUNING.HERMITCRAB.SPEAKTIME -0.7  -- it's minus one here to create a buffer between text.
    inst.components.talker.fontsize = 28
    inst.components.talker.colour = Vector3(233/255, 140/255, 120/255)
    inst.components.talker.offset = Vector3(0,-700,0)

    if LOC.GetTextScale() == 1 then
        --Note(Peter): if statement is hack/guess to make the talker not resize for users that are likely to be speaking using the fallback font.
        --Doesn't work for users across multiple languages or if they speak in english despite having a UI set to something else, but it's more likely to be correct, and is safer than modifying the talker

        inst.components.talker.fontsize = 40
    end
    inst.components.talker.font = TALKINGFONT_WORMWOOD

    inst:AddComponent("npc_talker")

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst.components.talker.ontalk = ontalk
        inst.components.talker.donetalkingfn = stoptalking


    inst:AddComponent("inspectable")	

    inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(12, 12)
    inst.components.playerprox:SetOnPlayerFar(OnFar)
    --inst.components.playerprox:SetOnPlayerNear(OnNear)
    --inst.components.playerprox:SetTargetMode(inst.components.playerprox.TargetModes.LockOnPlayer)

	inst:DoTaskInTime(0, Spawn)

	inst:ListenForEvent("despawn", Despawn)
	inst.Despawn = Despawn
	inst.FinishScenario = FinishScenario
	inst.persists = false

	inst.DoTalk = DoTalkQueue

        return inst
    end

    return Prefab("tiddlestranger_rne", fn, assets, prefabs)



--------------------------------------------------------------------------
