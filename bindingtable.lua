--[[
    author:Lei.Zhang
    time:2020-02-11 08:44:12
]]
local bindingtable = {}

function bindingtable.create(initTable)
    local t = {}
    local mt
    mt = {
        type____ = "bindingtable", --用于数据类型判断
        bind____ = {}, --存放绑定的监听函数
        maxn____ = {}, --Lua5.2以后取消了table.maxn函数，所以定义自定义了maxn____
        __index = function (table, key)
            return mt[key]
        end,
        __newindex = function ( table, key, value )
            local value_old = mt[key]
            if value_old == value then
                return
            end
            mt[key] = value
            local binds = mt.bind____[key]
            if binds then
                local maxn = mt.maxn____[key]
                for i=1,maxn do
                    local bindFunc = binds[i]
                    if type(bindFunc) == "function" then
                        bindFunc(value,value_old,key)
                    end
                end
            end
        end
    }
    setmetatable(t, mt)
    if type(initTable) == "table" then
        for k,v in pairs(initTable) do
            t[k] = v
        end
    end
    return t
end

function bindingtable.watch(table, key, func)
    assert(type(table) == "table" and table.type____ == "bindingtable", "(bindingtable expected, got "..type(table)..")" )
    local binds = table.bind____
    local maxns = table.maxn____
    if not binds[key] then
        binds[key] = {}
        maxns[key] = 0
    end
    local bind = binds[key]
    local tag = #bind + 1
    bind[tag] = func
    if tag > maxns[key] then
        maxns[key] = tag
    end
    return tag
end

function bindingtable.unwatch(table, key, tag)
    assert(type(table) == "table" and table.type____ == "bindingtable", "(bindingtable expected, got "..type(table)..")" )
    local binds = table.bind____
    if binds[key] then
        binds[key][tag] = nil
    end
end

function bindingtable.watchonce(table, key, func)
    assert(type(table) == "table" and table.type____ == "bindingtable", "(bindingtable expected, got "..type(table)..")" )
    local tag 
    local f = function (...)
        func(...)
        bindingtable.unwatch(table, key, tag)
    end
    tag = bindingtable.watch(table, key , f)
    return tag
end



return bindingtable