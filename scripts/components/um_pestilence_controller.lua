return Class(function(self, inst)
	self.inst = inst
	assert(TheWorld.ismastersim, "um_ocupusappearinator should not exist on client")
	--Todo What if a tree is somehow added or removed?

	local function FindSmallOffset(x, z)
		local x_off = math.random(-10, 10) / 5 + x
		local z_off = math.random(-10, 10) / 5 + z
		if TheWorld.Map:IsVisualGroundAtPoint(x_off, 0, z_off) then
			return x_off, z_off
		else
			return FindSmallOffset(x, z)
		end
	end
	local function SpawnPosse(nymph, x, z)
		nymph.aphidposse = {}
		for i = 1, math.random(5, 8) do
			local x_off, z_off = FindSmallOffset(x, z)
			local aphid = SpawnPrefab("aphid")
			table.insert(nymph.aphidposse, aphid)
			aphid.Transform:SetPosition(x_off, 0, z_off)
			aphid.nymph = nymph
			aphid.components.follower:SetLeader(nymph)
			aphid.sg:GoToState("enter_loop")
		end
	end

	function self:SpawnNymph()
		local cleanredwoods = {}
		local infestedredwoods = {}

		if self.redwoods ~= nil then
			for i, v in ipairs(self.redwoods) do
				if v:HasTag("infestedtree") then
					table.insert(infestedredwoods, v)
				else
					table.insert(cleanredwoods, v)
				end
			end
		end

		if #infestedredwoods > 0 and #cleanredwoods > 0 then
			local nymph = SpawnPrefab("nymph")
			local homepos = infestedredwoods[math.random(#infestedredwoods)]:GetPosition()

			local offset = FindWalkableOffset(homepos, math.random() * 2 * PI, 4, 4)
			local x, z = offset.x + homepos.x, offset.z + homepos.z
			nymph.Transform:SetPosition(x, 0, z)
			nymph.treetarget = cleanredwoods[math.random(#cleanredwoods)]:GetPosition()
			nymph.sg:GoToState("land")
			SpawnPosse(nymph, x, z)
		end
	end

	function self:FindTrees()
		if not self.redwoods then
			local tag = "giant_tree"
			self.redwoods = {}
			for k, v in pairs(Ents) do
				if v:HasTag(tag) then
					table.insert(self.redwoods, v)
				end
			end
		end
	end

	function self:GetInfestedTreePercent()
		local infested = 0
		for i, v in ipairs(self.redwoods) do
			if v:HasTag("infestedtree") then
				infested = infested + 1
			end
		end
		return infested / #self.redwoods
	end

	function self:InitializeTimer()
		local time = 10 * 60 * 8                   -- Max Time to spread at 10 days
		if self:GetInfestedTreePercent() > 0.5 then -- Half the forest is taken... need no reduction

		elseif self:GetInfestedTreePercent() > 0.25 then -- Good bit of the forest is taken.
			time = time / 10
		else                                       -- The Aphids are in danger of going extinct, spread faster (0.5 days)
			time = time / 20
		end
		self.inst.components.timer:StartTimer("spreadaphids", time)
	end

	function self:OnSave()
		local data = {}
		data.redwoods = self.redwoods
	end

	function self:OnLoad(data)
		if data then
			if data.redwoods then
				self.redwoods = data.redwoods
			end
		end
	end

	function self:OnPostInit()
		if not self.redwoods then
			self.inst:DoTaskInTime(1, function(inst)
				inst.components.um_pestilencecontroller:FindTrees()
				inst.components.um_pestilencecontroller:InitializeTimer()
			end)
		elseif not self.inst.components.timer:TimerExists("spreadaphids") then
			self.inst.components.timer:InitializeTimer()
		end
	end

	inst:ListenForEvent("timerdone", function(inst, data)
		if data then
			if data.name == "spreadaphids" then
				self:SpawnNymph()
				self:InitializeTimer()
			end
		end
	end)
end)
