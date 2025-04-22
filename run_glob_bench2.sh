echo "Peglob"
luajit call_bench.lua
echo "---"

# echo "Peglob (unoptimized)"
# luajit call_bench_noopt.lua
# echo "---"

echo "Bun.Glob"
./bun bench_bunglob.js
echo "---"

echo "Minimatch"
./bun bench_minimatch.js
echo "---"
