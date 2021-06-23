local env = env
GLOBAL.setfenv(1, GLOBAL)
----------------------------------------------------------------
local easing = require("easing")

local function OnDead(inst)
    AwardRadialAchievement("spiderqueen_killed", inst:GetPosition(), TUNING.ACHIEVEMENT_RADIUS_FOR_GIANT_KILL)
	if not inst:HasTag("nodecomposepls") then
	local corpse = SpawnPrefab("spiderqueencorpse")
	corpse.Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst:DoTaskInTime(0.3, function(inst)
	inst:Remove()
	end)
	end
end


local projectile_prefabs =
{
    "spat_splat_fx",
    "spat_splash_fx_full",
    "spat_splash_fx_med",
    "spat_splash_fx_low",
    "spat_splash_fx_melted",
}
--These weapons are unused since the part of her brain that can use them is inactive
local function EquipWeapons(inst)
    if inst.components.inventory ~= nil and not inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) then
        local snotbomb = CreateEntity()
        snotbomb.name = "Snotbomb"
        --[[Non-networked entity]]
        snotbomb.entity:AddTransform()
        snotbomb:AddComponent("weapon")
        snotbomb.components.weapon:SetDamage(TUNING.SPAT_PHLEGM_DAMAGE)
        snotbomb.components.weapon:SetRange(TUNING.SPAT_PHLEGM_ATTACKRANGE)
        snotbomb.components.weapon:SetProjectile("queen_web_bomb")
        snotbomb:AddComponent("inventoryitem")
        snotbomb.persists = false
        snotbomb.components.inventoryitem:SetOnDroppedFn(snotbomb.Remove)
        snotbomb:AddComponent("equippable")
        snotbomb:AddTag("snotbomb")

        inst.components.inventory:GiveItem(snotbomb)
        inst.weaponitems.snotbomb = snotbomb

        local meleeweapon = CreateEntity()
        meleeweapon.name = "Snaut Bash"
        --[[Non-networked entity]]
        meleeweapon.entity:AddTransform()
        meleeweapon:AddComponent("weapon")
        meleeweapon.components.weapon:SetDamage(TUNING.SPIDERQUEEN_DAMAGE)
        meleeweapon.components.weapon:SetRange(TUNING.SPAT_MELEE_ATTACKRANGE/4)
        meleeweapon:AddComponent("inventoryitem")
        meleeweapon.persists = false
        meleeweapon.components.inventoryitem:SetOnDroppedFn(meleeweapon.Remove)
        meleeweapon:AddComponent("equippable")
        meleeweapon:AddTag("meleeweapon")

        inst.components.inventory:GiveItem(meleeweapon)
        inst.weaponitems.meleeweapon = meleeweapon
    end
end

local function SpitCooldown(inst, data)
	local target = inst.components.combat.target ~= nil and inst.components.combat.target or nil
	
	if data.name == "SpitCooldown" and target ~= nil and target.components.pinnable ~= nil then
		if not target ~= nil and inst.sg:HasStateTag("attack") and inst:GetDistanceSqToInst(target) <= 300 and inst:GetDistanceSqToInst(target) >= 25  then
			inst.components.timer:StopTimer("SpitCooldown")
			inst.sg:GoToState("give_off_cob_web")
			inst.spitweb = true
		else
			inst.components.timer:StopTimer("SpitCooldown")
			inst.components.timer:StartTimer("SpitCooldown", 3)
		end
    end
end


local function LaunchWeb(inst, target)
	if target ~= nil then
		local x, y, z = inst.Transform:GetWorldPosition()
		local projectile = SpawnPrefab("queen_web_bomb")
		local a, b, c = target.Transform:GetWorldPosition()
		local targetpos = target:GetPosition()
		local dx = a - x
		local dz = c - z
		local rangesq = dx * dx + dz * dz
		local maxrange = 15
		local bigNum = 10
		local speed = easing.linear(rangesq, bigNum, 3, maxrange * maxrange)
		
		--targetpos.x = targetpos.x + math.random(-1,1)
		--targetpos.z = targetpos.z + math.random(-1,1)
		
		local function shrink(inst, time, startsize, endsize)
			inst.AnimState:SetMultColour(1,1,1,.9)
			inst.Transform:SetScale(startsize, startsize, startsize)
			inst.components.colourtweener:StartTween({1,1,1,1}, time)
			inst.components.sizetweener:StartTween(.5, time, inst.Remove)
			--inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/bomb_fall")
		end

		local shadow = SpawnPrefab("warningshadow")
		shadow.Transform:SetPosition(a, b, c)

		shadow:AddComponent("sizetweener")
		shadow:AddComponent("colourtweener")

		shadow.shrink = shrink
	
		shadow:shrink(((speed + 5) / 14), 1.75, 0.5)
		
		projectile.Transform:SetPosition(x, y, z)
		projectile.Physics:ClearCollisionMask()
		projectile.components.complexprojectile:SetGravity(-30)
		projectile.Physics:CollidesWith(COLLISION.WORLD)
		projectile.Physics:CollidesWith(COLLISION.OBSTACLES)
		projectile.components.complexprojectile.usehigharc = true
		projectile.components.complexprojectile:SetHorizontalSpeed(speed + 5)
		projectile.components.complexprojectile:Launch(targetpos, inst, inst)
	end
end

env.AddPrefabPostInit("spiderqueen", function(inst)
	inst.entity:AddGroundCreepEntity()
	
	if not TheWorld.ismastersim then
		return
	end
	--inst.WebReady = true
	--inst:AddComponent("inventory")
    --inst.weaponitems = {}
	--EquipWeapons(inst)
	inst.GroundCreepEntity:SetRadius(2)
	inst:ListenForEvent("death", OnDead)
	
	inst:AddComponent("timer")
    inst:ListenForEvent("timerdone", SpitCooldown)
	
	inst.LaunchWeb = LaunchWeb
	
	--inst.OnLoad = function(inst)  inst.WebReady = true   end
end)