local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
local function onattack(inst, attacker, target)
	if target ~= nil and (target:HasTag("shadow") or target:HasTag("shadowminion") or target:HasTag("shadowchesspiece") or target:HasTag("stalker") or target:HasTag("stalkerminion")) and not target.components.health:IsDead() then
		target.components.health:DoDelta(-12)
		--print("damage")
    end

		--print("hit")
	inst.components.weapon.attackwear = target ~= nil and target:IsValid() 
		and (target:HasTag("shadow") or target:HasTag("shadowminion") or target:HasTag("shadowchesspiece") or target:HasTag("stalker") or target:HasTag("stalkerminion")) 
		and TUNING.GLASSCUTTER.SHADOW_WEAR 
		or 1
end

env.AddPrefabPostInit("glasscutter", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	if inst.components.weapon ~= nil then
		inst.components.weapon:SetOnAttack(onattack)
	end
	
end)