local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

local function UpgradeNil(inst)
	inst.components.upgradeable.upgradetype = nil
end

local function attach_turbine(inst)
	inst._turbine = SpawnPrefab("mastupgrade_windturbine")
	inst._turbine._mast = inst
	--inst.highlightchildren = { inst._turbine }

	inst._turbine.entity:SetParent(inst.entity)
	inst._turbine.entity:AddFollower():FollowSymbol(inst.GUID, "mastupgrade_lamp", 0, 0, 0)
			
    inst.SoundEmitter:PlaySound("dontstarve/common/fireAddFuel")
end

local function upgrade_windturbine(inst, no_built_callback)
    attach_turbine(inst)
	inst:DoTaskInTime(0, UpgradeNil)
    --inst.components.upgradeable.upgradetype = nil
	
    if not no_built_callback then
        inst._turbine:PushEvent("onbuilt")
    end
end

local masts = {
	"mast",
	"mast_malbatross",
}

for i, v in pairs(masts) do
	env.AddPrefabPostInit(v, function(inst)

		if not TheWorld.ismastersim then
			return
		end
		
		if inst.components.upgradeable ~= nil then
			local _UmOldUpgrade = inst.components.upgradeable.onupgradefn
			inst.components.upgradeable.onupgradefn = function(inst, performer, upgraded_from_item)
				local numupgrades = inst.components.upgradeable.numupgrades
				if numupgrades == 1337 then
					upgrade_windturbine(inst)
				else
					_UmOldUpgrade(inst, performer, upgraded_from_item)
				end
			end
		end
		
		local _OnSave = inst.OnSave
		
		inst.OnSave = function(inst, data)
			if inst._turbine ~= nil then
				data.turbine = true
			end
			
			if _OnSave ~= nil then
				return _OnSave(inst, data)
			end
		end
		
		local _OnLoad = inst.OnLoad
		
		inst.OnLoad = function(inst, data)
			if data ~= nil and data.turbine then
				upgrade_windturbine(inst)
			end
			
			if _OnLoad ~= nil then
				return _OnLoad(inst, data)
			end
		end
	end)
end