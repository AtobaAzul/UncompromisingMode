local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

env.AddPrefabPostInit("oceanfish_shoalspawner", function(inst)
    if not TheWorld.ismastersim then
        return
    end
    if inst.components.childspawner ~= nil then
        if TheWorld.state.isautumn then
            inst.components.childspawner:SetRareChild("oceanfish_small_6", 0.2)
        elseif TheWorld.state.iswinter then
            inst.components.childspawner:SetRareChild("oceanfish_medium_8", 0.2)
            inst.components.childspawner.childname = "oceanfish_medium_4"
        elseif TheWorld.state.isspring then
            inst.components.childspawner:SetRareChild("oceanfish_small_7", 0.2)
            inst.components.childspawner.childname = "oceanfish_medium_5"
        elseif TheWorld.state.issummer then
            inst.components.childspawner:SetRareChild("oceanfish_small_8", 0.2)
            inst.components.childspawner.childname = "oceanfish_medium_3"
        end
    end
end)

env.AddPrefabPostInit("oceanfish_medium_2", function(inst)
    local function OnLoad(inst, data)
        if data ~= nil and data.herdprefab ~= nil then
            inst.components.herdmember.herdprefab = data.herdprefab
        end

        if data ~= nil and data.heavy then
            inst.heavy = data.heavy
        end

        if not TheWorld.state.isautumn then
            if inst.sg ~= nil then
                inst.sg:GoToState("leave")
            else
                inst:Remove()
            end
        end
    end
    inst.OnLoad = OnLoad
end)

env.AddPrefabPostInit("oceanfish_small_6", function(inst)
    local function OnLoad(inst, data)
        if data ~= nil and data.herdprefab ~= nil then
            inst.components.herdmember.herdprefab = data.herdprefab
        end

        if data ~= nil and data.heavy then
            inst.heavy = data.heavy
        end

        if not TheWorld.state.isautumn then
            if inst.sg ~= nil then
                inst.sg:GoToState("leave")
            else
                inst:Remove()
            end
        end
    end
    inst.OnLoad = OnLoad
end)

env.AddPrefabPostInit("oceanfish_medium_4", function(inst)
    local function OnLoad(inst, data)
        if data ~= nil and data.herdprefab ~= nil then
            inst.components.herdmember.herdprefab = data.herdprefab
        end

        if data ~= nil and data.heavy then
            inst.heavy = data.heavy
        end

        if not TheWorld.state.iswinter then
            if inst.sg ~= nil then
                inst.sg:GoToState("leave")
            else
                inst:Remove()
            end
        end
    end
    inst.OnLoad = OnLoad
end)

env.AddPrefabPostInit("oceanfish_medium_8", function(inst)
    local function OnLoad(inst, data)
        if data ~= nil and data.herdprefab ~= nil then
            inst.components.herdmember.herdprefab = data.herdprefab
        end

        if data ~= nil and data.heavy then
            inst.heavy = data.heavy
        end

        if not TheWorld.state.iswinter then
            if inst.sg ~= nil then
                inst.sg:GoToState("leave")
            else
                inst:Remove()
            end
        end
    end
    inst.OnLoad = OnLoad
end)

env.AddPrefabPostInit("oceanfish_medium_5", function(inst)
    local function OnLoad(inst, data)
        if data ~= nil and data.herdprefab ~= nil then
            inst.components.herdmember.herdprefab = data.herdprefab
        end

        if data ~= nil and data.heavy then
            inst.heavy = data.heavy
        end

        if not TheWorld.state.isspring then
            if inst.sg ~= nil then
                inst.sg:GoToState("leave")
            else
                inst:Remove()
            end
        end
    end
    inst.OnLoad = OnLoad
end)

env.AddPrefabPostInit("oceanfish_small_7", function(inst)
    local function OnLoad(inst, data)
        if data ~= nil and data.herdprefab ~= nil then
            inst.components.herdmember.herdprefab = data.herdprefab
        end

        if data ~= nil and data.heavy then
            inst.heavy = data.heavy
        end

        if not TheWorld.state.isspring then
            if inst.sg ~= nil then
                inst.sg:GoToState("leave")
            else
                inst:Remove()
            end
        end
    end
    inst.OnLoad = OnLoad
end)

env.AddPrefabPostInit("oceanfish_small_8", function(inst)
    if not TheWorld.ismastersim then
        return
    end
    local function OnLoad(inst, data)
        if data ~= nil and data.herdprefab ~= nil then
            inst.components.herdmember.herdprefab = data.herdprefab
        end

        if data ~= nil and data.heavy then
            inst.heavy = data.heavy
        end

        if not TheWorld.state.issummer then
            if inst.sg ~= nil then
                inst.sg:GoToState("leave")
            else
                inst:Remove()
            end
        end
    end
    inst.OnLoad = OnLoad
end)

