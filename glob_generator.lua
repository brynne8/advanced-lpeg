local inspect = require('inspect')
local letters = "abcdefghijklmnopqrstuvwxyz_."

math.randomseed(os.time())

local function multiply(a, b)
    local res = {}
    for _, x in ipairs(a) do
        for _, y in ipairs(b) do
            table.insert(res, x .. y)
        end
    end
    return res
end

local function gen_letter(s, e)
    local index = math.random(s, e)
    return letters:sub(index, index)
end

-- Generate a random word of given length range
local function gen_word(min_len, max_len)
    local word_length = math.random(min_len or 1, max_len or 3)
    local word = ""
    for j = 1, word_length do
        word = word .. gen_letter(1, 28)
    end
    return word
end

local function gen_simple()
    local index = math.random(1, 3)
    if index == 1 then
        -- ques
        return { '?', { gen_letter(1, 28), gen_letter(1, 28) } }
    elseif index == 2 then
        -- class
        local ids = { math.random(1, 28), math.random(1, 28) }
        table.sort(ids)
        return { '[' .. letters:sub(ids[1], ids[1]) .. '-' .. letters:sub(ids[2], ids[2]) .. ']',
            { gen_letter(ids[1], ids[2]), gen_letter(ids[1], ids[2]) } }
    elseif index == 3 then
        -- literal
        local letter = gen_letter(1, 28)
        return { letter, { letter } }
    end
end

local function gen_star()
    local res = {}
    for i = 1, 3 do
        table.insert(res, gen_word(0, 4))
    end
    return { '*', res }
end

-- Generate test cases for brace expansion {a,b,c}
local function gen_brace()
    local count = math.random(2, 3)  -- Number of items in braces
    local pattern_parts = {}
    local matches = {}
    
    -- Generate random length words for each brace option
    for i = 1, count do
        local word = gen_word()  -- Using default 1-3 length
        table.insert(pattern_parts, word)
        table.insert(matches, word)
    end
    
    -- Combine into brace pattern
    local pattern = "{" .. table.concat(pattern_parts, ",") .. "}"
    return {pattern, matches}
end

-- Generate a single segment of a glob pattern
local function gen_seg()
    local generators = {gen_simple, gen_star, gen_brace}
    local num_parts = math.random(3, 5)
    local last_generator_index = 0
    local pattern_parts = {}
    local current_matches = {""}
    
    for i = 1, num_parts do
        -- Get available generators (excluding the last used one)
        local available_generators = {}
        for j = 1, #generators do
            if j ~= last_generator_index then
                table.insert(available_generators, j)
            end
        end
        
        -- Select a random generator from available ones
        local generator_index = available_generators[math.random(1, #available_generators)]
        last_generator_index = generator_index
        
        -- Generate pattern and matches
        local pattern, matches = table.unpack(generators[generator_index]())
        
        -- Add to pattern parts
        table.insert(pattern_parts, pattern)
        
        -- Update matches
        current_matches = multiply(current_matches, matches)
    end
    
    -- Combine pattern parts
    local full_pattern = table.concat(pattern_parts)
    
    return {full_pattern, current_matches}
end

print(inspect(gen_seg()))