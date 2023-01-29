local WinkyBurrowInventory = Class(function(self, inst)
	self.inst = inst
	--print("skullchestcomponentadded")
	self.inst:DoTaskInTime(0,function() self:SpawnTrunk() end)
end)


function WinkyBurrowInventory:OnSave()
	local data = {}	
	local refs = {}
	if self.trunk and self.trunk:IsValid() then
		data.trunk = self.trunk.GUID
		table.insert(refs,data.trunk)	
	end
	return data, refs
end

function WinkyBurrowInventory:OnLoad(data)
	if data.trunk then
		self.cancelspawn = true
	end
end

function WinkyBurrowInventory:LoadPostPass(ents, data)
	if data.trunk and ents[data.trunk] then
		self.trunk = ents[data.trunk].entity
	end
end

function WinkyBurrowInventory:LongUpdate(dt)

end

function WinkyBurrowInventory:OnUpdate( dt )

end

function WinkyBurrowInventory:empty( target )
	local t_cont = target.components.container
	local cont = self.trunk.components.container
	if t_cont and cont then		
		for i,slot in pairs(cont.slots) do
			local item = cont:RemoveItemBySlot(i)
			--print(item.prefab)
			t_cont:GiveItem(item, i, nil, nil, true)
		end
	end	
end

function WinkyBurrowInventory:fill( source )
	local s_cont = source.components.container
	local cont = self.trunk.components.container
	if s_cont and cont then		
		for i,slot in pairs(s_cont.slots) do
			local item = s_cont:RemoveItemBySlot(i)
			--print(item.prefab)
			cont:GiveItem(item, i, nil, nil, true)
		end
	end	
end

function WinkyBurrowInventory:SpawnTrunk()
	if not self.trunk then
		--print("SPAWN TRUNK!!!!!!!!!!!!!!!!!!!!!!!!")
		self.trunk = SpawnPrefab("uncompromising_winkyburrow_master")
	end
	
    self.trunk.entity:AddTag("NOBLOCK")

    if self.trunk.Physics then
        self.trunk.Physics:SetActive(false)
    end
    if self.trunk.Light and self.trunk.Light:GetDisableOnSceneRemoval() then
        self.trunk.Light:Enable(false)
    end
    if self.trunk.AnimState then
        self.trunk.AnimState:Pause()
    end
    if self.trunk.DynamicShadow then
        self.trunk.DynamicShadow:Enable(false)
    end
    if self.trunk.MiniMapEntity then
        self.trunk.MiniMapEntity:SetEnabled(false)
    end
end

return WinkyBurrowInventory
