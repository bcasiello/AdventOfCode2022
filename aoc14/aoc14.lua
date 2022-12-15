local f = io.open(arg[1], "r")
local paths = {}
local minx, maxx, miny, maxy
miny = 0
maxy = 0
minx = 1000000
maxx = 0
while true do
    local line = f:read()
    if not line then
        break
    end
    local t = {}
    for x, y in line:gmatch("(%d+),(%d+)") do
        x = tonumber(x)
        y = tonumber(y)
        if x < minx then
            minx = x
        end
        if x > maxx then
            maxx = x
        end
        if y > maxy then
            maxy = y
        end
        table.insert(t, { x=x, y=y})
    end
    table.insert(paths, t)
end
f:close()
maxy = maxy + 2
local grid = {}
local function drawgrid()
    for r = miny, maxy do
        for c = minx-maxy, maxx+maxy do
            io.write(grid[r][c])
        end
        print()
    end
    print()
end

for r = miny, maxy do
    local row = {}
    if r == maxy then
        for c = minx-maxy, maxx+maxy do
            row[c] = "#"
        end
    else
        for c = minx-maxy, maxx+maxy do
            row[c] = "."
        end
    end
    grid[r] = row
end
grid[0][500] = "+"

local function add_line(point1, point2)
    if point1.x == point2.x then
        for j = point1.y, point2.y, point1.y < point2.y and 1 or -1 do
            grid[j][point1.x] = "#"
        end
    else
        for j = point1.x, point2.x, point1.x < point2.x and 1 or -1 do
            grid[point1.y][j] = "#"
        end
    end
end
for i, v in ipairs(paths) do
    for j = 1, #v-1 do
        add_line(v[j], v[j+1])
    end
end
drawgrid()

local done = false
local function drop_sand()
    local grainrow, graincol = 0, 500
    while true do
        if grid[grainrow+1][graincol] == "." then
            grid[grainrow][graincol] = grainrow == 0 and "+" or "."
            grainrow = grainrow + 1
            grid[grainrow][graincol] = "o"
        elseif grid[grainrow+1][graincol-1] == "." then
            grid[grainrow][graincol] = grainrow == 0 and "+" or "."
            grainrow = grainrow + 1
            graincol = graincol - 1
            grid[grainrow][graincol] = "o"
        elseif grid[grainrow+1][graincol+1] == "." then
            grid[grainrow][graincol] = grainrow == 0 and "+" or "."
            grainrow = grainrow + 1
            graincol = graincol + 1
            grid[grainrow][graincol] = "o"
        elseif grainrow == 0 then
            done = true
            return
        else
            return
        end
    end
end
drawgrid()
local count = 0
while not done do
    count = count + 1
    drop_sand()
end
drawgrid()
print('count is ', count)