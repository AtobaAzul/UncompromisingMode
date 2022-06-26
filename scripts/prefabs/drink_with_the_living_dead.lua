local function oneatenfn(inst, eater)
	if eater:HasTag("player") then
		if eater.components.debuffable ~= nil and eater.components.debuffable:IsEnabled() and
			not (eater.components.health ~= nil and eater.components.health:IsDead()) and
			not eater:HasTag("playerghost") then
			eater.components.debuffable:AddDebuff("buff_stantonslumber", "buff_stantonslumber")
			local stanton = FindEntity(eater,10,nil,{"stanton"})
			
			if stanton ~= nil then
				stanton.DrinkUp(stanton)
			end
		end
	else
		SpawnPrefab(inst.prefab).Transform:SetPosition(eater.Transform:GetWorldPosition())
	end
end

local function fn_tonic()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("stanton_shadow_tonic")
    inst.AnimState:SetBuild("stanton_shadow_tonic")
    inst.AnimState:PlayAnimation("idle")
	inst.AnimState:PlayAnimation("idle_loop", true)
	inst:AddTag("stantondrink")
    MakeInventoryFloatable(inst)
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/stanton_shadow_tonic.xml"
	--inst.components.inventoryitem.cangoincontainer = false
    MakeHauntableLaunch(inst)
	inst.oneatenfn = oneatenfn
    inst:AddComponent("edible")
    inst.components.edible.healthvalue = 0
    inst.components.edible.hungervalue = 0
    inst.components.edible.sanityvalue = -3
    inst.components.edible.foodtype = FOODTYPE.GOODIES
	inst.components.edible:SetOnEatenFn(inst.oneatenfn)
	inst:AddTag("preparedfood")
	
	inst:ListenForEvent("ondropped",function(inst) 
		local stanton = TheSim:FindFirstEntityWithTag("stanton")
		if stanton ~= nil then
			stanton.TellThemRules(stanton)
		end			
		--inst:Remove() 
	end)
		
	inst:WatchWorldState("isday", function(inst)
		inst:Remove()
	end)
	inst:WatchWorldState("iscaveday", function(inst)
		inst:Remove()
	end)
	
    return inst
end

local function fn_tonic_fancy()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("stanton_shadow_tonic_fancy")
    inst.AnimState:SetBuild("stanton_shadow_tonic")
    inst.AnimState:PlayAnimation("idle")
	inst.AnimState:PlayAnimation("idle_loop", true)
	inst:AddTag("stantondrink")
    MakeInventoryFloatable(inst)
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end


    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/stanton_shadow_tonic_fancy.xml"
	--inst.components.inventoryitem.cangoincontainer = false
    MakeHauntableLaunch(inst)
	inst.oneatenfn = oneatenfn
    inst:AddComponent("edible")
    inst.components.edible.healthvalue = 0
    inst.components.edible.hungervalue = 0
    inst.components.edible.sanityvalue = -3
    inst.components.edible.foodtype = FOODTYPE.GOODIES
	inst.components.edible:SetOnEatenFn(inst.oneatenfn)
	inst:AddTag("preparedfood")
	
	inst:ListenForEvent("ondropped",function(inst) 
		local stanton = TheSim:FindFirstEntityWithTag("stanton")
		if stanton ~= nil then
			stanton.TellThemRules(stanton)
		end			
		--inst:Remove() 
	end)
		
	inst:WatchWorldState("isday", function(inst)
		inst:Remove()
	end)
	inst:WatchWorldState("iscaveday", function(inst)
		inst:Remove()
	end)
	
    return inst
end

local function OnDoneTalking(inst)
    if inst.talktask ~= nil then
        inst.talktask:Cancel()
        inst.talktask = nil
    end
    inst.SoundEmitter:KillSound("talk")
end

local function OnTalk(inst)
    OnDoneTalking(inst)
    inst.SoundEmitter:PlaySound("dontstarve/creatures/together/stalker/talk_LP", "talk")
    inst.talktask = inst:DoTaskInTime(2 + math.random() * .5, OnDoneTalking)
end


