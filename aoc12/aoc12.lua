-- see https://towardsdatascience.com/graph-theory-bfs-shortest-path-problem-on-a-grid-1437d5cb4023

local map = {}
local visited = {}

local start, goal, node, height
local f = io.open(arg[1], "r")
for line in f:lines() do
    local row = {}
    local vr = {}
    for i = 1,#line do
        height = line:sub(i, i)
        if height == "S" then
            node = 1
            start = {row=#map+1, col=i}
        elseif height == "E" then
            node = 26
            goal = {row=#map+1, col=i}
        else
            node = string.byte(height, 1) - string.byte("a", 1) + 1
        end
        table.insert(row, node)
        table.insert(vr, false)
    end
    table.insert(map, row)
    table.insert(visited, vr)
end
f:close()

-- is row/col a valid move from cur_row, cur_col?
local function valid(row, col, cur_row, cur_col)
    return  1 <= row and row <= #map and                -- gott stay
            1 <= col and col <= #map[row] and           --  on the map
            not visited[row][col] and                   -- haven't been here already
            map[row][col] <= 1 + map[cur_row][cur_col]  -- not too high for little elfs to climb
end

local delta_row = {-1, 1, 0, 0}
local delta_col = {0, 0, 1, -1}

local queue = {}
local moves = 0
local nodes_left_in_layer = 1
local nodes_in_next_layer = 0

local function clearvisited()
    for row = 1,#map do
        for col = 1,#map[row] do
            visited[row][col] = false
        end
    end
end
local function reinit()
    clearvisited()
    queue = {}
    moves = 0
    nodes_left_in_layer = 1
    nodes_in_next_layer = 0
end

local function explore_neighbors(r, c)
    for i = 1,4 do
        local rr = r + delta_row[i]
        local cc = c + delta_col[i]
        if valid(rr, cc, r, c) then
            table.insert(queue, {rr, cc})
            visited[rr][cc] = true
            nodes_in_next_layer  = nodes_in_next_layer + 1
        end
    end
end

local function solve(sr, sc)
    reinit()
    table.insert(queue, {sr, sc})
    visited[sr][sc] = true

    while #queue > 0 do
        local r, c = table.unpack(table.remove(queue, 1))
        if goal.row == r and goal.col == c then
            return moves
        end
        explore_neighbors(r, c)
        nodes_left_in_layer = nodes_left_in_layer - 1
        if nodes_left_in_layer == 0 then
            nodes_left_in_layer = nodes_in_next_layer
            nodes_in_next_layer = 0
            moves = moves + 1
        end
    end
    return nil
end

-- part 1
print('smallest path is ' .. solve(start.row, start.col) .. " steps")

-- part 2
local min = #map * #map[1]
local steps
for tr = 1, #map do
    for tc = 1, #map[tr] do
        if map[tr][tc] == 1 then
            steps = solve(tr, tc)
            if steps ~= nil and steps < min then
                min = steps
            end
        end
    end
end
print('smallest of all paths is ' .. min .. " steps")
