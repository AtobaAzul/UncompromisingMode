local require = GLOBAL.require

AddPlayerPostInit(function(inst)

	if not GLOBAL.TheWorld.ismastersim then
        return inst
    end
	
	local _OldOnSave = inst.OnSave
	local _OldOnLoad = inst.OnLoad

	local function OnSave(inst, data)
		if inst.vetcurse ~= nil then
			data.vetscurse = inst.vetcurse
		end
		
		return _OldOnSave(inst, data, ...)
	end

	local function OnLoad(inst, data)
		if data ~= nil then
		
			if data.vetscurse then
				inst:ListenForEvent("respawnfromghost", function()
					inst:DoTaskInTime(3, function(inst) 
						
						inst.components.debuffable:AddDebuff("buff_vetcurse", "buff_vetcurse")
					end)
				end, inst)
				
				inst:ListenForEvent("ms_playerseamlessswaped", function()
					inst:DoTaskInTime(3, function(inst) 
						
						inst.components.debuffable:AddDebuff("buff_vetcurse", "buff_vetcurse")
					end)
				end, inst)
			end
		end
	
		return _OldOnLoad(inst, data, ...)
	end
	
	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
end)