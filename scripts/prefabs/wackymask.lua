local assets=
{
    Asset("ANIM", "anim/hat_whitecatmask.zip"),
	Asset("ANIM", "anim/ratmask_icon.zip"),
	--Asset("ATLAS", "images/inventoryimages/gasmask.xml"),
	--Asset("IMAGE", "images/inventoryimages/gasmask.tex"),
}

local function pumpkin_disable(inst)
	local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner
	if owner then
		if owner.pumpkinhat_notplantkin then
			owner:RemoveTag("plantkin")
			if owner.components.leader then
				owner.components.leader:RemoveFollowersByTag("plantkin")
			end
			owner.pumpkinhat_notplantkin = nil
		end
	end
end

local function pumpkin_enable(inst)
	local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner
	if owner then
		if not owner:HasTag("plantkin") then
			owner.pumpkinhat_notplantkin = true
			owner:AddTag("plantkin")
		end
		
		if math.random() > 0.5 then
			SpawnPrefab("green_leaves").Transform:SetPosition(owner.Transform:GetWorldPosition())
		else
			SpawnPrefab("orange_leaves").Transform:SetPosition(owner.Transform:GetWorldPosition())
		end
	end
end

local function merm_disable(inst)
	local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner
	if owner then
		if owner.mermhat_wasmonster then
			owner:AddTag("monster")
			owner.mermhat_wasmonster = nil
		end
		if owner.mermhat_notamerm then
			owner:RemoveTag("merm")
			owner:RemoveTag("mermdisguise")
			if owner.components.leader then
				owner.components.leader:RemoveFollowersByTag("merm")
			end
			owner.mermhat_notamerm = nil
		end
	end
end

local function merm_enable(inst)
	local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner
	if owner then
		if owner.components.leader then
			owner.components.leader:RemoveFollowersByTag("pig")
		end

		if not owner:HasTag("merm") then
			owner.mermhat_notamerm = true
			owner:AddTag("merm")
			owner:AddTag("mermdisguise")
		end
		if owner:HasTag("monster") then
			owner.mermhat_wasmonster = true
			owner:RemoveTag("monster")
		end
		
		owner.SoundEmitter:PlaySound("dontstarve/creatures/merm/attack")
	end
end

local function pig_disable(inst)
	local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner
	if owner then
		if owner.pighat_notapig then
			owner:RemoveTag("pig")
			if owner.components.leader then
				owner.components.leader:RemoveFollowersByTag("pig")
			end
			owner.pighat_notapig = nil
		end
		
		
		if owner.pighat_notpolite then
			owner:RemoveTag("polite")
			owner.pighat_notpolite = nil
		end
	end
end

local function pig_enable(inst)
	local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner
	if owner then
		if owner.components.leader then
			owner.components.leader:RemoveFollowersByTag("merm")
		end

		if not owner:HasTag("pig") then
			owner.pighat_notapig = true
			owner:AddTag("pig")
		end
		
		if not owner:HasTag("polite") then
			owner.pighat_notpolite = true
			owner:AddTag("polite")
		end
		
		owner.SoundEmitter:PlaySound("dontstarve/pig/oink")
	end
end

local function skeleton_disable(inst)
	local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner
	if owner then
		if owner:HasTag("rneskeleton") then
			owner:RemoveTag("rneskeleton")
		end
	end
end

local function skeleton_enable(inst)
	local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner
	if owner then
		if owner:HasTag("rneskeleton") then
			owner:RemoveTag("rneskeleton")
		end
	end
end

local function demon_disable(inst)
	local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner
	if owner then
		if owner.components.health ~= nil then
			owner.components.health.externalfiredamagemultipliers:RemoveModifier(inst)
		end
	end
end

local function demon_enable(inst)
	local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner
	if owner then
		if owner.components.health ~= nil then
			owner.components.health.externalfiredamagemultipliers:SetModifier(inst, 1 - 0.75)
		end
	end
end

local function goop_disable(inst)
	local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner
	if owner then
        if owner.components.hunger ~= nil then
            owner.components.hunger.burnratemodifiers:RemoveModifier(inst)
        end
	end
