local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------


env.AddPrefabPostInit("bundle", function(inst)
	if not TheWorld.ismastersim then
		return
	end

	--inst:AddComponent("savedage")
	
	local _OnUnwrapped = inst.components.unwrappable.onunwrappedfn

	--[[local function OnUnwrapped(inst)
		inst.components.savedage:GetAge()
	end]]
	
    inst.components.unwrappable.onunwrappedfn = function(inst, pos, doer)
		if inst.burnt then
			SpawnPrefab("ash").Transform:SetPosition(pos:Get())
		else
			--print("bubba")
			local loottable = (setupdata ~= nil and setupdata.lootfn ~= nil) and setupdata.lootfn(inst, doer) or loot
			if loottable ~= nil then
						--print("chumba")
				local moisture = inst.components.inventoryitem:GetMoisture()
				local iswet = inst.components.inventoryitem:IsWet()
				for i, v in ipairs(loottable) do
					local item = SpawnPrefab(v)
					if item ~= nil then
						if item.Physics ~= nil then
							item.Physics:Teleport(pos:Get())
						else
							item.Transform:SetPosition(pos:Get())
						end
						
						if item.components.inventoryitem ~= nil then
							item.components.inventoryitem:InheritMoisture(moisture, iswet)
							if tossloot then
								item.components.inventoryitem:OnDropped(true, .5)
							end
						end
						
						if item.components.perishable ~= nil then
						--print("chumba")
							item.components.perishable:ReducePercent(1)
						end
					end
				end
			end
			if doer ~= nil and doer.SoundEmitter ~= nil then
				doer.SoundEmitter:PlaySound("dontstarve/common/together/packaged")
			end
			inst:Remove()
		end
		
		if _OnUnwrapped ~= nil then
			_OnUnwrapped(inst, pos, doer)
		end
	end
end)
