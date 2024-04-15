-- TODO: Move any speech to strings for translation. AFTER this is all working, anyway.
local npc_dialogue = {
	"This sure is an interesting change of scenery.",
	"Have you seen a woman clothed in shadows? No reason.",
	"I really need to stop making deals with shady strangers.",
	"Mmm... What a quaint realm, really.",
	"It's so quiet here. Other than those damned birds.",
	"That's it, stay still little birdy... Ah, it moved. Blast.",
	"Most of my spells are too destructive to eliminate these birds without... Well, setting the continent on fire.",
	"No offense, but you're far too normal to entertain me. Let me know if you see anyone literally glowing with power, though.",
	"You know, this place would be WAY too easy to carpet bomb.",
	"Hey, what's a better word for 'assassinate'? Anyone?",
	"Maybe this world has tastier poisons? Wishful thinking, I suppose...",
	"Any idea how to reverse this portal? No? Hm...",
	"Say... You wouldn't happen to know the way to this realm's palace, would you?",
	"The stars here are all wrong. You should fix that.",
	"Would anyone like a horoscope? Well, too bad.",
	"This realm's blasted moon blots out half the stars. A shame, really...",
	"Has... Has anyone happened to look up at the moon? There's, um, a lot going on there.",
	"Did the moon just blink??",
	"Alright, really, am I the only one seeing that celestial being's appendages??",
	"Whatever a 'Vet Curse' is, just keep it away from me. I've had enough curses for one lifetime.",
	"Well, I suppose there's nothing to stop me here... YHARIM IS A BITCH ASS MOTHERFUCKER. Oh... Heavens, that felt good.",
	"I should take a few of these rats home. They would fit nicely under the Tyrant's throne...",
	"If I could just manage to catch that veiled demoness...",
	"Are there any lava caves around here? Just curious. Feeling like a dip.",
	"Why doesn't anyone here use real magic? It's basically everywhere in this realm. Did I miss something??",
	"Mrrp is cringe."
}

local npc_dialogue_winky = {
	"I swear I saw a person made of... Rat. Well, not the strangest thing I've laid eyes on.",
	"So... You do exist. Hm. That's fine. Absolutely." -- If Winky.
}

local npc_dialogue_wathom = {
	"Does this realm have demons, by chance? I thought I saw one. In broad daylight...",
	"Who's a slightly intriguing little attempt at utilizing this world's magic? You are! Yes you aaare!" -- If Wathom.
}

local taunts_spawnedwrong = {
	"Wow, rude.",
	"Oh, two can play at that game.",
	"Aww, baby's first magic spell! Die.",
	"Why do people in this realm keep teleporting me around??",
	"You know what? Get uncompromised.",
	"Oh great, another one.",
	"How about I uncompromise the carbon from your body?",
	"Go to hell."
}

local taunts_attacked = {
	"Wow, rude.",
	"Hitting people is rude, you know.",
	"Cute.",
	"Mine's better than yours, promise.",
	"I don't think you want what you think you want.",
	"You know what? Get uncompromised.",
	"Are you sure you want to lose your life?",
	"You should try not to be so courageous.",
	"Couldn't leave me well-enough alone, could you?"
}

local taunts_boss_startfalse = {
	"Come back when you're a little, mmmmm, better defended against extraplanar mysticism.",
	"If a spell like this works on you, you're not ready to try that."
}

local taunts_boss_starttrue1 = {
	"Oh? How interesting.",
	"Oh? That's interesting...",
	"Hm? I see...",
	"Oh? You're still here?",
	"Wait, you weren't displaced by that?",
	"Wait, what?",
	"That spell... Didn't work?",
	"Oho? Perhaps you could survive a few moments.",
	"Oh? Well... Maybe you wouldn't instantly turn into a red mist.",
	"Ah... It seems someone came prepared."
}

local taunts_boss_starttrue2 = {
	"Very well. I'll indulge.",
	"Well, it's not like this portal is going anywhere.",
	"I'm not making progress here anyway. Why not?",
	"Well, if you insist.",
	"I suppose I could use a distraction from my plight.",
	"Fine. I was growing bored, anyway."
}

local taunts_boss = {
	"If you're looking for some fourth-degree burns, you've got the right person.",
	"You must enjoy going through hell.",
	"This is, quite literally, 1% of my power. Just thought you should know.",
	"Come now, stay quick on your feet!",
	"Is that what passes for mobility in this realm?",
	"Oh, that was a close one.",
	"I suppose this will keep me in-practice.",
	"Keep it up. You might make for a minimally interesting training dummy.",
	"Tell you what. If you survive long enough, I may have a small trinket for you.",
	"You could try hitting me, you know.",
	"Hey... Are you actually trying to hit me?",
	"Isn't this *yawn* exciting? Ah, sorry...",
	"Having any regrets? An epiphany, perhaps?",
	"Is your mental fortitude fading?",
	"Oh? Is your rage... Escalating?",
	"What I mistook for courage... Was it perhaps madness?",
	"...aused, yooouuu, noooo-thing. But. Striiiife... Ah, was that out loud?"
}

local taunts_boss_playerkilled = {
	"Get uncompromised.",
	"Skidaddle skidoodle.",
	"Skill issue.",
	"Have you considered ingesting random artifacts of unwathomable power? Could help your chances."
}

