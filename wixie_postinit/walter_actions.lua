local function AddEnemyDebuffFx(fx, target)
    target:DoTaskInTime(math.random()*0.25, function()
        local x, y, z = target.Transform:GetWorldPosition()
        local fx = GLOBAL.SpawnPrefab(fx)
        if fx then
            fx.Transform:SetPosition(x, y, z)
        end

        return fx
    end)
end

local wobycommand = AddAction(
	"WOBY_COMMAND",
	"WOBY_COMMAND_FETCH",
	function(act)
	
	local hasfollowers = false
	
	if act.doer ~= nil and act.doer.components.leader ~= nil and act.target ~= nil then
		for k,v in pairs(act.doer.components.leader.followers) do
            if not k:HasTag("customwobytag") and k.components.follower ~= nil then 
				if k.components.combat ~= nil and act.target.components.combat and k.components.follower.canaccepttarget then
					k.components.combat:SuggestTarget(act.target)
				end
				
				hasfollowers = true
            end
        end
	end
	
    if act.doer ~= nil and act.doer.woby ~= nil and act.doer.woby.sg.currentstate.name ~= "transform" then
		if act.doer.components.rider ~= nil and 
		act.doer.components.rider:IsRiding() and 
		act.doer.components.rider:GetMount() and 
		act.doer.components.rider:GetMount():HasTag("woby")
		and not (hasfollowers and act.target ~= nil and act.target:HasTag("CHOP_workable")) then
			if act.target ~= nil and act.target.components.combat ~= nil then
				act.doer.sg:GoToState("bark_at")
				
				if act.target ~= nil then
					if act.target.components.combat ~= nil then
						--[[if act.doer.woby.scarytask == nil then
							act.doer.woby.scarytask = act.doer.woby:DoTaskInTime(10, function(inst)
									inst.scarytask = nil
								end)
								
							act.doer:DoTaskInTime(7*GLOBAL.FRAMES, function(inst)
								inst.SoundEmitter:PlaySound("dontstarve/creatures/together/stalker/taunt")
							end)
							
							local x, y, z = act.target.Transform:GetWorldPosition()
							local ents = GLOBAL.TheSim:FindEntities(x, y, z, 10, { "_combat" }, { "companion" })
							for i, v in ipairs(ents) do
								if v.components.hauntable ~= nil and v.components.hauntable.panicable and not
								(v.components.follower ~= nil and v.components.follower:GetLeader() and v.components.follower:GetLeader():HasTag("player")) then
									v.components.hauntable:Panic(TUNING.BATTLESONG_PANIC_TIME)
									AddEnemyDebuffFx("battlesong_instant_panic_fx", v)
								end
							end
						
							act.target:AddDebuff("bigwoby_debuff", "bigwoby_debuff")
							
							
							act.doer.woby.components.hunger:DoDelta(-5) 
						end]]
						if (act.target.components.combat ~= nil and 
						act.target.components.combat:CanTarget(act.doer) and not
						(act.target.components.combat:TargetIs(act.doer) or act.target.components.grouptargeter ~= nil and act.target.components.grouptargeter:IsTargeting(act.doer)) and not
						(act.target.sg ~= nil and act.target.sg:HasStateTag("attack"))) then
							act.target.components.combat:SetTarget(act.doer)
						end
						
						return true
					end
				end
			else
				return false, "WOBYNEEDTODISMOUNT"
			end
		else
			local act_pos = act:GetActionPoint()
			
			--if act.target ~= nil and act.doer.woby.wobytarget ~= nil then
				if act.doer.woby.wobytarget == act.target then
					act.doer.woby.wobytarget = nil
					act.doer.woby.oldwobytarget = nil
					act.doer.woby.sg:GoToState("bark_clearaction")
					
					if act.target.components.combat ~= nil then
						act.doer.components.talker:Say(GLOBAL.GetString(act.doer, "ANNOUNCE_WOBY_COMBAT_STOP"))
					else
						act.doer.components.talker:Say(GLOBAL.GetString(act.doer, "ANNOUNCE_WOBY_STOP"))
					end
					
					return true
				end
			--end
			
		
			if act.doer.woby.components.hunger:GetPercent() == 0 then
				act.doer.woby.sg:GoToState("hungry")
				return false, "WOBYHUNGRY"
			end
		
			if act.target then
				if act.target.components ~= nil then
				
					if (act.target:HasTag("DIG_workable") and not (act.target.components.pickable ~= nil and act.target.components.pickable.canbepicked) or act.target:HasTag("snowpile_basic")) and not act.doer.woby:HasTag("woby") then
						
						act.doer.woby.wobytarget = nil
						act.doer.woby.oldwobytarget = nil
						
						if act.doer.woby.brain ~= nil then
							act.doer.woby.brain:Stop()
							act.doer.woby.brain:Start()
						end
						
						act.doer.woby.sg:GoToState("bark_clearaction")
						
						return false, "WOBYTOOSMALL"
					end
				
					if act.target.components.combat ~= nil then
						if hasfollowers then
							act.doer.components.talker:Say(GLOBAL.GetString(act.doer, "ANNOUNCE_TROUP_ATTACK"))
						else
							act.doer.components.talker:Say(GLOBAL.GetString(act.doer, "ANNOUNCE_WOBY_BARK"))
						end
					else
						if hasfollowers and act.target:HasTag("CHOP_workable") then
							act.doer.components.talker:Say(GLOBAL.GetString(act.doer, "ANNOUNCE_TROUP_ATTENTION"))
						
							return true
						else
							if (act.target.components.pickable == nil and
							act.target.components.inventoryitem == nil and not 
							(act.doer.woby:HasTag("woby") and act.target:HasTag("DIG_workable"))) then
								if hasfollowers then
									return false, "TROUPNEVERMIND"
								else
									return false, "WOBYNEVERMIND"
								end
							end
							
							
							act.doer.components.talker:Say(GLOBAL.GetString(act.doer, "ANNOUNCE_WOBY_FETCH"))
						end
					end
					
					act.doer.woby.sg:GoToState("bark_clearaction")
					
					act.doer.woby.wobytarget = nil
					act.doer.woby.oldwobytarget = nil
					
					if act.doer.woby.brain ~= nil then
						act.doer.woby.brain:Stop()
						act.doer.woby.brain:Start()
					end
			
					act.doer.woby.wobytarget = act.target
					
					return true
				end
			else
				if hasfollowers then
					return false, "TROUPNEVERMIND"
				else
					return false, "WOBYNEVERMIND"
				end
			end
		end
    end
end
)

