local env = env
GLOBAL.setfenv(1, GLOBAL)

local UpvalueHacker = require("tools/upvaluehacker")

local STATE_DATA = 
{
    ["wimpy"] = { 
        skin_data = { skin_mode = "wimpy_skin", default_build = "wolfgang_skinny" },
        
        announce = "ANNOUNCE_NORMALTOWIMPY",
        event = "powerdown",
        sound = "wolfgang2/characters/wolfgang/wimpy",

        externaldamagemultiplier = 0.75,
        talksoundoverride = "dontstarve/characters/wolfgang/talk_small_LP", 
        hurtsoundoverride = "dontstarve/characters/wolfgang/hurt_small",
        customidle = "idle_wolfgang_skinny",
        tag = "mightiness_wimpy",

        scale = 0.9,
        work_effectiveness = TUNING.WIMPY_WORK_EFFECTIVENESS,

		hunger_mult = TUNING.WIMPY_HUNGER_RATE_MULT,
    },
    
    ["normal"] = { 
        skin_data = { skin_mode = "normal_skin", default_build = "wolfgang" },
        
        announce = {wimpy = "ANNOUNCE_WIMPYTONORMAL", mighty = "ANNOUNCE_MIGHTYTONORMAL", shadow = "ANNOUNCE_MIGHTYTONORMAL", monster = "ANNOUNCE_MONSTERTONORMAL"},
        event =    {wimpy = "powerup", mighty = "powerdown", shadow = "powerdown", monster = "powerdown"},
        sound =    {wimpy = "wolfgang2/characters/wolfgang/mighty", mighty = "wolfgang2/characters/wolfgang/wimpy", shadow = "wolfgang2/characters/wolfgang/wimpy", monster = "wolfgang2/characters/wolfgang/wimpy"},

        externaldamagemultiplier = nil,
        talksoundoverride = nil,
        hurtsoundoverride = nil,
        customidle = "idle_wolfgang",
        tag = "mightiness_normal",

        scale = 1,
        winter_insulation = nil,
        summer_insulation = nil,
    },
    
    ["mighty"] = { 
        skin_data = { skin_mode = "mighty_skin", default_build = "wolfgang_mighty" },
        
        announce = "ANNOUNCE_NORMALTOMIGHTY",
        event = "powerup",
        sound = "wolfgang2/characters/wolfgang/mighty",

        externaldamagemultiplier = 2,
        talksoundoverride = "dontstarve/characters/wolfgang/talk_large_LP", 
        hurtsoundoverride = "dontstarve/characters/wolfgang/hurt_large",
        customidle = "idle_wolfgang_mighty",
        tag = "mightiness_mighty",

        row_force_mult = TUNING.MIGHTY_ROWER_MULT,
		row_extra_max_velocity = TUNING.MIGHTY_ROWER_EXTRA_MAX_VELOCITY,
        anchor_raise_speed = TUNING.MIGHTY_ANCHOR_SPEED,
        lower_sail_strength = TUNING.MIGHTY_SAIL_BOOST_STRENGTH,
		
		scale = 1.2,
        work_effectiveness = TUNING.MIGHTY_WORK_EFFECTIVENESS,
		
		hunger_mult = TUNING.MIGHTY_HUNGER_RATE_MULT
    },
	
	["shadow"] = { 
        skin_data = { skin_mode = "mighty_skin", default_build = "wolfgang_mighty" },
        
        announce = "ANNOUNCE_NORMALTOMIGHTY",
        event = "powerup",
        sound = "wolfgang2/characters/wolfgang/mighty",

        externaldamagemultiplier = 2,
        talksoundoverride = "dontstarve/characters/wolfgang/talk_large_LP", 
        hurtsoundoverride = "dontstarve/characters/wolfgang/hurt_large",
        customidle = "idle_wolfgang_mighty",
        tag = "mightiness_mighty",

        row_force_mult = TUNING.MIGHTY_ROWER_MULT,
		row_extra_max_velocity = TUNING.MIGHTY_ROWER_EXTRA_MAX_VELOCITY,
        anchor_raise_speed = TUNING.MIGHTY_ANCHOR_SPEED,
        lower_sail_strength = TUNING.MIGHTY_SAIL_BOOST_STRENGTH,
		
		scale = 1.2,
        work_effectiveness = TUNING.MIGHTY_WORK_EFFECTIVENESS,
		
		hunger_mult = TUNING.SHADOW_HUNGER_RATE_MULT,
		
		max_health = TUNING.SHADOW_WOLFGANG_MAX_HEALTH
    },
	
	["monster"] = { 
        skin_data = { skin_mode = "mighty_skin", default_build = "wolfgang_mighty" },
        
        announce = "ANNOUNCE_NORMALTOMONSTER",
        event = "powerup",
        sound = "wolfgang2/characters/wolfgang/mighty",

        externaldamagemultiplier = 2,
        talksoundoverride = "dontstarve/characters/wolfgang/talk_large_LP", 
        hurtsoundoverride = "dontstarve/characters/wolfgang/hurt_large",
        customidle = "idle_wolfgang_mighty",
        tag = "mightiness_mighty",

        row_force_mult = TUNING.MIGHTY_ROWER_MULT * TUNING.MIGHTY_ROWER_MULT,
		row_extra_max_velocity = TUNING.MIGHTY_ROWER_EXTRA_MAX_VELOCITY * 5,
        anchor_raise_speed = TUNING.MIGHTY_ANCHOR_SPEED * 2,
        lower_sail_strength = TUNING.MIGHTY_SAIL_BOOST_STRENGTH * 2,
		
		scale = 1.2,
        work_effectiveness = TUNING.MIGHTY_WORK_EFFECTIVENESS,
		
		hunger_mult = TUNING.MIGHTY_HUNGER_RATE_MULT,
    },
}

