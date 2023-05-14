local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

local function OnNewTarget_Remember(inst, data)
	if data ~= nil and data.target ~= nil and data.target:HasTag("player") then
		if table.contains(inst.remembered_threats, data.target) then
			local strtbl = STRINGS["PIG_REMEMBER_THREAT"]
			if strtbl ~= nil then
				local strid = math.random(#strtbl)
				inst.components.talker:Chatter("PIG_REMEMBER_THREAT", strid)
			end
		else
			table.insert(inst.remembered_threats, data.target)
		end
	end
end

local function OnSave(inst, data)
	data.remembered_threats = inst.remembered_threats
		
	if inst._OldOnSave ~= nil then
		return inst._OldOnSave(inst, data)
	end
end
	
local function OnLoad(inst, data)
    if data then
		inst.remembered_threats = data.remembered_threats or inst.remembered_threats
	end
		
	if inst._OldOnLoad ~= nil then
		return inst._OldOnLoad(inst, data)
	end
end

local MAX_TARGET_SHARES = 5
local SHARE_TARGET_DIST = 30

local function OnAttacked(inst, data)
    local attacker = data.attacker
    inst:ClearBufferedAction()

	if attacker ~= nil then
		if attacker:HasTag("player") then
			inst.components.combat:ShareTarget(attacker, SHARE_TARGET_DIST, function(dude) return dude.prefab == inst.prefab end, MAX_TARGET_SHARES)
		end
	end
end

env.AddPrefabPostInit("pigman", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	inst:AddTag("pigattacker")
	
	inst.remembered_threats = {}
	
	if inst.components.combat ~= nil then
		local _OldRetarget = inst.components.combat.targetfn
		local period = inst.components.combat.retargetperiod
		
		inst.components.combat:SetRetargetFunction(period, function(inst)
			if inst:HasTag("NPC_contestant") then
				return nil
			end

			local RETARGET_MUST_TAGS = { "_combat" }
			local exclude_tags = { "playerghost", "INLIMBO" , "NPC_contestant" }
			if inst.components.follower.leader ~= nil then
				table.insert(exclude_tags, "abigail")
			end
			if inst.components.minigame_spectator ~= nil then
				table.insert(exclude_tags, "player") -- prevent spectators from auto-targeting webber
			end

			local oneof_tags = {"monster","wonkey","pirate", "player"}
			if not inst:HasTag("merm") then
				table.insert(oneof_tags, "merm")
			end

			return not inst:IsInLimbo()
				and FindEntity(
						inst,
						TUNING.PIG_TARGET_DIST,
						function(guy)
							return table.contains(inst.remembered_threats, guy) and guy:IsInLight() and inst.components.combat:CanTarget(guy)
						end,
						RETARGET_MUST_TAGS, -- see entityreplica.lua
						exclude_tags,
						oneof_tags
					)
				or _OldRetarget(inst)
		end)
	end
	
    inst:ListenForEvent("newcombattarget", OnNewTarget_Remember)
	

	local _OldOnSave = inst.OnSave
	local _OldOnLoad = inst.OnLoad
	
	if inst.OnSave ~= nil then
		inst._OldOnSave = inst.OnSave
	end
	
	if inst.OnLoad ~= nil then
		inst._OldOnLoad = inst.OnLoad
	end
	
    inst:ListenForEvent("attacked", OnAttacked)
	
    inst.OnSave = OnSave
	
    inst.OnLoad = OnLoad

end)

env.AddPrefabPostInit("pigguard", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	inst:AddTag("pigattacker")

end)

env.AddPrefabPostInit("pigking_pigguard", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	inst:AddTag("pigattacker")

end)
