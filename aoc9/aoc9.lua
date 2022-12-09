local t
local locs

local moves = {
    R = { x= 1, y= 0},
    L = { x=-1, y= 0},
    U = { x= 0, y= 1},
    D = { x= 0, y=-1},
}
local function movex(i, right)
    if right then
        t[i].x = t[i].x + 1
    else
        t[i].x = t[i].x - 1
    end
end
local function movey(i, up)
    if up then
        t[i].y = t[i].y + 1
    else
        t[i].y = t[i].y - 1
    end
end
local function do_move(max_t, dir)
    local move = moves[dir]
    t[0].x = t[0].x + move.x
    t[0].y = t[0].y + move.y
    local distx, disty
    for i = 1, max_t do
        distx = math.abs(t[i-1].x - t[i].x)
        disty = math.abs(t[i-1].y - t[i].y)
        if distx + disty > 2 then
            -- diagonal move
            movex(i, t[i-1].x > t[i].x)
            movey(i, t[i-1].y > t[i].y)
        elseif disty > 1 then
            movey(i, t[i-1].y > t[i].y)
        elseif distx > 1 then
            movex(i, t[i-1].x > t[i].x)
        end
    end
    locs[t[max_t].x..","..t[max_t].y] = true
end

local function do_moves(max_t)
    t = {}
    for i = 0, max_t do
        t[i] = {x=1,y=1}
    end
    locs = {}
    locs["1,1"] = true
    local f = io.open(arg[1], "r")
    local dir, n
    for line in f:lines() do
        dir, n = line:match("(.) (%d+)")
        for _ = 1, n do
            do_move(max_t, dir)
        end
    end
    f:close()
end

local function count_locs()
    local count = 0
    for _ in pairs(locs) do
        count = count + 1
    end
    return count
end

-- part 1
do_moves(1)
print(count_locs())

-- part 2
do_moves(9)
print(count_locs())
