local glob = require('peglob_noopt')
local lines = {}
local iterations = 100

for line in io.lines('glob-real/filelist.txt') do
  table.insert(lines, line)
end

local function bench_glob(pattern, expected_count)
  local grammar = glob:match(pattern)
  local start_time = os.clock()
  for i = 1, iterations do
    local count = 0
    for _, line in ipairs(lines) do
      if grammar:match(line) then
        count = count + 1
      end
    end
    
    if count ~= expected_count then
      print(string.format("%s (%d matched), expected %d", pattern, count, expected_count))
      return
    end
  end
  
  print(string.format("%s time: %.2f ms", pattern, (os.clock() - start_time) * 1000 / iterations))
end

local function test_bench()
  bench_glob([[{src,extensions}/**/test/**/{fixtures,browser,common}/**/*.{ts,js}]], 726)
  bench_glob([[{extensions,src}/**/{media,images,icons}/**/*.{svg,png,gif,jpg}]], 119)
  bench_glob([[{.github,build,test}/**/{workflows,azure-pipelines,integration,smoke}/**/*.{yml,yaml,json}]], 53)
  bench_glob([[src/vs/{base,editor,platform,workbench}/test/{browser,common,node}/**/[a-z]*[tT]est.ts]], 224)
  bench_glob([[src/vs/workbench/{contrib,services}/**/*{Editor,Workspace,Terminal}*.ts]], 155)
  bench_glob([[{extensions,src}/**/{markdown,json,javascript,typescript}/**/*.{ts,json}]], 19)
  bench_glob([[**/{electron-sandbox,electron-main,browser,node}/**/{*[sS]ervice*,*[cC]ontroller*}.ts]], 419)
  bench_glob([[{src,extensions}/**/{common,browser,electron-sandbox}/**/*{[cC]ontribution,[sS]ervice}.ts]], 586)
  bench_glob([[src/vs/{base,platform,workbench}/**/{test,browser}/**/*{[mM]odel,[cC]ontroller}*.ts]], 95)
  bench_glob([[extensions/**/{browser,common,node}/{**/*[sS]ervice*,**/*[pP]rovider*}.ts]], 3)
end

test_bench()