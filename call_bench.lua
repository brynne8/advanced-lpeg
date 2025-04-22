local function bench(expected, pattern, str)
  os.execute(([[luajit bench_peglob.lua %s %s %s]]):format(expected, pattern, str))
end

for i=1, 20 do
  bench(true, ('a*'):rep(i) .. 'b', ('a'):rep(99) .. 'b')
end

for i=1, 20 do
  bench(false, ('a*'):rep(i) .. 'b', ('a'):rep(100))
end

for i=1, 20 do
  bench(true, ('a/**/'):rep(i) .. 'b', ('a/'):rep(99) .. 'b')
end

for i=1, 20 do
  bench(false, ('a/**/'):rep(i) .. 'b', ('a/'):rep(99) .. 'a')
end

for i=1, 20 do
  bench(true, ('a/c/**/'):rep(i) .. 'b', ('a/c/'):rep(i) .. 'b')
end

for i=1, 20 do
  bench(false, ('a/c/**/'):rep(i) .. 'b', ('a/c/'):rep(i) .. 'd')
end

for i=1, 20 do
  bench(true, ('a*{c,'):rep(i) .. 'b' .. ('}'):rep(i), ('a'):rep(99) .. 'b')
end

for i=1, 20 do
  bench(false, ('a*{c,'):rep(i) .. 'b' .. ('}'):rep(i), ('a'):rep(100))
end

for i=1, 20 do
  bench(true, ('a*{b,c}*/**/'):rep(i) .. 'abcd', ('axcd/'):rep(50) .. 'abcd')
end

for i=1, 20 do
  bench(false, ('a*{b,c}*/**/'):rep(i) .. 'abcd', ('axcd/'):rep(50) .. 'axcd')
end