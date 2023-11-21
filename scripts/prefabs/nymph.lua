local brain = require("brains/nymphbrain")

SetSharedLootTable("nymph_loot",
	{
		--{'weevole_carapace', 1},
		{ 'beeswax', 1 },
	})
		
		
local sounds = {
    flap = "farming/creatures/lord_fruitfly/LP",
    hurt = "farming/creatures/lord_fruitfly/hit",
    attack = "farming/creatures/lord_fruitfly/attack",
    die = "farming/creatures/lord_fruitfly/die",
    die_ground = "farming/creatures/lord_fruitfly/hit",
    sleep = "farming/creatures/lord_fruitfly/sleep",
    buzz = "farming/creatures/lord_fruitfly/hit",
}


local function common()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()

    inst.DynamicShadow:SetSize(2, 0.75)
    inst.Transform:SetFourFaced()

    MakeGhostPhysics(inst, 1, 0.5)

    inst.AnimState:SetBank("fruitfly")

    inst:AddTag("flying")
    inst:AddTag("ignorewalkableplatformdrowning")

    return inst
end

local function common_server(inst)
    inst:AddComponent("inspectable")

    inst:AddComponent("sleeper")
    inst.components.sleeper:SetResistance(3)

    inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = 6
    inst.components.locomotor.pathcaps = {allowocean = true}

    MakeMediumFreezableCharacter(inst, "fruit")

    MakeHauntablePanic(inst)

    return inst
end

local function LootSetupFunction(lootdropper)
    lootdropper.chanceloot = nil
    if not TheSim:FindFirstEntityWithTag("friendlyfruitfly") then
        lootdropper:AddChanceLoot("fruitflyfruit", 1.0)
    end
end

local function KeepTargetFn(inst, target)
    local p1x, p1y, p1z = inst.components.knownlocations:GetLocation("home"):Get()
    local p2x, p2y, p2z = target.Transform:GetWorldPosition()
    local maxdist = TUNING.LORDFRUITFLY_DEAGGRO_DIST
    return inst.components.combat:CanTarget(target) and distsq(p1x, p1z, p2x, p2z) < maxdist * maxdist
end

local RETARGET_MUSTTAGS = { "player" }
local RETARGET_CANTTAGS = { "playerghost" }
local function RetargetFn(inst)
    return not inst.planttarget and not inst.soiltarget and
        FindEntity(inst, TUNING.LORDFRUITFLY_TARGETRANGE, function(guy) return inst.components.combat:CanTarget(guy) end, RETARGET_MUSTTAGS, RETARGET_CANTTAGS) or nil
end

local function OnAttacked(inst, data)
    local attacker = data ~= nil and data.attacker or nil
    if attacker == nil then
        return
    end
	local x,y,z = inst.Transform:GetWorldPosition()
	local aphids = TheSim:FindEntities(x,y,z,20,{"aphid"})
	for i,v in ipairs(aphids) do
		if v.components.combat then
			v.components.combat:SuggestTarget(attacker)
		end
	end
    --inst.components.combat:SetTarget(attacker)
end



local function ShouldSleep(inst)
    return false
end

local function ShouldWake(inst)
    return true
end


local function ShouldKeepTarget()
    return false
end

local function FadeOut(inst,fade)
	local tree = FindEntity(inst,6,nil,{"giant_tree"},{"infestedtree"})
	--TheNet:Announce("Fadout")
	if tree then
		tree.InfestMe(tree)
	end
	inst:Remove()
end

local function FindSmallOffset(x,z)
	local x_off = math.random(-10,10)/5+x
	local z_off = math.random(-10,10)/5+z
	if TheWorld.Map:IsVisualGroundAtPoint(x_off,0,z_off) then
		return x_off,z_off
	else
		return FindSmallOffset(x,z)
	end
end

local function MoveGroup(inst,x,z)
	if inst.aphidposse then
		local curx,cury,curz = inst.Transform:GetWorldPosition()
		local aphids = TheSim:FindEntities(curx,cury,curz,10,{"aphid"},{"nymph"})
		for i,v in ipairs(aphids) do
			local xposse,zposse = FindSmallOffset(x,z)
			v.Transform:SetPosition(xposse,0,zposse)
		end
	end
	inst.Transform:SetPosition(x,0,z)
end

local function FindSpotToMoveTowardsTree(inst)
	local x,y,z = inst.Transform:GetWorldPosition()
	local xtarget,ytarget,ztarget = inst.treetarget.x,inst.treetarget.y,inst.treetarget.z
	local hypoten = math.sqrt(inst:GetDistanceSqToPoint(inst.treetarget))
	local x_final, y_final, z_final
	local speedmult = 10
	x_final = ((xtarget - x) / hypoten) * (speedmult) + x
	z_final = ((ztarget - z) / hypoten) * (speedmult) + z
	if TheWorld.Map:IsVisualGroundAtPoint(x_final,0,z_final) then
		MoveGroup(inst,x_final,z_final)
	else
		local telepos = {}
		telepos.x = x_final
		telepos.z = z_final
		telepos.y = 0
		local offset = FindWalkableOffset(telepos, math.random() * 2 * PI, 4, 4)
		if offset then
			x_final, z_final = offset.x + telepos.x, offset.z + telepos.z
			MoveGroup(inst,x_final,z_final)
		else --Can't find an offset.... so we'll just let the nymph go and leave the aphids behind.
			inst.Transform:SetPosition(x,0,z)
		end
	end
