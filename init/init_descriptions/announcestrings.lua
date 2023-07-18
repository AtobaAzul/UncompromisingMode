--This is compatability for rezecib's status announcements mod.
 if not GLOBAL.STRINGS._STATUS_ANNOUNCEMENTS then GLOBAL.STRINGS._STATUS_ANNOUNCEMENTS = {} end
GLOBAL.STRINGS._STATUS_ANNOUNCEMENTS.WINKY = {
	HUNGER = {
		FULL  = "Gluttony...",
		HIGH  = "Not very hungry.",
		MID   = "My stomach hurts.",
		LOW   = "Urgh... where is my dinner?",
		EMPTY = "I will eat a rat if I have to!",
	},
	SANITY = {
		FULL  = "No thoughts, head empty.",
		HIGH  = "I think I dropped something.",
		MID   = "Something does not feel right.",
		LOW   = "Are these rats real?",
		EMPTY = "Crazy? I am not!",
	},
	HEALTH = {
		FULL  = "I think I am fine.",
		HIGH  = "I feel some pain.",
		MID   = "Take a hit for me or something.",
		LOW   = "What have I done to deserve this? Do not answer that.",
		EMPTY = "SQUEAK!!!",
	},
	WETNESS = {
		FULL  = "I am like a big wet rag now...",
		HIGH  = "All this water is terrible!",
		MID   = "My fur is getting heavy.",
		LOW   = "I do not like being wet.",
		EMPTY = "Rain. I hate it.",
	},
}
GLOBAL.STRINGS._STATUS_ANNOUNCEMENTS.WATHOM = {
	HUNGER = {
		FULL  = "Sated.",
		HIGH  = "Soon, hunt.",
		MID   = "Hunt goes on.",
		LOW   = "Starving.",
		EMPTY = "Food! Dire!",
	},
	SANITY = {
		FULL  = "Sane.",
		HIGH  = "Sane enough.",
		MID   = "Faux whispers, audible.",
		LOW   = "Abyss beckoning.",
		EMPTY = "No going back! Abyss be damned!!",
	},
	HEALTH = {
		FULL  = "Stabilized.",
		HIGH  = "I am fine.",
		MID   = "Keep going! Keep going!",
		LOW   = "Can't go on.",
		EMPTY = "Fuel, leaking!!",
	},
	WETNESS = {
		FULL  = "I hate it here.",
		HIGH  = "Worst fear, realized.",
		MID   = "Suffering.",
		LOW   = "All water, drip to abyss.",
		EMPTY = "Good.",
	},
    --ADRENALINE = {
        --FULL  = "GRRRRRAAAAAHH!",
        --HIGH  = "Amp! Amp! Amp!",
        --MID   = "Fight! Fight!",
        --LOW   = "Fuel entropy, near zero.",
        --EMPTY = "Huff... Puff...",
     --},
}
GLOBAL.STRINGS._STATUS_ANNOUNCEMENTS.WIXIE = {
	HUNGER = {
		FULL  = "I'm pretty full now.",
		HIGH  = "Not sharing my food with anyone!",
		MID   = "Got any food? Doesn't matter, give it to me!",
		LOW   = "I'm so hungry I could eat a horse!",
		EMPTY = "I'd kill for a meal right now!",
	},
	SANITY = {
		FULL  = "Never felt better!",
		HIGH  = "Feeling a little trapped in my head.",
		MID   = "Ugh, can't get these thoughts out of my head!",
		LOW   = "The world is closing in around me!",
		EMPTY = "Shove off! Leave me alone for once!",
	},
	HEALTH = {
		FULL  = "Feeling pretty good.",
		HIGH  = "Some bruises and scratches, nothing I can't handle.",
		MID   = "All this rough-housing is starting to get to me!",
		LOW   = "I want to go home!",
		EMPTY = "Charles...",
	},
	WETNESS = {
		FULL  = "Am I melting?! I feel like I'm melting!",
		HIGH  = "That's quite enough rain, is it not?",
		MID   = "I don't like being drenched by all this water...",
		LOW   = "Rain, rain, go away!",
		EMPTY = "I hate the rain.",
	},
}
--WALTER = {
	--WOBY_HUNGER = {
		--FULL  = "She's full and happy!",
		--HIGH  = "You want a treat, Woby?",
		--MID   = "What's the matter, girl? Are you hungry?",
		--LOW   = "I need to find her something to eat!",
		--EMPTY = "Woby sounds like she's starving!",
	--},
--}
-- FOR THIS TO WORK THIS NEEDS TO BE IN MODMAIN.LUA: modimport("init/init_descriptions/announcestrings.lua")