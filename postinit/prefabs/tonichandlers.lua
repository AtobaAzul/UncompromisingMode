local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddPrefabPostInit("player_common", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
if inst.components.trader ~= nil then
	_OnGetItem =inst.components.trader.onaccept

	local function NewOnGetItem(inst, giver, item)
		if item:HasTag("stantondrink") and not giver:HasTag("stanton") then
				local stanton = FindEntity(inst,10,nil,{"stanton"})
				if stanton ~= nil then
					stanton.TellThemRules(stanton)
				end	
			item:Remove()
		else
			_OnGetItem(inst,giver,item)
		end
	end
end

end)
--Prevent players from giving others the tonic.