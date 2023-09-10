return Class(function(self, inst)
    self.inst = inst
	assert(TheWorld.ismastersim, "um_ocupusappearinator should not exist on client")

	local function FindDahSquids()
		local tag = "um_ocupus_core"
		local entswithOCU = {}
		for k,v in pairs(Ents) do
			if v:HasTag(tag) then
				table.insert(entswithOCU, v)
			end
		end
		return #entswithOCU
	end
	
	local function NoOtherOct(Hazardous,val)
		if #TheSim:FindEntities(Hazardous[1][val],0,Hazardous[2][val],40,{"um_ocupus_core"}) == 0 then
			return true
		end
	end
	
	local function IterateThroughTiles(Hazardous)
		for i = 1,#Hazardous[1] do
			local val = math.floor(#Hazardous[1]*math.random() + 1)
			if NoOtherOct(Hazardous,val) then
				local locationfornewoct = {}
				locationfornewoct.x = Hazardous[1][val]
				locationfornewoct.z = Hazardous[2][val]
				return locationfornewoct
			else
				table.remove(Hazardous[1],val)
				table.remove(Hazardous[2],val)
				IterateThroughTiles(Hazardous)
			end
		end
	end
	
	local function FindLocationForNewOct()
		if TheWorld.components.um_oceantilelogger and TheWorld.components.um_oceantilelogger.Hazardous then		
			return IterateThroughTiles(TheWorld.components.um_oceantilelogger.Hazardous)
		end
	end
	
	local function DoDahOcupii()
		local locationfornewoct = FindLocationForNewOct()
		if locationfornewoct then --If you maxwelled the whole ocean I swear
			SpawnPrefab("um_ocupus").Transform:SetPosition(locationfornewoct.x,0,locationfornewoct.z)
		end
	end

	local function OnSeasonTick(src, data)
		local Ocupiiiiiiiiii = FindDahSquids()
		if Ocupiiiiiiiiii and Ocupiiiiiiiiii < 1 then
			DoDahOcupii()
			DoDahOcupii()
		elseif Ocupiiiiiiiiii < 3 then
			DoDahOcupii()
		elseif Ocupiiiiiiiiii < 4 and math.random() > 0.5 then
			DoDahOcupii()
		elseif Ocupiiiiiiiiii < 6 and math.random() > 0.75 then
			DoDahOcupii()
		elseif math.random() > 0.9 then
			DoDahOcupii()
		end
		
	end
	
	function self:FirstRun()
		DoDahOcupii()
		DoDahOcupii()
		DoDahOcupii()
	end
	function self:OnSave()
		local data = {}
		data.firstrun = self.firstrun
	end
	
	function self:OnLoad(data)
		if data then
			if data.firstrun then
				self.firstrun = data.firstrun
			end
		end
	end
	function self:OnPostInit()
		if not self.firstrun then
			TheNet:Announce("didfirstrun")
			self.firstrun = true
			self.inst:DoTaskInTime(0, function(inst) inst.components.um_ocupusappearinator:FirstRun() end)
		end
	end
	self.inst:ListenForEvent("seasontick", OnSeasonTick, TheWorld)
end)