local function onnear(inst, target)
if inst.contestent ~= nil then
	if inst.contestent == target then
		if inst.tonicout == false then
			inst:ForceFacePoint(target:GetPosition())
			inst.AnimState:PlayAnimation("give")
			inst.AnimState:PushAnimation("give_pst", false)
			inst.AnimState:PushAnimation("idle_loop", true)
			if target.components.inventory ~= nil then
				--OnTalk(inst)
				--inst.components.talker:Say(GetString("generic", "STANTON_GIVE"))
				local tonic = SpawnPrefab("stanton_shadow_tonic")
				target.components.inventory:GiveItem(tonic, nil)
				inst.tonicout = true
			end
		end
	end
else
	inst.contestent = target
	inst:ForceFacePoint(target:GetPosition())
	inst.AnimState:PlayAnimation("give")
	inst.AnimState:PushAnimation("give_pst", false)
	inst.AnimState:PushAnimation("idle_loop", true)
		if target.components.inventory ~= nil then
			OnTalk(inst)
			inst.components.talker:Say(GetString(inst.contestent, "STANTON_GIVE"))
			local tonic = SpawnPrefab("stanton_shadow_tonic")
			target.components.inventory:GiveItem(tonic, nil)
			inst.tonicout = true
		end
		
end
end

local function Refresh(inst)
if inst:GetDistanceSqToInst(inst.contestent) < 5 then
	local target = inst.contestent
	inst:ForceFacePoint(target:GetPosition())
	inst.AnimState:PlayAnimation("give")
	inst.AnimState:PushAnimation("give_pst", false)
	inst.AnimState:PushAnimation("idle_loop", true)
	if target.components.inventory ~= nil then
		local tonic
		if math.random() > 0.5 then
		tonic = SpawnPrefab("stanton_shadow_tonic")
		else
		tonic = SpawnPrefab("stanton_shadow_tonic_fancy")
		end
		target.components.inventory:GiveItem(tonic, nil)
		inst.tonicout = true
	end
else
	OnTalk(inst)
	inst.components.talker:Say(GetString("generic", "STANTON_RESTOCK"))	
	inst.tonicout = false
end
end

local function TellThemRules(inst)
OnTalk(inst)
inst.components.talker:Say(GetString(inst.contestent, "STANTON_RULES"))
inst.AnimState:PlayAnimation("dial_loop",false)
inst.AnimState:PushAnimation("idle_loop",true)
inst:DoTaskInTime(3,Refresh)
end

local function DrinkUp(inst)
	inst.patience = inst.patience+5
    inst.AnimState:PlayAnimation("quick_eat_pre")
    inst.AnimState:PushAnimation("quick_eat", false)
if math.random() < inst.stantonslumberstack and not inst:HasTag("won") then
	inst.AnimState:PushAnimation("dozy",false)
	inst.AnimState:PushAnimation("sleep_loop",true)
	inst:AddTag("dying")
	inst:DoTaskInTime(4,function(inst) 
		inst:AddComponent("health")
		inst.components.lootdropper:DropLoot(inst:GetPosition())
		inst.components.health:Kill() --This makes him fade out
	end)
else
	if inst:HasTag("won") then
		inst.Gloat(inst)
	else
		inst.stantonslumberstack = inst.stantonslumberstack + 0.1
		OnTalk(inst)
		if inst.stantonslumberstack <=.4 then
			inst.components.talker:Say(GetString(inst.contestent, "STANTON_POET"..(inst.stantonslumberstack*10)))
		else
			inst.components.talker:Say(GetString(inst.contestent, "STANTON_POET5"))
		end
			inst.AnimState:PushAnimation("dial_loop",false)
			inst.AnimState:PushAnimation("idle_loop",true)
	
		inst:DoTaskInTime(3,Refresh)
	end
end
end

local function Gloat(inst)
OnTalk(inst)
inst.components.talker:Say(GetString(inst.contestent, "STANTON_GLOAT"))
inst.AnimState:PlayAnimation("dial_loop")
inst.AnimState:PushAnimation("jump")
inst:DoTaskInTime(2.5,function(inst) 
	local x,y,z = inst.Transform:GetWorldPosition()
	SpawnPrefab("maxwell_smoke").Transform:SetPosition(x,y,z)
	inst.Wrath(inst,false)
	inst:Remove() 
end)
end

