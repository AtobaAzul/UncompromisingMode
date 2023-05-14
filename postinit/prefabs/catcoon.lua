local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
SetSharedLootTable('catty',
	{
		{ 'meat',     1.00 },
		{ 'coontail', 1.00 },
	})

local function OnAttackOther(inst, data)
	if data.target:HasTag("raidrat") and not data.target.components.health:IsDead() then
		data.target.components.health:Kill()
	end
end

local function OnAttacked(inst, data)
	local attacker = data ~= nil and data.attacker or nil
	if attacker ~= nil and attacker.userid ~= nil and not table.contains(inst.hitlist, attacker.userid) then
		table.insert(inst.hitlist, attacker.userid)
	end
	if inst.countercounter == 0 then --Counterattack
		inst.sg:GoToState("pounce_pre")
	else
		if inst.sg.currentstate.name == "hiss" then
			inst.sg:GoToState("hit")
		end
	end
end

local function RetargetFn(inst)
	return FindEntity(inst, TUNING.CATCOON_TARGET_DIST,
		function(guy)
			for i, v in ipairs(inst.hitlist) do
				if guy.userid ~= nil and v == guy.userid then
					return inst.components.combat:CanTarget(guy)
				end
			end
			if guy:HasTag("catcoon") then
				return not (inst.components.follower and inst.components.follower:IsLeaderSame(guy))
					and
					not (inst.components.follower and guy.components.follower and inst.components.follower.leader == nil and guy.components.follower.leader == nil)
					and guy.components.health
					and not guy.components.health:IsDead()
					and inst.components.combat:CanTarget(guy)
			else
				return ((guy:HasTag("monster") or guy:HasTag("smallcreature"))
					and guy.components.health
					and not guy.components.health:IsDead()
					and inst.components.combat:CanTarget(guy)
					and not (inst.components.follower and inst.components.follower.leader ~= nil and guy:HasTag("abigail")))
					and not (inst.components.follower and inst.components.follower:IsLeaderSame(guy))
					or (guy:HasTag("cattoyairborne")
					and not (inst.components.follower and inst.components.follower:IsLeaderSame(guy)))
			end
		end)
end

local function OnSave(inst, data)
	if inst.hitlist ~= nil then
		data.hitlist = inst.hitlist
	end
end

local function OnLoad(inst, data)
	if data ~= nil and data.hitlist ~= nil then
		inst.hitlist = data.hitlist
	else
		inst.hitlist = {}
	end
end

env.AddPrefabPostInit("catcoon", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	inst.hitlist = {}
	inst.countercounter = 0
	if inst.components.health ~= nil then
		inst.components.health:SetMaxHealth(TUNING.DSTU.MONSTER_CATCOON_HEALTH_CHANGE)
	end

	if inst.components.lootdropper ~= nil then
		inst.components.lootdropper:SetChanceLootTable('catty')
	end
	inst.components.combat:SetRetargetFunction(3, RetargetFn)


	inst:ListenForEvent("onattackother", OnAttackOther)
	inst:ListenForEvent("attacked", OnAttacked)
	inst.components.combat:SetRange(TUNING.CATCOON_ATTACK_RANGE / 1.5) --Lower the range
	inst.components.combat:SetAttackPeriod(TUNING.CATCOON_ATTACK_PERIOD / 1.5) --Make it attack faster to compensate

	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
end)

local function SpawnChild(inst, child)
	if inst.hitlist ~= nil then
		child.hitlist = inst.hitlist
	end
end

env.AddPrefabPostInit("catcoonden", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	inst.hitlist = {}
	if TheWorld.totalcatcoondens ~= nil then
		TheWorld.totalcatcoondens = TheWorld.totalcatcoondens + 1
	else
		TheWorld.totalcatcoondens = 1
	end
	---------------------------------------------------------------------

	---------------------------------------------------------------------
	local _onchildkilledfn = inst.components.childspawner.onchildkilledfn
	local _onsave = inst.OnSave
	local _onload = inst.OnLoad

	local function OnChildKilled(inst, child)
		if inst.lives_left <= 0 and inst.hitlist ~= nil then
			inst.hitlist = nil
		else
			if child.hitlist ~= nil then
				inst.hitlist = child.hitlist
			end
		end
		
		_onchildkilledfn(inst, child)
	end

	local function OnLoad(inst, data)
		if data ~= nil and data.hitlist ~= nil then
			inst.hitlist = data.hitlist
		end
		
		return _onload(inst, data)
	end

	local function OnSave(inst, data)
		if inst.hitlist ~= nil then
			data.hitlist = inst.hitlist
		end
		
		return _onsave(inst, data)
	end

	inst.components.childspawner:SetRegenPeriod(2.5 * TUNING.CATCOONDEN_REGEN_TIME) --Catcoons are now reasonably common, they don't need a super fast regen time

	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
	inst.components.childspawner.onchildkilledfn = OnChildKilled
	inst.components.childspawner.onspawned = SpawnChild
end)
