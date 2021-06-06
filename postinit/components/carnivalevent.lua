local env = env
local UpvalueHacker = GLOBAL.require("tools/upvaluehacker")
GLOBAL.setfenv(1, GLOBAL)

------------------------Fire spread is less efficient in winter-----------------------------------------
env.AddComponentPostInit("carnivalevent", function(self)

	local _OldOnSave = self.OnSave
	local _OldOnLoad = self.OnLoad
	local _OldSpawnCarnivalHost = self.SpawnCarnivalHost

	function self:OnSave(data)
		data.corvusisdead = self.corvusisdead
		
		_OldOnSave()
	end

	function self:OnLoad(data)
		if data ~= nil then
			self.corvusisdead = data.corvusisdead
		end
	
		_OldOnLoad(data)
	end

	local SpawnCarnivalHost

	SpawnCarnivalHost = function(carnival_host, loading)
		--if self.corvusisdead then
			return
		--end
		
		_OldSpawnCarnivalHost(carnival_host, loading)
	end
end)