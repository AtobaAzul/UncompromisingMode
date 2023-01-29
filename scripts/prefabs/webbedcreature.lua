local function SetStage(inst, stage)
	if stage <= 3 then


		inst.AnimState:PlayAnimation(inst.anims.init)
		inst.AnimState:PushAnimation(inst.anims.idle, true)
		inst:DoTaskInTime(3,function(inst) inst.AnimState:SetTime(math.random() * 2) end)
	end
end

local function SetSmall(inst)
	if inst:HasTag("mediumcocoon") then
	inst:RemoveTag("mediumcocoon")
	end
	if inst:HasTag("largecocoon") then
	inst:RemoveTag("largecocoon")
	end
	inst:AddTag("smallcocoon")

	inst.AnimState:SetBank("wackycocoonsmall")
	inst.AnimState:SetBuild("wackycocoonsmall")
	inst.DynamicShadow:SetSize(3.5, 2.5)
	inst.components.lootdropper:AddChanceLoot("silk",    1.00)
	inst.components.lootdropper:AddChanceLoot("silk",    1.00)
    inst.anims = {
    	hit="hit_small",
    	idle="idle_small",
    	kill="break_small",
		init = "appear_small",
    }
    SetStage(inst, 1)
end


local function SetMedium(inst)
	if inst:HasTag("smallcocoon") then
	inst:RemoveTag("smallcocoon")
	end
	if inst:HasTag("largecocoon") then
	inst:RemoveTag("largecocoon")
	end
	inst:AddTag("mediumcocoon")

	inst.DynamicShadow:SetSize(4, 3.5)
	inst.components.lootdropper:AddChanceLoot("silk",    1.00)
	inst.components.lootdropper:AddChanceLoot("silk",    1.00)
	inst.components.lootdropper:AddChanceLoot("silk",    1.00)
	inst.components.lootdropper:AddChanceLoot("silk",    1.00)
    inst.anims = {
    	hit="hit_medium",
    	idle="idle_medium",
    	kill="break_medium",
		init = "appear_medium",
    }
    SetStage(inst, 2)
end

local function SetLarge(inst)
	if inst:HasTag("smallcocoon") then
	inst:RemoveTag("smallcocoon")
	end
	if inst:HasTag("mediumcocoon") then
	inst:RemoveTag("mediumcocoon")
	end
	inst:AddTag("largecocoon")

	inst.DynamicShadow:SetSize(5, 4)
	inst.components.lootdropper:AddChanceLoot("silk",    1.00)
	inst.components.lootdropper:AddChanceLoot("silk",    1.00)
	inst.components.lootdropper:AddChanceLoot("silk",    1.00)
	inst.components.lootdropper:AddChanceLoot("silk",    1.00)
	inst.components.lootdropper:AddChanceLoot("silk",    1.00)
	inst.components.lootdropper:AddChanceLoot("silk",    1.00)
    inst.anims = {
    	hit="hit_large",
    	idle="idle_large",
    	kill="break_large",
		init = "appear_large",
    }
    SetStage(inst, 3)
end


