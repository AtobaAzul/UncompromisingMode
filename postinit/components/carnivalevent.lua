local env = env
local UpvalueHacker = GLOBAL.require("tools/upvaluehacker")
GLOBAL.setfenv(1, GLOBAL)

------------------------Fire spread is less efficient in winter-----------------------------------------
env.AddComponentPostInit("carnivalevent", function(self)

	local _OldSpawnCarnivalHost = self.SpawnCarnivalHost

	--[[local _OldOnSave = self.OnSave
	local _OldOnLoad = self.OnLoad
	function self:OnSave()
		local data =
		{
		corvusisdead = self.corvusisdead
		}

		local ents = {}
		if _carnival_host ~= nil then
			data.carnival_host = _carnival_host.GUID
			table.insert(ents, _carnival_host.GUID)
		end

		return data, ents
	end

	function self:OnLoad(data)
		if data ~= nil then
			self.corvusisdead = data.corvusisdead
		end
	
		_OldOnLoad(data)
	end]]

	local SpawnCarnivalHost

	seld:SpawnCarnivalHost(carnival_host, loading)
		--if self.corvusisdead then
			--return
		--end
		
		print("spawn")
		
		_OldSpawnCarnivalHost(carnival_host, loading)
	end
end)