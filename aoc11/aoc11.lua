local monkeys
local lcm

local function parse_monkey(f)
    local monkey = f:read()
    if not monkey then
        return false
    end
    monkey = monkey:match("Monkey (%d+):")
    local itemlist = f:read():match("Starting items: (.*)")
    local items = {}
    for value in itemlist:gmatch("(%d+)") do
        table.insert(items, value)
    end
    local operator, operand = f:read():match("  Operation: new = old (%p) (%w+)")
    local divisor = f:read():match("  Test: divisible by (%d+)")
    lcm = lcm * divisor
    local tmonkey = f:read():match("    If true: throw to monkey (%d+)")
    local fmonkey = f:read():match("    If false: throw to monkey (%d+)")
    f:read()
    table.insert(monkeys, {monkey=monkey, items=items, operator=operator, operand=operand, divisor= divisor, tmonkey=tmonkey, fmonkey=fmonkey, inspections=0})
    return true
end

local function do_round(monkey, part)
    while #monkey.items ~= 0 do
        local old = table.remove(monkey.items, 1)
        local new
        if monkey.operator == "*" then
            new = old * ((monkey.operand == "old") and old or monkey.operand)
        elseif monkey.operator == "+" then
            new = old + ((monkey.operand == "old") and old or monkey.operand)
        end
        new = (part == 1) and (new // 3) or (new % lcm)
        local dest = 1 + (((new % monkey.divisor) == 0) and monkey.tmonkey or monkey.fmonkey)
        table.insert(monkeys[dest].items, new)
        monkey.inspections = monkey.inspections + 1
    end
end

local function do_part(part, rounds)
    monkeys = {}
    lcm = 1
    local f = io.open(arg[1], "r")
    while parse_monkey(f) do
    end
    f:close()

    print(part, rounds)
    for _ = 1,rounds do
        for i = 1,#monkeys do
            do_round(monkeys[i], part)
        end
    end
    table.sort(monkeys, function (a, b) return a.inspections > b.inspections end)
    print(monkeys[1].inspections * monkeys[2].inspections)
end

do_part(1, 20)
do_part(2, 10000)