local function OnKilled(inst)
	inst.AnimState:PlayAnimation(inst.anims.kill)
	local x, y, z = inst.Transform:GetWorldPosition()
    inst.SoundEmitter:KillSound("loop")
	inst.SoundEmitter:PlaySound("dontstarve/creatures/spider/spiderLair_destroy")
	local creature = nil
	if inst.size ~= nil then
		if inst.size == 1 then
		creature = "deer"
		inst.components.lootdropper:AddChanceLoot("meat",    1.00)
		inst.components.lootdropper:AddChanceLoot("meat",    0.5)
		inst.components.lootdropper:AddChanceLoot("deer_antler",    1.00)
		inst.components.lootdropper:AddChanceLoot("bluegem",    0.5)
		inst.components.lootdropper:AddChanceLoot("redgem",    0.5)
		end
		if inst.size == 2 then
		creature = "beefalo"
		inst.components.lootdropper:AddChanceLoot("meat",    1.00)
		inst.components.lootdropper:AddChanceLoot("meat",    1.00)
		inst.components.lootdropper:AddChanceLoot("beefalowool",    1.00)
		inst.components.lootdropper:AddChanceLoot("beefalowool",    1.00)
		inst.components.lootdropper:AddChanceLoot("beefalowool",    0.5)
		inst.components.lootdropper:AddChanceLoot("horn",    0.5)
		inst.components.lootdropper:AddChanceLoot("poop",    0.5)
		end
		if inst.size == 3 then
		creature = "mossling"
		inst.components.lootdropper:AddChanceLoot("meat",    1.00)
		inst.components.lootdropper:AddChanceLoot("drumstick",    1.00)
		inst.components.lootdropper:AddChanceLoot("goose_feather",    1.00)
		inst.components.lootdropper:AddChanceLoot("goose_feather",    1.00)
		end
		if inst.size == 4 then
		creature = "pigman"
		inst.components.lootdropper:AddChanceLoot("meat",    1.00)
		inst.components.lootdropper:AddChanceLoot("pigskin",    1.00)
		inst.components.lootdropper:AddChanceLoot("tophat",    1.00)
		end
		if inst.size == 5 then
		creature = "bunnyman"
		inst.components.lootdropper:AddChanceLoot("meat",    1.00)
		inst.components.lootdropper:AddChanceLoot("carrot",    1.00)
		inst.components.lootdropper:AddChanceLoot("carrot",    1.00)
		inst.components.lootdropper:AddChanceLoot("manrabbit_tail",    1.00)
		inst.components.lootdropper:AddChanceLoot("manrabbit_tail",    0.5)
		end
		if inst.size == 6 then
		creature = "koalefant_summer"
		inst.components.lootdropper:AddChanceLoot("meat",    1.00)
		inst.components.lootdropper:AddChanceLoot("meat",    1.00)
		inst.components.lootdropper:AddChanceLoot("meat",    1.00)
		inst.components.lootdropper:AddChanceLoot("meat",    1.00)
		inst.components.lootdropper:AddChanceLoot("poop",    1.00)
		inst.components.lootdropper:AddChanceLoot("poop",    0.5)
		inst.components.lootdropper:AddChanceLoot("phlegm",    0.5)
		end
		if inst.size == 7 then
		creature = "grassgator"
		inst.components.lootdropper:AddChanceLoot("plantmeat",    1.00)
		inst.components.lootdropper:AddChanceLoot("cutgrass",    1.00)
		inst.components.lootdropper:AddChanceLoot("twigs",    1.00)
		end
		if inst.size == 8 then
		creature = "tallbird"
		inst.components.lootdropper:AddChanceLoot("meat",    1.00)
		inst.components.lootdropper:AddChanceLoot("smallmeat",    0.5)
		inst.components.lootdropper:AddChanceLoot("tallbirdegg",    1.00)
		inst.components.lootdropper:AddChanceLoot("cutgrass",    1.00)
		inst.components.lootdropper:AddChanceLoot("cutgrass",    0.5)
		inst.components.lootdropper:AddChanceLoot("twigs",    1.00)
		inst.components.lootdropper:AddChanceLoot("twigs",    0.5)
		end
		if inst.size == 9 then
		creature = "spiderqueen"
		end
		if inst.size == 10 then
		creature = "warg"
		inst.components.lootdropper:AddChanceLoot("monstermeat",    1.00)
		inst.components.lootdropper:AddChanceLoot("monstersmallmeat",    0.5)
		inst.components.lootdropper:AddChanceLoot("houndstooth",    1.00)
		inst.components.lootdropper:AddChanceLoot("houndstooth",    0.5)
		inst.components.lootdropper:AddChanceLoot("boneshard",    1.00)
		inst.components.lootdropper:AddChanceLoot("boneshard",    0.5)
		inst.components.lootdropper:AddChanceLoot("bluegem",    0.5)
		inst.components.lootdropper:AddChanceLoot("redgem",    0.5)
		end
		if inst.size == 11 then
		creature = "krampus"
		inst.components.lootdropper:AddChanceLoot("monstermeat",    1.00)
		inst.components.lootdropper:AddChanceLoot("monstersmallmeat",    0.5)
		inst.components.lootdropper:AddChanceLoot("charcoal",    1.00)
		inst.components.lootdropper:AddChanceLoot("charcoal",    0.5)
		inst.components.lootdropper:AddChanceLoot("boneshard",    1.00)
		inst.components.lootdropper:AddChanceLoot("krampus_sack",    0.05)
		inst.components.lootdropper:AddChanceLoot("bluegem",    0.5)
		inst.components.lootdropper:AddChanceLoot("redgem",    0.5)
		end
		if inst.size == 12 then
		creature = "walrus"
		inst.components.lootdropper:AddChanceLoot("meat",    1.00)
		inst.components.lootdropper:AddChanceLoot("meat",   0.5)
		inst.components.lootdropper:AddChanceLoot("blowdart_pipe",    0.5)
		inst.components.lootdropper:AddChanceLoot("walrus_tusk", 1.0)
		end
		if inst.size == 13 then
		creature = "bishop"
		inst.components.lootdropper:AddChanceLoot("trinket_6",    1.00)
		end
		if inst.size == 14 then
		creature = "spat"
		inst.components.lootdropper:AddChanceLoot("meat",    1.00)
		inst.components.lootdropper:AddChanceLoot("meat",    0.5)
		inst.components.lootdropper:AddChanceLoot("steelwool",    1.00)
		inst.components.lootdropper:AddChanceLoot("steelwool",    0.5)
		inst.components.lootdropper:AddChanceLoot("phlegm",    1.00)
		end
		if inst.size == 15 then
		creature = "lightninggoat"
		inst.components.lootdropper:AddChanceLoot("meat",    1.00)
		inst.components.lootdropper:AddChanceLoot("meat",    0.5)
		inst.components.lootdropper:AddChanceLoot("lightninggoathorn",    1.00)
		inst.components.lootdropper:AddChanceLoot("lightninggoathorn",    1.00)
		end
		if inst.size == 16 then
		creature = "snapdragon"
		inst.components.lootdropper:AddChanceLoot("plantmeat",    1.00)
		inst.components.lootdropper:AddChanceLoot("plantmeat",    0.5)
		inst.components.lootdropper:AddChanceLoot("livinglog",    1.00)
		inst.components.lootdropper:AddChanceLoot("livinglog",    1.00)
		inst.components.lootdropper:AddChanceLoot("livinglog",    1.00)
		inst.components.lootdropper:AddChanceLoot("livinglog",    0.50)
		inst.components.lootdropper:AddChanceLoot("whisperpod",    1.0)
		end
		if inst.size == 17 then
		creature = "catcoon"
		inst.components.lootdropper:AddChanceLoot("meat",    1.00)
		inst.components.lootdropper:AddChanceLoot("coontail",    1.00)
		inst.components.lootdropper:AddChanceLoot("coontail",    1.00)
		end
		if inst.size == 18 then
			creature  = "eyeofterror_mini"
			inst.components.lootdropper:AddChanceLoot("milkywhites",		1.00)
			inst.components.lootdropper:AddChanceLoot("milkywhites",		1.00)
			inst.components.lootdropper:AddChanceLoot("milkywhites",		0.50)
			inst.components.lootdropper:AddChanceLoot("monstermeat", 	1.00)
			inst.components.lootdropper:AddChanceLoot("monstermeat", 	5.00)
		end
		if inst.size == 19 then
			creature  = "pied_rat"
			inst.components.lootdropper:AddChanceLoot("rat_tail",		1.00)
			inst.components.lootdropper:AddChanceLoot("rat_tail",		1.00)
			inst.components.lootdropper:AddChanceLoot("rat_tail",		0.50)
		end
		inst.components.lootdropper:DropLoot()
	--[[if creature ~= nil and not creature == "spiderqueen" then
		inst.components.lootdropper:SetChanceLootTable('webbedcreature_'..creature)
	end]]

    local deadcreature = SpawnPrefab(creature)
	deadcreature.Transform:SetPosition(x, y, z)
	if creature == "spiderqueen" then
		deadcreature:AddTag("nodecomposepls")
	end
	deadcreature.components.health:Kill()
	if creature == "mossling" then --Fix funny mossling glitch
	deadcreature:DoTaskInTime(0.1,function(deadcreature) deadcreature.sg:GoToState("death") end)
	end
	else
    local deadcreature = SpawnPrefab("pigman")
	deadcreature.Transform:SetPosition(x, y, z)
	deadcreature.components.health:Kill()
	end
	local spawner = SpawnPrefab("webbedcreaturespawner")
	spawner.Transform:SetPosition(x, y, z)
