local f = io.open("input.txt", "r")
local elves = {}
local sum = 0
local value
for line in f:lines() do
    value = tonumber(line)
    if value then
        -- new value for current elf
        sum = sum + value
    else
        -- start new elf
        table.insert(elves,  sum)
        sum = 0
    end
end
-- if the last entry was not a blank line, we still have one elf
-- that's not in the table yet.
if sum > 0 then
    table.insert(elves, sum)
end
-- this assumes we don't care about the elf id, just the calories
-- if we want to maintain ids, store them in the table values.
table.sort(elves, function (a, b) return a > b end)

print("Top elf carries " .. elves[1] .. " calories.")
local top3 = elves[1] + elves[2] + elves[3]
print("Top 3 elves carry " .. top3 .. " calories")
