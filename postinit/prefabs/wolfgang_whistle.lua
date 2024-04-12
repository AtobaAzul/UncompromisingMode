local env = env
GLOBAL.setfenv(1, GLOBAL)

local function DoAnnounce(doer, str)
	if doer.components.talker ~= nil then
		doer.components.talker:Say(GetString(doer, str))
	end
end

local function OnPlayed(inst, doer)
	if doer.components.coach ~= nil and doer.components.mightiness ~= nil and doer:HasTag("wolfgang_coach") then
		local str
		if not doer.components.mightiness:IsWimpy() then
			if doer:HasTag("coaching") then
				doer.components.coach:Disable()
				str = "ANNOUNCE_WOLFGANG_END_COACHING"
			else
				doer.components.coach:Enable()
				str = "ANNOUNCE_WOLFGANG_BEGIN_COACHING"
			end
		elseif doer.components.mightiness:IsWimpy() then
			str = "ANNOUNCE_WOLFGANG_WIMPY_COACHING"
		end

		if str ~= nil then
			local delay = doer.AnimState:IsCurrentAnimation("whistle") and doer.AnimState:GetCurrentAnimationLength() - doer.AnimState:GetCurrentAnimationTime() - 5 * FRAMES or 0
			if delay > 0 then
				doer:DoTaskInTime(delay, DoAnnounce, str)
			else
				DoAnnounce(doer, str)
			end
		end
	end
end

env.AddPrefabPostInit("wolfgang_whistle", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	if inst.components.instrument ~= nil then
		inst.components.instrument:SetOnPlayedFn(OnPlayed)
	end
end)