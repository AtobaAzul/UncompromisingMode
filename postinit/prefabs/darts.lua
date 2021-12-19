local env = env
GLOBAL.setfenv(1, GLOBAL)




env.AddPrefabPostInit("blowdart_yellow", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	local _attackfn = inst.components.weapon.onattack
	
	local function yellowattack(inst, attacker, target)
	    if target:IsValid() and (target:HasTag("chess") or target:HasTag("uncompromising_pawn") or target:HasTag("twinofterror")) then
			if not target.components.debuffable then
				target:AddComponent("debuffable")
			end
			target.components.debuffable:AddDebuff("shockstundebuff", "shockstundebuff")
			
		end

		_attackfn(inst, attacker, target)
	end
	inst.components.weapon:SetOnAttack(yellowattack)
end)
