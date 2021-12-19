local function StartTransform(inst)
	inst.components.uncompromising_transformer.queuedTransform = false
	inst.components.uncompromising_transformer:StartTransform()
end

local function StartRevert(inst)
	inst.components.uncompromising_transformer.queuedRevert = false
	inst.components.uncompromising_transformer:StartRevert()
end

local function StartTransformWorld(self, value)
	if not self.transformWorldEventValue or value == self.transformWorldEventValue then
		self.queuedTransform = false
		self:StartTransform()
	end
end

local function StartRevertWorld(self, value)
	if not self.revertWorldEventValue or value == self.revertWorldEventValue then
		self.queuedRevert = false
		self:StartRevert()
	end
end

local Uncompromising_Transformer = Class(function(self, inst)

	self.inst = inst

	self.transformPrefab = "rabbit"

	self.objectData = nil

	self.transformEvent = nil
	self.transformEventTarget = nil

	self.revertEvent = nil
	self.revertEventTarget = nil

	self.onTransform = nil
	self.onRevert = nil

	self.transformed = false

	self.transformOffScreen = true

	self.queuedTransform = false
	self.queuedRevert = false

end)

function Uncompromising_Transformer:GetDebugString()
	return tostring(self.transformed)
end

function Uncompromising_Transformer:SetOnTransformFn(fn)
	self.onTransform = fn
end

function Uncompromising_Transformer:SetOnRevertFn(fn)
	self.onRevert = fn
end

function Uncompromising_Transformer:SetObjectData(data)
	self.objectData = data
end

function Uncompromising_Transformer:GetObjectData()
	local c_data = {}
	local p_data = {}

	for k,v in pairs(self.inst.components) do
		if v.OnSave then
			local t, refs = v:OnSave()
			if t then
				c_data[k] = t
			end
		end
	end

	if self.inst.OnSave then
		self.inst.OnSave(self.inst, p_data)
	end

	self.objectData = {
		prefab = self.inst.prefab,
		component_data = c_data,
		prefab_data = p_data,
	}
end

function Uncompromising_Transformer:RemoveSleepEvents()
	if self.sleepRevertEvent then
		self.inst:RemoveEventCallback("entitysleep", StartRevert)
		self.sleepRevertEvent = nil
	end

	if self.sleepTransformEvent then
		self.inst:RemoveEventCallback("entitysleep", StartTransform)
		self.sleepTransformEvent = nil
	end

	self.queuedRevert = false
	self.queuedTransform = false
end

function Uncompromising_Transformer:SetRevertEvent(event, target)
    self.inst:DoTaskInTime(.1, function()
		if self.revertEvent then return end
		self.revertEvent = event
		self.revertEventTarget = target or nil

		self.inst:ListenForEvent(self.revertEvent, StartRevert, self.revertEventTarget or TheWorld)
	end)
end

function Uncompromising_Transformer:SetTransformEvent(event, target)
    self.inst:DoTaskInTime(.1, function()
		if self.transformEvent then return end
		self.transformEvent = event
		self.transformEventTarget = target or nil

		self.inst:ListenForEvent(self.transformEvent, StartTransform, self.transformEventTarget or TheWorld)
	end)
end

function Uncompromising_Transformer:SetRevertWorldEvent(event, value)
	self.inst:DoTaskInTime(.1, function()
		if self.revertWorldEvent then return end
		self.revertWorldEvent = event
		self.revertWorldEventValue = value

		self:WatchWorldState(self.revertWorldEvent, StartRevertWorld)
	end)
end

function Uncompromising_Transformer:SetTransformWorldEvent(event, value)
	self.inst:DoTaskInTime(.1, function()
		if self.transformWorldEvent then return end
		self.transformWorldEvent = event
		self.transformWorldEventValue = value

		self:WatchWorldState(self.transformWorldEvent, StartTransformWorld)
	end)
end

function Uncompromising_Transformer:SetOnLoadCheck(check)
	self.onLoadCheck = check
end

function Uncompromising_Transformer:Transform()
	self.inst:DoTaskInTime(math.random(), function()
		local transformedPrefab = SpawnPrefab(self.transformPrefab)
		transformedPrefab.Transform:SetPosition(self.inst:GetPosition():Get())

		if transformedPrefab.components.uncompromising_transformer then
			if self.revertEvent then
				transformedPrefab.components.uncompromising_transformer:SetRevertEvent(self.revertEvent, self.revertEventTarget)
			end

			if self.revertWorldEvent then
				transformedPrefab.components.uncompromising_transformer:SetRevertWorldEvent(self.revertWorldEvent, self.revertWorldEventValue)
			end

			if self.onLoadCheck then
				transformedPrefab.components.uncompromising_transformer:SetOnLoadCheck(self.onLoadCheck)
			end

			transformedPrefab.components.uncompromising_transformer:SetObjectData(self.objectData)
			transformedPrefab.components.uncompromising_transformer.transformed = true
			transformedPrefab.components.uncompromising_transformer.transformOffScreen = self.transformOffScreen
		end

		self.inst:Remove()
	end)
