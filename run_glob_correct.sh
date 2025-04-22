echo "Peglob"
luajit testpeglob.lua
echo "---"

echo "NeoVim glob"
luajit testvimglob.lua
echo "---"

echo "lua-glob"
luajit testluaglob.lua
echo "---"

echo "lua-glob-pattern"
luajit testluaglobpattern.lua