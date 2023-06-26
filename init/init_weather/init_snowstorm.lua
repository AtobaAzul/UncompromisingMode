local require = GLOBAL.require

local function GetSandstormLevel(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	if TheSim ~= nil then
		local ents = TheSim:FindEntities(x, y, z, 4, { "wall" })
		local suppressorNearby1 = (#ents > 2)

		local ents2 = TheSim:FindEntities(x, y, z, 6, { "fire" })
		local suppressorNearby2 = (#ents2 > 0)

		local ents3 = TheSim:FindEntities(x, y, z, 5.5, { "shelter" })
		local suppressorNearby3 = (#ents3 > 2)

		local ents4 = TheSim:FindEntities(x, y, z, 6, { "snowstorm_protection_high" })
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

	if GLOBAL.TheWorld.state.iswinter and not suppressorNearby1 and not suppressorNearby2 and not suppressorNearby3 and not suppressorNearby4 and (GLOBAL.TheWorld:HasTag("snowstormstart") or (GLOBAL.TheWorld.net ~= nil and GLOBAL.TheWorld.net:HasTag("snowstormstartnet"))) then
		return 1
	else
		return inst.player_classified ~= nil and inst.player_classified.stormlevel:value() / 7 or 0
	end
end

local function SetInstanceFunctions2(inst)
	inst.GetSandstormLevel = GetSandstormLevel
end

AddPlayerPostInit(function(inst)
	if not GLOBAL.TheWorld.ismastersim then
		return inst
	end

	if GLOBAL.TheWorld.ismastersim then
		inst:AddComponent("snowstormwatcher")
	end

	SetInstanceFunctions2(inst)
end)

AddClassPostConstruct("screens/playerhud", function(inst)
	local SnowOver = require("widgets/snowover")
	local Um_StormOver = require("widgets/um_stormover")
	local HeatwaveOver = require("widgets/heatwaveover")

	local fn = inst.CreateOverlays

	function inst:CreateOverlays(owner)
		fn(self, owner)
		self.um_stormover = self.overlayroot:AddChild(Um_StormOver(owner))
		self.snowover = self.overlayroot:AddChild(SnowOver(owner))
		self.um_heatwaveover = self.overlayroot:AddChild(HeatwaveOver(owner))
	end
end)
