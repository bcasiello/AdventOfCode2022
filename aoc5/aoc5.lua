local stacks = {}

local function crane9000(line)
    local n, from, to = line:match("move (%d+) from (%d+) to (%d+)")
    for _ = 1, tonumber(n) do
        table.insert(stacks[tonumber(to)], 1, table.remove(stacks[tonumber(from)], 1))
    end
end
local function crane9001(line)
    local n, from, to = line:match("move (%d+) from (%d+) to (%d+)")
    local t = {}
    for _ = 1, tonumber(n) do
        table.insert(t, 1, table.remove(stacks[tonumber(from)], 1))
    end
    for _, v in ipairs(t) do
        table.insert(stacks[tonumber(to)], 1, v)
    end
end
local function do_stack(line)
    -- compress picture to single crate id or space
    line = line:gsub(".(.).%s?", "%1")
    for i = 1,#line do
        if line:sub(i, i) ~= " " then
            if not stacks[i] then stacks[i] = {} end
            table.insert(stacks[i], line:sub(i, i))
        end
    end
end

local function do_with_crane(crane)
    local f = io.open(arg[1], "r")
    for line in f:lines() do
        if #line == 0 or tonumber(line:sub(2,2))then
            -- ignore - blank line or stack numbers
        elseif line:match("^move") then
            crane(line)
        else
            do_stack(line)
        end
    end
    f:close()
    local result = ""
    for i in ipairs(stacks) do
        result = result .. (stacks[i][1] or " ")
    end
    print(result)
end

-- part 1
stacks = {}
do_with_crane(crane9000)
-- part 2
stacks = {}
do_with_crane(crane9001)
