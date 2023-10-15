local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

env.AddPrefabPostInit("raindrop", function(inst)

    inst.entity:AddSoundEmitter()
	
	if not TheWorld.ismastersim then
		return
	end

	local mushroomcheck = nil--TheSim:FindFirstEntityWithTag("acidrain_mushroom")
	
	if mushroomcheck ~= nil and TheWorld.state.isautumn then
		--inst.AnimState:SetMultColour(0.5, 1, 0, 1)
		inst:ListenForEvent("onremove", function(inst) 
			if math.random() >= 0.9 then 
				SpawnPrefab("acid_rain_splash").Transform:SetPosition(inst.Transform:GetWorldPosition()) 
			end 
		end)
	end

end)