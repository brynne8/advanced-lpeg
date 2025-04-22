local glob = require('peglob')
local lines = {}

for line in io.lines('glob-real/filelist.txt') do
  table.insert(lines, line)
end

local function glob_it(pattern)
  local grammar = glob:match(pattern)
  for _, line in ipairs(lines) do
    if grammar:match(line) then
      print(line)
    end
  end
end

local function test_bench()
--   glob_it([[{src,extensions}/**/test/**/{fixtures,browser,common}/**/*.{ts,js}]], 726)
--   glob_it([[{extensions,src}/**/{media,images,icons}/**/*.{svg,png,gif,jpg}]], 119)
--   glob_it([[{.github,build,test}/**/{workflows,azure-pipelines,integration,smoke}/**/*.{yml,yaml,json}]], 53)
--   glob_it([[src/vs/{base,editor,platform,workbench}/test/{browser,common,node}/**/[a-z]*[tT]est.ts]], 224)
--   glob_it([[src/vs/workbench/{contrib,services}/**/*{Editor,Workspace,Terminal}*.ts]], 155)
--   glob_it([[{extensions,src}/**/{markdown,json,javascript,typescript}/**/*.{ts,json}]], 19)
--   glob_it([[**/{electron-sandbox,electron-main,browser,node}/**/{*[sS]ervice*,*[cC]ontroller*}.ts]], 419)
--   glob_it([[{src,extensions}/**/{common,browser,electron-sandbox}/**/*{[cC]ontribution,[sS]ervice}.ts]], 586)
--   glob_it([[src/vs/{base,platform,workbench}/**/{test,browser}/**/*{[mM]odel,[cC]ontroller}*.ts]], 95)
  glob_it([[extensions/**/{browser,common,node}/{**/*[sS]ervice*,**/*[pP]rovider*}.ts]], 3)
end

test_bench()