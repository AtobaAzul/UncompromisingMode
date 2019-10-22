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
local env = env
GLOBAL.setfenv(1, GLOBAL)

if rawget(_G, "AddShardRPCHandler") then
    --Uncomprimising Survival Shard RPC or USSR
    USSR = {
        AddShardRPCHandler = AddShardRPCHandler,
        SendShardRPC = SendShardRPC,
        AddShardRPCHandler = SendShardRPCToServer,
        SHARD_LIST = SHARD_LIST,
        SHARD_RPC_HANDLERS = SHARD_RPC_HANDLERS,
        SHARD_RPC = SHARD_RPC,
    }
    return
end

env.AddPrefabPostInitAny(function(inst)
    if TheWorld and TheWorld.shard == inst then
        inst:AddComponent("uncomprimising_shard_report")
    end
end)

local SHARD_LIST = {}
local SHARD_RPC_HANDLERS = {}
local SHARD_RPC = {}

local function __index_lower(t, k)
    return rawget(t, string.lower(k))
end

local function __newindex_lower(t, k, v)
    rawset(t, string.lower(k), v)
end

local function setmetadata( tab )
    setmetatable(tab, {__index = __index_lower, __newindex = __newindex_lower})
end

local function HandleShardRPC(shard_id, shardlist, namespace, code, ...)
    if type(shardlist) == "number" then
        shardlist = {shardlist}
    end
    if SHARD_RPC_HANDLERS[namespace] ~= nil then
        local fn = SHARD_RPC_HANDLERS[namespace][code]
        if fn ~= nil and TheWorld ~= nil then
            if shard_id ~= TheShard:GetShardId() and (shardlist == nil or table.contains(shardlist, tonumber(TheShard:GetShardId()))) then
                fn(shard_id, ...)
            end
        else
            print("Invalid Shard RPC code: ", namespace, code)
        end
    else
        print("Invalid Shard RPC namespace: ", namespace, code)
    end
end

local _Networking_SystemMessage = Networking_SystemMessage
function Networking_SystemMessage(message, ...)
    if string.sub(message, 1, 4) == "UHSR" then
        if TheWorld.ismastersim then
            local RPC = assert(loadstring("HandleShardRPC("..string.sub(message, 5)..")"))
            setfenv(RPC, {HandleShardRPC = HandleShardRPC})
            RPC()
        end
    else
        _Networking_SystemMessage(message, ...)
    end
end

local function AddShardRPCHandler(namespace, name, fn)
    if SHARD_RPC[namespace] == nil then
        SHARD_RPC[namespace] = {}
        SHARD_RPC_HANDLERS[namespace] = {}

        setmetadata(SHARD_RPC[namespace])
        setmetadata(SHARD_RPC_HANDLERS[namespace])
    end

    table.insert(SHARD_RPC_HANDLERS[namespace], fn)
    SHARD_RPC[namespace][name] = { namespace = namespace, id = #SHARD_RPC_HANDLERS[namespace] }

    setmetadata(SHARD_RPC[namespace][name])
end

--TODO: what other things might we want in the shard list?
local function ShardReportInfo(shard_id, fromShardID, shardData)
    if TheWorld.ismastershard then 
        TheWorld:PushEvent("new_shard_report", {fromShard = fromShardID, data = DataDumper(shardData, nil, false)})
    end
end
AddShardRPCHandler("UncomprimisingSurvival", "ShardReportInfo", ShardReportInfo)

local function dump(val)
    return DataDumper(val, '', true)
end

local function SendShardRPC(id_table, shardlist, ...)
    assert(id_table.namespace ~= nil and SHARD_RPC_HANDLERS[id_table.namespace] ~= nil and SHARD_RPC_HANDLERS[id_table.namespace][id_table.id] ~= nil)

    --convert args to string format
    local ArgStrings = {}
    ArgStrings[#ArgStrings+1] = dump(TheShard:GetShardId())
    --if we only have a single shard were sending to we can optimize by not sending it as a table
    if type(shardlist) == "table" and #shardlist == 1 then 
        shardlist = tonumber(shardlist[1])
    elseif type(shardlist) == "string" then
        shardlist = tonumber(shardlist)
    elseif type(shardlist) == "table" then
        for i, v in ipairs(shardlist) do
            shardlist[i] = tonumber(v)
        end
    end
    ArgStrings[#ArgStrings+1] = dump(shardlist)
    ArgStrings[#ArgStrings+1] = dump(id_table.namespace)
    ArgStrings[#ArgStrings+1] = dump(id_table.id)

    for i, v in ipairs({...}) do
        ArgStrings[#ArgStrings+1] = dump(v)
    end
    
    TheNet:SystemMessage("UHSR"..table.concat(ArgStrings, ","))
end

--small helper function for pure slave -> master communication
local function SendShardRPCToServer(id_table, ...)
    SendShardRPC(id_table, tonumber(SHARDID.MASTER), ...)
end

USSR = {
    AddShardRPCHandler = AddShardRPCHandler,
    SendShardRPC = SendShardRPC,
    AddShardRPCHandler = SendShardRPCToServer,
    SHARD_LIST = SHARD_LIST,
    SHARD_RPC_HANDLERS = SHARD_RPC_HANDLERS,
    SHARD_RPC = SHARD_RPC,
}