end

function Uncompromising_Transformer:TransformOnSleep()
	self.queuedTransform = true
	self.sleepTransformEvent = self.inst:ListenForEvent("entitysleep", StartTransform)
end

function Uncompromising_Transformer:StartTransform()
	self:RemoveSleepEvents()

	if not self.transformed then
		if (self.transformOffScreen and self.inst:IsAsleep()) or not self.transformOffScreen then
			self:GetObjectData()
			self:Transform()
		else
			self:TransformOnSleep()
		end
	end
end

function Uncompromising_Transformer:Revert()
	self.inst:DoTaskInTime(math.random(), function()
		local obj = SpawnPrefab(self.objectData.prefab)
		if obj then
			obj.Transform:SetPosition(self.inst:GetPosition():Get())
			for k,v in pairs(self.objectData.component_data) do
				local cmp = obj.components[k]
				if cmp and cmp.OnLoad then
					cmp:OnLoad(v)
				end
			end

			if obj.OnLoad then
				obj.OnLoad(obj, self.objectData.item_data)
			end

			self.inst:Remove()
		end
	end)
end

function Uncompromising_Transformer:RevertOnSleep()
	self.queuedRevert = true
	self.sleepRevertEvent = self.inst:ListenForEvent("entitysleep", StartRevert)
end

function Uncompromising_Transformer:StartRevert()
	self:RemoveSleepEvents()

	if self.transformed then
		if (self.transformOffScreen and self.inst:IsAsleep()) or not self.transformOffScreen then
			self:Revert()
		else
			self:RevertOnSleep()
		end
	end
end

function Uncompromising_Transformer:OnSave()
	local data = {}
	local refs = {}

	data.queuedTransform = self.queuedTransform
	data.queuedRevert = self.queuedRevert

	data.transformPrefab = self.transformPrefab
	data.transformed = self.transformed
	data.objectData = self.objectData or nil

	data.transformEvent = self.transformEvent
	data.revertEvent = self.revertEvent
	data.transformWorldEvent = self.transformWorldEvent
	data.transformWorldEventValue = self.transformWorldEventValue
	data.revertWorldEvent = self.revertWorldEvent
	data.revertWorldEventValue = self.revertWorldEventValue

	data.onLoadCheck = self.onLoadCheck

	if self.transformEventTarget then
		data.transformEventTarget = self.transformEventTarget.GUID
		table.insert(refs, self.transformEventTarget.GUID)
	end

	if self.revertEventTarget then
		data.revertEventTarget = self.revertEventTarget.GUID
		table.insert(refs, self.revertEventTarget.GUID)
	end

	return data, refs
end

function Uncompromising_Transformer:OnLoad(data)
	if data then
		self.transformPrefab = data.transformPrefab
		self.objectData = data.objectData
		self.transformed = data.transformed
		self.transformEvent = data.transformEvent
		self.revertEvent = data.revertEvent
		self.onLoadCheck = data.onLoadCheck

		if data.queuedRevert then
			self:RevertOnSleep()
		end

		if data.queuedTransform then
			self:TransformOnSleep()
		end
	end
end

function Uncompromising_Transformer:LoadPostPass(ents, data)
	self.inst:DoTaskInTime(0, function(inst)
		if inst.components.uncompromising_transformer.onLoadCheck ~= nil and inst.components.uncompromising_transformer.onLoadCheck(inst) and not inst.components.uncompromising_transformer.transformed then
			inst.components.uncompromising_transformer:GetObjectData()
			inst.components.uncompromising_transformer:Transform()
		elseif inst.components.uncompromising_transformer.transformed then
			inst.components.uncompromising_transformer:Revert()
		end
	end)
	
	if self.transformEvent then
			print("transformEvent")
		if data.transformEventTarget then
			print("transformEventTarget")
			local tar = ents[data.transformEventTarget]
			if tar then
				tar = tar.entity
				self:SetTransformEvent(self.transformEvent, tar)
			end
		else
			print("else transformEvent")
			self:SetTransformEvent(self.transformEvent)
		end
	end

	if self.revertEvent then
			print("revertEvent")
		if data.revertEventTarget then
			print("revertEventTarget")
			local tar = ents[data.revertEventTarget]
			if tar then
				tar = tar.entity
				self:SetRevertEvent(self.revertEvent, tar)
			end
		else
			self:SetRevertEvent(self.revertEvent)
			print("else SetRevertEvent")
		end
	end

	if self.transformWorldEvent then
			print("transformWorldEvent")
		self:SetTransformWorldEvent(self.transformWorldEvent, self.transformWorldEventValue)
	end

	if self.revertWorldEvent then
			print("revertWorldEvent")
		self:SetRevertWorldEvent(self.revertWorldEvent, self.revertWorldEventValue)
	end

end

return Uncompromising_Transformer
