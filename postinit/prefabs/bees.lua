local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

local bees = {
"beequeen",
"beeguard",
"bee",
"killerbee",
}

local function ShareTarget(inst,data)
	local other = data.target
	local x,y,z = inst.Transform:GetWorldPosition()
	local bees = TheSim:FindEntities(x,y,z,20,{"bee"})
	for i,bee in ipairs(bees) do
		if bee.components.combat ~= nil and bee.components.combat.target == nil then
			bee.components.combat:SuggestTarget(other)
		end
	end
end

for i,bee in ipairs(bees) do
	env.AddPrefabPostInit(bee, function(inst)
		if not TheWorld.ismastersim then
			return
		end
	inst:ListenForEvent("onhitother",ShareTarget)
	end)
end