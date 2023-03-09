local require = GLOBAL.require

AddClassPostConstruct( "widgets/controls", function(self, inst)
	local owner = self.owner
	if owner == nil then return end
	local ClaustrophobiaOver = require "widgets/claustrophobiaover"
	self.claustrophobiaover = self:AddChild( ClaustrophobiaOver(owner) )
	self.claustrophobiaover:MoveToBack()
	self.inst:ListenForEvent("updateclaustrophobia", function(inst, data) return self.claustrophobiaover:UpdateState(data.claustrophobia) end, self.owner)
end)

local KnownModIndex = GLOBAL.KnownModIndex

local function GetModName(modname) -- modinfo's modname and internal modname is different.
	for _, knownmodname in ipairs(KnownModIndex:GetModsToLoad()) do
		if KnownModIndex:GetModInfo(knownmodname).name == modname then
			return knownmodname
		end
	end
end

AddClassPostConstruct( "widgets/statusdisplays", function(self, owner)
	if owner:HasTag("pinetreepioneer") then
		local WobyHungerDisplay = require "widgets/WobyHungerDisplay"
		self.WobyHungerDisplay = self:AddChild(WobyHungerDisplay(owner, config))
		--self.WobyHungerDisplay:SetPosition(-82.5, -42.5, 0)
		
		self.combinedmod = GetModName("Combined Status")
		if self.combinedmod ~= nil then
			local pos = self.stomach:GetPosition()
			
			self.WobyHungerDisplay:SetPosition(pos.x - 70, pos.z, 0)
		else
			self.WobyHungerDisplay:SetPosition(-40, -100, 0)
			self.moisturemeter:SetPosition(40, -100, 0)
		end
		
		self.WobyHungerDisplay:MoveToBack()
		
		self.owner:DoTaskInTime(0.1, function(owner)
			owner.player_classified:ListenForEvent("WobyHungerDirty", function(inst)
				self.WobyHungerDisplay:UpdateHunger(inst.WobyHunger:value())
			end)
		end)
	end
end)

AddPrefabPostInit("player_classified", function(inst)
		inst.WobyHunger = GLOBAL.net_ushortint(inst.GUID, "WobyHunger", "WobyHungerDirty")
		
		if GLOBAL.TheWorld.ismastersim then
			inst.OnWobyHungerDelta = function(woby, data)
				inst.WobyHunger:set(woby.replica.hunger:GetCurrent())
			end

			inst.CheckForWalterTask = inst:DoPeriodicTask(1, function()
				local parent = inst.entity:GetParent()
				if parent ~= nil and parent:HasTag("pinetreepioneer") and parent.woby ~= nil then
					parent:ListenForEvent("hungerdelta", parent.player_classified.OnWobyHungerDelta, parent.woby)
				else
					if inst.CheckForWalterTask ~= nil then
						inst.CheckForWalterTask:Cancel()
					end
					
					inst.CheckForWalterTask = nil
				end
			end)
		end
end)