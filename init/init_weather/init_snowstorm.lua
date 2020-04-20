local require = GLOBAL.require

local function GetSandstormLevel(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	if TheSim ~= nil then
		local ents = TheSim:FindEntities(x, y, z, 4, {"wall"})
		local suppressorNearby1 = (#ents > 2)
		
		local ents2 = TheSim:FindEntities(x, y, z, 6, {"fire"})
		local suppressorNearby2 = (#ents2 > 0)
		
		local ents3 = TheSim:FindEntities(x, y, z, 5.5, {"shelter"})
		local suppressorNearby3 = (#ents3 > 2)
		
		local ents4 = TheSim:FindEntities(x, y, z, 6, {"saltpack_protection"})
		local suppressorNearby4 = (#ents4 > 0)
	--[[else
	
		local ents = TheSim:FindEntities(x, y, z, 4, {"wall"})
		local suppressorNearby1 = 0
		
		local ents2 = TheSim:FindEntities(x, y, z, 6, {"fire"})
		local suppressorNearby2 = 0
		
		local ents3 = TheSim:FindEntities(x, y, z, 5.5, {"shelter"})
		local suppressorNearby3 = 0
	--]]
	
	end

	if GLOBAL.TheWorld.state.cycles > TUNING.DSTU.WEATHERHAZARD_START_DATE and GLOBAL.TheWorld.state.issnowing and not suppressorNearby1 and not suppressorNearby2 and not suppressorNearby3 and not suppressorNearby4 and GLOBAL.TheWorld:HasTag("snowstormstart") then
		return 1
	else
		return inst.player_classified ~= nil and inst.player_classified.sandstormlevel:value() / 7 or 0
	end
end

local function SetInstanceFunctions(inst)
        inst.GetSandstormLevel = GetSandstormLevel
end

AddPlayerPostInit(function(inst)

	if not GLOBAL.TheWorld.ismastersim then
        return inst
    end
		
	if GLOBAL.TheWorld.ismastersim then
		inst:AddComponent("snowstormwatcher")
	end
	
	SetInstanceFunctions(inst)
	
	--inst:AddComponent("firerain")
end)

AddClassPostConstruct("screens/playerhud",function(inst)
	local SnowOver = require("widgets/snowover")
	local fn =inst.CreateOverlays
	function inst:CreateOverlays(owner)
		fn(self, owner)
		self.snowover = self.overlayroot:AddChild(SnowOver(owner))
	end
	
end)
--[[
local function OnSpy(inst)
--print("on")
        inst._parent.HUD.snowover:SnowOn()
		inst._parent:PushEvent("snowon")
		
end

local function OffSpy(inst)
--print("off")
	if inst._parent ~= nil then
		ThePlayer.HUD.snowover:Show()
        inst._parent.HUD.snowover:SnowOn()
    end
end

AddPrefabPostInit("player_classified", function(inst)
	
	inst.snowoveron = GLOBAL.net_bool(inst.GUID, "snow.snowover", "snowdirty")
	inst:ListenForEvent("snowdirty", OnSpy)
end)--]]