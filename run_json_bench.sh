json_files=(
    "data/apache_builds.json" 
    "data/github_events.json" 
    "data/marine_ik.json" 
    "data/numbers.json" 
    "data/twitterescaped.json"
    "data/canada.json" 
    "data/gsoc-2018.json" 
    "data/mesh.json" 
    "data/random.json" 
    "data/update-center.json"
    "data/citm_catalog.json" 
    "data/instruments.json" 
    "data/mesh.pretty.json" 
    "data/twitter.json"
)

# 运行性能测试
for json_file in "${json_files[@]}"; do
    echo "---"
    echo "Testing with $json_file"
    luajit lpeg_parser.lua $json_file
    luajit rxi_parser.lua $json_file
    luajit dkjson_parser.lua $json_file
    luajit cjson_parser.lua $json_file
    echo ""
done