end

local function MakeAphidsNearbyFollow(inst)
	local x,y,z = inst.Transform:GetWorldPosition()
	local aphids = TheSim:FindEntities(x,y,z,10,{"aphid"},{"nymph"})
	for i,v in ipairs(aphids) do
		v.components.follower.leader = inst
	end
end

local function SpawnAphid(nymph)
	if not nymph.aphidposse then
		nymph.aphidposse = 0
	end
	local x,y,z = nymph.Transform:GetWorldPosition()
	local x_off, z_off = FindSmallOffset(x, z)
	local aphid = SpawnPrefab("aphid")
	aphid.Transform:SetPosition(x_off, 0, z_off)
	aphid.nymph = nymph
	aphid.components.follower:SetLeader(nymph)
	aphid.sg:GoToState("enter_loop")
	aphid.persists = false
	nymph.aphidposse = nymph.aphidposse + 1
	aphid:ListenForEvent("ondeath",function(inst) 
		if nymph and nymph.aphidposse > 1 then 
			nymph.aphidposse = nymph.aphidposse - 1 
		end 
	end)
	aphid:DoPeriodicTask(4,function(aphid) aphid.NymphGroundCheck(aphid) end)
end
	
local function GroundCheck(inst)
	local x,y,z = inst.Transform:GetWorldPosition()
	if TheWorld.Map:IsAboveGroundAtPoint(x,y,z) and inst.aphidpossedigging then
		local temp = inst.aphidposse
		inst.aphidpossedigging = nil
		inst.aphidposse = 0
		for i = 1,temp do
			SpawnAphid(inst)
		end
	end
end

local function minifn()
    local inst = common()

    inst.sounds = sounds
    
    inst.AnimState:SetBuild("nymph")
    inst.AnimState:PlayAnimation("idle")

	inst:AddTag("insect")
    inst:AddTag("aphid")
    inst:AddTag("hostile")
	inst:AddTag("nymph")
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    common_server(inst)
    
    inst:AddComponent("follower")

    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "fruit"
    --inst.components.combat:SetKeepTargetFunction(ShouldKeepTarget)

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.FRUITFLY_HEALTH)
    
    inst.components.sleeper:SetSleepTest(ShouldSleep)
    inst.components.sleeper:SetWakeTest(ShouldWake)

    inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetChanceLootTable("nymph_loot")
    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aura = TUNING.SANITYAURA_TINY
    inst.components.locomotor.walkspeed = 2

	inst:AddComponent("knownlocations")
    inst:SetBrain(brain)
    inst:SetStateGraph("SGfruitfly")
	--inst:DoPeriodicTask(4+4*math.random() ,TryToInfestTree)
    inst:ListenForEvent("attacked", OnAttacked)
	inst:DoPeriodicTask(4,function(inst) --Check if we've reached our destination
		if inst.treetarget then
			if inst:GetDistanceSqToPoint(inst.treetarget) < 2^2 then
				FadeOut(inst,1)
			end
			if inst:IsAsleep() then
				if inst:GetDistanceSqToPoint(inst.treetarget) < 12^2 then -- When not loaded, it can't get close enough to trigger, so we're helping fix that by allowing a wider check....
					inst.Transform:SetPosition(inst.treetarget.x,inst.treetarget.y,inst.treetarget.z)
					FadeOut(inst,1)
				else
					FindSpotToMoveTowardsTree(inst)
				end
			end
			GroundCheck(inst)
		else
			inst:Remove()
		end
	end)
	
	inst.OnLoad = function(inst,data)
		if data then
			if data.treetargetx then
				--TheNet:Announce("wehadthetree")
				inst.treetarget = {}
				inst.treetarget = Vector3(data.treetargetx,data.treetargety,data.treetargetz)
				--MakeAphidsNearbyFollow(inst)
			end
			if data.aphidposse then 
				--for i = 1,data.aphidposse-1 do --Temporarily commented to prevent crash (nymphs that spawn after reloading will now be defenseless)
					--SpawnAphid(inst)
				--end		
			end
		end
	end
	inst.OnSave = function(inst,data)
		if data then
			if inst.treetarget then
				data.treetargetx = inst.treetarget.x
				data.treetargetz = inst.treetarget.z
				data.treetargety = inst.treetarget.y
			end
			if inst.aphidposse then
				data.aphidposse = inst.aphidposse
			end
		end
	end
    return inst
end
return  Prefab("nymph", minifn)