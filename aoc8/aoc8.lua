local grid = {}
local cur = ""
local f = io.open(arg[1], "r")
for line in f:lines() do
    local row = {}
    line:gsub(".", function(s) table.insert(row,s) end)
    table.insert(grid, row)
end
f:close()

local function hidden_by_row(height, col, min, max)
    for i = min, max do
        if grid[i][col] >= height then
            return true
        end
    end
    return false
end

local function hidden_by_col(height, row, min, max)
    for i = min, max do
        if grid[row][i] >= height then
            return true
        end
    end
    return false
end
local function is_visible(row, col)
    local height = grid[row][col]
    return not (hidden_by_row(height, col, 1, row-1) and
                hidden_by_row(height, col, row+1, #grid) and
                hidden_by_col(height, row, 1, col-1) and
                hidden_by_col(height, row, col+1, #grid[row]))
end

local count = 4 * (#grid - 1)   -- outer trees are always visible
-- check interior trees
for i = 2,#grid-1 do
    for j = 2,#grid[i]-1 do
        if is_visible(i, j) then
            count = count + 1
        end
    end
end
print('count', count)

-- part 2

local function scene_score(row, col)
    local height = grid[row][col]
    local score = 1
    for i = col-1, 1, -1 do
        if i == 1 or grid[row][i] >= height then
            score = (col - i)
            break
        end
    end
    for i = col+1, #grid[row] do
        if i == #grid[row] or grid[row][i] >= height then
            score = score * (i - col)
            break
        end
    end
    for i = row-1, 1, -1 do
        if i == 1 or grid[i][col] >= height then
            score = score * (row - i)
            break
        end
    end
    for i = row+1, #grid do
        if i == #grid or grid[i][col] >= height then
            score = score * (i - row)
            break
        end
    end
    return score
end

local best_scene_score = 0
for i = 2,#grid-1 do
    for j = 2,#grid[i]-1 do
        local height = grid[i][j]
        local score = scene_score(i,j)
        if score > best_scene_score then
            best_scene_score = score
        end
    end
end
print('best scene score', best_scene_score)
