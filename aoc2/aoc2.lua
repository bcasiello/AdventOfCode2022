-- with only 9 possible entries, it's easy to precompute
-- if this were more complex, use a function to compute and maybe memoize
local outcomescore = {
--  entry     w/l/d score + throw score   
    ["A X"] = 3 +           1,
    ["A Y"] = 6 +           2,
    ["A Z"] = 0 +           3,
    ["B X"] = 0 +           1,
    ["B Y"] = 3 +           2,
    ["B Z"] = 6 +           3,
    ["C X"] = 6 +           1,
    ["C Y"] = 0 +           2,
    ["C Z"] = 3 +           3,
}

local score = 0
local f = io.open(arg[1], "r")
for line in f:lines() do
    score = score + outcomescore[line]
end
f:close()
print("Total score is " .. score)

local strategyscore = {
--  entry     w/l/d score + throw score   
    ["A X"] = 0 +           3, -- lose to rock is scissors
    ["A Y"] = 3 +           1, -- draw to rock is rock
    ["A Z"] = 6 +           2, -- win to rock is paper
    ["B X"] = 0 +           1, -- lose to paper is rock
    ["B Y"] = 3 +           2, -- draw is paper
    ["B Z"] = 6 +           3, -- win in scissors
    ["C X"] = 0 +           2, -- lose to scissors is paper
    ["C Y"] = 3 +           3, -- draw is scissors
    ["C Z"] = 6 +           1, -- win is rock
}
score = 0
f = io.open(arg[1], "r")
for line in f:lines() do
    score = score + strategyscore[line]
end
f:close()
print("Total strategy score is " .. score)