end

local function OnEntityWake(inst)
    inst.SoundEmitter:PlaySound("dontstarve/creatures/spider/spidernest_LP", "loop")
end

local function OnEntitySleep(inst)
	inst.SoundEmitter:KillSound("loop")
end

local function onsave(inst,data)
if inst.size ~= nil then
data.size = inst.size
else
data.size = math.random(1,18)
end
end
local function onload(inst,data)
if data and data.size ~= nil then
inst.size = data.size
else
inst.size = math.random(1, 18)
end
end

local function SetSize(inst)
	if inst.size == 1 then   --No Eyed Deer
		SetMedium(inst)
		inst.components.named:SetName("Fuzzy Cocoon")
	end

	if inst.size == 2 then   --Beefalo
		SetLarge(inst)
		inst.components.named:SetName("Hairy Cocoon")
	end

	if inst.size == 3 then   --Mossling
		SetMedium(inst)
		inst.components.named:SetName("Feathery Cocoon")
	end

	if inst.size == 4 then   --Pigman
		SetSmall(inst)
		inst.components.named:SetName("Leathery Cocoon")
	end

	if inst.size == 5 then   --Bunnyman
		SetSmall(inst)
		inst.components.named:SetName("Fuzzy Cocoon")
	end

	if inst.size == 6 then   --koalefant
		SetLarge(inst)
		inst.components.named:SetName("Leathery Cocoon")
	end

	if inst.size == 7 then   --grass gator
		SetLarge(inst)
		inst.components.named:SetName("Leafy Cocoon")
	end

	if inst.size == 8 then   --Tallbird
		SetMedium(inst)
		inst.components.named:SetName("Feathery Cocoon")
	end

	if inst.size == 9 then   --SpiderQueen
		SetLarge(inst)
		inst.components.named:SetName("Grotesque Cocoon")
	end

	if inst.size == 10 then   --Varg
		SetLarge(inst)
		inst.components.named:SetName("Hairy Cocoon")
	end

	if inst.size == 11 then   --Krampus
		SetMedium(inst)
		inst.components.named:SetName("Grotesque Cocoon")
	end

	if inst.size == 12 then   --Mactusk
		SetMedium(inst)
		inst.components.named:SetName("Leathery Cocoon")
	end

	if inst.size == 13 then   --Clockwork Knight
		SetSmall(inst)
		inst.components.named:SetName("Hardened Cocoon")
	end

	if inst.size == 14 then   --Ewecus
		SetLarge(inst)
		inst.components.named:SetName("Hardened Cocoon")
	end
	if inst.size == 15 then   --Volt goat
		SetSmall(inst)
		inst.components.named:SetName("Hairy Cocoon")
	end
	if inst.size == 16 then   --Snapdragon
		SetMedium(inst)
		inst.components.named:SetName("Leafy Cocoon")
	end
	if inst.size == 17 then   --Catcoon
		SetSmall(inst)
		inst.components.named:SetName("Fuzzy Cocoon")
	end
	if inst.size == 18 then   --Sussy peeper
		SetSmall(inst)
		inst.components.named:SetName("Grotesque Cocoon")
	end
	if inst.size == 19 then   --Pied Rat
		SetSmall(inst)
		inst.components.named:SetName("Stinky Cocoon")
	end
