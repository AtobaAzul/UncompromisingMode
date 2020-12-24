local env = env
GLOBAL.setfenv(1, GLOBAL)

local function BonusDamage(inst)
	local x, y, z = inst.Transform:GetWorldPosition() 
	local ents = TheSim:FindEntities(x, y, z, 40, { "crabking" })
	if #ents > 0 then
		for i, v in ipairs(ents) do
			if v:IsValid() and not v:IsInLimbo() then
				if v.components.health ~= nil and not v.components.health:IsDead() then
					v.components.health:DoDelta(-500)
				end
				
				print(v)
			end
		end
    end
end

env.AddPrefabPostInit("crabking_claw", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	inst:ListenForEvent("death", BonusDamage)
end)