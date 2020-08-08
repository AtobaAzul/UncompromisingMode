local env = env
GLOBAL.setfenv(1, GLOBAL)
----------------------------------------------------------------
local function OnDead(inst)
    AwardRadialAchievement("spiderqueen_killed", inst:GetPosition(), TUNING.ACHIEVEMENT_RADIUS_FOR_GIANT_KILL)
	local corpse = SpawnPrefab("spiderqueencorpse")
	corpse.Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst:DoTaskInTime(0.3, function(inst)
	inst:Remove()
	end)
end


local projectile_prefabs =
{
    "spat_splat_fx",
    "spat_splash_fx_full",
    "spat_splash_fx_med",
    "spat_splash_fx_low",
    "spat_splash_fx_melted",
}
local function EquipWeapons(inst)
    if inst.components.inventory ~= nil and not inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) then
        local snotbomb = CreateEntity()
        snotbomb.name = "Snotbomb"
        --[[Non-networked entity]]
        snotbomb.entity:AddTransform()
        snotbomb:AddComponent("weapon")
        snotbomb.components.weapon:SetDamage(TUNING.SPAT_PHLEGM_DAMAGE)
        snotbomb.components.weapon:SetRange(TUNING.SPAT_PHLEGM_ATTACKRANGE)
        snotbomb.components.weapon:SetProjectile("web_bomb")
        snotbomb:AddComponent("inventoryitem")
        snotbomb.persists = false
        snotbomb.components.inventoryitem:SetOnDroppedFn(snotbomb.Remove)
        snotbomb:AddComponent("equippable")
        snotbomb:AddTag("snotbomb")

        inst.components.inventory:GiveItem(snotbomb)
        inst.weaponitems.snotbomb = snotbomb

        local meleeweapon = CreateEntity()
        meleeweapon.name = "Snaut Bash"
        --[[Non-networked entity]]
        meleeweapon.entity:AddTransform()
        meleeweapon:AddComponent("weapon")
        meleeweapon.components.weapon:SetDamage(TUNING.SPIDERQUEEN_DAMAGE)
        meleeweapon.components.weapon:SetRange(TUNING.SPIDERQUEEN_ATTACKRANGE)
        meleeweapon:AddComponent("inventoryitem")
        meleeweapon.persists = false
        meleeweapon.components.inventoryitem:SetOnDroppedFn(meleeweapon.Remove)
        meleeweapon:AddComponent("equippable")
        meleeweapon:AddTag("meleeweapon")

        inst.components.inventory:GiveItem(meleeweapon)
        inst.weaponitems.meleeweapon = meleeweapon
    end
end
env.AddPrefabPostInit("spiderqueen", function(inst)
	inst.entity:AddGroundCreepEntity()
	
	if not TheWorld.ismastersim then
		return
	end
	inst.WebReady = true
	inst:AddComponent("inventory")
    inst.weaponitems = {}
	EquipWeapons(inst)
	inst.GroundCreepEntity:SetRadius(2)
	inst:ListenForEvent("death", OnDead)
	inst.OnLoad = function(inst)  inst.WebReady = true   end
end)