end

local function goop_enable(inst)
	local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner
	if owner then
        if owner.components.hunger ~= nil then
            owner.components.hunger.burnratemodifiers:SetModifier(inst, 0.85)
        end
	end
end

local function GetGender(charactername)
    if table.contains(CHARACTER_GENDERS.MALE, charactername.prefab) then
        return "MALE"
    elseif table.contains(CHARACTER_GENDERS.FEMALE, charactername.prefab) then
        return "FEMALE"
    else
        return "THEY"
    end
end

local function ghost_enable(inst)
	local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner
	if owner then
		if not owner:HasTag("abigail") then
			owner.ghostmask_notaghostfriend = true
			owner:AddTag("abigail")
		end
			
		if GetGender(owner) == "FEMALE" then
			owner.SoundEmitter:PlaySound("dontstarve/ghost/ghost_girl_howl")
		elseif GetGender(owner) == "MALE" then
			owner.SoundEmitter:PlaySound("dontstarve/ghost/ghost_howl")
		else
			if math.random() > 0.5 then
				owner.SoundEmitter:PlaySound("dontstarve/ghost/ghost_girl_howl")
			else
				owner.SoundEmitter:PlaySound("dontstarve/ghost/ghost_howl")
			end
		end
	end
end

local function ghost_disable(inst)
	local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner
	if owner then
		if owner.ghostmask_notaghostfriend then
			owner:RemoveTag("abigail")
			owner.ghostmask_notaghostfriend = nil
		end
	end
end

local function joy_enable(inst)
	local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner
	if owner then
		owner.SoundEmitter:PlaySound("dontstarve/creatures/together/klaus/lol")
		--owner.SoundEmitter:PlaySound("dontstarve/creatures/together/stalker/laugh")
	end
end

local function joy_disable(inst)
	local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner
	if owner then
		if owner.components.sanity then
			owner.components.sanity:DoDelta(-50)
		end
	end
end

local function TechnoSpark(inst)
	local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner
	if owner then
		local x, y, z = owner.Transform:GetWorldPosition()
		SpawnPrefab("sparks").Transform:SetPosition(x, y + 1 + math.random() * 1.5, z)
	end
end

local function TechnoTask(inst)
	inst:DoTaskInTime(math.random(), TechnoSpark)
end

local function techno_disable(inst)
	if inst.technospark then
		inst.technospark:Cancel()
		inst.technospark = nil
	end
end
	
local function techno_enable(inst)
	local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner
	if owner then
		owner.SoundEmitter:PlaySound("dontstarve/characters/wx78/levelup")
	end
	
	inst.technospark = inst:DoPeriodicTask(1, TechnoTask)
end

local SLEEPTARGETS_CANT_TAGS = { "playerghost", "FX", "DECOR", "INLIMBO" }
local SLEEPTARGETS_ONEOF_TAGS = { "sleeper", "player" }

local function MandrakeScream(inst)
	inst:DoTaskInTime(0.5, function(inst)
		inst.SoundEmitter:PlaySound("dontstarve/creatures/mandrake/death")
		
		local x, y, z = inst.Transform:GetWorldPosition()
		local ents = TheSim:FindEntities(x, y, z, TUNING.MANDRAKE_SLEEP_RANGE, nil, SLEEPTARGETS_CANT_TAGS, SLEEPTARGETS_ONEOF_TAGS)
		local canpvp = not inst:HasTag("player") or TheNet:GetPVPEnabled()
		for i, v in ipairs(ents) do
			if (v == inst or canpvp or not v:HasTag("player")) and
				not (v.components.freezable ~= nil and v.components.freezable:IsFrozen()) and
				not (v.components.pinnable ~= nil and v.components.pinnable:IsStuck()) and
				not (v.components.fossilizable ~= nil and v.components.fossilizable:IsFossilized()) then
				local mount = v.components.rider ~= nil and v.components.rider:GetMount() or nil
				if mount ~= nil then
					mount:PushEvent("ridersleep", { sleepiness = 7, sleeptime = TUNING.MANDRAKE_SLEEP_TIME + math.random() })
				end
				if v:HasTag("player") then
					v:PushEvent("yawn", { grogginess = 4, knockoutduration = TUNING.MANDRAKE_SLEEP_TIME + math.random() })
				elseif v.components.sleeper ~= nil then
					v.components.sleeper:AddSleepiness(7, TUNING.MANDRAKE_SLEEP_TIME + math.random())
				elseif v.components.grogginess ~= nil then
					v.components.grogginess:AddGrogginess(4, TUNING.MANDRAKE_SLEEP_TIME + math.random())
				else
					v:PushEvent("knockedout")
				end
			end
		end
	end)