wobycommand.priority = HIGH_ACTION_PRIORITY
wobycommand.rmb = true
wobycommand.distance = 36
wobycommand.mount_valid = true

local wobystay = AddAction(
	"WOBY_STAY",
	"WOBY_STAY",
	function(act)
	local act_pos = act:GetActionPoint()
	local hasfollowers = false
	
	if act.doer ~= nil and act.doer.components.leader ~= nil then
		for k,v in pairs(act.doer.components.leader.followers) do
            if not k:HasTag("customwobytag") and k.components.follower ~= nil then
				if k.brain ~= nil then
					k.brain:Stop()
					k.brain:Start()
					
					if k.components.locomotor ~= nil then 
						k.components.locomotor:GoToPoint(act_pos, nil, true)
					end
					
					hasfollowers = true
				end
            end
        end
	end
	
    if act.doer and act.doer.woby ~= nil and act_pos ~= nil and act.doer.woby.sg.currentstate.name ~= "transform" then
		act.doer.woby.wobytarget = nil
		act.doer.woby.oldwobytarget = nil
		
		if act.doer.woby.brain ~= nil then
			act.doer.woby.brain:Stop()
			act.doer.woby.brain:Start()
		end
		
		local sitpoint = GLOBAL.SpawnPrefab("woby_target")
		sitpoint.Transform:SetPosition(act_pos.x, 0, act_pos.z)
		sitpoint.owner = act.doer
		act.doer.woby.wobytarget = sitpoint
		
		if hasfollowers then
			act.doer.components.talker:Say(GLOBAL.GetString(act.doer, "ANNOUNCE_TROUP_STAY"))
		else
			act.doer.components.talker:Say(GLOBAL.GetString(act.doer, "ANNOUNCE_WOBY_STAY"))
		end
		
		return true
    end
end
)