local function UpdatePatience(inst)
inst.patience = inst.patience-1
if inst.patience <= 0 then
	OnTalk(inst)
	inst.components.talker:Say(GetString(inst.contestent, "STANTON_SUPERIMPATIENT"))
	inst.AnimState:PlayAnimation("dial_loop")
	inst.AnimState:PushAnimation("jump")
	inst:DoTaskInTime(2.5,function(inst) 
		local x,y,z = inst.Transform:GetWorldPosition()
		SpawnPrefab("maxwell_smoke").Transform:SetPosition(x,y,z)
		inst.Wrath(inst,true)
		inst:Remove() 
	end)
end
if inst.patience == 6 then
	OnTalk(inst)
	inst.components.talker:Say(GetString(inst.contestent, "STANTON_IMPATIENT"))
	inst.AnimState:PlayAnimation("dial_loop")
	inst.AnimState:PushAnimation("idle_loop")
end
end

local function TrySpawnSkeleton(inst)
local x,y,z = inst.Transform:GetWorldPosition()
x = x + math.random(-3,3)
z = z + math.random(-3,3)

if TheWorld.Map:IsAboveGroundAtPoint(x,y,z) then
	local skele = SpawnPrefab("rneskeleton")
	skele.Transform:SetPosition(x,y,z)
	skele.decided = true
else
	TrySpawnSkeleton(inst)
end
end

local function Wrath(inst,super)
if super then
	TrySpawnSkeleton(inst)
	TrySpawnSkeleton(inst)
	TrySpawnSkeleton(inst)
end
TrySpawnSkeleton(inst)
end

local function fn_stanton(Sim)
	local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	local shadow = inst.entity:AddDynamicShadow()
    shadow:SetSize( 1.5, .5 )
    inst.entity:AddNetwork()
    inst.entity:AddLightWatcher()
    inst.Transform:SetFourFaced()
	inst.entity:SetPristine()

	inst:AddComponent("talker")        
    inst.components.talker.colour = Vector3(252/255, 226/255, 219/255)
    inst.components.talker.offset = Vector3(0, -500, 0)
    inst.components.talker:MakeChatter()
    inst.components.talker.lineduration = TUNING.HERMITCRAB.SPEAKTIME * 2 -0.5
    if LOC.GetTextScale() == 1 then
		inst.components.talker.fontsize = 30
    end
    inst.components.talker.font = TALKINGFONT_HERMIT
    inst:AddComponent("npc_talker")
	
	if not TheWorld.ismastersim then
        return inst
    end
	inst:AddTag("stanton")
    inst.AnimState:SetBank("wilson")
    inst.AnimState:SetBuild("wilton")
    inst.AnimState:PlayAnimation("jump",false)
	inst:DoTaskInTime(0,function(inst) 
		local x,y,z = inst.Transform:GetWorldPosition()
		SpawnPrefab("maxwell_smoke").Transform:SetPosition(x,y,z)
	end)
	inst:DoTaskInTime(0.7,function(inst) inst.AnimState:PlayAnimation("idle_loop",true) end)
	
	-- Gear handler
    inst.AnimState:Hide("ARM_carry")
    inst.AnimState:Show("ARM_normal")
        inst.AnimState:OverrideSymbol("swap_hat", "hat_straw", "swap_hat")
        inst.AnimState:Show("HAT")
        inst.AnimState:Show("HAIR_HAT")
        inst.AnimState:Hide("HAIR_NOHAT")
        inst.AnimState:Hide("HAIR")	
	--
    inst:AddComponent("inspectable")
    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aura = -TUNING.SANITYAURA_SMALL
	
	
	inst:WatchWorldState("isday", function(inst)
		if not inst:HasTag("dying") then
			inst.AnimState:PlayAnimation("jump")
			inst:DoTaskInTime(0.5,function(inst) inst:Remove() end)
		end
	end)
	inst:WatchWorldState("iscaveday", function(inst)
		if not inst:HasTag("dying") then
			inst.AnimState:PlayAnimation("jump")
			inst:DoTaskInTime(0.5,function(inst) inst:Remove() end)
		end
	end)
	
	inst:DoPeriodicTask(0.5,function(inst)
		if inst.contestent ~= nil then
			inst:ForceFacePoint(inst.contestent:GetPosition())
		end	
	end)
	
	inst.patience = 15
	inst.stantonslumberstack = 0
	inst.tonicout = false
	inst.DrinkUp = DrinkUp
	inst.TellThemRules = TellThemRules
	inst.Refresh = Refresh
	inst.Gloat = Gloat
	inst.Wrath = Wrath
	
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:AddChanceLoot("skullflask",      1.00)
	inst.components.lootdropper:AddChanceLoot("boneshard",    1.00)
	inst.components.lootdropper:AddChanceLoot("boneshard",    1.00)
	inst.components.lootdropper:AddChanceLoot("boneshard",    1.00)
	inst.components.lootdropper:AddChanceLoot("boneshard",    1.00)
	
	inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(2, 3) --set specific values
    inst.components.playerprox:SetOnPlayerNear(onnear)
    inst.components.playerprox:SetPlayerAliveMode(inst.components.playerprox.AliveModes.AliveOnly)
	inst:DoTaskInTime(2,function(inst)
	OnTalk(inst)
	inst.AnimState:PushAnimation("dial_loop",false)
	inst.AnimState:PushAnimation("idle_loop",true)	
	inst.components.talker:Say(GetString("generic", "STANTON_GREET")) 
	end)
	
	inst:DoPeriodicTask(3,function(inst)
		if inst.patience > 0 then
			UpdatePatience(inst)
		end
	end)
    return inst
