
local WathomArms = Class(function(self, inst)
	self.inst = inst
	self.stab = nil
	self.stabtest = nil
	self.onstabdo = nil
	self.canusefrominventory = false
	self.isbow = false
	self.canuseontargets = true
	self.canuseonpoint = false
	self.action = ACTIONS.WARFARINARMS
end)

function WathomArms:SetStabFn(fn)
	self.stab = fn
end

function WathomArms:SetStabTestFn(fn)
	self.stabtest = fn
end

function WathomArms:SetOnStabDoFn(fn)
	self.onstabdo = fn
end

function WathomArms:SetAction(act)
	self.action = act
end

function WathomArms:DoStab(target, pos)
	if self.stab then
		self.stab(self.inst, target, pos)

		if self.onstabdo then
			self.onstabdo(self.inst, target, pos)
		end
	end
	self.inst:FacePoint(target.Transform:GetWorldPosition())
end

function WathomArms:CanStab(doer, target, pos)
	if self.stabtest then
		return self.stabtest(self.inst, doer, target, pos) and self.stab ~= nil
	end

	return self.stab ~= nil

end

function WathomArms:CollectInventoryActions(doer, actions)
	if self:CanStab(doer) and self.canusefrominventory then
		table.insert(actions, self.action)
	end
end

function WathomArms:CollectEquippedActions(doer, target, actions, right)
	if right and self:CanStab(doer, target) and self.canuseontargets then
		table.insert(actions, self.action)
	end
end

function WathomArms:CollectPointActions(doer, pos, actions, right)
    if right and self:CanStab(doer, nil, pos) and self.canuseonpoint then
		table.insert(actions, self.action)
	end
end

return WathomArms