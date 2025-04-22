local glob = require('peglob')

local function assert_match(expected, pattern, str)
  local success, grammar = pcall(function() return glob:match(pattern) end)

  if not success or not grammar then
    print(string.format("  Invalid grammar for pattern '%s' matching '%s'",
      pattern, str))
    return false
  end

  local result = grammar:match(str)
  if not result == expected then
    print(string.format("  Assertion failed for pattern '%s' matching '%s': expected %s, got %s", 
      pattern, str, tostring(expected), tostring(result)))
    return false
  end
  return true
end

local function bench_glob(expected, pattern, str)
  if assert_match(expected, pattern, str) then
    local iterations = 100
    local start_time = os.clock()

    local grammar = glob:match(pattern)
    for i = 1, iterations do
      grammar:match(str)
    end

    local average_time = (os.clock() - start_time) * 1000 / iterations
    print(string.format("%s time: %.4f ms", pattern, average_time))
  end
end

local expected = arg[1] == "true"
local pattern = arg[2]
local str = arg[3]

bench_glob(expected, pattern, str)