local taunts_spawnedwrong = {
	"Wow, rude.",
	"Oh, two can play at that game.",
	"Aww, baby's first magic spell! Die.",
	"Why do people in this realm keep teleporting me around??",
	"You know what? Get uncompromised.",
	"Oh great, another one.",
	"Uncompromising this, uncompromising that, how about I uncompromise the carbon from your body?"
}

local function getrandomposition(inst)
	local centers = {}
	for i, node in ipairs(TheWorld.topology.nodes) do 
		if TheWorld.Map:IsPassableAtPoint(node.x, 0, node.y) and node.type ~= NODE_TYPE.SeparatedRoom then
			table.insert(centers, { x = node.x, z = node.y })
		end
	end
	if #centers > 0 then
		local pos = centers[math.random(#centers)]
		return Point(pos.x, 0, pos.z)
	else
		return Point(0, 0, 0)
	end
end

local function teleport_end(teleportee, locpos)	
	if teleportee.components.inventory ~= nil and teleportee.components.inventory:IsHeavyLifting() then teleportee.components.inventory:DropItem(teleportee.components.inventory:Unequip(EQUIPSLOTS.BODY), true, true) end
	
	teleportee.sg.statemem.teleport_task = nil
	teleportee.sg:GoToState(teleportee:HasTag("playerghost") and "appear" or "wakeup")
	teleportee.SoundEmitter:PlaySound("dontstarve/common/staffteleport")
end

local function SpawnedWrong(inst)
	-- Complain about being summoned out of nowhere. Rude af tbh.
	inst.AnimState:PlayAnimation("speak_loop", true)
	TheNet:Announce("  " .. taunts_spawnedwrong[math.random(1, #taunts_spawnedwrong)])
	
	inst:DoTaskInTime(3, function() inst.AnimState:PlayAnimation("spell_loop", true) end)
	
	inst.SoundEmitter:PlaySound("stmpwyfs/stmpwyfs/WITCH_warningshot", "WITCH_warningshot")
	inst.SoundEmitter:SetVolume("WITCH_warningshot", 0.05)
	
	inst:DoTaskInTime(5, function()
		local x, y, z = inst.Transform:GetWorldPosition()
		local ents = TheSim:FindEntities(x, y, z, 50, { "player" },
			{ "FX", "NOCLICK", "INLIMBO", "invisible", "notarget", "noattack", "playerghost" })
		if #ents > 0 then
			for i, teleportee in pairs(ents) do
				local locpos = getrandomposition()
				
				TheWorld:PushEvent("ms_sendlightningstrike", teleportee:GetPosition())
				
				if teleportee.Physics ~= nil then
					teleportee.Physics:Teleport(locpos.x, 0, locpos.z)
				else
					teleportee.Transform:SetPosition(locpos.x, 0, locpos.z)
				end
				
				teleportee:SnapCamera()
				teleportee:ScreenFade(true, 1)
				teleportee.sg.statemem.teleport_task = teleportee:DoTaskInTime(1, teleport_end, locpos)
				
				-- After a moment of rest, hit them and smash max health.
				teleportee:DoTaskInTime(5, function()
					if teleportee ~= nil and teleportee.components.health ~= nil and not teleportee:HasTag("playerghost") then
						teleportee.components.health:DeltaPenalty(100)
						teleportee.components.health:DoDelta(-10, nil, inst, nil, inst)
					end
					
					if teleportee.sg ~= nil and not teleportee.sg:HasStateTag("nointerrupt") and not teleportee:HasTag("playerghost") and teleportee.components.health ~= nil and not teleportee.components.health:IsDead() then
						teleportee.sg:GoToState("electrocute")
					end
					
					teleportee:DoTaskInTime(FRAMES*1, function() TheWorld:PushEvent("ms_sendlightningstrike", teleportee:GetPosition()) end)
				end)
			end
		end
		inst:DoTaskInTime(FRAMES*1, function() inst:Remove() end)
	end)
end

local function fn()
	local inst = CreateEntity()
	
	-- Core components
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddLight()
	inst.entity:AddNetwork()
	
	MakeCharacterPhysics(inst, 25, .5)
	RemovePhysicsColliders(inst)
	inst:AddTag("NOBLOCK")
	
	inst.AnimState:SetBank("um_WITCH")
	inst.AnimState:SetBuild("um_WITCH")
	inst.AnimState:PlayAnimation("idle_loop", true)
	inst.Transform:SetScale(6.5, 6.5, 6.5)
	
	inst:AddTag("scarytoprey")
	
	inst.Light:Enable(true)
	inst.Light:SetRadius(4)
	inst.Light:SetFalloff(0.75)
	inst.Light:SetIntensity(0.3)
	inst.Light:SetColour(0.5, 0.3, 0)
	
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(96000)
	inst.components.health:SetInvincible(true)
	
	inst:DoTaskInTime(1, SpawnedWrong) -- Note: cannot be spawned correctly. Stay tuned for the season 2 battle pass!
	
	return inst
end

return Prefab("um_witch", fn)