end

local function oneatenfnflask(inst, eater)
	if eater:HasTag("player") then
		if eater.components.debuffable ~= nil and eater.components.debuffable:IsEnabled() and
					not (eater.components.health ~= nil and eater.components.health:IsDead()) and
					not eater:HasTag("playerghost") then
					local empty = SpawnPrefab("skullflask_empty")
					eater.components.inventory:GiveItem(empty, nil)
					eater.components.debuffable:AddDebuff("buff_hypercourage", "buff_hypercourage")	
		end
	else
		SpawnPrefab("skullflask_empty").Transform:SetPosition(eater.Transform:GetWorldPosition())
	end
end

local function fn_flask()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("skullflask")
    inst.AnimState:SetBuild("skullflask")
    inst.AnimState:PlayAnimation("idle")
	
    MakeInventoryFloatable(inst)
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end


    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/skullflask.xml"
    MakeHauntableLaunch(inst)
    inst:AddComponent("edible")
    inst.components.edible.healthvalue = 0
    inst.components.edible.hungervalue = 0
    inst.components.edible.sanityvalue = -5
    inst.components.edible.foodtype = FOODTYPE.GOODIES
	inst.components.edible:SetOnEatenFn(oneatenfnflask)
	inst:AddTag("preparedfood")
    return inst
end

local function Refill(inst,data)
	if data ~= nil and data.name == "refill" then
		local goop = SpawnPrefab("skullflask")
        local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner or nil
        local holder = owner ~= nil and (owner.components.inventory or owner.components.container) or nil
        if holder ~= nil then
            local slot = holder:GetItemSlot(inst)
            inst:Remove()
            holder:GiveItem(goop)
        else
            local x, y, z = inst.Transform:GetWorldPosition()
            inst:Remove()
            goop.Transform:SetPosition(x, y, z)
        end
		inst:Remove()
	end
end

local function fn_flask_empty()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("skullflask")
    inst.AnimState:SetBuild("skullflask")
    inst.AnimState:PlayAnimation("empty")
	
    MakeInventoryFloatable(inst)
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end


    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/skullflask_empty.xml"
    MakeHauntableLaunch(inst)
	inst:AddComponent("timer")
	inst.components.timer:StartTimer("refill",(8*60))
	inst:ListenForEvent("timerdone", Refill)
	
	
    return inst
end

return Prefab("skullflask", fn_flask),
Prefab("skullflask_empty", fn_flask_empty),
Prefab("stanton_shadow_tonic", fn_tonic),
Prefab("stanton_shadow_tonic_fancy", fn_tonic_fancy),
Prefab("stanton", fn_stanton)
