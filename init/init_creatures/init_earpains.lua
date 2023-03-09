
local earpainers = {

	{name = "koalefant", state = "disarm", delay = 1, magnitude = 20, range = 7}


}

local function EarBleed(inst)
	local v = inst.noisestats
	local x,y,z = inst.Transform:GetWorldPosition()
	local range = 5
	if v.range then
		range = v.range
	end
	local wathoms = TheSim:FindEntities(x,y,z,range,{"player"})
	for i,wathom in ipairs(wathoms) do
		if wathom.components.health and not wathom.components.health:IsDead() then
			wathom.components.health:DoDelta(-v.magnitude)
			wathom.sg:GoToState("curse_controlled")
		end	
	end
end

for i,v in ipairs(earpainers) do
	if v.name then
		AddStategraphPostInit(v.name, function(inst)
			print("Initialized Earbleeder: "..v.name)
			if inst.states[v.state] then
				local noisestate = inst.states[v.state]
				local _onenter
				if noisestate.onenter then
					_onenter = noisestate.onenter
				end
				local function OnEnter(inst,v)
					local delay = 1
					if v.delay then
						delay = v.delay
					end
					inst.noisestats = v
					inst:DoTaskInTime(delay,EarBleed)
					if _onenter then
						_onenter(inst)
					end
				end
				noisestate.onenter = OnEnter(inst,v)
			end
		end)
	end
end