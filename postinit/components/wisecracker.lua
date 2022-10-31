local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
env.AddComponentPostInit("wisecracker", function(self, inst)
	self.inst = inst

	inst:ListenForEvent("onpresink_portable", function(inst, data)
        inst.components.talker:Say(GetString(inst, "ANNOUNCE_PORTABLEBOAT_SINK"))
    end)
end)