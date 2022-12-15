local in_order = 1
local out_of_order = 2
local equal = 3

local function compare(list1, list2)
    if #list1 == 0 and #list2 == 0 then
        return equal
    elseif #list1 == 0 then
        return in_order
    elseif #list2 == 0 then
        return out_of_order
    end
    local left = list1[1]
    local right = list2[1]
    if type(left) == "number" and type(right) == "number" then
        if left < right then
            return in_order
        elseif left > right then
            return out_of_order
        end
    else
        if type(left) == "number" then
            left = {left}
        elseif type(right) == "number" then
            right = {right}
        end
        local result = compare(left, right)
        if result ~= equal then
            return result
        end
    end
    return compare(table.pack(table.unpack(list1, 2)), table.pack(table.unpack(list2, 2)))
end

local f = io.open(arg[1], "r")
local index = 0
local sum = 0
while true do
    local line = f:read()
    if not line then
        break
    end
    local list1 = load("return " .. line:gsub("%[","{"):gsub("%]","}"))()
    local list2 = load("return " .. f:read():gsub("%[","{"):gsub("%]","}"))()
    f:read()
    index = index + 1
    if compare(list1, list2) == in_order then
        print('good index ', index)
        sum = sum + index
    end
end
f:close()
print("sum is ", sum)

-- part 2
local packets = {}
local divider1 = {{2}}
local divider2 = {{6}}
table.insert(packets, divider1)
table.insert(packets, divider2)
f = io.open(arg[1], "r")
while true do
    local line = f:read()
    if not line then
        break
    end
    table.insert(packets, load("return " .. line:gsub("%[","{"):gsub("%]","}"))())
    table.insert(packets, load("return " .. f:read():gsub("%[","{"):gsub("%]","}"))())
    f:read()
    print('npackets', #packets)
end
f:close()

local function printtable(t)
    io.write("{")
    for i, v in ipairs(t) do
        if i > 1 then
            io.write(", ")
        end
        if type(v) == "table" then
            printtable(v)
        else
            io.write(v)
        end
    end
    io.write("}")
end
for i,v in packets do
    io.write(i..": ")
    printtable(v)
    print()
end
table.sort(packets, function (a, b) return compare(a, b) == in_order end)
local i1, i2
for i, v in ipairs(packets) do
    if v == divider1 then
        print(i1)
        i1 = i
        print(i1)
    elseif v == divider2 then
        i2 = i
        print(i2)
        break
    end
end
print("result is ", i1*i2)
--]]