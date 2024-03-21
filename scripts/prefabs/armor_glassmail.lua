local function OnBlocked(owner, data)
    owner.SoundEmitter:PlaySound("dontstarve/wilson/hit_scalemail")
	--local lavaetaken = false

	for i = 1,8 do
		if owner.lavae[i].hidden == false then --and lavaetaken == false  then --I changed my mind, shatter ALL the lavae, like a *glass* cannon XD
			owner.lavae[i].PlayBreakSound(owner.lavae[i])
			owner.lavae[i].BreakShard(owner.lavae[i])
			owner.lavae[i]:Hide()
			owner.lavae[i].hidden = true
			owner.lavae[i].Light:Enable(false)
			--lavaetaken = true
		end
	end
end

local function SpawnGlassDummies(inst)
	local x,y,z = inst.Transform:GetWorldPosition()
	local LIMIT = 2
	inst.lavae = {}
	for i = 1,8 do
		inst.lavae[i] = SpawnPrefab("armor_glassmail_shards")
		inst.lavae[i].WINDSTAFF_CASTER = inst
		inst.lavae[i].components.linearcircler:SetCircleTarget(inst)
		inst.lavae[i].components.linearcircler:Start()
		inst.lavae[i].components.linearcircler.randAng = i*0.125
		inst.lavae[i].components.linearcircler.clockwise = false
		inst.lavae[i].components.linearcircler.distance_limit = LIMIT
		inst.lavae[i].components.linearcircler.setspeed = 0.2
		inst.lavae[i]:Hide()
		inst.lavae[i].hidden = true
	end
end

local function RemoveGlassDummies(inst)
	for i = 1,8 do
		if inst.lavae[i] ~= nil then
			if inst.lavae[i].hidden == false then --and lavaetaken == false  then --I changed my mind, shatter ALL the lavae, like a *glass* cannon XD
				inst.lavae[i].PlayBreakSound(inst.lavae[i])
				inst.lavae[i].BreakShard(inst.lavae[i])
			end
			inst.lavae[i]:Remove()
		end
	end
end

local function TempDamage(inst)
	for i = 1,8 do
		inst.lavae[i].Speen(inst.lavae[i])
	end
end

local function TryAddCrystal(inst)
local rand = math.random(1,8)
	if inst.lavae[rand].hidden then
		inst.lavae[rand].hidden = false
		inst.lavae[rand]:Show()
		inst.lavae[rand].Light:Enable(true)
		inst.lavae[rand].SummonShard(inst.lavae[rand])
	else
		TryAddCrystal(inst)
	end
end

local function NoCrystalsLeftToSpawn(inst)
local val = true
for i = 1,8 do
	if inst.lavae[i].hidden then
		val = false 
	end
end
return val
end

local function UpdateGlass(inst,data)
    if data and data.target and (data.target.components.combat and data.target.components.combat.defaultdamage > 0) or (data.target.prefab == "dummytarget" or data.target.prefab == "antlion" or data.target.prefab == "stalker_atrium" or data.target.prefab == "stalker")  then
        TempDamage(inst)
        if inst.armormeleehits == nil then
            inst.armormeleehits = 0
        end
        inst.armormeleehits = inst.armormeleehits + 1
        if inst.armormeleehits >= 3 and NoCrystalsLeftToSpawn(inst) == false then
            TryAddCrystal(inst)
            inst.armormeleehits = 0
        end
    end
end

local function onequip(inst, owner)

    owner.AnimState:OverrideSymbol("swap_body", "armor_glassmail", "swap_body")

	SpawnGlassDummies(owner)
	
    inst:ListenForEvent("blocked", OnBlocked, owner)
    inst:ListenForEvent("attacked", OnBlocked, owner)
	owner:ListenForEvent("onattackother", UpdateGlass)
	
    if owner.components.health ~= nil then
        owner.components.health.externalfiredamagemultipliers:SetModifier(inst, 1 - TUNING.ARMORDRAGONFLY_FIRE_RESIST)
    end
	
    if inst._light == nil or not inst._light:IsValid() then
        inst._light = SpawnPrefab("armor_glassmail_light")
    end
    if owner ~= nil then
        inst._light.entity:SetParent(owner.entity)
    end	
end

local function onunequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")

    inst:RemoveEventCallback("blocked", OnBlocked, owner)
    inst:RemoveEventCallback("attacked", OnBlocked, owner)
	owner:RemoveEventCallback("onattackother", UpdateGlass)
	
    if owner.components.health ~= nil then
        owner.components.health.externalfiredamagemultipliers:RemoveModifier(inst)
    end
    if inst._light ~= nil then
		if inst._light:IsValid() then
           inst._light:Remove()
        end
    inst._light = nil
    end
	RemoveGlassDummies(owner)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
	inst.entity:AddLight()
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")

    inst.Light:SetColour(111/255, 111/255, 227/255)
    inst.Light:SetIntensity(0.75)
    inst.Light:SetFalloff(0.5)
    inst.Light:SetRadius(0.5)
    inst.Light:Enable(true)  
	
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("armor_glassmail")
    inst.AnimState:SetBuild("armor_glassmail")
    inst.AnimState:PlayAnimation("anim")

    MakeInventoryFloatable(inst, "small", 0.2, 0.80)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/armor_glassmail.xml"
	
    inst:AddComponent("armor")
    inst.components.armor:InitCondition(TUNING.ARMORDRAGONFLY, TUNING.ARMORDRAGONFLY_ABSORPTION)

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY

    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

	inst:AddComponent("timer")
	
    MakeHauntableLaunch(inst)
    return inst
end

local function armor_glassmail_light_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    inst:AddTag("FX")

    inst.Light:SetColour(111/255, 111/255, 227/255)
    inst.Light:SetIntensity(0.75)
    inst.Light:SetFalloff(0.5)
    inst.Light:SetRadius(0.5)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    return inst
end

return Prefab("armor_glassmail", fn),
Prefab("armor_glassmail_light", armor_glassmail_light_fn)

