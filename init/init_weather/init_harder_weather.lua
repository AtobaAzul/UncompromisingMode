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

-------------Torches only smolder objects now---------------
local _OldLightAction = GLOBAL.ACTIONS.LIGHT.fn

GLOBAL.ACTIONS.LIGHT.fn = function(act)
    if act.invobject ~= nil and act.invobject.components.lighter ~= nil then
		if GLOBAL.TheWorld.state.season == "winter" then
			if act.invobject.components.fueled then
				act.invobject.components.fueled:DoDelta(-5, act.doer) --Hornet: Made it take fuel away because.... The snow and cold takes some of the fire? probably will change
			end
			act.target.components.burnable:StartWildfire()
			return true
		else
			return _OldLightAction(act)
		end
	end
end

local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
env.AddPrefabPostInit("cave", function(inst)
    if not TheWorld.ismastersim then
        return
    end
    
    inst:AddComponent("cavedeerclopsspawner")
	inst:AddComponent("hayfever_tracker")
end)

env.AddPrefabPostInit("forest", function(inst)
    if not TheWorld.ismastersim then
        return
    end
	inst:AddComponent("toadrain")
	inst:AddComponent("hayfever_tracker")
	inst:AddComponent("firefallwarning")
	
	inst:AddComponent("gmoosespawner")
	inst:AddComponent("mock_dragonflyspawner")
end)