end
	
local function mandrake_enable(inst)
	local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner
	if owner then
		owner.SoundEmitter:PlaySound("dontstarve/creatures/mandrake/pop")
		owner:ListenForEvent("attacked", MandrakeScream)
	end
end
	
local function mandrake_disable(inst)
	local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner
	if owner then
		owner:RemoveEventCallback("attacked", MandrakeScream)
	end
end

local function stopusingopossum(inst, data)
	local hat = inst.components.inventory ~= nil and inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD) or nil
	if hat ~= nil and data.statename ~= "hide" then
		hat.components.useableitem:StopUsingItem()
	end
end

local function opossum_enable(inst)
	local owner = inst.components.inventoryitem.owner
	if owner then
		inst:ListenForEvent("newstate", stopusingopossum, owner)
	end
end

local function opossum_disable(inst)
	local owner = inst.components.inventoryitem.owner
	if owner then
		inst:RemoveEventCallback("newstate", stopusingopossum, owner)
	end
end

local function opossum_onuse(inst)
	local owner = inst.components.inventoryitem.owner
	if owner then
		owner.sg:GoToState("opossum_death")
	end
end

local function FindClosestPart(owner)
	local ix, iy, iz = owner.Transform:GetWorldPosition()

	local burrows = TheSim:FindEntities(ix, iy, iz, 2000, {"ratburrow"})
	if burrows ~= nil then
		for i, v in ipairs(burrows) do
			if owner.SoundEmitter ~= nil then
				owner:DoTaskInTime(i, function(owner)
					for i = 1,5 do
						local delay = i / 10
					
						owner:DoTaskInTime(FRAMES * i * 1.5 + delay, function()
							if v ~= nil then
								local x, y, z = owner.Transform:GetWorldPosition()
								local px, py, pz = v.Transform:GetWorldPosition()
								local rad = math.rad(owner:GetAngleToPoint(px, py, pz))
								local velx = math.cos(rad) * 4.5
								local velz = -math.sin(rad) * 4.5
							
								local dx, dy, dz = x + ((i/2) * velx), 0, z + ((i/2) * velz)
								
								local fx1 = SpawnPrefab("ratring_fx")
								fx1.Transform:SetPosition(dx, dy, dz)
								fx1.Transform:SetScale(0.6 - delay, 0.6 - delay, 0.6 - delay)
								fx1.SoundEmitter:PlaySound("UCSounds/ratsniffer/burrowping", nil, 1 - delay)
							end
						end)
					end
				end)
			end
		end
	elseif burrows == nil or burrows <= 0 then
		inst.components.talker:Say(GetString(owner, "ANNOUNCE_NORATBURROWS"))
	end
end

local function OnCooldown(inst)
	inst.components.useableitem.inuse = false
end

local NOTAGS =
{
	"smallcreature",
	"_container",
	"spore",
}
local function IsAVersionOfRot(v)
	if v.prefab == "spoiled_food" or v.prefab == "rottenegg" or v.prefab == "spoiled_fish" or v.prefab == "spoiled_fish_small" then
		return true
	end
end

