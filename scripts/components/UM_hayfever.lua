--------------------------------------------------
--UM_hayfever is a player component that searches for nearby sources of pollen then determines their effect on the player.
local UM_hayfever = Class(function(self, inst)
    self.inst = inst
    self.enabled = false --Keeps track on whether the component is e
    self.pollencount = 0 --Number that changes onupdate, based on nearby pollen plants
	self.nosestuffyness = 0 --Number that determines some passive downsides to hayfever, builds up and must be reduced or it will result in player death
	
	self.proximity_sanityrate = 0 --Proximity sanity rate is based on pollencount
	self.passive_sanityrate = 0 --Passive sanity rate is based on nosestuffyness
end,
nil,
{
})

--Simple DoDelta function for nosestuffyness, also keeps the nosestuffyness between the bounds of 0 and 300
function UM_hayfever:DoDelta(amount)
    if ((self.nosestuffyness + amount) <= 300 and amount > 0) or ((self.nosestuffyness + amount) >= 0 and amount < 0) then         
       self.nosestuffyness = self.nosestuffyness + amount
    else
		if amount > 0 then
			self.nosestuffyness = 300
		else
			self.nosestuffyness = 0
		end
    end
	if amount > 0 then
		TheNet:SystemMessage("Your nose fills with pollen! It is now: "..self.nosestuffyness)
	else
		TheNet:SystemMessage("Your nose drains! It is now: "..self.nosestuffyness)
	end
end

--Returns whether or not the player is wearing a gas mask.
local function HasGasMask(inst)
	return inst:HasTag("hasplaguemask") or inst:HasTag("has_gasmask")
end

--Sets the modifier UM_hayfever inflicts upon the player
function UM_hayfever:UpdateHayfeverSanityDrain(inst)
	inst.components.sanity.externalmodifiers:SetModifier(self, self.passive_sanityrate + self.proximity_sanityrate)
end

--Calculates the proximity sanity drain the player should be receiving based on the pollen they are inhaling 
function UM_hayfever:CalcProximityDrain(pollen)
	local drain = 0
	if pollen > 0.003 then
		drain = -TUNING.SANITYAURA_TINY/2
	end
	if pollen > 0.01 then
		drain = -TUNING.SANITYAURA_TINY
	end
	if pollen > 0.1 then
		drain = -TUNING.SANITYAURA_SMALL*2
	end
	if HasGasMask(self.inst) then
		drain = 0
	end		
	self.proximity_sanityrate = drain
end

--Calculates the passive sanity drain the player recieves when they let nosestuffyness get too high
function UM_hayfever:CalcPassiveDrain()
	if self.nosestuffyness > 50 then
		self.passive_sanityrate = -TUNING.SANITYAURA_TINY/2
	end
	if self.nosestuffyness > 150 then
		self.passive_sanityrate = -TUNING.SANITYAURA_SMALL/2
	end
	if self.nosestuffyness > 250 then
		self.passive_sanityrate = -TUNING.SANITYAURA_MED/2
	end
	if self.nosestuffyness < 50 then
		self.passive_sanityrate = 0
	end
end

--Updates and calculates how much slowness the player should be recieving based on the pollen they are inhaling and their nosestuffyness value.
function UM_hayfever:UpdateSlowness(pollencount)
	local mult = 1
	if (pollencount > 0.01 and not HasGasMask(self.inst)) then
		mult = 0.9
	end
	if (pollencount > 0.05 and not HasGasMask(self.inst)) or self.nosestuffyness > 150 then
		mult = 0.85
	end
	if (pollencount > 0.5 and not HasGasMask(self.inst)) or self.nosestuffyness > 250 then
		mult = 0.8
	end
	self.inst.components.locomotor:RemoveExternalSpeedMultiplier(self.inst, "hayfever")
	self.inst.components.locomotor:SetExternalSpeedMultiplier(self.inst, "hayfever", mult)
