--- Advent of Code, Day 3

-- old school - implement set functions by hand instead of yoinking Penlight's.
local function make_set(s)
    local t = {}
    for i = 1,#s do
        t[s:sub(i, i)] = true
    end
    return t
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

-- index of the letter is the priority value
local priority_map = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

local function priorities(s)
    local sum = 0
    local pos
    for k in pairs(s) do
        pos = priority_map:find(k)
        if pos then
            sum = sum + pos
        end
    end
    return sum
end
local f = io.open(arg[1], "r")
local total = 0
for rucksack in f:lines() do
    local cs1 = make_set(rucksack:sub(1,#rucksack/2))
    local cs2 = make_set(rucksack:sub(#rucksack/2+1))
    local common = set_intersection(cs1, cs2)
    total = total + priorities(common)
end
f:close()
print("Total is " .. total)

-- part 2
f = io.open(arg[1], "r")
total = 0
while true do
    local r1 = f:read("l")
    if not r1 then break end
    local r2 = f:read("l")
    if not r2 then break end
    local r3 = f:read("l")
    if not r3 then break end
    local s1 = make_set(r1)
    local s2 = make_set(r2)
    local s3 = make_set(r3)
    local common = set_intersection(s1, s2)
    common = set_intersection(common, s3)
    total = total + priorities(common)
end
f:close()
print("Badge total is " .. total)
