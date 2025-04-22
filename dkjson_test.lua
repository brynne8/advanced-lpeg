local dkjson = require('dkjson').use_lpeg()
-- local inspect = require('inspect')
-- local test_file = io.open(...)
local str = '{ }'

local decoded, pos, msg = dkjson.decode(str)

print(decoded, pos, msg)