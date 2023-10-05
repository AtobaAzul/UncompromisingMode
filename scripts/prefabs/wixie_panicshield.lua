local assets =
{
	Asset("ANIM", "anim/stalker_shield.zip"),
}

local SLEEPREPEL_MUST_TAGS = { "_combat" }
local SLEEPREPEL_CANT_TAGS = { "player", "companion", "shadow", "playerghost", "INLIMBO", "toadstool", "notarget" }

local function StartRepel(inst)
	if inst.host ~= nil then
		local x, y, z = inst.Transform:GetWorldPosition()

		local ents = TheSim:FindEntities(x, y, z, 4, SLEEPREPEL_MUST_TAGS, SLEEPREPEL_CANT_TAGS)

		for i, v in ipairs(ents) do
			if v.components.combat ~= nil then
				--v.components.combat:GetAttacked(inst.host, 0, nil)
				v:PushEvent("attacked", { attacker = inst.host, damage = 0, weapon = nil })
			end

			if v.components.locomotor ~= nil and not v:HasTag("stageusher") and (v.sg ~= nil and not v.sg:HasStateTag("noshove") or v.sg == nil) then
				for i = 1, 50 do
					v:DoTaskInTime((i - 1) / 50, function(v)
						if v ~= nil and inst.host ~= nil then
							local x, y, z = inst.host.Transform:GetWorldPosition()
							local tx, ty, tz = v.Transform:GetWorldPosition()

							if tx ~= nil then
								local rad = math.rad(inst.host:GetAngleToPoint(tx, ty, tz))
								local velx = math.cos(rad) --* 4.5
								local velz = -math.sin(rad) --* 4.5

								local giantreduction = v:HasTag("epic") and 1.5 or v:HasTag("smallcreature") and 0.8 or 1
								local cursemultiplier = v:HasDebuff("wixiecurse_debuff") and 1.5 or 1

								local dx, dy, dz = tx + (((2 / (i + 3)) * velx) / giantreduction) * cursemultiplier, ty, tz + (((2 / (i + 3)) * velz) / giantreduction) * cursemultiplier
								local ground = TheWorld.Map:IsPassableAtPoint(dx, dy, dz)
								local boat = TheWorld.Map:GetPlatformAtPoint(dx, dz)
								local ocean_collision = TheWorld.Map:IsOceanAtPoint(dx, dy, dz)

								if not (v.sg ~= nil and (v.sg:HasStateTag("swimming") or v.sg:HasStateTag("invisible"))) then
									if v ~= nil and dx ~= nil and (ground or boat or ocean_collision and v.components.locomotor:CanPathfindOnWater() or v.components.tiletracker ~= nil and not v:HasTag("whale")) then
										--[[if ocean_collision and v.components.amphibiouscreature and not v.components.amphibiouscreature.in_water then
												v.components.amphibiouscreature:OnEnterOcean()
											end]]

										v.Transform:SetPosition(dx, dy, dz)
									end
								end
							end
						end
					end)
				end
			end
		end
	end
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	inst:AddTag("FX")

	inst.AnimState:SetBank("stalker_shield")
	inst.AnimState:SetBuild("stalker_shield")
	inst.AnimState:PlayAnimation("idle" .. math.random(3))
	inst.AnimState:SetFinalOffset(2)
	--inst.AnimState:SetScale(1, 1, 1)

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst.SoundEmitter:PlaySound("dontstarve/creatures/together/stalker/shield")

	inst.persists = false
	inst:ListenForEvent("animover", inst.Remove)
	inst:DoTaskInTime(inst.AnimState:GetCurrentAnimationLength() + FRAMES, inst.Remove)

	inst:DoTaskInTime(2 * FRAMES, StartRepel)

	return inst
end

return Prefab("wixie_panicshield", fn, assets)
