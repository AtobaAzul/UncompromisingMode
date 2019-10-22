--[[
Copyright (C) 2019 Zarklord

This file is part of Uncomprimising Survival.

The source code of this file is shared under the RECEX
SHARED SOURCE LICENSE (version 1.0).
The source code is shared for referrence and academic purposes
with the hope that people can read and learn from it. This is not
Free and Open Source software, and code is not redistributable
without permission of the author. Read the RECEX SHARED
SOURCE LICENSE for details 
The source codes does not come with any warranty including
the implied warranty of merchandise. 
To view a copy of the RECEX SHARED SOURCE LICENSE please refer to 
<https://raw.githubusercontent.com/Recex/Licenses/master/SharedSourceLicense/LICENSE.txt>
]]

--------------------------------------------------------------------------
--[[ Uncomprimising_Shard_Report ]]
--------------------------------------------------------------------------

return Class(function(self, inst)

assert(TheWorld.ismastersim, "Uncomprimising_Shard_Report should not exist on client")

--------------------------------------------------------------------------
--[[ Constants ]]
--------------------------------------------------------------------------

local MAX_TARGETS = 10

--------------------------------------------------------------------------
--[[ Member variables ]]
--------------------------------------------------------------------------

--Public
self.inst = inst

--Private
local _world = TheWorld
local _ismastershard = _world.ismastershard

--Network
local mastershardID = net_tinybyte(inst.GUID, "uncomprimising_shard_report._mastershardid") --this can be a tinybyte since its value is ALWAYS 1
local mastershardData = net_string(inst.GUID, "uncomprimising_shard_report._mastersharddata", "mastersharddirty")
local slaveshardID = {}
local slaveshardData = {}
local emptyShardList = {}

local function GetShardReportDataFromWorld()
    local data = {tags = {}}
    if TheWorld:HasTag("forest") then
        table.insert(data.tags, "forest")
    end
    if TheWorld:HasTag("cave") then
        table.insert(data.tags, "cave")
    end
    return data
end

local function UpdateShardRPCSenders(shardNumber)
    --hack to send arbitrary table over a string, normally this would be to costly to do but we only do this once per shard at startup, so its not a big deal.
    USSR.SHARD_LIST[slaveshardID[shardNumber]:value()] = loadstring(slaveshardData[shardNumber]:value())()
end

for i = 1, MAX_TARGETS do
    local prefix = "uncomprimising_shard_report._slaveshard["..tostring(i).."]"
    table.insert(slaveshardID, net_uint(inst.GUID, prefix.."id"))
    table.insert(slaveshardData, net_string(inst.GUID, prefix.."data", "slaveshard["..i.."]dirty"))
    table.insert(emptyShardList, i)
    inst:ListenForEvent("slaveshard["..i.."]dirty", function() UpdateShardRPCSenders(i) end)
end

--------------------------------------------------------------------------
--[[ Private event listeners ]]
--------------------------------------------------------------------------

local NewShardReport = _ismastershard and function(inst, data)
    if #emptyShardList > 0 then 
        slaveshardID[emptyShardList[1]]:set(data.fromShard)
        slaveshardData[emptyShardList[1]]:set(data.data)
        table.remove(emptyShardList, 1)
    else
        print("To many Slave Shards connected to Master Shard")
    end
end or nil

local ReportShardData = not _ismastershard and function(inst)
    USSR.SHARD_LIST[mastershardID:value()] = loadstring(mastershardData:value())()
    USSR.SendShardRPCToServer(USSR.SHARD_RPC.UncomprimisingSurvival.ShardReportInfo, TheShard:GetShardId(), GetShardReportDataFromWorld())
end or nil

local once = 0
local _Shard_UpdateWorldState = Shard_UpdateWorldState
Shard_UpdateWorldState = _ismastershard and function(world_id, state, tags, world_data, ...)
    if once == 0 then
        mastershardID:set(tonumber(SHARDID.MASTER))
        mastershardData:set(DataDumper(GetShardReportDataFromWorld(), nil, true))
        USSR.SHARD_LIST[mastershardID:value()] = loadstring(mastershardData:value())()
        once = 1
    end
    if state ~= REMOTESHARDSTATE.READY then
        for i, v in ipairs(slaveshardID) do
            if slaveshardID[i]:value() == world_id then
                slaveshardData[i]:set("nil")
                table.insert(emptyShardList, i)
                table.sort(emptyShardList)
                break
            end
        end
    end
    _Shard_UpdateWorldState(world_id, state, tags, world_data, ...)
end or _Shard_UpdateWorldState

--------------------------------------------------------------------------
--[[ Initialization ]]
--------------------------------------------------------------------------

if _ismastershard then
    --Register master shard events
    inst:ListenForEvent("new_shard_report", NewShardReport, _world)
else
    --Register network variable sync events
    inst:ListenForEvent("mastersharddirty", ReportShardData)
end

--------------------------------------------------------------------------
--[[ End ]]
--------------------------------------------------------------------------

end)
