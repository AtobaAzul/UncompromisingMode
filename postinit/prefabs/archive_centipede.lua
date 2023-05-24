local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
SetSharedLootTable( 'um_archive_centipede',
{
    {'moonstorm_spark',    1},
})

env.AddPrefabPostInit("archive_centipede", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	if inst.components.lootdropper ~= nil then
		inst.components.lootdropper:SetChanceLootTable('um_archive_centipede')
	end
end)


local function AssignCharge(inst)
	if not inst.charge then
		if math.random() > 0.5 then
			inst.charge = 1
		else
			inst.charge = 2
		end
	end
end

env.AddPrefabPostInit("archive_moon_statue", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	inst:DoTaskInTime(0,AssignCharge)
	local _OldFinish = inst.components.workable.onfinish
	
	local function OnFinish(inst)
		if inst.charge and inst.charge == 1 then
			SpawnPrefab("archive_security_pulse").Transform:SetPosition(inst.Transform:GetWorldPosition())
		end
		
		_OldFinish(inst)
	end
	
	inst.components.workable:SetOnFinishCallback(OnFinish)
	
	if inst.OnSave then
		local _OnSave = inst.OnSave
		inst.OnSave = function(inst,data)
			data.charge = inst.charge
			
			return _OnSave(inst,data)
		end
	else
		inst.OnSave = function(inst,data)
			data.charge = inst.charge
		end
	end
	
	if inst.OnLoad then
		local _OnLoad = inst.OnLoad
		inst.OnLoad = function(inst,data)
			if data and data.charge then
				inst.charge = data.charge
				inst.charge = data.charge
			end
			
			return _OnLoad(inst,data)
		end
	else
		inst.OnLoad = function(inst,data)
			if data and data.charge then
				inst.charge = data.charge
			end
		end
	end
	
	local function Shocking(inst)
		if inst.charge and inst.charge == 1 then
			local fx = SpawnPrefab("electricchargedfx")
			fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
			inst.shocking = inst:DoTaskInTime(math.random(3,10),Shocking)
		end
	end
	
	inst:ListenForEvent("entitywake", function(inst)
		inst.shocking = inst:DoTaskInTime(math.random(3,10),Shocking) 
	end)
	
	inst:ListenForEvent("entitysleep", function(inst)
		if inst.shocking then
			inst.shocking:Cancel()
			inst.shocking = nil
		end
	end)
end)