local function TrySpawnIcon(v,intensity)
	local nearbyicon = FindEntity(v,2,nil,{"ratmask_stinklines"})
	if nearbyicon ~= nil then
		nearbyicon.Resize(nearbyicon,intensity)
	else	
		local icon = SpawnPrefab("ratmask_stinklines")
		local x,y,z = v.Transform:GetWorldPosition()
		icon.Transform:SetPosition(x,y,z)
		icon.Resize(icon,intensity)
	end
end

local function FoodScoreCalculations(container,v)
	if container then
		if v:HasTag("stale") then
			TrySpawnIcon(v,.5)
		end
		if v:HasTag("spoiled") then
			TrySpawnIcon(v,.75)
		end
		if IsAVersionOfRot(v) then
			TrySpawnIcon(v,1)
		end
	else
		if v:HasTag("fresh") then
			TrySpawnIcon(v,.5)
		end
		if v:HasTag("stale") then
			TrySpawnIcon(v,.75)
		end
		if v:HasTag("spoiled") then
			TrySpawnIcon(v,.8)
		end
		if IsAVersionOfRot(v) then
			TrySpawnIcon(v,1)
		end
	end
end

local function Sniffertime(owner)
	local x, y, z = owner.Transform:GetWorldPosition()

	local ents = TheSim:FindEntities(x, 0, z, 20, {"_inventoryitem"},NOTAGS)
	if ents ~= nil then
		for i, v in ipairs(ents) do
			if v.components.inventoryitem:IsHeld() then
				if v.components.inventoryitem and v.components.inventoryitem:GetGrandOwner() ~= nil and not (v.components.inventoryitem:GetGrandOwner().prefab == "lureplant" or v.components.inventoryitem:GetGrandOwner().prefab == "catcoon") then
					if not (v:HasTag("frozen") or v:HasTag("NORATCHECK")) and v.components.farmplantable == nil then
						FoodScoreCalculations(true,v)
					end
				end
			else
				if not (v:HasTag("frozen") or v:HasTag("NORATCHECK")) and v.components.farmplantable == nil then
					FoodScoreCalculations(false,v)
				end
				if not (v:HasTag("balloon") or v:HasTag("heavy") or v:HasTag("projectile") or v:HasTag("NORATCHECK")) then
					if (v:HasTag("_equippable") or v:HasTag("gem") or v:HasTag("tool"))  then
						TrySpawnIcon(v,.5)
					elseif v:HasTag("molebait") then
						TrySpawnIcon(v,.5)
					end
				end
			end
		end
	end
end

local function CheckTargetPiece(inst)
	local owner = inst.components.inventoryitem.owner
		
    if owner ~= nil then
		FindClosestPart(owner)
		inst.fx = SpawnPrefab("ratring_fx")
		inst.fx.entity:AddFollower()
		inst.fx.Follower:FollowSymbol(owner.GUID, "swap_hat", 0, 0, 0)
		inst.fx.Transform:SetScale(0.5, 0.5, 0.5)
				
		inst.SoundEmitter:KillSound("ratping")
		inst.SoundEmitter:PlaySound("UCSounds/ratping/ping_hotter", "ratping")
	end
    if owner ~= nil and FindEntity(owner,40,nil,{"rat_sniffer"}) ~= nil then
		Sniffertime(owner)
	end	
	
    inst.components.rechargeable:Discharge(8)
end

local function rat_enable(inst)
	local owner = inst.components.inventoryitem.owner
	
	if owner ~= nil and not owner:HasTag("equipmentmodel") then
		inst.components.fueled:StartConsuming()
		owner:AddTag("ratfriend")
		owner.SoundEmitter:PlaySound("turnoftides/creatures/together/carrat/emerge")
	end
end

local function rat_disable(inst)
    inst.components.fueled:StopConsuming()
	
	local owner = inst.components.inventoryitem.owner
	if owner then
		owner:RemoveTag("ratfriend")
	end
end

