----------------------------------------------------------------------------------------------------------
-- Remove thermal stone sewing
-- Relevant: heatrock.lua
----------------------------------------------------------------------------------------------------------
local function DoSewing(self, target, doer)
    if self ~= nil and self.inst ~= nil then
        local _OldDoSewing = self.DoSewing
        
        self.DoSewing = function(self, target, doer)
            if target ~= nil and not target:HasTag("heatrock") then --<< Check for thermal
                _OldDoSewing(self, target, doer)
            end
        end
    end
end
AddComponentPostInit("sewing", DoSewing)
--TODO thermal stone stacking

----------------------------------------------------------------------------------------------------------
-- Make thermal stone very ineffective if no winter clothing found
-- Relevant: heatrock.lua, HeatFn, heater:SetThermics
----------------------------------------------------------------------------------------------------------
--TODO thermal stone ineffetive without clothes

----------------------------------------------------------------------------------------------------------
-- Make you take damage randomly when at Max Moisture wetness, by falling and knockbacking
-- Relevant: moisture.lua, onmaxmoisture
----------------------------------------------------------------------------------------------------------
--TODO: Add slip sound

local function trip_damage(player)
    player.components.health:DoDelta(-GLOBAL.TUNING.DSTU.TRIPOVER_HEALTH_DAMAGE)
end

local function trip_over(player)
    --trip over you scrubby eel
    player:PushEvent("knockback", {knocker = player, radius = GLOBAL.TUNING.DSTU.TRIPOVER_KNOCKABCK_RADIUS, strengthmult = 0.5})
    player:DoTaskInTime(0.5, trip_damage)
end

local function trip_chance_check()
    return GLOBAL.math.random() < GLOBAL.TUNING.DSTU.TRIPOVER_ONMAXWET_CHANCE_PER_SEC
end

local function trip_over_chance_on_maxwet(player)
    if player~=nil and player:HasTag("character") and (player:GetMoisture() == player:GetMaxMoisture()) and player.sg ~= nil and player.sg:HasStateTag("moving") then
        local time = GLOBAL.GetTime()
        if player.components.moisture.lastslip_check < time - 1 then
            if player.components.moisture.lastslip_time < time - GLOBAL.TUNING.DSTU.TRIPOVER_ONMAXWET_COOLDOWN  then
                print("chance")
                if trip_chance_check() then
                    print("hit")
                    trip_over(player)
                    --play sound too
                    player.SoundEmitter:PlaySound("dontstarve/common/dropGeneric")
                    player.components.moisture.lastslip_time = time
                end
            end
            print("check")
            player.components.moisture.lastslip_check = time
        end
    end
end

local function OnUpdate(self, dt)
    print(dt)
    if self ~= nil and self.inst ~= nil then
        local _OldOnUpdate = self.OnUpdate
        
        self.OnUpdate = function(self, dt)
            _OldOnUpdate(self, dt)
            trip_over_chance_on_maxwet(self.inst)
        end
    end
end

AddComponentPostInit("moisture", function(component)
    if component ~= nil and GLOBAL ~= nil then
        component.lastslip_time = GLOBAL.GetTime()
        component.lastslip_check = GLOBAL.GetTime()
    end
end)
AddComponentPostInit("moisture", OnUpdate)

----------------------------------------------------------------------------------------------------------
-- Increase the chance of dropping wet tool on hit
-- Relevant: inventoryitemmoisture.lua, moisture.lua, player_common.lua (DropWetTool)
----------------------------------------------------------------------------------------------------------
--Note: Not working, removed plans of adding this

--[[local function DropWetTool(inst, data)
    --Tool slip.
    if inst.components.moisture:GetSegs() < 4 then
        return
    end

    print(1)
    local tool = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
    if tool ~= nil and tool:GetIsWet() and math.random() < easing.inSine(TheWorld.state.wetness, 0, .15*GLOBAL.TUNING.DSTU.SLIPCHANCE_INCREASE_X, inst.components.moisture:GetMaxMoisture()) then
        print(2)
        local projectile =                                                              -- Change here ^
            data.weapon ~= nil and
            data.projectile == nil and
            (data.weapon.components.projectile ~= nil or data.weapon.components.complexprojectile ~= nil)

        if projectile then
            local num = data.weapon.components.stackable ~= nil and data.weapon.components.stackable:StackSize() or 1
            if num <= 1 then
                return
            end
            inst.components.inventory:Unequip(EQUIPSLOTS.HANDS, true)
            tool = data.weapon.components.stackable:Get(num - 1)
            tool.Transform:SetPosition(inst.Transform:GetWorldPosition())
            if tool.components.inventoryitem ~= nil then
                tool.components.inventoryitem:OnDropped()
            end
        else
            inst.components.inventory:Unequip(EQUIPSLOTS.HANDS, true)
            inst.components.inventory:DropItem(tool)
        end

        if tool.Physics ~= nil then
            local x, y, z = tool.Transform:GetWorldPosition()
            tool.Physics:Teleport(x, .3, z)

            local angle = (math.random() * 20 - 10) * DEGREES
            if data.target ~= nil and data.target:IsValid() then
                local x1, y1, z1 = inst.Transform:GetWorldPosition()
                x, y, z = data.target.Transform:GetWorldPosition()
                angle = angle + (
                    (x1 == x and z1 == z and math.random() * 2 * PI) or
                    (projectile and math.atan2(z - z1, x - x1)) or
                    math.atan2(z1 - z, x1 - x)
                )
            else
                angle = angle + math.random() * 2 * PI
            end
            local speed = projectile and 2 + math.random() or 3 + math.random() * 2
            tool.Physics:SetVel(math.cos(angle) * speed, 10, math.sin(angle) * speed)
        end
        --Lock out from picking up for a while?
        --V2C: no need, the stategraph goes into busy state
    end
end

local function OnAttackOther(inst, data)
    if data ~= nil and data.target ~= nil and data.target:HasTag("player") then
        inst.hasAttackedPlayer = true
    end
    if data.weapon then
        DropWetTool(inst, data)
    end
end


AddPlayerPostInit(function(inst)
    if inst ~= nil then 
        inst:ListenForEvent("onattackother", OnAttackOther)
    end
end)
]]