local taunts_finishboss = { -- These will appear in order.
	"Alright, I have a question...",
	"How the HELL are you still ALIVE?!",
	"Well, whatever.",
	"The important part is, you lasted surprisingly... Longer than 5 seconds.",
	"All things considered, I can recognize a good effort.",
	"Here. Something to remember the occasion by.", -- Drop ornament.
	"Don't do anything weird with it.",
	"Not that you would, but...",
	"Well, I've seen things.",
	"There's this thing called a \'subreddit\', where people keep drawing pictures of m...",
	"Actually.",
	"I'm going to stop talking now.",
	"Bye." -- Teleport self away, and drop 'crumpled notes' at same time.
}


local function RandomTeleportNearbyPlayers(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x, y, z, 50, { "player" }, { "FX", "NOCLICK", "INLIMBO", "invisible", "notarget", "noattack", "playerghost" })
	
	local function getrandomposition(inst)
		local centers = {}
		
		for i, node in ipairs(TheWorld.topology.nodes) do 
			if TheWorld.Map:IsPassableAtPoint(node.x, 0, node.y) and node.type ~= NODE_TYPE.SeparatedRoom then
				table.insert(centers, { x = node.x, z = node.y })
			end
		end
		
		if #centers > 0 then
			local pos = centers[math.random(#centers)]
			return Point(pos.x, 0, pos.z)
		else
			return Point(0, 0, 0)
		end
	end

	local function teleport_end(teleportee, locpos)
		if teleportee.components.inventory ~= nil and teleportee.components.inventory:IsHeavyLifting() then
			teleportee.components.inventory:DropItem(teleportee.components.inventory:Unequip(EQUIPSLOTS.BODY), true, true)
		end
	
		teleportee.sg.statemem.teleport_task = nil
		teleportee.sg:GoToState(teleportee:HasTag("playerghost") and "appear" or "wakeup")
		teleportee.SoundEmitter:PlaySound("dontstarve/common/staffteleport")
	end
	
	
	if #ents > 0 then
		for i, teleportee in pairs(ents) do
			local locpos = getrandomposition()
			
			TheWorld:PushEvent("ms_sendlightningstrike", teleportee:GetPosition())
			
			if teleportee.Physics ~= nil then
				teleportee.Physics:Teleport(locpos.x, 0, locpos.z)
			else
				teleportee.Transform:SetPosition(locpos.x, 0, locpos.z)
			end
			
			teleportee:SnapCamera()
			teleportee:ScreenFade(true, 0)
			teleportee.sg.statemem.teleport_task = teleportee:DoTaskInTime(1, teleport_end, locpos)
			
			-- After a moment of rest, hit them and smash max health.
			teleportee:DoTaskInTime(5, function()
				if teleportee ~= nil and teleportee.components.health ~= nil and not teleportee:HasTag("playerghost") then
					teleportee.components.health:DeltaPenalty(50)
					teleportee.components.health:DoDelta(-1, nil, inst, nil, inst)
				end
				
				if teleportee.sg ~= nil and not teleportee.sg:HasStateTag("nointerrupt")
				and not teleportee:HasTag("playerghost") and teleportee.components.health ~= nil and not teleportee.components.health:IsDead()
				then
					teleportee.sg:GoToState("electrocute")
				end
				
				teleportee:DoTaskInTime(FRAMES*1, function()
					TheWorld:PushEvent("ms_sendlightningstrike", teleportee:GetPosition())
				end)
			end)
		end
	end
end

local function SpawnedWrong(inst)
	-- Complain about being summoned out of nowhere. Rude af tbh.
	inst.AnimState:PlayAnimation("speak_loop", true)
	TheNet:Announce("  " .. taunts_spawnedwrong[math.random(1, #taunts_spawnedwrong)])
	
	inst:DoTaskInTime(3, function()
		inst.AnimState:PlayAnimation("spell_loop", true)
	end)
	
	inst.SoundEmitter:PlaySound("stmpwyfs/stmpwyfs/WITCH_warningshot", "WITCH_warningshot")
	inst.SoundEmitter:SetVolume("WITCH_warningshot", 0.5)
	
	-- TODO: Move the teleport code to the persistent Calamitas controller near the portal; then make her very not-persistent.
	inst:DoTaskInTime(5, RandomTeleportNearbyPlayers)
	inst:DoTaskInTime(5, function()
		inst.AnimState:SetMultColour(1, 1, 1, 0)
		inst:DoTaskInTime(7, function()
			inst:Remove()
		end)
	end)
end


local function fn()
	local inst = CreateEntity()
	
	-- Core components
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddLight()
	inst.entity:AddNetwork()
	
	MakeCharacterPhysics(inst, 25, .5)
	RemovePhysicsColliders(inst)
	inst:AddTag("NOBLOCK")
	
	inst.AnimState:SetBank("um_WITCH")
	inst.AnimState:SetBuild("um_WITCH")
	inst.AnimState:PlayAnimation("idle_loop", true)
	inst.Transform:SetScale(6.5, 6.5, 6.5)
	
	inst:AddTag("scarytoprey")
	
	inst.Light:Enable(true)
	inst.Light:SetRadius(4)
	inst.Light:SetFalloff(0.75)
	inst.Light:SetIntensity(0.3)
	inst.Light:SetColour(0.5, 0.3, 0)
	
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(96000)
	inst.components.health:SetMinHealth(1)
	
	inst:AddComponent("combat")
	
	
	inst:DoTaskInTime(1, SpawnedWrong) -- Note: cannot be spawned 'correctly'. Stay tuned for the season 2 battle pass!
	
	
	inst.OnEntitySleep = inst.Remove
	inst.persists = false
	
	return inst
end

return Prefab("um_witch", fn)
