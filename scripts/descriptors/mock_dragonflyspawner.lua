--[[
-Code courtesy of penguin0616. Most (Almost all, actually) belongs to Insight.
Adapted for uncompromising mode. 
]]

-- uncompromising_mock_dragonflyspawner.lua [Worldly]
local filename = debug.getinfo(1, "S").source:match("([%w_]+)%.lua$")

local MOCKFLY_TIMERNAME = "mockfly_timetoattack"
local function GetMockdragonflyData(self)
	if MOCKFLY_TIMERNAME == false then
		return {}
	end

	if not self.inst.updatecomponents[self] then
		return {}
	end

	local save_data = self:OnSave()

	local time_to_attack
	if CurrentRelease.GreaterOrEqualTo("R15_QOL_WORLDSETTINGS") then
		if MOCKFLY_TIMERNAME == nil then
			--DEERCLOPS_TIMERNAME = assert(Insight.env.util.recursiveGLOBALetupvalue(TheWorld.components[filename].GetDebugString, "DEERCLOPS_TIMERNAME"), "Unable to find \"DEERCLOPS_TIMERNAME\"") --"mock_dragonfly_timetoattack"
			MOCKFLY_TIMERNAME = Insight.env.util.recursive_getupvalue(TheWorld.components[filename].GetDebugString, "DEERCLOPS_TIMERNAME") or false
		end
		time_to_attack = TheWorld.components.worldsettingstimer:GetTimeLeft(MOCKFLY_TIMERNAME)
	else
		time_to_attack = save_data.timetoattack
	end

	local target = Insight.env.util.getupvalue(self.OnUpdate, "_targetplayer")

	if target then
		target = {
			name = target.name,
			userid = target.userid,
			prefab = target.prefab,
		}
	end

	return {
		time_to_attack = time_to_attack,
		target = target,
		warning = save_data.warning,
	}
end

local function ProcessInformation(context, time_to_attack, target)
	local time_string = context.time:SimpleProcess(time_to_attack)
	local client_table = target and TheNet:GetClientTableForUser(target.userid)

	if not client_table then
		return time_string
	else
		local target_string = string.format("%s - %s", target.name, target.prefab)
		return string.format(
			"<color=%s>Target: %s</color> -> %s", 
			Insight.env.Color.ToHex(
				client_table.colour
			),
			target_string, 
			time_string
		)
	end
end

local function Describe(self, context)
	local description = nil
	local data = {}

	if self == nil and context.mock_dragonfly_data then
		data = context.mock_dragonfly_data
	elseif self and context.mock_dragonfly_data == nil then
		data = GetMockdragonflyData(self)
	else
		error(string.format("mock_dragonflyspawner.Describe improperly called with self=%s & mock_dragonfly_data=%s", tostring(self), tostring(context.mock_dragonfly_data)))
	end

	if data.time_to_attack then
		description = ProcessInformation(context, data.time_to_attack, data.target)
	end

	return {
		priority = 10,
		description = description,
		icon = {
			atlas = "images/Dragonfly.xml",
			tex = "Dragonfly.tex",
		},
		worldly = true,
		time_to_attack = data.time_to_attack,
		target_userid = data.target and data.target.userid or nil,
		warning = data.warning,
	}
end

local function StatusAnnoucementsDescribe(special_data, context)
	if not special_data.time_to_attack then
		return
	end

	local description = nil
	local target = special_data.target_userid and TheNet:GetClientTableForUser(special_data.target_userid)

	if target then
		description = Insight.env.ProcessRichTextPlainly(string.format(
			"<prefab=dragonfly> will spawn on %s (<prefab=%s>) in %s.",
			target.name,
			target.prefab,
			context.time:TryStatusAnnouncementsTime(special_data.time_to_attack)
		))
	else
		description = Insight.env.ProcessRichTextPlainly(string.format(
			"<prefab=dragonfly> will attack in %s.",
			context.time:TryStatusAnnouncementsTime(special_data.time_to_attack)
		))
	end

	return {
		description = description,
		append = true
	}
end

local function DangerAnnouncementDescribe(special_data, context)
	-- Funny enough, very similar to logic for status announcements and normal descriptor.
	-- Gets repetitive.
	if not special_data.time_to_attack then
		return
	end

	local description
	local client_table = TheNet:GetClientTableForUser(special_data.target_userid)
	local time_string = context.time:SimpleProcess(special_data.time_to_attack, "realtime")
	
	if not client_table then
		description = string.format("<prefab=dragonfly> will attack in %s.", time_string)
	else
		description = string.format(
			"<prefab=dragonfly> will spawn on %s (<prefab=%s>) in %s.",
			client_table.name, 
			client_table.prefab, 
			time_string
		)
	end

	return description, "boss"
end

return {
	Describe = Describe,
	GetMockdragonflyData = GetMockdragonflyData,
	StatusAnnoucementsDescribe = StatusAnnoucementsDescribe,
	DangerAnnouncementDescribe = DangerAnnouncementDescribe,
}