local function Hack(inst, data)
	local snap = SpawnPrefab("impact")
	local x, y, z = inst.Transform:GetWorldPosition()
	local x1, y1, z1 = data.target.Transform:GetWorldPosition()
	local angle = -math.atan2(z1 - z, x1 - x)
	snap.Transform:SetPosition(x1, 1.2, z1)
	snap.Transform:SetRotation(angle * RADIANS)
	snap.Transform:SetScale(0.8, 0.8, 0.8)
		
	if data.target.components.health ~= nil and not data.target.components.health:IsDead() then
		data.target.components.health:DoDelta(-5, false, inst)
	end
		
	if inst.components.sanity then
		inst.components.sanity:DoDelta(-1)
	end
	
	inst.SoundEmitter:PlaySound("dontstarve/impacts/impact_stone_wall_sharp")
end

local function hockey_enable(inst)
	local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner
	if owner then
		owner:ListenForEvent("onattackother", Hack)
	end
end

local function hockey_disable(inst)
	local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner
	if owner then
		owner:RemoveEventCallback("onattackother", Hack)
	end
end

local function cat_enable(inst)
	local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner
	if owner then
		owner.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/catcoon/pickup")
	end
end

local function clown_enable(inst)
	local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner
	if owner then
		owner.SoundEmitter:PlaySound("wes/characters/wes/balloon_party")
	end
end

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_hat", inst.bank, "swap_hat")	
	
	if inst.bank == "hat_bagmask" then
		owner.AnimState:Show("HAT")
		owner.AnimState:Show("HAIR_NOHAT")
		--owner.AnimState:Hide("HAIR_NOHAT")
		owner.AnimState:Show("HAIR_NOHAT")
		owner.AnimState:Hide("HAIR")
		owner.AnimState:Hide("HAIRFRONT")
		owner.AnimState:Hide("HEAD")
	else
		owner.AnimState:Show("HAT")
		owner.AnimState:Hide("HAIR_HAT")
		owner.AnimState:Show("HAIR_NOHAT")
		owner.AnimState:Show("HAIR")
		owner.AnimState:Show("HAIRFRONT")
	end
	
	if inst.customequip ~= nil then
		inst.customequip(inst)
	end
	
	if owner ~= nil and not owner:HasTag("equipmentmodel") then
		inst.components.fueled:StartConsuming()
	end
end
 
local function onunequip(inst, owner)
	--owner.AnimState:Show("HAIR_NOHAT")
	owner.AnimState:Show("HAIR")
    owner.AnimState:ClearOverrideSymbol("swap_hat")
	owner.AnimState:ClearOverrideSymbol("face")
    owner.AnimState:Hide("HAT")
	owner.AnimState:Show("HEAD")
	
	if inst.customunequip ~= nil then
		inst.customunequip(inst)
	end

	inst.components.fueled:StopConsuming()
end

local function fncommon(bank, build)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
	
    MakeInventoryPhysics(inst)
	
	inst.bank = bank
	
    inst.AnimState:SetBank(bank)
    inst.AnimState:SetBuild(bank)
    inst.AnimState:PlayAnimation("anim")  

	inst:AddTag("hats")
	
	MakeInventoryFloatable(inst, "small")
	
    inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/"..bank..".xml"

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
	
	inst:AddComponent("fueled")
	inst.components.fueled.fueltype = FUELTYPE.USAGE
	inst.components.fueled:InitializeFuelLevel(480)
	inst.components.fueled:SetDepletedFn(--[[generic_perish]]inst.Remove)
	
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip )
    
	MakeHauntableLaunch(inst)
	
    return inst
end

local function bagfn()
    local inst = fncommon("hat_bagmask", "hat_bagmask")
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.equippable.dapperness = TUNING.DAPPERNESS_MED
	
    return inst
end

local function blackcatfn()
    local inst = fncommon("hat_blackcatmask", "hat_blackcatmask")

	inst:AddTag("nightvision")
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.customequip = cat_enable
	
	inst.components.equippable.dapperness = TUNING.CRAZINESS_SMALL
	
    return inst
end

local function clownfn()
    local inst = fncommon("hat_clownmask", "hat_clownmask")
	
	inst.foleysound = "wes/common/foley/balloon_vest"
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.customequip = clown_enable
	
	inst.components.equippable.dapperness = TUNING.DAPPERNESS_MED_LARGE
	
    return inst
