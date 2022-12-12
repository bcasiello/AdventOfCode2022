local cycle = 0
local x = 1
local sum = 0
local scanline = ""
local function tick()
    scanline = scanline .. ((x-1 <= (cycle%40) and (cycle%40) <= x+1) and "#" or ".")
    if #scanline == 40 then
        print(scanline)
        scanline = ""
    end
    cycle = cycle + 1
    if ((cycle + 20) % 40) == 0 then
        if cycle <= 220 then
            sum = sum + cycle * x
        end
    end
end

local f = io.open(arg[1], "r")
local operand
for line in f:lines() do
    operand = line:match("addx (%-?%d+)")
    if operand then
        tick()
        tick()
        x = x + operand
    else
        tick() -- noop
    end
end
f:close()
print(sum)
