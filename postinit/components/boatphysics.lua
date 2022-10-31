local env = env
GLOBAL.setfenv(1, GLOBAL)
local easing = require("easing")

--This will apply 50% more rowing force when the boat is a portable raft

env.AddComponentPostInit("boatphysics", function(self)
	local _OldApplyRowForce = self.ApplyRowForce
	
	function self:ApplyRowForce(dir_x, dir_z, force, max_velocity)
		if self.inst:HasTag("portableraft") then
			force = force * 1.25
			
			local dir_normal_x, dir_normal_z = VecUtil_NormalizeNoNaN(dir_x, dir_z)
			local velocity_normal_x, velocity_normal_z = VecUtil_NormalizeNoNaN(self.velocity_x, self.velocity_z)
			local force_dir_modifier = math.max(0, VecUtil_Dot(velocity_normal_x, velocity_normal_z, dir_normal_x, dir_normal_z))

			local base_dampening = self:GetForceDampening()

			if force_dir_modifier > 0 then
				local dir_length = VecUtil_Length(dir_normal_x, dir_normal_z)

				local forward_dir_length = dir_length * force_dir_modifier
				local side_dir_length = dir_length * (1 - force_dir_modifier)

				local velocity_left_normal_x, velocity_left_normal_z = velocity_normal_z, -velocity_normal_x
				local is_left = VecUtil_Dot(velocity_left_normal_x, velocity_left_normal_z, dir_normal_x, dir_normal_z) > 0

				local velocity_dampening = base_dampening - easing.inExpo(
					math.min(VecUtil_Length(self.velocity_x, self.velocity_z), max_velocity),
					TUNING.BOAT.BASE_DAMPENING,
					TUNING.BOAT.MAX_DAMPENING - TUNING.BOAT.BASE_DAMPENING,
					max_velocity
				)

				self:DoApplyForce(velocity_normal_x, velocity_normal_z, force * math.max(0, velocity_dampening) * forward_dir_length)
				self:DoApplyForce(velocity_left_normal_x, velocity_left_normal_z, force * math.max(0, base_dampening) * side_dir_length * (is_left and 1 or -1))
			else
				self:DoApplyForce(dir_x, dir_z, force * math.max(0, base_dampening))
			end
		else
			return _OldApplyRowForce(self, dir_x, dir_z, force, max_velocity)
		end
	end
end)