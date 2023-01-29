local SkullChestInventory = Class(function(self, inst)
	self.inst = inst
	--print("skullchestcomponentadded")
	self.inst:DoTaskInTime(0,function() self:SpawnTrunk() end)
end)


function SkullChestInventory:OnSave()
	local data = {}	
	local refs = {}
	if self.trunk and self.trunk:IsValid() then
		data.trunk = self.trunk.GUID
		table.insert(refs,data.trunk)	
	end
	return data, refs
end

function SkullChestInventory:OnLoad(data)
	if data.trunk then
		self.cancelspawn = true
	end
end

function SkullChestInventory:LoadPostPass(ents, data)
	if data.trunk and ents[data.trunk] then
		self.trunk = ents[data.trunk].entity
	end
end

function SkullChestInventory:LongUpdate(dt)

end

function SkullChestInventory:OnUpdate( dt )

end

function SkullChestInventory:empty(target)
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

function SkullChestInventory:fill( source )
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

function SkullChestInventory:SpawnTrunk()
	if not self.trunk then
		--print("SPAWN TRUNK!!!!!!!!!!!!!!!!!!!!!!!!")
		self.trunk = SpawnPrefab("skullchest")
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

return SkullChestInventory