end

local function wathomfn()
    local inst = fncommon("hat_wathommask", "hat_wathommask")
	
	inst:AddTag("goggles")
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.equippable.dapperness = TUNING.CRAZINESS_SMALL
	
    return inst
end

local function devilfn()
    local inst = fncommon("hat_devilmask", "hat_devilmask")
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.customequip = demon_enable
	inst.customunequip = demon_disable
	
	inst.components.equippable.dapperness = TUNING.DAPPERNESS_MED_LARGE
	
    return inst
end

local function fiendfn()
    local inst = fncommon("hat_fiendmask", "hat_fiendmask")
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.customequip = demon_enable
	inst.customunequip = demon_disable
	
	inst.components.equippable.dapperness = TUNING.DAPPERNESS_MED_LARGE
	
    return inst
end

local function ghostfn()
    local inst = fncommon("hat_ghostmask", "hat_ghostmask")
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.customequip = ghost_enable
	inst.customunequip = ghost_disable
	
	inst.components.equippable.dapperness = TUNING.CRAZINESS_SMALL
	
    return inst
end

local function globfn()
    local inst = fncommon("hat_globmask", "hat_globmask")
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.customequip = goop_enable
	inst.customunequip = goop_disable
	
	inst.components.equippable.equippedmoisture = 0.5
	inst.components.equippable.maxequippedmoisture = 32
		
	inst.components.equippable.dapperness = TUNING.DAPPERNESS_SMALL
	
    return inst
end

local function hockeyfn()
    local inst = fncommon("hat_hockeymask", "hat_hockeymask")
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.customequip = hockey_enable
	inst.customunequip = hockey_disable
	
	inst.components.equippable.dapperness = TUNING.DAPPERNESS_SMALL
	
    return inst
end

local function joyousfn()
    local inst = fncommon("hat_joyousmask", "hat_joyousmask")
    if not TheWorld.ismastersim then
        return inst
    end
	inst.customequip = joy_enable
	inst.customunequip = joy_disable
	
	inst.components.equippable.dapperness = TUNING.DAPPERNESS_SUPERHUGE
	
    return inst
end

local function mermfn()
    local inst = fncommon("hat_mermmask", "hat_mermmask")
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.customequip = merm_enable
	inst.customunequip = merm_disable
	
	inst.components.equippable.dapperness = -TUNING.DAPPERNESS_TINY
	
    return inst
end

local function oozefn()
    local inst = fncommon("hat_oozemask", "hat_oozemask")
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.customequip = goop_enable
	inst.customunequip = goop_disable
	
	inst.components.equippable.equippedmoisture = 0.5
	inst.components.equippable.maxequippedmoisture = 32
		
	inst.components.equippable.dapperness = TUNING.DAPPERNESS_SMALL
	
    return inst
end

local function orangecatfn()
    local inst = fncommon("hat_orangecatmask", "hat_orangecatmask")

	inst:AddTag("nightvision")
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.customequip = cat_enable
	
	inst.components.equippable.dapperness = TUNING.CRAZINESS_SMALL
	
    return inst
end

local function phantomfn()
    local inst = fncommon("hat_phantommask", "hat_phantommask")
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.customequip = ghost_enable
	inst.customunequip = ghost_disable
	
	inst.components.equippable.dapperness = TUNING.CRAZINESS_SMALL
	
    return inst
end

local function pigfn()
    local inst = fncommon("hat_pigmask", "hat_pigmask")
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.customequip = pig_enable
	inst.customunequip = pig_disable
	
	inst.components.equippable.dapperness = TUNING.DAPPERNESS_MED
	
    return inst
end

local function pumpgorefn()
    local inst = fncommon("hat_pumpgoremask", "hat_pumpgoremask")
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.customequip = pumpkin_enable
	inst.customunequip = pumpkin_disable
	
	inst.components.equippable.dapperness = TUNING.CRAZINESS_SMALL
	
    return inst
end

