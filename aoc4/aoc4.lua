--- Advent of Code, Day 4

-- create set from range
local function range_to_set(first, last)
    local t = {}
    for i = first, last do
        t[i] = true
    end
    return t
end

-- is s2 a subset of s1?
local function subset(s1, s2)
    for k, v in pairs(s2) do
        if not s1[k] then
            return false
        end
    end
    return true
end

local function set_empty(s)
    for _ in pairs(s) do
        return false
    end
    return true
end

local function set_intersection(s1, s2)
    local t = {}
    for k, v in pairs(s1) do
        if s2[k] then
            t[k] = v
        end
    end
    return t
end

local f = io.open(arg[1], "r")
local total = 0
for line in f:lines() do
    local start1, end1, start2, end2 = line:match("(%d+)-(%d+),(%d+)-(%d+)")
    assert(start1, "malformed line: " .. line)
    local set1 = range_to_set(start1, end1)
    local set2 = range_to_set(start2, end2)
    if subset(set1, set2) or subset(set2, set1) then
        total = total + 1
    end
end
f:close()
print("Total is " .. total)

-- part 2
f = io.open(arg[1], "r")
total = 0
for line in f:lines() do
    local start1, end1, start2, end2 = line:match("(%d+)-(%d+),(%d+)-(%d+)")
    assert(start1, "malformed line: " .. line)
    local set1 = range_to_set(start1, end1)
    local set2 = range_to_set(start2, end2)
    local intersection = set_intersection(set1, set2)
    if not set_empty(intersection) then
        total = total + 1
    end
end
f:close()
print("Total is " .. total)
