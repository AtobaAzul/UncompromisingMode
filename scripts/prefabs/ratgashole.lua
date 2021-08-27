local assets =
{
	Asset("ANIM", "anim/ratgas_hole.zip"),
}

local function fartover(inst)
	-- print('fartover')
	--if not inst.SoundEmitter:PlayingSound("poisonswamp_lp") then
	--	inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/poisonswamp_lp", "poisonswamp_lp")
	--end
	
	inst.AnimState:PlayAnimation("boil_start", false)
	inst.AnimState:PushAnimation("boil_loop", true)
	inst.farting = false
end

local function HasFilter(victim)
	if victim:HasTag("hasplaguemask") or victim:HasTag("has_gasmask") then
		return true
	end
end

local function DoBadThings(victim)
	if not HasFilter(victim) then
		victim.components.health:DoDelta(-100)
		victim.components.health:DeltaPenalty(0.5)
	else
		victim.components.health:DoDelta(-20) --TODO: Make the concentrated gas also damage the gas mask itself
		victim.components.health:DeltaPenalty(0.15)		
	end
end

local function fart(inst)
	if not inst.farting then
		inst.farting = true

		
		inst.AnimState:PlayAnimation("pop_pre", false)
		inst.AnimState:PushAnimation("pop", false)
		
		inst:DoTaskInTime(15*FRAMES, function (inst)
			--inst.SoundEmitter:KillSound("poisonswamp_lp")
		end)

		inst:DoTaskInTime(20*FRAMES, function()
			--inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/poisonswamp_attack")
		local x,y,z = inst.Transform:GetWorldPosition()
		local victims = TheSim:FindEntities(x,y,z,3,{"player"},{"playerghost"})
		if victims ~= nil then
			for i,victim in ipairs(victims) do
				if victim and victim:IsValid() then 
					DoBadThings(victim)
				end
			end
		end
		end)


		inst:ListenForEvent("animqueueover", fartover)
	end
end

local function steam(inst)
	-- local prefab = SpawnPrefab("poisonbubble_short")
	-- prefab.Transform:SetPosition(inst:GetPosition():Get())
	if not inst.farting then
		inst.farting = true
		inst.AnimState:PlayAnimation("pop_pre", false)
		inst.AnimState:PushAnimation("pop", false)
	end
end

local function OnWake(inst)
	if inst.steamtask then
		inst.steamtask:Cancel()
		inst.steamtask = nil
	end

	--inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/poisonswamp_lp", "poisonswamp_lp")

	inst.steamtask = inst:DoPeriodicTask(3+(math.random()*2), fart)
end

local function OnSleep(inst)
	if inst.steamtask then
		inst.steamtask:Cancel()
		inst.steamtask = nil
	end

	--inst.SoundEmitter:KillSound("poisonswamp_lp")

end

local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	anim:SetBank("ratgas_hole")
	anim:SetBuild("ratgas_hole")
	anim:PlayAnimation("boil_loop", true)
	anim:SetLayer( LAYER_BACKGROUND )
	anim:SetSortOrder( 3 )
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.steamtask = inst:DoPeriodicTask(3+(math.random()*2), fart)

	inst.OnEntityWake = OnWake
	inst.OnEntitySleep = OnSleep
	
	inst:AddComponent("inspectable")

	
	return inst
end

return Prefab("ratgashole", fn, assets) 
