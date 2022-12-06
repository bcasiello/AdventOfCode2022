local queue = {}
local function string_to_set(s)
    local t = {}
    for i = 1, #s do
        t[s:sub(i,i)] = true
    end
    return t
end
local function set_size(s)
    local size = 0
    for k, v in pairs(s) do
        size = size + 1
    end
    return size
end

local function find_marker(marker_len)
    local f = io.open(arg[1], "r")
    for line in f:lines() do
        local pos = 1
        while #line >= marker_len do
            if marker_len == set_size(string_to_set(line:sub(1,marker_len))) then
                return pos+marker_len-1
            end
            line = line:sub(2)
            pos = pos + 1
        end
        return nil
    end
    f:close()
end

-- part 1
print('packet marker found at position ', find_marker(4))

-- part 2
print('message marker found at position ', find_marker(14))
