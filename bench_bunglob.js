import { Glob } from "bun";

function assertMatch(expected, pattern, str) {
  let glob;
  try {
    glob = new Glob(pattern);
  } catch (error) {
    console.log(`  Invalid glob pattern '${pattern}' matching '${str}'`);
    return false;
  }

  const result = glob.match(str);
  if (result !== expected) {
    console.log(`  Assertion failed for pattern '${pattern}' matching '${str}': expected ${expected}, got ${result}`);
    return false;
  }
  return true;
}

async function benchGlob(expected, pattern, str) {
  if (assertMatch(expected, pattern, str)) {
    const iterations = 1;
    const startTime = performance.now();
    
    const glob = new Glob(pattern);
    for (let i = 0; i < iterations; i++) {
      glob.match(str);
    }
    
    const averageTime = (performance.now() - startTime) / iterations;
    if (averageTime > 2000) return;
    console.log(`${pattern} time: ${averageTime.toFixed(4)} ms`);
  }
}

// Generate test patterns exactly matching call_bench.lua
async function runBenchmarks() {
  // Test 1: Repeated "a*" followed by b
  for (let i = 1; i <= 20; i++) {
    const pattern = ('a*').repeat(i) + 'b';  // Creates patterns like "a*a*a*b"
    await benchGlob(true, pattern, 'a'.repeat(99) + 'b');
  }
  
  for (let i = 1; i <= 20; i++) {
    const pattern = ('a*').repeat(i) + 'b';
    await benchGlob(false, pattern, 'a'.repeat(100));  // No 'b' at end
  }

  // Test 2: Repeated "a/**/" followed by b
  for (let i = 1; i <= 20; i++) {
    const pattern = ('a/**/').repeat(i) + 'b';  // Creates patterns like "a/**/a/**/b"
    await benchGlob(true, pattern, ('a/').repeat(99) + 'b');
  }

  for (let i = 1; i <= 20; i++) {
    const pattern = ('a/**/').repeat(i) + 'b';
    await benchGlob(false, pattern, ('a/').repeat(99) + 'a');
  }

  // Test 3: Repeated "a/c/**/" followed by b
  for (let i = 1; i <= 20; i++) {
    const pattern = ('a/c/**/').repeat(i) + 'b';
    await benchGlob(true, pattern, ('a/c/').repeat(i) + 'b');
  }

  for (let i = 1; i <= 20; i++) {
    const pattern = ('a/c/**/').repeat(i) + 'b';
    await benchGlob(false, pattern, ('a/c/').repeat(i) + 'd');
  }

  // Test 4: Repeated "a*{c," with closing braces
  for (let i = 1; i <= 10; i++) {
    const pattern = ('a*{c,').repeat(i) + 'b' + '}'.repeat(i);
    await benchGlob(true, pattern, 'a'.repeat(99) + 'b');
  }

  for (let i = 1; i <= 10; i++) {
    const pattern = ('a*{c,').repeat(i) + 'b' + '}'.repeat(i);
    await benchGlob(false, pattern, 'a'.repeat(100));
  }

  // Test 5: Complex patterns with braces and **
  for (let i = 1; i <= 10; i++) {
    const pattern = ('a*{b,c}*/**/').repeat(i) + 'abcd';
    await benchGlob(true, pattern, ('axcd/').repeat(50) + 'abcd');
  }

  for (let i = 1; i <= 10; i++) {
    const pattern = ('a*{b,c}*/**/').repeat(i) + 'abcd';
    await benchGlob(false, pattern, ('axcd/').repeat(50) + 'axcd');
  }
}

runBenchmarks();