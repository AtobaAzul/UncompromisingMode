local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

--Behold the mind of the sleep-deprived college student! (Don't push me till we know that klei doesn't change AG and mess this up, though I did make sure to do everything as compat friendly as possible, more than any other piece of work I've done before, for sure.)

local UpvalueHacker = require("tools/upvaluehacker")
local function CheckForceJump(inst,data) -- Secondary means to force the leap if for some reason the player isn't in a position for it to happen naturally
	if data.name == "forceleapattack" and inst.components.combat and inst.components.combat.target and inst.components.health and not inst.components.health:IsDead() then
		inst.forceleap = true
	elseif data.name == "forceleapattack" then
		inst.components.timer:StartTimer("forceleapattack", math.random(30,45))
	end
	--This is actually the only way the belch happens
	if data.name == "forcebelch" and inst.components.combat and inst.components.combat.target and inst.components.health and not inst.components.health:IsDead() and inst.components.health:GetPercent() < 0.6 then
		inst.forcebelch = true
	elseif data.name == "forcebelch" then
		inst.components.timer:StartTimer("forcebelch", math.random(20,30))
	end
end

local easing = require("easing")

local function LaunchProjectile(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local angle = (inst.Transform:GetRotation() + 90) * DEGREES
    local x1 = x + .01 * math.sin(angle)
    local z1 = z + .01 * math.cos(angle)	
	local goo = SpawnPrefab("guardian_goo")
    goo.Transform:SetPosition(x1, y+3, z1)
	goo.Transform:SetRotation(angle / DEGREES)
	goo._caster = inst
	
	Launch2(goo, inst, inst.projectilespeed, 2, 2, 4)
end

env.AddPrefabPostInit("minotaur", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	inst.forceleap = false
	inst.forcebelch = false
	inst.combo = 0
	inst.components.timer:StartTimer("forceleapattack", math.random(30,45))
	inst.components.timer:StartTimer("forcebelch", math.random(30,45))
	inst:ListenForEvent("timerdone", CheckForceJump)
	
	local _OnAttacked = UpvalueHacker.GetUpvalue(Prefabs.minotaur.fn, "OnAttacked")
	local function OnAttacked(inst, data)
		if not inst.sg:HasStateTag("newbuild") then
			_OnAttacked(inst,data)
		end
	end
	inst:RemoveEventCallback("attacked",_OnAttacked)
	UpvalueHacker.SetUpvalue(Prefabs.minotaur.fn, OnAttacked,"OnAttacked")
	
	inst:ListenForEvent("attacked",OnAttacked)
	
	inst.LaunchProjectile = LaunchProjectile
end)
