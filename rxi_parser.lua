local rxi_json = require('rxi_json')
-- local inspect = require('inspect')
local test_file = io.open(...)
local str = test_file:read('*a')

-- Do warmup runs first
-- print("Performing warmup runs...")
for i = 1, 3 do
    local decoded = rxi_json.decode(str)
end

local total_time = 0
local iterations = 10

for i = 1, iterations do
    local start_time = os.clock()
    local decoded = rxi_json.decode(str)
    local end_time = os.clock()
    total_time = total_time + (end_time - start_time)
end

local average_time = (total_time / iterations) * 1000  -- Convert to milliseconds
print(string.format("rxi_json decoding time: %.2f ms", average_time))