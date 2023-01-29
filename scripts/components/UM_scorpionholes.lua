return Class(function(self, inst)

assert(TheWorld.ismastersim, "UM_scorpionholes should not exist on client")

self.inst = inst
inst.UM_selfref = self
self.homesites = {}

self.village_generated = nil


local function OnSeasonTick(src, data)
	if TheWorld.state.issummer then
		
	end
end

self.inst:ListenForEvent("seasontick", OnSeasonTick, TheWorld)
--[[self.inst:DoPeriodicTask(3,function(inst) 
		for i,v in ipairs(inst.UM_selfref.homesites) do
			TheNet:Announce(i)
		end
	end)]]
end)