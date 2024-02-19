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
    local function SpawnPosse(nymph) --, x, z)
        if not nymph.aphidposse then
            nymph.aphidposse = 0
        end
        local modifier = 1
        if TheWorld.state.isspring or TheWorld.state.iswinter then
            modifier = 0.5
        end

        for i = 1, math.random(5, 8) * modifier do
            local x, y, z = nymph.Transform:GetWorldPosition()
            local x_off, z_off = FindSmallOffset(x, z)
            local aphid = SpawnPrefab("aphid")
            aphid.Transform:SetPosition(x_off, 0, z_off)
            aphid.nymph = nymph
            aphid.components.follower:SetLeader(nymph)
            aphid.sg:GoToState("enter_loop")
            nymph.aphidposse = nymph.aphidposse + 1
            aphid.persists = false
            --[[nymph.aphidposse = {}
			for i = 1, math.random(5, 8) do
				local x_off, z_off = FindSmallOffset(x, z)
				local aphid = SpawnPrefab("aphid")
				table.insert(nymph.aphidposse, aphid)
				aphid.Transform:SetPosition(x_off, 0, z_off)
				aphid.nymph = nymph
				aphid.components.follower:SetLeader(nymph)
				aphid.sg:GoToState("enter_loop")
			end]]
            aphid:ListenForEvent("ondeath", function(inst)
                if nymph and nymph.aphidposse > 1 then
                    nymph.aphidposse = nymph.aphidposse - 1
                end
            end)
            aphid:DoPeriodicTask(4, function(aphid) aphid.NymphGroundCheck(aphid) end)
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
            SpawnPosse(nymph) --, x, z)
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
        if self.redwoods ~= nil then
            for i, v in ipairs(self.redwoods) do
                if v:HasTag("infestedtree") then
                    infested = infested + 1
                end
            end

            return infested / #self.redwoods
        end

        return 1
    end

    function self:InitializePestilenceTimer()
        if not self.inst.components.timer:TimerExists("spreadaphids") then
            local time = 10 * 60 * 8 -- Max Time to spread at 10 days

            local percent = self:GetInfestedTreePercent()

            time = time * (percent * 10)

            if percent >= 0.5 then
                self.inst:DoTaskInTime(TUNING.TOTAL_DAY_TIME, function(inst) inst.components.um_pestilencecontroller:InitializePestilenceTimer() end)
			else
				if TheWorld.state.iswinter then
					self.inst.components.timer:StartTimer("spreadaphids", 5 * time) -- Winter means we'll wait a lot longer before starting up aphids again...
				else
					self.inst.components.timer:StartTimer("spreadaphids", time)
				end
            end
        end
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
                inst.components.um_pestilencecontroller:InitializePestilenceTimer()
            end)
        elseif not self.inst.components.timer:TimerExists("spreadaphids") then
            self.inst.components.timer:InitializeTimer()
        end
    end

    inst:ListenForEvent("timerdone", function(inst, data)
        if data then
            if data.name == "spreadaphids" then
                if not TheWorld.state.iswinter then
                    self:SpawnNymph()
                end
                self:InitializePestilenceTimer()
            end
        end
    end)
end)
