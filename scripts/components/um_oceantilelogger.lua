return Class(function(self, inst)
    self.inst = inst
	assert(TheWorld.ismastersim, "um_oceantilelogger should not exist on client")
	--Tiles Occur Every 4 spaces

	local function AnalyzeWorld(tiletype) --207 For Hazardous
		local tiletable = {}
		tiletable[1] = {}
		tiletable[2] = {}
		local i = 1
		for x = -822,822,4 do--Instead relate to world size if accessible
			for z = -822,822,4 do
				TheNet:Announce(TheWorld.Map:GetTileAtPoint(x, 0, z))
				if TheWorld.Map:GetTileAtPoint(x, 0, z) == tiletype then
					tiletable[1][i] = x
					tiletable[2][i] = z
					i = i + 1
				end
			end
		end
		print("finished logging hazardous")
		print("Here's the first entry")
		print("x = ")
		print(tiletable[1][1])
		print("z = ")
		print(tiletable[2][1])
		print("The total hazardous")
		print(#tiletable[1])

		return tiletable
		
	end
	
	local function FindAllTileTypes(self)
		self.Hazardous = AnalyzeWorld(207)
	end
	function self:OnSave()
		local data = {}
		data.Hazardous = self.Hazardous
	end
	
	function self:OnLoad(data)
		if data then
			if data.Hazardous then
				self.Hazardous = data.Hazardous
			else
				self.Hazardous = AnalyzeWorld(207)
			end
		end
	end
	function self:OnPostInit()
		if not self.Hazardous then
			self.Hazardous = AnalyzeWorld(207)
		end
	end
end)