end

local function Regen(inst, attacker)
	---TheNet:Announce("attacked")
	if not attacker:HasTag("player") then
		if attacker.components.combat ~= nil and attacker.components.combat.target ~= nil then
		attacker.components.combat:DropTarget()
		end
	end
    if not inst.components.health:IsDead() and not attacker:HasTag("hoodedwidow") then
		--TheNet:Announce("advancing")
		local widowweb = FindEntity(inst,50,function(guy) return guy:HasTag("widowweb") end)
		if widowweb then
			--TheNet:Announce("tellingvvidovv")
			widowweb.SpawnInvestigators(widowweb,attacker)
		end

        inst.SoundEmitter:PlaySound("dontstarve/creatures/spider/spiderLair_hit")
        inst.AnimState:PlayAnimation(inst.anims.hit)
        inst.AnimState:PushAnimation(inst.anims.idle)
		if attacker:HasTag("widowsgrasp") and not (attacker.components.rider ~= nil and attacker.components.rider:IsRiding()) then
			--inst.components.health:Kill()
			elseif attacker:HasTag("player") and not attacker:HasTag("mime") and not attacker:HasTag("widowsgrasp") then
			attacker.components.talker:Say(GetString(attacker.prefab, "WEBBEDCREATURE"))
		end
	end
