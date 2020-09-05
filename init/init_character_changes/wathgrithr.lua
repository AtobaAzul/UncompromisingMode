local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
local smallScale = 0.5
local medScale = 0.7
local largeScale = 1.1

local function onkill(inst, data)
	if data.cause == inst.prefab 
		and not data.inst:HasTag("prey") 
		and not data.inst:HasTag("veggie") 
		and not data.inst:HasTag("structure") then
		local delta = (data.inst.components.combat.defaultdamage) * 0.25 / 2
        inst.components.health:DoDelta(delta, false, "battleborn")
        inst.components.sanity:DoDelta(delta)

        if math.random() < .1 and not data.inst.components.health.nofadeout then
        	local time = data.inst.components.health.destroytime or 2
        	inst:DoTaskInTime(time, function()
        		local s = medScale
        		if data.inst:HasTag("smallcreature") then
        			s = smallScale
    			elseif data.inst:HasTag("largecreature") then
    				s = largeScale
    			end
        		local fx = SpawnPrefab("wathgrithr_spirit")
        		fx.Transform:SetPosition(data.inst:GetPosition():Get())
        		fx.Transform:SetScale(s,s,s)
    		end)
        end

	end
end

local function IsValidVictim(victim)
    return victim ~= nil
        and not ((victim:HasTag("prey") and not victim:HasTag("hostile")) or
                victim:HasTag("veggie") or
                victim:HasTag("structure") or
                victim:HasTag("wall") or
                victim:HasTag("balloon") or
                victim:HasTag("groundspike") or
                victim:HasTag("smashable") or
                victim:HasTag("companion"))
        and victim.components.health ~= nil
        and victim.components.combat ~= nil
end

local BATTLEBORN_STORE_TIME = 3
local BATTLEBORN_DECAY_TIME = 5
local BATTLEBORN_TRIGGER_THRESHOLD = 1

local function battleborn_onattack(inst, data)
	inst.battleborn = -1000000000000
    local victim = data.target
    if not inst.components.health:IsDead() and IsValidVictim(victim) then
        local total_health = victim.components.health:GetMaxWithPenalty()
        local damage = (data.weapon ~= nil and data.weapon.components.weapon:GetDamage(inst, victim))
                    or inst.components.combat.defaultdamage
        local percent = (damage <= 0 and 0)
                    or (total_health <= 0 and math.huge)
                    or damage / total_health
        --math and clamp does account for 0 and infinite cases
        local delta = math.clamp(victim.components.combat.defaultdamage * .25 * percent / 1.5, .11, 0.66)

        --decay stored battleborn
        if inst.battleborn2 > 0 then
            local dt = GetTime() - inst.battleborn2_time - BATTLEBORN_STORE_TIME
            if dt >= BATTLEBORN_DECAY_TIME then
                inst.battleborn2 = 0
            elseif dt > 0 then
                local k = dt / BATTLEBORN_DECAY_TIME
                inst.battleborn2 = Lerp(inst.battleborn2, 0, k * k)
            end
        end

        --store new battleborn
        inst.battleborn2 = inst.battleborn2 + delta
        inst.battleborn2_time = GetTime()

        --consume battleborn if enough has been stored
        if inst.battleborn2 > BATTLEBORN_TRIGGER_THRESHOLD then
            inst.components.health:DoDelta(inst.battleborn2, false, "battleborn")
            inst.components.sanity:DoDelta(inst.battleborn2)
            inst.battleborn2 = 0
        end
    end
end

local function ondeath(inst)
	inst.battleborn = -1000000000000
    inst.battleborn2 = 0
end

env.AddPrefabPostInit("wathgrithr", function(inst) 
	if not TheWorld.ismastersim then
		return
	end
	
	inst.battleborn = -1000000000000
	
    inst.battleborn2 = 0
    inst.battleborn2_time = 0
	inst:ListenForEvent("onattackother", battleborn_onattack)
    --inst:ListenForEvent("entity_death", function(wrld, data) onkill(inst, data) end, TheWorld)
	
    inst:ListenForEvent("death", ondeath)
end)