local function redskullfn()
    local inst = fncommon("hat_redskullmask", "hat_redskullmask")
	
	inst.foleysound = "dontstarve/creatures/together/stalker/minion/step"
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.customequip = skeleton_enable
	inst.customunequip = skeleton_disable
	
	inst.components.equippable.dapperness = TUNING.DAPPERNESS_MED
	
    return inst
end

local function skullfn()
    local inst = fncommon("hat_skullmask", "hat_skullmask")
	
	inst.foleysound = "dontstarve/creatures/together/stalker/minion/step"
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.customequip = skeleton_enable
	inst.customunequip = skeleton_disable
	
	inst.components.equippable.dapperness = TUNING.DAPPERNESS_MED
	
    return inst
end

local function spectrefn()
    local inst = fncommon("hat_spectremask", "hat_spectremask")
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.customequip = ghost_enable
	inst.customunequip = ghost_disable
	
	inst.components.equippable.dapperness = TUNING.CRAZINESS_SMALL
	
    return inst
end

local function whitecatfn()
    local inst = fncommon("hat_whitecatmask", "hat_whitecatmask")

	inst:AddTag("nightvision")
		
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.customequip = cat_enable
	
	inst.components.equippable.dapperness = TUNING.CRAZINESS_SMALL
	
    return inst
end

local function technofn()
    local inst = fncommon("hat_technomask", "hat_technomask")
	
	inst.foleysound = "dontstarve/movement/foley/wx78"
		
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.customequip = techno_enable
	inst.customunequip = techno_disable
	
	inst.components.equippable.dapperness = TUNING.DAPPERNESS_SMALL
	inst.components.equippable.insulated = true
	
    return inst
end

local function mandrakefn()
    local inst = fncommon("hat_mandrakemask", "hat_mandrakemask")

	inst.foleysound = "dontstarve/creatures/mandrake/walk"
		
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.customequip = mandrake_enable
	inst.customunequip = mandrake_disable
	
	inst.components.equippable.dapperness = TUNING.DAPPERNESS_MED_LARGE
	
    return inst
end

local function opossumfn()
    local inst = fncommon("hat_opossummask", "hat_opossummask")

	inst:AddTag("hide")
		
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.customequip = opossum_enable
	inst.customunequip = opossum_disable

	inst:AddComponent("useableitem")
	inst.components.useableitem:SetOnUseFn(opossum_onuse)
	
	inst.components.equippable.dapperness = TUNING.DAPPERNESS_MED
	
    return inst
end

local function Icon_Resize(inst,intensity)
	inst.intensity = intensity + inst.intensity
	if inst.intensity > 2 then
		inst.intensity = inst.intensity/1.2
	end
	if inst.intensity > 4 then
		inst.intensity = inst.intensity/1.5
	end
	inst.Transform:SetScale(inst.intensity,inst.intensity,inst.intensity)
end

local function Icon_Resize_Stink(inst,intensity)
	inst.Transform:SetScale(intensity, intensity, intensity)
end

local function ratmask_iconfn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
	

    inst.AnimState:SetBank("ratmask_icon")
    inst.AnimState:SetBuild("ratmask_icon")
     
	inst:AddTag("INLIMBO")
	inst:AddTag("ratmask_icon")
	
    inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	inst.intensity = 1.5
	inst.Resize = Icon_Resize
	inst.AnimState:PlayAnimation("anim"..math.random(0,2)) 
	inst:ListenForEvent("animover",function(inst) inst:Remove() end)
	return inst
end

local function ratmask_stinkfn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
	
    inst.AnimState:SetBank("fumes_fx")
    inst.AnimState:SetBuild("fumes_fx")
     
	inst:AddTag("INLIMBO")
	inst:AddTag("ratmask_stinklines")
	
    inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.Resize = Icon_Resize_Stink
	inst.anim_loop = 1
	inst.anim_loop_rand = math.random(2, 3)
	
	inst:DoTaskInTime(math.random(0, .5), function()
		inst.AnimState:PlayAnimation("fumes")
	end)
	
	inst:ListenForEvent("animover",function(inst)
		if inst.anim_loop >= inst.anim_loop_rand then
			inst:Remove() 
		else
			inst.anim_loop = inst.anim_loop + 1	
			inst.AnimState:PlayAnimation("fumes") 
		end
	end)
	
	return inst
