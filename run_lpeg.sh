json_files=("data/canada.json" "data/canada.json" "data/twitter.json" "data/twitterescaped.json" "data/marine_ik.json")

# 运行性能测试
for json_file in "${json_files[@]}"; do
    echo "---"
    echo "Testing with $json_file"
    luajit lpeg_fullopt.lua $json_file
    luajit lpeg_nomtab.lua $json_file
    luajit lpeg_nosubst.lua $json_file
    luajit lpeg_noopt.lua $json_file
    echo ""
done
