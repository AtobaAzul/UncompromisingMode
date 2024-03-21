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
        for i = 1, math.random(4, 6) do
            local x_off, z_off = FindSmallOffset(x, z)
            local aphid = SpawnPrefab("aphid")
            nymph.aphidposse = (nymph.aphidposse or 0) + 1
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
        if self.redwoods ~= nil then
            for i, v in ipairs(self.redwoods) do
                if v:HasTag("infestedtree") then
                    infested = infested + 1
                end
            end

            if #self.redwoods == 0 then
                return 0
            else
                return infested / #self.redwoods
            end
        end

        return 1
    end

    function self:InitializeTimer()
        if not self.inst.components.timer:TimerExists("spreadaphids") then
            local time = 10 * 60 * 8 * (self:GetInfestedTreePercent() * 2) --Linear Scaling from 0->20 days

            self.inst.components.timer:StartTimer("spreadaphids", time)
        end
    end

    --THIS IS SAVING ACTUAL ENTITIES. Do NOT save actual entites as it very consistently causes crashes on save/load.
    --On this case especifically saving/loading is redundant as well as populating the component postinit always occurs.
    --[[function self:OnSave()
        local data = {}
        data.redwoods = self.redwoods
    end

    function self:OnLoad(data)
        if data then
            if data.redwoods then
                self.redwoods = data.redwoods
            end
        end
    end]]

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
