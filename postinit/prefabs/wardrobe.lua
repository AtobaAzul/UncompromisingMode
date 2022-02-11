local env = env
GLOBAL.setfenv(1, GLOBAL)

local function onopen(inst)
    inst.AnimState:PlayAnimation("open")
    inst.SoundEmitter:PlaySound("dontstarve/common/wardrobe_open")
end

local function onclose(inst)
    inst.AnimState:PlayAnimation("close")
    inst.SoundEmitter:PlaySound("dontstarve/common/wardrobe_close")
end

local function ChangeIn(inst,doer)
	inst.components.wardrobe:BeginChanging(doer)
end
local function OnStopChanneling(inst)
	if inst.channeler ~= nil then
		--inst.channeler.sg:GoToState("idle")
	end
	inst.channeler = nil
end

local function GetActivateVerb(inst)
 return "OPEN"
end

env.AddPrefabPostInit("wardrobe", function(inst)
	if not TheWorld.ismastersim then
		return
	end
    inst:AddComponent("container")
    inst.components.container:WidgetSetup("wardrobe")
    inst.components.container.skipclosesnd = true
    inst.components.container.skipopensnd = true

    inst.components.container.onopenfn = onopen
    inst.components.container.onclosefn = onclose

    inst:AddComponent("channelable")
    inst.components.channelable:SetChannelingFn(ChangeIn, OnStopChanneling)
    inst.components.channelable.use_channel_longaction = true
    inst.components.channelable.skip_state_stopchanneling = true
    inst.components.channelable.skip_state_channeling = true
    inst.components.channelable.ignore_prechannel = true
	
	inst.GetActivateVerb = GetActivateVerb
end)

STRINGS.ACTIONS.STARTCHANNELING.WARDROBE = "Use"

ACTIONS.STARTCHANNELING.strfn = function(act)
    if act.target and act.target:HasTag("pump")
    then return "PUMP"
    elseif act.target and act.target:HasTag("wardrobe")
    then return "WARDROBE"
    else return nil
    end
end