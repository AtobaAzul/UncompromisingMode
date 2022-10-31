local env = env
GLOBAL.setfenv(1, GLOBAL)

local RETARGET_MUST_TAGS = { "_combat", "_health" }
local RETARGET_CANT_TAGS = { "minotaur" }
local function retargetfn(inst)
    return FindEntity(
        inst,
        TUNING.TENTACLE_ATTACK_DIST,
        function(guy)
            return guy.prefab ~= inst.prefab
                and guy.entity:IsVisible()
                and not guy.components.health:IsDead()
                and (guy.components.combat.target == inst or
                    guy:HasTag("character") or
                    guy:HasTag("monster") or
                    guy:HasTag("animal"))
                and (guy:HasTag("player") or (guy.sg and not guy.sg:HasStateTag("hiding")))
        end,
        RETARGET_MUST_TAGS,
        RETARGET_CANT_TAGS)
end

env.AddPrefabPostInit("bigshadowtentacle", function(inst)
	if not TheWorld.ismastersim then
		return
	end

	inst.components.combat:SetRetargetFunction(0.5, retargetfn)
end)