end
-------------------------------------------------------------------
-- This function runs every dt, handles searching for all plants with UM_pollen nearby and determines their effect based on category.
-- After that it also determines how the plants' pollen should change nosestuffyness and runs all the other subfunctions above based on pollencount and nosestuffyness
-------------------------------------------------------------------
function UM_hayfever:PollenCount(dt)
	local inst = self.inst
	local x,y,z = inst.Transform:GetWorldPosition()
	local pollenplants = TheSim:FindEntities(x,y,z,10,{"UM_pollen"})
	if pollenplants then
		local lowpollencount,medpollencount,highpollencount = 0,0,0
		------------------------------
		--Check Each Plant for uniqueness such as being picked.... it affects the pollen count!
		------------------------------
		for i,v in ipairs(pollenplants) do
			--Low
			local lowaddition,medaddition,highaddition = 0
			if v:HasTag("pollenlow") and inst:GetDistanceSqToInst(v) < (4^2) then
				lowaddition = 1/15*dt
				if v.components.pickable and v.components.pickable.canbepicked == false then
					lowaddition = lowaddition*0.25
				end
				lowpollencount = lowpollencount + lowaddition
				lowaddition = 0
			end
			--Med
			if v:HasTag("pollenmed") and inst:GetDistanceSqToInst(v) < (5^2) and not v:HasTag("stump") then --Stumps AINT GOT NO POLLEN
				medaddition = 1/7*dt
				medpollencount = medpollencount + medaddition
				medaddition = 0
			end			
			--Large
			if v:HasTag("pollenhigh") then
				highaddition = 1/5*dt
				highpollencount = highpollencount + highaddition
				highaddition = 0
			end		
		end
		------------------------------
		--Check to see if the player has a gas mask 
		------------------------------
		local pollencount = lowpollencount + medpollencount + highpollencount
		if pollencount ~= 0 then
			if HasGasMask(inst) or inst:HasTag("wereplayer") then --Wereplayers have passive gas mask, but without the effect blocking.
				pollencount = pollencount * 0.25
			end
			inst.components.UM_hayfever:DoDelta(pollencount)
		end
		
		if self.inst:HasTag("playerghost") then --If the player is dead, reset their pollencount, etc. Consider reworking this into an event listener.
			pollencount = 0
			self.nosestuffyness = 0
		end
		self.pollencount = pollencount --Used for use in HealthManage and possibly other external use... thinking about letting items gain a bonus if their user is immersed in pollen.
		inst.components.UM_hayfever:CalcProximityDrain(pollencount)
		inst.components.UM_hayfever:UpdateSlowness(pollencount)
		inst.components.UM_hayfever:CalcPassiveDrain()
		inst.components.UM_hayfever:UpdateHayfeverSanityDrain(inst)
	end
end

--Redirects to PollenCount function
function UM_hayfever:OnUpdate(dt)
	self:PollenCount(dt)
end

--Healthmanage function manages health reductions based on how much 
local function HealthManage(inst)
	local self = inst.components.UM_hayfever
	if inst.components.health ~= nil then
		if (self.pollencount > 0.5 and not HasGasMask(inst)) or self.nosestuffyness > 200 then
			inst.components.health:DoDelta(-3,"Sinus Infection")
		end
		if self.nosestuffyness > 250 then
			inst.components.health:DeltaPenalty(0.01)
		end
	end
end

--Simple Enable function... nothing really to see here
function UM_hayfever:Enable()
	self.enabled = true
	self.pollencounttask = self.inst:DoPeriodicTask(3,HealthManage)
    self.inst:StartUpdatingComponent(self)
	TheNet:SystemMessage("Hayfever is active!")
end

--Simple Disable function... nothing to see here
function UM_hayfever:Disable()
    self.enabled = false
	self.pollencounttask = nil
    self.inst:StopUpdatingComponent(self)
	self.inst.components.locomotor:RemoveExternalSpeedMultiplier(self.inst, "hayfever")
	TheNet:SystemMessage("Hayfever has been deactivated!")
end

--Important saved data is whether hayfever is enabled as well as nosestuffyness
function UM_hayfever:OnSave()
    local data = {}
    local references = {}

    data.enabled = self.enabled
	data.pollencount = self.pollencount
	data.nosestuffyness = self.nosestuffyness
    return data, references
end

--Important loaded data is whether hayfever is enabled as well as nosestuffyness
--Goes ahead and runs an update on the sanity drain
function UM_hayfever:OnLoad(data, newents)
    if data then
        if data.enabled then
            self.enabled = data.enabled
        end
		if data.pollencount then
			self.pollencount = data.pollencount
		end
		if data.nosestuffyness then
			self.nosestuffyness = data.nosestuffyness
		end
    end 
    if self.enabled then
        self:Enable()
    end
	self:CalcPassiveDrain()
	self:UpdateHayfeverSanityDrain(self.inst)
end

return UM_hayfever