end

local function fn()
		local inst = CreateEntity()
		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddNetwork()
		inst.entity:AddDynamicShadow()
		inst.entity:AddSoundEmitter()

		--MakeObstaclePhysics(inst, .5)


		inst.AnimState:SetBank("wackycocoons")
		inst.AnimState:SetBuild("wackycocoons")
		inst.AnimState:PlayAnimation("idle_small", true)

		inst:AddTag("noepicmusic")
		inst:AddTag("webbedcreature")
		inst:AddTag("structure")
		inst:AddTag("noauradamage")
		--inst:AddTag("notarget")
		inst:AddTag("houndfriend")
		inst:AddTag("antlion_sinkhole_blocker")
		inst:AddTag("queensstuff")
		inst:AddTag("companion")
		inst:AddTag("ignorewalkableplatforms")
		inst:AddTag("ignorewalkableplatformdrowning")

		inst.entity:SetPristine()

		if not TheWorld.ismastersim then
			return inst
		end

		-------------------
		inst:AddComponent("health")
		inst.components.health:SetMaxHealth(1000000)
		inst.components.health.absorb = 1
		--inst.components.health.invincible = true
		inst:AddComponent("combat")
        inst.components.combat:SetOnHit(Regen)
		inst:ListenForEvent("death", OnKilled)

		inst:AddComponent("lootdropper")
		inst:AddComponent("named")

		MakeLargePropagator(inst)

		inst:AddComponent("inspectable")
		inst:DoTaskInTime(0,SetSize)
		MakeSnowCovered(inst)
		inst.OnSave = onsave
		inst.OnLoad = onload
		inst.OnEntitySleep = OnEntitySleep
		inst.OnEntityWake = OnEntityWake
		inst.size = math.random(1,19)
		return inst
end

local function on_anim_over(inst)
    if inst.components.mine.issprung then
        return
    end

	if inst.froze then
	if inst.Harvestable then
	inst.AnimState:PushAnimation("idle_frozen", true)
	else
	inst.AnimState:PushAnimation("trap_idle", true)
	end
	else
    local random_value = math.random()
    if random_value < 0.4 then
        inst.AnimState:PushAnimation("idle_2")
        -- inst.SoundEmitter:PlaySound("turnoftides/creatures/together/starfishtrap/idle")
        inst.AnimState:PushAnimation("idle", true)


    elseif random_value < 0.8 then
        inst.AnimState:PushAnimation("idle_3")
        -- inst.SoundEmitter:PlaySound("turnoftides/creatures/together/starfishtrap/idle")
        inst.AnimState:PushAnimation("idle", true)
    end
	end


end

local function on_anim_over(inst)
if math.random() > 0.95 then
inst.AnimState:PlayAnimation(inst.category.."_twitch")
else
inst.AnimState:PlayAnimation(inst.category)
end
end

local function decorsave(inst,data)
if data~= nil then
data.category = inst.category
end
end

local function decorload(inst,data)
if data ~= nil then
inst.category = data.category
inst.AnimState:PlayAnimation(inst.category)
end
end
local function fndecor()
		local inst = CreateEntity()
		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddNetwork()
		inst:AddTag("webdecor")
		inst:AddTag("antlion_sinkhole_blocker")
		inst.AnimState:SetBank("cocoondecor")
		inst.AnimState:SetBuild("cocoondecor")
		inst.entity:SetPristine()
		if not TheWorld.ismastersim then
			return inst
		end
		inst:ListenForEvent("animover", on_anim_over)
		inst.OnSave = decorsave
		inst.OnLoad = decorload
		return inst
end


return Prefab("webbedcreature", fn),
Prefab("widowdecor", fndecor)

