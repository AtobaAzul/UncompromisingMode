local env = env
GLOBAL.setfenv(1, GLOBAL)

local function MayKill(self, amount)
    if self.currenthealth + amount <= 0 then
        return true
    end
end

local function DoSleep(inst, revived)
    if inst ~= revived and
        (TheNet:GetPVPEnabled() or not inst:HasTag("player")) and
        not (inst.components.freezable ~= nil and inst.components.freezable:IsFrozen()) and
        not (inst.components.pinnable ~= nil and inst.components.pinnable:IsStuck()) and
        not (inst.components.fossilizable ~= nil and inst.components.fossilizable:IsFossilized()) then
        local mount = inst.components.rider ~= nil and inst.components.rider:GetMount() or nil
        if mount ~= nil then
            mount:PushEvent("ridersleep", { sleepiness = 10, sleeptime = TUNING.PANFLUTE_SLEEPTIME })
        end
        if inst.components.sleeper ~= nil then
            inst.components.sleeper:AddSleepiness(10, TUNING.PANFLUTE_SLEEPTIME)
        elseif inst.components.grogginess ~= nil then
            inst.components.grogginess:AddGrogginess(10, TUNING.PANFLUTE_SLEEPTIME)
        else
            inst:PushEvent("knockedout")
        end
    end
end

local function FindSleepable(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, 7, { "_combat", "_health" }, { "player" })
    if ents then
        for i, v in ipairs(ents) do
            if v.components.health and not v.components.health:IsDead() then
                DoSleep(v, inst)
            end
        end
    end
end

local function TriggerAmulet(self)
    if self.inst.components.timer ~= nil and self.inst:HasTag("wathom") then
        if self.inst.components.timer:TimerExists("shadowwathomcooldown") then
            self.inst.components.timer:StopTimer("shadowwathomcooldown")
            self.inst.components.timer:StartTimer("shadowwathomcooldown", TUNING.TOTAL_DAY_TIME)
        else
            self.inst.components.timer:StartTimer("shadowwathomcooldown", TUNING.TOTAL_DAY_TIME)
        end
    end

    local item = self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.NECK)
    if item == nil then
        item = self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY)
    end

    local item2
    FindSleepable(self.inst)
    self:SetCurrentHealth(1)
    if self.inst.components.oldager ~= nil then
        self.inst.components.oldager:StopDamageOverTime()
        self:DoDelta(49, true, "pocketwatch_heal", true)
    else
        self:DoDelta(49, false, item, true) --set 25%
    end

    if self.inst:HasTag("wathom") then
        self.inst.AnimState:SetBuild("wathom")
    end

    SpawnPrefab("slingshotammo_hitfx_gold").Transform:SetPosition(self.inst.Transform:GetWorldPosition())
    SpawnPrefab("shadow_despawn").Transform:SetPosition(self.inst.Transform:GetWorldPosition())

    self:SetInvincible(true)

    if self.inst.components.sanity then
        self.inst.components.sanity:SetPercent(0.25)
    end

    self.inst:DoTaskInTime(1,
        function(inst) if inst.components.health then inst.components.health:SetInvincible(false) end end)
    item:DoTaskInTime(0, function(item) item:Remove() end)
end

local function HasLLA(self)
    if self.inst.components.inventory then
        local item = self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.NECK)
        if item == nil then
            item = self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY)
        end
        if item and item.prefab == "amulet" and self.inst.components.timer ~= nil and not self.inst.components.timer:TimerExists("shadowwathomcooldown") then
            return true
        end
    end
end
local function IsCharlieRose(item)
    return item.prefab == "charlierose"
end


local function HasCharlieRose(self)
    return self.inst.components.inventory:FindItem(IsCharlieRose) ~= nil
end

local function TriggerRose(self)
    local rose = self.inst.components.inventory:FindItem(IsCharlieRose)

    if rose then
        if rose.components.stackable then
            rose.components.stackable:Get():Remove()
        else
            rose:Remove()
        end
    end

    self.inst.components.sanity:SetPercent(.5, true)
    self.inst.components.hunger:SetPercent(2 / 3, true)
    self.inst.components.temperature:SetTemp(TUNING.STARTING_TEMP)
    self:DeltaPenalty(0.25)
    self:SetPercent(0.5)

    for i = 0, 3 do
        self.inst:DoTaskInTime(math.random(), function(inst)
            local x, y, z = inst.Transform:GetWorldPosition()
            local fx = SpawnPrefab("rose_petals_fx")
            fx.Transform:SetPosition(x + GetRandomMinMax(-1, 1), y, z + GetRandomMinMax(-1, 1))
        end)
    end
end

env.AddComponentPostInit("health", function(self)
    if not TheWorld.ismastersim then return end

    local _DoDelta = self.DoDelta
    --(self:HasTag("wathom") and self:HasTag("amped")
    function self:DoDelta(amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb, ...)
        if TUNING.DSTU.SHADOW_WATHOM and self.inst:HasTag("wathom") then
            if MayKill(self, amount) and cause == "shadowvortex" and TUNING.DSTU.COMPROMISING_SHADOWVORTEX and not self.inst.sg:HasStateTag("blackpuddle_death") then
                self.inst.components.rider:ActualDismount()
                self.inst.sg:GoToState("blackpuddle_death")
                return 1
            elseif MayKill(self, amount) and HasLLA(self) and not self.inst:HasTag("deathamp") then --and not (self.inst:HasTag("deathamp")) then
                TriggerAmulet(self)
                return 49
            elseif MayKill(self, amount) and HasLLA(self) and self.inst:HasTag("deathamp") and cause == "deathamp" and self.inst.components.timer ~= nil and not self.inst.components.timer:TimerExists("shadowwathomcooldown") then
                if not self.inst:HasTag("playerghost") and self.inst.ToggleUndeathState ~= nil then
                    self.inst:ToggleUndeathState(self.inst, false)
                end
                TriggerAmulet(self) --Don't trigger the LLA here, let it happen in our own component, so this doesn't break whenever canis moves it to his own mod.
                return 49
            elseif self.inst:HasTag("deathamp") and cause ~= "deathamp" then
                self.inst.components.adrenaline:DoDelta(amount * 1)
            elseif MayKill(self, amount) and (self.inst:HasTag("wathom") and self.inst:HasTag("amped")) and cause ~= "deathamp" then --suggest that we add a trigger here to show that wathom is still being hit, despite his lack of flinching or anything.
                if not self.inst:HasTag("deathamp") then
                    self.inst:AddTag("deathamp")
                    self.inst:ToggleUndeathState(self.inst, true)
                    return _DoDelta(self, -self.currenthealth + 1, false, cause, true, afflicter, ignore_absorb, ...) --needed to do this for ignore_invincible...
                end
            elseif not self.inst:HasTag("deathamp") then                                                              -- No positive healing if you're on your last breath
                return _DoDelta(self, amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb, ...)
            end
        elseif MayKill(self, amount) and HasLLA(self) then
            TriggerAmulet(self)
            return 49
        elseif MayKill(self, amount) and HasCharlieRose(self) then
            TriggerRose(self)
        else
            return _DoDelta(self, amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb, ...)
        end
    end
end)
