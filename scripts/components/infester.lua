local Infester = Class(function(self, inst)
    self.inst = inst    
    self.infesting = false
    self.inst:ListenForEvent("death", function() self:Uninfest() end)
    self.inst:ListenForEvent("freeze", function() self:Uninfest() end)
	self.inst:ListenForEvent("killed", function() self:Uninfest() end)
	self.inst:ListenForEvent("losttarget", function() self:Uninfest() end)
    self.basetime = 1
    self.randtime = 1
    self.inst:AddTag("infester")
end)

function Infester:Uninfest()
	if self == nil then
		self.inst:ClearBufferedAction()
		self.infesting = false
		
		if self.target then
			local pos =Vector3(self.target.Transform:GetWorldPosition())
			self.target:RemoveChild(self.inst)
			self.inst.Physics:Teleport(pos.x,pos.y,pos.z) 
			
			self.target.components.infestable:uninfest(self.inst)
			self.target:RemoveTag("infested")
			self.target = nil
			if self.inst.components.combat ~= nil then
			self.inst.components.combat.target = nil
			end
		end
		
		if self.inst.bitetask then
			self.inst.bitetask:Cancel()
			self.inst.bitetask = nil
		end
		
		self.inst:StopUpdatingComponent(self)
	end
end

function Infester:bite()
	if self.bitefn then
		self.bitefn(self.inst)		
	end
	if self.target then
		self.inst.bitetask = self.inst:DoTaskInTime(self.basetime+(math.random()*self.randtime),function() self:bite() end)
	else
	self.Uninfest()
	end
end

function Infester:Infest(target)	
	if target.components.infestable then
		self.infesting = true
		self.target = target
		self.inst.bitetask = self.inst:DoTaskInTime(self.basetime+(math.random()*self.randtime),function() self:bite() end)
		self.inst.AnimState:SetFinalOffset(-1)
		self.inst.Physics:Teleport(0,0,0)
		self.inst:PushEvent("oninfest")
		target:AddChild(self.inst)
		
		target.components.infestable:infest(self.inst)
		target:AddTag("infested")
	end
end
return Infester