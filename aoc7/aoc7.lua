local fs = {}
local cur = ""
local f = io.open(arg[1], "r")
for line in f:lines() do
    if line:sub(1,1) == "$" then
        -- do command
        local cmd, arg = line:match("^%$ (%w+) (%g+)")
        if cmd == "cd" then
            if arg == "/" then
                cur = "/"
                fs[cur] = {size = 0, total = nil, parent=nil}
            elseif arg == ".." then
                cur = fs[cur].parent
            else
                local data = {size = 0, total = nil, parent = cur}
                cur = cur .. arg .. "/"
                fs[cur] = data
            end
        end
    else
        -- do data
        local size, name = line:match("^(%g+) (%w+)")
        if size ~= "dir" then
            fs[cur].size = fs[cur].size + tonumber(size)
        end
    end
end

local function totals(dir)
    if fs[dir].total then
        return fs[dir.total]
    end
    local size = fs[dir].size
    for k, v in pairs(fs) do
        if v.parent == dir then
            size = size + totals(k)
        end
    end
    fs[dir].total = size
    return size
end

totals("/")
local sum = 0
for k, v in pairs(fs) do
    if v.total and v.total < 100000 then
        sum = sum + v.total
    end
end
print('sum', sum)

local maxused = 70000000 - 30000000
local best = 0
local bestdir = 0
for k, v in pairs(fs) do
    local diff = fs["/"].total - v.total
    if diff < maxused and diff > best then
        best = diff
        bestdir = v.total
    end
end
print('best', bestdir)
