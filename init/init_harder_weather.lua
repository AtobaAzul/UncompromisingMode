----------------------------------------------------------------------------------------------------------
-- Nerf therml stone stacking
-- Relevant: heatrock.lua
----------------------------------------------------------------------------------------------------------
--TODO

----------------------------------------------------------------------------------------------------------
-- Make thermal stone very ineffective if no winter clothing found
-- Relevant: heatrock.lua
----------------------------------------------------------------------------------------------------------
--TODO

----------------------------------------------------------------------------------------------------------
-- Make you take damage randomly when at Max Moisture wetness, by falling and knockbacking
-- Relevant: moisture.lua, onmaxmoisture
----------------------------------------------------------------------------------------------------------
--TODO: get this working
local TUNING.DSTU.TRIPOVER_HEALTH_PENALTY = 15;
local TUNING.DSTU.TRIPOVER_ONMAXWET_CHANCE = 0.10;
local TUNING.DSTU.TRIPOVER_KNOCKABCK_RADIUS = 20;

function trip_over(player)
    print("tripped over")
    --trip over you scrubby eel
    player:PushEvent("knockback", {knocker = player, radius = TUNING.DSTU.TRIPOVER_KNOCKABCK_RADIUS})
    player.components.health:DeltaPenalty(TUNING.DSTU.TRIPOVER_HEALTH_PENALTY)
end

local function trip_over_chance_on_maxwet(player)
    print("fall when wet?")
    if(player~=nil and player.GetMoisture == self.GetMaxMoisture) then
        print("totally wet")
        if (GLOBAL.math.random() > TUNING.DSTU.TRIPOVER_ONMAXWET_CHANCE)-- and
            --~player.walking) then
            -- or try self.components.playercontroller.directwalking
            -- or try self.status == RUNNING
            trip_over(player)
        end
    end
end

AddComponentPostInit("moisture", function(self)
    function self:LongUpdate(dt)
            self:OnUpdate(dt)
            print("moisture long update")
            trip_over_chance_on_maxwet(self.inst.player_classified)
    end
end)

----------------------------------------------------------------------------------------------------------
-- Increase the chance of dropping wet tool on hit
-- Relevant: inventoryitemmoisture.lua, moisture.lua, player_common.lua (DropWetTool)
----------------------------------------------------------------------------------------------------------
--TODO: Get this working
local TUNING.DSTU.SLIPCHANCE_INCREASE_X = 3;
AddPrefabPostInit("player_common", function(inst)

	local function DropWetTool(inst, data)
        --Tool slip.
        if inst.components.moisture:GetSegs() < 4 then
            return
        end
    
        local tool = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        if tool ~= nil and tool:GetIsWet() and math.random() < easing.inSine(TheWorld.state.wetness, 0, .15*TUNING.DSTU.SLIPCHANCE_INCREASE_X, inst.components.moisture:GetMaxMoisture()) then
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
    
    if inst ~= nil and inst.components.combat ~= nil then 
        inst.components.combat:SetRetargetFunction(GLOBAL.GetRandomWithVariance(1, .5), retargetfn)
    end
end)

-- Anyone know how to change a Class's function post init, similar to AddPrefabPostInit? I want to change Moisture:LongUpdate inside this https://pastebin.com/q23J9kpt

-- Other code snippets:
-- local waterproofness = (v.components.inventory and math.min(v.components.inventory:GetWaterproofness(),1)) or 0
-- moisture:DoDelta(wetamount * (1 - waterproofness))
-- self.inst.components.moisture:GetMoisture()
-- self.inst.components.moisture:GetMaxMoisture()
-- owner.components.moisture:GetMoisture())