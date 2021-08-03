local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
local easing = require("easing")

SetSharedLootTable( 'walrus_summer',
{
    {'meat',            1.00},
    {'blowdart_pipe',   1.00},
    {'sunglasses',       0.25},
    {'walrus_tusk',     0.50},
    {'hawaiianshirt',     0.05},
})


local function SpitCooldown(inst, data)
	local target = inst.components.combat.target ~= nil and inst.components.combat.target or nil

	if data.name == "SpitCooldown" then
		if inst.sg:HasStateTag("busy") then
			inst.components.timer:StopTimer("SpitCooldown")
			inst.components.timer:StartTimer("SpitCooldown", 3)
		else
			if target ~= nil and inst:GetDistanceSqToInst(target) <= 300 and inst:GetDistanceSqToInst(target) >= 50 then
				inst.sg:GoToState("throw_trap_pre")
				inst.spitweb = true
				inst.components.timer:StopTimer("SpitCooldown")
				inst.components.timer:StartTimer("SpitCooldown", 15)
			else
				local trap = FindEntity(inst, 3, nil, "bear_trap")

				if not trap then
					inst.sg:GoToState("drop_trap")
				end
				inst.spitweb = true
				inst.components.timer:StopTimer("SpitCooldown")
				inst.components.timer:StartTimer("SpitCooldown", 15)
			end
		end
    end
end

local function LaunchTrap(inst, target)
	if target ~= nil then
		local x, y, z = inst.Transform:GetWorldPosition()
		local projectile = SpawnPrefab("um_bear_trap_projectile")
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

		--[[local shadow = SpawnPrefab("warningshadow")
		shadow.Transform:SetPosition(a, b, c)

		shadow:AddComponent("sizetweener")
		shadow:AddComponent("colourtweener")

		shadow.shrink = shrink
	
		shadow:shrink(((speed + 4) / 15), 1.75, 0.5)]]
		
		projectile.Transform:SetPosition(x, y, z)
		projectile.Physics:ClearCollisionMask()
		projectile.components.complexprojectile:SetGravity(-50)
		projectile.Physics:CollidesWith(COLLISION.WORLD)
		projectile.Physics:CollidesWith(COLLISION.OBSTACLES)
		projectile.components.complexprojectile.usehigharc = true --true?
		projectile.components.complexprojectile:SetHorizontalSpeed(speed + 5)
		projectile.components.complexprojectile:Launch(targetpos, inst, inst)
	end
end

local function OnIsSummer(inst, issummer)
    if issummer then
		inst.AnimState:SetBank("walrus")
        inst.AnimState:SetBuild("walrus_build_summer")
		inst.components.lootdropper:SetChanceLootTable('walrus_summer')
    else
		inst.AnimState:SetBank("walrus")
        inst.AnimState:SetBuild("walrus_build")
		inst.components.lootdropper:SetChanceLootTable('walrus')
    end
end

env.AddPrefabPostInit("walrus", function (inst)
	if not TheWorld.ismastersim then
		return
	end
	inst:AddComponent("timer")
	if not inst.components.timer:TimerExists("SpitCooldown") then
		inst.components.timer:StartTimer("SpitCooldown", 15)
	end
    inst:ListenForEvent("timerdone", SpitCooldown)
	
	inst.LaunchTrap = LaunchTrap
	
	inst:WatchWorldState("issummer", OnIsSummer)
    if TheWorld.state.issummer then
        OnIsSummer(inst, true)
    end
	

end)

local function OnIsSummerBaby(inst, issummer)
    if issummer then
		inst.AnimState:SetBank("walrus")
        inst.AnimState:SetBuild("walrus_baby_build_summer")
    else
		inst.AnimState:SetBank("walrus")
        inst.AnimState:SetBuild("walrus_baby_build")
    end
end


env.AddPrefabPostInit("little_walrus", function (inst)
	if not TheWorld.ismastersim then
		return
	end
	
	inst:WatchWorldState("issummer", OnIsSummerBaby)
    if TheWorld.state.issummer then
        OnIsSummerBaby(inst, true)
    end
end)