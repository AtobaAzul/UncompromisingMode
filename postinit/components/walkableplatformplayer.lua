local env = env
GLOBAL.setfenv(1, GLOBAL)

local function BoatCam_ActiveFn(params, parent, best_dist_sq)
	local state = params.updater.state
    local tpos = params.target:GetPosition()
	state.last_platform_x, state.last_platform_z = tpos.x, tpos.z

	local pan_gain, heading_gain, distance_gain = TheCamera:GetGains()
	TheCamera:SetGains(1.5, heading_gain, distance_gain)
end

local function BoatCam_UpdateFn(dt, params, parent, best_dist_sq)
    print("hi this is running")
    local tpos = params.target:GetPosition()

	local state = params.updater.state
    local platform_x, platform_y, platform_z = tpos:Get()

    local velocity_x = dt == 0 and 0 or ((platform_x - state.last_platform_x) / dt)
	local velocity_z = dt == 0 and 0 or ((platform_z - state.last_platform_z) / dt)
    local velocity_normalized_x, velocity_normalized_z = 0, 0
    local velocity = 0
    local min_velocity = 0.4
    local velocity_sq = velocity_x * velocity_x + velocity_z * velocity_z

    if velocity_sq >= min_velocity * min_velocity then
        velocity = math.sqrt(velocity_sq)
        velocity_normalized_x = velocity_x / velocity
        velocity_normalized_z = velocity_z / velocity
        velocity = math.max(velocity - min_velocity, 0)
    end

    local look_ahead_max_dist = 12
    local look_ahead_max_velocity = 12
    local look_ahead_percentage = math.min(math.max((velocity / look_ahead_max_velocity)+0.25, 0), 1)
    local look_ahead_amount = look_ahead_max_dist * look_ahead_percentage

    --Average target_camera_offset to get rid of some of the noise.
    state.target_camera_offset.x = (state.target_camera_offset.x + velocity_normalized_x * look_ahead_amount) / 2
    state.target_camera_offset.z = (state.target_camera_offset.z + velocity_normalized_z * look_ahead_amount) / 2

    state.last_platform_x, state.last_platform_z = platform_x, platform_z

    local camera_offset_lerp_speed = 0.25
    state.camera_offset.x, state.camera_offset.z = VecUtil_Lerp(state.camera_offset.x, state.camera_offset.z, state.target_camera_offset.x, state.target_camera_offset.z, dt * camera_offset_lerp_speed)

    TheCamera:SetOffset(state.camera_offset + (tpos - parent:GetPosition()))

    local pan_gain, heading_gain, distance_gain = TheCamera:GetGains()
    local pan_lerp_speed = 0.75
    pan_gain = Lerp(pan_gain, state.target_pan_gain, dt * pan_lerp_speed)

    TheCamera:SetGains(pan_gain, heading_gain, distance_gain)
end

env.AddComponentPostInit("walkableplatformplayer", function(self)
    function self:StartBoatCamera()
        local camera_settings =
        {
            state = {
                target_camera_offset = Vector3(0,1.5,0),
                camera_offset = Vector3(0,1.5,0),
                last_platform_x = 0, last_platform_z = 0,
                target_pan_gain = 4,
            },
            UpdateFn = BoatCam_UpdateFn,
            ActiveFn = BoatCam_ActiveFn,
        }
    
        TheFocalPoint.components.focalpoint:StartFocusSource(self.platform, nil, nil, math.huge, math.huge, -1, camera_settings)
    end
    
end)
