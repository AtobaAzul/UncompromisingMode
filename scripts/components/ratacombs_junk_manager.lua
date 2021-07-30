return Class(function(self, inst)
self.inst = inst

function self:UnLockFirstArea()
if self.areaoneblockers ~= nil then
	for i, v in ipairs(self.areaoneblockers) do
		v.dotransition(v)
	end
end
end

function self:MakeSpawnersSpawn()
	for i, v in ipairs(self.spawnerlist) do
		v.SpawnMoreJunk(v)
	end
end

function self:OnSave()
local data = {}
data.spawnerlist = inst.spawnerlist
end

function self:OnLoad(data)
	if data ~= nil then
		if data.spawnerlist ~= nil then
			self.spawnerlist = data.spawnerlist
		else
			self.spawnerlist = {}
		end
	else
		self.spawnerlist = {}
	end
end
end)