echo "Peglob"
luajit glob-real/bench_peglob.lua
echo "---"

# echo "Peglob (unoptimized)"
# luajit glob-real/bench_peglob_noopt.lua
# echo "---"

echo "Bun.Glob"
./bun glob-real/bench_bunglob.js
echo "---"

echo "Minimatch"
./bun glob-real/bench_minimatch.js
echo "---"

echo "lua-glob"
luajit glob-real/bench_luaglob.lua
echo "---"

echo "NeoVim Glob"
luajit glob-real/bench_vimglob.lua
echo "---"