end

local function ratfn()
    local inst = fncommon("hat_ratmask", "hat_ratmask")
	
    inst.entity:AddSoundEmitter()     
		
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.customequip = rat_enable
	inst.customunequip = rat_disable
	
	inst.components.equippable.dapperness = TUNING.CRAZINESS_SMALL
	
	inst:AddComponent("useableitem")
	inst.components.useableitem:SetOnUseFn(CheckTargetPiece)
	
    inst:AddComponent("rechargeable")
    inst.components.rechargeable:SetOnChargedFn(OnCooldown)
	inst.components.rechargeable:SetCharge(1011111)
	
	inst:AddComponent("fueled")
	inst.components.fueled.fueltype = FUELTYPE.USAGE
	inst.components.fueled:InitializeFuelLevel(TUNING.MOLEHAT_PERISHTIME)
	inst.components.fueled:SetDepletedFn(--[[generic_perish]]inst.Remove)
	
    return inst
end

local function PlayRingAnim(proxy)
    local inst = CreateEntity()

    inst:AddTag("FX")
    --[[Non-networked entity]]
    inst.entity:SetCanSleep(false)
    inst.persists = false

    inst.entity:AddTransform()
    inst.entity:AddAnimState()

    inst.Transform:SetFromProxy(proxy.GUID)

    inst.AnimState:SetBank("bearger_ring_fx")
    inst.AnimState:SetBuild("bearger_ring_fx")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetFinalOffset(3)

    inst.AnimState:SetOrientation( ANIM_ORIENTATION.OnGround )
    inst.AnimState:SetLayer( LAYER_BACKGROUND )
    inst.AnimState:SetSortOrder( 3 )

    inst:ListenForEvent("animover", inst.Remove)
end

local function ratringfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddSoundEmitter()     
    inst.entity:AddNetwork()

    inst:AddTag("FX")

    --Dedicated server does not need to spawn the local fx
    if not TheNet:IsDedicated() then
        --Delay one frame so that we are positioned properly before starting the effect
        --or in case we are about to be removed
        inst:DoTaskInTime(0, PlayRingAnim)
    end

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false
    inst:DoTaskInTime(3, inst.Remove)

    return inst
end

return Prefab("hat_bagmask", bagfn, assets),
		Prefab("hat_blackcatmask", blackcatfn, assets),
		Prefab("hat_clownmask", clownfn, assets),
		Prefab("hat_wathommask", wathomfn, assets),
		Prefab("hat_devilmask", devilfn, assets),
		Prefab("hat_fiendmask", fiendfn, assets),
		Prefab("hat_ghostmask", ghostfn, assets),
		Prefab("hat_globmask", globfn, assets),
		Prefab("hat_hockeymask", hockeyfn, assets),
		Prefab("hat_joyousmask", joyousfn, assets),
		Prefab("hat_mermmask", mermfn, assets),
		Prefab("hat_oozemask", oozefn, assets),
		Prefab("hat_orangecatmask", orangecatfn, assets),
		Prefab("hat_phantommask", phantomfn, assets),
		Prefab("hat_pigmask", pigfn, assets),
		Prefab("hat_pumpgoremask", pumpgorefn, assets),
		Prefab("hat_redskullmask", redskullfn, assets),
		Prefab("hat_skullmask", skullfn, assets),
		Prefab("hat_spectremask", spectrefn, assets),
		Prefab("hat_whitecatmask", whitecatfn, assets),
		Prefab("hat_technomask", technofn, assets),
		Prefab("hat_mandrakemask", mandrakefn, assets),
		Prefab("hat_opossummask", opossumfn, assets),
		Prefab("hat_ratmask", ratfn, assets),
		Prefab("ratring_fx", ratringfn, assets),
		Prefab("ratmask_icon", ratmask_iconfn, assets),
		Prefab("ratmask_stinklines", ratmask_stinkfn, assets)