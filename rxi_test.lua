local json = require('rxi_json')
local inspect = require('inspect')

print(inspect(json.decode('{"this":["is", "a", "minimal", "example"]}')))