local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------\

local function OnIsSpring(inst, isspring)
    if isspring then
        inst.AnimState:SetBuild("mosquito_yellow_build")
    else
        inst.AnimState:SetBuild("mosquito")
    end
end

env.AddPrefabPostInit("mosquito", function (inst)
    if not TheWorld.ismastersim then
		return
	end
	
	inst:WatchWorldState("isspring", OnIsSpring)
    if TheWorld.state.isspring then
        OnIsSpring(inst, true)
    end

end)