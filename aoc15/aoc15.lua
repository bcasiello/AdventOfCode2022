local function map_varg(f, ...)
	if select("#", ...) == 0 then
		return
	end
	return f((...)), map_varg(f, select(2, ...))
end
local function manhattan_distance(x1, y1, x2, y2)
    return math.abs(x1-x2) + math.abs(y1-y2)
end
local sensors = {}
local f = io.open(arg[1], "r")
for line in f:lines() do
    local sx, sy, bx, by = map_varg(tonumber, line:match("Sensor at x=(%-?%d+), y=(%-?%d+): closest beacon is at x=(%-?%d+), y=(%-?%d+)"))
    table.insert(sensors, {{x=sx,y=sy}, {x=bx,y=by}, manhattan_distance(sx, sy, bx, by)})
end
f:close()
local rowmt = {
    __index = function (t, k)
        return "." end,
}
local mt = {
    __index = function (t,k)
        local row = {}
        setmetatable(row, rowmt)
        t[k] = row
        return t[k]
    end,
}
local grid = {}
setmetatable(grid, mt)

local function cleargrid()
    grid = {}
    setmetatable(grid, mt)
end

-- part 1
local count = 0
cleargrid()
for i, v in ipairs(sensors) do
    print(i)
    local sensor, beacon, md = table.unpack(v)
    local y = 2000000
    grid[sensor.y][sensor.x] = "S"
    grid[beacon.y][beacon.x] = "B"
    for x = sensor.x - md, sensor.x + md do
        if md >= manhattan_distance(sensor.x, sensor.y, x, y) then
            if grid[y][x] == "." then
                grid[y][x] = "#"
                count = count + 1
            end
        end
    end
end
print('count is ', count)

-- part 2

local candidates = {}

for i, v in ipairs(sensors) do
    print(i)

    -- the signal must be just outside the sensor range of the sensors
    -- if it could be farther than that, there would be more than one solution
    local sensor, _, md = table.unpack(v)

    -- generate candidates by walking along just outside the sensor's border
    local y = sensor.y - md - 1
    local x = sensor.x
    -- walk southeast
    while y < sensor.y do
        table.insert(candidates, {x=x,y=y})
        y = y + 1
        x = x + 1
    end
    -- southwest
    while x > sensor.x do
        table.insert(candidates, {x=x,y=y})
        y = y + 1
        x = x - 1
    end
    -- northwest
    while y > sensor.y do
        table.insert(candidates, {x=x,y=y})
        y = y - 1
        x = x - 1
    end
    while x < sensor.x do
        table.insert(candidates, {x=x,y=y})
        y = y - 1
        x = x + 1
    end

    -- the cull the candidates that are
    -- 1. out of range, or
    -- 2. within range of another sensor
    for k = #candidates, 1, -1 do
        if candidates[k].x < 0 or candidates[k].x > 4000000 then
            table.remove(candidates, k)
        elseif candidates[k].y < 0 or candidates[k].y > 4000000 then
            table.remove(candidates, k)
        else
            for _, v2 in ipairs(sensors) do
                local sensor, _, md = table.unpack(v2)
                if md >= manhattan_distance(sensor.x, sensor.y, candidates[k].x, candidates[k].y) then
                    table.remove(candidates, k)
                    break
                end
            end
        end
    end

    -- anyone survive? that's our winner!
    if #candidates == 1 then
        print(candidates[1].x, candidates[1].y, candidates[1].x * 4000000 + candidates[1].y)
        break
    end
end
