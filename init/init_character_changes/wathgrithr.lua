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
		local delta = (data.inst.components.combat.defaultdamage) * 0.25
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

local function battleborn_onattack(inst)
	inst.battleborn = -1000000000000
end

env.AddPrefabPostInit("wathgrithr", function(inst) 
	if not TheWorld.ismastersim then
		return
	end
	
	inst.battleborn = -1000000000000
	inst:ListenForEvent("onattackother", battleborn_onattack)
    inst:ListenForEvent("entity_death", function(wrld, data) onkill(inst, data) end, TheWorld)
end)

