import { Glob } from "bun";
import fs from 'fs';

const iterations = 100;
const lines = fs.readFileSync('glob-real/filelist.txt', 'utf-8').split('\n');

function benchGlob(pattern, expectedCount) {
  const glob = new Glob(pattern);
  const start_time = performance.now();
  
  for (let i = 0; i < iterations; i++) {
    let count = 0;
    
    for (const line of lines) {
      if (glob.match(line)) {
        count++;
      }
    }
    
    if (count !== expectedCount) {
      console.log(`${pattern} (${count} matched), expected ${expectedCount}`);
      return;
    }
  }

  const elapsed_time = (performance.now() - start_time) / iterations;
  console.log(`${pattern} time: ${(elapsed_time).toFixed(2)} ms`);
}

function testBench() {
  benchGlob("{src,extensions}/**/test/**/{fixtures,browser,common}/**/*.{ts,js}", 726);
  benchGlob("{extensions,src}/**/{media,images,icons}/**/*.{svg,png,gif,jpg}", 119);
  benchGlob("{.github,build,test}/**/{workflows,azure-pipelines,integration,smoke}/**/*.{yml,yaml,json}", 53);
  benchGlob("src/vs/{base,editor,platform,workbench}/test/{browser,common,node}/**/[a-z]*[tT]est.ts", 224);
  benchGlob("src/vs/workbench/{contrib,services}/**/*{Editor,Workspace,Terminal}*.ts", 155);
  benchGlob("{extensions,src}/**/{markdown,json,javascript,typescript}/**/*.{ts,json}", 19);
  benchGlob("**/{electron-sandbox,electron-main,browser,node}/**/{*[sS]ervice*,*[cC]ontroller*}.ts", 419);
  benchGlob("{src,extensions}/**/{common,browser,electron-sandbox}/**/*{[cC]ontribution,[sS]ervice}.ts", 586);
  benchGlob("src/vs/{base,platform,workbench}/**/{test,browser}/**/*{[mM]odel,[cC]ontroller}*.ts", 95);
  benchGlob("extensions/**/{browser,common,node}/{**/*[sS]ervice*,**/*[pP]rovider*}.ts", 3);
}

testBench();