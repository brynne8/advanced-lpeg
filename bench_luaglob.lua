local luaglob = require('glob')

local total_tests = 0
local passed_tests = 0

local function assert_match(expected, pattern, str)
  total_tests = total_tests + 1
  local success, grammar = pcall(function() return luaglob.glob(pattern) end)

  if not success or not grammar then
    print(string.format("  Invalid grammar for pattern '%s' matching '%s'",
      pattern, str))
    return false
  end

  local result = grammar(str)
  if not result == expected then
    print(string.format("  Assertion failed for pattern '%s' matching '%s': expected %s, got %s", 
      pattern, str, tostring(expected), tostring(result)))
    return false
  else
    passed_tests = passed_tests + 1
  end
  return true
end

local function bench_glob(expected, pattern, str)
  if assert_match(expected, pattern, str) then
    local iterations = 100
    local start_time = os.clock()

    local grammar = luaglob.glob(pattern)
    for i = 1, iterations do
      grammar(str)
    end

    local average_time = (os.clock() - start_time) / iterations * 1000
    print(string.format("%s time: %.2f ms", pattern, average_time))
  end
end

local expected = arg[1] == "true"
local pattern = arg[2]
local str = arg[3]

bench_glob(expected, pattern, str)