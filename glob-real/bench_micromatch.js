const fs = require('fs');
const mm = require('micromatch');

const lines = [];
const iterations = 100;

fs.readFileSync('glob-real/filelist.txt', 'utf-8').split('\n').forEach(line => {
  lines.push(line);
});

const benchGlob = (pattern, expectedCount) => {
  const startTime = Date.now();
  const glob = mm.matcher(pattern);
  
  for (let i = 0; i < iterations; i++) {
    let count = 0;
    lines.forEach(line => {
      if (glob(line)) {
        count++;
      }
    });
    
    if (count !== expectedCount) {
      console.log(`${pattern} (${count} matched), expected ${expectedCount}`);
      return;
    }
  }

  const timeElapsed = (Date.now() - startTime) / iterations;
  console.log(`${pattern} time: ${timeElapsed.toFixed(2)} ms`);
};

const testBench = () => {
  benchGlob('{src,extensions}/**/test/**/{fixtures,browser,common}/**/*.{ts,js}', 726);
  benchGlob('{extensions,src}/**/{media,images,icons}/**/*.{svg,png,gif,jpg}', 119);
  benchGlob('{.github,build,test}/**/{workflows,azure-pipelines,integration,smoke}/**/*.{yml,yaml,json}', 53);
  benchGlob('src/vs/{base,editor,platform,workbench}/test/{browser,common,node}/**/[a-z]*[tT]est.ts', 224);
  benchGlob('src/vs/workbench/{contrib,services}/**/*{Editor,Workspace,Terminal}*.ts', 155);
  benchGlob('{extensions,src}/**/{markdown,json,javascript,typescript}/**/*.{ts,json}', 19);
  benchGlob('**/{electron-sandbox,electron-main,browser,node}/**/{*[sS]ervice*,*[cC]ontroller*}.ts', 419);
  benchGlob('{src,extensions}/**/{common,browser,electron-sandbox}/**/*{[cC]ontribution,[sS]ervice}.ts', 586);
  benchGlob('src/vs/{base,platform,workbench}/**/{test,browser}/**/*{[mM]odel,[cC]ontroller}*.ts', 95);
  benchGlob('extensions/**/{browser,common,node}/{**/*[sS]ervice*,**/*[pP]rovider*}.ts', 3);
};

testBench();