wobystay.priority = HIGH_ACTION_PRIORITY
wobystay.rmb = true
wobystay.distance = 36
wobystay.mount_valid = false

local wobyhere = AddAction(
	"WOBY_HERE",
	"WOBY_HERE",
	function(act)
	
	local hasfollowers = false
	
	if act.doer ~= nil and act.doer.components.leader ~= nil then
		for k,v in pairs(act.doer.components.leader.followers) do
            if not k:HasTag("customwobytag") and k.components.follower ~= nil then
				if k.brain ~= nil then
					k.brain:Stop()
					k.brain:Start()
					
					if k.components.locomotor ~= nil then 
						k.components.locomotor:GoToEntity(act.doer, nil, true)
					end
					
					hasfollowers = true
				end
            end
        end
	end
	
    if act.doer and act.doer.woby ~= nil and act.doer.woby.sg.currentstate.name ~= "transform" then
		act.doer.woby.wobytarget = nil
		act.doer.woby.oldwobytarget = nil
		
		if act.doer.woby.brain ~= nil then
			act.doer.woby.brain:Stop()
			act.doer.woby.brain:Start()
		end
		
		if act.doer.woby.sg.currentstate.name ~= "transform" then
			if act.doer.woby:IsNear(act.doer, 3) then
				act.doer.woby.sg:GoToState("woby_does_a_flip")
			else
				act.doer.woby.sg:GoToState("bark_clearaction")
			end
		end
		
		if hasfollowers then
			act.doer.components.talker:Say(GLOBAL.GetString(act.doer, "ANNOUNCE_TROUP_STAY"))
		else
			act.doer.components.talker:Say(GLOBAL.GetString(act.doer, "ANNOUNCE_WOBY_HERE"))
		end
		
		return true
    end
end
)

wobyhere.priority = HIGH_ACTION_PRIORITY
wobyhere.rmb = true
wobyhere.distance = 36
wobyhere.mount_valid = false

local wobyopen = AddAction(
	"WOBY_OPEN",
	"WOBY_OPEN",
	function(act)
	
	if act.doer.woby ~= nil then
        if act.doer.woby.components.container:IsOpen() then
            --act.doer.woby.components.container:Close(act.doer)
		else
			act.doer.woby.components.container:Open(act.doer)
        end
	end
end
)

wobyopen.priority = HIGH_ACTION_PRIORITY
wobyopen.rmb = true
wobyopen.distance = 36
wobyopen.mount_valid = true

local wobybark = AddAction(
	"WOBY_BARK",
	"WOBY_BARK",
	function(act)
    if act.target ~= nil then
		if act.target.components.combat ~= nil then
			--[[if act.doer:HasTag("woby") and act.doer.scarytask == nil then
				act.doer.scarytask = act.doer:DoTaskInTime(10, function(inst)
						inst.scarytask = nil
					end)
				
				local x, y, z = act.target.Transform:GetWorldPosition()
				local ents = GLOBAL.TheSim:FindEntities(x, y, z, 10, { "_combat" }, { "companion" })
				for i, v in ipairs(ents) do
					if v.components.hauntable ~= nil and v.components.hauntable.panicable and not
					(v.components.follower ~= nil and v.components.follower:GetLeader() and v.components.follower:GetLeader():HasTag("player")) then
						v.components.hauntable:Panic(TUNING.BATTLESONG_PANIC_TIME)
						AddEnemyDebuffFx("battlesong_instant_panic_fx", v)
					end
				end
			
				act.target:AddDebuff("bigwoby_debuff", "bigwoby_debuff")
				
				
				act.doer.components.hunger:DoDelta(-5) 
			end]]
			
			act.target.components.combat:SetTarget(act.doer)
			--act.target.components.combat:SuggestTarget(act.doer)
			return true
		end
    end
end
)

wobybark.distance = 10
wobybark.mount_valid = false


GLOBAL.ACTIONS.CAST_NET.mount_valid = false
GLOBAL.ACTIONS.DRY.mount_valid = true
GLOBAL.ACTIONS.CASTSPELL.distance = 40