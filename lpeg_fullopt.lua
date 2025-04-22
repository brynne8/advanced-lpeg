local re = require('re')
require("table.new")
-- local inspect = require('inspect')
local test_file = io.open(...)
local str = test_file:read('*a')

table.reverse = function (t)
  local reversedTable = {}
  local itemCount = #t
  for k, v in ipairs(t) do
    reversedTable[itemCount + 1 - k] = v
  end
  return reversedTable
end

local function codepoint_to_utf8(n)
  -- http://scripts.sil.org/cms/scripts/page.php?site_id=nrsi&id=iws-appendixa
  local f = math.floor
  if n <= 0x7f then
    return string.char(n)
  elseif n <= 0x7ff then
    return string.char(f(n / 64) + 192, n % 64 + 128)
  elseif n <= 0xffff then
    return string.char(f(n / 4096) + 224, f(n % 4096 / 64) + 128, n % 64 + 128)
  elseif n <= 0x10ffff then
    return string.char(f(n / 262144) + 240, f(n % 262144 / 4096) + 128,
                       f(n % 4096 / 64) + 128, n % 64 + 128)
  end
  error( string.format("invalid unicode codepoint '%x'", n) )
end

local function esc(str)
  return (str:gsub("\\(%d%d?%d?)", function(n)
    return string.char(tonumber(n))
  end))
end

local g = re.compile(esc[[
doc           <- JSON __ !.
JSON          <- __ (Number / Object / Array / String / True / False / Null)
Object        <- ('{' (String __ ':' JSON __ (',' {: String __ ':' JSON :} __)* / __) '}')
                   -> make_table
Array         <- {| '[' ({: JSON :} __ (',' {: JSON :} __)* / __) ']' |}
String        <- __ '"' {~ StringBody ~} '"'
StringBody    <- ([^"\\0-\31]+ / Escape+)*
Escape        <- '\' -> '' (["\/{|] / [bfnrt] -> str_esc / UnicodeEscape)
UnicodeEscape <- 'u' -> '' (({[dD][89aAbB]%x%x} '\u' {%x%x%x%x}) -> surrogate /
                            %x%x%x%x -> proc_uesc)
Number        <- ( Minus? IntPart FractPart? ExpPart? ) -> tonumber
Minus         <- '-'
IntPart       <- '0' / [1-9][0-9]*
FractPart     <- '.' [0-9]+
ExpPart       <- [eE] [+-]? [0-9]+
True          <- 'true'  ${true}
False         <- 'false' ${false}
Null          <- 'null'  ${nil}
__            <- %s*
]], {
  tonumber = tonumber,
  str_esc = {
    b = '\b',
    f = '\f',
    n = '\n',
    r = '\r',
    t = '\t'
  },
  proc_uesc = function(s)
    return codepoint_to_utf8(tonumber(s, 16))
  end,
  surrogate = function(a, b)
    local n1 = tonumber(a, 16)
    local n2 = tonumber(b, 16)
    return codepoint_to_utf8((n1 - 0xd800) * 0x400 + (n2 - 0xdc00) + 0x10000)
  end,
  make_table = function(...)
    local arg = {...}
    local len = #arg
    local res = table.new(0, len / 2)
    local i = 1
    repeat
      res[arg[i]] = arg[i + 1]
      i = i + 2
    until i > len
    return res
  end,
  add_prop = function(t, a, b)
    t[a] = b
    return t
  end
})

-- Do warmup runs first
-- print("Performing warmup runs...")
for i = 1, 3 do
    local decoded = g:match(str)
end

-- Store measurements in a simple table
local measurements = {}
local iterations = 15

for i = 1, iterations do
    local start_time = os.clock()
    local decoded = g:match(str)
    local end_time = os.clock()
    local elapsed = (end_time - start_time) * 1000  -- Convert to milliseconds
    measurements[i] = elapsed
end

-- Print measurements in a format easy to copy into Python
print("fullopt decoding time (ms):")
local output = "["
for i, time in ipairs(measurements) do
    output = output .. string.format("%.2f", time)
    if i < #measurements then
        output = output .. ", "
    end
end
output = output .. "]"
print(output)