local Um_DynamicDigester = Class(function(self, inst)
	self.inst = inst
	self.digesttime = 5
	self.itemstodigestfn = nil
	self.digest_per = 1
	self.task = self.inst:DoPeriodicTask(self.digesttime, function() self:TryDigest() end)
	self.inst:ListenForEvent("gotnewitem", function()
		if not self.task then
			self.task = self.inst:DoPeriodicTask(self.digesttime, function() self:TryDigest() end)
		end
	end)
end)


function Um_DynamicDigester:TryDigest()
	if self.inst.components.inventory then
		local helditems = {}

		for k,v in pairs(self.inst.components.inventory.itemslots) do
			if not v:HasTag("irreplaceable") then
				if self.itemstodigestfn then
					if self.itemstodigestfn(self.inst, v) then
						table.insert(helditems, v.prefab)
					end
				else
					table.insert(helditems, v.prefab)
				end
			end
		end
		if #helditems > 0 then
			local rnd = math.random(#helditems)
			self.inst.components.inventory:ConsumeByName(helditems[rnd], self.digest_per)
		else
			if self.task then
				self.task:Cancel()
				self.task = nil
			end
		end
	end
end

return Um_DynamicDigester