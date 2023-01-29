local events =
{

}

local states =
{
    State{
        name = "place",
        onenter = function(inst)
            inst.SoundEmitter:PlaySound(inst.sounds.place)
            inst.SoundEmitter:PlaySound("turnoftides/common/together/water/splash/large",nil,.3)
            inst.AnimState:PlayAnimation("place")
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State{
        name = "idle",
        onenter = function(inst)
            inst.AnimState:PlayAnimation("idle_full", true)
        end,

        events =
        {
            EventHandler("death", function(inst) inst.sg:GoToState("ready_to_snap") end),
        },
    },

    State{
        name = "ready_to_snap",
        onenter = function(inst)
            local ents = inst.components.walkableplatform:GetEntitiesOnPlatform()
            for ent in pairs(ents) do    
                ent:PushEvent("abandon_ship")
            end

            inst.sg:SetTimeout(0.75)
        end,

        ontimeout = function(inst)
            inst.sg:GoToState("snapping")
        end,
    },


    State{
        name = "snapping",
        onenter = function(inst)
			local fx_boat_crackle = SpawnPrefab("boat_leak")
			fx_boat_crackle.Transform:SetPosition(inst.Transform:GetWorldPosition())
			fx_boat_crackle.entity:SetParent(inst.entity)
            inst.AnimState:PlayAnimation("deflate")
            inst.sg:SetTimeout(3)

            for k in pairs(inst.components.walkableplatform:GetPlayersOnPlatform()) do
                k:PushEvent("onpresink_portable")
            end
        end,
		
        ontimeout = function(inst)
            inst.sg:GoToState("popping")
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("popping") end),
        },

        timeline =
        {
            TimeEvent(0 * FRAMES, function(inst)
                if inst.sounds.creak then inst.SoundEmitter:PlaySoundWithParams(inst.sounds.creak) end
            end),
            TimeEvent(2 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySoundWithParams(inst.sounds.damage,{intensity= .1})
            end),
            TimeEvent(17 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySoundWithParams(inst.sounds.damage,{intensity= .2})
            end),
            TimeEvent(32* FRAMES, function(inst)
                inst.SoundEmitter:PlaySoundWithParams(inst.sounds.damage,{intensity= .3})
            end),
            TimeEvent(39* FRAMES, function(inst)
                inst.SoundEmitter:PlaySoundWithParams(inst.sounds.damage,{intensity= .3})
            end),
            TimeEvent(39* FRAMES, function(inst)
                if inst.sounds.creak then inst.SoundEmitter:PlaySoundWithParams(inst.sounds.creak) end
            end),
            TimeEvent(51 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySoundWithParams(inst.sounds.damage,{intensity= .4})
            end),
            TimeEvent(58 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySoundWithParams(inst.sounds.damage,{intensity= .4})
            end),
            TimeEvent(60 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySoundWithParams(inst.sounds.damage,{intensity= .5})
            end),
            TimeEvent(71 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySoundWithParams(inst.sounds.damage,{intensity= .5})
            end),
            TimeEvent(75 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySoundWithParams(inst.sounds.damage, {intensity= .6})
            end),
            TimeEvent(82 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySoundWithParams(inst.sounds.damage, {intensity= .6})
            end),
        },
    },

    State{
        name = "popping",
        onenter = function(inst)
			inst.AnimState:PlayAnimation("retract")
			inst.SoundEmitter:PlaySound("wes/characters/wes/blow_idle")
			inst.SoundEmitter:PlaySound("wes/characters/wes/deflate_speedballoon")
			
			if inst.components.hull.boat_lip ~= nil then
				inst.components.hull.boat_lip:Remove()
			end
			
			if inst.components.hull.plank ~= nil then
				inst.components.hull.plank:Remove()
			end

			inst.persists = false
        end,
		
		events =
        {
            EventHandler("animover", function(inst)
				
				local fx_boat_crackle = SpawnPrefab("fx_boat_pop")
				fx_boat_crackle.Transform:SetPosition(inst.Transform:GetWorldPosition())
			
				if inst.boatreciever ~= nil then
					local boatspawn = SpawnPrefab("portableboat_item")
					LaunchAt(boatspawn, inst, inst.boatreciever, 5, 1, .5)
					
					if inst.rechargerate ~= nil then
						print("charge time")
						local rechargerate = 116 - (100 * inst.rechargerate)
						boatspawn.components.rechargeable:Discharge(rechargerate)
						boatspawn.components.deployable.restrictedtag = "literallynoone"
						boatspawn.SoundEmitter:PlaySound("dontstarve/common/balloon_pop")
					else
						boatspawn.components.rechargeable:Discharge(115)
						boatspawn.components.deployable.restrictedtag = "literallynoone"
						boatspawn.SoundEmitter:PlaySound("dontstarve/common/balloon_pop")
					end
				else
					local boatspawn = SpawnPrefab("portableboat_item")
					boatspawn.Transform:SetPosition(inst.Transform:GetWorldPosition())
					
					if inst.rechargerate ~= nil then
						print("charge time")
						local rechargerate = 116 - (100 * inst.rechargerate)
						boatspawn.components.rechargeable:Discharge(rechargerate)
						boatspawn.components.deployable.restrictedtag = "literallynoone"
						boatspawn.SoundEmitter:PlaySound("dontstarve/common/balloon_pop")
					else
						boatspawn.components.rechargeable:Discharge(115)
						boatspawn.components.deployable.restrictedtag = "literallynoone"
						boatspawn.SoundEmitter:PlaySound("dontstarve/common/balloon_pop")
					end
				end
				
				inst:Remove() 
			end),
        },
    },
}

return StateGraph("portableboat", states, events, "idle")