env.AddComponentPostInit("mightiness", function(self)
    if not TheWorld.ismastersim then return end
	
	self.rate = TUNING.MIGHTINESS_CHANGE_RATE
	self.gain_multiplier = TUNING.MIGHTINESS_CHANGE_MULT_NORMAL
	
	function self:OnHungerDelta(data)
		local hungerpercent = data ~= nil and data.newpercent * 100 or nil
		local hungerdelta = TUNING.MIGHTINESS_CHANGE_MULT_NORMAL
		
		local sanitypercent = self.inst.components.sanity:GetPercent() * 100
		local sanitydelta = TUNING.MIGHTINESS_CHANGE_MULT_NORMAL
		local lunacy = self.inst.components.sanity:IsLunacyMode()
		
		local coachingdelta = (self.inst:HasTag("coaching") and TUNING.MIGHTINESS_CHANGE_STANDARD_DELTA) or TUNING.MIGHTINESS_CHANGE_MULT_NONE
		
		if hungerpercent then
			if hungerpercent >= TUNING.MIGHTY_THRESHOLD then
				hungerdelta = -TUNING.MIGHTINESS_CHANGE_STANDARD_DELTA
			elseif hungerpercent >= TUNING.WIMPY_THRESHOLD then
				hungerdelta = TUNING.MIGHTINESS_CHANGE_MULT_NONE
			else
				hungerdelta = TUNING.MIGHTINESS_CHANGE_STANDARD_DELTA
			end

			if self.inst:HasTag("shadow_mighty") then
				if self.state ~= "shadow" then
					self:BecomeState("shadow")
				end
			elseif self.inst:HasTag("lunar_mighty") and hungerpercent >= TUNING.MIGHTY_THRESHOLD then
				if self.state ~= "monster" then
					self:BecomeState("monster")
				end
			elseif hungerpercent >= TUNING.MIGHTY_THRESHOLD then
				if self.state ~= "mighty" then
					self:BecomeState("mighty")
				end
			elseif hungerpercent >= TUNING.WIMPY_THRESHOLD then
				if self.state ~= "normal" then
					self:BecomeState("normal")
				end
			else
				if self.state ~= "wimpy" then
					self:BecomeState("wimpy")
				end
			end
		end
		
		if sanitypercent then
			if sanitypercent >= TUNING.MIGHTY_THRESHOLD then
				sanitydelta = -TUNING.MIGHTINESS_CHANGE_STANDARD_DELTA
			elseif sanitypercent >= TUNING.WIMPY_THRESHOLD then
				sanitydelta = TUNING.MIGHTINESS_CHANGE_MULT_NONE
			else
				sanitydelta =TUNING.MIGHTINESS_CHANGE_STANDARD_DELTA
			end
		end
		
		if lunacy then
			sanitydelta = -sanitydelta
		end
		
		self.gain_multiplier = (hungerdelta + sanitydelta + coachingdelta)
	end
	
	function self:DoDec(dt, ignore_damage)
		if self.draining and not self.invincible then
			   self:DoDelta(-self.rate * dt * self.gain_multiplier * self.ratemodifiers:Get())
		end
	end
	
	function self:BecomeState(state, silent, delay_skin, forcesound)
		if not self:CanTransform(state) then
			return
		end

		silent = silent or self.inst.sg:HasStateTag("silentmorph") or not self.inst.entity:IsVisible()

		local state_data = STATE_DATA[state]
		self:UpdateSkinMode(state_data.skin_data, delay_skin)

		local gym = self.inst.components.strongman.gym
		if gym then
			gym.components.mightygym:SetSkinModeOnGym(self.inst, state_data.skin_data.skin_mode)
		end

		if not silent then
			if state == "normal" then
				self.inst.sg:PushEvent(state_data.event[self.state])
				self.inst.components.talker:Say(GetString(self.inst, state_data.announce[self.state]))
			else
				self.inst.sg:PushEvent(state_data.event)
				self.inst.components.talker:Say(GetString(self.inst, state_data.announce))
			end
		end

		if state == "wimpy" and self.inst.components.coach then
			self.inst.components.coach:Disable()
		end
		
		if not silent or forcesound then
			if state == "normal" then
				self.inst.SoundEmitter:PlaySound(state_data.sound[self.state])
			else
				self.inst.SoundEmitter:PlaySound(state_data.sound)
			end
		end

		if state_data.externaldamagemultiplier ~= nil then
			self.inst.components.combat.externaldamagemultipliers:SetModifier(self.inst, state_data.externaldamagemultiplier)
			if self.inst:HasTag("shadow_strikes") then
				self.inst.components.combat.externaldamagemultipliers:SetModifier(self.inst, state_data.externaldamagemultiplier * TUNING.WOLFGANG_SHADOW_STRIKE_BASE_MULT)
			end
		else
			self.inst.components.combat.externaldamagemultipliers:RemoveModifier(self.inst)
		end
		
		self.inst.components.temperature.inherentinsulation = state_data.winter_insulation or 0
		self.inst.components.temperature.inherentsummerinsulation = state_data.summer_insulation or 0

		self.inst.components.hunger.burnrate = state_data.hunger_mult or 1
		
		local state_max_health = state_data.max_health or TUNING.WOLFGANG_HEALTH
		
		if state_max_health ~= self.inst.components.health.max_health then
			local health_percent = self.inst.components.health:GetPercent()
			
			if state == "shadow" then
				health_percent = (health_percent * TUNING.WOLFGANG_HEALTH)/state_max_health
			end
			self.inst.components.health:SetMaxHealth(state_max_health)
			self.inst.components.health:SetPercent(health_percent)
		end
		
		self.inst.components.expertsailor:SetRowForceMultiplier(state_data.row_force_mult)
		self.inst.components.expertsailor:SetRowExtraMaxVelocity(state_data.row_extra_max_velocity)
		self.inst.components.expertsailor:SetAnchorRaisingSpeed(state_data.anchor_raise_speed)
		self.inst.components.expertsailor:SetLowerSailStrength(state_data.lower_sail_strength)

		if  state_data.work_effectiveness then    
			self.inst.components.workmultiplier:AddMultiplier(ACTIONS.CHOP,    state_data.work_effectiveness, self.inst)
			self.inst.components.workmultiplier:AddMultiplier(ACTIONS.MINE,    state_data.work_effectiveness, self.inst)
			self.inst.components.workmultiplier:AddMultiplier(ACTIONS.HAMMER,  state_data.work_effectiveness, self.inst)
			
			self.inst.components.efficientuser:AddMultiplier(ACTIONS.CHOP,     state_data.work_effectiveness, self.inst)
			self.inst.components.efficientuser:AddMultiplier(ACTIONS.MINE,     state_data.work_effectiveness, self.inst)
			self.inst.components.efficientuser:AddMultiplier(ACTIONS.HAMMER,   state_data.work_effectiveness, self.inst)
		else
			self.inst.components.workmultiplier:RemoveMultiplier(ACTIONS.CHOP,   self.inst)
			self.inst.components.workmultiplier:RemoveMultiplier(ACTIONS.MINE,   self.inst)
			self.inst.components.workmultiplier:RemoveMultiplier(ACTIONS.HAMMER, self.inst)

			self.inst.components.efficientuser:RemoveMultiplier(ACTIONS.CHOP,    self.inst)
			self.inst.components.efficientuser:RemoveMultiplier(ACTIONS.MINE,    self.inst)
			self.inst.components.efficientuser:RemoveMultiplier(ACTIONS.HAMMER,  self.inst)
		end

		if not self.inst:HasTag("ingym") and not self.inst.components.rider:IsRiding() then
			self.inst:ApplyAnimScale("mightiness", state_data.scale)
		end
		
		self.inst:RemoveTag(STATE_DATA[self.state].tag)
		self.inst:AddTag(state_data.tag)    

		self.inst.talksoundoverride = state_data.talksoundoverride
		self.inst.hurtsoundoverride = state_data.hurtsoundoverride
		self.inst.customidleanim = state_data.customidle
		
		local previous_state = self.state
		self.state = state

		self.inst:PushEvent("mightiness_statechange", {previous_state = previous_state, state = state})
	end
	
	function self:GetSkinMode()
		return STATE_DATA[self.state].skin_data.skin_mode
	end
	
	function self:GetScale()
    return STATE_DATA[self.state].scale
	end
	
	function self:GetState()
		if self.state == "monster" or self.state == "shadow" then 
			return "mighty"
		else
			return self.state
		end
	end

	function self:IsMighty()
		return self.state == "mighty" or self.state == "monster" or self.state == "shadow" or self.state == "over"
	end
	
	function self:DoDelta(delta, force_update, delay_skin, forcesound, fromgym)
		local old = self.current
		local gymexpert = self.inst:HasTag("wolfgang_overbuff_expert")

		if delta > 0 then
			if gymexpert and fromgym then
				delta = delta * 2
			end
			self.current = math.min(self.current + delta, self.max + self:GetOverMax())
		else
			self.current = math.max(0,self.current + delta)
		end    

		self.inst:PushEvent("mightinessdelta", { oldpercent = old / self.max, newpercent = self.current / self.max, delta = self.current-old })
	end
	
	self.inst:ListenForEvent("hungerdelta", function(_, data) self:OnHungerDelta(data) end)
end)
