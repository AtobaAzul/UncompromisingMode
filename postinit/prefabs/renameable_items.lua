local env = env
GLOBAL.setfenv(1, GLOBAL)

local SignGenerator = require"signgenerator"
local UpvalueHacker = require("tools/upvaluehacker")
local writeables = require("writeables")

local kinds = UpvalueHacker.GetUpvalue(writeables.makescreen, "kinds")

if kinds == nil then
    return
end

env.AddPrefabPostInitAny(function(inst)
    if inst ~= nil and inst:HasTag("_equippable") then
        kinds[inst.prefab] = kinds["homesign"]
        kinds[inst.prefab].middlebtn = nil

        inst.custom_name = net_string(inst.GUID, "custom_name")

        inst.displaynamefn = function(_inst)
            local name = _inst.custom_name:value()
            return name ~= "" and name ~= nil and
                STRINGS.NAMES[string.upper(_inst.prefab)] .. "\n\"" ..
                name .. "\"" or STRINGS.NAMES[string.upper(_inst.prefab)]
        end

        if not TheWorld.ismastersim then
            return
        end

        inst:AddComponent("writeable")
        inst.components.writeable:SetDefaultWriteable(false)
        inst.components.writeable:SetAutomaticDescriptionEnabled(false)

        local _Write = inst.components.writeable.Write
        inst.components.writeable.Write =
            function(self, doer, text, ...)
                if not text then
                    text = self.text
                    if doer and doer.tool_prefab then
                        doer.components.inventory:GiveItem(SpawnPrefab(doer.tool_prefab), nil, inst:GetPosition())
                    end
                else
                    --switched to doer because some prefabs don't have SoundEmitter. A player should (hopefully) always have SoundEmitter.
                    doer.SoundEmitter:PlaySound("dontstarve/common/together/draw")
                end

                inst.custom_name:set(text and text ~= "" and text or "")

                _Write(self, doer, text, ...)
            end

        local _OnLoad = inst.components.writeable.OnLoad
        inst.components.writeable.OnLoad = function(self, ...)
            _OnLoad(self, ...)
            local text = self.text
            inst.custom_name:set(text and text ~= "" and text or "")
        end
    end
end)