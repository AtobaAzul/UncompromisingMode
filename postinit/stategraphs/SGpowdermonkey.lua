local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddStategraphPostInit("powdermonkey", function(inst)
    local states = {
        State {

            name = "action",
            tags = { "busy", "action", "caninterrupt" },
            onenter = function(inst, playanim)
                if inst:GetBufferedAction().target and inst:GetBufferedAction().target.components.boatcannon then
                    local cannon = inst:GetBufferedAction().target
                    cannon.components.timer:StartTimer("monkey_biz", 4)
                    if not cannon.components.boatcannon:IsAmmoLoaded() then
                        cannon.components.boatcannon:LoadAmmo("mortarball_monkey_item")
                    end
                end
                inst.Physics:Stop()
                inst.AnimState:PlayAnimation("action_pre")
                inst.AnimState:PushAnimation("action", false)
                -- inst.SoundEmitter:PlaySound("dontstarve/wilson/make_trap", "make")
            end,

            onexit = function(inst)
            end,

            timeline =
            {
                TimeEvent(6 * FRAMES, function(inst)
                    if inst:GetBufferedAction() and inst:GetBufferedAction().target and inst:GetBufferedAction().target.components.boatcannon then
                        if inst.cannon then inst.cannon.operator = nil end
                        inst.cannon = nil
                    end

                    inst.ClearTinkerTarget(inst)
                    inst:PerformBufferedAction()
                end),
            },

            events =
            {
                EventHandler("animqueueover", function(inst)
                    inst.sg:GoToState("idle")
                end),
            }
        }
    }


    for k, v in pairs(states) do
        assert(v:is_a(State), "Non-state added in mod state table!")
        inst.states[v.name] = v
    end
end)


--whatever i'm placing this here.

env.AddComponentPostInit("boatcannon", function(self)
    --if this overwrite causes trouble later, feel free to make fun of me. - Atobá

    local _Shoot = self.Shoot
    function self:Shoot()
        if self.loadedammo ~= "mortarball_monkey_item" then
            return _Shoot(self)
        else
            if self.loadedammo == nil then
                return
            end

            local x, y, z = self.inst.Transform:GetWorldPosition()
            local projectile = SpawnPrefab("mortarball")
            if projectile == nil then
                self:LoadAmmo(nil)
                return
            end

            projectile.redgemcount = 9
            projectile:setdamage(TUNING.MORTAR_DAMAGE)

            local theta = self.inst.Transform:GetRotation() * DEGREES
            local radius = 0.5
            local offset = Vector3(radius * math.cos(theta), 0, -radius * math.sin(theta))

            projectile.Transform:SetPosition(x + offset.x, y + TUNING.BOAT.BOATCANNON.PROJECTILE_INITIAL_HEIGHT, z + offset.z)

            projectile.shooter = self.inst

            local angle = -self.inst.Transform:GetRotation() * DEGREES
            local range = TUNING.BOAT.BOATCANNON.RANGE

            -- Apply direction & power to shot
            local targetpos = Vector3(x + math.cos(angle) * range, y, z + math.sin(angle) * range)
            projectile.components.complexprojectile:Launch(targetpos, self.inst, self.inst)

            -- Remove cannon ammo reference
            self:LoadAmmo(nil)

            -- Add a shot recoil to the boat
            local force_direction = -Vector3(math.cos(angle), 0, math.sin(angle))
            local force = 1
            local boat = self.inst:GetCurrentPlatform()
            if boat ~= nil then
                boat.components.boatphysics:ApplyForce(force_direction.x, force_direction.z, force)
            end
        end
    end
end)
